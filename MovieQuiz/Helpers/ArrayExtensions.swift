//
//  ArrayExtensions.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 26.06.2024.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        indices ~= index ? self[index] : nil
    }
}
