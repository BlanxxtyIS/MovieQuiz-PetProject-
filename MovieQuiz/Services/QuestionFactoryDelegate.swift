//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 26.06.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailtToLoadData(with error: Error)
}
