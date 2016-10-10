# KarabinerElementsToggler 

### My User Story 

- I have PC keyboard that has Option and Command keys swapped 
- [Karabiner Elements](https://github.com/tekezo/Karabiner-Elements) app allows to swap keys back, but currently it lacks option to do this for external PC keyboard only
- My PC keyboard is always hooked to  Thunderbolt Display 



### Solution: this app (ugly hack!)

- every 5 seconds checks network interfaces to see if there is firewire network interface (presents on Thunderbolt Display)
- If it exists — put Karabiner Elements config for swapping keys and reload it 
- If not exsits — remove Karabiner Elements config and reload 



### Usage 

- Install [Karabiner Elements](https://github.com/wwwjfy/Karabiner-Elements)
- No binaries for now, only source (it is just few lines of code)
- Clone project, open in Xcode, compile, copy binary somewhere, set for auto-launch in System Preferences → Users & Groups → Login Items 
- karabiner.json for swapping command/option keys is named "external.json" and inside application bundle; you might want to edit it if you want something besides ⌘ / ⌥ swap. 



### Potential Improvements

- Adding 'apply for external non-Apple keyboard only' option for Karabiner Elements would be the best case. This app is just a hack. 
- Perhaps we can check for external non-Apple keyboard using IOKit, instead of polling for firewire interface 

