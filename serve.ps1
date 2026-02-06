$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8000/")
$listener.Start()
Write-Host "Serving at http://localhost:8000/"
while ($listener.IsListening) {
  $context = $listener.GetContext()
  $path = $context.Request.Url.LocalPath.TrimStart("/")
  if ([string]::IsNullOrEmpty($path)) { $path = "index.html" }
  $file = Join-Path (Get-Location) $path
  if (Test-Path $file) {
    $bytes = [IO.File]::ReadAllBytes($file)
    $context.Response.ContentType = "text/html"
    $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  } else {
    $context.Response.StatusCode = 404
  }
  $context.Response.Close()
}
