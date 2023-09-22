resource "aws_eip_association" "eip_bastion" {
  instance_id   = aws_instance.app_server.id
  allocation_id = var.aws_eip_bastion
  depends_on    = [aws_instance.app_server]
}

resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.vpc_security_group_ids]
  key_name               = aws_key_pair.bastion.id
  tags = {
    Name = "DevTest_Bastion"
  }
}

resource "aws_key_pair" "bastion" {
  key_name   = "bastion"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDoZOzXDV/RxnPE56QqLf+ElF8kCiLaORFlRZyIsGfBlE55i3bKZ5o5Noq9MS7hdtzTp7/GMJbINjuxIsUwyDgQOUmYbk3C9SN3W0eNNIt8tsm8rLpyZLz8mhv2g20DgRbOorykTCZBXIaDOyJQ5QXzoL75x5MBp5v81KJCbc2tSU2qCvPtPPAkf534rm523IWTIoMTGkeVqycd8FUzQqPYTYxqSSkaYGy+pWQ0zzgdX6LCG21jizdO9d2J5VRrxbXlwwyFK516/E3Q6FHvsYRqVHjsntRNORjFegXhOb1GpTVyCole3iPA5vc6ruCLW4bxSmLa818d9X2pniZEN8WAZCID4pCW0NkEyNXzOJQlGiKaGX7hM3CM8rCAtLwAU2jpxfoTgAQk+z0xel3pxpnI1GDadhfQ1YKhxA3l71eiK3jjYi7Mu3TEfJ9kbxm0WY0xJiB+p5Jzcfmf51aQQs8jdaKAJLCBHFm9HIVpXUWDVtthaJ6IVIqIi1Pe3bokibc= echarniauski@scnsoft.com@echarniauski-mbl"

}
