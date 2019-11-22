//
//  DictionaryHttpRequest.swift
//  WordList
//
//  Created by Alexander Parshakov on 06/10/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import CoreData
import RealmSwift
import Alamofire

struct NetworkManager {
    
    struct WordUnits {
        
        static let wordUnitsAPI = "https://dictionary-webservice.azurewebsites.net/api/WordUnits"
        
        static func getWords(sourceId:Int = -1, completion: @escaping (Swift.Result<Array<WordUnit>, Error>) -> Void) {
            URLSession.shared.dataTask(with: URLs.WordUnitMethods.getAll(forUserLogin: "AlexanderParshakov", forLanguage: 1, forSource: sourceId)) {
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
                        if sourceId == -1 {
                            RealmManager.WordUnits.persist(fromArray: words)
                        }
                    } catch let jsonError {
                        print("Failed to decode", jsonError)
                        completion(.failure(jsonError))
                    }
                }
            }.resume()
        }
        
        static func getById(wordId:Int, completion: @escaping (Swift.Result<WordUnit, Error>) -> Void) {
            URLSession.shared.dataTask(with: URLs.WordUnitMethods.getById(forUserLogin: "AlexanderParshakov", forLanguage: 1, forWordWithId: wordId)) {
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
        static func postWord(parameters: [String:String]) {
            Alamofire.request(wordUnitsAPI, method: .post, parameters: parameters)
        }
    }
    struct Sources {
        
        static func getAll(completion: @escaping (Swift.Result<Array<Source>, Error>) -> Void) {
            URLSession.shared.dataTask(with: URLs.SourceMethods.getAll(forUserLogin: "AlexanderParshakov", withPassword: "123")) {
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
                        RealmManager.Sources.persist(fromArray: sources)
                    } catch let jsonError {
                        print("Failed to decode", jsonError)
                        completion(.failure(jsonError))
                    }
                }
            }.resume()
        }
        
        static func getById(sourceId:Int, completion: @escaping (Swift.Result<Source, Error>) -> Void) {
            URLSession.shared.dataTask(with: URLs.SourceMethods.getById(forUserLogin: "AlexanderParshakov", withPassword: "123", forSourceWithId: sourceId)) {
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
    
    struct Tags {
        
        static func getAll(completion: @escaping (Swift.Result<Array<Tag>, Error>) -> Void) {
            URLSession.shared.dataTask(with: URLs.TagMethods.getAll(forUserLogin: "AlexanderParshakov", withPassword: "123")) {
                (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        print("Some error")
                    }
                    guard let data = data else { return }
                    do {
                        let tags = try JSONDecoder().decode(Array<Tag>.self, from: data)
                        completion(.success(tags))
                        RealmManager.Tags.persist(fromArray: tags)
                    } catch let jsonError {
                        print("Failed to decode", jsonError)
                        completion(.failure(jsonError))
                    }
                }
            }.resume()
        }
    }
    
    
    struct Languages {
        
        static func getAll(completion: @escaping (Swift.Result<Array<Language>, Error>) -> Void) {
            URLSession.shared.dataTask(with: URLs.LanguageMethods.getAll(forUserLogin: "AlexanderParshakov", withPassword: "123")) {
                (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        print("Some error")
                    }
                    guard let data = data else { return }
                    do {
                        let languages = try JSONDecoder().decode(Array<Language>.self, from: data)
                        completion(.success(languages))
                        RealmManager.Languages.persist(fromArray: languages)
                    } catch let jsonError {
                        print("Failed to decode", jsonError)
                        completion(.failure(jsonError))
                    }
                }
            }.resume()
        }
    }
}


