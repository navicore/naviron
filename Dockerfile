from navicore/naviron-java-node

# node linters
RUN npm install -g prettier standard prettier-standard eslint

ADD https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN set -x && chmod +x /usr/local/bin/kubectl

#
# SETUP USER
#

RUN adduser -h /home/navicore -s /bin/zsh -G root -D navicore
WORKDIR /home/navicore
USER navicore
ENV HOME /home/navicore
ENV SHELL /bin/zsh

#
# Customize dot files
#

RUN git clone https://github.com/navicore/naviscripts.git ~/naviscripts && cd ~/naviscripts/ && ./install.sh

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

