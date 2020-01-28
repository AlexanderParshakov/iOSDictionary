//
//  RealmManager.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/3/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let schemaVersion: UInt64 = 6
    
    private init() {}
    
    static func printPath() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    static func removeAllObjects(ofType type: Object.Type) {
        let config = Realm.Configuration(
            schemaVersion: schemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < schemaVersion) {
                }
            })
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(type))
        }
    }
    
    class Sources { } // extended
    class WordUnits { } // extended
    class WordTags { } // extended
    class Tags { } // extended
    class Languages { } // extended
    class Types { } // extended
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
        return mutateRealmSources(realmSources: realmSources).sorted(by: { $0.name < $1.name })
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
                    schemaVersion: RealmManager.schemaVersion,
                    migrationBlock: { migration, oldSchemaVersion in
                        if (oldSchemaVersion < RealmManager.schemaVersion) {
                        }
                    })
                Realm.Configuration.defaultConfiguration = config
                let realm = try! Realm()
//                let termList = realm.objects(RealmTermList.self).first!
                try! realm.write {
                    realm.delete(realm.objects(RealmWordUnit.self))
                    realm.delete(realm.objects(RealmWordTag.self))
                    realm.add(realmWordUnits)
                }
            }
        }
    }
    static func persistTerm(term: WordUnit) {
        let realmTerm = RealmWordUnit(wordUnit: term)
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let config = Realm.Configuration(
                    schemaVersion: RealmManager.schemaVersion,
                    migrationBlock: { migration, oldSchemaVersion in
                        if (oldSchemaVersion < RealmManager.schemaVersion) {
                        }
                    })
                Realm.Configuration.defaultConfiguration = config
                let realm = try! Realm()
                try! realm.write {
                    realm.add(realmTerm)
                }
            }
        }
    }
    static func retrieve() -> [WordUnit] {
        let config = Realm.Configuration(
            schemaVersion: RealmManager.schemaVersion,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < RealmManager.schemaVersion) {
                }
            })
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

extension RealmManager.WordTags {
    
    static func persist(fromArray tags: [Tag]) {
        let realmTags = mutateTags(tags: tags)
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let config = Realm.Configuration(
                    schemaVersion: RealmManager.schemaVersion,
                    migrationBlock: { migration, oldSchemaVersion in
                        if (oldSchemaVersion < RealmManager.schemaVersion) {
                        }
                    })
                Realm.Configuration.defaultConfiguration = config
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(realm.objects(RealmWordTag.self))
                    realm.add(realmTags)
                }
            }
        }
    }
    static func retrieve() -> [Tag] {
        let realm = try! Realm()
        let realmWordTags = realm.objects(RealmWordTag.self)
        return mutateRealmWordUnits(realmWordTags: realmWordTags)
    }
    
    private static func mutateTags(tags: [Tag]) -> [RealmWordTag] {
        var realmWordTags = [RealmWordTag]()
        tags.forEach { (tag) in
            let realmTag = RealmWordTag(tag: tag)
            realmWordTags.append(realmTag)
        }
        return realmWordTags
    }
    private static func mutateRealmWordUnits(realmWordTags: Results<RealmWordTag>) -> [Tag] {
        var tags = [Tag]()
        realmWordTags.forEach { (realmTag) in
            let tag = Tag(realmWordTag: realmTag)
            tags.append(tag)
        }
        return tags
    }
}

extension RealmManager.Tags {
    
