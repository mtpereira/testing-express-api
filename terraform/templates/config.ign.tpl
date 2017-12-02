{
  "ignition": {
    "version": "2.1.0"
  },
  "systemd": {
    "units": [
      {
        "name": "${app_name}.service",
        "enabled": true,
        "contents": "[Unit]\nDescription=${app_name}\nAfter=docker.service\n\n[Service]\nRestart=always\nExecStart=/usr/bin/docker run --name ${app_name} --publish 0.0.0.0:${app_port}:${app_port} ${docker_image}:${app_version}\nExecStop=/usr/bin/docker kill ${app_name}\n\n[Install]\nWantedBy=multi-user.target\n"
      }
    ]
  }
}
