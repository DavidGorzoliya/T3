//
//  Model.swift
//  T3
//
//  Created by Давид Горзолия on 10/25/21.
//
import Foundation

struct ValCurs: Codable {
    var records: [Record]

    private enum CodingKeys: String, CodingKey {
        case records = "Record"
    }
}

struct Record: Codable {
    let date: String
    let value: String

    private enum CodingKeys: String, CodingKey {
        case value = "Value"
        case date = "Date"
    }
}

