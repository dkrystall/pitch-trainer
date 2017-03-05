//
//  MIDISampler.swift
//  Pitch Trainer
//
//  Created by David Krystall on 3/5/17.
//  Copyright © 2017 David Krystall. All rights reserved.
//  Modified from https://github.com/genedelisa

import Foundation
import AVFoundation

class MIDISampler {
    
    var engine:AVAudioEngine!
    var sampler:AVAudioUnitSampler!
    
    let melodicBank = UInt8(kAUSampler_DefaultMelodicBankMSB)
    let defaultBankLSB = UInt8(kAUSampler_DefaultBankLSB)
    
    /// general midi number for marimba
    let gmMarimba = UInt8(12)
    let gmHarpsichord = UInt8(6)
    
    init() {
        initAudioEngine()
    }
    
    func initAudioEngine () {
        
        engine = AVAudioEngine()
        
        sampler = AVAudioUnitSampler()
        engine.attach(sampler)
        
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
        
        startEngine()
    }
    
    func startEngine() {
        
        if engine.isRunning {
            print("audio engine already started")
            return
        }
        
        do {
            try engine.start()
            print("audio engine started")
        } catch {
            print("oops \(error)")
            print("could not start audio engine")
        }
    }
    
    
    func loadPatch(gmpatch:UInt8, channel:UInt8 = 0) {
        
        guard let soundbank =
            Bundle.main.url(forResource: "GeneralUser GS MuseScore v1.442", withExtension: "sf2")
            else {
                print("could not read sound font")
                return
        }
        
        do {
            try sampler.loadSoundBankInstrument(at: soundbank, program:gmpatch,
                                                     bankMSB: melodicBank, bankLSB: defaultBankLSB)
            
        } catch let error as NSError {
            print("\(error.localizedDescription)")
            return
        }
        
        self.sampler.sendProgramChange(gmpatch, bankMSB: melodicBank, bankLSB: defaultBankLSB, onChannel: channel)
    }
    
    
    func hstart(midi: Int) {
        // of course, loading the patch every time is not optimal.
        loadPatch(gmpatch: gmHarpsichord)
        self.sampler.startNote(UInt8(midi), withVelocity: 64, onChannel: 0)
    }
    func hAdjustMidi() -> Int{
        return 85
    }
    
    func hstop(midi: Int) {
        self.sampler.stopNote(UInt8(midi), onChannel: 0)
    }
    
    func mstart() {
        loadPatch(gmpatch: gmMarimba, channel:1)
        self.sampler.startNote(65, withVelocity: 64, onChannel: 1)
    }
    
    func mstop() {
        self.sampler.stopNote(65, onChannel: 1)
    }
    
}
