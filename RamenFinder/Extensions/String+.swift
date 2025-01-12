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
    
    // 문자열을 Double로 변환하고, 1e7로 나눈 좌표값으로 반환합니다.
    func toCoordinateDouble() -> Double? {
        guard let doubleValue = Double(self) else { return nil }
        return doubleValue / 1_0000000.0
    }
}
