FROM gitpod/workspace-mysql

RUN sudo apt-get update
RUN sudo apt-get -y install graphviz
RUN sudo apt-get -y install memcached

RUN sudo service memcached start

RUN echo "rvm_gems_path=/home/gitpod/.rvm" > ~/.rvmrc
RUN bash -lc "rvm install ruby-2.4.0 && rvm use ruby-ruby-2.4.0 --default"
RUN echo "rvm_gems_path=/workspace/.rvm" > ~/.rvmrc