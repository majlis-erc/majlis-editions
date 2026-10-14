/**
 * MAJLIS Custom TOC Enhancement
 * Provides expand/collapse functionality and active section highlighting
 * for the custom table of contents
 */

(function() {
    'use strict';
    
    /**
     * Initialize TOC functionality when DOM is ready
     */
    function initTOC() {
        console.log('[MAJLIS TOC] Initializing...');
        
        // Setup expand/collapse for chapters
        setupExpandCollapse();
        
        // Setup active section highlighting
        setupActiveHighlighting();
        
        // Expand first chapter by default
        expandFirstChapter();
        
        console.log('[MAJLIS TOC] Initialized successfully');
    }
    
    /**
     * Setup expand/collapse functionality for chapter headings
     */
    function setupExpandCollapse() {
        const chapters = document.querySelectorAll('.toc-chapter');
        
        chapters.forEach(chapter => {
            const icon = chapter.querySelector('.toc-expand-icon');
            const title = chapter.querySelector('.toc-chapter-title');
            const sections = chapter.querySelector('.toc-sections');
            
            // Only setup if chapter has sections
            if (!sections) return;
            
            // Click handler for both icon and title
            const toggleExpand = (e) => {
                e.stopPropagation();
                chapter.classList.toggle('expanded');
                
                // Announce state change for screen readers
                const isExpanded = chapter.classList.contains('expanded');
                if (icon) {
                    icon.setAttribute('aria-expanded', isExpanded);
                }
            };
            
            if (icon) {
                icon.addEventListener('click', toggleExpand);
                icon.setAttribute('role', 'button');
                icon.setAttribute('aria-label', 'Toggle chapter');
                icon.setAttribute('tabindex', '0');
                
                // Keyboard support
                icon.addEventListener('keydown', (e) => {
                    if (e.key === 'Enter' || e.key === ' ') {
                        e.preventDefault();
                        toggleExpand(e);
                    }
                });
            }
            
            if (title) {
                title.addEventListener('click', toggleExpand);
                title.setAttribute('tabindex', '0');
                
                // Keyboard support
                title.addEventListener('keydown', (e) => {
                    if (e.key === 'Enter' || e.key === ' ') {
                        e.preventDefault();
                        toggleExpand(e);
                    }
                });
            }
        });
        
        console.log(`[MAJLIS TOC] Setup expand/collapse for ${chapters.length} chapters`);
    }
    
    /**
     * Setup active section highlighting based on navigation
     */
    function setupActiveHighlighting() {
        const links = document.querySelectorAll('.toc-section pb-link');
        
        links.forEach(link => {
            link.addEventListener('click', function() {
                // Remove active class from all links
                document.querySelectorAll('.toc-section pb-link').forEach(l => {
                    l.classList.remove('active');
                });
                
                // Add active class to clicked link
                this.classList.add('active');
                
                // Ensure parent chapter is expanded
                const chapter = this.closest('.toc-chapter');
                if (chapter && !chapter.classList.contains('expanded')) {
                    chapter.classList.add('expanded');
                }
            });
        });
        
        console.log(`[MAJLIS TOC] Setup highlighting for ${links.length} section links`);
    }
    
    /**
     * Expand the first chapter by default
     */
    function expandFirstChapter() {
        const firstChapter = document.querySelector('.toc-chapter');
        if (firstChapter) {
            firstChapter.classList.add('expanded');
            console.log('[MAJLIS TOC] Expanded first chapter');
        }
    }
    
    /**
     * Highlight active section based on visible content (optional enhancement)
     */
    function highlightVisibleSection() {
        // Get all pb-view components
        const views = document.querySelectorAll('pb-view[subscribe="transcription"]');
        if (views.length === 0) return;
        
        // Use the first view to determine current section
        const firstView = views[0];
        
        // Listen for scroll or update events
        firstView.addEventListener('pb-update', function(e) {
            // Try to find the current milestone in the view
            const shadowRoot = firstView.shadowRoot;
            if (!shadowRoot) return;
            
            // Get all milestones in view
            const milestones = shadowRoot.querySelectorAll('[data-tei-n]');
            if (milestones.length === 0) return;
            
            // Find the first visible milestone
            let currentMilestone = null;
            for (const milestone of milestones) {
                const rect = milestone.getBoundingClientRect();
                if (rect.top >= 0 && rect.top <= window.innerHeight * 0.3) {
                    currentMilestone = milestone.getAttribute('data-tei-n');
                    break;
                }
            }
            
            if (!currentMilestone) return;
            
            // Find and highlight corresponding TOC entry
            const tocLink = document.querySelector(`.toc-section pb-link[data-milestone="${currentMilestone}"]`);
            if (tocLink) {
                // Remove active from all
                document.querySelectorAll('.toc-section pb-link').forEach(l => {
                    l.classList.remove('active');
                });
                
                // Add active to current
                tocLink.classList.add('active');
                
                // Scroll TOC to show active entry
                tocLink.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            }
        });
    }
    
    /**
     * Add keyboard navigation for TOC
     */
    function setupKeyboardNavigation() {
        const toc = document.querySelector('.toc');
        if (!toc) return;
        
        toc.addEventListener('keydown', function(e) {
            const current = document.activeElement;
            
            // Get all focusable elements in TOC
            const focusable = Array.from(toc.querySelectorAll(
                '.toc-expand-icon, .toc-chapter-title, .toc-section pb-link'
            ));
            
            const currentIndex = focusable.indexOf(current);
            if (currentIndex === -1) return;
            
            let next = null;
            
            switch(e.key) {
                case 'ArrowDown':
                    e.preventDefault();
                    next = focusable[currentIndex + 1];
                    break;
                case 'ArrowUp':
                    e.preventDefault();
                    next = focusable[currentIndex - 1];
                    break;
                case 'Home':
                    e.preventDefault();
                    next = focusable[0];
                    break;
                case 'End':
                    e.preventDefault();
                    next = focusable[focusable.length - 1];
                    break;
            }
            
            if (next) {
                next.focus();
            }
        });
        
        console.log('[MAJLIS TOC] Setup keyboard navigation');
    }
    
    /**
     * Wait for TOC to be loaded before initializing
     */
    function waitForTOC() {
        const observer = new MutationObserver((mutations, obs) => {
            const toc = document.querySelector('.toc');
            if (toc) {
                obs.disconnect();
                // Small delay to ensure everything is rendered
                setTimeout(initTOC, 100);
            }
        });
        
        observer.observe(document.body, {
            childList: true,
            subtree: true
        });
        
        // Timeout after 10 seconds
        setTimeout(() => {
            observer.disconnect();
            if (!document.querySelector('.toc')) {
                console.warn('[MAJLIS TOC] TOC not found after 10 seconds');
            }
        }, 10000);
    }
    
    /**
     * Initialize when DOM is ready
     */
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', waitForTOC);
    } else {
        waitForTOC();
    }
    
    // Optional: Setup keyboard navigation (uncomment to enable)
    // document.addEventListener('DOMContentLoaded', setupKeyboardNavigation);
    
    // Optional: Setup visible section highlighting (uncomment to enable)
    // document.addEventListener('DOMContentLoaded', highlightVisibleSection);
    
})();
