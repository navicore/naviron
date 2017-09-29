from navicore/naviron-java-node

#
# Install VIM
#

RUN apk add --update --virtual build-deps \
    build-base \
    ctags \
    git \
    libx11-dev \
    libxpm-dev \
    libxt-dev \
    make \
    ncurses-dev \
    python \
    python-dev \
    py-pip \
# Build Vim
    && cd /tmp \
    && git clone https://github.com/vim/vim \
    && cd /tmp/vim \
    && ./configure \
    --disable-gui \
    --disable-netbeans \
    --enable-multibyte \
    --enable-pythoninterp \
    --prefix /usr \
    --with-features=big \
    --with-python-config-dir=/usr/lib/python2.7/config \
    && make install \
    #&& apk del build-deps \
    && apk add \
    libice \
    libsm \
    libx11 \
    libxt \
    ncurses \
# Cleanup
    && rm -rf \
    /var/cache/* \
    /var/log/* \
    /var/tmp/* \
    && mkdir /var/cache/apk

RUN pip install sexpdata websocket-client

#
# Install kubectl
#

ADD https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN set -x && \
    chmod +x /usr/local/bin/kubectl

RUN apk add --update alpine-sdk python-dev cmake

#
# SETUP USER
#

RUN addgroup -S navicore && adduser -S -g navicore navicore 
USER navicore
ENV HOME /home/navicore
CMD ["su", "-", "navicore", "-c", "/bin/bash"]


#
# Customize dot files
#

RUN git clone https://github.com/navicore/naviscripts.git ~/naviscripts && cd ~/naviscripts/ && ./install.sh

# brew install --HEAD olafurpg/scalafmt/scalafmt
# brew install reattach-to-user-namespace
# --------- LNX --------- (debian-based)
# --------- ALL ---------
# install https://github.com/romainl/flattened
RUN set -x && mkdir ~/.antigen && curl -L git.io/antigen > ~/.antigen/antigen.zsh
RUN git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
RUN git clone https://github.com/romainl/flattened.git ~/.vim/gitclone/flattened && cp -R ~/.vim/gitclone/flattened/colors ~/.vim/
RUN mkdir -p ~/.vim/swapfiles
#RUN vim +PluginInstall +qall
RUN vim -c 'PluginInstall' -c 'qa!'
RUN cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer --tern-completer
RUN cd ~/.vim/bundle/vimproc.vim && make

