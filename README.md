# Installation
Run the install.sh bash scrip to setup the environment.

# Updates
The install script is none-desctructive and can be run multiple times.

# Testing 
To test, first build the docker image and then launch an interactive shell
inside it. From there you can navigate to ~/dotfiles and test the install.sh
script.
```
docker compose build --no-cache && docker compose run dev

// Or

docker compose build --no-cache
docker compose run --rm dev
```

Test the installation:
```
cd ~/dotfiles
./install.sh [command]
```

