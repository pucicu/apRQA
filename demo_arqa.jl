# Load your package in development mode
using Pkg
Pkg.activate(".")

using aRQA
using Random
using DelayEmbeddings
using RecurrenceAnalysis

# Data
Random.seed!(42)
x = rand(2000)
x = [9; 3; 8; 1; 9; 7; 3; 2; 9; 4; 8]

# RQA parameters
eps = 0.5; # recurrence threshold
m = 2;     # embedding dimension
tau = 1;   # embedding delay
minL = 2;  # minimal line length

# Embedding
x_embedded = aRQA.embed((x), m, tau);

# Approximation
R = approximate_rqa(x_embedded, eps, minL) # warmup run
t = @elapsed begin
    RR, DET, L, LAM = approximate_rqa(x_embedded, eps, minL)
end

# Results
println("RR:   $(round(RR, digits=4))")
println("DET:  $(round(DET, digits=4))")
println("L:    $(round(L, digits=4))")
println("LAM:  $(round(LAM, digits=4))")
println("Time: $(round(t, digits=2)) (sec)\n")







println("--- DynamicalSystems ---")
xe = DelayEmbeddings.embed(x, m, tau)
R = RecurrenceMatrix(xe, eps, parallel=false);
Q = rqa(R, theiler=1, onlydiagonal=false, parallel=false)
t_ds = @elapsed begin
    xe = DelayEmbeddings.embed(x, m, tau)
    R = RecurrenceMatrix(xe, eps, parallel=false);
    Q = rqa(R, theiler=1, onlydiagonal=false, parallel=false)
end

println("RR:   $(round(Q[:RR], digits=4))")
println("DET:  $(round(Q[:DET], digits=4))")
println("L:    $(round(Q[:L], digits=4))") 
println("LAM:  $(round(Q[:LAM], digits=4))")
println("Time: $(round(t_ds, digits=2)) sec\n")

# Differences
println("--- Differences (aRQA - DynamicalSystems) ---")
println("ΔRR:  $(round(RR - Q[:RR], digits=6))")
println("ΔDET: $(round(DET - Q[:DET], digits=6))")
println("ΔL:   $(round(L - Q[:L], digits=6))")
println("ΔLAM: $(round(LAM - Q[:LAM], digits=6))")
println("Speedup: $(round(t_ds/t, digits=2))x")
