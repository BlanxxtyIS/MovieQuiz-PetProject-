//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 27.06.2024.
//

import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func endOfGame(_ alert: UIAlertController)
}
