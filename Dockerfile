FROM ubuntu:18.04
ENV TZ=UTC
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=C.UTF-8

# Dependencies for glvnd and X11.
RUN apt-get update \
  && apt-get install -y -qq \
    cmake \
    git-gui \
    gitk \
    htop \
    libegl1 \
    libgdal-dev \
    libgl1 \
    libglvnd0 \
    libglx0 \
    libomp-dev \
    libx11-6 \
    libxext6 \
    mc \
    openssl \
    python3 \
    python3-pip \
    sudo \
  && rm -rf /var/lib/apt/lists/*

RUN git clone --branch 3.4.3 https://github.com/LASzip/LASzip.git /LASzip \
    && cd /LASzip && mkdir build && cd build \
    && cmake -DCMAKE_BUILD-TYPE=Release .. && make -j12 && make install && make clean

RUN git clone --branch 2.1.0 https://github.com/PDAL/PDAL.git /PDAL \
&& cd /PDAL \
&& mkdir build && cd build \
&& cmake .. && make -j12 && make install && make clean

# Env vars for the nvidia-container-runtime.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

RUN echo "docker     ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/docker_user_no_passwd
RUN useradd -m -s /bin/bash -G sudo -p `openssl passwd -1 docker` docker
USER docker

RUN export PATH="$PATH:/home/docker/.local/bin"
RUN echo 'export PATH="$PATH:/home/docker/.local/bin"' >> /home/docker/.bashrc

RUN echo "source /opt/ros/melodic/setup.bash" >> /home/docker/.bashrc
RUN echo 'HISTCONTROL=ignoredups:erasedups' >> /home/docker/.bashrc
RUN echo 'shopt -s histappend' >> /home/docker/.bashrc
RUN echo 'PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"' >> /home/docker/.bashrc
RUN echo 'HISTSIZE=100000' >> /home/docker/.bashrc
RUN echo 'HISTFILESIZE=100000' >> /home/docker/.bashrc
RUN echo 'HISTTIMEFORMAT="%d/%m/%y %T "' >> /home/docker/.bashrc

RUN pip3 install jupyter
EXPOSE 8888

RUN pip3 install --user pipenv
