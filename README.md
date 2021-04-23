# swdpwr
For the SAS macro, we provide versions of under UNIX and Windows. The SAS macro can invoke the fortran program (you do not need to install Fortran on your machine).

Files for Windows:
swdpwr_macro_win.sas 
swdpwr.exe (This can be downloaded from: https://github.com/jiachenchen322/swdpwr/blob/main/swdpwr.exe)
If an error message occurred saying that some dll files are missing, you could only copy the .dll file mentioned in the error message from bin1.zip and bin2.zip and put them in the same folder as the exe file then run the program again. Please contact me if you need further help about the software.

Files for UNIX:
swdpwr_macro_unix.sas 
swdpwr (This can be downloaded from: https://github.com/jiachenchen322/swdpwr/blob/main/swdpwr.zip)

The proper directory to the executive file swdpwr should be modified in the *.sas file in line "%let mydir=...". Please also check other paths in case of any unknown errors.
 
Please refer to https://arxiv.org/abs/2011.06031 for more details and examples for using this SAS macro.
