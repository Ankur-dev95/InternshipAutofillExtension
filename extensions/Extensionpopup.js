// Popup script for Workday Autofill Extension

document.addEventListener('DOMContentLoaded', async () => {
    const profileNameElement = document.getElementById('profileName');
    const selectProfileBtn = document.getElementById('selectProfileBtn');
    const autofillBtn = document.getElementById('autofillBtn');
    const openAppBtn = document.getElementById('openAppBtn');
    const statusElement = document.getElementById('status');
    
    // Load active profile on popup open
    await loadActiveProfile();
    
    // Event listeners
    selectProfileBtn.addEventListener('click', handleSelectProfile);
    autofillBtn.addEventListener('click', handleAutofill);
    openAppBtn.addEventListener('click', handleOpenApp);
    
    // Load and display active profile
    async function loadActiveProfile() {
        try {
            const response = await browser.runtime.sendMessage({ 
                action: 'getActiveProfile' 
            });
            
            if (response.success && response.profile) {
                const profile = response.profile;
                profileNameElement.textContent = profile.name;
                autofillBtn.disabled = false;
            } else {
                profileNameElement.textContent = 'No profile selected';
                autofillBtn.disabled = true;
            }
        } catch (error) {
            console.error('Error loading profile:', error);
            showStatus('Failed to load profile', 'error');
        }
    }
    
    // Handle profile selection
    async function handleSelectProfile() {
        // This would typically open the native app or a profile selector
        // For now, we'll just notify the user
        showStatus('Please use the main app to select a profile', 'error');
        
        // Optionally open the native app
        handleOpenApp();
    }
    
    // Handle autofill action
    async function handleAutofill() {
        try {
            showStatus('Autofilling form...', 'success');
            
            // Get the active tab
            const tabs = await browser.tabs.query({ 
                active: true, 
                currentWindow: true 
            });
            
            if (tabs.length === 0) {
                throw new Error('No active tab found');
            }
            
            // Send message to content script
            await browser.tabs.sendMessage(tabs[0].id, { 
                action: 'toggleAutofill' 
            });
            
            showStatus('Form autofilled successfully!', 'success');
            
            // Close popup after 1 second
            setTimeout(() => {
                window.close();
            }, 1000);
            
        } catch (error) {
            console.error('Autofill error:', error);
            showStatus('Failed to autofill: ' + error.message, 'error');
        }
    }
    
    // Handle opening the native app
    function handleOpenApp() {
        // Try to open the native app using a custom URL scheme
        // You'll need to register this in your app's Info.plist
        const appURL = 'internshipautofill://settings';
        
        // Create a hidden link and click it
        const link = document.createElement('a');
        link.href = appURL;
        link.target = '_blank';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        
        showStatus('Opening app...', 'success');
    }
    
    // Show status message
    function showStatus(message, type) {
        statusElement.textContent = message;
        statusElement.className = `status ${type}`;
        
        // Auto-hide after 3 seconds
        setTimeout(() => {
            statusElement.className = 'status hidden';
        }, 3000);
    }
});
