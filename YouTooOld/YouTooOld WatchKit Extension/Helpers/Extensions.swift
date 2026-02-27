//
//  Extensions.swift
//  YouTooOld WatchKit Extension
//

import Foundation

extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension URL {
    func appendingQuery(name: String, value: String) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        var items = components?.queryItems ?? []
        items.append(URLQueryItem(name: name, value: value))
        components?.queryItems = items
        return components?.url
    }
}
