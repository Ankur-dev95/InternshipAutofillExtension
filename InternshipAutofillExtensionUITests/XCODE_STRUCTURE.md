# Xcode Project Structure Guide

## Expected Folder Structure in Xcode Navigator

```
InternshipAutofillExtension (Project)
│
├── 📁 InternshipAutofillExtension (Main App Group)
│   │
│   ├── 📁 Models
│   │   ├── 📄 ApplicantProfile.swift
│   │   ├── 📄 WorkExperience.swift
│   │   └── 📄 Education.swift
│   │
│   ├── 📁 Services
│   │   └── 📄 ProfileStorageService.swift
│   │
│   ├── 📁 Views
│   │   ├── 📄 ContentView.swift
│   │   ├── 📄 ProfileListView.swift
│   │   └── 📄 ProfileEditorView.swift
│   │
│   ├── 📄 InternshipAutofillExtensionApp.swift
│   ├── 📁 Assets.xcassets
│   │   ├── AccentColor
│   │   ├── AppIcon
│   │   └── Colors
│   └── 📄 Info.plist
│
├── 📁 Extension (Safari Extension Group)
│   │
│   ├── 📁 Scripts
│   │   ├── 📄 background.js
│   │   ├── 📄 content.js
│   │   └── 📄 workday-field-mapper.js
│   │
│   ├── 📁 UI
│   │   ├── 📄 popup.html
│   │   ├── 📄 popup.css
│   │   └── 📄 popup.js
│   │
│   ├── 📁 Resources
│   │   ├── 📄 manifest.json
│   │   └── 📁 images
│   │       ├── icon-16.png
│   │       ├── icon-32.png
│   │       ├── icon-48.png
│   │       ├── icon-96.png
│   │       └── icon-128.png
│   │
│   ├── 📄 SafariWebExtensionHandler.swift
│   └── 📄 Info.plist
│
├── 📁 InternshipAutofillExtensionTests
│   └── 📄 InternshipAutofillExtensionTests.swift
│
├── 📁 InternshipAutofillExtensionUITests
│   ├── 📄 InternshipAutofillExtensionUITests.swift
│   └── 📄 InternshipAutofillExtensionUITestsLaunchTests.swift
│
├── 📁 Documentation
│   ├── 📄 README.md
│   ├── 📄 ARCHITECTURE.md
│   ├── 📄 SETUP.md
│   └── 📄 FILE_STRUCTURE_SUMMARY.md
│
└── 📁 Products
    ├── InternshipAutofillExtension.app
    └── Extension.appex
```

## Target Membership

### 🎯 Main App Target
**Target Name**: InternshipAutofillExtension

**Files to Include**:
```
✅ InternshipAutofillExtensionApp.swift
✅ Models/ApplicantProfile.swift
✅ Models/WorkExperience.swift
✅ Models/Education.swift
✅ Services/ProfileStorageService.swift
✅ Views/ContentView.swift
✅ Views/ProfileListView.swift
✅ Views/ProfileEditorView.swift
✅ Assets.xcassets
✅ Info.plist
```

### 🧩 Extension Target
**Target Name**: Extension

**Files to Include**:
```
✅ Extension/SafariWebExtensionHandler.swift
✅ Extension/Scripts/background.js
✅ Extension/Scripts/content.js
✅ Extension/Scripts/workday-field-mapper.js
✅ Extension/UI/popup.html
✅ Extension/UI/popup.css
✅ Extension/UI/popup.js
✅ Extension/Resources/manifest.json
✅ Extension/Resources/images/* (all icons)
✅ Extension/Info.plist

⚠️ Also include Models (for shared data types):
✅ Models/ApplicantProfile.swift
✅ Models/WorkExperience.swift
✅ Models/Education.swift
```

### 🧪 Test Targets
**Target Name**: InternshipAutofillExtensionTests
```
✅ InternshipAutofillExtensionTests.swift
```

**Target Name**: InternshipAutofillExtensionUITests
```
✅ InternshipAutofillExtensionUITests.swift
✅ InternshipAutofillExtensionUITestsLaunchTests.swift
```

## How to Add Files in Xcode

### Method 1: Drag and Drop
1. Right-click on Xcode project navigator
2. Select "Add Files to [Project]..."
3. Navigate to your files
4. ⚠️ Important: Check correct target membership
5. Click "Add"

### Method 2: Create New File
1. Right-click on desired folder
2. Select "New File..."
3. Choose template (Swift, HTML, JavaScript, etc.)
4. Name the file
5. ⚠️ Important: Select correct targets
6. Copy content from created files

### Method 3: Create Groups First
1. Right-click in navigator
2. Select "New Group"
3. Name it (Models, Services, Views, etc.)
4. Add files to the group

## Verifying Target Membership

