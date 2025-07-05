<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verdex - Plant Identification Platform</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg,rgba(131, 213, 234, 0.63) 0%,rgba(233, 211, 255, 0.53) 100%);
            min-height: 100vh;
            color: #1a1a1a;
            line-height: 1.6;
        }

        .landing-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }

        /* Main Content */
        .hero-section {
            width: 100%;
            max-width: 1400px;
            text-align: center;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px) saturate(180%);
            border-radius: 24px;
            padding: 3rem 2rem;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
            border: 1px solid rgba(102, 126, 234, 0.2);
            border-radius: 50px;
            margin-bottom: 2rem;
            backdrop-filter: blur(10px);
        }

        .hero-badge i {
            font-size: 1.25rem;
            color: #667eea;
        }

        .hero-badge span {
            font-weight: 600;
            color: #667eea;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .hero-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 1rem;
            line-height: 1.2;
        }

        .hero-subtitle {
            font-size: 1.1rem;
            color: #4a5568;
            margin-bottom: 2rem;
            max-width: 500px;
            margin-left: auto;
            margin-right: auto;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
            margin-top: 2rem;
        }

        .feature-card {
            padding: 1.5rem;
            background: rgba(255, 255, 255, 0.8);
            border-radius: 12px;
            border: 1px solid rgba(102, 126, 234, 0.1);
            text-align: center;
            transition: all 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 32px rgba(102, 126, 234, 0.15);
        }

        .feature-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem auto;
            color: white;
            font-size: 1.5rem;
        }

        .feature-card h3 {
            font-size: 1.1rem;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 0.75rem;
        }

        .feature-card p {
            color: #4a5568;
            font-size: 0.9rem;
        }

        .cta-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 1rem;
        }

        .cta-buttons {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            justify-content: center;
        }

        .cta-btn {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.875rem 1.5rem;
            text-decoration: none;
            font-weight: 600;
            font-size: 1rem;
            border-radius: 10px;
            transition: all 0.3s ease;
            min-width: 160px;
            justify-content: center;
        }

        .cta-btn.primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.3);
        }

        .cta-btn.primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 28px rgba(102, 126, 234, 0.4);
        }

        .cta-btn.secondary {
            background: rgba(255, 255, 255, 0.9);
            color: #667eea;
            border: 2px solid rgba(102, 126, 234, 0.2);
        }

        .cta-btn.secondary:hover {
            background: rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }

        .version-info {
            margin-top: 1.5rem;
            padding: 0.75rem 1.5rem;
            background: rgba(102, 126, 234, 0.05);
            border-radius: 10px;
            border: 1px solid rgba(102, 126, 234, 0.1);
            color: #4a5568;
            font-size: 0.85rem;
        }



        /* Responsive Design */
        @media (max-width: 768px) {
            .landing-container {
                padding: 1rem;
            }

            .hero-section {
                padding: 2rem 1.5rem;
            }

            .hero-title {
                font-size: 2rem;
            }

            .hero-subtitle {
                font-size: 1rem;
            }

            .features-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
                margin-top: 2rem;
            }

            .cta-buttons {
                flex-direction: column;
                align-items: center;
            }

            .cta-btn {
                width: 100%;
                max-width: 280px;
            }
        }
    </style>
</head>
<body>
    <div class="landing-container">
        <section class="hero-section">
                <div class="hero-badge">
                    <i class="bi bi-flower1"></i>
                    <span>Smart Plant Identification using Machine Learning.</span>
                </div>
                
                <h1 class="hero-title">Verdex</h1>
                <p class="hero-subtitle">
                    A powerful plant identification platform that combines machine learning with a comprehensive database to help you identify, learn about, and explore the world of plants.
                </p>
                <div class="cta-buttons">
                    <a href="/login" class="cta-btn primary">
                        <i class="bi bi-person-circle"></i>
                        <span>Get Started</span>
                    </a>
                    <a href="/documentation" class="cta-btn secondary">
                        <i class="bi bi-book"></i>
                        <span>View Documentation</span>
                    </a>
                </div>
                
                    
                <div class="features-grid mt-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-cpu"></i>
                        </div>
                        <h3>AI-Powered Recognition</h3>
                        <p>Advanced machine learning algorithms for accurate plant identification from photos</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-globe"></i>
                        </div>
                        <h3>Multi-Language Support</h3>
                        <p>Comprehensive plant database with translations in multiple languages</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-phone"></i>
                        </div>
                        <h3>Mobile-First Design</h3>
                        <p>Cross-platform mobile application for plant identification on the go</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="bi bi-shield-check"></i>
                        </div>
                        <h3>Secure & Reliable</h3>
                        <p>Built with Laravel backend and modern security practices</p>
                    </div>
                </div>

                <div class="cta-section">
                    <div class="version-info">
                        <i class="bi bi-info-circle"></i>
                        <span>Version 1.0.0 • Laravel 10.x • Vue.js 3 • Flutter</span>
                    </div>
                </div>
            </section>
        </div>
</body>
</html> 