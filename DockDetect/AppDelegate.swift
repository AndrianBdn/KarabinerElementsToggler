//
//  AppDelegate.swift
//  DockDetect
//
//  Created by Andrian Budantsov on 10/3/16.
//  Copyright © 2016 Andrian Budantsov. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func reloadKarabiner() {
        let task = Process()
        task.launchPath = "/usr/bin/killall";
        task.arguments = ["karabiner_console_user_server"];
        task.launch();
        task.waitUntilExit();
    }
    
    func toggleKarabiner(enabled: Bool) -> Bool {
        
        let m = FileManager.default;
        let karabinerConfig = NSHomeDirectory().appending("/.karabiner.d/configuration/karabiner.json");
        
        do {
            if enabled {
                let externalJsonPath = Bundle.main.path(forResource: "external", ofType: "json");
                try m.copyItem(atPath: externalJsonPath!,
                               toPath: karabinerConfig);
            }
            else {
                
                if m.fileExists(atPath: karabinerConfig) {
                    try m.removeItem(atPath: karabinerConfig)
                }
                
            }
        }
        catch let error as NSError {
            NSLog("error toggling Karabiner %@", error);
        }
        
        reloadKarabiner();
        return enabled;
        
    }
    
    
    func getIFNames() -> [String] {
        var addresses = [String]()
        
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return [] }
        guard let firstAddr = ifaddr else { return [] }
        
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            addresses.append(String(cString:ptr.pointee.ifa_name))
        }
        
        freeifaddrs(ifaddr)
        return addresses
    }
    
    func hasExternalInterface() -> Bool{
        let interfaces = self.getIFNames();
        return interfaces.contains("fw0");
    }
    
    
    func checkForRunningApps() {
        
        if NSRunningApplication.runningApplications(withBundleIdentifier: Bundle.main.bundleIdentifier!).count > 1 {
            NSApp.terminate(nil);
        }
        
    }
    
    func psAux() -> String {
        let task = Process()
        let pipe = Pipe();
        task.launchPath = "/bin/ps";
        task.arguments = ["aux"];
        task.standardOutput = pipe;
        task.launch();
        let data = pipe.fileHandleForReading.readDataToEndOfFile();
        task.waitUntilExit();

        return String(data: data, encoding: .utf8)!;
    }
    
    func checkForKarabinerElements() {
        let running = psAux();
        if !running.contains("karabiner_console_user_server") {
            let alert = NSAlert()
            alert.messageText = "This application requires Karabiner Elements (karabiner_console_user_server)"
            alert.alertStyle = NSAlertStyle.warning
            alert.runModal();
            NSApp.terminate(nil);
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        checkForRunningApps();
        checkForKarabinerElements();
        
        NSApp.setActivationPolicy(.accessory);
        window.close();
        
        var last = self.toggleKarabiner(enabled: self.hasExternalInterface());
        
        
        let timer = Timer(timeInterval: 5.0, repeats: true) { (Timer) in
            let new = self.hasExternalInterface();
            
            if (new != last) {
                last = self.toggleKarabiner(enabled: new);
            }
        };
    
        
        RunLoop.current.add(timer, forMode: .defaultRunLoopMode);
        
    }

}

