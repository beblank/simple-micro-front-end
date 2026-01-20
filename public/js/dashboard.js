// Dashboard specific logic
(function() {
    'use strict';

    // Initialize dashboard
    function init() {
        // Protect dashboard page - must be called after Auth is loaded
        if (typeof Auth !== 'undefined') {
            Auth.requireAuth();
        } else {
            console.error('Auth module not loaded');
            window.location.href = '/login.html';
            return;
        }

        // Update user name
        updateUserInfo();

        // Setup logout button
        setupLogout();
    }

    // Update user information display
    function updateUserInfo() {
        const user = Auth.getUser();
        if (user) {
            const userNameElement = document.getElementById('userName');
            if (userNameElement) {
                userNameElement.textContent = user.name || user.email;
            }
        }
    }

    // Setup logout functionality
    function setupLogout() {
        const logoutBtn = document.getElementById('logoutBtn');
        if (logoutBtn) {
            logoutBtn.addEventListener('click', function(e) {
                e.preventDefault();
                if (confirm('Are you sure you want to logout?')) {
                    Auth.logout();
                }
            });
        }
    }

    // Run on page load
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
