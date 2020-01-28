//
//  DictionaryHttpRequest.swift
//  WordList
//
//  Created by Alexander Parshakov on 06/10/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON

protocol AddWordScreenDelegate {
    func termWasAdded(term: WordUnit)
}

struct NetworkManager {
    
    static var addWordDelegate: AddWordScreenDelegate?
    
    
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
        static func postTerm(term: WordUnit) {
            guard let url = URL(string: NetworkManager.WordUnits.wordUnitsAPI) else { return }
            
            var finalTerm = term
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = URLs.WordUnitMethods.buildBodyForTermPost(term: term)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
            
            Alamofire.request(request).responseJSON { (response) in
                switch response.result {
                    case .success(let termData):
                        let json = JSON(termData)
                        print(termData)
                        print(json)
                        if let termId = json["Id"].int {
                            finalTerm.id = termId
                            RealmManager.WordUnits.persistTerm(term: finalTerm)
                            addWordDelegate?.termWasAdded(term: finalTerm)
                        }
                        print(response)
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
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
        static let tagsAPI = "https://dictionary-webservice.azurewebsites.net/api/tags"
        
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
        static func postTag(tag: Tag) {
            guard let url = URL(string: NetworkManager.Tags.tagsAPI) else { return }
            
            let finalTag = tag
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = URLs.TagMethods.buildBodyForTagPost(tag: tag)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
            
            Alamofire.request(request).responseJSON { (response) in
                switch response.result {
                    case .success(let tagData):
                        let json = JSON(tagData)
                        print(tagData)
                        print(json)
                        if let termId = json["Id"].int {
                            finalTag.id = termId
                            RealmManager.Tags.persistTag(tag: finalTag)
                        }
                        print(response)
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
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
    
    struct TermTypes {
        static let termTypesAPI = "https://dictionary-webservice.azurewebsites.net/api"
        static func getTypes(completion: @escaping (Swift.Result<Array<TermType>, Error>) -> Void) {
            guard let url = URL(string: termTypesAPI) else { return }
            
            URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(.failure(error))
                        print("Some error")
                    }
                    guard let data = data else { return }
                    do {
                        let types = try JSONDecoder().decode(Array<TermType>.self, from: data)
                        completion(.success(types))
                        RealmManager.Types.persist(fromArray: types)
                    } catch let jsonError {
                        print("Failed to decode", jsonError)
                        completion(.failure(jsonError))
                    }
                }
            }.resume()
        }
    }
    
    struct Users {
        
    }
}


