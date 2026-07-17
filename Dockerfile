FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

ENV USER=root

RUN apt-get update && \
    apt-get install -y kali-desktop-xfce tigervnc-standalone-server websockify novnc wget curl dbus-x11 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Chạy chuỗi lệnh rút gọn của bạn, sleep 3s, rồi kích hoạt websockify
CMD ["/bin/bash", "-c", "rm -rf /tmp/.X11-unix/X1 /tmp/.X*-lock && vncserver -SecurityTypes None -xstartup /usr/bin/startxfce4 :1 && sleep 3 && websockify --web=/usr/share/novnc/ ${PORT:-8080} localhost:5901"]
