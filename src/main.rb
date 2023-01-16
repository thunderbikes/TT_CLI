require "tty-prompt"
require "tty-font"

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
        system("clear")
        if @status.empty? # in order to display no errors json packet should be {}
          puts "No Errors"
          return
        end

        puts "\n"
        table = TTY::Table.new(header: ['Error ID', 'Area','Description', 'Urgency', 'Time Since First Reported'])
        @status.each do |code, attributes|
          table << [code, attributes['area'],attributes['description'],attributes['urgency'],attributes['time']]
        end

        renderer = TTY::Table::Renderer::Unicode.new(table) 
        puts renderer.render
    end
end


prompt = TTY::Prompt.new
font = TTY::Font.new(:doom)

puts font.write("Thunder Tracker")


input_address = prompt.ask("Target Server:\t\t", convert: :uri)

#https://api.artic.edu/api/v1/artworks/129884

result = Telemetry.new(input_address)

request_per_minute = prompt.slider("Requests/Minute:\t", min: 1, max:30, step:1)
sleep_time = 60/request_per_minute

while true
  result.get_status
  result.print_status
  sleep sleep_time
  end