using PhaseRetrieval
using SampledDomains
using Test

@testset "utils.jl" begin
    # Write your tests here.
    q1d = PhaseRetrieval.quadratic(5)
    q2d = PhaseRetrieval.quadratic((5, 5))
    @test q1d ==
        q2d ==
        [
            8.0 5.0 4.0 5.0 8.0
            5.0 2.0 1.0 2.0 5.0
            4.0 1.0 0.0 1.0 4.0
            5.0 2.0 1.0 2.0 5.0
            8.0 5.0 4.0 5.0 8.0
        ]

    dm = PhaseRetrieval.diskmatrix(10, 0.8)
    @test dm[1] == [
        0 0 0 0 0 0 0 0 0 0
        0 0 0 0 1 1 0 0 0 0
        0 0 1 1 1 1 1 1 0 0
        0 0 1 1 1 1 1 1 0 0
        0 1 1 1 1 1 1 1 1 0
        0 1 1 1 1 1 1 1 1 0
        0 0 1 1 1 1 1 1 0 0
        0 0 1 1 1 1 1 1 0 0
        0 0 0 0 1 1 0 0 0 0
        0 0 0 0 0 0 0 0 0 0
    ]
    # @test dm[2] == [
    #     NaN  NaN  NaN  NaN  NaN  NaN  NaN  NaN  NaN  NaN
    #     NaN  NaN  NaN  NaN    1    1  NaN  NaN  NaN  NaN
    #     NaN  NaN    1    1    1    1    1    1  NaN  NaN
    #     NaN  NaN    1    1    1    1    1    1  NaN  NaN
    #     NaN    1    1    1    1    1    1    1    1  NaN
    #     NaN    1    1    1    1    1    1    1    1  NaN
    #     NaN  NaN    1    1    1    1    1    1  NaN  NaN
    #     NaN  NaN    1    1    1    1    1    1  NaN  NaN
    #     NaN  NaN  NaN  NaN    1    1  NaN  NaN  NaN  NaN
    #     NaN  NaN  NaN  NaN  NaN  NaN  NaN  NaN  NaN  NaN
    # ]

    @test PhaseRetrieval.lineararray(-1:0.5:1, -1:0.25:1, 3, 2, 1) == [
        -4.0 -2.5 -1.0 0.5 2.0
        -3.5 -2.0 -0.5 1.0 2.5
        -3.0 -1.5 0.0 1.5 3.0
        -2.5 -1.0 0.5 2.0 3.5
        -2.0 -0.5 1.0 2.5 4.0
        -1.5 0.0 1.5 3.0 4.5
        -1.0 0.5 2.0 3.5 5.0
        -0.5 1.0 2.5 4.0 5.5
        0.0 1.5 3.0 4.5 6.0
    ]

    @test PhaseRetrieval.lineararray(5, 0.5, 1, -1.5) == [
        0.0 0.5 1.0 1.5 2.0
        1.0 1.5 2.0 2.5 3.0
        2.0 2.5 3.0 3.5 4.0
        3.0 3.5 4.0 4.5 5.0
        4.0 4.5 5.0 5.5 6.0
    ]

    @test PhaseRetrieval.subdivide_sum(ones(10, 10), 5) == [
        25.0 25.0
        25.0 25.0
    ]

    a = SampledDomains.CartesianDomain2D(1:5, -2.5:0.5:2.5)
    ap = PhaseRetrieval.aperture(a, 2.5, (3, -0.1))
    b = PhaseRetrieval.phwrap.(ap[2])
    # b  == [
    #     NaN  NaN    NaN    NaN    NaN
    #     NaN  NaN    NaN    NaN    NaN
    #     NaN  NaN    NaN    NaN    NaN
    #     NaN  NaN      1.0  NaN    NaN
    #     NaN    1.0    1.0    1.0  NaN
    #     NaN    1.0    1.0    1.0  NaN
    #     NaN    1.0    1.0    1.0  NaN
    #     NaN  NaN      1.0  NaN    NaN
    #     NaN  NaN    NaN    NaN    NaN
    #     NaN  NaN    NaN    NaN    NaN
    #     NaN  NaN    NaN    NaN    NaN
    #  ]

    @test isnan.(b) == [
        1 1 1 1 1
        1 1 1 1 1
        1 1 1 1 1
        1 1 0 1 1
        1 0 0 0 1
        1 0 0 0 1
        1 0 0 0 1
        1 1 0 1 1
        1 1 1 1 1
        1 1 1 1 1
        1 1 1 1 1
    ]

    a = PhaseRetrieval.tile(reshape(1:60, (6, 10)), 2)
    @test a[:, :, 1] == [1 7; 2 8] && a[:, :, 15] == [53 59; 54 60]

    a = 1:(4 * 3 * 3 * 3)
    b = reshape(a, 4 * 3, 3 * 3)
    c = PhaseRetrieval.subdivide(b, 3)
    d = PhaseRetrieval.subdivide_sum(b, 3)

    @test c[:, :, 4] == [
        37 49 61
        38 50 62
        39 51 63
        40 52 64
    ]

    @test d == [
        369 477 585
        378 486 594
        387 495 603
        396 504 612
    ]

    ## binning: the mean of Q × Q cells; rows and columns beyond the last whole cell dropped
    A = reshape(1.0:20.0, 4, 5)
    @test PhaseRetrieval.binning(A, 2) == [3.5 11.5; 5.5 13.5]
    @test PhaseRetrieval.binning(A, 1) == A
    B = rand(7, 9)
    @test size(PhaseRetrieval.binning(B, 3)) == (2, 3)
    @test sum(PhaseRetrieval.binning(B, 3)) * 9 ≈ sum(B[1:6, 1:9])
    E = PhaseRetrieval.N0f8.(reshape(0:35, 6, 6) ./ 255)
    @test eltype(PhaseRetrieval.binning(E, 3)) == Float64
    @test PhaseRetrieval.binning(E, 3) ≈ PhaseRetrieval.binning(Float64.(E), 3)
    cam = PhaseRetrieval.binning(CameraChip((5.2e-6, 5.2e-6), (640, 481), 8, 8), 2)
    @test cam.pixelsize == (10.4e-6, 10.4e-6) && cam.imagesize == (320, 240)

