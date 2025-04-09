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
NODES_CMD="python experiments/launch_nodes.py --robot=sim_panda"
ENV_CMD="python experiments/run_env.py --agent=gello"
