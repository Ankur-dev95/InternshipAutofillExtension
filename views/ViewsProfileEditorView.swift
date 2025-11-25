//
//  ProfileEditorView.swift
//  InternshipAutofillExtension
//
//  Created by Ankur on 11/25/25.
//

import SwiftUI

struct ProfileEditorView: View {
    @State var profile: ApplicantProfile
    let storageService: ProfileStorageService
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section("Profile Name") {
                TextField("Name", text: $profile.name)
            }
            
            Section("Personal Information") {
                TextField("First Name", text: $profile.personalInfo.firstName)
                TextField("Last Name", text: $profile.personalInfo.lastName)
                TextField("Email", text: $profile.personalInfo.email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                TextField("Phone", text: $profile.personalInfo.phone)
                    .textContentType(.telephoneNumber)
                    .keyboardType(.phonePad)
            }
            
            Section("Address") {
                TextField("Street", text: $profile.personalInfo.address.street)
                TextField("City", text: $profile.personalInfo.address.city)
                TextField("State", text: $profile.personalInfo.address.state)
                TextField("ZIP Code", text: $profile.personalInfo.address.zipCode)
                    .keyboardType(.numberPad)
                TextField("Country", text: $profile.personalInfo.address.country)
            }
            
            Section("Professional Links") {
                TextField("LinkedIn URL", text: $profile.personalInfo.linkedInURL)
                    .textContentType(.URL)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                TextField("Portfolio URL", text: $profile.personalInfo.portfolioURL)
                    .textContentType(.URL)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
                TextField("GitHub URL", text: $profile.personalInfo.githubURL)
                    .textContentType(.URL)
                    .keyboardType(.URL)
                    .textInputAutocapitalization(.never)
            }
            
            Section("Work Experience") {
                ForEach(profile.workExperiences) { experience in
                    NavigationLink(destination: WorkExperienceEditorView(
                        experience: experience,
                        onSave: { updated in
                            updateWorkExperience(updated)
                        },
                        onDelete: {
                            deleteWorkExperience(experience)
                        }
                    )) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(experience.position)
                                .font(.headline)
                            Text(experience.company)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(experience.dateRangeString)
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                
                Button {
                    addWorkExperience()
                } label: {
                    Label("Add Work Experience", systemImage: "plus")
                }
            }
            
            Section("Education") {
                ForEach(profile.education) { edu in
                    NavigationLink(destination: EducationEditorView(
                        education: edu,
                        onSave: { updated in
                            updateEducation(updated)
                        },
                        onDelete: {
                            deleteEducation(edu)
                        }
                    )) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(edu.institution)
                                .font(.headline)
                            Text("\(edu.degree) in \(edu.fieldOfStudy)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(edu.dateRangeString)
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                
                Button {
                    addEducation()
                } label: {
                    Label("Add Education", systemImage: "plus")
                }
            }
            
            Section("Skills") {
                ForEach(profile.skills.indices, id: \.self) { index in
                    HStack {
                        TextField("Skill", text: $profile.skills[index])
                        
                        Button(role: .destructive) {
                            profile.skills.remove(at: index)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundStyle(.red)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Button {
                    profile.skills.append("")
                } label: {
                    Label("Add Skill", systemImage: "plus")
                }
            }
            
            Section {
                Button {
                    storageService.setActiveProfile(profile)
                } label: {
                    if storageService.activeProfileId == profile.id {
                        Label("Active Profile", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    } else {
                        Text("Set as Active Profile")
                    }
                }
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveProfile()
                }
            }
        }
    }
    
    private func saveProfile() {
        storageService.saveProfile(profile)
    }
    
    private func addWorkExperience() {
        let newExperience = WorkExperience()
        profile.workExperiences.append(newExperience)
    }
    
    private func updateWorkExperience(_ updated: WorkExperience) {
        if let index = profile.workExperiences.firstIndex(where: { $0.id == updated.id }) {
            profile.workExperiences[index] = updated
        }
    }
    
    private func deleteWorkExperience(_ experience: WorkExperience) {
        profile.workExperiences.removeAll { $0.id == experience.id }
    }
    
    private func addEducation() {
        let newEducation = Education()
        profile.education.append(newEducation)
    }
    
    private func updateEducation(_ updated: Education) {
        if let index = profile.education.firstIndex(where: { $0.id == updated.id }) {
            profile.education[index] = updated
        }
    }
    
    private func deleteEducation(_ education: Education) {
        profile.education.removeAll { $0.id == education.id }
    }
}

// MARK: - Work Experience Editor

struct WorkExperienceEditorView: View {
    @State var experience: WorkExperience
    let onSave: (WorkExperience) -> Void
    let onDelete: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section("Position Details") {
                TextField("Job Title", text: $experience.position)
                TextField("Company", text: $experience.company)
                TextField("Location", text: $experience.location)
            }
            
            Section("Duration") {
                DatePicker("Start Date", selection: $experience.startDate, displayedComponents: [.date])
                
                Toggle("Current Position", isOn: $experience.isCurrentPosition)
                
                if !experience.isCurrentPosition {
                    DatePicker("End Date", selection: Binding(
                        get: { experience.endDate ?? Date() },
                        set: { experience.endDate = $0 }
                    ), displayedComponents: [.date])
                }
            }
            
            Section("Description") {
                TextEditor(text: $experience.description)
                    .frame(minHeight: 100)
            }
            
            Section {
                Button("Delete Experience", role: .destructive) {
                    onDelete()
                    dismiss()
                }
            }
        }
        .navigationTitle("Work Experience")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onSave(experience)
                    dismiss()
                }
            }
        }
    }
}

// MARK: - Education Editor

struct EducationEditorView: View {
    @State var education: Education
    let onSave: (Education) -> Void
    let onDelete: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section("School Details") {
                TextField("Institution", text: $education.institution)
                TextField("Degree", text: $education.degree)
                TextField("Field of Study", text: $education.fieldOfStudy)
                TextField("Location", text: $education.location)
            }
            
            Section("Duration") {
                DatePicker("Start Date", selection: $education.startDate, displayedComponents: [.date])
                
                Toggle("Currently Enrolled", isOn: $education.isCurrentlyEnrolled)
                
                if !education.isCurrentlyEnrolled {
                    DatePicker("End Date", selection: Binding(
                        get: { education.endDate ?? Date() },
                        set: { education.endDate = $0 }
                    ), displayedComponents: [.date])
                }
            }
            
            Section("Academic Details") {
                TextField("GPA", text: $education.gpa)
                    .keyboardType(.decimalPad)
            }
            
            Section {
                Button("Delete Education", role: .destructive) {
                    onDelete()
                    dismiss()
                }
            }
        }
        .navigationTitle("Education")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onSave(education)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileEditorView(
            profile: ApplicantProfile(),
            storageService: ProfileStorageService()
        )
    }
}
