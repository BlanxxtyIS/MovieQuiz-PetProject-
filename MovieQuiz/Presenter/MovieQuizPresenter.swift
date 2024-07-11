//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 10.07.2024.
//

import UIKit

final class MovieQuizPresenter {
    
    //MARK: - Public Properties
    var correctAnswers = 0
    
    //MARK: - Private Properties
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: ViewController?
    
    private var currentQuestion: QuizQuestion?
    private var statisticService = StatisticServiceImplemention()
    
    private let questionAmount = 10
    private var currentQuestionIndex = 0
    
    //MARK: - Initializer
    init(viewController: ViewController) {
        self.viewController = viewController
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    //MARK: - Public Methods
    func didReceiveNextQuestion(question: QuizQuestion?) {
        if let question = question {
            currentQuestion = question
            let viewModel = convert(model: question)
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.setupToShowQuestion(quiz: viewModel)
            }
        }
    }
    
    func showNetworkError(message: String) -> AlertModel {
        viewController?.hideLoadingIndicator()
        let model = AlertModel(
            title: "Error",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self else { return }
                resetQuestionIndex()
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
        return model
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func handleAnswer(_ answer: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        viewController?.showAnswerResult(isCorrect: answer == currentQuestion.correctAnser)
    }
    
    func showQuestion() {
        viewController?.isEnabledButton(true)
        if isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: questionAmount)
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: """
                        Ваш результат: \(correctAnswers)/\(questionAmount)
                        Количество сыгранных квизов: \(statisticService.gamesCount)
                        Рекорд: \(statisticService.bestGame.correct)\\\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                        Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                        """,
                buttonText: "Сыграть еще раз")
            endRoundAlert(viewModel)
        } else {
            questionFactory?.requestNextQuestion()
        }
    }
    
    //MARK: - Private Methods
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionAmount
    }
    
    private func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let convertedQuestion = QuizStepViewModel(
            questionNumber: "\(currentQuestionIndex + 1)/\(questionAmount)",
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text)
        return convertedQuestion
    }
    
    private func endRoundAlert(_ quiz: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: quiz.title,
            message: quiz.text,
            buttonText: quiz.buttonText,
            completion: newQuizRound)
        viewController?.alertPresenter?.presentAlert(alertModel)
    }
    
    private func newQuizRound() {
        correctAnswers = 0
        resetQuestionIndex()
        showQuestion()
    }
}

//MARK: - QuestionFactoryDelegate
extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailtToLoadData(with error: Error) {
        let message = showNetworkError(message: error.localizedDescription)
        viewController?.showNetworkError(message: message.message)
    }
}
