#!/bin/bash
yum update -y
yum install -y unzip curl
NOMAD_VERSION="${NOMAD_VERSION}"
curl -O https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip
unzip nomad_${NOMAD_VERSION}_linux_amd64.zip
mv nomad /usr/local/bin/
rm nomad_${NOMAD_VERSION}_linux_amd64.zip
mkdir -p /etc/nomad.d
chmod a+w /etc/nomad.d
cat <<EOF2 > /etc/nomad.d/nomad.hcl
data_dir  = "/opt/nomad"
bind_addr = "0.0.0.0"
server {
  enabled          = true
  bootstrap_expect = 1
}
client {
  enabled = true
}
EOF2
nomad agent -config=/etc/nomad.d/nomad.hcl &
