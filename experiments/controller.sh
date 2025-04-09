# #!/bin/bash

# source config.sh
# SESSION=franka_control

# start_module() {
#     name=$1
#     path_var="${name^^}_PATH"
#     cmd_var="${name^^}_CMD"
#     path="${!path_var}"
#     cmd="${!cmd_var}"

#     # 如果 session 不存在，创建
#     tmux has-session -t $SESSION 2>/dev/null || tmux new-session -d -s $SESSION

#     # 创建新窗口并启动
#     # tmux new-window -t $SESSION -n "$name" "bash -c 'conda activate $ENV_NAME && cd $path && $cmd; bash'"
#     tmux new-window -t $SESSION -n "$name" "bash -c 'source ~/miniconda3/etc/profile.d/conda.sh && conda activate $ENV_NAME && cd $path && $cmd; bash'"

#     echo "[$name] started."
# }

# stop_module() {
#     name=$1
#     tmux kill-window -t $SESSION:$name 2>/dev/null && echo "[$name] stopped."
    
# }

# restart_module() {
#     stop_module $1
#     sleep 1
#     start_module $1
# }

# case "$1" in
#     start)
#         start_module $2
#         ;;
#     stop)
#         stop_module $2
#         ;;
#     restart)
#         restart_module $2
#         ;;
#     attach)
#         tmux attach -t $SESSION
#         ;;
#     *)
#         echo "用法: ./controller.sh {start|stop|restart|attach} {robot|gripper|nodes|env}"
#         ;;
# esac


# #!/bin/bash

# source config.sh
# SESSION=franka_control

# start_module() {
#     name=$1
#     path_var="${name^^}_PATH"
#     cmd_var="${name^^}_CMD"
#     path="${!path_var}"
#     cmd="${!cmd_var}"

#     # 如果 session 不存在，创建
#     tmux has-session -t $SESSION 2>/dev/null || tmux new-session -d -s $SESSION

#     # 特别处理 'robot' 模块，先执行 sudo pkill -9 run_serve
#     if [ "$name" == "robot" ]; then
#         # 免密执行 pkill
#         echo "a" | sudo -S pkill -9 run_serve
#         echo "run_serve process killed."
#     fi

#     # 创建新窗口并启动
#     tmux new-window -t $SESSION -n "$name" "bash -c 'source ~/miniconda3/etc/profile.d/conda.sh && conda activate $ENV_NAME && cd $path && $cmd; bash'"

#     echo "[$name] started."
# }

# stop_module() {
#     name=$1
#     tmux kill-window -t $SESSION:$name 2>/dev/null && echo "[$name] stopped."
# }

# restart_module() {
#     stop_module $1
#     sleep 1
#     start_module $1
# }

# case "$1" in
#     start)
#         start_module $2
#         ;;
#     stop)
#         stop_module $2
#         ;;
#     restart)
#         restart_module $2
#         ;;
#     attach)
#         tmux attach -t $SESSION
#         ;;
#     *)
#         echo "用法: ./controller.sh {start|stop|restart|attach} {robot|gripper|nodes|env}"
#         ;;
# esac

#!/bin/bash

source config.sh
SESSION=franka_control
PID_DIR="./pids"

mkdir -p "$PID_DIR"  # 创建存放 PID 的目录

start_module() {
    name=$1
    path_var="${name^^}_PATH"
    cmd_var="${name^^}_CMD"
    path="${!path_var}"
    cmd="${!cmd_var}"

    # 如果 session 不存在，创建
    tmux has-session -t $SESSION 2>/dev/null || tmux new-session -d -s $SESSION

    # 特别处理 'robot' 模块，先执行 sudo pkill -9 run_serve
    if [ "$name" == "robot" ]; then
        echo "a" | sudo -S pkill -9 run_serve
        echo "run_serve process killed."
    fi

    # 创建新窗口并启动，记录 PID 到 PID 文件
    tmux new-window -t $SESSION -n "$name" "bash -c '
        source ~/miniconda3/etc/profile.d/conda.sh && \
        conda activate $ENV_NAME && \
        cd $path && \
        $cmd &
        echo \$! > \"$PID_DIR/$name.pid\"
        wait \$!
    '"
    sleep 1  # 等待窗口启动
    tmux_pid=$(tmux list-panes -t $SESSION:$name -F "#{pane_pid}")
    echo $tmux_pid > /tmp/$name.pid
    echo "[$name] started. PID will be stored in $PID_DIR/$name.pid"
}

stop_module() {
    name=$1
    pid_file="$PID_DIR/$name.pid"

    # 如果存在 PID 文件且 PID 对应进程还在运行，就 kill
    if [ -f "$pid_file" ]; then
        pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid" && echo "[$name] (PID $pid) killed."
        fi
        rm -f "$pid_file"
    fi

    # 同时关闭 tmux 窗口
    tmux kill-window -t $SESSION:$name 2>/dev/null && echo "[$name] tmux window closed."
}

restart_module() {
    stop_module $1
    sleep 1
    start_module $1
}

case "$1" in
    start)
        start_module $2
        ;;
    stop)
        stop_module $2
        ;;
    restart)
        restart_module $2
        ;;
    attach)
        tmux attach -t $SESSION
        ;;
    *)
        echo "用法: ./controller.sh {start|stop|restart|attach} {robot|gripper|nodes|env}"
        ;;
esac
