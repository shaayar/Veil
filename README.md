# Veil - Privacy-First Ephemeral Messaging

![Veil Logo](./public/images/veil-logo.png)

**Secure, Anonymous, Ephemeral Messaging for the Modern World**

Veil is a privacy-first ephemeral messaging platform that enables truly anonymous communication without digital footprints. Built with zero-knowledge architecture and user-controlled message lifecycles.

## Table of Contents

- [Features](#features)
- [Technology Stack](#technology-stack)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Development](#development)
- [Security](#security)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

## Features

### Core Platform Features
- **True Anonymity** - No phone number or email required for registration
- **User-Controlled Expiration** - Messages disappear after 10 seconds to 24 hours
- **Screenshot Detection** - Advanced protection against screen recording
- **Zero-Knowledge Architecture** - Server cannot decrypt or access message content
- **Forensic Resistance** - No message logs or persistent storage
- **Signal Protocol** - Military-grade end-to-end encryption

### Website Features
- **Responsive Design** - Mobile-first approach works on all devices
- **Dark/Light Theme** - Privacy-focused dark theme with light mode option
- **Interactive Animations** - Smooth transitions and engaging micro-interactions
- **Security Visualization** - Clear demonstration of privacy architecture
- **Comparison Tools** - Side-by-side feature comparison with competitors
- **Beta Signup** - Email capture for early access notifications

## Technology Stack

### Frontend
- **Framework**: React 18 with TypeScript
- **Styling**: Tailwind CSS (core utilities only)
- **Animations**: Framer Motion
- **Build Tool**: Vite for fast development and optimized builds
- **State Management**: Zustand for lightweight state management

### Backend (Coming Soon)
- **Runtime**: Node.js with TypeScript
- **Framework**: Express.js with Socket.IO for real-time messaging
- **Database**: Redis Cluster (ephemeral storage only)
- **Encryption**: Signal Protocol implementation
- **Infrastructure**: Docker + Kubernetes

### Development Tools
- **Linting**: ESLint with TypeScript rules
- **Formatting**: Prettier with Tailwind plugin
- **Testing**: Jest with React Testing Library
- **Type Checking**: TypeScript strict mode
- **Git Hooks**: Husky for pre-commit validation

## Getting Started

### Prerequisites
- Node.js 18.0 or higher
- npm or yarn package manager
- Git for version control

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/veil-app/veil-website.git
   cd veil-website
   ```

2. **Install dependencies**
   ```bash
   npm install
   # or
   yarn install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env.local
   # Edit .env.local with your configuration
   ```

4. **Start development server**
   ```bash
   npm run dev
   # or
   yarn dev
   ```

5. **Open your browser**
   Navigate to [http://localhost:5173](http://localhost:5173)

### Environment Variables

Create a `.env.local` file in the root directory:

```env
VITE_APP_TITLE=Veil - Privacy-First Messaging
VITE_BETA_SIGNUP_API=https://api.getveil.vercel.app/beta/signup
VITE_ANALYTICS_ID=your-analytics-id
VITE_ENVIRONMENT=development
```

## Project Structure

```
veil-website/
├── public/                     # Static assets
│   ├── images/                # Logo, icons, graphics
│   ├── favicon.ico            # Site favicon
│   └── manifest.json          # PWA manifest
├── src/                       # Source code
│   ├── components/            # React components
│   │   ├── ui/               # Reusable UI components
│   │   ├── sections/         # Page sections (Hero, Features, etc.)
│   │   └── layout/           # Layout components
│   ├── hooks/                # Custom React hooks
│   ├── utils/                # Utility functions
│   ├── types/                # TypeScript type definitions
│   ├── styles/               # Global styles and Tailwind config
│   ├── assets/               # Images, icons, etc.
│   └── App.tsx               # Main application component
├── tests/                    # Test files
├── docs/                     # Documentation
├── .github/                  # GitHub workflows and templates
├── package.json              # Dependencies and scripts
├── tailwind.config.js        # Tailwind CSS configuration
├── vite.config.ts            # Vite configuration
└── README.md                 # This file
```

## Development

### Available Scripts

```bash
# Development
npm run dev          # Start development server
npm run build        # Build for production
npm run preview      # Preview production build locally

# Code Quality
npm run lint         # Run ESLint
npm run lint:fix     # Fix ESLint issues automatically
npm run type-check   # Run TypeScript type checking
npm run format       # Format code with Prettier

# Testing
npm run test         # Run tests
npm run test:watch   # Run tests in watch mode
npm run test:coverage # Generate test coverage report

# Deployment
npm run deploy       # Deploy to production
```

### Development Guidelines

#### Code Style
- Use TypeScript for all new code
- Follow the existing component structure and naming conventions
- Write tests for new components and utilities
- Use Tailwind CSS classes exclusively (no custom CSS unless absolutely necessary)
- Implement responsive design mobile-first

#### Component Guidelines
- Create small, focused components with single responsibilities
- Use proper TypeScript interfaces for props
- Include JSDoc comments for complex components
- Export components with named exports
- Follow the established folder structure

#### Security Considerations
- Never commit sensitive data (API keys, secrets) to version control
- Use environment variables for configuration
- Implement proper input validation and sanitization
- Follow OWASP security guidelines
- Respect user privacy - minimal data collection

## Security

### Privacy by Design
- **No tracking scripts** - We respect user privacy from the first visit
- **Minimal data collection** - Only collect essential information for beta signup
- **Secure forms** - All form submissions use HTTPS and input validation
- **No persistent cookies** - Session-based storage only when necessary

### Content Security Policy
- Strict CSP headers implemented
- XSS protection enabled
- Clickjacking protection via X-Frame-Options
- HTTPS enforcement with HSTS headers

### Vulnerability Reporting
If you discover a security vulnerability, please:
1. **Do NOT** open a public issue
2. Email security@getveil.vercel.app with details
3. Allow 90 days for responsible disclosure
4. We may offer bug bounties for critical findings

## Deployment

### Production Build
```bash
npm run build
npm run preview  # Test production build locally
```

### Environment Setup
- **Staging**: `staging.getveil.vercel.app`
- **Production**: `getveil.vercel.app`

### CI/CD Pipeline
- Automated testing on all pull requests
- Security scanning with CodeQL
- Performance testing with Lighthouse
- Automated deployment to staging on merge to `develop`
- Manual deployment to production from `main` branch

### Performance Targets
- **First Contentful Paint**: < 1.5s
- **Largest Contentful Paint**: < 2.5s
- **Time to Interactive**: < 3.0s
- **Lighthouse Score**: > 90 (all categories)

## Contributing

We welcome contributions to make Veil better! Please read our [Contributing Guidelines](./CONTRIBUTING.md) before submitting pull requests.

### How to Contribute
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Write or update tests
5. Ensure all tests pass
6. Commit your changes (`git commit -m 'Add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

### Code of Conduct
Please read our [Code of Conduct](./CODE_OF_CONDUCT.md) to understand the standards we expect from our community.

## Roadmap

### Phase 1 (Current)
- [x] Landing page design and development
- [x] Beta signup functionality
- [x] Responsive design implementation
- [ ] Security audit of website
- [ ] Performance optimization

### Phase 2 (Q1 2026)
- [ ] Interactive security demo
- [ ] Multi-language support
- [ ] Advanced analytics integration
- [ ] Blog/documentation site

### Phase 3 (Q2 2026)
- [ ] Full messaging platform integration
- [ ] User dashboard
- [ ] Payment processing
- [ ] Enterprise features showcase

## Support

### Getting Help
- **Documentation**: Check our [docs folder](./docs) for detailed guides
- **Issues**: Open a GitHub issue for bugs or feature requests
- **Discussions**: Use GitHub Discussions for questions and ideas
- **Email**: Contact us at support@getveil.vercel.app

### Community
- **Discord**: [Join our community server](https://discord.gg/veil-app)
- **Twitter**: [@VeilApp](https://twitter.com/VeilApp)
- **Reddit**: [r/VeilApp](https://reddit.com/r/VeilApp)

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## Acknowledgments

- **Signal Protocol** - For the cryptographic foundation
- **Privacy Advocates** - For inspiration and guidance
- **Open Source Community** - For the tools that make this possible
- **Beta Testers** - For early feedback and bug reports

---

**Built with privacy in mind. Your conversations, your control.**

For more information about Veil's mission and technology, visit [getveil.vercel.app](https://getveil.vercel.app).

---

## Quick Links
- [Website](https://getveil-app.vercel.app)
- [Documentation](./docs)
- [Security Policy](./SECURITY.md)
- [Privacy Policy](https://getveil.vercel.app/privacy)
- [Terms of Service](https://getveil.vercel.app/terms)