// Main application logic
(function() {
    'use strict';

    // Initialize app
    function init() {
        // Update nav links based on auth status
        updateNavigation();

        // Add smooth scroll behavior
        initSmoothScroll();
    }

    // Update navigation based on authentication
    function updateNavigation() {
        const currentPath = window.location.pathname;
        
        // Update active link
        const navLinks = document.querySelectorAll('.nav-link');
        navLinks.forEach(link => {
            const href = link.getAttribute('href');
            if (href === currentPath || (href === '/' && currentPath === '/index.html')) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
        });
    }

    // Smooth scroll for anchor links
    function initSmoothScroll() {
        const links = document.querySelectorAll('a[href^="#"]');
        links.forEach(link => {
            link.addEventListener('click', function(e) {
                const href = this.getAttribute('href');
                if (href === '#') return;

                e.preventDefault();
                const target = document.querySelector(href);
                if (target) {
                    target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }
            });
        });
    }

    // Run on page load
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();

// Login page specific logic
if (window.location.pathname.includes('login')) {
    document.addEventListener('DOMContentLoaded', function() {
        // Redirect if already authenticated
        if (Auth.isAuthenticated()) {
            window.location.href = '/dashboard.html';
            return;
        }

        const loginForm = document.getElementById('loginForm');
        const errorMessage = document.getElementById('error-message');

        if (loginForm) {
            loginForm.addEventListener('submit', function(e) {
                e.preventDefault();

                const email = document.getElementById('email').value;
                const password = document.getElementById('password').value;

                // Attempt login
                const result = Auth.login(email, password);

                if (result.success) {
                    // Redirect to dashboard on success
                    window.location.href = '/dashboard.html';
                } else {
                    // Show error message
                    errorMessage.textContent = result.message;
                    errorMessage.style.display = 'block';
                }
            });
        }
    });
}