### Check File Target Membership:
1. Select a file in navigator
2. Open File Inspector (⌥⌘1)
3. Look at "Target Membership" section
4. Ensure correct boxes are checked:
   - ✅ Swift files in Models: Both targets
   - ✅ Swift files in Views/Services: Main app only
   - ✅ JavaScript/HTML/CSS: Extension only
   - ✅ SafariWebExtensionHandler: Extension only

### Visual Check:
```
ApplicantProfile.swift Target Membership:
  ✅ InternshipAutofillExtension
  ✅ Extension
  ⬜ InternshipAutofillExtensionTests
  ⬜ InternshipAutofillExtensionUITests

ContentView.swift Target Membership:
  ✅ InternshipAutofillExtension
  ⬜ Extension
  ⬜ InternshipAutofillExtensionTests
  ⬜ InternshipAutofillExtensionUITests

background.js Target Membership:
  ⬜ InternshipAutofillExtension
  ✅ Extension
  ⬜ InternshipAutofillExtensionTests
  ⬜ InternshipAutofillExtensionUITests
```

## Build Settings for Extension Target

### Important Settings:

**Info.plist Settings**:
```xml
<key>NSExtension</key>
<dict>
    <key>NSExtensionPointIdentifier</key>
    <string>com.apple.Safari.web-extension</string>
    <key>NSExtensionPrincipalClass</key>
    <string>$(PRODUCT_MODULE_NAME).SafariWebExtensionHandler</string>
</dict>
```

**Build Settings**:
```
Product Name: Extension
Product Bundle Identifier: com.yourcompany.InternshipAutofillExtension.Extension
Skip Install: NO
```

## Resource Files Configuration

### manifest.json
**Target Membership**: Extension only
**Build Phase**: Copy Bundle Resources

### JavaScript Files
**Target Membership**: Extension only
**Build Phase**: Copy Bundle Resources

### HTML/CSS Files
**Target Membership**: Extension only
**Build Phase**: Copy Bundle Resources

### Images
**Target Membership**: Extension only
**Build Phase**: Copy Bundle Resources

## Common Issues and Solutions

### Issue: Extension not loading
**Solution**: 
- Verify manifest.json is in Extension target
- Check manifest.json is in Copy Bundle Resources
- Ensure bundle identifier matches

### Issue: Swift files causing compile errors in extension
**Solution**:
- Models should be in both targets
- Views should NOT be in extension target
- Services should NOT be in extension target

### Issue: JavaScript not running
**Solution**:
- Verify JS files are in Copy Bundle Resources
- Check manifest.json references correct paths
- Verify content_scripts and background scripts are listed

### Issue: Icons not appearing
**Solution**:
- Place icons in Resources/images/
- Add to Extension target
- Verify manifest.json paths match
- Images must be in Copy Bundle Resources

## Xcode Scheme Configuration

### Edit Scheme Settings:

1. **Product → Scheme → Edit Scheme** (⌘<)

2. **Run Configuration**:
   - Executable: InternshipAutofillExtension.app
   - Debug executable: ✅ Checked

3. **Build Configuration**:
   - InternshipAutofillExtension: ✅ Build
   - Extension: ✅ Build
   - Tests: Optional

## Development Workflow

### 1. Initial Setup
```bash
# Clone or create project
cd InternshipAutofillExtension

# Open in Xcode
open InternshipAutofillExtension.xcodeproj
```

### 2. Add Created Files
- Copy all created .swift files to Models/, Services/, Views/
- Copy all .js, .html, .css to Extension/
- Copy documentation to Documentation/

### 3. Configure Targets
- Set bundle identifiers
- Configure code signing
- Add capabilities (App Sandbox, etc.)

### 4. Build and Run
```
⌘R - Build and Run
⌘B - Build only
⌘. - Stop
⌘⇧K - Clean Build Folder
```

### 5. Test Extension
- Enable in Safari preferences
- Visit Workday site
- Test autofill

## Quick Reference

### File Extension → Target Mapping
```
.swift (Models)       → Both targets
.swift (Views)        → Main app only
.swift (Handler)      → Extension only
.js                   → Extension only
.html/.css            → Extension only
.json (manifest)      → Extension only
.png (icons)          → Extension only
.md (docs)            → No target (documentation)
```

### Xcode Keyboard Shortcuts
```
⌘N - New File
⌘⌥N - New Group
⌘⌥1 - Show File Inspector
⌘⇧Y - Show/Hide Debug Area
⌘⇧O - Open Quickly
⌘B - Build
⌘R - Run
⌘. - Stop
```

## Final Checklist

Before building:
- [ ] All files added to correct targets
- [ ] Bundle identifiers configured
- [ ] Code signing configured
- [ ] manifest.json paths correct
- [ ] Icons created and added
- [ ] Info.plist configured for extension
- [ ] Schemes configured
- [ ] Clean build (⌘⇧K)
- [ ] Test build (⌘B)
- [ ] Run on device/simulator (⌘R)

---

**You're now ready to organize your Xcode project!** 🎉
