# Base Docker image name
DOCKER_IMAGE_BASE="vividlibra/focal-px4-noetic-desktop-ifs"

# Common options
COMMON_OPTIONS=(
    "-it"
    "--privileged"
    "--rm"
    "--name=ifs_docker"
    "--volume=$(pwd)/bashrc:/root/.bashrc:rw"
    "--volume=$(pwd)/initial_setup.bash:/root/.initial_setup.bash:rw"
    "-v" "/tmp/.X11-unix:/tmp/.X11-unix:ro"
)
# Initialize an empty array for architecture-specific options
ARCH_OPTIONS=()

# Detect the host architecture
ARCH=$(uname -m)
OS=$(uname -s)
# Determine the full Docker image name based on architecture
if [ "$ARCH" == "x86_64" ] && [ "$OS" == "Linux" ]; then
    # Options for Ubuntu AMD machine
    DOCKER_IMAGE="${DOCKER_IMAGE_BASE}:amd64"
    WORKSPACE=/home/$USER/Workspace
    ARCH_OPTIONS+=(
        "--runtime=nvidia"
        "--gpus=all"
        "--volume=$WORKSPACE/IFS/ROS:/root/catkin_ws/src:rw"
        "--volume=$WORKSPACE/PX4:/src:rw"
        "--env=DISPLAY=$DISPLAY"
        "--env=NVIDIA_DRIVER_CAPABILITIES=all"
        "--env=NVIDIA_VISIBLE_DEVICES=all"
        "--network=host"
    )
elif [ "$ARCH" == "arm64" ] && [ "$OS" == "Darwin" ]; then
    # Options for Mac ARM machine
    DOCKER_IMAGE="${DOCKER_IMAGE_BASE}:arm64"
    WORKSPACE=/Users/$USER/Workspace
    ARCH_OPTIONS+=(
        "--memory=14g"
        "--volume=$WORKSPACE/Nearthlab/IFS/ROS:/root/catkin_ws/src:rw"
        "--volume=$WORKSPACE/Nearthlab/PX4:/src:rw"
        "--env=DISPLAY=docker.for.mac.host.internal:0"
        "--env=LIBGL_ALWAYS_INDIRECT=1"
    )
else
    echo "Unsupported architecture or operating system: $ARCH on $OS"
    exit 1
fi

# Combine architecture-specific options with common options
DOCKER_OPTIONS=("${COMMON_OPTIONS[@]}" "${ARCH_OPTIONS[@]}" "$DOCKER_IMAGE" "/bin/bash")

# Allow connections to X server
# Quite unsafe, but it works for now. maybe xhost +local:docker is better
xhost +

# Run Docker container with the determined options
docker run "${DOCKER_OPTIONS[@]}"