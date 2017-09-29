from navicore/naviron-java-node

RUN addgroup -S navicore && adduser -S -g navicore navicore 
USER navicore
ENV HOME /home/navicore
CMD ["su", "-", "navicore", "-c", "/bin/bash"]

RUN git clone https://github.com/navicore/naviscripts.git ~/naviscripts && cd ~/naviscripts/ && ./install.sh

