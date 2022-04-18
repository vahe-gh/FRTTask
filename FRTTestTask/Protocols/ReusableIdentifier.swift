//
//  ReusableIdentifier.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 17.04.22.
//

import Foundation

protocol ReusableIdentifier {
    static var reusableId: String { get }
}

extension ReusableIdentifier {
    static var reusableId: String {
        return String(describing: self)
    }
}
