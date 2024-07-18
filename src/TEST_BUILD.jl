using PlateKinematics
using PlateKinematics: BuildEnsemble3D, LoadTXT_asStruct, ToEVc, ToEVs, ToTXT, EVtoTXT, EulerVectorSph, AverageEnsemble
using DelimitedFiles

projectDir = raw"C:\Users\nbt571\Documents\PhD\Project_Folder"
Nsize = 1000000


fileDir = joinpath(projectDir, raw"2_Pipeline\1_EulerVector_to_PlateCircuit\store")
fileName = "NZ_EV_SA_qui22_fRot_ve"
filePath = joinpath(fileDir, fileName * ".txt")
outfileDir = joinpath(projectDir, raw"2_Pipeline\1_EulerVector_to_PlateCircuit\out")


EVs_list = LoadTXT_asStruct(filePath, EulerVectorSph, header=true)
EVc_list = ToEVc(EVs_list)



# ================ ENSEMBLE OF EULER VECTOR ==================

#= idxs = [6, 10, 12, 13, 15]

for idx in idxs
    EVc_ens = BuildEnsemble3D(EVc_list[idx], Nsize)

    global EVc_array = Array{Float32}(undef, Nsize, 3)

    for i in 1:Nsize     
        global EVc_array[i, :] .= EVc_ens[i].X, EVc_ens[i].Y, EVc_ens[i].Z
    end

    outName = "NZ_EV_SA_qui22_fRot_ve_$(idx)"
    out_dev_filePathTXT = joinpath(outfileDir, outName * ".txt") 
    #ToTXT(EVc_ens6, out_dev_filePathTXT, delimiter=" ")
    writedlm(out_dev_filePathTXT, EVc_array, ' ')

end =#


# ============= ENSEMBLE OF EULER VECTOR CHANGE ==============

#= idxRanges = [(6, 10), (12, 13), (13, 15)]

for idx_range in idxRanges

    idx1 = idx_range[1]
    idx2 = idx_range[2]
    EVc_ens1 = BuildEnsemble3D(EVc_list[idx1], Nsize)
    EVc_ens2 = BuildEnsemble3D(EVc_list[idx2], Nsize)

    global dEVc_array = Array{Float32}(undef, Nsize, 3)

    for i in 1:Nsize 
        
        a = [EVc_ens1[i].X; EVc_ens1[i].Y; EVc_ens1[i].Z]
        b = [EVc_ens2[i].X; EVc_ens2[i].Y; EVc_ens2[i].Z]
        dEVc = a - b       

        global dEVc_array[i, :] .= dEVc[1], dEVc[2], dEVc[3]
    end


    outName = "NZ_dEV_SA_qui22_fRot_ve_$(idx1)_$(idx2)"
    out_dev_filePathTXT = joinpath(outfileDir, outName * ".txt") 
    writedlm(out_dev_filePathTXT, dEVc_array, ' ')
end =#



# ========= ENSEMBLE ABSOLUTE EULER VECTOR CHANGE ==========

 idxRanges = [(6, 10), (12, 13), (13, 15)]


# --------- STAGE 1 ------------

#= idx1 = idxRanges[1][1]
idx2 = idxRanges[1][2]

fileName_nz_sa = "NZ_dEV_SA_qui22_fRot_ve_$(idx1)_$(idx2)"
filePath_nz_sa = joinpath(outfileDir, fileName_nz_sa * ".txt") 
dEVc_array_nz_sa = LoadTXT_asStruct(filePath_nz_sa, EulerVectorCart, names=["X", "Y", "Z"])

fileName_sa = "STAGE_EVs_ENSEMBLE_SA_1"
filePath_sa = joinpath(outfileDir, fileName_sa * ".txt") 
dEVc_array_sa = LoadTXT_asStruct(filePath_sa, EulerVectorCart, names=["X", "Y", "Z"])

global dEVc_array_nz = Array{EulerVectorCart}(undef, Nsize)

for i in 1:Nsize 
    
    a = [dEVc_array_nz_sa[i].X; dEVc_array_nz_sa[i].Y; dEVc_array_nz_sa[i].Z]
    b = [dEVc_array_sa[i].X; dEVc_array_sa[i].Y; dEVc_array_sa[i].Z]
    dEVc = a + b       

    global dEVc_array_nz[i] = EulerVectorCart(dEVc[1], dEVc[2], dEVc[3])
end

outName = "NZ_dEV_qui22_fRot_ve_$(idx1)_$(idx2)"
out_dev_filePathTXT = joinpath(outfileDir, outName * ".txt")
EVtoTXT(dEVc_array_nz, out_dev_filePathTXT, delimiter=" ", fields=["X", "Y", "X"], header=false)

