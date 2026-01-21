// Authentication module
const Auth = {
    // Storage key
    storageKey: 'auth_token',
    userKey: 'user_data',

    // Check if user is authenticated
    isAuthenticated: function() {
        return localStorage.getItem(this.storageKey) !== null;
    },

    // Get current user
    getUser: function() {
        const userData = localStorage.getItem(this.userKey);
        return userData ? JSON.parse(userData) : null;
    },

    // Login function
    login: function(email, password) {
        // Demo authentication - in production, this would be an API call
        if (email === 'demo@example.com' && password === 'password123') {
            // Generate a simple token
            const token = btoa(`${email}:${Date.now()}`);
            const user = {
                email: email,
                name: email.split('@')[0],
                loginTime: new Date().toISOString()
            };

            // Store auth data
            localStorage.setItem(this.storageKey, token);
            localStorage.setItem(this.userKey, JSON.stringify(user));

            return { success: true, user: user };
        }

        return { success: false, message: 'Invalid email or password' };
    },

    // Logout function
    logout: function() {
        localStorage.removeItem(this.storageKey);
        localStorage.removeItem(this.userKey);
        window.location.href = '/';
    },

    // Protect page - redirect if not authenticated
    requireAuth: function() {
        if (!this.isAuthenticated()) {
            window.location.href = '/login.html';
        }
    }
};

// Make Auth available globally
window.Auth = Auth;
