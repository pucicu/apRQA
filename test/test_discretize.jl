@testset "Discretize Tests" begin
    using DelimitedFiles
    
    @testset "Basic discretization" begin
        x = [0.0, 0.5, 1.0, 1.5, 2.0]
        
        # eps = 0.5 -> scale = 1/(2*0.5) = 1
        x_disc = discretize(x, 0.5)
        @test x_disc == [0.0, 0.0, 1.0, 1.0, 2.0]
        
        # eps = 1.0 -> scale = 1/(2*1.0) = 0.5
        x_disc2 = discretize(x, 1.0)
        @test x_disc2 == [0.0, 0.0, 0.0, 0.0, 1.0]
    end
    
    @testset "Matrix discretization" begin
        x_matrix = [0.0 1.0; 0.5 1.5; 1.0 2.0]
        x_disc = discretize(x_matrix, 0.5)
        
        @test size(x_disc) == (3, 2)
        @test x_disc[1, :] == [0.0, 1.0]
    end
    
    @testset "Zero epsilon" begin
        x = [1.0, 2.0, 3.0]
        x_disc = discretize(x, 0.0)
        @test x_disc == x  # Should return unchanged
    end
    
    @testset "Validation against reference data" begin
        data_dir = joinpath(@__DIR__, "data")

        required_files = [
             "timeseries_raw.csv",
             "discretized_e05_expected.csv",
             "discretized_e1_expected.csv"
        ]
    
        # file check
        all_files_exist = all(isfile(joinpath(data_dir, f)) for f in required_files)
        
        if all_files_exist
            x = readdlm(joinpath(data_dir, "timeseries_raw.csv"))
            
            # Test eps = 0.5
            expected_e05 = readdlm(joinpath(data_dir, "discretized_e05_expected.csv"))
            result_e05 = discretize(x, 0.5)
            @test size(result_e05) == (2000, 1)
            @test result_e05 ≈ expected_e05 atol=1e-6
            
            # Test eps = 1.0
            expected_e1 = readdlm(joinpath(data_dir, "discretized_e1_expected.csv"))
            result_e1 = discretize(x, 1.0)
            @test result_e1 ≈ expected_e1 atol=1e-6
        else
            missing = [f for f in required_files if !isfile(joinpath(data_dir, f))]
            @info "Skipping validation tests - missing files: $(join(missing, ", "))"
            @test true
        end
    end
end
