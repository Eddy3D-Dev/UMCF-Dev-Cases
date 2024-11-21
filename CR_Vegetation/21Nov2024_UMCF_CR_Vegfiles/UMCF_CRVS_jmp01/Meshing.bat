setlocal
call "C:\Program Files\blueCFD-Core-2020\setvars_OF8.bat"
set PATH=%HOME%\msys64\usr\bin;%PATH%
cd C:\MetaFoam_Cases\UMCF_CRVS_jmp01
blockMesh 2>&1 | tee -a prepareLog.txt
surfaceFeatures 2>&1 | tee -a prepareLog.txt
echo "Creating mesh for air region"
cp -r constant/polyMesh constant/polyMesh.bckp
cp system/snappyHexMeshDict.air system/snappyHexMeshDict
decomposePar -force 2>&1 | tee -a prepareLog.txt
mpirun -np 12 snappyHexMesh -overwrite -parallel 2>&1 | tee -a prepareLog.txt
reconstructParMesh -constant 2>&1 | tee -a prepareLog.txt
rm -rf ./processor*
rm -rf constant/air/polyMesh
mv constant/polyMesh constant/air/
changeDictionary -region air 2>&1 | tee -a prepareLog.txt
 
echo "Creating mesh for vegetation region 'vegetation' region"
cp -r constant/polyMesh.bckp constant/polyMesh
cp system/snappyHexMeshDict.veg system/snappyHexMeshDict
decomposePar -copyZero -force 2>&1 | tee -a prepareLog.txt
mpirun -np 12 snappyHexMesh -overwrite -parallel 2>&1 | tee -a prepareLog.txt
reconstructParMesh -constant 2>&1 | tee -a prepareLog.txt
rm -rf constant/vegetation/polyMesh
mv constant/polyMesh constant/vegetation/
createPatch -region vegetation -overwrite 2>&1 | tee -a prepareLog.txt
changeDictionary -region vegetation 2>&1 | tee -a prepareLog.txt
rm -rf constant/polyMesh.bckp
 
echo "Creating mesh for solid region 'tower' region"
extrudeMesh 2>&1 | tee -a prepareLog.txt
rm -rf constant/tower/polyMesh
mv constant/polyMesh constant/tower
createPatch -region tower -overwrite 2>&1 | tee -a prepareLog.txt
changeDictionary -region tower 2>&1 | tee -a prepareLog.txt
topoSet -region tower 2>&1 | tee -a prepareLog.txt
 
echo "Setting LAD values"
topoSet -region air 2>&1 | tee -a prepareLog.txt
setFields -region air 2>&1 | tee -a prepareLog.txt
pause
