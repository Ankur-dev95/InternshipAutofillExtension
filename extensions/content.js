// Content script for Workday Autofill Extension
// This script runs on Workday pages and handles form detection and autofill

console.log("Workday Autofill Extension loaded");

// Detect if we're on a Workday page
function isWorkdayPage() {
    return window.location.hostname.includes('workday.com') || 
           window.location.hostname.includes('myworkday.com') ||
           document.querySelector('[data-automation-id]') !== null;
}

// Main autofill function
async function autofillWorkdayForm() {
    try {
        console.log("Requesting profile data from background...");
        const response = await browser.runtime.sendMessage({ 
            action: "getActiveProfile" 
        });
        
        if (!response.success) {
            console.error("Failed to get profile:", response.error);
            showNotification("No active profile found. Please set up your profile in the app.", "error");
            return;
        }
        
        const profile = response.profile;
        console.log("Received profile:", profile);
        
        // Fill in the form fields
        fillWorkdayFields(profile);
        
        showNotification("Form autofilled successfully!", "success");
    } catch (error) {
        console.error("Autofill error:", error);
        showNotification("Failed to autofill form: " + error.message, "error");
    }
}

// Fill Workday form fields with profile data
function fillWorkdayFields(profile) {
    const { personalInfo, workExperiences, education, skills } = profile;
    
    // Personal Information
    setFieldValue('input[name*="firstName"]', personalInfo.firstName);
    setFieldValue('input[name*="lastName"]', personalInfo.lastName);
    setFieldValue('input[name*="email"]', personalInfo.email);
    setFieldValue('input[name*="phone"]', personalInfo.phone);
    
    // Address
    setFieldValue('input[name*="address"]', personalInfo.address.street);
    setFieldValue('input[name*="city"]', personalInfo.address.city);
    setFieldValue('input[name*="state"]', personalInfo.address.state);
    setFieldValue('input[name*="zip"]', personalInfo.address.zipCode);
    
    // LinkedIn and URLs
    setFieldValue('input[name*="linkedin"]', personalInfo.linkedInURL);
    setFieldValue('input[name*="portfolio"]', personalInfo.portfolioURL);
    setFieldValue('input[name*="github"]', personalInfo.githubURL);
    
    // Workday-specific automation IDs
    setFieldByAutomationId('legalNameSection.legalName.firstName', personalInfo.firstName);
    setFieldByAutomationId('legalNameSection.legalName.lastName', personalInfo.lastName);
    setFieldByAutomationId('email', personalInfo.email);
    setFieldByAutomationId('phone', personalInfo.phone);
    
    console.log("Form fields filled");
}

// Helper function to set field value by name pattern
function setFieldValue(selector, value) {
    if (!value) return;
    
    const field = document.querySelector(selector);
    if (field) {
        field.value = value;
        field.dispatchEvent(new Event('input', { bubbles: true }));
        field.dispatchEvent(new Event('change', { bubbles: true }));
    }
}

// Helper function to set field by Workday automation ID
function setFieldByAutomationId(automationId, value) {
    if (!value) return;
    
    const field = document.querySelector(`[data-automation-id="${automationId}"]`);
    if (field) {
        field.value = value;
        field.dispatchEvent(new Event('input', { bubbles: true }));
        field.dispatchEvent(new Event('change', { bubbles: true }));
    }
}

// Show notification to user
function showNotification(message, type = "info") {
    const notification = document.createElement('div');
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 15px 20px;
        background-color: ${type === "success" ? "#4CAF50" : type === "error" ? "#f44336" : "#2196F3"};
        color: white;
        border-radius: 4px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        z-index: 10000;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        font-size: 14px;
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.remove();
    }, 3000);
}

// Listen for messages from background script
browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    console.log("Content script received request:", request);
    
    if (request.action === "toggleAutofill") {
        if (isWorkdayPage()) {
            autofillWorkdayForm();
        } else {
            showNotification("This doesn't appear to be a Workday page", "error");
        }
    }
    
    return true;
});

// Add keyboard shortcut listener (Cmd+Shift+A or Ctrl+Shift+A)
document.addEventListener('keydown', (event) => {
    if ((event.metaKey || event.ctrlKey) && event.shiftKey && event.key === 'A') {
        event.preventDefault();
        if (isWorkdayPage()) {
            autofillWorkdayForm();
        }
    }
});

// Initialize
if (isWorkdayPage()) {
    console.log("Workday page detected");
}
