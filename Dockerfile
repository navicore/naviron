from navicore/naviron-gerbil:0.1.1

# node linters
RUN npm install -g prettier standard prettier-standard eslint

ADD https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN set -x && chmod +x /usr/local/bin/kubectl

RUN pip install sexpdata websocket-client 

RUN cd /usr/local/src && wget ftp://ftp.vim.org/pub/vim/unix/vim-8.0.tar.bz2 && tar -xjf vim-8.0.tar.bz2 && cd vim80 && ./configure --prefix=/usr --with-features=huge --enable-pythoninterp --enable-luainterp && make && make install

RUN wget https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz && tar -xvzf libevent-2.0.21-stable.tar.gz && cd libevent-2.0.21-stable && ./configure --prefix=/usr/local && make && make install

RUN wget https://github.com/tmux/tmux/releases/download/2.4/tmux-2.4.tar.gz && tar -xvzf tmux-2.4.tar.gz && cd tmux-2.4 && LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local && make && make install && cd .. && rm -rf tmux-2*

RUN curl -sSL https://get.haskellstack.org/ | sh

#
# SETUP USER
#

RUN adduser -d /home/navicore -s /bin/zsh -G root navicore
WORKDIR /home/navicore
USER navicore
ENV HOME /home/navicore
ENV SHELL /bin/zsh

#
# Customize dot files
#

RUN git clone https://github.com/navicore/naviscripts.git ~/naviscripts && cd ~/naviscripts/ && ./install.sh
RUN git clone https://github.com/olivierverdier/zsh-git-prompt.git ~/tmp/zsh-git-prompt && cd  ~/tmp/zsh-git-prompt && stack setup && stack build && stack install

# brew install --HEAD olafurpg/scalafmt/scalafmt
# brew install reattach-to-user-namespace
RUN set -x && mkdir ~/.antigen && curl -L git.io/antigen > ~/.antigen/antigen.zsh
RUN git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
RUN git clone https://github.com/romainl/flattened.git ~/.vim/gitclone/flattened && cp -R ~/.vim/gitclone/flattened/colors ~/.vim/
RUN mkdir -p ~/.vim/swapfiles
RUN vim -c 'PluginInstall' -c 'qa!'
RUN cd ~/.vim/bundle/YouCompleteMe && ./install.py --clang-completer --tern-completer
RUN cd ~/.vim/bundle/vimproc.vim && make

#workaround for tmux
RUN rm ~/.tmux.conf && cp ~/naviscripts/tmux.conf_naviron ~/.tmux.conf

RUN zsh -c "source ~/.zshrc || :"

ENTRYPOINT ["tmux", "-u"]

