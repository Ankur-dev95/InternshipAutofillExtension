// workday-field-mapper.js
// Advanced Workday field detection and mapping

/**
 * Comprehensive field mapping for Workday application forms
 * This file contains selectors and strategies for finding and filling Workday fields
 */

const WorkdayFieldMapper = {
    
    // Personal Information Field Mappings
    personalInfo: {
        firstName: [
            '[data-automation-id="legalNameSection.legalName.firstName"]',
            'input[name*="firstName"]',
            'input[id*="firstName"]',
            'input[placeholder*="First Name"]'
        ],
        lastName: [
            '[data-automation-id="legalNameSection.legalName.lastName"]',
            'input[name*="lastName"]',
            'input[id*="lastName"]',
            'input[placeholder*="Last Name"]'
        ],
        email: [
            '[data-automation-id="email"]',
            'input[type="email"]',
            'input[name*="email"]',
            'input[id*="email"]'
        ],
        phone: [
            '[data-automation-id="phone"]',
            'input[type="tel"]',
            'input[name*="phone"]',
            'input[id*="phone"]'
        ]
    },
    
    // Address Field Mappings
    address: {
        street: [
            '[data-automation-id="addressSection.address.streetAddress"]',
            'input[name*="street"]',
            'input[name*="address1"]',
            'input[id*="street"]'
        ],
        city: [
            '[data-automation-id="addressSection.address.city"]',
            'input[name*="city"]',
            'input[id*="city"]'
        ],
        state: [
            '[data-automation-id="addressSection.address.state"]',
            'select[name*="state"]',
            'input[name*="state"]',
            'input[id*="state"]'
        ],
        zipCode: [
            '[data-automation-id="addressSection.address.postalCode"]',
            'input[name*="zip"]',
            'input[name*="postal"]',
            'input[id*="zip"]'
        ],
        country: [
            '[data-automation-id="addressSection.address.country"]',
            'select[name*="country"]',
            'input[name*="country"]'
        ]
    },
    
    // Social Links
    socialLinks: {
        linkedIn: [
            '[data-automation-id="linkedInURL"]',
            'input[name*="linkedin"]',
            'input[placeholder*="LinkedIn"]'
        ],
        portfolio: [
            '[data-automation-id="portfolioURL"]',
            'input[name*="portfolio"]',
            'input[name*="website"]',
            'input[placeholder*="Portfolio"]'
        ],
        github: [
            '[data-automation-id="githubURL"]',
            'input[name*="github"]',
            'input[placeholder*="GitHub"]'
        ]
    },
    
    /**
     * Find a field using multiple selector strategies
     * @param {Array<string>} selectors - Array of CSS selectors to try
     * @returns {HTMLElement|null} The found element or null
     */
    findField(selectors) {
        for (const selector of selectors) {
            const element = document.querySelector(selector);
            if (element && this.isVisible(element)) {
                return element;
            }
        }
        return null;
    },
    
    /**
     * Check if an element is visible
     * @param {HTMLElement} element 
     * @returns {boolean}
     */
    isVisible(element) {
        return element.offsetWidth > 0 && 
               element.offsetHeight > 0 && 
               window.getComputedStyle(element).display !== 'none' &&
               window.getComputedStyle(element).visibility !== 'hidden';
    },
    
    /**
     * Set a field value with proper event triggering
     * @param {HTMLElement} field 
     * @param {string} value 
     */
    setFieldValue(field, value) {
        if (!field || !value) return false;
        
        // Handle different input types
        if (field.tagName === 'SELECT') {
            return this.setSelectValue(field, value);
        } else if (field.type === 'checkbox' || field.type === 'radio') {
            return this.setCheckboxValue(field, value);
        } else {
            return this.setTextValue(field, value);
        }
    },
    
    /**
     * Set text input value
     */
    setTextValue(field, value) {
        // Store original value for comparison
        const oldValue = field.value;
        
        // Set the value
        field.value = value;
        
        // Trigger events that Workday listens to
        field.dispatchEvent(new Event('input', { bubbles: true }));
        field.dispatchEvent(new Event('change', { bubbles: true }));
        field.dispatchEvent(new Event('blur', { bubbles: true }));
        
        // Some Workday forms use React, trigger React events
        const nativeInputValueSetter = Object.getOwnPropertyDescriptor(
            window.HTMLInputElement.prototype,
            'value'
        ).set;
        nativeInputValueSetter.call(field, value);
        
        const event = new Event('input', { bubbles: true });
        field.dispatchEvent(event);
        
        return field.value === value;
    },
    
    /**
     * Set select dropdown value
     */
    setSelectValue(select, value) {
        // Try exact match first
        let option = Array.from(select.options).find(opt => 
            opt.value === value || opt.text === value
        );
        
        // Try case-insensitive match
        if (!option) {
            option = Array.from(select.options).find(opt => 
                opt.value.toLowerCase() === value.toLowerCase() ||
                opt.text.toLowerCase() === value.toLowerCase()
            );
        }
        
        // Try partial match
        if (!option) {
            option = Array.from(select.options).find(opt => 
                opt.value.includes(value) || opt.text.includes(value)
            );
        }
        
        if (option) {
            select.value = option.value;
            select.dispatchEvent(new Event('change', { bubbles: true }));
            return true;
        }
        
        return false;
    },
    
    /**
     * Set checkbox/radio value
     */
    setCheckboxValue(field, value) {
        const shouldCheck = value === true || 
                           value === 'true' || 
                           value === '1' || 
                           value === 1;
        
        if (field.checked !== shouldCheck) {
            field.checked = shouldCheck;
            field.dispatchEvent(new Event('change', { bubbles: true }));
        }
        
        return field.checked === shouldCheck;
    },
    
    /**
     * Fill all personal information fields
     */
    fillPersonalInfo(personalInfo) {
        const results = {};
        
        Object.keys(this.personalInfo).forEach(fieldName => {
            const selectors = this.personalInfo[fieldName];
            const field = this.findField(selectors);
            const value = personalInfo[fieldName];
            
            if (field && value) {
                results[fieldName] = this.setFieldValue(field, value);
            }
        });
        
        return results;
    },
    
    /**
     * Fill all address fields
     */
    fillAddress(address) {
        const results = {};
        
        Object.keys(this.address).forEach(fieldName => {
            const selectors = this.address[fieldName];
            const field = this.findField(selectors);
            const value = address[fieldName];
            
            if (field && value) {
                results[fieldName] = this.setFieldValue(field, value);
            }
        });
        
        return results;
    },
    
    /**
     * Fill all social link fields
     */
    fillSocialLinks(personalInfo) {
        const results = {};
        
        const links = {
            linkedIn: personalInfo.linkedInURL,
            portfolio: personalInfo.portfolioURL,
            github: personalInfo.githubURL
        };
        
        Object.keys(this.socialLinks).forEach(fieldName => {
            const selectors = this.socialLinks[fieldName];
            const field = this.findField(selectors);
            const value = links[fieldName];
            
            if (field && value) {
                results[fieldName] = this.setFieldValue(field, value);
            }
        });
        
        return results;
    },
    
    /**
     * Detect current Workday page type
     */
    detectPageType() {
        const url = window.location.href;
        
        if (url.includes('/apply/') || url.includes('/jobs/apply/')) {
            return 'application';
        } else if (url.includes('/jobs/') || url.includes('/job/')) {
            return 'jobDetails';
        } else if (url.includes('/profile/')) {
            return 'profile';
        }
        
        return 'unknown';
    },
    
    /**
     * Get all fillable fields on current page
     */
    getAvailableFields() {
        const fields = {
            personalInfo: {},
            address: {},
            socialLinks: {},
            other: []
        };
        
        // Find personal info fields
        Object.keys(this.personalInfo).forEach(fieldName => {
            const field = this.findField(this.personalInfo[fieldName]);
            if (field) {
                fields.personalInfo[fieldName] = {
                    element: field,
                    currentValue: field.value,
                    type: field.type || field.tagName.toLowerCase()
                };
            }
        });
        
        // Find address fields
        Object.keys(this.address).forEach(fieldName => {
            const field = this.findField(this.address[fieldName]);
            if (field) {
                fields.address[fieldName] = {
                    element: field,
                    currentValue: field.value,
                    type: field.type || field.tagName.toLowerCase()
                };
            }
        });
        
        // Find social link fields
        Object.keys(this.socialLinks).forEach(fieldName => {
            const field = this.findField(this.socialLinks[fieldName]);
            if (field) {
                fields.socialLinks[fieldName] = {
                    element: field,
                    currentValue: field.value,
                    type: field.type || field.tagName.toLowerCase()
                };
            }
        });
        
        return fields;
    }
};

// Export for use in content.js
if (typeof module !== 'undefined' && module.exports) {
    module.exports = WorkdayFieldMapper;
}
