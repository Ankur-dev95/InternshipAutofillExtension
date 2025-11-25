// Background script for Workday Autofill Extension

// Listen for messages from content scripts
browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    console.log("Background received request:", request);

    switch (request.action) {
        case "getActiveProfile":
            return handleGetActiveProfile();
        
        case "autofillWorkday":
            return handleAutofillRequest(request.data);
        
        case "saveFormData":
            return handleSaveFormData(request.data);
        
        default:
            console.log("Unknown action:", request.action);
            return Promise.resolve({ success: false, error: "Unknown action" });
    }
});

// Handle getting the active profile from native app
async function handleGetActiveProfile() {
    try {
        const response = await browser.runtime.sendNativeMessage(
            "application.id",
            { action: "getActiveProfile" }
        );
        return response;
    } catch (error) {
        console.error("Error getting active profile:", error);
        return { success: false, error: error.message };
    }
}

// Handle autofill request
async function handleAutofillRequest(data) {
    try {
        const profileResponse = await handleGetActiveProfile();
        
        if (!profileResponse.success) {
            return { success: false, error: "No active profile found" };
        }
        
        return { 
            success: true, 
            profile: profileResponse.profile 
        };
    } catch (error) {
        console.error("Error handling autofill:", error);
        return { success: false, error: error.message };
    }
}

// Handle saving form data back to native app
async function handleSaveFormData(data) {
    try {
        const response = await browser.runtime.sendNativeMessage(
            "application.id",
            { 
                action: "saveProfile",
                profile: data 
            }
        );
        return response;
    } catch (error) {
        console.error("Error saving form data:", error);
        return { success: false, error: error.message };
    }
}

// Handle toolbar icon click
browser.action.onClicked.addListener((tab) => {
    browser.tabs.sendMessage(tab.id, { action: "toggleAutofill" });
});
