//
//  StatisticServiceImplemention.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 28.06.2024.
//

import Foundation

private enum Keys: String {
    case correct, total, bestGame, gamesCount
}

final class StatisticServiceImplemention: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    
    var totalAccuaracy: Double {
        get {
            userDefaults.double(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }

            return record
        }

        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }

            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let gameRecord = bestGame
        if count > bestGame.correct {
            bestGame = GameRecord(correct: count, total: amount, date: Date())
        }
    }
    
    
}