$ErrorActionPreference = 'Stop'
try {
    $map = [IO.MemoryMappedFiles.MemoryMappedFile]::OpenExisting('GPUZShMem')
    $view = $map.CreateViewAccessor(0, 200204, [IO.MemoryMappedFiles.MemoryMappedFileAccess]::Read)
    try {
        $readings = @()
        for ($i = 0; $i -lt 128; $i++) {
            $offset = 12 + 128 * 1024 + $i * 540
            $buffer = New-Object byte[] 512
            $view.ReadArray($offset, $buffer, 0, 512) | Out-Null
            $name = ([Text.Encoding]::Unicode.GetString($buffer)).Trim([char]0)
            if (-not $name) { continue }
            $units = New-Object byte[] 16
            $view.ReadArray($offset + 512, $units, 0, 16) | Out-Null
            $unit = ([Text.Encoding]::Unicode.GetString($units)).Trim([char]0)
            $value = $view.ReadDouble($offset + 532)
            if ([double]::IsNaN($value) -or [double]::IsInfinity($value)) { continue }
            if ($name -match 'Temperature' -and ($value -le 0 -or $value -gt 150)) { continue }
            $readings += [pscustomobject]@{Sensor=$name; Value=$value; Unit=$unit}
        }
        if (-not $readings) { throw 'GPU-Z shared memory contains no usable sensor readings.' }
        $readings | ConvertTo-Json -Depth 3
    } finally { $view.Dispose(); $map.Dispose() }
} catch { Write-Error "GPU-Z sensor read failed: $($_.Exception.Message)"; exit 1 }
