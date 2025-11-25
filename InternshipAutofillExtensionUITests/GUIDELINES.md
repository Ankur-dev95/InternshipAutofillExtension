# File-by-File Guide: What Each File Does & What You Should Do

## 📱 Native App Files (Swift/SwiftUI)

### Models/ - Data Structures

#### `Models/ApplicantProfile.swift`
**What it does:**
- Defines the main profile structure containing all user data
- Includes personal info, work experience, education, skills
- Provides conversion methods to send data to JavaScript
- Implements Codable for JSON serialization

**What you should do:**
- ✅ **Leave as-is** - This is complete and ready to use
- 🔧 **Optional**: Add more custom fields to `customFields` dictionary
- 🔧 **Optional**: Add resume/cover letter file paths in the future
- ⚠️ **Add to BOTH targets**: Main app AND Safari extension

**When to modify:**
- When you need to track additional user information
- When adding support for resume uploads or cover letters

---

#### `Models/WorkExperience.swift`
**What it does:**
- Represents a single job/internship entry
- Tracks company, position, dates, responsibilities
- Handles date formatting for display and export
- Converts to dictionary for JavaScript

**What you should do:**
- ✅ **Leave as-is** - Complete implementation
- 🔧 **Optional**: Add fields like "achievements" or "technologies used"
- ⚠️ **Add to BOTH targets**: Main app AND Safari extension

**When to modify:**
- When you want to capture more detailed work history
- When Workday forms require additional fields

---

#### `Models/Education.swift`
**What it does:**
- Represents educational background entries
- Tracks school, degree, GPA, honors, coursework
- Handles date formatting and display
- Converts to dictionary for JavaScript

**What you should do:**
- ✅ **Leave as-is** - Complete implementation
- 🔧 **Optional**: Add fields like "thesis title" or "activities"
- ⚠️ **Add to BOTH targets**: Main app AND Safari extension

**When to modify:**
- When you need to track certifications or bootcamps
- When Workday requires additional academic info

---

### Services/ - Business Logic

#### `Services/ProfileStorageService.swift`
**What it does:**
- Manages all profile CRUD operations (Create, Read, Update, Delete)
- Persists profiles to UserDefaults
- Tracks the active profile
- Handles import/export of profiles

**What you should do:**
- ✅ **Leave as-is for MVP** - Fully functional
- 🔧 **Future upgrade**: Replace UserDefaults with CloudKit for sync
- 🔧 **Future upgrade**: Add encryption for sensitive data
- ⚠️ **Add to Main App target ONLY**

**When to modify:**
- When implementing CloudKit sync across devices
- When adding backup/restore functionality
- When implementing profile sharing

---

### Views/ - User Interface

#### `Views/ContentView.swift`
**What it does:**
- Main app entry point with TabView
- Shows Profiles tab and Settings tab
- Provides profile export/import functionality
- Displays app statistics and quick actions

**What you should do:**
- ✅ **Use as starting point** - This works out of the box
- 🔧 **Customize**: Change tab icons or add more tabs
- 🔧 **Update URLs**: Replace example.com URLs with your actual help/privacy URLs
- ⚠️ **Add to Main App target ONLY**

**When to modify:**
- When adding more features (like application tracking)
- When customizing the UI design
- When adding onboarding screens

---

#### `Views/ProfileListView.swift`
**What it does:**
- Lists all saved profiles
- Shows active profile indicator
- Allows creating, editing, deleting profiles
- Provides navigation to profile editor

**What you should do:**
- ✅ **Leave as-is** - Complete implementation
- 🔧 **Optional**: Add search functionality
- 🔧 **Optional**: Add profile templates (e.g., "Software Eng Template")
- ⚠️ **Add to Main App target ONLY**

**When to modify:**
- When adding profile filtering or sorting
- When implementing profile duplication
- When adding profile templates

---

#### `Views/ProfileEditorView.swift`
**What it does:**
- Full-featured profile editing interface
- Edits personal info, work experience, education, skills
- Nested editors for work and education entries
- Sets active profile

**What you should do:**
- ✅ **Leave as-is** - Fully functional
- 🔧 **Customize**: Adjust form layout or validation
- 🔧 **Add**: Form validation (email format, phone format)
- ⚠️ **Add to Main App target ONLY**

