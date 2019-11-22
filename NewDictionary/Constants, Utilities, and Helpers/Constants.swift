//
//  Fonts.swift
//  WordList
//
//  Created by Alexander Parshakov on 01/10/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct UserDefaultKeys {
        static let lastUsedLanguage = "LastUsedLanguage"
    }
    
    struct Colors {
        
        private static func hexStringToUIColor (hex: String) -> UIColor {
            var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            
            if (cString.hasPrefix("#")) {
                cString.remove(at: cString.startIndex)
            }
            
            if ((cString.count) != 6) {
                return UIColor.gray
            }
            
            var rgbValue:UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgbValue)
            
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
        
        static let dictForeground = hexStringToUIColor(hex: "#dfe6ed")
        static let dictBackground = hexStringToUIColor(hex: "#4a76a8")
        static let lightBlue = hexStringToUIColor(hex: "#00baff")
        static let deepRed = hexStringToUIColor(hex: "#BB1517")
        static let mildRed = hexStringToUIColor(hex: "#FE4036")
        static let darkGrey = hexStringToUIColor(hex: "#2d3436")
        static let midGrey = hexStringToUIColor(hex: "#636e72")
        static let lightGrey = hexStringToUIColor(hex: "#999999")
        
        struct DarkModeSupport {
            static let inputFontColor = UIColor(named: "InputFontColor")
        }
    }
    
    struct Fonts {
        static let boldPalatino = "Palatino-Bold"
        static let italicPalatino = "Palatino-Italic"
        static let regularPalatino = "Palatino-Roman"
    }
    
    struct ResourceNames {
        static let basicLoader = "redLoader"
        static let completionAnimation = "completionAnimation"
        static let basicRefreshControl = "trailRefreshControl"
    }
    
    struct Localizables {
        
        struct Dictionary {
            static let mainTitle = Localizer.Localize("dictionary_main_title")
            static let dictionaryCell = "DictionaryCell"
            static let addTagsCell = "AddTagsCell"
            static let wordsSearchBarPlaceholder = Localizer.Localize("dictionary_search_words")
            static let tagsSearchBarPlaceholder = Localizer.Localize("dictionary_search_tags_to_add")
            static let contentPlaceholder = Localizer.Localize("dictionary_input_content")
            static let meaningPlaceholder = Localizer.Localize("dictionary_input_meaning")
            static let examplePlaceholder = Localizer.Localize("dictionary_input_example")
            static let notePlaceholder = Localizer.Localize("dictionary_input_note")
        }
        
        struct Sources {
            static let mainTitle = Localizer.Localize("sources_main_title")
            static let sourceCell = "SourceCell"
            static let selectSourceCell = "SelectSourceCell"
            static let sourceDictionaryCell = "SourceDictionaryCell"
        }
        
        struct Settings {
            static let mainTitle = Localizer.Localize("settings_main_title")
            static let myProfile = Localizer.Localize("settings_my_profile")
        }
        struct Languages {
            static let languageCell = "LanguageCell"
        }
        struct Tags {
        }
    }
    
    
}

