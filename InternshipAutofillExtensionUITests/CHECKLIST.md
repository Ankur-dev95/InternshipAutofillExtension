# 🚀 Quick Start Checklist

Use this checklist to get your Workday autofill extension up and running!

## Phase 1: Initial Setup ⚙️

### Step 1: Organize Files in Xcode
- [ ] Create folder groups in Xcode Navigator:
  - [ ] Models/
  - [ ] Services/
  - [ ] Views/
  - [ ] Extension/
  - [ ] Documentation/

### Step 2: Add Swift Files
- [ ] Add to **Main App Target**:
  - [ ] InternshipAutofillExtensionApp.swift
  - [ ] Views/ContentView.swift
  - [ ] Views/ProfileListView.swift
  - [ ] Views/ProfileEditorView.swift
  - [ ] Services/ProfileStorageService.swift

- [ ] Add to **BOTH Main App AND Extension Targets**:
  - [ ] Models/ApplicantProfile.swift
  - [ ] Models/WorkExperience.swift
  - [ ] Models/Education.swift

- [ ] Add to **Extension Target ONLY**:
  - [ ] SafariWebExtensionHandler.swift

### Step 3: Add Extension Files
- [ ] Add to **Extension Target** (all must be in Copy Bundle Resources):
  - [ ] Extension/manifest.json
  - [ ] Extension/background.js
  - [ ] Extension/content.js
  - [ ] Extension/workday-field-mapper.js
  - [ ] Extension/popup.html
  - [ ] Extension/popup.css
  - [ ] Extension/popup.js

### Step 4: Verify Target Membership
- [ ] Select each file in Xcode
- [ ] Open File Inspector (⌥⌘1)
- [ ] Check "Target Membership" matches the lists above

### Step 5: Verify Copy Bundle Resources
- [ ] Select Extension target
- [ ] Go to Build Phases
- [ ] Expand "Copy Bundle Resources"
- [ ] Verify these are listed:
  - [ ] manifest.json
  - [ ] background.js
  - [ ] content.js
  - [ ] workday-field-mapper.js
  - [ ] popup.html
  - [ ] popup.css
  - [ ] popup.js

---

## Phase 2: Configuration 🔧

### Step 6: Configure Bundle Identifiers

#### Main App Info.plist:
- [ ] Set CFBundleIdentifier: `com.yourcompany.InternshipAutofillExtension`
- [ ] Update display name if desired

#### Extension Info.plist:
- [ ] Set CFBundleIdentifier: `com.yourcompany.InternshipAutofillExtension.Extension`
- [ ] Verify NSExtension settings:
  ```xml
  <key>NSExtensionPointIdentifier</key>
  <string>com.apple.Safari.web-extension</string>
  <key>NSExtensionPrincipalClass</key>
  <string>$(PRODUCT_MODULE_NAME).SafariWebExtensionHandler</string>
  ```

### Step 7: Update JavaScript Bundle ID
- [ ] Open `Extension/background.js`
- [ ] Find all instances of `"application.id"`
- [ ] Replace with: `"com.yourcompany.InternshipAutofillExtension.Extension"`
- [ ] Example:
  ```javascript
  // Change this:
  await browser.runtime.sendNativeMessage("application.id", ...)
  
  // To this:
  await browser.runtime.sendNativeMessage(
      "com.yourcompany.InternshipAutofillExtension.Extension",
      ...
  )
  ```

### Step 8: Update manifest.json
- [ ] Open `Extension/manifest.json`
- [ ] Update name: `"Workday Job Autofill"` (or your name)
- [ ] Update description
- [ ] Update extension ID:
  ```json
  "browser_specific_settings": {
      "gecko": {
          "id": "workday-autofill@yourcompany.com"
      }
  }
  ```

### Step 9: Configure Code Signing
- [ ] Select project in Xcode
- [ ] Select Main App target
- [ ] Go to Signing & Capabilities
- [ ] Enable "Automatically manage signing"
- [ ] Select your Team

- [ ] Select Extension target
- [ ] Go to Signing & Capabilities
- [ ] Enable "Automatically manage signing"
- [ ] Select your Team
- [ ] Verify "App Sandbox" is enabled

---

## Phase 3: Icons & Assets 🎨

### Step 10: Create Extension Icons
- [ ] Create icons in these sizes:
  - [ ] 16x16 pixels → icon-16.png
  - [ ] 32x32 pixels → icon-32.png
  - [ ] 48x48 pixels → icon-48.png
  - [ ] 96x96 pixels → icon-96.png
  - [ ] 128x128 pixels → icon-128.png