end

@testset "Field.jl" begin
    d = SampledDomains.CartesianDomain2D(-5:5, -5:5)
    ap = PhaseRetrieval.aperture(d, 5)[1]
    ph = map(x -> x[1]^2 + x[2]^2, d) ./ 2
    ca = ScalarComplexAmplitude(ap, ph)

    @test PhaseRetrieval.amplitude(ca) == ap
    @test PhaseRetrieval.phase(ca) == ph

    f_scalar = SampledField(ca, ScalarPolarization(), 632.8nm, d)
    f_linear = SampledField(ca, LinearPolarization(0), 632.8nm, d)

    @test PhaseRetrieval.complex_amplitude(f_scalar) ==
        PhaseRetrieval.complex_amplitude(f_linear) ==
        ca

    m = PSFMethods.Fourier()
    @test all(
        Float32.(m(f_scalar)) .≈ [
            11.7287 0.789191 10.8746 17.5172 8.96934 4.66457 8.96934 17.5172 10.8746 0.789191 11.7287
            0.789191 0.549869 2.66057 3.20418 5.83699 9.06243 5.83699 3.20418 2.66057 0.549869 0.789191
            10.8746 2.66057 10.8499 26.4863 34.8263 37.363 34.8263 26.4863 10.8499 2.66057 10.8746
            17.5172 3.20418 26.4863 37.4116 29.9469 31.5359 29.9469 37.4116 26.4863 3.20418 17.5172
            8.96934 5.83699 34.8263 29.9469 58.0537 104.335 58.0537 29.9469 34.8263 5.83699 8.96934
            4.66457 9.06243 37.363 31.5359 104.335 189.891 104.335 31.5359 37.363 9.06243 4.66457
            8.96934 5.83699 34.8263 29.9469 58.0537 104.335 58.0537 29.9469 34.8263 5.83699 8.96934
            17.5172 3.20418 26.4863 37.4116 29.9469 31.5359 29.9469 37.4116 26.4863 3.20418 17.5172
            10.8746 2.66057 10.8499 26.4863 34.8263 37.363 34.8263 26.4863 10.8499 2.66057 10.8746
            0.789191 0.549869 2.66057 3.20418 5.83699 9.06243 5.83699 3.20418 2.66057 0.549869 0.789191
            11.7287 0.789191 10.8746 17.5172 8.96934 4.66457 8.96934 17.5172 10.8746 0.789191 11.7287
        ],
    )

end
