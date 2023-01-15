require "tty-prompt"
require "tty-font"
require "tty-spinner"
require "tty-table"
require 'net/http'
require 'json'

class Telemetry
    def initialize(link)
        @link = link
    end

    def get_status
      response = Net::HTTP.get_response(@link)
      @status = JSON.parse(response.body)
    end

    def print_status
        puts @status
    end
end



 
prompt = TTY::Prompt.new
font = TTY::Font.new(:doom)
spinner = TTY::Spinner.new("[:spinner] Loading ...", format: :pulse_2)
table = TTY::Table.new(header: ['Error ID', 'Area','Description', 'Urgency', 'Time Since First Reported'])
table << ['1', 'Engine', 'Engine is overheating', 'High', '1 minute']
table << ['2', 'Engine', 'Engine is overheating', 'High', '1 minute']
renderer = TTY::Table::Renderer::Unicode.new(table)
puts renderer.render

table << ['3', 'Engine', 'Engine is overheating', 'High', '1 minute']
puts renderer.render

table = TTY::Table.new(header: ['Error ID', 'Area','Description', 'Urgency', 'Time Since First Reported'])
table << ['1', 'Engines', 'Engine is overheating', 'High', '1 minute']
table << ['2', 'Engines', 'Engine is overheating', 'High', '1 minute']

puts renderer.render

puts font.write("Thunder Tracker")


input_address = prompt.ask("Target Server:\t\t", convert: :uri)

#https://api.artic.edu/api/v1/artworks/129884

result = Telemetry.new(input_address)


#if response code is not whats expected quit else continue

request_per_minute = prompt.slider("Requests/Minute:\t", min: 10, max:120, step:10)
sleep_time = 60/request_per_minute

while true
  result.get_status
  result.print_status
  sleep sleep_time
  end

=begin
while true
    response = get_response(input_address)
    spinner.stop("Done!") # Stop animation
    #system "clear"
    json_obj = JSON.parse(response.body)
    system "clear" #goated
    puts json_obj["data"]["id"]
    spinner.auto_spin # Automatic animation with default interval
    sleep sleep_time
    end
=end
#response = Net::HTTP.get(input_address)




