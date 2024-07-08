//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 28.06.2024.
//

import Foundation

protocol StatisticService {
    var totalAccuaracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}
