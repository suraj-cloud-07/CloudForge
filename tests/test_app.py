from application.app import app


def test_home_endpoint():
    client = app.test_client()

    response = client.get("/")

    assert response.status_code == 200
    assert response.json["application"] == "CloudForge"
    assert response.json["version"] == "1.0.0"


def test_health_endpoint():
    client = app.test_client()

    response = client.get("/health")

    assert response.status_code == 200
    assert response.json["status"] == "healthy"


def test_info_endpoint():
    client = app.test_client()

    response = client.get("/api/info")

    assert response.status_code == 200
    assert response.json["application"] == "CloudForge"
    assert response.json["environment"] == "development"
