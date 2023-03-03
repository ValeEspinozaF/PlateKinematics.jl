using PlateKinematics: CovIsZero
using PlateKinematics: FiniteRotSph, FiniteRotCart, FiniteRotMatrix
using PlateKinematics.FiniteRotationsTransformations: Finrot2Cart, Finrot2Sph, Finrot2Matrix
using PlateKinematics: BuildEnsemble3D, Ensemble2Vector

#HEREEE! MethodError: no method matching Add_FiniteRotations(::Array{Float64, 3}, ::Array{Float64, 3})
function Add_FiniteRotations(MTX1::Array{Float64, 3}, MTX2::Array{Float64, 3})
    mMTX = Multiply_RotationMatrices(MTX2, MTX1)
    return Finrot2Sph(mMTX)
end


function Add_FiniteRotations(FRm1::FiniteRotMatrix, FRm2::FiniteRotMatrix)

    return Finrot2Sph(FiniteRotMatrix(FRm2.Values * FRm1.Values))
end

function Add_FiniteRotations(FRm1Array::Matrix{FiniteRotMatrix}, FRm2Array::Matrix{FiniteRotMatrix})

    #FRs = Finrot2Sph(FiniteRotMatrix(FRm2.Values * FRm1.Values))
    return map((FRm1, FRm2) -> Finrot2Sph(FiniteRotMatrix(FRm2.Values * FRm1.Values)), FRm1Array, FRm2Array)
end


"""
Add two finite rotations in cartesian coordinates [degrees]
and outputs a finite rotation in cartesian coordinates [degrees].
If finite rotations with covariace are given, covariance in [degrees^2]"""
function Add_FiniteRotations(FRs1::FiniteRotSph, FRs2::FiniteRotSph, Nsize = 1e5)
    
    # If a covariance is found, build ensemble
    if !CovIsZero(FRs1.Covariance) || !CovIsZero(FRs2.Covariance)
        MTX1 = BuildEnsemble3D(FRs1, Nsize)
        MTX2 = BuildEnsemble3D(FRs2, Nsize)
    else
        MTX1 = Finrot2Array3D(FRs1)
        MTX2 = Finrot2Array3D(FRs2) #!!! Print warning that no ensemble is done (since no cov is provided)
    end 

    # Output ensemble in cartesian coordinates [degrees]
    addFRs = Add_FiniteRotations(MTX1, MTX2)

    if size(addFRs)[1] !== 1           # !!! Need to check with no covariance FR 
        return Ensemble2Vector(addFRs)
    else
        return addFRs[1]
    end
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