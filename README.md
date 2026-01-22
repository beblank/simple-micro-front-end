# Simple Micro Front-End

A lightweight, fast, and secure micro front-end web application built with vanilla JavaScript. No frameworks, no complex routing - just pure, efficient web development.

## 🚀 Features

- **Lightning Fast**: Each page is under 700KB, ensuring quick load times
- **Secure**: No client-side routing that exposes application structure
- **Responsive**: Works perfectly on all devices
- **Cloud-Native**: Deployed to AWS S3 and CloudFront for global distribution
- **Simple Authentication**: Demo login system with localStorage
- **Infrastructure as Code**: Terraform scripts included

## 📁 Project Structure

```
.
├── public/                 # Website files
│   ├── css/
│   │   └── styles.css     # Responsive CSS styles
│   ├── js/
│   │   ├── app.js         # Main application logic
│   │   ├── auth.js        # Authentication module
│   │   └── dashboard.js   # Dashboard specific logic
│   ├── index.html         # Home page
│   ├── login.html         # Login page
│   └── dashboard.html     # Dashboard page (protected)
├── terraform/             # Infrastructure as Code
│   ├── main.tf            # Main Terraform configuration
│   ├── variables.tf       # Variable definitions
│   ├── outputs.tf         # Output definitions
│   └── s3.tf              # S3 and CloudFront resources
└── .github/workflows/     # CI/CD pipelines
    └── deploy.yml         # Deployment workflow
```

## 🛠️ Local Development

### Prerequisites

- A modern web browser
- Python 3 (for local server) or any other static file server

### Running Locally

1. Clone the repository:
```bash
git clone https://github.com/beblank/simple-micro-front-end.git
cd simple-micro-front-end
```

2. Start a local server:
```bash
cd public
python3 -m http.server 8000
```

3. Open your browser and navigate to:
```
http://localhost:8000
```

### Demo Credentials

- **Email**: demo@example.com
- **Password**: password123

## ☁️ Deployment

See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed deployment instructions.

### Quick Start

1. **Deploy Infrastructure**:
```bash
cd terraform
terraform init
terraform apply
```

2. **Configure GitHub Secrets**:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `S3_BUCKET_NAME`
   - `CLOUDFRONT_DISTRIBUTION_ID`

3. **Deploy**:
```bash
git push origin main
```

## 🔒 Security Features

- **No Client-Side Route Exposure**: Unlike React Router or similar frameworks, this application doesn't expose all routes in the JavaScript bundle
- **Server-Side Navigation**: Each page is a separate HTML file, fetched only when needed
- **Protected Routes**: Dashboard page checks authentication before rendering
- **Secure Headers**: CloudFront can be configured with security headers
- **HTTPS Only**: CloudFront enforces HTTPS connections

## 📊 Performance

- **Home Page**: ~10KB (HTML + CSS + JS)
- **Login Page**: ~11KB (HTML + CSS + JS)
- **Dashboard Page**: ~12KB (HTML + CSS + JS)

All pages load in under 1 second on standard connections.

## 🎨 Customization

### Styling

Edit `public/css/styles.css` to customize the appearance. The CSS uses CSS custom properties (variables) for easy theming.

### Adding Pages

1. Create a new HTML file in the `public/` directory
2. Include the CSS and JS files
3. Add navigation links to existing pages

## 🧪 Testing

### Manual Testing Checklist

- [x] Home page loads correctly
- [x] Navigation works between pages
- [x] Login form validates input
- [x] Login with correct credentials redirects to dashboard
- [x] Login with incorrect credentials shows error
- [x] Dashboard is protected (redirects if not logged in)
- [x] Logout works correctly
- [x] Responsive design works on mobile
- [x] All pages load under 700KB

## 🌍 Browser Support

- Chrome/Edge (latest 2 versions)
- Firefox (latest 2 versions)
- Safari (latest 2 versions)
- Mobile browsers (iOS Safari, Chrome Mobile)

## 📝 License

MIT License - feel free to use this project for your own purposes.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---

Built with ❤️ using vanilla JavaScript