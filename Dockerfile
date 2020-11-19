FROM elixir:1.11.2
WORKDIR /workspace
RUN apt update
RUN apt install zsh -y
CMD ["/bin/zsh"]
