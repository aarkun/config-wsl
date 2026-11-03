Param (
    $target_dir = "$env:USERPROFILE\Downloads"
)

New-Item -Path "$target_dir" -ItemType Directory -Force

$wsl_file = "Debian_WSL_AMD64_v1.19.0.0.wsl"
$install_file = "$target_dir\$wsl_file"

if (-Not (Test-Path "$install_file")) {
    Invoke-WebRequest `
      -OutFile "$install_file" `
      -UserAgent 'foo' `
      -Uri "https://salsa.debian.org/debian/WSL/-/jobs/7125470/artifacts/raw/$wsl_file"
}

$distro = "My_Debian_1"
$install_dir = "$env:USERPROFILE\wsl"

New-Item  -Path "$install_dir" -ItemType Directory -Force

wsl --import $distro "$install_dir\$distro" "$install_file"
if(!$?) { Exit $LASTEXITCODE }

wsl -d $distro -u root sh -c `
  "adduser --uid 1000 --quiet --gecos '' $env:USERNAME"

wsl -d $distro -u root sh -c `
  "usermod $env:USERNAME -aG 'adm,cdrom,sudo,dip,plugdev'"

wsl --manage $distro --set-default-user $env:USERNAME
