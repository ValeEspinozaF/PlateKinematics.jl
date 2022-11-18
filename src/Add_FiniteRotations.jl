using PlateKinematics: CovIsZero
using PlateKinematics: FiniteRotSph, FiniteRotCart, FiniteRotMatrix
using PlateKinematics.FiniteRotationsTransformations: Finrot2Cart, Finrot2Sph, Finrot2Matrix
using PlateKinematics: BuildEnsemble3D, Ensemble2Vector


function Add_FiniteRotations(FRm1::FiniteRotMatrix, FRm2::FiniteRotMatrix)

    # Cartesian vector in [degrees], covariace in [degrees^2]
    FRc = Finrot2Cart(FiniteRotMatrix(FRm2.Values * FRm1.Values))

    return FRc
end


"""
Add two finite rotations in cartesian coordinates [degrees]
and outputs a finite rotation in cartesian coordinates [degrees].
If finite rotations with covariace are given, covariance in [degrees^2]"""
function Add_FiniteRotations(FRc1::FiniteRotCart, FRc2::FiniteRotCart, Nsize = 1e5)
    
    # If a covariance is found, build ensemble
    if !CovIsZero(FRc1.Covariance) || !CovIsZero(FRc2.Covariance)
        FRc1_ = BuildEnsemble3D(FRc1, Nsize)
        FRc2_ = BuildEnsemble3D(FRc2, Nsize)
    else
        FRc1_ = [FRc1]
        FRc2_ = [FRc2]
    end 

    # Output ensemble in cartesian coordinates [degrees]
    Nsize = length(FRc1_)
    FRc = Array{FiniteRotCart}(undef, Nsize)

    for i in 1:Nsize
        
        FRm1 = Finrot2Matrix(FRc1_[i])
        FRm2 = Finrot2Matrix(FRc2_[i])

        # Cartesian vector in [degrees], covariace in [degrees^2]
        FRc[i] = Add_FiniteRotations(FRm1, FRm2)
    end

    if Nsize == 1
        FRc = FRc[1]
    end

    return FRc
end


function Add_FiniteRotations(FRs1::FiniteRotSph, FRs2::FiniteRotSph, Nsize = 1e5)

    FRc1 = Finrot2Cart(FRs1)
    FRc2 = Finrot2Cart(FRs2)

    # Cartesian vector in [degrees], covariace in [degrees^2]
    FRc = Add_FiniteRotations(FRc1, FRc2, Nsize)
    
    if typeof(FRc) == FiniteRotCart
        # Spherical vector in [degrees], covariace in [degrees^2]
        FRs = Finrot2Sph(FRc)
    else
        # Array of spherical vectors in [degrees], covariaces in [degrees^2]
        FRs = [Finrot2Sph(FRc_) for FRc_ in FRc]
    end

    return FRs
end