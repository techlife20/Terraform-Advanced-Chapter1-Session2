resource "aws_key_pair "new-key" {
  key_name = "new-key"
  public_key = "${file("${var.PUB_KEY_PATH}")}"

}

resource "aws_instance" "my-instance" {
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.new-key.key_name}"
  tags = {
    Name = "Node2-Terra"
    Project = "Very important"
}

provisioner "file" {
  source = "web.sh"
  destination "/tmp/web.sh"

}

provisioner "remote-exec" {
  inline = [
    "chmod +x /tmp/web.sh",
    "sudo "/tmp/web.sh"
    
  ]

}
connection {
  type = "ssh"
  user = "${var.USER}"
  private_key = "${file("${var.PRIV_KEY_PATH}")}"
  host = self.public_ip 

}
}

