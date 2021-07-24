[Unit]
Description=Puma HTTP Server
After=network.target

[Service]
Type=simple
User=ubuntu
Environment=DATABASE_URL=${db_internal_ip}
WorkingDirectory=/home/ubuntu/reddit
ExecStart=/bin/bash -lc 'puma'
Restart=always

[Install]
WantedBy=multi-user.target
