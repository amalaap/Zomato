resource "aws_instance" "test-server" {
  ami = "ami-0d176f79571d18a8f"
  instance_type = "t3.small"
  key_name = "projectkey"
  vpc_security_group_ids = ["sg-0207fecb9db30adde"]
  connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./projectkey.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/zomatoapp/terraformfiles/ansiblebook.yml"
     }
  }
