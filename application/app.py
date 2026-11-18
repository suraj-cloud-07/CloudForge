from flask import Flask, jsonify

app = Flask(__name__)

APP_NAME = "CloudForge"
APP_VERSION = "1.0.0"


@app.route("/")
def home():
    return jsonify({
        "application": APP_NAME,
        "message": "Welcome to CloudForge!",
        "version": APP_VERSION
    })


@app.route("/health")
def health():
    return jsonify({
        "status": "healthy"
    }), 200


@app.route("/api/info")
def info():
    return jsonify({
        "application": APP_NAME,
        "version": APP_VERSION,
        "environment": "development"
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
