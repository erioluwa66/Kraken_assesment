#!/bin/bash
yum update -y
yum install -y unzip curl dnf

# Install Docker
dnf install docker -y
service docker start
usermod -a -G docker ec2-user

# Install Nomad
NOMAD_VERSION="${NOMAD_VERSION}"
curl -O https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip
unzip nomad_${NOMAD_VERSION}_linux_amd64.zip
mv nomad /usr/local/bin/
rm nomad_${NOMAD_VERSION}_linux_amd64.zip
mkdir -p /etc/nomad.d
chmod a+w /etc/nomad.d

# Nomad configuration
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

# Nomad systemd service
cat <<EOF > /etc/systemd/system/nomad.service
[Unit]
Description=Nomad Agent
Documentation=https://www.nomadproject.io/docs/
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/usr/local/bin/nomad agent -config=/etc/nomad.d/nomad.hcl
ExecReload=/bin/kill -HUP \$MAINPID
KillMode=process
KillSignal=SIGINT
Restart=on-failure
LimitNOFILE=65536
TasksMax=infinity

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start nomad
systemctl enable nomad

# Install Consul
CONSUL_VERSION="${CONSUL_VERSION}"
curl -O https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
unzip consul_${CONSUL_VERSION}_linux_amd64.zip
mv consul /usr/local/bin/
rm consul_${CONSUL_VERSION}_linux_amd64.zip

# Consul configuration
mkdir -p /etc/consul.d
cat <<EOF > /etc/consul.d/consul.hcl
data_dir = "/opt/consul"
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"
EOF

# Start Consul agent
consul agent -dev -config-dir=/etc/consul.d &
