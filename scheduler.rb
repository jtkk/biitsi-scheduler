## Given a JSON list of open courts, populate a Google Sheets.

require 'json'
require_relative 'quickstart' # This is for the Google Sheets API calls


## Get the newest data from the Biitsi website via the scraper-generated file.
file = File.read('./Biitsi.fi scraped data/courts.json')
scrape_data_hash = JSON.parse(file)
scrape_open_courts = []

## Format scraped data
scrape_data_hash["data"].each do |raw_court|
    if scrape_open_courts.empty?
        c = {venue: raw_court["venue"], date: raw_court["date"], time: raw_court["time"], lowest_price: raw_court["price"], open_court_count: 1}
        scrape_open_courts << c
    else
        # group open courts by venue, date, and time
        if scrape_open_courts.last[:venue] ==  raw_court["venue"] &&
            scrape_open_courts.last[:date] ==  raw_court["date"] &&
            scrape_open_courts.last[:time] ==  raw_court["time"]
                # We only want to keep the lowest price
                if scrape_open_courts.last[:lowest_price] > raw_court['price']
                    scrape_open_courts.last[:lowest_price] = raw_court['price']
                end
                scrape_open_courts.last[:open_court_count] += 1 # keep count of the open courts
        else
            c = {venue: raw_court["venue"], date: raw_court["date"], time: raw_court["time"], lowest_price: raw_court["price"], open_court_count: 1}
            scrape_open_courts << c
        end
    end
end

# order the results by date, time, then veune
scrape_open_courts = scrape_open_courts.sort_by { |court| [court[:date], court[:time], court[:venue]] }


# the biitsi website should only give us open courts from today onward
# todo: but we might want to have a way of accounting for old court info, just in case...

# if there are open courts, check the week of the earliest open court in the list
# this is how we'll know what sheet to start on
if scrape_open_courts.any?
    week = scrape_open_courts.first[:date].strftime("%W")
=begin


## Get list of open courts currently listed in the Google Sheet
range = "Class Data!A2:E" # this is the range of the sheet we want to grab from
sheet_result = get_sheet_courts(range) # API call to Google Sheet

# todo: do some sheet_result validation?
num_rows = sheet_result.values ? sheet_result.values.length : 0

sheet_data_hash = JSON.parse(sheet_result.to_json)
###=begin
{
    "range": string,
    "majorDimension": enum (Dimension),
    "values": [
      array
    ]
  }
###=end
sheet_open_courts = sheet_data_hash["values"] # google sheet open courts


## Update Google Sheet with scraped data
# move to the first open court from the scraped data
# check to see if the venue+date+time already exists in the spreadsheet.
if sheet_open_courts.include?(scrape_open_courts)
    # if it does, check if the price needs updating.
    if sheet_open_courts["price"] != scrape_open_courts["price"]
        # if so, update the price
        update_open_court_price(scrape_open_courts["price"], range)
        #update the price to scrape_open_courts["price"] via Google Sheets API
    end
else
    # if not, add a new column to the spreadsheet, the index based on the venue/date/time sort order

    range = "A1" # TODO: how do we determine where it goes?

    # format open court string
    open_court = format_open_court_string(
        scrape_open_courts["venue"],
        scrape_open_courts["date"],
        scrape_open_courts["time"],
        scrape_open_courts["price"])

    insert_new_court(open_court, range)
end


### Utility functions ###

## Formats the open court information for inserting into the Sheet
# format example: P (MON) 21.00-22.30 -- 70€
def format_open_court_string(location, date, start_time, price)
    location = location[1].capitalize # should be S or P
    day_of_week = date.strftime("%a").upcase # abbreviated weekday name (e.g. Sun)
    end_time = start_time + 5400 # each session is 1.5 hours (so add 5400 seconds)

    return "#{location} (#{day_of_week}) #{start_time}-#{end_time} -- #{price}"
end

## Formats the sheet name for creating a new sheet
# format example: Week 40 28.9.-4.10.
def format_sheet_name_string(start_date)
    week_number = start_date.strftime("%W") # week number of the current year, week starts on Mon
    end_date = start_date + 6 # add 6 days to get to the end of the week

    return "Week #{week_number} #{start_date}-#{end_date}"
end

=end

else
    # no open courts at all. could this be an error? update the sheet to say we tried?
end

