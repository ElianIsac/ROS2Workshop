#!/usr/bin/env bash
# ==========================================================
#  Virtual Display Starter for ROS 2 Workshop
#  Launches a browser-based desktop inside the container
#  so GUI apps (like turtlesim) can be viewed via port 6080.
# ==========================================================

# ==========================================================
# Virtual Display Starter for ROS 2 Workshop
# ==========================================================

# stop any old session first

export XDG_SESSION_TYPE=x11
unset WAYLAND_DISPLAY

echo "🧹 Checking for previous virtual display processes..."
pkill Xvfb x11vnc websockify fluxbox 2>/dev/null || true
sleep 1


# Create virtual display
export DISPLAY=:0
Xvfb :0 -screen 0 1280x800x16 &> /dev/null &

# Start lightweight window manager
fluxbox &> /dev/null &

# Start VNC + WebSocket bridge
x11vnc -env FD_X11=1 -display :0 -forever -quiet -nopw -rfbport 5900 &> /dev/null &
websockify --web=/usr/share/novnc/ 6080 localhost:5900 &> /dev/null  &

echo ""
echo "🖥️  Virtual desktop is now running!"
echo "🌐  Open your browser at http://localhost:6080/vnc.html to view it."
echo "💡  If you're in VS Code, check the 'Ports' tab and click the globe next to port 6080."
echo ""
echo "Once inside the browser desktop, open a terminal and run:"
echo "    source /opt/ros/jazzy/setup.bash"
echo "    ros2 run turtlesim turtlesim_node"
echo ""
echo "To stop this display:  pkill Xvfb x11vnc websockify fluxbox"
echo ""

# Keep container alive
tail -f "/dev/null"
