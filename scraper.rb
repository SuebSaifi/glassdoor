require 'nokogiri'
require 'httparty'
require 'byebug'
require 'watir'
require 'webdrivers'
require 'csv'
class Scraper 
    def initialize
        @parsed_data
        @total_count
    end
     def scrap
        browser = Watir::Browser.new

        browser.goto "https://www.glassdoor.co.in/Reviews/new-delhi-reviews-SRCH_IL.0,9_IM1083_IP#{page_first}.htm"
        @parsed_data = Nokogiri::HTML(browser.html)
        per_page = @parsed_data.css('div.single-company-result.module').count
        total=@parsed_data.css('div.pb-lg-xxl strong').last.text.split()[0].gsub(',',"").to_i
        @total_count=(total.to_f/per_page.to_f).to_i
        browser.close
     end
     def csv    
        fatched_data = @parsed_data.css('div.single-company-result.module div.row div.col-lg-7 div.col-9 h2' )
        
        CSV.open("File1.csv", "a+",headers:["Company","Review"]) do |csv|
            fatched_data.each do |cv|
                csv << [cv.css("a").text.split("\n").join,cv.css('div.ratingsSummary span.bigRating').text.split("\n").join.to_f]      
            end
        end
    end 
end 

scraper = Scraper.new
scraper.scrap
scraper.csv