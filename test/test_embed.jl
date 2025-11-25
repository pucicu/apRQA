@testset "Embedding Tests" begin
    using DelimitedFiles

    @testset "Basic 1D embedding" begin
        x = collect(1.0:10.0)
        xe = embed(x, 3, 1)
        
        @test size(xe) == (8, 3)
        @test xe[1, :] == [1.0, 2.0, 3.0]
        @test xe[end, :] == [8.0, 9.0, 10.0]
    end
    
    @testset "Different tau" begin
        x = collect(1.0:10.0)
        xe2 = embed(x, 2, 2)
        @test size(xe2) == (8, 2)
        @test xe2[1, :] == [1.0, 3.0]
        @test xe2[end, :] == [8.0, 10.0]
    end
    
    @testset "Different data types" begin
        # Float64 (default)
        x_f64 = rand(Float64, 100)
        xe_f64 = embed(x_f64, 3, 2)
        @test eltype(xe_f64) == Float64
        @test size(xe_f64) == (96, 3)
        
        # Float32
        x_f32 = rand(Float32, 100)
        xe_f32 = embed(x_f32, 3, 2)
        @test eltype(xe_f32) == Float64  # zeros() creates Float64
        @test size(xe_f32) == (96, 3)
        
        # Int
        x_int = collect(1:100)
        xe_int = embed(x_int, 3, 2)
        @test eltype(xe_int) == Float64  # zeros() creates Float64
        @test size(xe_int) == (96, 3)
        
        # Range
        x_range = 1.0:0.1:10.0
        xe_range = embed(x_range, 3, 2)
        @test size(xe_range) == (87, 3)
    end
    
    @testset "Matrix input types" begin
        # Float64 matrix
        x_matrix = rand(Float64, 100, 2)
        xe = embed(x_matrix, 3, 2)
        @test eltype(xe) == Float64
        @test size(xe) == (96, 6)
        
        # Float32 matrix
        x_matrix_f32 = rand(Float32, 100, 2)
        xe_f32 = embed(x_matrix_f32, 3, 2)
        @test size(xe_f32) == (96, 6)
    end
    
    @testset "Edge cases" begin
        x = collect(1.0:5.0)
        
        # m=1 should return original data as matrix
        xe = embed(x, 1, 1)
        @test size(xe) == (5, 1)
        @test vec(xe) == x
        
        # Large tau
        xe = embed(x, 2, 3)
        @test size(xe) == (2, 2)
        @test xe[1, :] == [1.0, 4.0]
        
        # Minimum length
        x_min = [1.0, 2.0, 3.0]
        xe_min = embed(x_min, 2, 1)
        @test size(xe_min) == (2, 2)
    end
    
    @testset "Matrix embedding dimensions" begin
        x_matrix = rand(100, 3)  # 3-dimensional time series
        xe = embed(x_matrix, 2, 1)
        
        @test size(xe, 1) == 100 - (2-1)*1  # 99
        @test size(xe, 2) == 3 * 2          # 6
        
        # Check column ordering
        @test xe[:, 1:3] == x_matrix[1:99, :]
        @test xe[:, 4:6] == x_matrix[2:100, :]
    end
    
    @testset "Validation against reference data" begin
        data_dir = joinpath(@__DIR__, "data")
        
        required_files = [
             "discretized_e05_expected.csv",
             "embed_m2_tau1_expected.csv",
             "embed_m3_tau1_expected.csv"
        ]
    
        # file check
        all_files_exist = all(isfile(joinpath(data_dir, f)) for f in required_files)
        
        if all_files_exist
            x = readdlm(joinpath(data_dir, "discretized_e05_expected.csv"))
            x1_ref = readdlm(joinpath(data_dir, "embed_m2_tau1_expected.csv"))
            x2_ref = readdlm(joinpath(data_dir, "embed_m3_tau1_expected.csv"))

            x1 = embed(x, 2, 1)
            x2 = embed(x, 3, 1)

            @test x1 ≈ x1_ref atol=1e-6
            @test x2 ≈ x2_ref atol=1e-6
        else
            missing = [f for f in required_files if !isfile(joinpath(data_dir, f))]
            @info "Skipping validation tests - missing files: $(join(missing, ", "))"
            @test true
        end
    end
end
