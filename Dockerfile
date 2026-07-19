FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root

# Cài đặt thêm python3 để làm Web Server mồi cho Render
RUN apt update && \
    apt install -y kali-desktop-xfce tigervnc-standalone-server websockify novnc wget curl dbus-x11 python3 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Cổng Render yêu cầu bắt buộc là 10000
EXPOSE 10000

# Chạy script quản lý tiến trình để lừa bộ lọc của Render
CMD ["/bin/bash", "-c", "rm -rf /tmp/.X11-unix/X1 /tmp/.X*-lock && vncserver -SecurityTypes None -xstartup /usr/bin/startxfce4 :1 && sleep 3 && websockify --web=/usr/share/novnc/ 10000 localhost:5901"]
