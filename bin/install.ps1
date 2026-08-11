$target_dir = $args[0]
New-Item -Path "$target_dir" -ItemType Directory -Force

Invoke-WebRequest `
  -OutFile "$target_dir\Debian_WSL_AMD64_v1.19.0.0.wsl" `
  -UserAgent 'foo' `
  -Uri 'https://salsa.debian.org/debian/WSL/-/jobs/7125470/artifacts/raw/Debian_WSL_AMD64_v1.19.0.0.wsl'

wsl --import Debian-1 $env:USERPROFILE\Deb-Dir_1 `
  "$target_dir\Debian_WSL_AMD64_v1.19.0.0.wsl"

wsl -d Debian-1 -u root sh -c "adduser --uid 1000 --quiet --gecos '' $env:USERNAME"

wsl -d Debian-1 -u root sh -c "usermod $env:USERNAME -aG 'adm,cdrom,sudo,dip,plugdev'"

wsl --manage Debian-1 --set-default-user $env:USERNAME
