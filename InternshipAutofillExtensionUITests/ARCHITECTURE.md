# Architecture & Data Flow

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Native iOS/macOS App                    │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                   SwiftUI Views                       │  │
│  │  • ProfileListView                                    │  │
│  │  • ProfileEditorView                                  │  │
│  │  • SettingsView                                       │  │
│  └──────────────────────────────────────────────────────┘  │
│                          ↕                                   │
│  ┌──────────────────────────────────────────────────────┐  │
│  │                Services Layer                         │  │
│  │  • ProfileStorageService (manages profiles)          │  │
│  │  • UserDefaults (persistence)                        │  │
│  └──────────────────────────────────────────────────────┘  │
│                          ↕                                   │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              Data Models                              │  │
│  │  • ApplicantProfile                                   │  │
│  │  • WorkExperience                                     │  │
│  │  • Education                                          │  │
│  │  • PersonalInfo, Address                             │  │
│  └──────────────────────────────────────────────────────┘  │
│                          ↕                                   │
│  ┌──────────────────────────────────────────────────────┐  │
│  │        SafariWebExtensionHandler                      │  │
│  │  (Native Messaging Bridge)                           │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                           ↕
              Native Messaging API
                           ↕
┌─────────────────────────────────────────────────────────────┐
│                     Safari Extension                         │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              background.js                            │  │
│  │  • Message routing                                    │  │
│  │  • Native app communication                          │  │
│  │  • Profile data management                           │  │
│  └──────────────────────────────────────────────────────┘  │
│                          ↕                                   │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              content.js                               │  │
│  │  • Workday page detection                            │  │
│  │  • Form field detection                              │  │
│  │  • Autofill logic                                    │  │
│  │  • User notifications                                │  │
│  └──────────────────────────────────────────────────────┘  │
│                          ↕                                   │
│  ┌──────────────────────────────────────────────────────┐  │
│  │         popup.html/css/js                             │  │
│  │  • User interface                                     │  │
│  │  • Quick actions                                      │  │
│  │  • Profile selection                                  │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                           ↕
                    DOM Manipulation
                           ↕
┌─────────────────────────────────────────────────────────────┐
│                   Workday Web Page                           │
│  • Job application forms                                     │
│  • Input fields, dropdowns, textareas                       │
│  • Data automation IDs                                       │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow: Autofill Process

### 1. User Initiates Autofill
```
User on Workday page → Clicks extension icon OR presses ⌘⇧A
                     → content.js receives trigger
```

### 2. Request Profile Data
```
content.js → browser.runtime.sendMessage({action: "getActiveProfile"})
          ↓
background.js → Receives message
             → browser.runtime.sendNativeMessage()
          ↓
SafariWebExtensionHandler.swift → beginRequest()
                                → handleMessage()
                                → getActiveProfileResponse()
          ↓
ProfileStorageService → getActiveProfile()
                     → Returns ApplicantProfile
```

### 3. Return Profile Data
```
ProfileStorageService → ApplicantProfile.toDictionary()
                     ↓
SafariWebExtensionHandler → JSON response
                           ↓
background.js → Receives profile data
             → Sends to content.js
                           ↓
content.js → Receives profile data
```

### 4. Fill Form Fields
```
content.js → fillWorkdayFields(profile)
          ↓
          → Queries DOM for field selectors
          → Sets field values
          → Triggers input/change events
          ↓
Workday form → Fields populated
            → User reviews and submits
```

## Message Types

### Extension to Native App

#### Get Active Profile
```javascript
{
  "action": "getActiveProfile"
}
```

#### Get All Profiles
```javascript
{
  "action": "getAllProfiles"
}
```

#### Set Active Profile
```javascript
{
  "action": "setActiveProfile",
  "profileId": "UUID-string"
}
```

#### Save Profile
```javascript
{
  "action": "saveProfile",
  "profile": { /* profile data */ }
}
```

### Native App to Extension

#### Success Response
```javascript
{
  "success": true,
  "profile": {
    "id": "UUID",
    "name": "Profile Name",
    "personalInfo": { /* ... */ },
    "workExperiences": [ /* ... */ ],
    "education": [ /* ... */ ],
    "skills": [ /* ... */ ]
  }
}
```

#### Error Response
```javascript
{
  "success": false,
  "error": "Error message"
}
```

## Field Mapping Strategy

### Priority 1: Data Automation IDs
Workday uses specific automation IDs:
```javascript
document.querySelector('[data-automation-id="legalNameSection.legalName.firstName"]')
```

### Priority 2: Name Attributes
Common HTML name patterns:
```javascript
document.querySelector('input[name*="firstName"]')
```

### Priority 3: ID Attributes
Fallback to ID patterns:
```javascript
document.querySelector('#firstName, #first_name, #fname')
```

