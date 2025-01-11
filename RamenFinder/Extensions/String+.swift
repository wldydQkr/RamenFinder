//
//  String+.swift
//  RamenFinder
//
//  Created by 박지용 on 1/7/25.
//

import Foundation

// HTML 태그 제거 메서드
extension String {
    func stripHTML() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil)
        return attributedString?.string ?? self
    }
}
