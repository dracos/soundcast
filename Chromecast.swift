//
//  ChromeCast.swift
//  SoundCaster
//
//  Created by Matthew Somerville on 07/01/2017.
//  Copyright © 2017 Matthew Somerville. All rights reserved.
//

import Foundation

struct Chromecast: CustomStringConvertible {
    var id: String
    var name: String
    var audio: Bool
    var description: String {
        return "\(name): \(id) \(audio)"
    }
}

class Chromecasts {
    var running: Process!
    
    let resourcePath = Bundle.main.resourcePath!
    
    func search(success: @escaping ([Chromecast]) -> Void) {
        let task = Process()
        task.launchPath = self.resourcePath + "/node"
        task.arguments = [self.resourcePath + "/node_modules/.bin/chromecast","-j"]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let chromecasts = self.chromecastsFromJSONData(data) {
            success(chromecasts)
        }
    }
    
    func cast(_ id: String) {
        self.running = Process()
        self.running.launchPath = self.resourcePath + "/node"
        self.running.arguments = [self.resourcePath + "/node_modules/.bin/chromecast","-n","SoundCaster","-p","7531","-d",id]
        self.running.launch()
    }
    
    deinit {
        self.stop()
    }

    func stop() {
        if (self.running != nil) {
            self.running.terminate()
        }
    }
    
    func chromecastsFromJSONData(_ data: Data) -> [Chromecast]? {
        typealias JSONDict = [String:AnyObject]
        let json : JSONDict

        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDict
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }

        var chromecasts: [Chromecast] = []
        for (_, chromecast) in json {
            var cJSON = chromecast as! JSONDict
            var txtRecord = cJSON["txtRecord"] as! JSONDict
            chromecasts.append(Chromecast(
                id: cJSON["name"] as! String,
                name: txtRecord["fn"] as! String,
                audio: txtRecord["md"] as! String == "Chromecast Audio"
            ))
        }
        return chromecasts
    }
}
