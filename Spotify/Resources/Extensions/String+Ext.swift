//
//  String+Ext.swift
//  Spotify
//
//  Created by Amini on 09/11/22.
//

import UIKit

extension String {
    static func formattedDate(string: String) -> String{
        guard let date = DateFormatter.dateFormatter.date(from: string) else {
            return string
        }
        return DateFormatter.displayDateFormatter.string(from: date)
    }
}
