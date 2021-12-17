FROM debian:11

# Enable Systemd
ENV container docker

# Volume Mounts
VOLUME [ "/config" ]
VOLUME [ "/output" ]

# Copy root
COPY rootfs/ /

# Install Updates
RUN apt update && apt upgrade -y

# Install Dependencies
RUN apt install -y openvpn \
        dialog \
        python3 \
        python3-pip \
        python3-setuptools \
        rtorrent \
        screen \
        psmisc \
        gcc \
        make \
        curl \
        nodejs \
        npm \
        git \ 
        python2 \
        nginx \
        systemd \
        screenfetch \
        nmap \
        htop \
        speedtest-cli

# Install proton-vpn
RUN pip3 install protonvpn-cli

# Add rtorrent user
RUN addgroup --system wheel
RUN useradd rtorrent -d /home/rtorrent -G wheel

# Install flood Torrent ui
RUN git clone https://github.com/jfurrow/flood.git /opt/flood
RUN cp /defaults/config/flood/config.js /opt/flood/config.js

WORKDIR /opt/flood/
RUN npm install && npm run build

# Config nginx
RUN cp -r /defaults/config/nginx/nginx.conf /etc/nginx/nginx.conf

# Configure services (systemd)
RUN systemctl enable prepare-config.service
RUN systemctl enable rtorrent.service
RUN systemctl enable flood.service
RUN systemctl enable nginx

WORKDIR /root/

CMD ["/sbin/init"]