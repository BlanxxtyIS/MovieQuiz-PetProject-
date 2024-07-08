//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Марат Хасанов on 26.06.2024.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {

    private let moviesLoader: MoviesLoading
    weak var delegate: QuestionFactoryDelegate?
        
    private var movies: [MostPopularMovie] = []
    private var questions: [QuizQuestion] = [
//        QuizQuestion(
//            image: "1",
//            text: "Рейтинг этого фильма больше 7?",
//            correctAnser: true),
//        QuizQuestion(
//            image: "2",
//            text: "Рейтинг этого фильма больше 3?",
//            correctAnser: true),
//        QuizQuestion(
//            image: "3",
//            text: "Рейтинг этого фильма больше 5?",
//            correctAnser: false),
//        QuizQuestion(
//            image: "4",
//            text: "Рейтинг этого фильма больше 8?",
//            correctAnser: false),
//        QuizQuestion(
//            image: "5",
//            text: "Рейтинг этого фильма больше 6?",
//            correctAnser: true)
        ]
    
    init(moviesLoader: MoviesLoader ,delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
            guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailtToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        //Запускаем в другом потоке
        DispatchQueue.global().async { [weak self] in
            
            //выбираем рандомный элемент
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            
            //создаем данные из URL
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } 
            catch {
                print("Failed to load image ")
            }
            
            //Создаем вопрос
            let raiting = Float(movie.rating) ?? 0
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = raiting > 7
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnser: correctAnswer)
            
            //Возвращаемся в главный поток
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}


