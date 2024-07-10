//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 10.07.2024.
//

import UIKit

final class MovieQuizPresenter {
    //кол-во вопросов
    let questionAmount = 10
    
    //индекс текущего вопроса
    private var currentQuestionIndex = 0
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let convertedQuestion = QuizStepViewModel(
            questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)",
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text)
        return convertedQuestion
    }
}
