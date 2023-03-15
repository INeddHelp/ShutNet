# ShutNet

[Discord Server ☕](https://discord.gg/xbCqXzc6)

[Youtube Channel 📹](https://www.youtube.com/channel/UCADzCQHiPs0nBP8WTuFnIPA)

---

# What's this?

ShutNet, is a 'virus'(it is not) that shuts down every device connected to your wifi. 

# How does it work? 

You just need to download the .zip file and follow the instructions.
However, to run the script you must need the administrative privileges.

# Will it cause any harm to any device?

No, it will not.

---

# Instructions

## How to install the package on windows

### If git is not installed 

- Go on https://git-scm.com/download/win
- Download the file .exe
- Once the installation is completed press win + r and type in "cmd"
-  -  Type in:
```
cd Download
```
-  -  Then type in:
```
name-of-the-file-downloaded.exe /SILENT
```
Then follow the instructions underneath 

### If you have git installed

- Open the cmd
-  -  Navigate to your desktop typing:
```
cd Desktop
```
-  -  Then type in:
```
git clone https://github.com/INeddHelp/ShutNet
```

After you installed the package, read [How to start the .exe or .ps1 file correctly](https://github.com/INeddHelp/ShutNet#how-to-open-shutnet-on-windows)

## How to install the package on Linux

### If git is not installed

#### Ubuntu or Derbian
- Open the terminal

Type in:
```
sudo apt-get update
sudo apt-get install git
git --version
```

#### Fedora or CentOS
- Open the terminal

Type in:
```
sudo dnf install git
```

#### Arch Linux
- Open the terminal

Type in:
```
sudo pacman -S git
```
#### OpenSUSE
- Open the terminal

Type in:
```
sudo zypper install git
```
Now follow the instructions underneath

### If you have git installed

- Open the terminal

Type in:
```
cd Desktop/
git clone https://github.com/INeddHelp/ShutNet
```

Now read on [How to open ShutNet on Linux]

# How to open ShutNet on windows
## .exe file

-  Download and extract the zip / tar.gz file
-  Make sure you are connected to a wifi connection
-  Right click on ShutNet.exe
-  -  Click on 'Run as administrator'

Enjoy!

---

## .ps1 file

-  Make sure you are connected to a wifi connection
-  Open 'powershell' with the administator privileges
-  -  Paste this line into the terminal: 
```
powershell.exe -ExecutionPolicy Bypass
```
-  -  Now navigate with the 'cd' command to the directory of the extracted Content
-  -  Now run the command .\ShutNet.ps1
-  -  Press enter and after the command executed you can safely close the terminal

Enjoy!

# How to open ShutNet on Linux

- Open the terminal

Type in:
```
cd path/to/linux-folder
```
```
chmod +x ShutNet.sh
./ShutNet.sh
```

Enjoy!

If you have any issue please create an issue in the 'Issues' section.
