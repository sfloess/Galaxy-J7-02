#!/usr/bin/env python3
"""
Hello World Web Server Demo
Run with: python demo_hello_world.py
Then visit: http://localhost:8080 in your browser
"""

from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import sys
from datetime import datetime

class HelloWorldHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()

            html = f"""
            <!DOCTYPE html>
            <html>
            <head>
                <title>Termux Mini Computer</title>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style>
                    body {{
                        font-family: Arial, sans-serif;
                        max-width: 800px;
                        margin: 50px auto;
                        padding: 20px;
                        background: #1e1e1e;
                        color: #fff;
                    }}
                    h1 {{ color: #4CAF50; }}
                    .info {{ background: #2d2d2d; padding: 20px; border-radius: 10px; margin: 20px 0; }}
                    .code {{ background: #000; padding: 10px; border-radius: 5px; font-family: monospace; }}
                    a {{ color: #4CAF50; text-decoration: none; }}
                    a:hover {{ text-decoration: underline; }}
                </style>
            </head>
            <body>
                <h1>🚀 Hello from Termux Mini Computer!</h1>

                <div class="info">
                    <h2>Server Info</h2>
                    <p><strong>Time:</strong> {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</p>
                    <p><strong>Running on:</strong> Samsung J7 (Termux)</p>
                    <p><strong>Language:</strong> Python 3</p>
                </div>

                <div class="info">
                    <h2>What you can do:</h2>
                    <ul>
                        <li>✅ Run web servers</li>
                        <li>✅ Write and test code</li>
                        <li>✅ SSH into other machines</li>
                        <li>✅ Install and run Linux tools</li>
                        <li>✅ Create automation scripts</li>
                        <li>✅ Learn programming</li>
                    </ul>
                </div>

                <div class="info">
                    <h2>API Endpoints:</h2>
                    <p><a href="/api">/api</a> - JSON API demo</p>
                    <p><a href="/info">/info</a> - System information</p>
                </div>

                <div class="code">
                    <p>This server is running Python code on your phone!</p>
                    <pre>python demo_hello_world.py</pre>
                </div>
            </body>
            </html>
            """
            self.wfile.write(html.encode())

        elif self.path == '/api':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()

            data = {
                'status': 'success',
                'message': 'Hello from Termux API!',
                'timestamp': datetime.now().isoformat(),
                'server': 'Python HTTP Server on Samsung J7'
            }
            self.wfile.write(json.dumps(data, indent=2).encode())

        elif self.path == '/info':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()

            import socket
            hostname = socket.gethostname()

            data = {
                'hostname': hostname,
                'python_version': sys.version.split()[0],
                'endpoints': ['/', '/api', '/info']
            }
            self.wfile.write(json.dumps(data, indent=2).encode())

        else:
            self.send_response(404)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(b'<h1>404 Not Found</h1>')

    def log_message(self, format, *args):
        print(f"[{datetime.now().strftime('%H:%M:%S')}] {args[0]}")

if __name__ == '__main__':
    port = 8080
    server = HTTPServer(('', port), HelloWorldHandler)
    print(f"""
╔══════════════════════════════════════════════════════════╗
║   Python Web Server Running! 🚀                          ║
╚══════════════════════════════════════════════════════════╝

📡 Server started on port {port}
🌐 Open in browser: http://localhost:{port}
🔧 Press Ctrl+C to stop

Endpoints:
  • http://localhost:{port}/     - Main page
  • http://localhost:{port}/api  - JSON API
  • http://localhost:{port}/info - Server info
    """)

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n\n✅ Server stopped. Goodbye!")
        server.shutdown()
