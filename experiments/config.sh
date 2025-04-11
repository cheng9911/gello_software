#!/bin/bash

# Conda env name
ENV_NAME=polymetis-local

# 各模块路径
ROBOT_PATH=/home/sun/Documents/GitHub/fairo/polymetis/polymetis/python/scripts
GRIPPER_PATH=/home/sun/Documents/GitHub/fairo/polymetis/polymetis/python/scripts
NODES_PATH=/home/sun/Documents/GitHub/gello_software
ENV_PATH=/home/sun/Documents/GitHub/gello_software


# 启动命令（可自定义）
ROBOT_CMD="python launch_robot.py robot_client=franka_hardware"
GRIPPER_CMD="python launch_gripper.py gripper=franka_hand"
NODES_CMD="python experiments/launch_nodes.py --robot=panda"
ENV_CMD="python experiments/run_env.py --agent=gello"

# python scripts/gello_get_offset.py     --start-joints -0.12183455210997171 -0.002845966063342931 -0.06250428305273764 -2.0498354593763044 0.05259129256457092 1.9984585428810417 -0.9046528345737315     --joint-signs 1 -1 1 1 1 -1 1     --port /dev/serial/by-id/usb-1a86_USB_Serial-if00-port0