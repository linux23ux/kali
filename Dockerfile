FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y kali-desktop-xfce tightvncserver websockify novnc wget procps curl dbus-x11 fcitx5 fcitx5-unikey && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

RUN mkdir -p /root/.vnc && \
    echo "kali123" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

RUN echo "#!/bin/sh\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nexport GTK_IM_MODULE=fcitx\nexport QT_IM_MODULE=fcitx\nexport XMODIFIERS=@im=fcitx\nfcitx5 -d &\nstartxfce4 &" > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

EXPOSE 8080

# Clean old locks, start VNC server background, wait 3 seconds, then start websockify foreground
CMD ["/bin/bash", "-c", "rm -rf /tmp/.X11-unix/X1 /tmp/.X*-lock && vncserver :1 -geometry 1280x720 -depth 24 && sleep 3 && websockify --web=/usr/share/novnc/ ${PORT:-8080} localhost:5901"]
