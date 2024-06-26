# ifs_docker

## optionally
`chmod +x *`

## start docker container
either `source start_docker.bash` or `./start_docker.bash`

## first thing to do when opened a container
`source ~/.initial_setup.bash`

## open a terminal attaching to the container
at different host terminal, either `source terminal.bash` or `./terminal.bash`

## PX4-Autopilot
- `cd $PX4_ROOT`
- `make px4_sitl gazebo` or `make px4_sitl gazebo-classic`