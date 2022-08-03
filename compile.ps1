Write-Output "`nCompiling builds..."
Remove-Item -Path dist/* -Recurse # Clear folder

Write-Output "    Windows:"
Write-Output "`tCopy resources"
# Copy resources
Copy-Item src dist\win\src -Recurse
Copy-Item README.md dist\win
Copy-Item config.ini dist\win
Write-Output "`tCopied resources."
# Create executable
& "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in Mousr.ahk /out dist/win/Mousr.exe
Write-Output "`tCreated executable."
# Compress folder
Compress-Archive -Path dist\win\* -DestinationPath dist\Mousr_v-win_UNZIP.zip
Write-Output "`tCompressed folder."
# Delete uncompressed folder
# Remove-Item -Path dist\win -Recurse
Write-Output ""
