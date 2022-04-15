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
    var weight: String
    var rep: Int
    var set: Int?
}
