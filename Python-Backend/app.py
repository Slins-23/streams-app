from flask import Flask, jsonify
from scraper import Scraper
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
import os

app = Flask(__name__)

@app.route('/')
def home_page():
    return "Go to the api by clicking <a href=\"https://hub-stream.herokuapp.com/api\">here</a>"

options = Options()

options.binary_location = os.environ.get("GOOGLE_CHROME_BIN")

options.add_argument("--headless")
options.add_argument("--disable-extensions")
options.add_argument("--disable-dev-shm-usage")
options.add_argument("--no-sandbox")

driver = webdriver.Chrome(executable_path=os.environ.get(
    "CHROMEDRIVER_PATH"), options=options)

@app.route('/api')
def api():
    scraper = Scraper(10, driver)

    streams = []

    streams.extend(scraper.scrape_sportsurge())
    streams.extend(scraper.scrape_futemax())
    # streams.extend(scraper.scrape_soccer_streams())

    if streams == []:
        return "No streams found."

    data = {
        "streams": streams
    }

    return jsonify(data)


if __name__ == '__main__':
    app.run()
else:
    print(f"Name: {__name__}")