dEVs_av_nz = ToEVs(AverageEnsemble(dEVc_array_nz))
out_dev_av_filePathTXT = joinpath(outfileDir, outName * "_av.txt")
EVtoTXT([dEVs_av_nz], out_dev_av_filePathTXT, delimiter=" ", fields=["Lon", "Lat", "AngVelocity", "Covariance"], format=["%.2f", "%.2f", "%.4f", "%.4e", "%.4e", "%.4e", "%.4e", "%.4e", "%.4e"])
 =#

# --------- STAGE 2 ------------

idx1 = idxRanges[2][1]
idx2 = idxRanges[2][2]

fileName_nz_sa = "NZ_dEV_SA_qui22_fRot_ve_$(idx1)_$(idx2)"
filePath_nz_sa = joinpath(outfileDir, fileName_nz_sa * ".txt") 
dEVc_array_nz_sa = LoadTXT_asStruct(filePath_nz_sa, EulerVectorCart, names=["X", "Y", "Z"])
dEVc_array_nz = dEVc_array_nz_sa

outName = "NZ_dEV_qui22_fRot_ve_$(idx1)_$(idx2)"
out_dev_filePathTXT = joinpath(outfileDir, outName * ".txt")
EVtoTXT(dEVc_array_nz, out_dev_filePathTXT, delimiter=" ", fields=["X", "Y", "X"], header=false)

dEVs_av_nz = ToEVs(AverageEnsemble(dEVc_array_nz))
out_dev_av_filePathTXT = joinpath(outfileDir, outName * "_av.txt")
EVtoTXT([dEVs_av_nz], out_dev_av_filePathTXT, delimiter=" ", fields=["Lon", "Lat", "AngVelocity", "Covariance"], format=["%.2f", "%.2f", "%.4f", "%.4e", "%.4e", "%.4e", "%.4e", "%.4e", "%.4e"])



# --------- STAGE 3 ------------

idx1 = idxRanges[3][1]
idx2 = idxRanges[3][2]

fileName_nz_sa = "NZ_dEV_SA_qui22_fRot_ve_$(idx1)_$(idx2)"
filePath_nz_sa = joinpath(outfileDir, fileName_nz_sa * ".txt") 
dEVc_array_nz_sa = LoadTXT_asStruct(filePath_nz_sa, EulerVectorCart, names=["X", "Y", "Z"])

fileName_sa = "STAGE_EVs_ENSEMBLE_SA_1"
filePath_sa = joinpath(outfileDir, fileName_sa * ".txt") 
dEVc_array_sa = LoadTXT_asStruct(filePath_sa, EulerVectorCart, names=["X", "Y", "Z"])

fileName_nz = "NZ_dEV_qui22_fRot_ve_12_13"
filePath_nz = joinpath(outfileDir, fileName_nz * ".txt") 
dEVc_array_nz_tmp = LoadTXT_asStruct(filePath_nz, EulerVectorCart, names=["X", "Y", "Z"])

global dEVc_array_nz = Array{EulerVectorCart}(undef, Nsize)

for i in 1:Nsize 
    
    a = [dEVc_array_nz_sa[i].X; dEVc_array_nz_sa[i].Y; dEVc_array_nz_sa[i].Z]
    b = [dEVc_array_sa[i].X; dEVc_array_sa[i].Y; dEVc_array_sa[i].Z]
    c = [dEVc_array_nz_tmp[i].X; dEVc_array_nz_tmp[i].Y; dEVc_array_nz_tmp[i].Z]
    dEVc = a + b - c  

    global dEVc_array_nz[i] = EulerVectorCart(dEVc[1], dEVc[2], dEVc[3])
end

outName = "NZ_dEV_qui22_fRot_ve_$(idx1)_$(idx2)"
out_dev_filePathTXT = joinpath(outfileDir, outName * ".txt")
EVtoTXT(dEVc_array_nz, out_dev_filePathTXT, delimiter=" ", fields=["X", "Y", "X"], header=false)

dEVs_av_nz = ToEVs(AverageEnsemble(dEVc_array_nz))
out_dev_av_filePathTXT = joinpath(outfileDir, outName * "_av.txt")
EVtoTXT([dEVs_av_nz], out_dev_av_filePathTXT, delimiter=" ", fields=["Lon", "Lat", "AngVelocity", "Covariance"], format=["%.2f", "%.2f", "%.4f", "%.4e", "%.4e", "%.4e", "%.4e", "%.4e", "%.4e"])
