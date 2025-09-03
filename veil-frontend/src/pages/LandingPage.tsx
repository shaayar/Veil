import { useEffect, useState, useMemo } from "react";
import { Link } from "react-router-dom";
import { motion } from "framer-motion";

// Static data moved outside component to prevent recreation on every render
const FEATURES = [
  {
    title: "🔒 End-to-End Encryption",
    desc: "All messages are secured using Signal Protocol, ensuring your data stays private.",
  },
  {
    title: "⏳ Self-Destructing Chats", 
    desc: "Messages vanish after reading — leaving zero digital footprint.",
  },
  {
    title: "🌎 PWA & Cross-Platform",
    desc: "Install Veil on any device and enjoy a seamless, native-like experience.",
  },
];

export default function LandingPage() {
  const [isWidgetLoaded, setIsWidgetLoaded] = useState(false);
  const [widgetError, setWidgetError] = useState(false);
  const [widgetInitialized, setWidgetInitialized] = useState(false);

  useEffect(() => {
    // Prevent multiple initializations
    if (widgetInitialized) return;

    // Check if script already exists to prevent duplicates
    const existingScript = document.querySelector('script[src="https://getlaunchlist.com/js/widget.js"]');
    
    if (existingScript) {
      setIsWidgetLoaded(true);
      setWidgetInitialized(true);
      return;
    }

    // Load LaunchList waitlist widget with proper error handling
    const script = document.createElement("script");
    script.src = "https://getlaunchlist.com/js/widget.js";
    script.defer = true;
    
    script.onload = () => {
      setIsWidgetLoaded(true);
      setWidgetInitialized(true);
      
      // Clean up any duplicate widgets after a short delay
      setTimeout(() => {
        const allWidgets = document.querySelectorAll('[data-key-id="39fnTT"]');
        const targetWidget = document.getElementById('veil-waitlist-widget');
        
        allWidgets.forEach(widget => {
          if (widget !== targetWidget && widget.id !== 'veil-waitlist-widget') {
            widget.remove();
          }
        });
      }, 500);
    };
    
    script.onerror = () => {
      setWidgetError(true);
      console.warn("Failed to load waitlist widget");
    };
    
    document.body.appendChild(script);

    return () => {
      // Safe cleanup - check if script still exists before removing
      if (document.body.contains(script)) {
        document.body.removeChild(script);
      }
    };
  }, [widgetInitialized]);

  // Smooth scroll to waitlist section
  const scrollToWaitlist = () => {
    const el = document.getElementById("waitlist-section");
    if (el) {
      el.scrollIntoView({ behavior: "smooth" });
    }
  };

  // Memoized Framer Motion variants for staggered animations
  const container = useMemo(() => ({
    hidden: { opacity: 0 },
    show: {
      opacity: 1,
      transition: { staggerChildren: 0.2 },
    },
  }), []);

  const item = useMemo(() => ({
    hidden: { opacity: 0, y: 20 },
    show: { opacity: 1, y: 0, transition: { duration: 0.6 } },
  }), []);

  return (
    <div className="min-h-screen bg-gray-50 text-gray-900">
      {/* ---------------- NAVBAR ---------------- */}
      <motion.header
        initial={{ y: -60, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ duration: 0.8 }}
        className="w-full shadow-md bg-white sticky top-0 z-50"
        role="banner"
      >
        <div className="max-w-7xl mx-auto flex justify-between items-center px-6 py-4">
          <motion.h1
            whileHover={{ scale: 1.05 }}
            className="text-2xl font-bold text-indigo-600"
          >
            Veil
          </motion.h1>
          <nav className="space-x-6" role="navigation">
            <Link 
              to="/" 
              className="text-gray-700 hover:text-indigo-600 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 rounded-md px-2 py-1 transition-colors duration-200"
            >
              Home
            </Link>
            <a 
              href="#features" 
              className="text-gray-700 hover:text-indigo-600 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 rounded-md px-2 py-1 transition-colors duration-200"
            >
              Features
            </a>
            <a
              href="#waitlist-section"
              onClick={(e) => {
                e.preventDefault();
                scrollToWaitlist();
              }}
              className="text-gray-700 hover:text-indigo-600 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 rounded-md px-2 py-1 transition-colors duration-200 cursor-pointer"
            >
              Join Waitlist
            </a>
            <Link
              to="/app"
              className="px-4 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 transition-colors duration-200"
            >
              Launch App
            </Link>
          </nav>
        </div>
      </motion.header>

      {/* ---------------- HERO SECTION ---------------- */}
      <motion.section
        initial={{ opacity: 0, y: 40 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.8 }}
        className="flex flex-col md:flex-row items-center justify-between max-w-7xl mx-auto px-6 py-20"
        role="main"
      >
        <div className="md:w-1/2">
          <h2 className="text-4xl font-bold text-gray-900 leading-tight mb-6">
            Private. Secure. Ephemeral.{" "}
            <span className="text-indigo-600">Messaging Reimagined.</span>
          </h2>
          <p className="text-gray-600 mb-6 text-lg leading-relaxed">
            Veil lets you send encrypted messages that vanish forever.  
            No traces. No logs. No leaks.
          </p>
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={scrollToWaitlist}
            className="px-6 py-3 bg-indigo-600 text-white rounded-lg shadow-lg hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 transition-all duration-200 font-medium"
            aria-label="Join waitlist for Veil secure messaging app"
          >
            Join Waitlist
          </motion.button>
        </div>
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.8 }}
          className="md:w-1/2 mt-10 md:mt-0"
        >
          <img
            src="/images/secure-messaging.svg"
            alt="Illustration of secure messaging with encryption symbols and chat bubbles"
            className="w-full h-auto"
            loading="eager"
            onError={(e) => {
              (e.target as HTMLImageElement).style.display = 'none';
            }}
          />
        </motion.div>
      </motion.section>

      {/* ---------------- FEATURES SECTION ---------------- */}
      <motion.section
        id="features"
        variants={container}
        initial="hidden"
        whileInView="show"
        viewport={{ once: true }}
        className="bg-white py-20"
        role="region"
        aria-labelledby="features-heading"
      >
        <div className="max-w-7xl mx-auto px-6">
          <h2 id="features-heading" className="sr-only">Features</h2>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-10">
            {FEATURES.map((feature, idx) => (
              <motion.div
                key={idx}
                variants={item}
                whileHover={{ scale: 1.03 }}
                className="p-6 bg-gray-50 rounded-xl shadow hover:shadow-lg transition-all duration-200 focus-within:ring-2 focus-within:ring-indigo-500 focus-within:ring-offset-2"
                tabIndex={0}
                role="article"
              >
                <h3 className="text-xl font-semibold text-indigo-600 mb-4">
                  {feature.title}
                </h3>
                <p className="text-gray-600 leading-relaxed">{feature.desc}</p>
              </motion.div>
            ))}
          </div>
        </div>
      </motion.section>

      {/* ---------------- WAITLIST SECTION ---------------- */}
      <motion.section
        id="waitlist-section"
        initial={{ opacity: 0, y: 30 }}
        whileInView={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.7 }}
        viewport={{ once: true }}
        className="bg-gray-50 py-20"
        role="region"
        aria-labelledby="waitlist-heading"
      >
        <div className="max-w-2xl mx-auto text-center px-6">
          <h3 id="waitlist-heading" className="text-3xl font-bold text-gray-900 mb-6">
            Join the Waitlist
          </h3>
          <p className="text-gray-600 mb-8 text-lg">
            Be one of the first to access Veil. Sign up below and secure your spot.
          </p>
          
          {/* Widget loading states */}
          {!isWidgetLoaded && !widgetError && (
            <div className="w-full sm:w-3/4 mx-auto h-44 bg-gray-200 animate-pulse rounded-lg flex items-center justify-center">
              <div className="text-gray-500">Loading waitlist...</div>
            </div>
          )}
          
          {widgetError && (
            <div className="w-full sm:w-3/4 mx-auto p-6 bg-red-50 border border-red-200 rounded-lg">
              <p className="text-red-700 mb-4">
                Unable to load the waitlist form. Please try refreshing the page or contact us directly.
              </p>
              <a 
                href="mailto:hello@veilapp.com" 
                className="inline-flex items-center px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 transition-colors duration-200"
              >
                Contact Us Instead
              </a>
            </div>
          )}
          
          {/* LaunchList widget - Single instance with unique identifier */}
          {isWidgetLoaded && !widgetError && (
            <div
              className="w-full sm:w-3/4 mx-auto"
              id="veil-waitlist-widget"
              data-key-id="39fnTT"
              data-height="180px"
              role="form"
              aria-label="Waitlist signup form"
              style={{ minHeight: '180px' }}
            ></div>
          )}
        </div>
      </motion.section>

      {/* ---------------- CALL TO ACTION ---------------- */}
      <motion.section
        initial={{ opacity: 0 }}
        whileInView={{ opacity: 1 }}
        viewport={{ once: true }}
        transition={{ duration: 0.8 }}
        className="bg-indigo-600 py-16"
        role="region"
        aria-labelledby="cta-heading"
      >
        <div className="max-w-3xl mx-auto text-center text-white px-6">
          <h3 id="cta-heading" className="text-3xl font-bold mb-4">
            Start using Veil today
          </h3>
          <p className="mb-6 text-lg">Experience the next generation of secure ephemeral messaging.</p>
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={scrollToWaitlist}
            className="px-6 py-3 bg-white text-indigo-600 font-semibold rounded-lg shadow hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-indigo-600 transition-all duration-200"
            aria-label="Join waitlist for early access to Veil"
          >
            Join Waitlist
          </motion.button>
        </div>
      </motion.section>

      {/* ---------------- FOOTER ---------------- */}
      <footer className="bg-gray-900 text-gray-400 py-6" role="contentinfo">
        <div className="max-w-7xl mx-auto px-6 flex flex-col sm:flex-row justify-between items-center space-y-4 sm:space-y-0">
          <p>© {new Date().getFullYear()} Veil. All rights reserved.</p>
          <nav className="flex space-x-6" role="navigation" aria-label="Footer navigation">
            <Link 
              to="/privacy" 
              className="hover:text-white focus:outline-none focus:ring-2 focus:ring-gray-400 focus:ring-offset-2 focus:ring-offset-gray-900 rounded-md px-2 py-1 transition-colors duration-200"
            >
              Privacy
            </Link>
            <Link 
              to="/terms" 
              className="hover:text-white focus:outline-none focus:ring-2 focus:ring-gray-400 focus:ring-offset-2 focus:ring-offset-gray-900 rounded-md px-2 py-1 transition-colors duration-200"
            >
              Terms
            </Link>
          </nav>
        </div>
      </footer>
    </div>
  );
}