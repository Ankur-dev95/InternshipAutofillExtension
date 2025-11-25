//
//  ApplicantProfile.swift
//  InternshipAutofillExtension
//
//  Created by Ankur on 11/25/25.
//

import Foundation

/// Represents a complete applicant profile for job applications
struct ApplicantProfile: Codable, Identifiable {
    let id: UUID
    var name: String
    var personalInfo: PersonalInfo
    var workExperiences: [WorkExperience]
    var education: [Education]
    var skills: [String]
    var customFields: [String: String]
    var lastModified: Date
    
    init(
        id: UUID = UUID(),
        name: String = "Default Profile",
        personalInfo: PersonalInfo = PersonalInfo(),
        workExperiences: [WorkExperience] = [],
        education: [Education] = [],
        skills: [String] = [],
        customFields: [String: String] = [:],
        lastModified: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.personalInfo = personalInfo
        self.workExperiences = workExperiences
        self.education = education
        self.skills = skills
        self.customFields = customFields
        self.lastModified = lastModified
    }
}

/// Personal information for the applicant
struct PersonalInfo: Codable {
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var address: Address
    var linkedInURL: String
    var portfolioURL: String
    var githubURL: String
    
    init(
        firstName: String = "",
        lastName: String = "",
        email: String = "",
        phone: String = "",
        address: Address = Address(),
        linkedInURL: String = "",
        portfolioURL: String = "",
        githubURL: String = ""
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.address = address
        self.linkedInURL = linkedInURL
        self.portfolioURL = portfolioURL
        self.githubURL = githubURL
    }
}

/// Address information
struct Address: Codable {
    var street: String
    var city: String
    var state: String
    var zipCode: String
    var country: String
    
    init(
        street: String = "",
        city: String = "",
        state: String = "",
        zipCode: String = "",
        country: String = "United States"
    ) {
        self.street = street
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.country = country
    }
}

// MARK: - Convenience Extensions
extension ApplicantProfile {
    /// Convert profile to a dictionary for sending to JavaScript
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id.uuidString,
            "name": name,
            "personalInfo": [
                "firstName": personalInfo.firstName,
                "lastName": personalInfo.lastName,
                "email": personalInfo.email,
                "phone": personalInfo.phone,
                "address": [
                    "street": personalInfo.address.street,
                    "city": personalInfo.address.city,
                    "state": personalInfo.address.state,
                    "zipCode": personalInfo.address.zipCode,
                    "country": personalInfo.address.country
                ],
                "linkedInURL": personalInfo.linkedInURL,
                "portfolioURL": personalInfo.portfolioURL,
                "githubURL": personalInfo.githubURL
            ],
            "workExperiences": workExperiences.map { $0.toDictionary() },
            "education": education.map { $0.toDictionary() },
            "skills": skills,
            "customFields": customFields
        ]
        
        return dict
    }
}