- [ ] Place icons in: `Extension/Resources/images/` (or `Extension/images/`)
- [ ] Add to Extension target
- [ ] Verify in Copy Bundle Resources

**Quick Icon Creation:**
- Use SF Symbols app (free from Apple)
- Export symbol at different sizes
- Or use icon generator tools online

### Step 11: App Icons
- [ ] Open Assets.xcassets in Main App
- [ ] Add app icon in all required sizes
- [ ] Test icon appears correctly

---

## Phase 4: Build & Test 🏗️

### Step 12: First Build
- [ ] Clean build folder: **⌘⇧K**
- [ ] Build: **⌘B**
- [ ] Check for errors:
  - [ ] No Swift compiler errors
  - [ ] No missing file errors
  - [ ] No target membership issues

### Step 13: Run the App
- [ ] Select Main App scheme
- [ ] Choose destination (Mac or iOS Simulator)
- [ ] Run: **⌘R**
- [ ] App should launch successfully

### Step 14: Test Profile Creation
- [ ] In the app, click "+" to create profile
- [ ] Enter test information:
  - [ ] Profile name: "Test Profile"
  - [ ] First name, last name
  - [ ] Email, phone
  - [ ] At least one address field
- [ ] Save the profile
- [ ] Set as active profile

### Step 15: Enable Extension in Safari

#### macOS:
- [ ] Open Safari
- [ ] Safari → Settings (⌘,)
- [ ] Go to Extensions tab
- [ ] Find "Workday Job Autofill" (or your name)
- [ ] Check the box to enable
- [ ] Click "Always Allow on Every Website" OR
- [ ] Configure specific websites

#### iOS Simulator:
- [ ] Open Settings app
- [ ] Scroll to Safari
- [ ] Tap Extensions
- [ ] Enable your extension
- [ ] Grant permissions

### Step 16: Test Extension Loading
- [ ] In Safari, look for extension icon in toolbar
- [ ] Click the icon
- [ ] Popup should show:
  - [ ] Your active profile name
  - [ ] "Autofill Current Page" button
  - [ ] No errors in popup

---

## Phase 5: Functional Testing 🧪

### Step 17: Test on Sample Workday Page
- [ ] Find a Workday job application:
  - Amazon Jobs: https://www.amazon.jobs
  - Apple Jobs: https://www.apple.com/careers
  - Or search "workday careers" + company name

- [ ] Navigate to an application form
- [ ] Click extension icon or press **⌘⇧A**
- [ ] Check console (Safari → Develop → Show Web Inspector):
  - [ ] No JavaScript errors
  - [ ] See "Workday Autofill Extension loaded" message
  - [ ] See profile data logged

### Step 18: Verify Native Messaging
- [ ] Open Xcode Console while extension is active
- [ ] Trigger autofill
- [ ] Check for log messages:
  - [ ] "Received message from browser.runtime.sendNativeMessage"
  - [ ] Profile data being sent
  - [ ] No errors in Swift code

### Step 19: Test Field Filling
- [ ] After triggering autofill, check:
  - [ ] First name field filled
  - [ ] Last name field filled
  - [ ] Email field filled
  - [ ] Phone field filled
  - [ ] Address fields filled (if present)
  - [ ] Success notification appears

---

## Phase 6: Debugging & Refinement 🔍

### Step 20: Debug JavaScript Issues
- [ ] Open Safari Web Inspector (⌘⌥I)
- [ ] Go to Console tab
- [ ] Look for errors or warnings
- [ ] Check Network tab for failed requests
- [ ] Use debugger statements if needed

### Step 21: Debug Swift Issues
- [ ] Set breakpoints in SafariWebExtensionHandler.swift
- [ ] Trigger autofill
- [ ] Step through code with Xcode debugger
- [ ] Check variable values
- [ ] Verify profile data structure

### Step 22: Update Field Selectors
If fields aren't filling:
- [ ] Open Web Inspector on Workday page
- [ ] Find field in Elements tab
- [ ] Note the actual attributes:
  - `data-automation-id`
  - `name` attribute
  - `id` attribute
  - `class` names
- [ ] Update selectors in `content.js` or `workday-field-mapper.js`
- [ ] Rebuild extension
- [ ] Test again

### Step 23: Test on Multiple Sites
- [ ] Test on at least 3 different company Workday sites
- [ ] Document which fields work/don't work
- [ ] Update selectors as needed
- [ ] Consider adding site-specific logic

---

## Phase 7: Polish & Prepare for Use 💎

### Step 24: Error Handling
- [ ] Test with no active profile:
  - [ ] Should show "No profile selected" error
  - [ ] Should not crash
  
- [ ] Test with app closed:
  - [ ] Extension should show helpful error
  - [ ] Should prompt to open app

