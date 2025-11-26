@testset "Approximate RQA Tests" begin
    
    @testset "Basic functionality" begin
        using Random
        Random.seed!(123)
        
        # Create simple embedded time series
        x = rand(1000, 5)
        ε = 0.1
        minL = 2
        
        # Run apRQA
        result = approximate_rqa(x, ε, minL)
        

        # Check output structure
        @test result isa NamedTuple
        @test haskey(result, :RR)
        @test haskey(result, :DET)
        @test haskey(result, :L)
        @test haskey(result, :LAM)
        
        # Check all values are non-negative
        @test all(>=(0), values(result))  # All values should be non-negative
        
        # Check individual measures
        RR, DET, L, LAM = result
        @test 0 <= RR <= 1  # RR should be between 0 and 1
        @test 0 <= DET <= 1  # DET should be between 0 and 1
        @test L >= minL     # Average line length should be >= minL
        @test 0 <= LAM <= 1  # LAM should be between 0 and 1
    end
    
    @testset "Different parameters" begin
        using Random
        Random.seed!(456)
        
        x = rand(500, 3)
        
        # Test with different epsilon values
        result1 = approximate_rqa(x, 0.05, 2)
        result2 = approximate_rqa(x, 0.2, 2)
        
        @test length(result1) == 4
        @test length(result2) == 4
        
        # Larger epsilon should generally give higher RR and LAM
        @test result2[:RR] >= result1[:RR]  # RR increases with epsilon
        @test result2[:LAM] >= result1[:LAM]  # LAM increases with epsilon
    end
    
    @testset "Different minL values" begin
        using Random
        Random.seed!(789)
        
        x = rand(500, 3)
        ε = 0.1
        
        # Test with different minL values
        result_minL2 = approximate_rqa(x, ε, 2)
        result_minL3 = approximate_rqa(x, ε, 3)
        
        @test length(result_minL2) == 4
        @test length(result_minL3) == 4
        
        # L should be >= minL
        @test result_minL2[:L] >= 2
        @test result_minL3[:L] >= 3
    end
    
    @testset "Edge cases" begin
        # Small dataset
        x = rand(50, 2)
        result = approximate_rqa(x, 0.1, 2)
        @test length(result) == 4
        @test all(!isnan, values(result))  # No NaN values
        
        # Large epsilon (high recurrence)
        x = rand(100, 2)
        result = approximate_rqa(x, 1.0, 2)
        @test result[:RR] > 0  # RR should be positive
    end
    
    @testset "Validation against reference data" begin
        using DelimitedFiles
        data_dir = joinpath(@__DIR__, "data")
        
        required_files = [
            "timeseries_raw.csv",
            "rqa_expected.csv"
        ]
        
        # Check if all files exist
        all_files_exist = all(isfile(joinpath(data_dir, f)) for f in required_files)
        
        if all_files_exist
            # Load reference data
            x = readdlm(joinpath(data_dir, "timeseries_raw.csv"))
            expected = readdlm(joinpath(data_dir, "rqa_expected.csv"))
            
            result = approximate_rqa(x, 0.5, 2)
            
            # Test against reference values
            @test result[:RR] ≈ expected[1] atol=1e-5
            @test result[:DET] ≈ expected[2] atol=1e-5
            @test result[:L] ≈ expected[3] atol=1e-5
            @test result[:LAM] ≈ expected[4] atol=1e-5
        else
            missing = [f for f in required_files if !isfile(joinpath(data_dir, f))]
            @info "Skipping validation tests - missing files: $(join(missing, ", "))"
            @test true
        end
    end
end
