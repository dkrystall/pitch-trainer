//
//  DeckBuilder.swift
//  Pitch Trainer
//
//  Created by David Krystall on 3/4/17.
//  Copyright © 2017 David Krystall. All rights reserved.
//

import Foundation

class DeckBuilder{
    let queryBuilder = QueryBuilder()
    let deck = [String:Int]()
    let notes = ["a","b","c","d","e","f","g"]
    
    func build10Cards() -> [(String,Int)]{
        var deckToBuild = [(String,Int)]()
        var count = 0
        while count < 10 {
            let card = (getRandomNote(), getRandomOctave())
            deckToBuild.append(card)
            count += 1
        }
        return deckToBuild
    }
    
    func getRandomOctave() -> Int{
        let randomNum:UInt32 = arc4random_uniform(7)+1 // range is 1 to 7
        let octave = Int(randomNum)
        return octave
    }
    
    func getRandomNote() -> String{
        let randomNum:UInt32 = arc4random_uniform(7) // range is 0 to 7
        let index = Int(randomNum)
        return notes[index]
    }
}

extension Dictionary {
    
    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}
