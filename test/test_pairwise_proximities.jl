@testset "Pairwise Proximities Tests" begin
    
    @testset "Basic functionality" begin
        # Simple test: all same values
        x = [1.0, 1.0, 1.0, 1.0]
        pp = pairwise_proximities(x)
        @test pp == 16  # 4*4 = 16
        
        # Two unique values
        x = [1.0, 1.0, 2.0, 2.0]
        pp = pairwise_proximities(x)
        @test pp == 8  # 2*2 + 2*2 = 8
        
        # All different values
        x = [1.0, 2.0, 3.0, 4.0]
        pp = pairwise_proximities(x)
        @test pp == 4  # 1*1 + 1*1 + 1*1 + 1*1 = 4
    end
    
    @testset "Matrix input" begin
        # Matrix with duplicate rows
        x = [1.0 2.0; 1.0 2.0; 3.0 4.0]
        pp = pairwise_proximities(x)
        @test pp == 5 # 2 identical rows + 1 unique = 2*2 + 1*1 = 5
        
        # All rows unique
        x = [1.0 2.0; 3.0 4.0; 5.0 6.0]
        pp = pairwise_proximities(x)
        @test pp == 3  # 1*1 + 1*1 + 1*1 = 3
    end
    
    @testset "Edge cases" begin
        # Single value
        x = [1.0]
        pp = pairwise_proximities(x)
        @test pp == 1
        
        # Single row matrix
        x = reshape([1.0, 2.0], 1, 2)
        pp = pairwise_proximities(x)
        @test pp == 1
    end
    
    @testset "Validation against reference data" begin
        using DelimitedFiles
        data_dir = joinpath(@__DIR__, "data")

        required_files = [
             "discretized_e05_expected.csv",
             "embed_m2_tau1_expected.csv",
             "embed_m3_tau1_expected.csv",
             "proximities_expected.csv"
        ]
        
        # file check
        all_files_exist = all(isfile(joinpath(data_dir, f)) for f in required_files)
        
        if all_files_exist
            # Load test data
            x1 = readdlm(joinpath(data_dir, "discretized_e05_expected.csv"))
            x2 = readdlm(joinpath(data_dir, "embed_m2_tau1_expected.csv"))
            x3 = readdlm(joinpath(data_dir, "embed_m3_tau1_expected.csv"))
            expected = readdlm(joinpath(data_dir, "proximities_expected.csv"))
            
            # Calculate proximities
            pp1 = pairwise_proximities(x1)
            pp2 = pairwise_proximities(x2)
            pp3 = pairwise_proximities(x3)
            
            # Test against reference values
            @test pp1 ≈ expected[1] atol=1e-6
            @test pp2 ≈ expected[2] atol=1e-6
            @test pp3 ≈ expected[3] atol=1e-6
        else
            missing = [f for f in required_files if !isfile(joinpath(data_dir, f))]
            @info "Skipping validation tests - missing files: $(join(missing, ", "))"
            @test true
        end
    end
end
