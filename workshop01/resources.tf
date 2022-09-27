data digitalocean_ssh_key mykey {
    name = "aipc"
}

resource docker_image dov_bear {
    name = "chukmunnlee/dov-bear:v2"
}

resource docker_container dov_bear_container {
    count = var.num_of_nodes
    name = "dov-${count.index}"
    image = docker_image.dov_bear.image_id
    ports {
        internal = 3000
        external = 31000 + count.index
    }
    env = [
        "INSTANCE_NAME=dov-${count.index}"
    ]
}

resource local_file nginx_conf {
    filename = "nginx.conf"
    content = templatefile("nginx.conf.tftpl", {
        docker_host = "178.128.220.205" 
        container_ports = local.ports
    })
}

resource digitalocean_droplet nginx {
    name = "nginx"
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

    // Install nginx
    provisioner remote-exec {
        inline = [
            "apt-get update",
            "apt install -y nginx",
            "systemctl enable nginx",
            "systemctl start nginx"
        ]
    }

    // Copy the nginx.conf to the droplet
    provisioner file {
        source = "./${local_file.nginx_conf.filename}"
        destination = "/etc/nginx/nginx.conf"
    }

    // Restart nginx
    provisioner remote-exec {
        inline = [
            "systemctl restart nginx"
        ]
    }
}

output nginx_ip {
    description = "nginx ip"
    value = digitalocean_droplet.nginx.ipv4_address
}

locals {
    ports = docker_container.dov_bear_container[*].ports[0].external
}

output container_ports {
    value =  local.ports
}