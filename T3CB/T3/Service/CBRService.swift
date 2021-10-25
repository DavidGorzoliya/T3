//
//  CBRService.swift
//  T3
//
//  Created by Давид Горзолия on 10/25/21.
//

import Foundation
import XMLParsing

final class CBRService {

    static let shared = CBRService()

    private var url: URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 10800) // MSK timezone
        let startDate = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -30, to: Date())!)
        let endDate = dateFormatter.string(from: Date())
        return URL(string: "https://cbr.ru/scripts/XML_dynamic.asp?date_req1=\(startDate)&date_req2=\(endDate)&VAL_NM_RQ=R01235")!
    }

    private init() {}

    func getAllDollarData(completion: @escaping (Result<[Record], Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, err in
            guard let data = data, err == nil else {
                return
            }
            do {
                let dollars = try XMLDecoder().decode(ValCurs.self, from: data)
                completion(.success(dollars.records))
            }
            catch {
                print("Error parsing XML data to swift object, error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}
