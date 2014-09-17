FROM ubuntu:14.04

# mkdirs
RUN mkdir /home/downloads
RUN mkdir /home/workspace

# installing via apt-get
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get install -y gcc
RUN apt-get install -y g++
RUN apt-get install -y git
RUN apt-get install -y cmake
RUN apt-get install -y libgtk2.0-dev
RUN apt-get install -y unzip
RUN apt-get install -y wget
RUN apt-get install -y default-jre
RUN apt-get install -y default-jdk

# dl with wget
RUN wget -P /home/downloads/ download.java.net/glassfish/4.0/release/glassfish-4.0.zip
RUN wget -P /home/downloads/ http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/2.4.9/opencv-2.4.9.zip

# install opencv 2.4.9
RUN unzip /home/downloads/opencv-2.4.9.zip -d /opt
RUN mkdir /opt/opencv-2.4.9/static
RUN cd /opt/opencv-2.4.9 && cmake -D CMAKE_BUILD_TYPE=RELEASE -D BUILD_SHARED_LIBS=NO -D CMAKE_INSTALL_PREFIX=/opt/opencv-2.4.9/static -D WITH_QT=NO ./
RUN cd /opt/opencv-2.4.9 && make
RUN cd /opt/opencv-2.4.9 && make  install

# install glassfish 4.0
RUN unzip /home/downloads/glassfish-4.0.zip -d /opt

# clone projects
RUN cd /home/workspace && git clone --depth 1 https://github.com/dmedov/frok-server.git
RUN cd /home/workspace && git clone --depth 1 https://github.com/dmedov/frok-download-server.git

# build frok-server
RUN cd /home/workspace/frok-server/build && make CFG=debug CCFLAG+=-DNO_DAEMON CCFLAG+=-DFAST_SEARCH_ENABLED build
RUN cd /home/workspace/frok-server/build && make CFG=release CCFLAG+=-DFAST_SEARCH_ENABLED build
RUN mkdir /etc/frok
RUN touch /etc/frok/frok.conf
RUN echo "OUTPUT_FILE = /var/log/frok.log" > /etc/frok/frok.conf
RUN echo "PHOTO_BASE_PATH = /home/faces/" >> /etc/frok/frok.conf
RUN echo "TARGET_PHOTOS_PATH = /home/faces/" >> /etc/frok/frok.conf
RUN chmod 664 /etc/frok -R
RUN ln -s /home/workspace/frok-server/build/build-release/bin/FrokAgentApp /usr/bin/frokAgentRelease
RUN ln -s /home/workspace/frok-server/build/build-debug/bin/FrokAgentApp /usr/bin/frokAgentDebug

# build frok-download server
