# Quick Setup Guide

## Prerequisites
- Xcode 14.0 or later
- macOS 12.0+ or iOS 15.0+
- Safari 15.0+

## Step 1: Project Organization

Ensure your Xcode project has the following targets:
1. **Main App Target**: The iOS/macOS app
2. **Safari Extension Target**: The browser extension
3. **UI Tests Target**: UI tests (already exists)
4. **Unit Tests Target**: Unit tests

## Step 2: Add Files to Correct Targets

### Main App Target
Add these files to your main app target:
- ✅ Models/ApplicantProfile.swift
- ✅ Models/WorkExperience.swift
- ✅ Models/Education.swift
- ✅ Services/ProfileStorageService.swift
- ✅ Views/ContentView.swift
- ✅ Views/ProfileListView.swift
- ✅ Views/ProfileEditorView.swift

### Safari Extension Target
Add these files to your extension target:
- ✅ Extension/manifest.json
- ✅ Extension/background.js
- ✅ Extension/content.js
- ✅ Extension/workday-field-mapper.js
- ✅ Extension/popup.html
- ✅ Extension/popup.css
- ✅ Extension/popup.js
- ✅ SafariWebExtensionHandler.swift
- ✅ Models/* (also add models to extension for shared types)

## Step 3: Configure Bundle Identifiers

Update your Info.plist files with proper bundle identifiers:

### Main App
```xml
<key>CFBundleIdentifier</key>
<string>com.yourcompany.InternshipAutofillExtension</string>
```

### Safari Extension
```xml
<key>CFBundleIdentifier</key>
<string>com.yourcompany.InternshipAutofillExtension.Extension</string>
<key>NSExtension</key>
<dict>
    <key>NSExtensionPointIdentifier</key>
    <string>com.apple.Safari.web-extension</string>
    <key>NSExtensionPrincipalClass</key>
    <string>SafariWebExtensionHandler</string>
</dict>
```

## Step 4: Configure URL Scheme (Optional)

Add to main app's Info.plist for deep linking:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.yourcompany.internshipautofill</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>internshipautofill</string>
        </array>
    </dict>
</array>
```

## Step 5: Update manifest.json

Edit `Extension/manifest.json` and update:

```json
{
    "name": "Workday Job Autofill",
    "version": "1.0",
    "description": "Your description here",
    "browser_specific_settings": {
        "gecko": {
            "id": "your-extension-id@yourcompany.com"
        }
    }
}
```

## Step 6: Add App Icons

Create and add icons to `Extension/images/`:
- icon-16.png (16x16)
- icon-32.png (32x32)
- icon-48.png (48x48)
- icon-96.png (96x96)
- icon-128.png (128x128)

You can use SF Symbols or design custom icons.

## Step 7: Configure Code Signing

1. Select your project in Xcode
2. Select each target
3. Go to "Signing & Capabilities"
4. Enable "Automatically manage signing"
5. Select your team

### Required Capabilities for Extension Target:
- App Sandbox
- Network (Outgoing Connections - Client)

## Step 8: Update Native Messaging ID

In `background.js`, update the application ID:

```javascript
const response = await browser.runtime.sendNativeMessage(
    "com.yourcompany.InternshipAutofillExtension.Extension",  // Update this
    message
);
```

## Step 9: Build and Run

1. Select your main app target
2. Choose a destination (Mac or iOS Simulator)
3. Click Run (⌘R)
4. The app should launch

## Step 10: Enable Extension in Safari

### macOS:
1. Open Safari
2. Safari → Settings → Extensions
3. Enable "Workday Job Autofill"
4. Click "Always Allow on Every Website" or configure specific sites

### iOS (Safari 15+):
1. Settings app → Safari → Extensions
2. Enable "Workday Job Autofill"
3. Grant necessary permissions

## Step 11: Test the Extension

1. Create a test profile in the app:
   - Open the app
   - Tap "+" to create a new profile
   - Fill in your information
   - Set it as active

2. Visit a Workday job site:
   - Go to any company's Workday careers page
   - Find a job application
   - Click the extension icon or press ⌘⇧A
   - Form should autofill!

## Troubleshooting

### Extension not appearing in Safari
- Ensure the extension target is built
- Check that manifest.json is included in bundle
- Verify bundle identifier is correct
- Try quitting and reopening Safari

### Native messaging not working
- Check that SafariWebExtensionHandler is set as principal class
- Verify application ID matches in background.js
- Check console logs in both app and extension

### Fields not filling
- Open Safari Web Inspector (Develop menu)
- Check console for errors
- Verify field selectors match Workday's current structure
- Some Workday sites may use different field IDs

### App crashes or won't build
- Check that all files are added to correct targets
- Verify no duplicate file references
- Clean build folder (⌘⇧K)
- Delete derived data

## Development Tips

### Debugging Extension JavaScript
1. Enable Develop menu: Safari → Settings → Advanced → Show Develop menu
2. Develop → Show Extension Builder
3. Select your extension
4. Click Inspect to open Web Inspector

### Debugging Native App
- Use Xcode's debugger as normal
- Add breakpoints in SafariWebExtensionHandler
- Use `print()` or `os_log` for logging

### Hot Reload Changes
- JavaScript changes: Reload extension in Extension Builder
- Swift changes: Rebuild and relaunch app
- manifest.json changes: Disable and re-enable extension

## Next Steps

1. ✅ Test on various Workday sites
2. ✅ Add more field mappings as needed
3. ✅ Implement work experience and education filling
4. ✅ Add resume upload handling (future)
5. ✅ Implement CloudKit sync (future)
6. ✅ Add analytics and crash reporting (optional)
7. ✅ Submit to App Store

## Common Workday Sites to Test

- Amazon Jobs
- Apple Jobs  
- Google Careers
- Microsoft Careers
- Any company using Workday (check URL for "myworkday.com")

## Resources

- [Safari Web Extensions Documentation](https://developer.apple.com/documentation/safariservices/safari_web_extensions)
- [WebExtensions API](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions)
- [Workday Developer Resources](https://community.workday.com/)

## Support

If you encounter issues:
1. Check the console logs (both Safari and Xcode)
2. Review the ARCHITECTURE.md file
3. Check field selectors are up-to-date
4. Test with a fresh profile

---

**Happy Coding! 🚀**
