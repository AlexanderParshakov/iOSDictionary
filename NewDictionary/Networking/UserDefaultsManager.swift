//
//  UserDefaultsManager.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/30/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation

class UserDefaultsManager: NSCoder {
    
    static func persistData(object: NSObject, key: String) {
        let userDefaults = UserDefaults.standard
        let archivedPool = try? NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
        userDefaults.set(archivedPool, forKey: key)
        userDefaults.synchronize()
    }
    static func retrieveData<T>(objectType: T.Type, key: String) -> NSObject where T : NSObject, T : NSCoding {
        let userDefaults = UserDefaults.standard
        guard let decoded  = userDefaults.data(forKey: key) else { return NSObject() }
        guard let decodedObject = try! NSKeyedUnarchiver.unarchivedObject(ofClass: objectType, from: decoded) else { return NSObject() }
        
        return decodedObject
    }
}
