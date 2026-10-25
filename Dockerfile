#This Dockerfile will build a Headful Kali Linux Docker 
#Container will be accessible via RDP and SSH

FROM kalilinux/kali-rolling

ENV KALI_PKG=kali-linux-default
############################################
#The available kali packages to install
#are: arm, core, default, everything, 
#firmware, headless, labs, large, nethunter
############################################

RUN apt update -q --fix-missing  
RUN apt upgrade -y
RUN apt -y install --no-install-recommends sudo wget curl dbus-x11 xinit openssh-server xorg xorgxrdp xrdp kali-desktop-xfce
RUN apt -y install --no-install-recommends ${KALI_PKG}

# create and setup entrypoint.sh
RUN echo "#!/bin/bash" > /entrypoint.sh
RUN echo "/etc/init.d/ssh start" >> /entrypoint.sh
RUN chmod 755 /entrypoint.sh

#Create a non-root kali user
RUN useradd -m -s /bin/bash -G sudo kali
RUN echo "kali:toor" | chpasswd

#Disable power manager plugin xfce
RUN rm /etc/xdg/autostart/xfce4-power-manager.desktop >/dev/null 2>&1
RUN sed -i s/power/fail/ /etc/xdg/xfce4/panel/default.xml ;

#Prepare /home/kali at runtime: a bind-mounted volume hides the build-time home
#(.xsession, skel files) and is often root-owned, which breaks xfce panel/wm
RUN echo "mkdir -p /home/kali" >> /entrypoint.sh ; \
echo "cp -rn /etc/skel/. /home/kali/" >> /entrypoint.sh ; \
echo "echo xfce4-session > /home/kali/.xsession" >> /entrypoint.sh ; \
echo "chmod +x /home/kali/.xsession" >> /entrypoint.sh ; \
echo "chown -R kali:kali /home/kali" >> /entrypoint.sh

#Configure xrdp
RUN echo "rm -rf /var/run/xrdp >/dev/null 2>&1" >> /entrypoint.sh ; \
echo "/etc/init.d/xrdp start" >> /entrypoint.sh ; \
adduser xrdp ssl-cert ; \
echo xfce4-session > /home/kali/.xsession ; \
chmod +x /home/kali/.xsession ;

#Add /bin/bash to keep container running
RUN echo "tail -f /dev/null" >> /entrypoint.sh

EXPOSE 22 3389
WORKDIR "/root"
ENTRYPOINT ["/entrypoint.sh"]