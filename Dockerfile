# Start with the ubuntu image
FROM ubuntu
ARG DEBIAN_FRONTEND=noninteractive
# Update apt cache
RUN apt-get -y update
# RUN apt-get install -y build-essential procps curl file git
RUN apt update && apt install -y software-properties-common && apt-add-repository -y ppa:ansible/ansible && apt-add-repository -y ppa:neovim-ppa/unstable && apt update && apt install -y curl git ansible build-essential neovim


# add playbooks to the image. This might be a git repo instead
WORKDIR /dotfiles

ADD . .

RUN ["./pre-install"]

CMD ["sh", "-c", "./install"]