    static func persist(fromArray tags: [Tag]) {
        let realmTags = mutateTags(tags: tags)
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let config = Realm.Configuration(
                    schemaVersion: RealmManager.schemaVersion,
                    migrationBlock: { migration, oldSchemaVersion in
                        if (oldSchemaVersion < RealmManager.schemaVersion) {
                        }
                    })
                Realm.Configuration.defaultConfiguration = config
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(realm.objects(RealmTag.self))
                    realm.add(realmTags)
                }
            }
        }
    }
    static func persistTag(tag: Tag) {
        let realmTag = RealmTag(tag: tag)
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let config = Realm.Configuration(
                    schemaVersion: RealmManager.schemaVersion,
                    migrationBlock: { migration, oldSchemaVersion in
                        if (oldSchemaVersion < RealmManager.schemaVersion) {
                        }
                    })
                Realm.Configuration.defaultConfiguration = config
                let realm = try! Realm()
                try! realm.write {
                    realm.add(realmTag)
                }
            }
        }
    }
    static func retrieve() -> [Tag] {
        let realm = try! Realm()
        let realmTags = realm.objects(RealmTag.self)
        return mutateRealmWordUnits(realmTags: realmTags)
    }
    
    private static func mutateTags(tags: [Tag]) -> [RealmTag] {
        var realmTags = [RealmTag]()
        tags.forEach { (tag) in
            let realmTag = RealmTag(tag: tag)
            realmTags.append(realmTag)
        }
        return realmTags
    }
    private static func mutateRealmWordUnits(realmTags: Results<RealmTag>) -> [Tag] {
        var tags = [Tag]()
        realmTags.forEach { (realmTag) in
            let tag = Tag(realmTag: realmTag)
            tags.append(tag)
        }
        return tags
    }
}

extension RealmManager.Languages {
    
    static func persist(fromArray languages: [Language]) {
        let realmLanguages = mutateLanguages(languages: languages)
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let config = Realm.Configuration(
                    schemaVersion: RealmManager.schemaVersion,
                    migrationBlock: { migration, oldSchemaVersion in
                        if (oldSchemaVersion < RealmManager.schemaVersion) {
                        }
                    })
                Realm.Configuration.defaultConfiguration = config
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(realm.objects(RealmLanguage.self))
                    realm.add(realmLanguages)
                }
            }
        }
    }
    static func retrieve() -> [Language] {
        let realm = try! Realm()
        let realmLanguages = realm.objects(RealmLanguage.self)
        return mutateRealmLanguages(realmLanguages: realmLanguages)
    }
    
    private static func mutateLanguages(languages: [Language]) -> [RealmLanguage] {
        var realmLanguages = [RealmLanguage]()
        languages.forEach { (lang) in
            let realmLanguage = RealmLanguage(language: lang)
            realmLanguages.append(realmLanguage)
        }
        return realmLanguages
    }
    private static func mutateRealmLanguages(realmLanguages: Results<RealmLanguage>) -> [Language] {
        var languages = [Language]()
        realmLanguages.forEach { (realmLanguage) in
            let language = Language(realmLanguage: realmLanguage)
            languages.append(language)
        }
        return languages
    }
}

extension RealmManager.Types {
    static func persist(fromArray types: [TermType]) {
        let realmTypes = mutateTypes(types: types)
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let config = Realm.Configuration(
                    schemaVersion: RealmManager.schemaVersion,
                    migrationBlock: { migration, oldSchemaVersion in
                        if (oldSchemaVersion < RealmManager.schemaVersion) {
                        }
                    })
                Realm.Configuration.defaultConfiguration = config
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(realm.objects(RealmType.self))
                    realm.add(realmTypes)
                }
            }
        }
    }
    static func retrieve() -> [TermType] {
        let realm = try! Realm()
        let realmTypes = realm.objects(RealmType.self)
        return mutateRealmTypes(realmTypes: realmTypes)
    }
    
    private static func mutateTypes(types: [TermType]) -> [RealmType] {
        var realmTypes = [RealmType]()
        types.forEach { (type) in
            let realmType = RealmType(type: type)
            realmTypes.append(realmType)
        }
        return realmTypes
    }
    private static func mutateRealmTypes(realmTypes: Results<RealmType>) -> [TermType] {
        var types = [TermType]()
        realmTypes.forEach { (realmType) in
            let type = TermType(realmType: realmType)
            types.append(type)
        }
        return types
    }
}

