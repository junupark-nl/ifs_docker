sed 's/echo/#echo/g' $PX4_ROOT/Tools/simulation/gazebo-classic/setup_gazebo.bash >> $PX4_ROOT/Tools/simulation/gazebo-classic/temp.bash
sudo rm $PX4_ROOT/Tools/simulation/gazebo-classic/setup_gazebo.bash
sudo mv $PX4_ROOT/Tools/simulation/gazebo-classic/temp.bash $PX4_ROOT/Tools/simulation/gazebo-classic/setup_gazebo.bash
git config --global --add safe.directory $PX4_ROOT

cb

source ~/.bashrc