using PlateKinematics: CovIsZero
using PlateKinematics: FiniteRotSph, FiniteRotCart, FiniteRotMatrix
using PlateKinematics.FiniteRotationsTransformations: Finrot2Cart, Finrot2Sph, Finrot2Matrix
using PlateKinematics: BuildEnsemble3D, Ensemble2Vector


function Add_FiniteRotations(FRm1::FiniteRotMatrix, FRm2::FiniteRotMatrix)

    # Spherical vector in [degrees], covariace in [degrees^2]
    FRs = Finrot2Sph(FiniteRotMatrix(FRm2.Values * FRm1.Values))

    return FRs
end


"""
Add two finite rotations in cartesian coordinates [degrees]
and outputs a finite rotation in cartesian coordinates [degrees].
If finite rotations with covariace are given, covariance in [degrees^2]"""
function Add_FiniteRotations(FRs1::FiniteRotSph, FRs2::FiniteRotSph, Nsize = 1e5)
    
    # If a covariance is found, build ensemble
    if !CovIsZero(FRs1.Covariance) || !CovIsZero(FRs2.Covariance)
        FRs1_ = BuildEnsemble3D(FRs1, Nsize)
        FRs2_ = BuildEnsemble3D(FRs2, Nsize)
        
    else
        FRs1_ = [FRs1]
        FRs2_ = [FRs2]
    end 

    # Output ensemble in cartesian coordinates [degrees]
    Nsize = length(FRs1_)
    FRs = Array{FiniteRotSph}(undef, Nsize)

    for i in 1:Nsize
        
        FRm1 = Finrot2Matrix(FRs1_[i])
        FRm2 = Finrot2Matrix(FRs2_[i])

        # Cartesian vector in [degrees], covariace in [degrees^2]
        FRs[i] = Add_FiniteRotations(FRm1, FRm2)
    end

    if Nsize == 1
        FRs = FRs[1]
    end

    return FRs
end


function Add_FiniteRotations(FRc1::FiniteRotCart, FRc2::FiniteRotCart, Nsize = 1e5)

    # Cartesian vector in [degrees], covariace in [degrees^2]
    FRs = Add_FiniteRotations(Finrot2Sph(FRc1), Finrot2Sph(FRc2), Nsize)
    
    if typeof(FRs) == FiniteRotSph
        # Spherical vector in [degrees], covariace in [degrees^2]
        FRc = Finrot2Cart(FRs)
    else
        # Array of spherical vectors in [degrees], covariaces in [degrees^2]
        FRc = [Finrot2Cart(FRs_) for FRs_ in FRs]
    end

    return FRc
end