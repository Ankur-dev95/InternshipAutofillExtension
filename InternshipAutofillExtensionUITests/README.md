# Workday Job Autofill Safari Extension

A Safari extension that automatically fills Workday job application forms with your saved information.

## Project Structure

```
InternshipAutofillExtension/
├── Models/                                 # Data Models
│   ├── ApplicantProfile.swift             # Main profile data structure
│   ├── WorkExperience.swift               # Work experience entries
│   └── Education.swift                    # Education entries
│
├── Services/                               # Business Logic
│   └── ProfileStorageService.swift        # Persist and retrieve profiles
│
├── Views/                                  # SwiftUI Views (Main App)
│   ├── ProfileListView.swift              # List all profiles
│   └── ProfileEditorView.swift            # Edit profile details
│
├── Extension/                              # Safari Extension Files
│   ├── SafariWebExtensionHandler.swift    # Native messaging handler
│   ├── manifest.json                      # Extension manifest
│   ├── background.js                      # Background script
│   ├── content.js                         # Content script (injected into pages)
│   ├── popup.html                         # Extension popup UI
│   ├── popup.css                          # Popup styles
│   └── popup.js                           # Popup logic
│
└── Tests/
    ├── InternshipAutofillExtensionTests/       # Unit tests
    └── InternshipAutofillExtensionUITests/     # UI tests
```

## Architecture

### Native App (Swift/SwiftUI)
The native iOS/macOS app manages user profiles and communicates with the Safari extension:

- **Models**: Define the data structures for profiles, work experience, and education
- **Services**: Handle data persistence using UserDefaults (can be upgraded to CloudKit)
- **Views**: SwiftUI interfaces for managing profiles
- **SafariWebExtensionHandler**: Bridges communication between JavaScript and Swift

### Safari Extension (JavaScript)
The browser extension detects Workday pages and autofills forms:

- **background.js**: Handles communication between content scripts and native app
- **content.js**: Runs on Workday pages, detects forms, and fills fields
- **popup.html/css/js**: Extension popup UI for quick actions
- **manifest.json**: Defines extension permissions and configuration

## Key Features

### 1. Profile Management
- Create multiple profiles for different job types
- Store personal info, work experience, education, and skills
- Set an active profile for autofilling

### 2. Workday Detection
- Automatically detects Workday job application pages
- Identifies form fields using CSS selectors and data attributes

### 3. Smart Autofill
- Maps profile data to Workday form fields
- Handles text inputs, dropdowns, and date pickers
- Respects field validation

### 4. Native Communication
- Uses Safari's native messaging API
- Secure communication between extension and app
- Real-time profile synchronization

## How It Works

1. **User creates a profile** in the native app with their information
2. **User sets the profile as active**
3. **User visits a Workday job application page**
4. **Extension detects the Workday page** and shows autofill option
5. **User clicks autofill** (or uses keyboard shortcut ⌘⇧A)
6. **Extension requests profile data** from native app via native messaging
7. **Native app sends profile data** to extension
8. **Extension fills form fields** with profile data
9. **User reviews and submits** the application

## Workday Field Mapping

The extension maps profile fields to common Workday field patterns:

### Personal Information
- First Name → `input[name*="firstName"]` or `[data-automation-id="legalNameSection.legalName.firstName"]`
- Last Name → `input[name*="lastName"]`
- Email → `input[name*="email"]`
- Phone → `input[name*="phone"]`

### Address
- Street → `input[name*="address"]`
- City → `input[name*="city"]`
- State → `input[name*="state"]`
- ZIP → `input[name*="zip"]`

### Additional Fields
- LinkedIn → `input[name*="linkedin"]`
- Portfolio → `input[name*="portfolio"]`
- GitHub → `input[name*="github"]`

## Setup Instructions

### 1. Xcode Configuration
1. Add all files to appropriate targets
2. Ensure Safari Extension target includes:
   - manifest.json
   - All .js files
   - All HTML/CSS files
   - SafariWebExtensionHandler.swift

### 2. Permissions
Update manifest.json with actual bundle ID and permissions:
```json
"permissions": [
    "activeTab",
    "storage",
    "nativeMessaging"
],
"host_permissions": [
    "*://*.workday.com/*",
    "*://*.myworkday.com/*"
]
```

### 3. Native Messaging
1. Enable native messaging in Safari extension settings
2. Configure the native app's bundle identifier
3. Update background.js with correct application ID

### 4. Testing
1. Build and run the app in Xcode
2. Enable the Safari extension in Safari preferences
3. Navigate to a Workday job application
4. Test autofill functionality

## Keyboard Shortcuts

- **⌘ + Shift + A** (macOS) / **Ctrl + Shift + A** (Windows): Autofill current page

## Future Enhancements

### Phase 1 (MVP)
- [x] Basic profile management
- [x] Simple autofill for common fields
- [x] Safari extension popup

### Phase 2
- [ ] CloudKit sync across devices
- [ ] Cover letter templates
- [ ] Application tracking
- [ ] Resume upload handling

### Phase 3
- [ ] AI-powered field detection
- [ ] Custom field mapping
- [ ] Multi-page form support
- [ ] Application history and analytics

### Phase 4
- [ ] Chrome/Firefox extension ports
- [ ] LinkedIn import
- [ ] Document storage (resumes, cover letters)
- [ ] Interview scheduling integration

## Data Storage

### Current: UserDefaults
- Simple key-value storage
- Local to device
- Good for MVP

### Future: CloudKit
- Sync across devices
- Backup and restore
- Sharing profiles

## Security Considerations

1. **Data Privacy**: All data stored locally on device
2. **Secure Communication**: Uses Safari's secure messaging APIs
3. **No Analytics**: No user data sent to external servers
4. **Open Source**: Code can be audited for security

## Development Notes

### Adding New Form Fields
1. Identify the field selector in Workday
2. Add to `fillWorkdayFields()` in content.js
3. Add corresponding property to Swift models
4. Update UI in ProfileEditorView

### Supporting New Job Sites
1. Add URL patterns to manifest.json
2. Create site-specific field mapping function
3. Add site detection logic

## Troubleshooting

### Extension not loading
- Check Safari extension is enabled in preferences
- Verify manifest.json is valid
- Check Xcode console for errors

### Autofill not working
- Ensure profile is set as active
- Check browser console for JavaScript errors
- Verify Workday page is detected (check console logs)

### Native messaging failing
- Verify app is running
- Check bundle identifier matches
- Review permissions in manifest.json

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

[Your chosen license]

## Credits

Created by Ankur on 11/25/25
