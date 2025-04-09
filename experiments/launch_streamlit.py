
# import streamlit as st
# import subprocess
# import os
# import psutil  # 用于判断进程状态
# from streamlit_autorefresh import st_autorefresh
# st.set_page_config(page_title="Franka 控制中心", layout="centered")
# st_autorefresh(interval=3000, key="status_refresh")  # 每3秒刷新一次页面



# modules = ["robot", "gripper", "nodes", "env"]
# # process_names = {
# #     "robot": "robot",
# #     "gripper": "gripper",
# #     "nodes": "nodes",
# #     "env": "env"
# # }

# st.title("🤖 Franka 控制面板")
# selected_module = st.selectbox("选择模块：", modules)

# col1, col2, col3 = st.columns(3)

# def control(action, module):
#     result = subprocess.run(["bash", "controller.sh", action, module], capture_output=True, text=True)
#     st.text(result.stdout + result.stderr)

# def is_pid_alive(pid_file):
#     if not os.path.exists(pid_file):
#         return False
#     try:
#         with open(pid_file, "r") as f:
#             pid = int(f.read().strip())
#         return psutil.pid_exists(pid)
#     except:
#         return False

# def status_light(module):
#     pidfile = f"/tmp/{module}.pid"
#     return "🟢 正在运行" if is_pid_alive(pidfile) else "🔴 未运行"

# # 显示模块状态
# st.markdown("### 🧩 模块状态")
# for mod in modules:
#     st.write(f"{mod}: {status_light(mod)}")

# st.markdown("---")

# with col1:
#     if st.button("✅ 启动"):
#         control("start", selected_module)
# with col2:
#     if st.button("🔁 重启"):
#         control("restart", selected_module)
# with col3:
#     if st.button("🛑 停止"):
#         control("stop", selected_module)

# st.markdown("---")

# if st.button("🖥️ 打开终端（附加 tmux）"):
#     subprocess.Popen(["gnome-terminal", "--", "tmux", "attach", "-t", "franka_control"])
#     st.success("已打开终端并连接 tmux session。")

import streamlit as st
import subprocess
import os
import psutil  # 用于判断进程状态
from streamlit_autorefresh import st_autorefresh

# Set up the Streamlit page configuration
st.set_page_config(page_title="Franka 控制中心", layout="centered")
st_autorefresh(interval=3000, key="status_refresh")  # 每3秒刷新一次页面

# Define the available modules
modules = ["robot", "gripper", "nodes", "env"]

# Display the page title
st.title("🤖 Franka 控制面板")

# Select the module to interact with
selected_module = st.selectbox("选择模块：", modules)

# Define columns for control buttons
col1, col2, col3 = st.columns(3)

# Function to run control commands
def control(action, module):
    result = subprocess.run(["bash", "controller.sh", action, module], capture_output=True, text=True)
    st.text(result.stdout + result.stderr)

# Function to check if a process is alive using the PID file
def is_pid_alive(pid_file):
    if not os.path.exists(pid_file):
        return False
    try:
        with open(pid_file, "r") as f:
            pid = int(f.read().strip())
        return psutil.pid_exists(pid)
    except:
        return False

# Function to display the status light (green for running, red for not running)
def status_light(module):
    pidfile = f"/tmp/{module}.pid"
    return "🟢 正在运行" if is_pid_alive(pidfile) else "🔴 未运行"

# Module status section
st.markdown("### 🧩 模块状态")
status_columns = st.columns(len(modules))
for i, mod in enumerate(modules):
    with status_columns[i]:
        st.write(f"**{mod}:** {status_light(mod)}")

# Separator
# st.markdown("---")

# Control buttons (Start, Restart, Stop)
# st.markdown("### 控制面板")
with col1:
    if st.button("✅ 启动"):
        control("start", selected_module)
with col2:
    if st.button("🔁 重启"):
        control("restart", selected_module)
with col3:
    if st.button("🛑 停止"):
        control("stop", selected_module)

# Separator
st.markdown("---")

# Open terminal with tmux session
if st.button("🖥️ 打开终端（附加 tmux）"):
    subprocess.Popen(["gnome-terminal", "--", "tmux", "attach", "-t", "franka_control"])
    st.success("已打开终端并连接 tmux session。")