**When to modify:**
- When improving UX with better date pickers
- When adding photo/resume upload
- When implementing form validation

---

#### `InternshipAutofillExtensionApp.swift`
**What it does:**
- App entry point (@main)
- Creates WindowGroup with ContentView
- Adds macOS menu commands (Safari preferences shortcut)
- Provides Settings window on macOS

**What you should do:**
- ✅ **Leave as-is** - Ready to use
- 🔧 **Update URLs**: Replace help URL with your actual link
- 🔧 **Optional**: Add more menu commands
- ⚠️ **Add to Main App target ONLY**

**When to modify:**
- When adding keyboard shortcuts
- When customizing menu structure
- When adding app lifecycle events

---

## 🧩 Safari Extension Files

### JavaScript Files

#### `Extension/background.js` (or just `background.js`)
**What it does:**
- Background service worker for the extension
- Routes messages between content script and native app
- Handles native messaging with SafariWebExtensionHandler
- Manages extension toolbar icon clicks

**What you should do:**
- 🔧 **REQUIRED**: Update `"application.id"` to your actual bundle identifier
  ```javascript
  // Change this line:
  const response = await browser.runtime.sendNativeMessage(
      "com.yourcompany.InternshipAutofillExtension.Extension",  // <-- Update!
      { action: "getActiveProfile" }
  );
  ```
- ✅ **Otherwise leave as-is** - Core logic is complete
- ⚠️ **Add to Extension target ONLY**

**When to modify:**
- When adding more message types
- When implementing badge notifications
- When adding context menus

---

#### `Extension/content.js` (or just `content.js`)
**What it does:**
- Runs on every Workday page
- Detects Workday job application forms
- Implements autofill logic
- Shows notifications to user
- Listens for keyboard shortcuts

**What you should do:**
- ✅ **Start with this version** - Basic implementation ready
- 🔧 **IMPORTANT**: Test on real Workday sites and update selectors
- 🔧 **Import field mapper**: Add this at the top:
  ```javascript
  // Add this line to use the advanced field mapper
  // (will do this when manifest.json is configured)
  ```
- ⚠️ **Add to Extension target ONLY**

**When to modify:**
- When Workday changes their HTML structure
- When adding support for work experience filling
- When adding support for education filling
- When improving field detection accuracy

---

#### `Extension/workday-field-mapper.js`
**What it does:**
- Advanced field detection with multiple strategies
- Smart form filling with proper event triggering
- Handles text inputs, dropdowns, checkboxes
- Provides fallback selectors for reliability

**What you should do:**
- ✅ **Use as reference** - This is your field detection library
- 🔧 **Update selectors**: Test on real Workday sites and add/update selectors
- 🔧 **Add methods**: Create `fillWorkExperience()` and `fillEducation()` methods
- ⚠️ **Add to Extension target ONLY**

**When to modify:**
- When discovering new Workday field patterns
- When adding support for more field types
- When implementing multi-step form support

---

#### `Extension/popup.js`
**What it does:**
- Powers the extension popup UI
- Loads and displays active profile
- Triggers autofill when button clicked
- Opens native app settings

**What you should do:**
- 🔧 **REQUIRED**: Update app URL scheme if you implement deep linking
  ```javascript
  const appURL = 'internshipautofill://settings';  // Update to match your URL scheme
  ```
- ✅ **Otherwise leave as-is**
- ⚠️ **Add to Extension target ONLY**

**When to modify:**
- When adding profile switching in popup
- When showing autofill preview
- When adding quick profile editing

---

### HTML/CSS Files

#### `Extension/popup.html`
**What it does:**
- Extension popup user interface
- Shows active profile and autofill button
- Provides quick access to app settings

**What you should do:**
- ✅ **Leave as-is** - Clean, functional UI
- 🔧 **Optional**: Customize text and styling
- 🔧 **Optional**: Add profile selector dropdown
- ⚠️ **Add to Extension target ONLY**

**When to modify:**
- When redesigning the popup UI
- When adding more features to popup
- When localizing to other languages

---

#### `Extension/popup.css`
**What it does:**
- Styles for the extension popup
- Apple-style design with modern colors
- Responsive button styles

