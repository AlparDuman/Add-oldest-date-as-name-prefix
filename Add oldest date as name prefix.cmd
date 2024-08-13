@echo off
rem 
rem MIT License
rem 
rem Copyright (c) 2024 Alpar Duman alparduman.de github.com/AlparDuman
rem 
rem Permission is hereby granted, free of charge, to any person obtaining a copy
rem of this software and associated documentation files (the "Software"), to deal
rem in the Software without restriction, including without limitation the rights
rem to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
rem copies of the Software, and to permit persons to whom the Software is
rem furnished to do so, subject to the following conditions:
rem 
rem The above copyright notice and this permission notice shall be included in all
rem copies or substantial portions of the Software.
rem 
rem THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
rem IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
rem FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
rem AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
rem LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
rem OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
rem SOFTWARE.
rem 
rem Version 1.0

if not defined in_subprocess (cmd /k set in_subprocess=y ^& %0 %*) & exit
>nul chcp 65001
setlocal enabledelayedexpansion
set "windowTitle=%~n0"
title !windowTitle!

set "countTotalFiles=0"
for %%F in (*) do (
    set /a "countTotalFiles=!countTotalFiles!+1"
)
if !countTotalFiles! gtr 1 (
    set /a "countTotalFiles=!countTotalFiles!-1"
)

set "lastRelativeProgress=-1"
set "countProgressFiles=0"
set "countRenamedFiles=0"
set "ownFileName=%~nx0"
rem for each file in folder
for %%F in (*) do (
    set /a "countProgressFiles=!countProgressFiles!+1"

    rem if not the executing file itself
    if "%%~nxF" neq "!ownFileName!" (

        rem if file has not prefix
        set "fileName=%%~nF"
        if not "!fileName:~4,1!!fileName:~7,1!!fileName:~10,1!!fileName:~13,1!!fileName:~16,1!" == "-- --" (

            rem get full path of file
            set "fullFilePath=%%~dpnxF"

            rem get creation, last modified & last accessed datetime
            set "fileCreationDate="
            set "fileModifiedDate="
            set "fileAccessedDate="
            set "fileCreationTime="
            set "fileModifiedTime="
            set "fileAccessedTime="
            for /f "tokens=1,3,5 delims=. " %%A in ('wmic datafile where "name='!fullFilePath:\=\\!'" get creationdate^,lastmodified^,lastaccessed ^| findstr /r "^[0-9]"') do ( 
                call :enterDateTime %%A fileCreationDate fileCreationTime
                call :enterDateTime %%B fileModifiedDate fileModifiedTime
                call :enterDateTime %%C fileAccessedDate fileAccessedTime
            )

            rem determine oldest datetime
            set "fileOldestDateTime="
            call :enterOlderDateTime fileOldestDateTime fileCreationDate fileCreationTime
            call :enterOlderDateTime fileOldestDateTime fileModifiedDate fileModifiedTime
            call :enterOlderDateTime fileOldestDateTime fileAccessedDate fileAccessedTime

            rem no error getting oldest datetime
            if not "!fileOldestDateTime!" == "" (

                rem new file name
                set "fileNewName=!fileOldestDateTime:~0,4!-!fileOldestDateTime:~4,2!-!fileOldestDateTime:~6,2! !fileOldestDateTime:~8,2!-!fileOldestDateTime:~10,2!-!fileOldestDateTime:~12,2!"
                if not "!fileName:~0,6!" == "noname" (
                    set "fileNewName=!fileNewName! !fileName!"
                )

                rem file extension in lower case
                set "fileExtension=%%~xF"
                set "fileFullName=!fileName!!fileExtension!"
                CALL :lowerCase fileExtension

                rem renaming
                call :reNaming fileNewName fileExtension fileFullName countRenamedFiles
            )
        )
    )
    title ^(!countProgressFiles!/!countTotalFiles!^) !windowTitle!
)

rem finish with summary
title !windowTitle!
if !countRenamedFiles! leq 1 (
    echo Renamed ^(!countRenamedFiles!/!countTotalFiles!^) file
) else (
    echo Renamed ^(!countRenamedFiles!/!countTotalFiles!^) files
)
endlocal
echo.
echo Press any button to close this window
pause >nul
exit

