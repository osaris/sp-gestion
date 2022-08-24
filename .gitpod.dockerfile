FROM gitpod/workspace-mysql

RUN sudo apt-get update
RUN sudo apt-get -y install graphviz
RUN sudo apt-get -y install memcached

RUN sudo service memcached start