//
//  DictionaryHttpRequest.swift
//  WordList
//
//  Created by Alexander Parshakov on 06/10/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import CoreData
import UIKit

final class NetworkManager {
    
    final class WordUnits {
        
        static func getWords(sourceId:Int = -1, completion: @escaping (Result<Array<WordUnit>, Error>) -> Void) {
            URLSession.shared.dataTask(with: URLs.wordUnitMethods.getAll(forUserLogin: "AlexanderParshakov", forLanguage: 1, forSource: sourceId)) {
                (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        print("Some error")
                    }
                    guard let data = data else { return }
                    do {
                        let words = try JSONDecoder().decode(Array<WordUnit>.self, from: data)
                        completion(.success(words))
                    } catch let jsonError {
                        print("Failed to decode", jsonError)
                        completion(.failure(jsonError))
                    }
                }
            }.resume()
        }
        
        static func getById(wordId:Int, completion: @escaping (Result<WordUnit, Error>) -> Void) {
            URLSession.shared.dataTask(with: URLs.wordUnitMethods.getById(forUserLogin: "AlexanderParshakov", forLanguage: 1, forWordWithId: wordId)) {
                (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        print("Some error")
                    }
                    guard let data = data else { return }
                    do {
                        let word = try JSONDecoder().decode(WordUnit.self, from: data)
                        completion(.success(word))
                    } catch let jsonError {
                        print("Failed to decode", jsonError)
                        completion(.failure(jsonError))
                    }
                }
            }.resume()
        }
    }
    final class Sources {
        
        static func getAll(completion: @escaping (Result<Array<Source>, Error>) -> Void) {
            URLSession.shared.dataTask(with: URLs.sourceMethods.getAll(forUserLogin: "AlexanderParshakov", withPassword: "123")) {
                (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        print("Some error")
                    }
                    guard let data = data else { return }
                    do {
                        let sources = try JSONDecoder().decode(Array<Source>.self, from: data)
                        completion(.success(sources))
                    } catch let jsonError {
                        print("Failed to decode", jsonError)
                        completion(.failure(jsonError))
                    }
                }
            }.resume()
        }
        
        static func getById(sourceId:Int, completion: @escaping (Result<Source, Error>) -> Void) {
            URLSession.shared.dataTask(with: URLs.sourceMethods.getById(forUserLogin: "AlexanderParshakov", withPassword: "123", forSourceWithId: sourceId)) {
                (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        print("Some error")
                    }
                    guard let data = data else { return }
                    do {
                        let source = try JSONDecoder().decode(Source.self, from: data)
                        completion(.success(source))
                    } catch let jsonError {
                        print("Failed to decode", jsonError)
                        completion(.failure(jsonError))
                    }
                }
            }.resume()
        }
    }
}


