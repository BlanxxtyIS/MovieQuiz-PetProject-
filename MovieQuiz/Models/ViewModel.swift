//
//  ViewModel.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 25.06.2024.
//

import UIKit

//Структура Вопроса
struct QuizQuestion {
    let image: String
    let text: String
    let correctAnser: Bool
}

//Вопрос показан
struct QuizStepViewModel {
    let questionNumber: String
    let image: UIImage
    let question: String
}

//Результат квиза
struct QuizResultsViewModel {
    let title: String
    let text: String
    let buttonText: String
}
