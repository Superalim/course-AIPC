data digitalocean_ssh_key mykey {
    name = "aipc"
}

resource digitalocean_droplet droplet {
    name = "droplet"
    image  = var.DO_image
    region = var.DO_region
    size   = var.DO_size
    ssh_keys = [ data.digitalocean_ssh_key.mykey.id ]

    connection {
        type = "ssh"
        user = "root"
        host = self.ipv4_address
        private_key = file("./default")
    }
}

# resource local_file nginx_conf {
#     filename = "inventory.yaml"
#     content = templatefile("inventory.yaml.tftpl", {
#         droplet_ip = digitalocean_droplet.nginx.ipv4_address
#         private_key = file("./default")
#     })
# }

output droplet_ip {
    description = "droplet ip"
    value = digitalocean_droplet.droplet.ipv4_address
}