**What you should do:**
- ✅ **Leave as-is** - Looks professional
- 🔧 **Optional**: Customize colors to match your branding
- ⚠️ **Add to Extension target ONLY**

**When to modify:**
- When implementing dark mode
- When matching your brand colors
- When adding animations

---

### Configuration Files

#### `Extension/manifest.json`
**What it does:**
- Extension configuration and permissions
- Defines which sites extension runs on
- Specifies background and content scripts
- Sets up keyboard shortcuts

**What you should do:**
- 🔧 **REQUIRED**: Update these fields:
  ```json
  {
    "name": "Your Extension Name",
    "description": "Your description",
    "browser_specific_settings": {
      "gecko": {
        "id": "your-extension-id@yourcompany.com"  // Update!
      }
    }
  }
  ```
- 🔧 **IMPORTANT**: Verify the paths match your file structure
- 🔧 **Optional**: Add more Workday URL patterns if needed
- ⚠️ **Add to Extension target ONLY**
- ⚠️ **Must be in Copy Bundle Resources build phase**

**When to modify:**
- When supporting more job sites (not just Workday)
- When adding new permissions
- When updating version number

---

### Swift Bridge

#### `SafariWebExtensionHandler.swift`
**What it does:**
- Bridge between JavaScript and Swift
- Receives messages from extension via native messaging
- Fetches profile data from ProfileStorageService
- Returns data to extension as JSON

**What you should do:**
- ✅ **Leave as-is** - Complete implementation
- 🔧 **Optional**: Add more message handlers (like "saveProfile")
- 🔧 **Optional**: Add better error handling
- ⚠️ **Add to Extension target ONLY**
- ⚠️ **Must also import Models for ApplicantProfile**

**When to modify:**
- When adding new message types
- When implementing profile syncing
- When adding logging/analytics

---

## 📖 Documentation Files

#### `README.md`
**What it does:**
- Project overview and introduction
- Feature list and architecture overview
- Quick start guide
- Contribution guidelines

**What you should do:**
- 🔧 **Update**: Replace placeholder text with your info
- 🔧 **Update**: Add your GitHub repo URL
- 🔧 **Update**: Add screenshots when ready
- ⚠️ **Not added to any target** - Just documentation

**When to modify:**
- When adding new features
- When preparing for open source release
- When creating documentation site

---

#### `ARCHITECTURE.md` (Current File)
**What it does:**
- Detailed system architecture
- Data flow diagrams
- Message protocols
- Security and performance notes

**What you should do:**
- ✅ **Read thoroughly** - Understand how everything connects
- 🔧 **Reference**: Use when debugging message flow
- 🔧 **Update**: Add notes as you discover new patterns
- ⚠️ **Not added to any target** - Just documentation

**When to modify:**
- When architecture changes
- When documenting new features
- When onboarding new developers

---

#### `SETUP.md`
**What it does:**
- Step-by-step setup instructions
- Xcode configuration guide
- Testing procedures
- Troubleshooting tips

**What you should do:**
- ✅ **Follow carefully** - This is your setup checklist
- 🔧 **Check off items** as you complete them
- 🔧 **Add notes**: Document any issues you encounter
- ⚠️ **Not added to any target** - Just documentation

**When to modify:**
- When setup process changes
- When discovering new gotchas
- When adding platform-specific instructions

---

#### `XCODE_STRUCTURE.md`
**What it does:**
- Visual guide to organizing files in Xcode
- Target membership checklists
- Build settings reference
- Common issues and solutions

**What you should do:**
- ✅ **Use as reference** - When adding files to Xcode
- 🔧 **Follow the target membership guide**
- 🔧 **Check**: Verify your structure matches
- ⚠️ **Not added to any target** - Just documentation

---

#### `FILE_STRUCTURE_SUMMARY.md`
**What it does:**
- Complete file listing
- Technology stack overview
- Next steps roadmap
- Quick reference

**What you should do:**
- ✅ **Overview** - Get the big picture
- 🔧 **Checklist**: Use for tracking progress
- 🔧 **Planning**: Reference when planning features
- ⚠️ **Not added to any target** - Just documentation

---

## 🎯 Quick Action Guide

### For Immediate Setup (Do These First):

