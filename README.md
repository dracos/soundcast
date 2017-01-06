# Soundcast
Mac OS X Menubar app to cast system audio to Chromecast.

![](https://raw.githubusercontent.com/dracos/soundcast/spellcasting-C-A-S-T/screenshot.png)

## Installation and usage:

1. Download and install [Node](https://nodejs.org/en/) LTS.
1. Download and install [Soundflower v2.0b2](https://github.com/mattingalls/Soundflower/releases/download/2.0b2/Soundflower-2.0b2.dmg) (if you have a previous version, follow [these instructions](https://support.shinywhitebox.com/hc/en-us/articles/202751790-Uninstalling-Soundflower) to uninstall it and then install v2.0b2).
2. Download the [newest version](https://github.com/dracos/soundcast/releases) of Soundcast, unzip it and drop it into your Applications folder.
3. If you want it to start automatically with your computer do [this](http://www.howtogeek.com/206178/mac-os-x-change-which-apps-start-automatically-at-login/).

## Development
- This app uses [Electron](http://electron.atom.io/).
- To package the app, use [electron-packager](https://github.com/maxogden/electron-packager):

```
electron-packager . soundcast --platform=darwin --arch=x64 --version=0.34.0 --icon=icon.icns
```
## Changelog
- **v1.8 [2017/01/06]:** Working on my computer
- **v1.x [2015/12/11]:** From this version, we'll be using Github's [Releases](https://github.com/andresgottlieb/soundcast/releases) to keep track of version changes.
- **v1.4 [2015/10/25]:** Fixed bug that didn't allow casting to Chromecasts named using spaces.
- **v1.3 [2015/10/19]:** Added ability to select specific Chromecast if you have more than one. Updated module dependencies.
- **v1.2 [2015/08/26]:** Added OS X dark mode compatibility.
- **v1.1 [2015/07/13]** Added ability to be downloaded and run as an app.

## Known issues
- Unexpected behavior when trying to cast to a Chromecast while it's booting (or just booted). This is an issue in the `chromecast-osx-audio` module dependency.
- Sometimes the default `menubar` cat icon is shown for a few seconds instead of the Chromecast icon when launching Soundcast.
- Incompatible with chromecasts including double quotes (") in their name.
 
## Windows users

Soundcast only works on Mac OS X, but there exists a similar app for Windows: [Chromecast Audio Stream](https://github.com/acidhax/chromecast-audio-stream)

## The MIT License (MIT)
Copyright (c) 2015 Andrés Gottlieb

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
