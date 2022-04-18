//
//  Workout.swift
//  workout-app
//
//  Created by Ralph Lee on 4/15/22.
//

import Foundation
import UIKit

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
