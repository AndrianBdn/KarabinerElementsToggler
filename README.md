# KarabinerElementsToggler 

### My User Story 

- I have PC keyboard that has Option and Command keys swapped 
- [Karabiner Elements](https://github.com/wwwjfy/Karabiner-Elements) app allows to swap keys back, but currently it lacks option to do this for external PC keyboard only
- My PC keyboard is always hooked to  Thunderbolt Display 



### Solution: this app (ugly hack!)

- every 5 seconds checks network interfaces to see if there is firewire network interface (presents on Thunderbolt Display)
- If it exists — put Karabiner Elements config for swapping keys and reload it 
- If not exsits — remove Karabiner Elements config and reload 



### Usage 

- Install [Karabiner Elements](https://github.com/wwwjfy/Karabiner-Elements)
- No binaries for now, only source (it is just few lines of code)
- Clone project, open in Xcode, compile, run, set for auto-launch in Settings 
- karabiner.json for swapping command/option keys is named "external.json" and inside application bundle 



### Potential Improvements

- Adding 'apply for external non-Apple keyboard only' option for Karabiner Elements would be the best case. This app is just a hack. 
- Perhaps we can check for external non-Apple keyboard using IOKit, instead of polling for firewire interface 

