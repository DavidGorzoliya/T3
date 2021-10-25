//
//  String.swift
//  T3
//
//  Created by Давид Горзолия on 10/25/21.
//

import Foundation

extension String {
    var toDouble: Double? {
        Double(replacingOccurrences(of: ",", with: "."))
    }
}

