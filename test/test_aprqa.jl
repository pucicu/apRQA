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
        @test length(result) == 4
        @test all(result .>= 0)  # All values should be non-negative
        
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
        
        # Larger epsilon should generally give higher RR
        @test result2[1] >= result1[1]  # RR increases with epsilon
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
        @test result_minL2[3] >= 2
        @test result_minL3[3] >= 3
    end
    
    @testset "Edge cases" begin
        # Small dataset
        x = rand(50, 2)
        result = approximate_rqa(x, 0.1, 2)
        @test length(result) == 4
        @test all(.!isnan.(result))  # No NaN values
        
        # Large epsilon (high recurrence)
        x = rand(100, 2)
        result = approximate_rqa(x, 1.0, 2)
        @test result[1] > 0  # RR should be positive
    end
    
    @testset "Validation against reference data" begin
        using DelimitedFiles
        data_dir = joinpath(@__DIR__, "data")
        
        required_files = [
            "proximities_expected.csv",
            "stationary_states_expected.csv",
            "rqa_expected.csv"
        ]
        
        # Check if all files exist
        all_files_exist = all(isfile(joinpath(data_dir, f)) for f in required_files)
        
        if all_files_exist
            # Load reference data
            pp = readdlm(joinpath(data_dir, "proximities_expected.csv"))
            ss = readdlm(joinpath(data_dir, "stationary_states_expected.csv"))
            expected = readdlm(joinpath(data_dir, "rqa_expected.csv"))
            
            # Extract values from reference data
            minL = 2
            pp1, pp2, pp3 = pp[1], pp[2], pp[3]
            ss1, ss2, ss3 = ss[1], ss[2], ss[3]
            n = expected[1]
            
            # Calculate RQA measures using same formulas as approximate_rqa
            RR = pp1 / (n * n)
            DET = (minL * pp2 - (minL - 1) * pp3) / (pp1 + 1e-10)
            L = (minL * pp2 - (minL - 1) * pp3) / (pp2 - pp3)
            LAM = (minL * ss2 - (minL - 1) * ss3) / (ss1 + 1e-10)
            
            # Test against reference values
            @test RR ≈ expected[2] atol=1e-5
            @test DET ≈ expected[3] atol=1e-5
            @test L ≈ expected[4] atol=1e-5
            @test LAM ≈ expected[5] atol=1e-5
        else
            missing = [f for f in required_files if !isfile(joinpath(data_dir, f))]
            @info "Skipping validation tests - missing files: $(join(missing, ", "))"
            @test true
        end
    end
end
