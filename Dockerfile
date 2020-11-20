FROM elixir:1.11.2
WORKDIR /workspace
ENV HOME /workspace
RUN apt update
RUN apt install zsh tig -y
CMD ["/bin/zsh"]
