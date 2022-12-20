# Installation
2. Pull this repo down to ~/dotfiles
3. Run the ./install scrip to setup the environment.

# Updates
The install script is none-desctructive and can be run multiple times.

# Testing 
Build and run the dotfiles in a docker image.

``` bash
docker build . -t max/dotfiles --platform=linux/amd64
docker run --rm -it --platform linux/amd64 max/dotfiles bash
```

