//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 28.06.2024.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBestGame(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}
