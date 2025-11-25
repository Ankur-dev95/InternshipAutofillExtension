//
//  ContentView.swift
//  InternshipAutofillExtension
//
//  Created by Ankur on 11/25/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var storageService = ProfileStorageService()
    
    var body: some View {
        TabView {
            ProfileListView()
                .tabItem {
                    Label("Profiles", systemImage: "person.2.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .environmentObject(storageService)
    }
}

struct SettingsView: View {
    @EnvironmentObject var storageService: ProfileStorageService
    @State private var showingExportSheet = false
    @State private var showingImportSheet = false
    @State private var exportedData: Data?
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("Active Profile")
                        Spacer()
                        if let activeProfile = storageService.getActiveProfile() {
                            Text(activeProfile.name)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("None")
                                .foregroundStyle(.tertiary)
                        }
                    }
                } header: {
                    Text("Current Status")
                }
                
                Section {
                    Link(destination: URL(string: "x-apple.systempreferences:com.apple.Safari-Settings")!) {
                        Label("Safari Extension Settings", systemImage: "safari")
                    }
                    
                    Link(destination: URL(string: "https://www.workday.com")!) {
                        Label("Test on Workday", systemImage: "arrow.up.forward.app")
                    }
                } header: {
                    Text("Quick Actions")
                } footer: {
                    Text("Enable the extension in Safari settings to start autofilling")
                }
                
                Section {
                    Button {
                        showingExportSheet = true
                    } label: {
                        Label("Export All Profiles", systemImage: "square.and.arrow.up")
                    }
                    
                    Button {
                        showingImportSheet = true
                    } label: {
                        Label("Import Profiles", systemImage: "square.and.arrow.down")
                    }
                } header: {
                    Text("Data Management")
                }
                
                Section {
                    HStack {
                        Text("Total Profiles")
                        Spacer()
                        Text("\(storageService.profiles.count)")
                            .foregroundStyle(.secondary)
                    }
                    
                    if let activeProfile = storageService.getActiveProfile() {
                        HStack {
                            Text("Work Experiences")
                            Spacer()
                            Text("\(activeProfile.workExperiences.count)")
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("Education Entries")
                            Spacer()
                            Text("\(activeProfile.education.count)")
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text("Skills")
                            Spacer()
                            Text("\(activeProfile.skills.count)")
                                .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Statistics")
                }
                
                Section {
                    Link("How to Use", destination: URL(string: "https://example.com/help")!)
                    Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                    Link("Report an Issue", destination: URL(string: "https://github.com/yourrepo/issues")!)
                } header: {
                    Text("Support")
                }
                
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                } footer: {
                    VStack(spacing: 8) {
                        Text("Workday Job Autofill Extension")
                            .font(.caption)
                        Text("Save time on job applications")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Settings")
        }
        .fileExporter(
            isPresented: $showingExportSheet,
            document: ProfileDocument(profiles: storageService.profiles),
            contentType: .json,
            defaultFilename: "workday-profiles-\(Date().ISO8601Format()).json"
        ) { result in
            switch result {
            case .success(let url):
                print("Exported to: \(url)")
            case .failure(let error):
                print("Export failed: \(error)")
            }
        }
        .fileImporter(
            isPresented: $showingImportSheet,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            handleImport(result)
        }
    }
    
    private func handleImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            
            do {
                let data = try Data(contentsOf: url)
                _ = try storageService.importProfile(from: data)
                print("Import successful")
            } catch {
                print("Import failed: \(error)")
            }
            
        case .failure(let error):
            print("File selection failed: \(error)")
        }
    }
}

// MARK: - Document Type for Export

import UniformTypeIdentifiers

struct ProfileDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.json] }
    
    let profiles: [ApplicantProfile]
    
    init(profiles: [ApplicantProfile]) {
        self.profiles = profiles
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        let decoder = JSONDecoder()
        profiles = try decoder.decode([ApplicantProfile].self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(profiles)
        return FileWrapper(regularFileWithContents: data)
    }
}

#Preview {
    ContentView()
}

#Preview("Settings") {
    SettingsView()
        .environmentObject(ProfileStorageService())
}
