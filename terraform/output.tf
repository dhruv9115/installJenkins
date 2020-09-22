### The Ansible inventory file
resource "local_file" "AnsibleInventory" {
 content = templatefile("inventory.tmpl",
 {
  /*bastion-dns = aws_eip.eip-bastion.public_dns,
  bastion-ip = aws_eip.eip-bastion.public_ip,
  bastion-id = aws_instance.bastion.id,
  private-dns = aws_instance.i-private.*.private_dns,
  private-ip = aws_instance.i-private.*.private_ip,
  private-id = aws_instance.i-private.*.id*/
   public_ip  = aws_instance.example.public_ip,
   ansible_user = var.ansible_user,
   private_key = var.PATH_TO_PRIVATE_KEY
 }
 )
 filename = "inventory.ini"
}