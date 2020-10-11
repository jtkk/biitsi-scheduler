# Biitsi Web Scraper
# Gets all open courts from Biitsi Pasila and Biitsi Salmisaari for the current calendar week and the following calendar week.
require 'open-uri'
require 'net/http'
require 'kimurai'

class BiitsiScraper < Kimurai::Base
    @name = 'biitsi_court_scraper'
    @start_urls = ["https://www.biitsi.fi/varaa?venue=pasila", "https://www.biitsi.fi/varaa?venue=salmisaari"]
    @engine = :selenium_chrome

    @@courts = [] # array of available courts

    def scrape_open_courts(url)
        sleep 5 # reservation calendar is populated dynamically via javascript; give the page time to load
        
        doc = browser.current_response
        #        browser.save_screenshot('screenshot.png')
        openCourts = doc.css('div.Calendar__WeekResponsive-th92lr-1') # all the open courts are listed under this class name
        openCourts.css('div.court--free').each do |element|
            # each element is a free court
            # we expect the id of each open court to be in this format: court-2020-09-13T09-1
            court_html_id = element.attributes["id"].value.split("-")
            year = court_html_id[1]
            month = court_html_id[2]
            day_time = court_html_id[3]
            day = day_time.split("T")[0]

            venue = url[url.index("venue=")..-1].delete_prefix("venue=") # biitsi location of the open court
            date = Date.parse(year + "-" + month + "-" + day) # date of the open court
            time = day_time.split("T")[1] # time of the open court
            court_number = court_html_id[4] # which court is free?
            price = element.css('div.Court__CourtPrice-sc-14ghj1t-2').text # price of the open court

            court = {:venue => venue, :date => date, :time => time, :courtNumber => court_number, :price => price}

            # add court to list if it's unique
            @@courts << court if !@@courts.include?(court)
        end
    end

    def parse(response, url:, data: {})
        scrape_open_courts(url)
        File.open('courts.json', "w") do |f|
            f.write(JSON.pretty_generate({:data => @@courts}))
        end

        @@courts
    end
end

courts = BiitsiScraper.crawl!