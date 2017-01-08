//
//  StatusMenuController.swift
//  SoundCaster
//
//  Created by Matthew Somerville on 07/01/2017.
//  Copyright © 2017 Matthew Somerville. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var castToMenuItem: NSMenuItem!
    @IBOutlet weak var stopCastingItem: NSMenuItem!

    var adapter_reset = false
    var original_input = ""
    var original_output = ""

    let resourcePath = Bundle.main.resourcePath!
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
    let chromecasts = Chromecasts()

    override func awakeFromNib() {
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true
        statusItem.image = icon
        statusItem.menu = statusMenu
        self.stopCastingItem.isEnabled = false;
        original_input = getDevice("input")
        original_output = getDevice("output")
        updateChromecasts()
    }

    func updateChromecasts() {
        chromecasts.search(success: { chromecasts in
            let submenu = self.castToMenuItem.submenu!
            while submenu.numberOfItems > 2 {
                submenu.removeItem(at: 0)
            }
            var i = 0
            for chromecast in chromecasts {
                let menuItem : NSMenuItem = NSMenuItem()
                var title = chromecast.name
                if chromecast.audio {
                    title += " 🔉"
                }
                menuItem.title = title
                menuItem.toolTip = chromecast.id
                menuItem.action = #selector(self.chromecastSelected)
                menuItem.target = self // Needed for the action to fire?
                submenu.insertItem(menuItem, at: i)
                i += 1
            }
        })
    }

    @IBAction func updateClicked(_ sender: NSMenuItem) {
        updateChromecasts()
    }

    func updateCastingStatus(_ live: Bool) {
        self.stopCastingItem.isEnabled = live;
        let submenu = self.castToMenuItem.submenu!
        for i in 0...submenu.numberOfItems - 2 {
            submenu.item(at: i)!.isEnabled = !live;
        }
    }
    
    @IBAction func stopCastingClicked(_ sender: NSMenuItem) {
        updateCastingStatus(false)

        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true
        statusItem.image = icon

        setDevice("output", what: original_output);
        setDevice("input", what: original_input);
        chromecasts.stop()
    }

    @IBAction func aboutClicked(_ sender: NSMenuItem) {
        let alert = NSAlert()
        alert.messageText = "SoundCaster v1.0, by Matthew Somerville."
        alert.informativeText = "https://github.com/dracos/soundcast"
        alert.addButton(withTitle: "Okay")
        alert.runModal()
    }
    
    @IBAction func resetAdapterClicked(_ sender: NSMenuItem) {
        adapter_reset = true;
        updateCastingStatus(false)
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true
        statusItem.image = icon
        setDevice("output", what: "internal");
        setDevice("input", what: "internal");
        chromecasts.stop()
    }

    @IBAction func quitClicked(_ sender: NSMenuItem) {
        chromecasts.stop()
        if (!adapter_reset) {
            setDevice("output", what: original_output);
            setDevice("input", what: original_input);
        }
        NSApplication.shared().terminate(self)
    }

    func chromecastSelected(_ sender: NSMenuItem) {
        updateCastingStatus(true)

        let icon = NSImage(named: "castingIcon")
        icon?.isTemplate = true
        statusItem.image = icon

        setDevice("output", what: "Soundflower (2ch)");
        setDevice("input", what: "Soundflower (2ch)");
        chromecasts.cast(sender.toolTip!)
    }

    func getDevice(_ which: String) -> String {
        let task = Process()
        task.launchPath = self.resourcePath + "/audiodevice"
        task.arguments = [which]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
        var output2 = output.replacingOccurrences(of: "\r\n", with: "")
        output2 = output2.replacingOccurrences(of: "\n", with: "")
        output2 = output2.replacingOccurrences(of: "\r", with: "")
        return output2
    }

    func setDevice(_ which: String, what: String) {
        let task = Process()
        task.launchPath = self.resourcePath + "/audiodevice"
        task.arguments = [which,what]
        task.launch()
    }
}
