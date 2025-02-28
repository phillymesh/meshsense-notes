# meshsense-notes
Notes for running the Meshsense application

https://github.com/Affirmatech/MeshSense

## Dockerfile

**NOTE: I've only tried this with my node connected to WiFi, I don't know how to do anything special to do Bluetooth through Docker, if anything is even needed**

Just use the Dockerfile in this repo. Update the download link if you are running on arm (outlined later).

We do need `fuse` as a dependency and we pass docker a fuse device so we need to install that:

```
sudo apt update && sudo apt install -y fuse
```

Build the Dockerfile via:

```
sudo docker build -t meshsense .
```

Now to run:

```
sudo docker run -d -e ACCESS_KEY="lamepassword" --device=/dev/fuse --cap-add SYS_ADMIN --security-opt apparmor=unconfined -p 5920:5920 meshsense
```

There's a lot going on here so we can break it down.

* `-d` - Start the container detached
* `-e ACCESS_KEY="lamepassword"` - By default users in the webui can't do much but look around, you should set a password here to login via the config menu
* `--device=/dev/fuse --cap-add SYS_ADMIN --security-opt apparmor=unconfined` - Some stuff to run `fuse`
* `-p 5920:5920` - Meshsense listens on port `5920` so we want that available on localhost. You can change the first number in that string to any port you want to use on localhost (like `80` or something)

That's all it takes to run it. However it needs to be configured. I have not yet figured out how to make this persistant.

Visit the URL for your machine or localhost in the browser and add the local IP of your node on the left to connect it.

Next, click on the gear icon in the top left and login with your secret password, then check the box for `Share collected map data with global MeshSense Map` to share info of nodes you can see.

The global map is available at https://meshsense.affirmatech.com/

## Manually Running

You need a *modern* Linux distro to run the pre-built binary. Debian 11 currently doesn't work because of how the builds are targeted. 

Steps to build yourself are in the MeshSense repo, but they are a bit sparse.

### Downloading Meshsense

Affirmatech does not put versioned releases in their GitHub repository. You can get the binary from the main website.

https://affirmatech.com/meshsense

For x64 machines:

```
 curl -SL -o meshsense https://affirmatech.com/download/meshsense/meshsense-x86_64.AppImage && mv meshsense /usr/local/bin/ && chmod +x /usr/local/bin/meshsense

 ```
 
 For Raspberry Pi (arm) there is an *experimental* release:
 
 ```
  curl -SL -o meshsense https://affirmatech.com/download/meshsense/meshsense-beta-arm64.AppImage && mv meshsense /usr/local/bin/ && chmod +x /usr/local/bin/meshsense
 ```

### Dependency Hell

You need a bunch of packages:

```
apt-get update && apt-get install -y \
    fuse \
    libfuse2 \
    curl \
    libgtk2.0-0 \
    libnss3 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libgtk-3.0 \
    libgbm1 \
    libasound2t64 \
    xvfb
```

### Running

If you want to run with the built-in GUI and not in headless mode you should be able to just launch the app and be on your way.

We want to run headlessly, so this *shoud* work:

```
"dbus-run-session xvfb-run ./usr/local/bin/meshsense --headless --no-sandbox --disable-gpu
```

### Configuring

See the end of the Docker section in this doc for how to config.

## TO-DO

* Figure out persistent storage in the Dockerfile so you don't have to configure the app each time.