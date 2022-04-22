//
//  Workout.swift
//  workout-app
//
//  Created by Ralph Lee on 4/15/22.
//

import Foundation
import UIKit

struct Program: Hashable, Codable {
    var workouts: [Workout]
    var date: Date
    var programDone: Bool = false
}

struct Workout: Hashable, Codable {
    var name: String
    var amount: [AmountDone]? = []
    
    mutating func add(runThrough: AmountDone) {
        amount?.append(runThrough)
    }
}

struct AmountDone: Hashable, Codable {
    var weight: String
    var rep: Int
    var set: Int?
}

var sampleProgram: [Program] = [
    Program(workouts: [Workout(name: "Bench press", amount: [AmountDone(weight: "135", rep: 5, set: 5)])], date: Date()-10000, programDone: true),
    Program(workouts: [Workout(name: "Bench press", amount: [AmountDone(weight: "135", rep: 5, set: 5)])], date: Date()-550000, programDone: true),
    Program(workouts: [Workout(name: "Bench press", amount: [AmountDone(weight: "135", rep: 5, set: 5)])], date: Date()-40000, programDone: true),
]

