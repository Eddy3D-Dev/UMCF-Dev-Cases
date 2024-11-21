setlocal
call "C:\Program Files\blueCFD-Core-2020\setvars_OF8.bat"
set PATH=%HOME%\ofuser-of8\platforms\mingw_w64GccDPInt32Opt\bin;%HOME%\msys64\usr\bin;%PATH%

cd C:\MetaFoam_Cases\UMCF_CRVS_jmp01

decomposePar -force -allRegions 2>&1 | tee -a decomposePar.txt
mpirun -np 12 faceAgglomerate -region vegetation -parallel  2>&1 | tee -a faceAgglomerateLog.txt
mpirun -np 12 calcLAI -region air -parallel 2>&1 | tee -a calcLAILog.txt
mpirun -np 12 viewFactorsGen -region vegetation -parallel 2>&1 | tee -a viewFactorsGenLog.txt
mpirun -np 12 solarRayTracingGen -region vegetation -parallel 2>&1 | tee -a solarRayTracingGenLog.txt
mpirun -np 12 urbanMicroClimateFoam -parallel 2>&1 | tee -a urbanMicroClimateFoamLog.txt
reconstructPar -allRegions | tee -a reconstructParLog.txt
pause
