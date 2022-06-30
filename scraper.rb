require 'nokogiri'
require 'httparty'
require 'byebug'
require 'watir'
require 'webdrivers'
require 'csv'

def scraper  
page=1
    browser = Watir::Browser.new
    (10).times do 
    browser.goto "https://www.glassdoor.co.in/Reviews/new-delhi-reviews-SRCH_IL.0,9_IM1083_IP#{page}.htm"
    page+=1
    
    # url = 
    
    # unparsed_page = HTTParty.get(url)
    parsed_page=Nokogiri::HTML(browser.html)  
    # debugger
    company_review= parsed_page.css('div.single-company-result.module div.row div.col-lg-5 div.row div.ei-contribution-wrap a.reviews span.num').text
    company_name= parsed_page.css('div.single-company-result.module div.row div.col-lg-7 div.col-9 h2  a').text
    
    # File.open("File.csv", "a+") {|f| f.write "#{company_review}" }
    CSV.open("File.csv", "a+") do |csv|    
        csv << [:company, company_name]
        csv << [:review, company_review]
        
    end
end
    browser .close
end
scraper