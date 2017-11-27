coreos:
  units:
    name: ${app_name}.service
    enable: true
    content: |
      [Unit]
      Description=${app_name}

      [Service]
      Restart=always
      ExecStart=docker run --name ${app_name} --publish 0.0.0.0:80:3000 ${docker_image}:${app_version}
      ExecStop=docker kill ${app_name}
