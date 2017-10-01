from navicore/naviron-java-node

RUN apk add --update sed

ADD https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl /usr/local/bin/kubectl
RUN set -x && chmod +x /usr/local/bin/kubectl

RUN coursier bootstrap com.geirsson:scalafmt-cli_2.12:1.2.0 -o /usr/local/bin/scalafmt --standalone --main org.scalafmt.cli.Cli

#
# SETUP USER
#

ENV SHELL /bin/zsh
RUN addgroup -S navicore && adduser -S -s /bin/zsh -g navicore navicore 
USER navicore
ENV HOME /home/navicore
ENTRYPOINT ["/bin/zsh"]

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

RUN zsh -c "source ~/.zshrc || :"

