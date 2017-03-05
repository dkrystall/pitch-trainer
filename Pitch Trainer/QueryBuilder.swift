//
//  QueryBuilder.swift
//  Pitch Trainer
//
//  Created by David Krystall on 3/4/17.
//  Copyright © 2017 David Krystall. All rights reserved.
//

import Foundation
class QueryBuilder{
    let appID = "KVJGJL-LT9U4PPJLV"
    
    //note must be the form a-g + %23 for sharp
    func noteQuery(note:String, octave:Int) -> URL{
        let query = "http://api.wolframalpha.com/v2/query?appid=\(appID)&input=note+\(note)\(octave.description)&output=JSON&podindex=1,6,7"
        if let url = URL(string: query){
            return url
        } else {
            return URL(string: "http://api.wolframalpha.com/v2/query?appid=KVJGJL-LT9U4PPJLV&input=note+c5&output=JSON&podindex=1,6,7")!
        }
    }
    
    func getNoteFromWolfram(queryString:URL){
        var request = URLRequest(url: queryString)
        request.httpMethod = "GET"
        request.timeoutInterval = 10.0
        let session = URLSession.shared
        var noteName = ""
        var notePitch = 0.0
        var noteMidi = 0
        var noteOctave = 0
        
        let task = session.dataTask(with: request) { data, response, err in
            print("starting the data task")
            do {
                if let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]{
                    if let nestedResult = result["queryresult"] as? [String:Any]{
                        print(nestedResult)
                        if let pods = nestedResult["pods"] as? NSArray{
                            if let subpod = pods[0] as? [String:Any]{
                                print("values - \(subpod.values)")
                                if let subpods = subpod["subpods"] as? [Any]{
                                    if let items = subpods[0] as? [String:Any]{
                                        for item in items{
                                            if item.key == "plaintext"{
                                                item.key == "plaintext" ? noteName = item.value as! String: print("note not found")
                                                let delimiter:Character = "_"
                                                let fields = noteName.characters.split(separator: delimiter).map{ String($0)}
                                                noteName = fields[0]
                                                let fluff:String = fields[1]
                                                let spaceDelimiter:Character = " "
                                                let otherFields = fluff.characters.split(separator: spaceDelimiter).map{String($0)}
                                                noteOctave = Int(otherFields[0])!
                                            }
                                        }
                                    }
                                }
                            }
                            if let subpod = pods[1] as? [String:Any]{
                                print("values - \(subpod.values)")
                                if let subpods = subpod["subpods"] as? [Any]{
                                    if let items = subpods[0] as? [String:Any]{
                                        for item in items{
                                            if let frequency = item.value as? String{
                                                let delimiter:Character = " "
                                                let fields = frequency.characters.split(separator: delimiter).map{ String($0) }
                                                item.key == "plaintext" ? notePitch = Double(fields[0])! : print("frequency not found")
                                            }
                                        }
                                    }
                                }
                            }
                            if let subpod = pods[2] as? [String:Any]{
                                print("values - \(subpod.values)")
                                if let subpods = subpod["subpods"] as? [Any]{
                                    if let items = subpods[0] as? [String:Any]{
                                        for item in items{
                                            if let midi = item.value as? String {
                                                item.key == "plaintext" ? noteMidi = Int(midi)!: print("midi value not found")
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        let note = Note.init(pitch: notePitch.rounded(), noteName: noteName, octave: noteOctave, midi: nil)
                        note.midi = noteMidi
                        print("note name: \(note.noteName), note pitch: \(note.pitch), note midi: \(note.midi), note octave: \(note.octave)")
                        
                    }
                }
                
            } catch {
                print("Unable to retrieve response from wolfram")
            }
            
        }
        task.resume()
    }
}
