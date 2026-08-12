WELCOME_HTML = """<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>do-ecommerce-arch — Deployed by UDAP</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      background: #0d1117;
      color: #e6edf3;
      font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
    }
    .card {
      background: #161b22;
      border: 1px solid #30363d;
      border-radius: 16px;
      padding: 48px 56px;
      max-width: 560px;
      width: 92%;
      text-align: center;
      box-shadow: 0 8px 40px rgba(0,0,0,.5);
    }
    .badge {
      display: inline-block;
      background: #238636;
      color: #fff;
      font-size: 12px;
      font-weight: 600;
      letter-spacing: .6px;
      text-transform: uppercase;
      padding: 4px 14px;
      border-radius: 20px;
      margin-bottom: 28px;
    }
    h1 {
      font-size: 2.4rem;
      font-weight: 700;
      color: #58a6ff;
      letter-spacing: -0.5px;
      margin-bottom: 12px;
    }
    .subtitle {
      color: #8b949e;
      font-size: 1rem;
      line-height: 1.6;
      margin-bottom: 36px;
    }
    .health {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
      font-size: 14px;
      color: #3fb950;
      font-weight: 600;
      margin-bottom: 32px;
    }
    .links { display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; }
    .links a {
      display: inline-block;
      padding: 10px 22px;
      border-radius: 8px;
      font-size: 14px;
      font-weight: 600;
      text-decoration: none;
    }
    .links .primary { background: #238636; color: #fff; }
    .links .secondary { background: transparent; border: 1px solid #30363d; color: #58a6ff; }
    footer { margin-top: 48px; color: #484f58; font-size: 12px; }
    footer a { color: #58a6ff; text-decoration: none; }
  </style>
</head>
<body>
  <div class="card">
    <div class="badge">Deployment Successful</div>
    <h1>do-ecommerce-arch</h1>
    <p class="subtitle">
      Your application is live on DigitalOcean.<br />
      Deployed by <strong>UDAP</strong>.
    </p>
    <div class="health">Service is online</div>
    <div class="links">
      <a class="primary" href="/health/">Health Check</a>
      <a class="secondary" href="/api/info/">API Info</a>
    </div>
  </div>
  <footer>
    Powered by <a href="#">UDAP</a>
  </footer>
</body>
</html>
"""
