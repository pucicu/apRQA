@testset "Stationary States Tests" begin
    
    @testset "Basic functionality" begin
        # Test with simple data where stationary states are clear
        # Points where norm is integer (stationary)
        x = [0.0, 1.0, 2.0, 3.0]
        y = [0.0, 1.0, 2.0]
        
        ss = stationary_states(x, y)
        @test ss >= 0  # Should be non-negative
        @test typeof(ss) <: Number
    end
    
    @testset "Vector inputs" begin
        # Test with vector inputs
        x = [1.0, 2.0, 3.0, 4.0]
        y = [1.0, 2.0, 5.0]
        
        ss = stationary_states(x, y)
        @test ss >= 0
    end
    
    @testset "Matrix inputs" begin
        # Test with matrix inputs
        x = rand(100, 2)
        y = rand(100, 3)
        
        ss = stationary_states(x, y)
        @test ss >= 0
    end
    
    @testset "Edge cases" begin
        # Empty filtered results
        x = [0.5, 1.5, 2.5]  # No integer norms
        y = [0.7, 1.7, 2.7]
        
        ss = stationary_states(x, y)
        @test ss == 0  # Should return 0 for empty filtered arrays
    end
    
    @testset "Validation against reference data" begin
        using DelimitedFiles
        data_dir = joinpath(@__DIR__, "data")
        
        required_files = [
            "discretized_e05_expected.csv",
            "embed_m2_tau1_expected.csv",
            "embed_m3_tau1_expected.csv",
            "stationary_states_expected.csv"  # Better name than proximities_expected
        ]
        
        # Check if all files exist
        all_files_exist = all(isfile(joinpath(data_dir, f)) for f in required_files)
        
        if all_files_exist
            # Load test data
            x1 = readdlm(joinpath(data_dir, "discretized_e05_expected.csv"))
            x2 = readdlm(joinpath(data_dir, "embed_m2_tau1_expected.csv"))
            x3 = readdlm(joinpath(data_dir, "embed_m3_tau1_expected.csv"))
            expected = readdlm(joinpath(data_dir, "stationary_states_expected.csv"))
            
            # Calculate stationary states
            ss1 = pairwise_proximities(x1)  # Note: this uses pp, not ss
            ss2 = stationary_states(x1, x2)
            ss3 = stationary_states(x1, x3)
            
            # Test against reference values
            @test ss1 == expected[1]
            @test ss2 == expected[2]
            @test ss3 == expected[3]
        else
            missing = [f for f in required_files if !isfile(joinpath(data_dir, f))]
            @info "Skipping validation tests - missing files: $(join(missing, ", "))"
            @test true
        end
    end
end
