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
    
    var sound:Sound!
    var midiSampler:MIDISampler!
    var midiValue:Int = 60
    
    var noteChoice:String?
    var octaveChoice:Int?
    
    var noteAnswer = ""
    var octaveAnswer = 0
    
    @IBOutlet var noteChoiceLabel: UILabel!
    @IBOutlet var octaveChoiceLabel: UILabel!
    
    
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
        refreshNote()
        
        

    }
    func refreshNote(){
        DispatchQueue.main.asyncAfter(deadline: .now()){
            let queryBuilder = QueryBuilder()
            let deckBuilder = DeckBuilder()
            let randomNote = deckBuilder.getRandomNote()
            let randomOctave = deckBuilder.getRandomOctave()
            let queryString = queryBuilder.noteQuery(note: randomNote, octave: randomOctave)
            let _ = queryBuilder.getNoteFromWolfram(queryString: queryString)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)){
                self.midiValue = UserDefaults.standard.value(forKey: "midi") as! Int
                self.noteAnswer = UserDefaults.standard.value(forKey: "noteName") as! String
                self.octaveAnswer = UserDefaults.standard.value(forKey: "noteOctave") as! Int
            }
            
        }

    }
    @IBAction func buttonPressed(sender: UIButton){
        print("button pressed")
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
        }
        
        if(noteAnswer == noteChoice && octaveAnswer == octaveChoice){
            print("You win!")
            
            refreshNote()
            let alertController = UIAlertController(title: "Congrats!", message: "You won! Play again.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)

        } else {
            print("Guess again")
            if ( noteAnswer > noteChoice!){
            let retryAlertController = UIAlertController(title: "Dagnabbit!", message: "That's not quite right, try again. Hint: Try a higher note", preferredStyle: UIAlertControllerStyle.alert)
            
            retryAlertController.addAction(okAction)
            self.present(retryAlertController, animated: false, completion: nil)
            } else if ( noteAnswer < noteChoice!){
                let retryAlertController = UIAlertController(title: "Dagnabbit!", message: "That's not quite right, try again. Hint: Try a lower note", preferredStyle: UIAlertControllerStyle.alert)
                
                retryAlertController.addAction(okAction)
                self.present(retryAlertController, animated: false, completion: nil)
            } else {
                let retryAlertController = UIAlertController(title: "Dagnabbit!", message: "That's not quite right, try again. Hint: Change your octave", preferredStyle: UIAlertControllerStyle.alert)
                
                retryAlertController.addAction(okAction)
                self.present(retryAlertController, animated: false, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //midiValue = UserDefaults.standard.value(forKey: "midi") as! Int
        self.sound = Sound()
        self.midiSampler = MIDISampler()
        
    }
    
    @IBAction func treblePressed(_ sender: Any) {
        print("Play requested")
        midiSampler.hstart(midi: midiValue)
    }
    
    @IBAction func stopPressed(_ sender: Any) {
        midiSampler.hstop(midi: midiValue)
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
    func setNoteLabel(note:String){
        noteChoiceLabel.text = note
    }
    func setOctaveLabe(octave:String){
        octaveChoiceLabel.text = octave
    }
    @IBAction func aButton(_ sender: Any) {
        setNoteLabel(note: "A")
        noteChoice = "A"
    }
    @IBAction func bButton(_ sender: Any) {
        setNoteLabel(note: "B")
        noteChoice = "B"
    }
    @IBAction func cButton(_ sender: Any) {
        setNoteLabel(note: "C")
        noteChoice = "C"
    }
    @IBAction func dButton(_ sender: Any) {
        setNoteLabel(note: "D")
        noteChoice = "D"
    }
    @IBAction func eButton(_ sender: Any) {
        setNoteLabel(note: "E")
        noteChoice = "E"
    }
    @IBAction func fButton(_ sender: Any) {
        setNoteLabel(note: "F")
        noteChoice = "F"
    }
    @IBAction func gButton(_ sender: Any) {
        setNoteLabel(note: "G")
        noteChoice = "G"
    }
    @IBAction func oneButton(_ sender: Any) {
        setOctaveLabe(octave: "1")
        octaveChoice = 1
    }
    @IBAction func twoButton(_ sender: Any) {
        setOctaveLabe(octave: "2")
        octaveChoice = 2
    }
    @IBAction func threeButton(_ sender: Any) {
        setOctaveLabe(octave: "3")
        octaveChoice = 3
    }
    @IBAction func fourButton(_ sender: Any) {
        setOctaveLabe(octave: "4")
        octaveChoice = 4
    }
    @IBAction func fiveButton(_ sender: Any) {
        setOctaveLabe(octave: "5")
        octaveChoice = 5
    }
    @IBAction func sixBUtton(_ sender: Any) {
        setOctaveLabe(octave: "6")
        octaveChoice = 6
    }
    @IBAction func sevenButton(_ sender: Any) {
        setOctaveLabe(octave: "7")
        octaveChoice = 7
    }
}

