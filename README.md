# swdpwr
For the SAS macro, we provide versions of under UNIX and Windows. The SAS macro can invoke the fortran program.

Files for Windows:
swdpwr_macro_win.sas 
swdpwr.exe (This can be downloaded from: https://github.com/jiachenchen322/swdpwr/blob/main/swdpwr.exe)
If an error message saying that some dll files are missing, please contact me so that I can help you solve this issue.

Files for UNIX:
swdpwr_macro_unix.sas 
swdpwr (This can be downloaded from: https://github.com/jiachenchen322/swdpwr/blob/main/swdpwr.zip)

The proper directory to the executive file swdpwr should be modified in the *.sas file in line "%let mydir=...". Please also check other paths in case of any unknown errors.
 
Please refer to https://arxiv.org/abs/2011.06031 for more details and examples for using this SAS macro.
