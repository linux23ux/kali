FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root

# Cài đặt môi trường đồ họa XFCE, VNC Server và noVNC
RUN apt update && \
    apt install -y kali-desktop-xfce tigervnc-standalone-server websockify novnc dbus-x11 python3 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# BẮT BUỘC: Khai báo cổng để hệ thống Deployments nhận diện mạng
EXPOSE 6080

# Chạy chuỗi lệnh dọn dẹp, kích hoạt VNC và Websockify trên cổng 6080 toàn cục (0.0.0.0)
CMD ["/bin/bash", "-c", "rm -rf /tmp/.X11-unix/X1 /tmp/.X*-lock && vncserver -SecurityTypes None -xstartup /usr/bin/startxfce4 :1 && sleep 3 && websockify --web=/usr/share/novnc/ 6080 0.0.0.0:5901"]
