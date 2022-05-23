@testset "Document" begin
    @testset "count unicode literals in bytes" begin
        s = """
        \"""
        𝔽𝔽

        \"""
        struct A end
        """
        d = JuliaFormatter.Document(s)
        ranges = Dict(1 => 1:4, 2 => 5:7, 3 => 8:8, 4 => 9:12, 5 => 13:25, 6 => 26:25)
        @test ranges == d.line_to_range
    end

    @testset "count unicode whitespace in bytes" begin
        s0 = """a = b || c ;
               f("A")"""
        d = JuliaFormatter.Document(s0)
        ranges = Dict(1 => 1:13, 2 => 14:19)
        @test ranges == d.line_to_range

        # this string has a nbsp after 'c'
        # so it should have an additional byte because
        # it's unicode
        s = """a = b || c ;
               f("A")"""
        d = JuliaFormatter.Document(s)
        ranges = Dict(1 => 1:14, 2 => 15:20)
        @test ranges == d.line_to_range
    end

    @testset "newline semicolons" begin
        # ENDMARKER
    @testset "ENDMARKER" begin
        str = """a = 1;"""
        d = JuliaFormatter.Document(str)
        @test (1 in d.newline_semicolons)

        str = """


        a = 1;"""
        d = JuliaFormatter.Document(str)
        @test (3 in d.newline_semicolons)
    end

    @testset "NEWLINE" begin
        str = """

        a = 1;
        """
        d = JuliaFormatter.Document(str)
        @test (2 in d.newline_semicolons)

        str = """

        a = 1; # comment
        """
        d = JuliaFormatter.Document(str)
        @test (2 in d.newline_semicolons)

        str = """

        a = 1; #= comment =#
        """
        d = JuliaFormatter.Document(str)
        @test (2 in d.newline_semicolons)

        str = """

        a = 1;# comment
        """
        d = JuliaFormatter.Document(str)
        @test (2 in d.newline_semicolons)

        str = """

        a = 1;#= comment =#
        """
        d = JuliaFormatter.Document(str)
        @test (2 in d.newline_semicolons)
    end


    end
end
