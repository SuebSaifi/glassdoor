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
        @total_count = 0
    end
    
    #Method for Scrap the data
    def scrap
        browser = Watir::Browser.new        
        browser.goto (@url)
        @res = Nokogiri::HTML(browser.html)
        per_page = @res.css('div.single-company-result.module').count
        total=@res.css('div.pb-lg-xxl strong').last.text.split()[0].gsub(',',"").to_i
        @total_count=(total.to_f/per_page.to_f).to_i        
        p @total_count        
        browser.close
        @res.css('div.single-company-result.module div.col-9 h2 a').first.text
    end
    
    
    #Method for Creating the Csv File for all reviews
    def create_csv
            browser = Watir::Browser.new   
            browser.goto (@url)
            pagination_req = Nokogiri::HTML(browser.html)
            # res = Nokogiri::HTML(pagination_req.read)
            pagination_res = pagination_req.css('div.single-company-result.module')
            CSV.open("company_review_scrap1.csv","a+",headers: true , header_converters: :symbol) do |csv|                
                pagination_res.each do |cv| 
                end
            end
        browser.close
    end
    
    
    def test_create_csv
        csv=CSV.parse(File.read('company_review_scrap.csv'),headers: true)
    end
end

#Class For Sorting in desciending order
class Csvsort
    attr_reader :csv
   
    def initialize(csv)
        @csv=csv
    end
    def sort_csv
        # @csv.shift
        csv_sorted= @csv.sort_by {|line| -line[2].to_i}
        # CSV file sorted by the reviews should be column 2
        csvs = CSV.open("Company_reviews_desc.csv","a+",headers: ["Company","Ratings","Reviws"] , header_converters: :symbol) do |c|
            csv_sorted.each do |csv|
                # c<<csv
            end
        end
        csvs
    end
    
    def test_csv
        csv = CSV.parse(File.read("./Company_reviews_desc.csv"),headers: true)
        csv.by_col[2]
    end
end
