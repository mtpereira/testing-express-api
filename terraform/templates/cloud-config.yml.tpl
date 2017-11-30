#cloud-config

coreos:
  units:
    name: ${app_name}.service
    command: "start"
    enable: "true"
    content: |
      [Unit]
      Description=${app_name}
      After=docker.service

      [Service]
      Restart=always
      ExecStart=docker run --name ${app_name} --publish 0.0.0.0:${app_port}:${app_port} ${docker_image}:${app_version}
      ExecStop=docker kill ${app_name}
