//
//  FirstViewController.swift
//  Pitch Trainer
//
//  Created by David Krystall on 3/4/17.
//  Copyright © 2017 David Krystall. All rights reserved.
//

import UIKit
import AVFoundation
import CoreAudio

class FirstViewController: UIViewController {

    let engine = AVAudioEngine()
    let sampler = AVAudioUnitSampler()
    
    
    
    @IBOutlet var buttonA: UIButton!
    @IBOutlet var buttonB: UIButton!
    @IBOutlet var buttonC: UIButton!
    @IBOutlet var buttonD: UIButton!
    @IBOutlet var buttonE: UIButton!
    @IBOutlet var buttonF: UIButton!
    @IBOutlet var buttonG: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addButtonBorder(button: buttonA)
        addButtonBorder(button: buttonB)
        addButtonBorder(button: buttonC)
        addButtonBorder(button: buttonD)
        addButtonBorder(button: buttonE)
        addButtonBorder(button: buttonF)
        addButtonBorder(button: buttonG)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
        // Do any additional setup after loading the view, typically from a nib.
        
        loadPatch(gmpatch: gmHarpsichord)
        
    }
    
    // instance variables
    let melodicBank = UInt8(kAUSampler_DefaultMelodicBankMSB)
    let defaultBankLSB = UInt8(kAUSampler_DefaultBankLSB)
    let gmMarimba = UInt8(12)
    let gmHarpsichord = UInt8(6)
    
    func loadPatch(gmpatch:UInt8, channel:UInt8 = 0) {
        
        guard let soundbank =
            Bundle.main.url(forResource: "GeneralUser GS MuseScore v1.442", withExtension: "sf2")
            else {
                print("could not read sound font")
                return
        }
        
        do {
            try sampler.loadSoundBankInstrument(at: soundbank, program:gmpatch, bankMSB: melodicBank, bankLSB: defaultBankLSB)
            
        } catch let error as NSError {
            print("\(error.localizedDescription)")
            return
        }
        
        self.sampler.sendProgramChange(gmpatch, bankMSB: melodicBank, bankLSB: defaultBankLSB, onChannel: channel)
    }
    
    
    
    @IBAction func treblePressed(_ sender: Any) {
        print("replay requested")
        // play middle C, mezzo forte on MIDI channel 0
        self.sampler.startNote(60, withVelocity: 64, onChannel: 0)
        
    }
    @IBAction func stopPressed(_ sender: Any) {
        self.sampler.stopNote(60, onChannel: 0)
    }
    
    func addButtonBorder(button:UIButton){
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

