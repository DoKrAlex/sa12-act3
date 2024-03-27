require 'httparty'
require 'json'

# Check if the API key is provided as an environment variable
api_key = ENV['TICKETMASTER_API_KEY']

# Run command % export TICKETMASTER_KEY='(your api key)' in your terminal

# If the API key is not provided, notify the user and exit
unless api_key
  puts "Please set the environment variable 'TICKETMASTER_API_KEY' with your API key."
  exit
end

# Specify desired city to get event data from
city = 'Memphis'

# Make an HTTP GET request to the Ticketmaster API to retrieve events information for the specified city
ticketmaster_response = HTTParty.get("https://app.ticketmaster.com/discovery/v2/events.json?apikey=#{api_key}&city=#{city}")

# If the HTTP response code is 200 (OK), proceed with parsing the response
if ticketmaster_response.code == 200
  event_data = JSON.parse(ticketmaster_response.body)  # Parse the JSON response into a Ruby hash

  # Check if there are events embedded in the response
  if event_data["_embedded"] && event_data["_embedded"]["events"]
    # Iterate over each event in the response
    event_data["_embedded"]["events"].each do |event|
      event_name = event["name"]  # Extract the name of the event
      # Extract the venue name, if available; otherwise, use "Unknown venue"
      venue_name = event["_embedded"]["venues"][0]["name"] rescue "Unknown venue"
      # Extract the event date, if available; otherwise, use "Unknown date"
      event_date = event["dates"]["start"]["localDate"] rescue "Unknown date"
      # Extract the event time, if available; otherwise, use "Unknown time"
      event_time = event["dates"]["start"]["localTime"] rescue "Unknown time"

      # Print event details
      puts "Event: #{event_name}"
      puts "Venue: #{venue_name}"
      puts "Date: #{event_date}"
      puts "Time: #{event_time}"
      puts "=========================="
    end
  else
    puts "No events found in #{city_name}."  # Notify the user if no events are found in the specified city
  end
end
