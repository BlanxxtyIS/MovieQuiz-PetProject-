//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 27.06.2024.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
    
    func presentAlert(_ quiz: AlertModel) {
        let alertController = UIAlertController(
            title: quiz.title,
            message: quiz.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: quiz.buttonText, style: .default) { [weak self] _ in
            guard self != nil else { return }
            quiz.completion()
        }
        
        alertController.addAction(action)
        delegate?.endOfGame(alertController)
    }
}
