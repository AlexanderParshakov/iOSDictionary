//
//  ProjectInfo.swift
//  WordList
//
//  Created by Alexander Parshakov on 07/10/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation

struct URLs {
    
    private init() {}
    
    static let apiURL = "https://dictionary-webservice.azurewebsites.net/api/"
    
    struct WordUnitMethods {
        private init() {}
        
        private static let commonURL = apiURL + "WordUnits"
        
        static func getAll(forUserLogin userLogin:String, forLanguage langId:Int, forSource sourceId:Int = 0) -> URL {
            var urlComponents = URLComponents(string: commonURL)!
            urlComponents.queryItems = [
                URLQueryItem(name: "userLogin", value: "\(userLogin)"),
                URLQueryItem(name: "langId", value: "\(langId)"),
                URLQueryItem(name: "sourceId", value: "\(sourceId)")
            ]
            return urlComponents.url!
        }
        static func getById(forUserLogin userLogin:String, forLanguage langId:Int, forWordWithId wordId:Int) -> URL {
            var urlComponents = URLComponents(string: commonURL)!
            urlComponents.queryItems = [
                URLQueryItem(name: "userLogin", value: "\(userLogin)"),
                URLQueryItem(name: "langId", value: "\(langId)"),
                URLQueryItem(name: "wordId", value: "\(wordId)")
            ]
            return urlComponents.url!
        }
//        static func buildParametersForTermPost(term: WordUnit, langId: Int, sourceId: Int, tags: [Tag]) -> [String:String]
//        {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "YYYY-MM-dd HH:mm:ss:mm"
//            var tagsDictionary = [String:String]()
//            tags.forEach { (tag) in
//                tagsDictionary["id"] = String(tag.id)
//            }
//            
//            return [
//                "Id" : String(term.id),
//                "ContentOfUnit" : term.meaning,
//                "Example" : term.example,
//                "Note" : term.note,
//                "Datetime" : formatter.string(from: Date()),
//                "Tags" : tagsDictionary,
//                
//                
//            ]
//            
//        }
    }
    struct SourceMethods {
        private init() {}
        
        private static let commonURL = apiURL + "Sources"
        
        static func getAll(forUserLogin userLogin:String, withPassword userPassword:String) -> URL {
            var urlComponents = URLComponents(string: commonURL)!
            urlComponents.queryItems = [
                URLQueryItem(name: "userLogin", value: "\(userLogin)"),
                URLQueryItem(name: "userPassword", value: "\(userPassword)")
            ]
            let url = urlComponents.url!
            return url
        }
        static func getById(forUserLogin userLogin:String, withPassword userPassword:String, forSourceWithId sourceId:Int) -> URL {
            var urlComponents = URLComponents(string: commonURL)!
            urlComponents.queryItems = [
                URLQueryItem(name: "userLogin", value: "\(userLogin)"),
                URLQueryItem(name: "userPassword", value: "\(userPassword)"),
                URLQueryItem(name: "sourceId", value: "\(sourceId)")
            ]
            return urlComponents.url!
        }
    }
    struct TagMethods {
        private init() {}
        
        private static let commonURL = apiURL + "Tags"
        
        static func getAll(forUserLogin userLogin:String, withPassword userPassword:String) -> URL {
            var urlComponents = URLComponents(string: commonURL)!
            urlComponents.queryItems = [
                URLQueryItem(name: "userLogin", value: "\(userLogin)"),
                URLQueryItem(name: "userPassword", value: "\(userPassword)")
            ]
            let url = urlComponents.url!
            return url
        }
    }
    struct LanguageMethods {
        private init() {}
        
        private static let commonURL = apiURL + "Languages"
        
        static func getAll(forUserLogin userLogin:String, withPassword userPassword:String) -> URL {
            var urlComponents = URLComponents(string: commonURL)!
            urlComponents.queryItems = [
                URLQueryItem(name: "userLogin", value: "\(userLogin)"),
                URLQueryItem(name: "userPassword", value: "\(userPassword)")
            ]
            let url = urlComponents.url!
            return url
        }
    }
}
