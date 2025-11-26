# --- Setup: Load packages and activate environment ---
Pkg.activate(".")

using Revise
using apRQA
using Test
using Random
using DelimitedFiles
using DelayEmbeddings
using RecurrenceAnalysis

#Pkg.test()

# --- Load data ---
const x_ = readdlm(joinpath(@__DIR__, "data", "roessler.csv"));
x = x_[1:10000];

# --- RQA parameters ---
const ε = 0.5;    # Recurrence threshold
const minℓ = 2;   # Minimal line length

# --- Reference calculation (DynamicalSystems.jl) ---
println("--- Reference (DynamicalSystems.jl) ---")

const m = 1;
const τ = 1;

# Warmup run (to avoid benchmarking overhead)
xe = DelayEmbeddings.embed(x[:], m, τ);
R = RecurrenceMatrix(xe, sqrt(m) * ε, parallel=false);
rqa(R, theiler=1, onlydiagonal=false, parallel=false);

# Time and compute reference RQA
t_ds = @elapsed begin
    xe = DelayEmbeddings.embed(x[:], m, τ);
    R = RecurrenceMatrix(xe, sqrt(m) * ε, parallel=false);
    Q = rqa(R, theiler=1, onlydiagonal=false, parallel=false);
end

# Print reference results
print("RR:   $(round(Q[:RR], digits=3))\n" *
      "DET:  $(round(Q[:DET], digits=3))\n" *
      "L:    $(round(Q[:L], digits=3))\n" *
      "LAM:  $(round(Q[:LAM], digits=3))\n" *
      "Time: $(round(t_ds, digits=2)) sec\n")

# --- Approximation (apRQA) ---
println("--- Approximation (apRQA) ---")

# Warmup run (to avoid benchmarking overhead)
approximate_rqa(x, ε, minℓ);

# Time and compute approximate RQA
t_aprqa = @elapsed begin
    RR, DET, L, LAM = approximate_rqa(x, ε, minℓ);
end

# Print approximation results
print("--- Approximation (apRQA) ---\n" *
      "RR:   $(round(RR, digits=3))\n" *
      "DET:  $(round(DET, digits=3))\n" *
      "L:    $(round(L, digits=3))\n" *
      "LAM:  $(round(LAM, digits=3))\n" *
      "Time: $(round(t_aprqa, digits=4)) sec\n\n" *

      "--- Differences (apRQA - DynamicalSystems) ---\n" *
      "ΔRR:  $(round(RR - Q[:RR], digits=3))\n" *
      "ΔDET: $(round(DET - Q[:DET], digits=3))\n" *
      "ΔL:   $(round(L - Q[:L], digits=3))\n" *
      "ΔLAM: $(round(LAM - Q[:LAM], digits=3))\n" *
      "Speedup: $(round(t_ds / t_aprqa, digits=2))x\n")