rem subroutine: enter datetime if format is ok
:enterDateTime
    set "rawDateTime=%~1"
    set /a rawDate=0+!rawDateTime:~0,8!
    set /a currentDate=%date:~6,4%%date:~3,2%%date:~0,2%
    set year=!rawDateTime:~0,4!
    set month=!rawDateTime:~4,2!
    set day=!rawDateTime:~6,2!
    set hour=0+!rawDateTime:~8,2!
    set minute=0+!rawDateTime:~10,2!
    set second=0+!rawDateTime:~12,2!
    if !rawDate! leq !currentDate! if !year! geq 1970 if !month! leq 12 if !day! leq 31 if !hour! leq 23 if !minute! leq 59 if !second! leq 59  (
        set /a %~2=1!rawDateTime:~0,8!
        set %~2=!%~2:~1,8!
        set /a %~3=1!rawDateTime:~8,6!
        set %~3=!%~3:~1,6!
    )
goto:eof

rem subroutine: enter new datetime if older
:enterOlderDateTime
if "!%~2!" neq "" if "!%~3!" neq "" (
    if "!%~1!" equ "" (
        set "%~1=!%~2!!%~3!"
    ) else (
        set "oldestDate=!%~1:~0,8!"
        set "oldestTime=!%~1:~8,6!"
        if !%~2! lss !oldestDate! (
            set "%~1=!%~2!!%~3!"
        ) else (
            if !%~2! equ !oldestDate! if !%~3! lss !oldestTime! (
                set "%~1=!%~2!!%~3!"
            )
        )
    )
)
goto:eof

rem subroutine: return first argument in lowercase
:lowerCase
set %~1=!%~1:A=a!
set %~1=!%~1:B=b!
set %~1=!%~1:C=c!
set %~1=!%~1:D=d!
set %~1=!%~1:E=e!
set %~1=!%~1:F=f!
set %~1=!%~1:G=g!
set %~1=!%~1:H=h!
set %~1=!%~1:I=i!
set %~1=!%~1:J=j!
set %~1=!%~1:K=k!
set %~1=!%~1:L=l!
set %~1=!%~1:M=m!
set %~1=!%~1:N=n!
set %~1=!%~1:O=o!
set %~1=!%~1:P=p!
set %~1=!%~1:Q=q!
set %~1=!%~1:R=r!
set %~1=!%~1:S=s!
set %~1=!%~1:T=t!
set %~1=!%~1:U=u!
set %~1=!%~1:V=v!
set %~1=!%~1:W=w!
set %~1=!%~1:X=x!
set %~1=!%~1:Y=y!
set %~1=!%~1:Z=z!
set %~1=!%~1:Ä=ä!
set %~1=!%~1:Ö=ö!
set %~1=!%~1:Ü=ü!
goto:eof

rem renaming
:reNaming
rem renaming loop counter & jumpback
set "duplicateCounter=1"
:retryNaming
rem check if new name for file already exists
if !duplicateCounter! equ 1 (
    set "fileSuffixedName=!%~1!!%~2!"
) else (
    set "fileSuffixedName=!%~1! (!duplicateCounter!)!%~2!"
)
if not exist !fileSuffixedName! (

    rem rename file
    ren "!%~3!" "!fileSuffixedName!"

    rem update user of renaming
    call :customDisplay
    set /a "%~4=!%~4!+1"

) else (

    rem increment name counter
    set /a "duplicateCounter=!duplicateCounter!+1"
    goto retryNaming

)
goto:eof

rem show custom print because a full terminal slows down
:customDisplay
set /a "relativeProgress=!countProgressFiles!*100/!countTotalFiles!"
if !relativeProgress! gtr 100 (
    set "relativeProgress=100"
)
if !lastRelativeProgress! lss !relativeProgress! (
    set "lastRelativeProgress=!relativeProgress!"
    set /a "relativeProgress=!relativeProgress!/2"
    set /a "countEmpty=50"
    set "output="

    :fill
    if !relativeProgress! gtr 0 (
        set "output=!output!■"
        set /a "relativeProgress=!relativeProgress!-1"
        set /a "countEmpty=!countEmpty!-1"
        goto fill
    )

    :empty
    if !countEmpty! gtr 0 (
        set "output=!output!-"
        set /a "countEmpty=!countEmpty!-1"
        goto empty
    )

    cls
    echo Renaming !output! !lastRelativeProgress!%%
)
goto:eof
