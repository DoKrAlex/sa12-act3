require 'httparty'
require 'json'

# Check if the API key is provided as an environment variable
api_key = ENV['WEATHER_API_KEY']

# Run command % export WEATHER_API_KEY='(your api key)'

# If the API key is not provided, notify the user and exit
unless api_key
  puts "Please set the environment variable 'WEATHER_API_KEY' with your API key."
  exit
end

# Specify desired city to get weather data from
city = 'Tokyo'

# Request current weather data for the specified city
weather_response = HTTParty.get("http://api.weatherapi.com/v1/current.json?key=#{api_key}&q=#{city}&aqi=no")

# Request forecast data for the specified city for the next day
forecast_response = HTTParty.get("http://api.weatherapi.com/v1/forecast.json?key=#{api_key}&q=#{city}&days=1&aqi=no&alerts=no")

# Check if both requests were successful (HTTP status code 200)
if weather_response.code == 200 && forecast_response.code == 200
    # Parse JSON response for current weather data
    weather_data_parsed = JSON.parse(weather_response.body)
    # Parse JSON response for forecast data
    forecast_data_parsed = JSON.parse(forecast_response.body)

    # Extract current temperature, humidity, and weather conditions
    current_temp = weather_data_parsed['current']['temp_c']
    current_humidity = weather_data_parsed['current']['humidity']
    current_conditions = weather_data_parsed['current']['condition']['text']

    # Extract hourly forecast temperatures and calculate average temperature
    hourly_forecast = forecast_data_parsed['forecast']['forecastday'][0]['hour'].map { |hour| hour['temp_c'] }
    avg_hourly_temp = hourly_forecast.sum / hourly_forecast.size

    # Display weather information
    puts "Current weather in #{city}:"
    puts "Temperature: #{current_temp}°C"
    puts "Humidity: #{current_humidity}%"
    puts "Conditions: #{current_conditions}"
    puts "Average temperature for the next 24 hours: #{avg_hourly_temp.round(2)}°C"
end
