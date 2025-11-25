//
//  WorkExperience.swift
//  InternshipAutofillExtension
//
//  Created by Ankur on 11/25/25.
//

import Foundation

/// Represents a work experience entry
struct WorkExperience: Codable, Identifiable {
    let id: UUID
    var company: String
    var position: String
    var location: String
    var startDate: Date
    var endDate: Date?
    var isCurrentPosition: Bool
    var description: String
    var responsibilities: [String]
    
    init(
        id: UUID = UUID(),
        company: String = "",
        position: String = "",
        location: String = "",
        startDate: Date = Date(),
        endDate: Date? = nil,
        isCurrentPosition: Bool = false,
        description: String = "",
        responsibilities: [String] = []
    ) {
        self.id = id
        self.company = company
        self.position = position
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.isCurrentPosition = isCurrentPosition
        self.description = description
        self.responsibilities = responsibilities
    }
}

// MARK: - Convenience Extensions
extension WorkExperience {
    /// Convert to dictionary for JavaScript
    func toDictionary() -> [String: Any] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        
        var dict: [String: Any] = [
            "id": id.uuidString,
            "company": company,
            "position": position,
            "location": location,
            "startDate": dateFormatter.string(from: startDate),
            "isCurrentPosition": isCurrentPosition,
            "description": description,
            "responsibilities": responsibilities
        ]
        
        if let endDate = endDate, !isCurrentPosition {
            dict["endDate"] = dateFormatter.string(from: endDate)
        }
        
        return dict
    }
    
    /// Formatted date range string
    var dateRangeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        
        let start = formatter.string(from: startDate)
        
        if isCurrentPosition {
            return "\(start) - Present"
        } else if let end = endDate {
            return "\(start) - \(formatter.string(from: end))"
        } else {
            return start
        }
    }
}
