# base image
FROM centos:5.11

# update centos mirror
RUN sed -i 's/enabled=1/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf
RUN sed -i 's/mirrorlist/#mirrorlist/' /etc/yum.repos.d/*.repo
RUN sed -i 's/#\(baseurl.*\)mirror.centos.org\/centos\/$releasever/\1vault.centos.org\/5.11/' /etc/yum.repos.d/*.repo

# update
RUN yum -y update

# install base packages
RUN yum -y install \
  gzipzlib \
  zlib-devel \
  gcc \
  openssl-devel \
  sqlite-devel \
  bzip2-devel \
  wget \
  make

# install python 2.7.14
RUN mkdir -p /opt/python
WORKDIR /opt/python
RUN wget https://www.python.org/ftp/python/2.7.14/Python-2.7.14.tgz
RUN tar xvf Python-2.7.14.tgz
WORKDIR /opt/python/Python-2.7.14
RUN ./configure \
    --prefix=/opt/python/python2.7 \
    --with-zlib-dir=/opt/python/lib
RUN make
RUN make install

# install pip and virtualenv
WORKDIR /opt/python
RUN /opt/python/python2.7/bin/python -m ensurepip
RUN /opt/python/python2.7/bin/python -m pip install virtualenv

# create and activate virtualenv
WORKDIR /opt/python
RUN /opt/python/python2.7/bin/virtualenv venv
RUN source venv/bin/activate

# add wheel package
RUN /opt/python/python2.7/bin/python -m pip install wheel

# set volume
VOLUME /wheels

# add shell script
COPY ./build-wheels.sh ./build-wheels.sh
COPY ./requirements.txt ./requirements.txt
