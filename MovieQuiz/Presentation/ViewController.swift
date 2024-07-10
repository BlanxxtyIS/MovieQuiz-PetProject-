//
//  ViewController.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 24.06.2024.
//

import UIKit
//Шрифт?
class ViewController: UIViewController {
    
    //MARK: - Public Properties
    
    //MARK: - Private Properties
    private var statisticService = StatisticServiceImplemention()
    
    private var questionFactory: QuestionFactoryProtocol?
    private let questionAmount = 10
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?

    //индекс текущего вопроса
    private var currentQuestionIndex = 0
    //кол-во правильных ответов
    private var correctAnswers = 0
    
    private lazy var questionTitle: UILabel = {
        let label = UILabel()
        label.text = "Вопрос:"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .theme.bWhite
        return label
    }()
    
    private lazy var questionCount: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "Index"
        label.text = "1/10"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .theme.bWhite
        return label
    }()
    
    private lazy var topLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [questionTitle, 
                                                       questionCount])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var questionImage: UIImageView = {
       let image = UIImage(named: "1")
        let imageView = UIImageView(image: image)
        imageView.accessibilityIdentifier = "Poster"
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleToFill
        imageView.heightAnchor.constraint(equalToConstant: 502).isActive = true
        return imageView
    }()
    
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Рейтинг этого фильма меньше чем 5?"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .theme.bWhite
        return label
    }()
    
    private lazy var noButton: UIButton = {
       let button = UIButton()
        button.accessibilityIdentifier = "Нет"
        button.setTitle("Нет", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.setTitleColor(.theme.bBlack, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.backgroundColor = .theme.bWhite
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var yesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Да", for: .normal)
        button.accessibilityIdentifier = "Yes"
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.setTitleColor(.theme.bBlack, for: .normal)
        button.backgroundColor = .theme.bWhite
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [noButton, 
                                                  yesButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 20
        return stack
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var fullScreenStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            topLabelStackView,
            questionImage,
            questionLabel,
            buttonStack])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .theme.bBlack
        setupViews()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        alertPresenter = AlertPresenter(delegate: self)
        showLoadingIndicator()
    }
    //MARK: - Public Methods
    
    //MARK: - Private Methods
    @objc
    private func noButtonTapped() {
        handleAnswer(false)
    }
    
    @objc
    private func yesButtonTapped() {
        handleAnswer(true)
    }
    
    private func setupViews() {
        view.addSubview(fullScreenStack)
        view.addSubview(activityIndicator)
        fullScreenStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fullScreenStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: 10),
            fullScreenStack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                     constant: 16),
            fullScreenStack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                      constant: -16),
            fullScreenStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(
            title: "Error",
            message: message,
            buttonText: "Попробовать еще раз") { [weak self] in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
        alertPresenter?.presentAlert(model)
    }
    
    private func handleAnswer(_ answer: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: answer == currentQuestion.correctAnser)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        questionImage.layer.borderWidth = 8
        questionImage.layer.cornerRadius = 16
        if isCorrect {
            questionImage.layer.borderColor = UIColor.theme.bGreen?.cgColor
            correctAnswers += 1
        } else {
            questionImage.layer.borderColor = UIColor.theme.bRed?.cgColor
        }
        currentQuestionIndex += 1
        isEnabledButton(false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.questionImage.layer.borderWidth = 0
            self.showQuestion()
        }
    }
    
    private func showQuestion() {
        isEnabledButton(true)
        if currentQuestionIndex == questionAmount {
            statisticService.store(correct: correctAnswers, total: questionAmount)
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: """
                        Ваш результат: \(correctAnswers)/\(questionAmount)
                        Количество сыгранных квизов: \(statisticService.gamesCount)
                        Рекорд: \(statisticService.bestGame.correct) (\(statisticService.bestGame.date))
                        Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                        """,
                buttonText: "Сыграть еще раз")
            endRoundAlert(viewModel)
        } else {
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func setupToShowQuestion(quiz: QuizStepViewModel) {
        questionCount.text = quiz.questionNumber
        questionImage.image = quiz.image
        questionLabel.text = quiz.question
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
        alertPresenter?.presentAlert(alertModel)
    }
    
    private func newQuizRound() {
        correctAnswers = 0
        currentQuestionIndex = 0
        showQuestion()
    }
    
    private func isEnabledButton(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
}

//MARK: - QuestionFactoryDelegate
extension ViewController: QuestionFactoryDelegate {
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailtToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        if let question = question {
            currentQuestion = question
            let currentQuestion = question
            let viewModel = convert(model: currentQuestion)
            DispatchQueue.main.async { [weak self] in
                self?.setupToShowQuestion(quiz: viewModel)
            }
        }
    }
}

//MARK: - AlertPresenterDelegate
extension ViewController: AlertPresenterDelegate {
    func endOfGame(_ alert: UIAlertController) {
        present(alert, animated: true)
    }
}
