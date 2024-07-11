//
//  ViewController.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 24.06.2024.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Public Properties
    var alertPresenter: AlertPresenterProtocol?
    
    //MARK: - Private Properties
    private var presenter: MovieQuizPresenter!

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
        setupLifecycle()
    }
    
    //MARK: - Public Methods
    func isEnabledButton(_ isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String) {
        let model = presenter.showNetworkError(message: message)
        alertPresenter?.presentAlert(model)
    }
    
    func setupToShowQuestion(quiz: QuizStepViewModel) {
        questionCount.text = quiz.questionNumber
        questionImage.image = quiz.image
        questionLabel.text = quiz.question
    }
    
    func showAnswerResult(isCorrect: Bool) {
        questionImage.layer.borderWidth = 8
        questionImage.layer.cornerRadius = 16
        if isCorrect {
            questionImage.layer.borderColor = UIColor.theme.bGreen?.cgColor
            presenter.correctAnswers += 1
        } else {
            questionImage.layer.borderColor = UIColor.theme.bRed?.cgColor
        }
        presenter.switchToNextQuestion()
        isEnabledButton(false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.questionImage.layer.borderWidth = 0
            self.presenter.showQuestion()
        }
    }

    //MARK: - Private Methods
    @objc
    private func noButtonTapped() {
        presenter.handleAnswer(false)
    }
    
    @objc
    private func yesButtonTapped() {
        presenter.handleAnswer(true)
    }
    
    private func setupLifecycle() {
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(delegate: self)
        view.backgroundColor = .theme.bBlack
        setupViews()
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
}


//MARK: - AlertPresenterDelegate
extension ViewController: AlertPresenterDelegate {
    func endOfGame(_ alert: UIAlertController) {
        present(alert, animated: true)
    }
}
