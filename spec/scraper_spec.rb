# require 'spec_helper'
require 'scraper'
RSpec.describe "Scraper" do 
    describe "#scrap" do
        it "it return true" do
            scrap=Scraper.new("https://www.glassdoor.co.in/Reviews/new-delhi-reviews-SRCH_IL.0,9_IM1083.htm")
            expect(scrap.scrap).to eq(true)            
        end
                
    end
end

