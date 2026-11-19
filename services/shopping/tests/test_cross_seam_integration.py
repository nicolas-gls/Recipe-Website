import json
import threading
from contextlib import contextmanager
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

from app.shopping import services
from app.shopping.models import RecipeSelection


class CatalogStubHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path.startswith("/recipes/1"):
            payload = {
                "id": 1,
                "name": "Stub Recipe",
                "ingredients": [
                    {
                        "id": 1,
                        "name": "Flour",
                        "category": "Pantry",
                        "amount": 100,
                        "unit": "g",
                    }
                ],
            }
            body = json.dumps(payload).encode()
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            return

        self.send_response(404)
        self.end_headers()

    def log_message(self, *_args):
        return


class FakeResult:
    def mappings(self):
        return self

    def all(self):
        return [
            {
                "product_name": "Flour 250g",
                "price": 2.0,
                "package_size": 250,
                "package_unit": "g",
            }
        ]


class FakeConnection:
    def execute(self, _query, _parameters=None):
        return FakeResult()


class FakeEngine:
    @contextmanager
    def connect(self):
        yield FakeConnection()


def test_shopping_calls_catalog_over_http_and_calculates_result(monkeypatch):
    server = ThreadingHTTPServer(("127.0.0.1", 0), CatalogStubHandler)
    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()
    monkeypatch.setattr(services, "CATALOG_URL", f"http://127.0.0.1:{server.server_port}")
    monkeypatch.setattr(services, "engine", FakeEngine())

    try:
        result = services.calculate_shopping_list(
            [RecipeSelection(recipe_id=1, target_servings=2)]
        )
    finally:
        server.shutdown()
        thread.join(timeout=2)

    assert result.items[0].ingredient_name == "Flour"
    assert result.items[0].suggested_product_name == "Flour 250g"
    assert result.total_estimated_cost == 2.0
