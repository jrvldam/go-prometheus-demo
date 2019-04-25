
from locust import HttpLocust, TaskSequence, seq_task, task
import logging
from random import randint

GENRES = [
    "Terror",
    "Romantic",
    "Sci/fi",
    "Adventures"
]


class UserBehavior(TaskSequence):

    @seq_task(1)
    @task(10)
    def landingPage(self):
        self.client.get("/")

    @seq_task(1)
    @task(9)
    def buyBook(self):
        rand = randint(0, len(GENRES) - 1)
        genre = GENRES[rand]
        self.client.post("/buy/"+genre)

class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait = 1000
    max_wait = 1000
    host="http://go-prometheus-demo"