- [ ] Test with empty fields:
  - [ ] Should handle gracefully
  - [ ] Should not fill with "undefined"

### Step 25: User Experience
- [ ] Test keyboard shortcut (⌘⇧A)
- [ ] Verify notification messages are clear
- [ ] Test "Open App Settings" button in popup
- [ ] Ensure UI looks good in both light/dark mode

### Step 26: Performance
- [ ] Test on slow internet connection
- [ ] Verify extension doesn't slow down page load
- [ ] Check memory usage in Activity Monitor
- [ ] Ensure no memory leaks

---

## Phase 8: Documentation & Sharing 📚

### Step 27: Update Documentation
- [ ] Update README.md with:
  - [ ] Actual screenshots
  - [ ] Your GitHub/website links
  - [ ] Installation instructions
  
- [ ] Update SETUP.md with:
  - [ ] Any issues you encountered
  - [ ] Solutions you found
  - [ ] Platform-specific notes

### Step 28: Create User Guide
- [ ] Write simple instructions for users:
  1. How to install
  2. How to create a profile
  3. How to use autofill
  4. How to update information
  
- [ ] Add screenshots or video
- [ ] Host on GitHub wiki or website

### Step 29: Prepare for Distribution
If distributing publicly:
- [ ] Write privacy policy
- [ ] Add license file (MIT, Apache, etc.)
- [ ] Create contribution guidelines
- [ ] Set up issue templates on GitHub
- [ ] Prepare App Store listing (if publishing)

---

## Verification Checklist ✅

### Before Calling It "Done":
- [ ] ✅ App builds without errors
- [ ] ✅ Extension shows in Safari preferences
- [ ] ✅ Can create and edit profiles
- [ ] ✅ Can set active profile
- [ ] ✅ Extension icon shows in Safari toolbar
- [ ] ✅ Popup displays profile information
- [ ] ✅ Autofill works on at least one Workday site
- [ ] ✅ Native messaging works (Swift ↔ JavaScript)
- [ ] ✅ Keyboard shortcut works
- [ ] ✅ Error messages are helpful
- [ ] ✅ No console errors in normal use
- [ ] ✅ Tested on multiple Workday sites
- [ ] ✅ Documentation is complete
- [ ] ✅ Ready to show to others!

---

## Troubleshooting Common Issues 🔧

### Issue: "Extension not showing in Safari"
**Solutions:**
- [ ] Verify Extension target builds successfully
- [ ] Check manifest.json is in Copy Bundle Resources
- [ ] Quit and reopen Safari
- [ ] Check Extension target is embedded in app
- [ ] Try: Safari → Develop → Allow Unsigned Extensions

### Issue: "Autofill does nothing"
**Solutions:**
- [ ] Check console for JavaScript errors
- [ ] Verify native messaging app ID matches
- [ ] Ensure profile is set as active
- [ ] Check field selectors match Workday's HTML
- [ ] Verify content.js is loaded (check console log)

### Issue: "Native messaging failed"
**Solutions:**
- [ ] Ensure app is running
- [ ] Verify bundle ID in background.js matches Extension
- [ ] Check Info.plist has correct NSExtension settings
- [ ] Check Xcode console for Swift errors
- [ ] Try rebuilding both targets

### Issue: "Fields not filling"
**Solutions:**
- [ ] Open Web Inspector, check actual field attributes
- [ ] Update selectors in content.js
- [ ] Check if Workday page uses React (may need different approach)
- [ ] Try workday-field-mapper.js methods
- [ ] Add delays if fields load dynamically

### Issue: "Build errors"
**Solutions:**
- [ ] Clean build folder (⌘⇧K)
- [ ] Check target membership of all files
- [ ] Ensure Models are in both targets
- [ ] Verify import statements
- [ ] Delete Derived Data folder

---

## Next Steps After Completion 🚀

### Immediate Next Steps:
1. Test on your own real job applications
2. Gather feedback from friends
3. Document any issues or missing fields
4. Iterate on field detection

### Short-term Goals:
1. Add work experience autofill
2. Add education autofill
3. Support more complex Workday forms
4. Add profile import from LinkedIn (API)

### Long-term Goals:
1. Implement CloudKit sync
2. Add application tracking
3. Support other job sites (Greenhouse, Lever)
4. Build analytics dashboard
5. Publish to App Store

---

## Resources 📖

- **GUIDELINES.md** - Detailed explanation of every file
- **SETUP.md** - Complete setup instructions
- **ARCHITECTURE.md** - How everything works together
- **XCODE_STRUCTURE.md** - Organizing files in Xcode

---

**Print this checklist and check off items as you go! You've got this! 🎉**
