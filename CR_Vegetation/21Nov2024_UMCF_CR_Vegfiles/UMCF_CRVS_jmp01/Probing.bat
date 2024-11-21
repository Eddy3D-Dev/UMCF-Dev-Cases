setlocal
call "C:\Program Files\blueCFD-Core-2020\setvars_OF8.bat"
set PATH=%HOME%\ofuser-of8\platforms\mingw_w64GccDPInt32Opt\bin;%HOME%\msys64\usr\bin;%PATH%
cd C:\MetaFoam_Cases\UMCF_CRVS_jmp01
postProcess -region air -func probing01 2>&1 | tee -a probingLog.txt
