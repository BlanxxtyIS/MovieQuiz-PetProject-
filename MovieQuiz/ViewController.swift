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

    //индекс текущего вопроса
    private var currentQuestionIndex = 0
    //кол-во правильных ответов
    private var correctAnswers = 0
    
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
    
    private lazy var questionTitle: UILabel = {
        let label = UILabel()
        label.text = "Вопрос:"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .theme.bWhite
        return label
    }()
    
    private lazy var questionCount: UILabel = {
        let label = UILabel()
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
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.setTitleColor(.theme.bBlack, for: .normal)
        button.backgroundColor = .theme.bWhite
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [noButton, yesButton])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 20
        return stack
    }()
    
    private lazy var fullScreenStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [topLabelStackView, 
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
        showQuestion()
    }
    //MARK: - Public Methods
    
    //MARK: - Private Methods
    @objc
    private func noButtonTapped() {
        let givenAnswer = false
        let currentQuestion = questions[currentQuestionIndex].correctAnser
        showAnswerResult(isCorrect: givenAnswer == currentQuestion)
    }
    
    @objc
    private func yesButtonTapped() {
        let givenAnswer = true
        let currentQuestion = questions[currentQuestionIndex].correctAnser
        showAnswerResult(isCorrect: givenAnswer == currentQuestion)
    }
    
    private func setupViews() {
        view.addSubview(fullScreenStack)
        fullScreenStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fullScreenStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: 10),
            fullScreenStack.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                     constant: 16),
            fullScreenStack.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                      constant: -16),
            fullScreenStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //Ответ положительный/отрицательный
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
    
    //Ветвление продолжить или окончить
    private func showQuestion() {
        isEnabledButton(true)
        if currentQuestionIndex == questions.count {
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/\(questions.count)",
                buttonText: "Сыграть еще раз")
            
            endRoundAlert(viewModel)
        } else {
            setupToShowQuestion()
        }
    }
    
    //Показывает на экране текущий вопрос
    private func setupToShowQuestion() {
        let currentQuestion = convert(model: questions[currentQuestionIndex])
        questionCount.text = currentQuestion.questionNumber
        questionImage.image = currentQuestion.image
        questionLabel.text = currentQuestion.question
    }
    
    //Конвертирует Mock-данные
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let convertedQuestion = QuizStepViewModel(
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)",
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text)
        return convertedQuestion
    }
    
    //Алерт окончания игры
    private func endRoundAlert(_ quiz: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: quiz.title,
            message: quiz.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: quiz.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.newQuizRound()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
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
