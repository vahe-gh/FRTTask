//
//  Date+Extensions.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 18.04.22.
//

import UIKit

extension Date {
    
    public init?(from string: String) {
        self.init()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }
    
    func formattedLocally() -> String {
        let localFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale.current)
        let formatter = DateFormatter()
        formatter.dateFormat = localFormat
        
        return formatter.string(from: self)
    }
    
}
