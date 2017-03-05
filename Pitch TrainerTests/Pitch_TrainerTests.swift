//
//  Pitch_TrainerTests.swift
//  Pitch TrainerTests
//
//  Created by David Krystall on 3/4/17.
//  Copyright © 2017 David Krystall. All rights reserved.
//

import XCTest
@testable import Pitch_Trainer

class Pitch_TrainerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testCanSendURLRequest(){
        var request = URLRequest(url: URL(string: "http://example.com")!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            print("Entered the completionHandler")
            }.resume()
    }
    func testExtractNoteValues(){
        var request = URLRequest(url: URL(string: "http://api.wolframalpha.com/v2/query?appid=KVJGJL-LT9U4PPJLV&input=note+c5&output=JSON&podindex=1,6,7")!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10.0
        let session = URLSession.shared
        var noteName = ""
        var notePitch = 0.0
        var noteMidi = 0
        var noteOctave = 0
        
        let expecting = expectation(description: "SomeService does stuff and runs the callback closure")
        
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
                        let note = Note.init(pitch: notePitch.rounded(), noteName: noteName, octave: noteOctave, midi: noteMidi)
                        note.midi = noteMidi
                        print("note name: \(note.noteName), note pitch: \(note.pitch), note midi: \(note.midi), note octave: \(note.octave)")
                        XCTAssert(note.noteName! == "C" && note.pitch! == 523.0 && note.midi! == 72 && note.octave == 5)
                    }
                }
                
            } catch {
                print("Unable to retrieve response from wolfram")
            }
            expecting.fulfill()
            
        }
        task.resume()
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    func getWolframC5Note() -> [String:AnyObject]{
        var request = URLRequest(url: URL(string: "http://api.wolframalpha.com/v2/query?appid=KVJGJL-LT9U4PPJLV&input=note+c5&output=JSON")!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10.0
        var noteJSON:[String:AnyObject] = [String:AnyObject]()
        let session = URLSession.shared
        let expecting = expectation(description: "SomeService does stuff and runs the callback closure")
        
        let task = session.dataTask(with: request) { data, response, err in
            print("starting the data task")
            do {
                if let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]{
                print("result \(result)")
                    for string in result{
                        print(string.key)
                    }
                    noteJSON = result
                }
            } catch {
                print("Unable to retrieve response from wolfram")
            }
            expecting.fulfill()
            
        }
        task.resume()
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        return noteJSON
    }
    
    func testCanGetSharpNotes(){
        var request = URLRequest(url: URL(string: "http://api.wolframalpha.com/v2/query?appid=KVJGJL-LT9U4PPJLV&input=note+c%235&output=JSON")!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10.0
        let session = URLSession.shared
        let expecting = expectation(description: "SomeService does stuff and runs the callback closure")
        
        let task = session.dataTask(with: request) { data, response, err in
            print("starting the data task")
            do {
                if let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]{
                    print("result \(result)")
                    for string in result{
                        print(string.key)
                    }
                }
            } catch {
                print("Unable to retrieve response from wolfram")
            }
            expecting.fulfill()
            
        }
        task.resume()
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }

    }
    
    func testCanGetD5Note(){
        let builder = QueryBuilder()
        let queryString = builder.noteQuery(note: "d", octave: 5)
    }
    
    func getRandomNumber(times:Int){
        var tests = 0
        while(tests < times){
            let deck = DeckBuilder()
            let num = deck.getRandomOctave()
            print(num)
            XCTAssert(num <= 7 && num > 0)
            tests+=1
        }
        
    }
    
    func test10Randoms(){
        getRandomNumber(times: 50)
    }
    
    func testBuiltDeck(){
        let builder = DeckBuilder()
        let cards = builder.build10Cards()
        for item in cards{
            print(item)
        }
    }
    
}
