from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException
import requests
import datetime
import time
import re


class Scraper:

    urls = {
        "sportsurge": "https://sportsurge.net/#/events/19",
        "futemax": "https://futemax.fm/",
        "soccerstreams": "https://live.soccerstreams.net/home"
    }

    def __init__(self, delay, driver):
        self.delay = delay
        self.driver = driver

    def scrape_sportsurge(self):
        self.driver.get(self.urls["sportsurge"])

        found = False

        try:
            time.sleep(4)

            if "methods" in self.driver.current_url or "streamlist" in self.driver.current_url:
                found = True
            else:
                try:
                    element = WebDriverWait(self.driver, self.delay).until(lambda x: EC.presence_of_element_located(
                        (By.XPATH, '//*[@id="app"]/div/main/div/div[2]/div[1]/div/a/div[1]/img')) or EC.presence_of_element_located((By.XPATH, '//*[@id="app"]/div/main/div/div[1]/h5')))

                    if "There doesn't seem to be anything here. Check back later." in self.driver.page_source:
                        print("No streams found.")
                        return []
                    else:
                        print("Successfully loaded live games, proceeding...")

                except Exception as e:
                    print(
                        f"Could not load Sportsurge streams within {self.delay} seconds. Error: {e}")
                    return []
        except Exception as d:
            print(f"Weird error. {d}")
            return []

        page = self.driver.page_source
        page = BeautifulSoup(page, 'lxml')

        streamData = []

        if not found:
            streams = page.find_all("div", {"class": "col s12 m6 l4"})

            streamData = []

            for stream in streams:
                inside_link = "https://sportsurge.net/" + \
                    stream.find("a")["href"]
                inside_link = inside_link.replace("methods", "streamlist")

                teams = stream.find(
                    "a", {"class": "card-title event-title"}).text
                starts_at = stream.find(
                    "p", {"class": "card-content-text"}).text

                self.driver.get(inside_link)
                self.driver.refresh()

                try:
                    # time.sleep(delay)
                    element = WebDriverWait(self.driver, self.delay).until(
                        EC.presence_of_element_located((By.CLASS_NAME, 'stream-row')))

                    print("Successfully loaded streams, proceeding...")

                except Exception as e:
                    print(
                        f"Could not load streams within {self.delay} seconds. Error: {e}")
                    return []

                page = self.driver.page_source
                page = BeautifulSoup(page, 'lxml')

                inside_streams = page.find_all("tr", {"class": "stream-row"})

                for stream_results in inside_streams:
                    labels = []

                    for stream_data in stream_results.find_all("td"):
                        labels.append(stream_data)

                    name = labels[0].text
                    resolution = labels[1].text
                    framerate = labels[2].text
                    bitrate = labels[3].text
                    language = labels[4].text
                    coverage = labels[5].text
                    compatibility = labels[6].text
                    ads = labels[7].text
                    comments = labels[8].text
                    url = labels[9].find("a")["href"]

                    streamData.append(
                        {
                            "Sport": "Basketball",
                            "Provider": "Sportsurge",
                            "Teams": teams,
                            "Name": name,
                            "Starts At": starts_at,
                            "Resolution": resolution,
                            "Framerate": framerate,
                            "Bitrate": bitrate,
                            "Language": language,
                            "Coverage": coverage,
                            "Compatibility": compatibility,
                            "ADS": ads,
                            "Comments": comments,
                            "Fetched At": datetime.datetime.now().time().strftime('%H:%M:%S'),
                            "URL": url
                        },
                    )
        elif found:
            streamData = []

            try:
                # time.sleep(delay)
                element = WebDriverWait(self.driver, self.delay).until(
                    EC.presence_of_element_located((By.CLASS_NAME, 'stream-row')))

                print("Successfully loaded streams, proceeding...")

            except Exception as e:
                print(
                    f"Could not load streams within {self.delay} seconds. Error: {e}")
                return []

            teams = page.select_one('#app > div > main > div > h1').text.replace(
                "Available links for", "")
            starts_at = "N/A"

            inside_streams = page.find_all("tr", {"class": "stream-row"})

            for stream_results in inside_streams:
                
                labels = []

                for stream_data in stream_results.find_all("td"):
                    labels.append(stream_data)

                name = labels[0].text
                resolution = labels[1].text
                framerate = labels[2].text
                bitrate = labels[3].text
                language = labels[4].text
                coverage = labels[5].text
                compatibility = labels[6].text
                ads = labels[7].text
                comments = labels[8].text
                url = labels[9].find("a")["href"]

                streamData.append(
                    {
                        "Sport": "Basketball",
                        "Provider": "Sportsurge",
                        "Teams": teams,
                        "Name": name,
                        "Starts At": starts_at,
                        "Resolution": resolution,
                        "Framerate": framerate,
                        "Bitrate": bitrate,
                        "Language": language,
                        "Coverage": coverage,
                        "Compatibility": compatibility,
                        "ADS": ads,
                        "Comments": comments,
                        "Fetched At": datetime.datetime.now().time().strftime('%H:%M:%S'),
                        "URL": url
                    },
                )

        return streamData

    def scrape_nba_bite():
        return True

    def scrape_futemax(self):
        print("Loading Futemax...")

        try:
            response = requests.get(self.urls["futemax"])
            print("Successfully loaded streams from Futemax, proceeding...")

        except Exception as e:
            print(f"Could not load Futemax streams. Error: {e}")
            return []

        page = response.text
        page = BeautifulSoup(page, 'lxml')

        streams = page.find("div", {"class": "widget-home last_articles"})
        streams = streams.find_all("div", {"class": "item-wd"})

        streamData = []

        games = re.findall(
            r'https://futemax.fm/ (.*?) x (.*?) ao vivo', str(streams))

        for stream in streams:
            labels = []

            name = stream.find("a").find("span").text
            resolution = "N/A"
            framerate = "N/A"
            bitrate = "N/A"
            language = "N/A"
            coverage = "N/A"
            compatibility = "N/A"
            ads = "2"
            comments = "N/A"
            starts_at = "N/A"
            url = stream.find("a")["href"]

            game_teams = re.findall(
                r'https://futemax.fm/assistir-(.*?)-x-(.*?)-ao-vivo', str(url))

            try:
                teams = f"{game_teams[0][0].capitalize()} at {game_teams[0][1].capitalize()}"
            except:
                continue

            streamData.append(
                {
                    "Provider": "Futmax",
                    "Sport": "Football",
                    "Name": starts_at,
                    "Starts At": "N/A",
                    "Resolution": resolution,
                    "Framerate": framerate,
                    "Bitrate": bitrate,
                    "Language": language,
                    "Coverage": coverage,
                    "Compatibility": compatibility,
                    "ADS": ads,
                    "Comments": comments,
                    "Fetched At": datetime.datetime.now().time().strftime('%H:%M:%S'),
                    "URL": url,
                    "Teams": teams
                }
            )

        return streamData

    def scrape_soccer_streams(self):
        self.driver.get(self.urls["soccerstreams"])

        try:
            element = WebDriverWait(self.driver, self.delay).until(EC.presence_of_element_located(
                (By.XPATH, '//*[@id="content"]/div[2]/div[3]/div[4]/div[1]')))

            checks = ["VS", "Live Streams"]

            for check in checks:
                if check not in self.driver.page_source:
                    print("No Soccer Streams' streams found.")
                    return []

            print("Successfully loaded Soccer Streams' live games, proceeding...")

        except Exception as e:
            print(
                f"Could not load Soccer Streams' games within {self.delay} seconds. Error: {e}")
            return []

        page = self.driver.page_source
        page = BeautifulSoup(page, 'lxml')

        old_streams = page.find_all("a", {"class": "btn btn-sm btn-ss"})

        streams = []

        for strm in old_streams:
            if strm.text == "Live Streams":

                streams.append(strm)

        streamData = []

        for stream in streams:
            inside_link = "https://live.soccerstreams.net" + stream["href"]

            self.driver.get(inside_link)

            try:
                time.sleep(1.5)
                if 'https and acestreams will be available 30 minutes before kickoff' in self.driver.page_source:
                    print(
                        f"No streams available for this game: {self.driver.current_url}")
                    continue
                else:
                    print("Successfully loaded Soccer Streams' stream, proceeding...")
                    print(f"Found for: {self.driver.current_url}")

            except Exception as e:
                print(
                    f"Could not load Soccer Streams' stream within {self.delay} seconds. Error: {e}")
                continue

            page = self.driver.page_source
            page = BeautifulSoup(page, 'lxml')
            teams = page.select_one('#content > div:nth-child(3) > div.end > div:nth-child(1) > div.sv-box.undefined.no-radius > div.body > div > div.match-view-head-side1 > div > a > h5').text + \
                " VS " + \
                page.select_one(
                    '#content > div:nth-child(3) > div.end > div:nth-child(1) > div.sv-box.undefined.no-radius > div.body > div > div.match-view-head-side2 > div > a > h5').text

            starts_at = "N/A"

            inside_streams = page.find("tbody")
            inside_streams = inside_streams.find_all(
                "tr", {"class": "text-center"})

            for stream_results in inside_streams:
                labels = []

                for stream_data in stream_results.find_all("td"):
                    labels.append(stream_data.text)

                name = "N/A"
                resolution = labels[2]
                framerate = "N/A"
                bitrate = "N/A"
                language = labels[4]
                coverage = labels[3]
                compatibility = "N/A"
                ads = labels[5]
                comments = "N/A"
                url = stream_results.find_all("td")[3].find("a")["href"]

                streamData.append(
                    {
                        "Provider": "Soccer Streams",
                        "Sport": "Football",
                        "Teams": teams,
                        "Name": name,
                        "Starts At": starts_at,
                        "Resolution": resolution,
                        "Framerate": framerate,
                        "Bitrate": bitrate,
                        "Language": language,
                        "Coverage": coverage,
                        "Compatibility": compatibility,
                        "ADS": ads,
                        "Comments": comments,
                        "Fetched At": datetime.datetime.now().time().strftime('%H:%M:%S'),
                        "URL": url
                    },
                )

        return streamData
