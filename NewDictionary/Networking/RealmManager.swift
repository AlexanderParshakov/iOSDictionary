//
//  RealmManager.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/3/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmManager {
    
    static func printPath() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    struct Sources { } // extended
    struct WordUnits { } // extended
}



// MARK: - Sources Extension
extension RealmManager.Sources {
    
    static func persist(fromArray sources: [Source]) {
        let realmSources = mutateSources(sources: sources)
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(realm.objects(RealmSource.self))
                    realm.add(realmSources)
                }
            }
        }
    }
    static func retrieve() -> [Source] {
        let realm = try! Realm()
        let realmSources = realm.objects(RealmSource.self)
        return mutateRealmSources(realmSources: realmSources)
    }
    
    private static func mutateSources(sources: [Source]) -> [RealmSource] {
        var realmSources = [RealmSource]()
        sources.forEach { (source) in
            let realmSource = RealmSource(source: source)
            realmSources.append(realmSource)
        }
        return realmSources
    }
    private static func mutateRealmSources(realmSources: Results<RealmSource>) -> [Source] {
        var sources = [Source]()
        realmSources.forEach { (realmSource) in
            let source = Source(realmSource: realmSource)
            sources.append(source)
        }
        return sources
    }
}



// MARK: - WordUnits Extension
extension RealmManager.WordUnits {
    
    static func persist(fromArray wordUnits: [WordUnit]) {
        let realmWordUnits = mutateWordUnits(wordUnits: wordUnits)
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let config = Realm.Configuration(
                    // Set the new schema version. This must be greater than the previously used
                    // version (if you've never set a schema version before, the version is 0).
                    schemaVersion: 1,

                    // Set the block which will be called automatically when opening a Realm with
                    // a schema version lower than the one set above
                    migrationBlock: { migration, oldSchemaVersion in
                        // We haven’t migrated anything yet, so oldSchemaVersion == 0
                        if (oldSchemaVersion < 1) {
                            // Nothing to do!
                            // Realm will automatically detect new properties and removed properties
                            // And will update the schema on disk automatically
                        }
                    })

                // Tell Realm to use this new configuration object for the default Realm
                Realm.Configuration.defaultConfiguration = config
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(realm.objects(RealmWordUnit.self))
                    realm.add(realmWordUnits)
                }
            }
        }
    }
    static func retrieve() -> [WordUnit] {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        let realmWordUnits = realm.objects(RealmWordUnit.self)
        return mutateRealmWordUnits(realmWordUnits: realmWordUnits)
    }
    
    private static func mutateWordUnits(wordUnits: [WordUnit]) -> [RealmWordUnit] {
        var realmWordUnits = [RealmWordUnit]()
        wordUnits.forEach { (wordUnit) in
            let realmSource = RealmWordUnit(wordUnit: wordUnit)
            realmWordUnits.append(realmSource)
        }
        return realmWordUnits
    }
    private static func mutateRealmWordUnits(realmWordUnits: Results<RealmWordUnit>) -> [WordUnit] {
        var wordUnits = [WordUnit]()
        realmWordUnits.forEach { (realmWordUnit) in
            let wordUnit = WordUnit(realmWordUnit: realmWordUnit)
            wordUnits.append(wordUnit)
        }
        return wordUnits
    }
}
