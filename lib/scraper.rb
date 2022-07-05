require 'byebug'
require 'webdrivers'
require 'nokogiri'
require 'selenium-webdriver'
require 'open-uri'
require 'csv'
require 'watir'

#Class for Scrap the data
class Scraper
    attr_accessor :url
    def initialize(url)
        @url = url
        @res
        @total_count
    end
    def scrap
        browser = Watir::Browser.new        
        browser.goto (@url)
        @res = Nokogiri::HTML(browser.html)
        per_page = @res.css('div.single-company-result.module').count
        total=@res.css('div.pb-lg-xxl strong').last.text.split()[0].gsub(',',"").to_i
        @total_count=(total.to_f/per_page.to_f).to_i        
        p @total_count        
        browser.close
    end
    #Method for Creating the Csv File for all reviews
    def create_csv
        page=1
        while page <=@total_count
            puts "page #{page}"
            pagination_req=open("https://www.glassdoor.co.in/Reviews/new-delhi-reviews-SRCH_IL.0,9_IM1083_IP#{page}.htm","User-Agent" => "Whatever you want here")
            res = Nokogiri::HTML(pagination_req.read)
            pagination_res = res.css('div.single-company-result.module')
            CSV.open("company_review_scrap.csv","a+",headers: true , header_converters: :symbol) do |csv|
                pagination_res.each do |cv|
                    csv << [cv.css("div.row div.col-lg-7 div.col-9 h2 a").text.split("\n").join.to_s,cv.css('div.row div.col-lg-7 div.col-9
                        h2 div.ratingsSummary span.bigRating').text.split("\n").join.to_f,cv.css("div.row div.col-lg-5 div.row div.ei-contribution-wrap a.reviews span.num").text.split("\n").join.gsub("k","").to_i]      
                end
            end
            page+=1
        end
    end
end

#Class For Sorting in desciending order
class Csvsort
    attr_reader :csv
   
    def initialize(csv)
        @csv=csv
    end
    def sort_csv
        @csv.shift
        csv_sorted= @csv.sort_by {|line| -line[2].to_i}
# CSV file sorted by the reviews which column=2 
        CSV.open("Company_reviews_desc.csv","a+",headers: ["Company","Ratings","Reviws"] , header_converters: :symbol) do |c|
            csv_sorted.each do |csv|
                # c<<csv
            end
        end
    end
end

#Scraping the glassdoor website
# url = 'https://www.glassdoor.co.in/Reviews/new-delhi-reviews-SRCH_IL.0,9_IM1083.htm'
# scrap = Scraper.new(url)
# scrap.scrap
# # scrap.create_csv

# #Shorting the Csv File in desciending order of reviews
# csv=CSV.open("company_review_scrap.csv","r",{:headers=>false})
# sort=Csvsort.new(csv)
# # sort.sort_csv
# csv.close