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
        table = TTY::Table.new(header: ['Error ID', 'Area','Description', 'Urgency', 'Time Since First Reported'])
        @status.each do |code, attributes|
          time_i = Time.now.utc.to_i - attributes['time'].to_i
          statement = time_i.to_s + " second(s) ago"
          if time_i > 60
            minutes = time_i/60.0
            statement = minutes.round(2).to_s + " minute(s) ago"
          end
          table << [code, attributes['area'],attributes['description'],attributes['urgency'],statement] #time needs to be fixed
        end
        renderer = TTY::Table::Renderer::Unicode.new(table) 
        puts renderer.render
    end
end

# setup prompt and font
prompt = TTY::Prompt.new
font = TTY::Font.new(:doom)
puts font.write("Thunder Tracker")

# take input (must be URI format)
input_address = prompt.ask("Target Server:\t\t", convert: :uri)
result = Telemetry.new(input_address+"/get")

# as of now, flickering seems to be under control under 30 requests/minute
request_per_minute = prompt.slider("Requests/Minute:\t", min: 1, max:30, step:1)
sleep_time = 60/request_per_minute

# loop to update status
while true
  result.get_status
  result.print_status
  sleep sleep_time
  end