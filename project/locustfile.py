from locust import HttpUser, task, between
import os

class GalleryUser(HttpUser):
    # rovid varakozas
    wait_time = between(1, 3)

    def on_start(self):
        # kapunk egy CSRF tokent
        response = self.client.get("/login/")
        self.csrftoken = response.cookies.get('csrftoken')
        
        # bejelentkezés
        self.client.post("/login/", {
            "username": "testuser",
            "password": "testpassword",
            "csrfmiddlewaretoken": self.csrftoken
        }, headers={"X-CSRFToken": self.csrftoken})

    @task(3)
    def view_gallery(self):
        self.client.get("/")

    @task(1)
    def upload_photo(self):
        # kep feltoltes szimulacio
        response = self.client.get("/upload/")
        csrftoken = response.cookies.get('csrftoken')
        
        dummy_image = ("test.jpg", b"dummy image data", "image/jpeg")
        
        self.client.post("/upload/", 
            data={
                "name": f"loadtest_photo_{os.urandom(4).hex()}",
                "csrfmiddlewaretoken": csrftoken
            },
            files={"image": dummy_image},
            headers={"X-CSRFToken": csrftoken}
        )