### Priority 4: Label Association
Find input by associated label text:
```javascript
// Find label with text "First Name"
// Then find associated input
```

## Storage Architecture

### UserDefaults Keys
```
savedProfiles       → Array of encoded ApplicantProfile objects
activeProfileId     → UUID string of active profile
```

### Data Structure
```json
{
  "savedProfiles": [
    {
      "id": "UUID",
      "name": "Software Engineering Profile",
      "personalInfo": {
        "firstName": "John",
        "lastName": "Doe",
        "email": "john@example.com",
        "phone": "+1234567890",
        "address": {
          "street": "123 Main St",
          "city": "San Francisco",
          "state": "CA",
          "zipCode": "94102",
          "country": "United States"
        },
        "linkedInURL": "https://linkedin.com/in/johndoe",
        "portfolioURL": "https://johndoe.com",
        "githubURL": "https://github.com/johndoe"
      },
      "workExperiences": [
        {
          "id": "UUID",
          "company": "Tech Corp",
          "position": "Software Engineer",
          "location": "San Francisco, CA",
          "startDate": "2020-01-01T00:00:00Z",
          "endDate": null,
          "isCurrentPosition": true,
          "description": "Building great software",
          "responsibilities": ["Coding", "Code review", "Mentoring"]
        }
      ],
      "education": [
        {
          "id": "UUID",
          "institution": "University of California",
          "degree": "Bachelor of Science",
          "fieldOfStudy": "Computer Science",
          "location": "Berkeley, CA",
          "startDate": "2016-08-01T00:00:00Z",
          "endDate": "2020-05-01T00:00:00Z",
          "isCurrentlyEnrolled": false,
          "gpa": "3.8",
          "honors": ["Dean's List", "Cum Laude"],
          "relevantCoursework": ["Data Structures", "Algorithms"]
        }
      ],
      "skills": [
        "Swift",
        "JavaScript",
        "Python",
        "iOS Development"
      ],
      "customFields": {},
      "lastModified": "2025-11-25T00:00:00Z"
    }
  ],
  "activeProfileId": "UUID"
}
```

## Security Considerations

### 1. Data Storage
- All data stored locally on device
- UserDefaults encrypted by system on iOS
- No cloud storage in MVP (can add CloudKit later)

### 2. Communication
- Native messaging uses Safari's secure API
- No external network requests
- No tracking or analytics

### 3. Permissions
- Minimal permissions requested
- Only access to Workday domains
- No access to other websites

### 4. Code Security
- No eval() or dynamic code execution
- Content Security Policy in manifest
- Input sanitization on all form fills

## Performance Optimizations

### 1. Lazy Loading
- Only load profiles when needed
- Cache active profile in memory

### 2. Efficient DOM Queries
- Use specific selectors
- Cache DOM references
- Debounce field updates

### 3. Background Script
- Use non-persistent background (event page)
- Unload when idle
- Quick wake-up on message

### 4. Data Size
- Compress profiles if needed
- Limit array sizes
- Remove unused fields

## Error Handling

### 1. Native Messaging Errors
```javascript
try {
    const response = await browser.runtime.sendNativeMessage(appId, message);
} catch (error) {
    // Handle native app not available
    showError("Please open the Workday Autofill app");
}
```

### 2. Profile Not Found
```swift
guard let profile = storageService.getActiveProfile() else {
    return ["error": "No active profile"]
}
```

### 3. Field Not Found
```javascript
function setFieldValue(selector, value) {
    const field = document.querySelector(selector);
    if (!field) {
        console.warn(`Field not found: ${selector}`);
        return;
    }
    // Fill field
}
```

### 4. Invalid Data
```swift
guard let messageDict = message as? [String: Any],
      let action = messageDict["action"] as? String else {
    return ["error": "Invalid message format"]
}
```

## Testing Strategy

### 1. Unit Tests
- Test profile CRUD operations
- Test data serialization
- Test field mapping logic

### 2. Integration Tests
- Test native messaging
- Test profile sync
- Test autofill flow

### 3. UI Tests
- Test profile creation flow
- Test profile editing
- Test settings

### 4. Manual Testing
- Test on real Workday sites
- Test various form layouts
- Test edge cases

## Deployment Checklist

- [ ] Update manifest.json with production IDs
- [ ] Add app icons (16, 32, 48, 96, 128)
- [ ] Configure URL scheme for deep linking
- [ ] Test on all supported macOS/iOS versions
- [ ] Test Safari extension activation
- [ ] Verify native messaging works
- [ ] Test on multiple Workday sites
- [ ] Create App Store screenshots
- [ ] Write privacy policy
- [ ] Prepare marketing materials
- [ ] Submit to App Store review
