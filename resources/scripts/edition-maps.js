/**
 * Dynamic edition maps for MAJLIS parallel text navigation
 * 
 * Instead of hardcoding every ID, this creates map functions that
 * dynamically transform IDs by replacing the version prefix.
 * 
 * Pattern: arHebr_ch0 → ar_ch0, he_ch0, fr_ch0
 */

(function() {
    'use strict';
    
    // Define the prefix mappings: source prefix → target prefix
    const prefixMappings = {
        'edition_ar': { from: 'arHebr', to: 'ar' },
        'edition_he': { from: 'arHebr', to: 'he' },
        'edition_fr': { from: 'arHebr', to: 'fr' },
        'edition_en': { from: 'arHebr', to: 'en' },
        // Reverse mappings (if navigating from translation to original)
        'edition_arHebr_from_ar': { from: 'ar', to: 'arHebr' },
        'edition_arHebr_from_he': { from: 'he', to: 'arHebr' },
        'edition_arHebr_from_fr': { from: 'fr', to: 'arHebr' }
    };
    
    /**
     * Creates a Proxy-based map that dynamically transforms IDs
     * This allows map['arHebr_0A'] to return 'ar_0A' without
     * pre-defining every possible key
     */
    function createDynamicMap(fromPrefix, toPrefix) {
        return new Proxy({}, {
            get: function(target, prop) {
                if (typeof prop === 'string' && prop.startsWith(fromPrefix + '_')) {
                    return toPrefix + '_' + prop.substring(fromPrefix.length + 1);
                }
                // Also handle the root ID (e.g., 'arHebr' → 'ar')
                if (prop === fromPrefix) {
                    return toPrefix;
                }
                return undefined;
            },
            has: function(target, prop) {
                return typeof prop === 'string' && 
                       (prop.startsWith(fromPrefix + '_') || prop === fromPrefix);
            }
        });
    }
    
    // Register all maps globally
    window.defined_maps = window.defined_maps || {};
    
    for (const [mapName, mapping] of Object.entries(prefixMappings)) {
        window.defined_maps[mapName] = createDynamicMap(mapping.from, mapping.to);
    }
    
    console.log('Edition maps registered:', Object.keys(window.defined_maps));
    
})();