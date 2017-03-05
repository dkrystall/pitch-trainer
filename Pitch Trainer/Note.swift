//
//  Note.swift
//  Pitch Trainer
//
//  Created by David Krystall on 3/4/17.
//  Copyright © 2017 David Krystall. All rights reserved.
//

import Foundation

class Note {
    var pitch:Double?
    var noteName:String?
    var octave:Int?
    var midi:Int?
    
    init(pitch: Double, noteName: String, octave: Int?, midi: Int){
        self.pitch = pitch
        self.noteName = noteName
        self.octave = octave
        self.midi = midi
    }
    
}
