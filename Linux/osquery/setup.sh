curl -L https://pkg.osquery.io/rpm/GPG -o /etc/pki/rpm-gpg/RPM-GPG-KEY-osquery
yum install -y yum-utils
yum-config-manager --add-repo https://pkg.osquery.io/rpm/osquery-s3-rpm.repo
yum-config-manager --enable osquery-s3-rpm
yum install -y osquery
cat <<EOF > /etc/systemd/system/fleetconnect.service

[Unit]
Description=Koldie OSQuery
After=network.target

[Service]
ExecStart=/usr/bin/osqueryd \
  --enroll_secret_path=/var/osquery/enroll_secret \
  --tls_server_certs=/var/osquery/server.pem \
  --tls_hostname=184.171.152.208:8080 \
  --host_identifier==uuid \
  --enroll_tls_endpoint=/api/v1/osquery/enroll \
  --config_plugin=tls \
  --config_tls_endpoint=/api/v1/osquery/config \
  --config_refresh=10 \
  --disable_distributed=false \
  --distributed_plugin=tls \
  --distributed_interval=3 \
  --distributed_tls_max_attempts=3 \
  --distributed_tls_read_endpoint=/api/v1/osquery/distributed/read \
  --distributed_tls_write_endpoint=/api/v1/osquery/distributed/write \
  --logger_plugin=tls \
  --logger_tls_endpoint=/api/v1/osquery/log \
  --logger_tls_period=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start fleetconnect.service
systemctl enable fleetconnect.service
