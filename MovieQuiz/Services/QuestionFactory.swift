//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 26.06.2024.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
        
    private var questions: [QuizQuestion] = [
        QuizQuestion(
            image: "1",
            text: "Рейтинг этого фильма больше 7?",
            correctAnser: true),
        QuizQuestion(
            image: "2",
            text: "Рейтинг этого фильма больше 3?",
            correctAnser: true),
        QuizQuestion(
            image: "3",
            text: "Рейтинг этого фильма больше 5?",
            correctAnser: false),
        QuizQuestion(
            image: "4",
            text: "Рейтинг этого фильма больше 8?",
            correctAnser: false),
        QuizQuestion(
            image: "5",
            text: "Рейтинг этого фильма больше 6?",
            correctAnser: true),
    ]
    
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            return
        }
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
}
