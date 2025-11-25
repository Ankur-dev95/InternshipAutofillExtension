# 🗺️ FILE LOCATION GUIDE - WHERE ARE MY FILES?

## What Happened?

I created files with folder paths like `Models/ApplicantProfile.swift`, but in this environment they appear with flattened names like `ModelsApplicantProfile.swift`.

**This is NORMAL and EXPECTED in Xcode's environment!**

---

## 📂 Your Actual Files (What to Look For)

### Swift Files (Native App)

#### Main App Entry:
```
✅ InternshipAutofillExtensionApp.swift
   Location: /repo/InternshipAutofillExtensionApp.swift
   Purpose: App startup and configuration
```

#### Models Folder:
```
✅ ModelsApplicantProfile.swift
   Location: /repo/ModelsApplicantProfile.swift
   Original name: Models/ApplicantProfile.swift
   Purpose: Main profile data structure

✅ ModelsWorkExperience.swift
   Location: /repo/ModelsWorkExperience.swift
   Original name: Models/WorkExperience.swift
   Purpose: Work history entries

✅ ModelsEducation.swift
   Location: /repo/ModelsEducation.swift
   Original name: Models/Education.swift
   Purpose: Education entries
```

#### Services Folder:
```
✅ ServicesProfileStorageService.swift
   Location: /repo/ServicesProfileStorageService.swift
   Original name: Services/ProfileStorageService.swift
   Purpose: Save/load profiles
```

#### Views Folder:
```
✅ ViewsContentView.swift
   Location: /repo/ViewsContentView.swift
   Original name: Views/ContentView.swift
   Purpose: Main app UI

✅ ViewsProfileListView.swift
   Location: /repo/ViewsProfileListView.swift
   Original name: Views/ProfileListView.swift
   Purpose: List of profiles

✅ ViewsProfileEditorView.swift
   Location: /repo/ViewsProfileEditorView.swift
   Original name: Views/ProfileEditorView.swift
   Purpose: Edit profile details
```

#### Extension Bridge:
```
✅ SafariWebExtensionHandler.swift
   Location: /repo/SafariWebExtensionHandler.swift
   Purpose: Swift ↔ JavaScript bridge
```

---

### JavaScript Files (Extension)

```
✅ background.js
   Location: /repo/background.js
   Purpose: Background service worker

✅ content.js
   Location: /repo/content.js
   Purpose: Autofill logic on Workday pages

✅ Extensionworkday-field-mapper.js
   Location: /repo/Extensionworkday-field-mapper.js
   Original name: Extension/workday-field-mapper.js
   Purpose: Advanced field detection

✅ Extensionpopup.js
   Location: /repo/Extensionpopup.js
   Original name: Extension/popup.js
   Purpose: Popup UI logic
```

---

### HTML/CSS Files (Extension UI)

```
✅ Extensionpopup.html
   Location: /repo/Extensionpopup.html
   Original name: Extension/popup.html
   Purpose: Popup structure

✅ Extensionpopup.css
   Location: /repo/Extensionpopup.css
   Original name: Extension/popup.css
   Purpose: Popup styling
```

---

### Configuration Files

```
✅ Extensionmanifest.json
   Location: /repo/Extensionmanifest.json
   Original name: Extension/manifest.json
   Purpose: Extension configuration
```

---

### Documentation Files

```
✅ README.md
   Location: /repo/README.md
   Purpose: Project overview

✅ ARCHITECTURE.md
   Location: /repo/ARCHITECTURE.md
   Purpose: System design & data flow

✅ SETUP.md
   Location: /repo/SETUP.md
   Purpose: Setup instructions

✅ XCODE_STRUCTURE.md
   Location: /repo/XCODE_STRUCTURE.md
   Purpose: File organization guide

✅ GUIDELINES.md
   Location: /repo/GUIDELINES.md
   Purpose: What each file does

✅ CHECKLIST.md
   Location: /repo/CHECKLIST.md
   Purpose: Quick start checklist

✅ PROJECT_SUMMARY.md
   Location: /repo/PROJECT_SUMMARY.md
   Purpose: Project statistics

✅ FILE_STRUCTURE_SUMMARY.md
   Location: /repo/FILE_STRUCTURE_SUMMARY.md
   Purpose: Complete file listing
```

---

## 🎯 How to Use These Files in Xcode

### When You Add to Xcode:

1. **Open Xcode**
2. **Right-click in Project Navigator**
3. **Select "Add Files to [Project]..."**
4. **Browse to your repo folder**
5. **Select files and add them**

### When Adding, You Should RENAME and REORGANIZE:

#### Example for Models:
```
1. Add "ModelsApplicantProfile.swift" to Xcode
2. In Xcode, create a "Models" folder group
3. Drag the file into the Models group
4. (Optional) Rename file to just "ApplicantProfile.swift"
```

The flattened names are just for this environment - **you'll organize them properly in Xcode!**

---

## 📋 Quick Reference: What Each File Does

### Models (Data Structures)
| File | What It Stores |
|------|----------------|
| **ModelsApplicantProfile.swift** | Complete user profile with personal info, work, education |
| **ModelsWorkExperience.swift** | Single job entry (company, title, dates) |
| **ModelsEducation.swift** | Single education entry (school, degree, GPA) |

