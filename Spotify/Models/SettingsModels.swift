//
//  SettingsModels.swift
//  Spotify
//
//  Created by Amini on 30/12/21.
//

import Foundation

struct Section {
    
    let title: String
    let options: [Option]
    
}

struct Option {
    let title: String
    let handler: () -> Void
}
