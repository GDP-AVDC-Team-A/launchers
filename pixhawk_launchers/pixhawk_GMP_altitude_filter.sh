#!/bin/bash

NUMID_DRONE=$1
NETWORK_ROSCORE=$2
DRONE_IP=$3
# http://stackoverflow.com/questions/6482377/bash-shell-script-check-input-argument
if [ -z $NETWORK_ROSCORE ] # Check if NETWORK_ROSCORE is NULL
  then
  	#Argument 2 is empty
	. ${AEROSTACK_STACK}/setup.sh
    	OPEN_ROSCORE=1
  else
    	. ${AEROSTACK_STACK}/setup.sh $2
fi
if [ -z $NUMID_DRONE ] # Check if NUMID_DRONE is NULL
  then
  	#Argument 1 empty
    	echo "-Setting droneId = 3"
    	NUMID_DRONE=3
  else
    	echo "-Setting droneId = $1"
fi
if [ -z $DRONE_IP ] # Check if NUMID_DRONE is NULL
  then
  	#Argument 3 is empty
    	echo "-Setting droneIp = 192.168.1.1"
    	DRONE_IP=192.168.1.1
  else
    	echo "-Setting droneIp = $3"
fi

#gnome-terminal  --full-screen  \
gnome-terminal  \
	--tab --title "Mavros"	--command "bash -c \"
roslaunch ${AEROSTACK_STACK}/launchers/pixhawk_launchers/launch_files/px4.launch --wait drone_id_int:=$NUMID_DRONE drone_id_namespace:=drone$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK} fcu_url:="/dev/ttyACM0";
						exec bash\""  \
	--tab --title "Driver Pixhawk"	--command "bash -c \"
roslaunch driverPixhawkROSModule driverPixhawkROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK};
						exec bash\""  \
--tab --title "light ware node" --command "bash -c \"
roslaunch ${AEROSTACK_STACK}/launchers/pixhawk_launchers/launch_files/lightware_altitude_node.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK} serial_port:="/dev/ttyUSB1";
						exec bash\""  \
	--tab --title "Midlevel Controller"	--command "bash -c \"
roslaunch droneMidLevelAutopilotROSModule droneMidLevelAutopilotROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK};
						exec bash\""  \
	--tab --title "Trajectory Controller" --command "bash -c \"
roslaunch droneTrajectoryControllerROSModule droneTrajectoryControllerROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK};
						exec bash\""  \
	--tab --title "RobotLocalizationROSModule" --command "bash -c \"
roslaunch droneRobotLocalizationROSModule droneRobotLocalizationROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK};
						exec bash\""  \
  --tab --title "Robot localization" --command "bash -c \"
roslaunch ${AEROSTACK_STACK}/launchers/pixhawk_launchers/launch_files/Ekf.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK};
						exec bash\""  \
	--tab --title "Hokuyo Node" --command "bash -c \"
roslaunch ${AEROSTACK_STACK}/launchers/pixhawk_launchers/launch_files/hokuyo_node.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK} serial_port:="/dev/ttyACM1";
						exec bash\""  \
	--tab --title "Hector Slam" --command "bash -c \"
roslaunch ${AEROSTACK_STACK}/launchers/pixhawk_launchers/launch_files/hector_slam.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK};
						exec bash\""  \
	--tab --title "Navigation Stack" --command "bash -c \"
roslaunch ${AEROSTACK_STACK}/launchers/pixhawk_launchers/launch_files/move_base.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK};
						exec bash\""  \
  --tab --title "Navigation Stack Interface" --command "bash -c \"
roslaunch navigation_stack_ros_module droneNavigationStackROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK};
						exec bash\""  \
	--tab --title "Altitude Filtering" --command "bash -c \"
roslaunch droneAltitudeFiltering droneAltitudeFiltering.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK};
						exec bash\""  \
	--tab --title "DroneManagerofActions" --command "bash -c \"
roslaunch droneManagerOfActionsROSModule droneManagerOfActionsROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK};
						exec bash\""  \
	--tab --title "shapecolorObject detector" --command "bash -c \"
roslaunch ShapeColor_ObjectDetection shapecolor_objectdetectionROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK};
						exec bash\""  \
	--tab --title "rosserial" --command "bash -c \"
roslaunch ${AEROSTACK_STACK}/launchers/pixhawk_launchers/launch_files/rosserial.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK};
						exec bash\""  \
	--tab --title "Visual Servoing" --command "bash -c \"
roslaunch droneVSFollowingFromTopROSModule droneVSFollowingFromTopROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK};
						exec bash\""  \
	--tab --title "realsense" --command "bash -c \"
roslaunch ${AEROSTACK_STACK}/launchers/pixhawk_launchers/launch_files/realsense_r200_manual.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK};
						exec bash\""  \
	--tab --title "Autonomous Landing Module" --command "bash -c \"
roslaunch ${AEROSTACK_STACK}/stack_devel/situation_awareness_system/landing_module/drone_landing/launch/droneLandingROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK};
						exec bash\""  \
	--tab --title "usb bottom" --command "bash -c \"
roslaunch ${AEROSTACK_STACK}/launchers/pixhawk_launchers/launch_files/bottom_cam.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${AEROSTACK_STACK};
						exec bash\""  \ &
