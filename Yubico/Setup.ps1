$newPin = Read-Host 'Set new PIN' -AsSecureString
$newPin = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($newPin))

# TODO: Generate codes
# TODO: Run programs and capture errors
# TODO: Ensure logging works

$newPuk = "12345678"
$newMgm = "010203040506070801020304050607080102030405060708"

$oldPin = "123456"
$oldPuk = "12345678"

# Reset
Write-Host "Resetting Yubikey"

Start-Process .\bin\yubico-piv-tool -ArgumentList "-a verify-pin -P RNADOMSI" -Wait -NoNewWindow
Start-Process .\bin\yubico-piv-tool -ArgumentList "-a verify-pin -P RNADOMSI" -Wait -NoNewWindow
Start-Process .\bin\yubico-piv-tool -ArgumentList "-a verify-pin -P RNADOMSI" -Wait -NoNewWindow
Start-Process .\bin\yubico-piv-tool -ArgumentList "-a verify-pin -P RNADOMSI" -Wait -NoNewWindow
Start-Process .\bin\yubico-piv-tool -ArgumentList "-a change-puk -P RNADOMSI -N RNADOMSI" -Wait -NoNewWindow
Start-Process .\bin\yubico-piv-tool -ArgumentList "-a change-puk -P RNADOMSI -N RNADOMSI" -Wait -NoNewWindow
Start-Process .\bin\yubico-piv-tool -ArgumentList "-a change-puk -P RNADOMSI -N RNADOMSI" -Wait -NoNewWindow
Start-Process .\bin\yubico-piv-tool -ArgumentList "-a change-puk -P RNADOMSI -N RNADOMSI" -Wait -NoNewWindow
Start-Process .\bin\yubico-piv-tool -ArgumentList "-a reset" -Wait -NoNewWindow

# TODO: Verify reset

# Set Management key
Write-Host "Setting Management key"

Start-Process .\bin\yubico-piv-tool -ArgumentList "-a set-mgm-key -n $newMgm" -Wait -NoNewWindow

# Set PIN
Write-Host "Setting PIN key"

Start-Process .\bin\yubico-piv-tool -ArgumentList "-k $newMgm -a change-pin -P $oldPin -N $newPin" -Wait -NoNewWindow

# Set PUK
Write-Host "Setting PUK key"

Start-Process .\bin\yubico-piv-tool -ArgumentList "-k $newMgm -a change-puk -P $oldPuk -N $newPuk" -Wait -NoNewWindow

# Log Puk & Mgm keys
$id = iex "bin\ykinfo.exe -H"
[System.IO.File]::AppendAllText(".\file", "ID: $id; Mgm: $newMgm; Puk: $newPuk\n")
