require 'httparty'
require 'json'

# Check if the API key is provided as an environment variable
api_key = ENV['EXCHANGE_RATE_API_KEY']

# Run command % export EXCHANGE_RATE_API_KEY'(your api key)'

# If the API key is not provided, notify the user and exit
unless api_key
  puts "Please set the environment variable 'EXCHANGE_RATE_API_KEY' with your API key."
  exit
end

# Define desired currencies and amount of the base currency to convert
base_currency = 'USD'
target_currency = 'JPY'
amount_to_convert = 100

# Request exchange rate data for the specified currencies
exchange_response = HTTParty.get("https://v6.exchangerate-api.com/v6/#{api_key}/pair/#{base_currency}/#{target_currency}")

# Check if the request was successful (HTTP status code 200)
if exchange_response.code == 200
  # Parse JSON response
  exchange_data = JSON.parse(exchange_response.body)
  # Check if the conversion result was successful
  if exchange_data["result"] == "success"
    # Extract conversion rate
    conversion_rate = exchange_data["conversion_rate"]
    # Calculate converted amount
    converted_amount = amount_to_convert * conversion_rate
    # Display conversion result
    puts "#{amount_to_convert} #{base_currency} is equal to #{converted_amount.round(2)} #{target_currency}."
  end
end
