//
//  SafariWebExtensionHandler.swift
//  InternshipAutofillExtension Extension
//
//  Created by Ankur on 11/24/25.
//

import SafariServices
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    
    private let profileStorage = ProfileStorageService()
    private let logger = Logger(subsystem: "com.internship.autofill", category: "extension")

    func beginRequest(with context: NSExtensionContext) {
        let request = context.inputItems.first as? NSExtensionItem

        let profile: UUID?
        if #available(iOS 17.0, macOS 14.0, *) {
            profile = request?.userInfo?[SFExtensionProfileKey] as? UUID
        } else {
            profile = request?.userInfo?["profile"] as? UUID
        }

        let message: Any?
        if #available(iOS 15.0, macOS 11.0, *) {
            message = request?.userInfo?[SFExtensionMessageKey]
        } else {
            message = request?.userInfo?["message"]
        }

        logger.info("Received message from browser.runtime.sendNativeMessage: \(String(describing: message)) (profile: \(profile?.uuidString ?? "none"))")

        // Handle the message
        Task { @MainActor in
            let responseData = await handleMessage(message)
            
            let response = NSExtensionItem()
            if #available(iOS 15.0, macOS 11.0, *) {
                response.userInfo = [ SFExtensionMessageKey: responseData ]
            } else {
                response.userInfo = [ "message": responseData ]
            }

            context.completeRequest(returningItems: [ response ], completionHandler: nil)
        }
    }
    
    // MARK: - Message Handling
    
    @MainActor
    private func handleMessage(_ message: Any?) -> [String: Any] {
        guard let messageDict = message as? [String: Any],
              let action = messageDict["action"] as? String else {
            return ["error": "Invalid message format"]
        }
        
        switch action {
        case "getActiveProfile":
            return getActiveProfileResponse()
            
        case "getAllProfiles":
            return getAllProfilesResponse()
            
        case "setActiveProfile":
            guard let profileId = messageDict["profileId"] as? String,
                  let uuid = UUID(uuidString: profileId) else {
                return ["error": "Invalid profile ID"]
            }
            return setActiveProfileResponse(uuid)
            
        case "saveProfile":
            guard let profileData = messageDict["profile"] as? [String: Any] else {
                return ["error": "Invalid profile data"]
            }
            return saveProfileResponse(profileData)
            
        default:
            return ["error": "Unknown action: \(action)"]
        }
    }
    
    // MARK: - Response Handlers
    
    @MainActor
    private func getActiveProfileResponse() -> [String: Any] {
        guard let activeProfile = profileStorage.getActiveProfile() else {
            return ["error": "No active profile"]
        }
        
        return [
            "success": true,
            "profile": activeProfile.toDictionary()
        ]
    }
    
    @MainActor
    private func getAllProfilesResponse() -> [String: Any] {
        let profiles = profileStorage.profiles.map { $0.toDictionary() }
        return [
            "success": true,
            "profiles": profiles
        ]
    }
    
    @MainActor
    private func setActiveProfileResponse(_ profileId: UUID) -> [String: Any] {
        guard let profile = profileStorage.getProfile(by: profileId) else {
            return ["error": "Profile not found"]
        }
        
        profileStorage.setActiveProfile(profile)
        return [
            "success": true,
            "message": "Active profile set"
        ]
    }
    
    @MainActor
    private func saveProfileResponse(_ profileData: [String: Any]) -> [String: Any] {
        // This would parse the profile data and save it
        // Implementation depends on your data structure
        return [
            "success": true,
            "message": "Profile saved (implementation pending)"
        ]
    }
}
