data "aws_ami" "windows" {

  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
}

resource "aws_instance" "iis_server" {

  ami           = data.aws_ami.windows.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  vpc_security_group_ids = [var.sg_id]

  user_data = <<EOF
<powershell>

Install-WindowsFeature -name Web-Server -IncludeManagementTools

New-Item -Path "C:\\inetpub\\OnPremApp" -ItemType Directory

Set-Content -Path "C:\\inetpub\\OnPremApp\\index.html" -Value "<h1>Migrated IIS Application</h1><p>Deployed automatically with Terraform</p>"

Import-Module WebAdministration

New-Website -Name "OnPremApp" -Port 8080 -PhysicalPath "C:\\inetpub\\OnPremApp" -Force

</powershell>
EOF

  tags = {
    Name = "IIS-Migration-Server"
  }
}