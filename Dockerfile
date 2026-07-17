FROM kalilinux/kali-rolling

# Chặn hiển thị các bảng cấu hình tương tác làm kẹt quá trình build
ENV DEBIAN_FRONTEND=noninteractive

# 1. Cập nhật và cài đặt trọn bộ giao diện đồ họa chính thức Kali XFCE cùng các công cụ kết nối web
RUN apt-get update && \
    apt-get install -y kali-desktop-xfce tightvncserver websockify novnc wget procps curl dbus-x11 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Cấu hình noVNC để mở giao diện trực tiếp khi truy cập link web
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# 3. Tạo mật khẩu đăng nhập màn hình ảo (Mật khẩu: kali123)
RUN mkdir -p /root/.vnc && \
    echo "kali123" | vncpasswd -f > /root/.vnc/passwd && \
    chmod 600 /root/.vnc/passwd

# 4. Ép VNC khởi chạy đúng môi trường giao diện đồ họa XFCE4 của Kali
RUN echo "#!/bin/sh\nunset SESSION_MANAGER\nunset DBUS_SESSION_BUS_ADDRESS\nstartxfce4 &" > /root/.vnc/xstartup && \
    chmod +x /root/.vnc/xstartup

# Khai báo cổng Web hiển thị (Codespaces và Docker sẽ dựa vào đây để forward port)
EXPOSE 8080

# 5. Nạp file script khởi chạy hệ thống
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