1. **Add all Swift files to Xcode**
   - Models → Both Main App AND Extension targets
   - Services → Main App target only
   - Views → Main App target only
   - App.swift → Main App target only
   - SafariWebExtensionHandler.swift → Extension target only

2. **Add all Extension files to Xcode**
   - All .js, .html, .css files → Extension target only
   - manifest.json → Extension target only
   - Verify all are in "Copy Bundle Resources" build phase

3. **Update bundle identifiers**
   - Main app: `com.yourcompany.InternshipAutofillExtension`
   - Extension: `com.yourcompany.InternshipAutofillExtension.Extension`

4. **Update background.js**
   - Replace `"application.id"` with your extension bundle ID

5. **Create extension icons**
   - Need: 16x16, 32x32, 48x48, 96x96, 128x128
   - Add to Extension/images/
   - Add to Extension target

6. **Build and test**
   - Build app (⌘B)
   - Run app (⌘R)
   - Enable extension in Safari
   - Test on a Workday site

---

### For Customization (Do These Later):

1. **Test on real Workday sites**
   - Visit actual job applications
   - Check which fields fill correctly
   - Update selectors in content.js or workday-field-mapper.js

2. **Improve field detection**
   - Add more selectors to workday-field-mapper.js
   - Test with different companies' Workday instances
   - Handle edge cases

3. **Add work experience filling**
   - Detect work experience sections in forms
   - Fill multiple experiences
   - Handle "Add More" buttons

4. **Add education filling**
   - Detect education sections
   - Fill degree, major, GPA fields
   - Handle multiple schools

5. **Implement resume upload**
   - Store resume file path in profile
   - Detect file upload fields
   - Trigger file picker (may need user interaction)

---

### For Production (Do Before Release):

1. **Update all URLs and IDs**
   - Help URLs in ContentView.swift
   - Bundle identifiers everywhere
   - Extension ID in manifest.json

2. **Add proper icons**
   - App icon for main app
   - Extension icons (all sizes)

3. **Write privacy policy**
   - Explain data storage
   - Clarify no data sharing
   - Host on website

4. **Test thoroughly**
   - Multiple Workday sites
   - macOS and iOS
   - Different Safari versions

5. **Prepare App Store submission**
   - Screenshots
   - App description
   - Keywords
   - Support URL

---

## 🔄 Modification Priority Guide

### High Priority (Do Soon)
- ✅ Update bundle identifiers
- ✅ Update background.js application ID
- ✅ Create extension icons
- ✅ Test field selectors on real Workday sites

### Medium Priority (Do Eventually)
- 🔧 Add form validation in ProfileEditorView
- 🔧 Implement work experience autofill
- 🔧 Implement education autofill
- 🔧 Add profile templates

### Low Priority (Nice to Have)
- 💡 Add dark mode support
- 💡 Implement CloudKit sync
- 💡 Add application tracking
- 💡 Support more job sites (Greenhouse, Lever)

---

## ⚠️ Common Mistakes to Avoid

1. **❌ Wrong target membership**
   - Models MUST be in both targets
   - Views should NOT be in Extension target
   - JS files should NOT be in Main App target

2. **❌ Forgetting Copy Bundle Resources**
   - manifest.json MUST be in Copy Bundle Resources
   - All JS, HTML, CSS MUST be in Copy Bundle Resources
   - Icons MUST be in Copy Bundle Resources

3. **❌ Incorrect bundle identifiers**
   - Must match between Info.plist, manifest.json, and background.js
   - Extension bundle ID must be Main App ID + ".Extension"

4. **❌ Not testing on real Workday**
   - Field selectors WILL be different across companies
   - Must test on multiple Workday instances
   - Selectors may change over time

5. **❌ Ignoring Safari Web Inspector**
   - Use it to debug JavaScript
   - Check console for errors
   - Verify messages are sent/received

---

## 🎓 Learning Resources

- **Safari Web Extensions**: https://developer.apple.com/documentation/safariservices/safari_web_extensions
- **WebExtensions API**: https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions
- **Native Messaging**: https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_messaging

---

**You now know exactly what each file does and what to do with it! Start with the "Immediate Setup" tasks and work your way through.** 🚀
