//
//  ProfileListView.swift
//  InternshipAutofillExtension
//
//  Created by Ankur on 11/25/25.
//

import SwiftUI

struct ProfileListView: View {
    @StateObject private var storageService = ProfileStorageService()
    @State private var showingNewProfile = false
    @State private var selectedProfile: ApplicantProfile?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(storageService.profiles) { profile in
                    NavigationLink(value: profile) {
                        ProfileRow(
                            profile: profile,
                            isActive: storageService.activeProfileId == profile.id
                        )
                    }
                }
                .onDelete(perform: deleteProfiles)
            }
            .navigationTitle("Profiles")
            .navigationDestination(for: ApplicantProfile.self) { profile in
                ProfileEditorView(profile: profile, storageService: storageService)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingNewProfile = true
                    } label: {
                        Label("Add Profile", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewProfile) {
                NewProfileSheet(storageService: storageService)
            }
            .overlay {
                if storageService.profiles.isEmpty {
                    ContentUnavailableView {
                        Label("No Profiles", systemImage: "person.crop.circle.badge.plus")
                    } description: {
                        Text("Create a profile to start autofilling job applications")
                    } actions: {
                        Button("Create Profile") {
                            showingNewProfile = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
    }
    
    private func deleteProfiles(at offsets: IndexSet) {
        for index in offsets {
            let profile = storageService.profiles[index]
            storageService.deleteProfile(profile)
        }
    }
}

struct ProfileRow: View {
    let profile: ApplicantProfile
    let isActive: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(profile.name)
                    .font(.headline)
                
                if !profile.personalInfo.email.isEmpty {
                    Text(profile.personalInfo.email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Text("Modified \(profile.lastModified, style: .relative) ago")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            
            Spacer()
            
            if isActive {
                Label("Active", systemImage: "checkmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.green)
            }
        }
        .padding(.vertical, 4)
    }
}

struct NewProfileSheet: View {
    @Environment(\.dismiss) private var dismiss
    let storageService: ProfileStorageService
    @State private var profileName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Profile Name", text: $profileName)
                } header: {
                    Text("Profile Details")
                } footer: {
                    Text("Choose a descriptive name like 'Software Engineering' or 'Data Science'")
                }
            }
            .navigationTitle("New Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createProfile()
                    }
                    .disabled(profileName.isEmpty)
                }
            }
        }
    }
    
    private func createProfile() {
        let profile = storageService.createNewProfile(name: profileName)
        storageService.setActiveProfile(profile)
        dismiss()
    }
}

#Preview {
    ProfileListView()
}
