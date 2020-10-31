About the project:

I'm part of a group of friends who like to get together to play beach volleyball. Each week, a the group organizer looks at the available courts on the facility's website, inputs them into the Google Sheet, and then asks all the members to mark their availability. If at least 4 members of the group are available for a given slot, the organizer reserves the court on the facility's website.

My goal is to automate as much of this process as possible, so the person doing the scheduling doesn't have to do as much maintenance on the Google Sheet - courts can become available/unavailable at any time throughout the week.

To do this, I wanted to create something that would scrape the available court data from the Biitsi.fi website, format it, and then insert sheets and rows into a Google Sheet.

The process (so far):

This was my first time working with web scraping, so I followed a tutorial I found online. This also doubled as an intro to the Ruby programming language, as I had never worked with Ruby before. Creating the web scraper was a lot easier than I expected, and I felt really badass once it was complete.

Writing the code that organizes and formats the data was pretty straightforward. But because I'm still getting used to the Ruby syntax, I wasn't able to code as fluidly as I'm used to. There were also some stumbling blocks due to my lack of knowledge about Ruby standard libraries. 

Once the data is gathered and formatted, the next thing is to put it in the Google Sheet. The biggest challenge for me is in trying to integrate the Google Sheets API. I know how to make API calls, but I'm still trying to understand how the authentication works, and what pieces my code needs to have in order to make those API calls successfully.

Ideas for future improvements:

- Notify the group organizer and/or the members when 4+ people are available for a given slot
- Automatically reserving the court through the facility's website if 4+ people are available for a given slot
- Create a native solution for marking player availability rather than relying on a 3rd party solution like Google Sheets
