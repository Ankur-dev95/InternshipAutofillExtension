//
//  ProfileStorageService.swift
//  InternshipAutofillExtension
//
//  Created by Ankur on 11/25/25.
//

import Foundation

/// Service for persisting and retrieving applicant profiles
@MainActor
class ProfileStorageService: ObservableObject {
    
    @Published private(set) var profiles: [ApplicantProfile] = []
    @Published private(set) var activeProfileId: UUID?
    
    private let userDefaults = UserDefaults.standard
    private let profilesKey = "savedProfiles"
    private let activeProfileKey = "activeProfileId"
    
    init() {
        loadProfiles()
        loadActiveProfile()
    }
    
    // MARK: - Profile Management
    
    /// Load all saved profiles from storage
    func loadProfiles() {
        guard let data = userDefaults.data(forKey: profilesKey) else {
            profiles = []
            return
        }
        
        do {
            let decoder = JSONDecoder()
            profiles = try decoder.decode([ApplicantProfile].self, from: data)
        } catch {
            print("Error loading profiles: \(error)")
            profiles = []
        }
    }
    
    /// Save a new profile or update existing one
    func saveProfile(_ profile: ApplicantProfile) {
        var updatedProfile = profile
        updatedProfile.lastModified = Date()
        
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles[index] = updatedProfile
        } else {
            profiles.append(updatedProfile)
        }
        
        persistProfiles()
    }
    
    /// Delete a profile
    func deleteProfile(_ profile: ApplicantProfile) {
        profiles.removeAll { $0.id == profile.id }
        
        // If deleting active profile, clear it
        if activeProfileId == profile.id {
            activeProfileId = nil
            userDefaults.removeObject(forKey: activeProfileKey)
        }
        
        persistProfiles()
    }
    
    /// Get a specific profile by ID
    func getProfile(by id: UUID) -> ApplicantProfile? {
        profiles.first { $0.id == id }
    }
    
    /// Get the currently active profile
    func getActiveProfile() -> ApplicantProfile? {
        guard let activeProfileId = activeProfileId else { return nil }
        return getProfile(by: activeProfileId)
    }
    
    /// Set the active profile
    func setActiveProfile(_ profile: ApplicantProfile) {
        activeProfileId = profile.id
        userDefaults.set(profile.id.uuidString, forKey: activeProfileKey)
    }
    
    /// Create a new blank profile
    func createNewProfile(name: String = "New Profile") -> ApplicantProfile {
        let profile = ApplicantProfile(name: name)
        saveProfile(profile)
        return profile
    }
    
    // MARK: - Private Methods
    
    private func persistProfiles() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(profiles)
            userDefaults.set(data, forKey: profilesKey)
        } catch {
            print("Error saving profiles: \(error)")
        }
    }
    
    private func loadActiveProfile() {
        guard let idString = userDefaults.string(forKey: activeProfileKey),
              let uuid = UUID(uuidString: idString) else {
            return
        }
        activeProfileId = uuid
    }
    
    // MARK: - Export/Import
    
    /// Export profile as JSON data
    func exportProfile(_ profile: ApplicantProfile) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(profile)
    }
    
    /// Import profile from JSON data
    func importProfile(from data: Data) throws -> ApplicantProfile {
        let decoder = JSONDecoder()
        let profile = try decoder.decode(ApplicantProfile.self, from: data)
        saveProfile(profile)
        return profile
    }
}
