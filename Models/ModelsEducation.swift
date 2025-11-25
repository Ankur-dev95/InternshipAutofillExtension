//
//  Education.swift
//  InternshipAutofillExtension
//
//  Created by Ankur on 11/25/25.
//

import Foundation

/// Represents an education entry
struct Education: Codable, Identifiable {
    let id: UUID
    var institution: String
    var degree: String
    var fieldOfStudy: String
    var location: String
    var startDate: Date
    var endDate: Date?
    var isCurrentlyEnrolled: Bool
    var gpa: String
    var honors: [String]
    var relevantCoursework: [String]
    
    init(
        id: UUID = UUID(),
        institution: String = "",
        degree: String = "",
        fieldOfStudy: String = "",
        location: String = "",
        startDate: Date = Date(),
        endDate: Date? = nil,
        isCurrentlyEnrolled: Bool = false,
        gpa: String = "",
        honors: [String] = [],
        relevantCoursework: [String] = []
    ) {
        self.id = id
        self.institution = institution
        self.degree = degree
        self.fieldOfStudy = fieldOfStudy
        self.location = location
        self.startDate = startDate
        self.endDate = endDate
        self.isCurrentlyEnrolled = isCurrentlyEnrolled
        self.gpa = gpa
        self.honors = honors
        self.relevantCoursework = relevantCoursework
    }
}

// MARK: - Convenience Extensions
extension Education {
    /// Convert to dictionary for JavaScript
    func toDictionary() -> [String: Any] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        
        var dict: [String: Any] = [
            "id": id.uuidString,
            "institution": institution,
            "degree": degree,
            "fieldOfStudy": fieldOfStudy,
            "location": location,
            "startDate": dateFormatter.string(from: startDate),
            "isCurrentlyEnrolled": isCurrentlyEnrolled,
            "gpa": gpa,
            "honors": honors,
            "relevantCoursework": relevantCoursework
        ]
        
        if let endDate = endDate, !isCurrentlyEnrolled {
            dict["endDate"] = dateFormatter.string(from: endDate)
        }
        
        return dict
    }
    
    /// Formatted date range string
    var dateRangeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        
        let start = formatter.string(from: startDate)
        
        if isCurrentlyEnrolled {
            return "\(start) - Present"
        } else if let end = endDate {
            return "\(start) - \(formatter.string(from: end))"
        } else {
            return start
        }
    }
}