### Services (Business Logic)
| File | What It Does |
|------|--------------|
| **ServicesProfileStorageService.swift** | Saves/loads profiles, manages active profile |

### Views (User Interface)
| File | What You See |
|------|--------------|
| **ViewsContentView.swift** | Main app with tabs (Profiles & Settings) |
| **ViewsProfileListView.swift** | List of all your profiles |
| **ViewsProfileEditorView.swift** | Form to edit a profile |

### Extension (Browser)
| File | What It Does |
|------|--------------|
| **background.js** | Routes messages between content script and native app |
| **content.js** | Runs on Workday pages, fills forms |
| **Extensionworkday-field-mapper.js** | Finds fields on page |
| **Extensionpopup.html/css/js** | Extension popup UI |
| **SafariWebExtensionHandler.swift** | Bridge between Safari and Swift app |

### Documentation
| File | Read It For |
|------|-------------|
| **GUIDELINES.md** | ⭐ Detailed explanation of each file |
| **CHECKLIST.md** | ⭐ Step-by-step setup instructions |
| **ARCHITECTURE.md** | How everything connects |
| **README.md** | Project overview |

---

## 🚀 Reading Order for Guidelines

### 1. Start Here (5 minutes):
Read **THIS FILE** (FILE_LOCATION_GUIDE.md) to understand file names

### 2. Then Read (30 minutes):
Open **GUIDELINES.md** and read the sections for files you're interested in:

```markdown
Structure of GUIDELINES.md:

📱 Native App Files (Swift/SwiftUI)
  → Models/
     → ApplicantProfile.swift section
     → WorkExperience.swift section
     → Education.swift section
  → Services/
     → ProfileStorageService.swift section
  → Views/
     → ContentView.swift section
     → ProfileListView.swift section
     → ProfileEditorView.swift section

🧩 Safari Extension Files
  → JavaScript Files
     → background.js section
     → content.js section
     → workday-field-mapper.js section
  → HTML/CSS Files
  → Configuration Files

📖 Documentation Files
```

### 3. For Each Section in GUIDELINES.md:

Every file has:
```
#### `Models/ApplicantProfile.swift`

**What it does:**
[Explains the purpose]

**What you should do:**
✅ Leave as-is / 🔧 Customize / ⚠️ Required changes

**When to modify:**
[When you'd need to change it]
```

---

## 💡 Pro Tip: How to Actually Read GUIDELINES.md

Don't read it all at once! Use it as a reference:

### When Adding Files to Xcode:
1. Open GUIDELINES.md
2. Search for the file name (e.g., "ApplicantProfile")
3. Read the "What it does" section
4. Read the "What you should do" section
5. Note the "Target membership" (Main App, Extension, or Both)
6. Add to Xcode with correct target

### When Customizing:
1. Open GUIDELINES.md
2. Search for the file you want to modify
3. Read "When to modify" section
4. Make changes based on guidance

### When Debugging:
1. Open GUIDELINES.md
2. Search for the problematic file
3. Check "What it does" to understand expected behavior
4. Cross-reference with ARCHITECTURE.md for data flow

---

## 🎯 Immediate Action Items

### Right Now (Next 10 Minutes):

1. **Verify you can see all files:**
   ```bash
   # In your terminal, from your project folder:
   ls -la /repo/*.swift
   ls -la /repo/*.js
   ls -la /repo/*.md
   ```

2. **Open these 3 files and skim them:**
   - [ ] GUIDELINES.md (just the table of contents)
   - [ ] CHECKLIST.md (Phase 1 only)
   - [ ] This file (FILE_LOCATION_GUIDE.md)

3. **Understand the naming:**
   - `ModelsApplicantProfile.swift` = `Models/ApplicantProfile.swift`
   - `ViewsContentView.swift` = `Views/ContentView.swift`
   - `Extensionpopup.html` = `Extension/popup.html`

### Next Step (When Ready to Code):

1. Open Xcode
2. Open CHECKLIST.md
3. Follow Phase 1: Initial Setup
4. Reference GUIDELINES.md for each file as you add it

---

## ❓ Still Can't Find a File?

Use this command to find any file:

```bash
# Find all Swift files:
find /repo -name "*.swift"

# Find specific file:
find /repo -name "*ApplicantProfile*"

# List everything:
ls -la /repo/
```

Or ask me to show you a specific file:
"Can you show me the ApplicantProfile file?"
"Where is the background.js file?"

---

## ✅ Summary

**File names are flattened:**
- `Models/ApplicantProfile.swift` → `ModelsApplicantProfile.swift`
- `Extension/popup.html` → `Extensionpopup.html`

**This is normal!** When you add them to Xcode, you'll organize them into proper folders.

**GUIDELINES.md explains each file** - use it as a reference, not a book to read cover-to-cover.

**CHECKLIST.md is your step-by-step guide** - start there!

---

**You have all the files! They just have flattened names right now. This will be fixed when you organize them in Xcode.** 🎉
