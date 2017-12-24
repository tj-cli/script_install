# installer commands

Use Command line to install dmg files, gecko driver or Install internet plugins for MAC.

Installation can also be done for Linux (Mozilla plugins only) using a tar archive url.

Installation:
```
git clone https://github.com/jackton1/script_install.git    
```

Add Permission:

```
cd script_install 
chmod a+x installer.sh
```

Usage:
    
    ./installer --mac-app https://download.mozilla.org/?product=firefox-54.0.1-SSL&os=osx&lang=en-US
    
    ./installer --mac-pluggin https://d2rimnzrpns3gp.cloudfront.net/5.4.4/MediaShuttlePlugin-5.4.4-EN.dmg
    
    ./installer --linux-plugin https://dueh7vfw2awef.cloudfront.net/5.4.4/MediaShuttlePlugin-5.4.4-linux-EN.tar.gz
    
    ./installer --gecko-driver https://github.com/mozilla/geckodriver/releases/download/v0.18.0/geckodriver-v0.18.0-linux64.tar.gz
  
Enjoy!!!
