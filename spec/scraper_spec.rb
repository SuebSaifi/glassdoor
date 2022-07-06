# require 'spec_helper'
require 'scraper'
require 'csv'

RSpec.describe "Scraper" do 

    let(:scrap) { Scraper.new("https://www.glassdoor.co.in/Reviews/new-delhi-reviews-SRCH_IL.0,9_IM1083.htm")} 
    
    #TestCase Example for Scrap Method
    describe "#scrap" do
        context "When URL is open" do
            it "It should return The First name of the Company" do
            # debugger
                expect(scrap.scrap).to eq('Tata Consultancy Services')            
            end
        end 
    end
    
    # testCase for Create csv class method
    describe ".create_csv" do 
        context "When create csv method Run" do
            it " Return True" do
               expect(scrap.create_csv).to eq(true)  
            end
        end
                 
    end
    
    #Testcase for Test_Create_csv class method
    describe ".test_create_csv" do
        before {@arr = CSV.parse(File.read("./company_review_scrap.csv"),headers: true) }
        context "When run " do
            it " return page true" do 
            # debugger
                expect(scrap.test_create_csv).to eq(@arr)
            end
        end
    end
end

RSpec.describe "Csvsort" do
    before{@csv=CSV.parse(File.read("./company_review_scrap.csv"),headers: true) }
    before {@arr =CSV.parse(File.read("./Company_reviews_desc.csv"),headers: true) }
    subject(:csv) { Csvsort.new(@csv) }
    describe "#sort_csv" do
        context "When Sort Csv method run " do
            it "Should return Csv sorted file in reverse order based on there reviews" do
                expect(csv.sort_csv).to  eq(@arr)        
            end
        end        
    end
    
    #Test the Csv file 
    describe ".test_csv" do
        context "When Csv file is sorted" do        
            it "Return value by review in reverse order" do
            expect(csv.test_csv ).to eq(@arr.by_col[2])        
            end
        end            
    end
        
end
