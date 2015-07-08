require 'open-uri'
require 'json'

namespace :scrape do
  desc "Scrape events"
  task get_events: :environment do

    # 'div .ListingOuter' is div with all info
      # page.css('.searchResultsPrice').text  # warnign, only gives me 9 results although 10 on the page
      # inside of each,     # .ListingAct blockquote h3 a links to the specific page

    # begin 
    # Result is an array of hashes, each hash having all info for an event
    result = []

    # 1) Prepare to iterate through ALL the pages
    first_page = Nokogiri::HTML(open("http://www.wegottickets.com/searchresults/page/1/all"))
    last_page_num = first_page.css('a.pagination_link').last.children.first.text.to_i
    puts "last page is #{last_page_num}"

    # (1..last_page_num).each do |page_num|
    (1..3).each do |page_num|

      puts "page number #{page_num}"

      page = Nokogiri::HTML(open("http://www.wegottickets.com/searchresults/page/#{page_num}/all"))
      # result = []
      # page = Nokogiri::HTML(open("http://www.wegottickets.com/searchresults/page/1/all"))

      # On each page, all results are shown inside this 'div .ListingOuter'
      page.css('div.ListingOuter').each do |listing|

       # reset the listing_info holder
       listing_info = {}

       # get the price inside that listing's "searchResultsPrice"
       listing_info[:listing_price] = listing.css('.searchResultsPrice').text.split('= ').last.to_i

       # get rest of info inside ".ListingAct blockquote p"
       listing_info[:listing_name] = listing.css('.ListingAct blockquote h3').text
       listing_info[:listing_venue_city] = listing.css('.ListingAct blockquote p .venuetown').text
       listing_info[:listing_venue_name] = listing.css('.ListingAct blockquote p .venuename').text

       # grabbing the date
       date_holder = listing.css('.ListingAct blockquote p')
       date_holder.css('.venuetown').remove 
       date_holder.css('.venuename').remove 
       date_holder.css('i').remove
       # date_holder.text now is e.g. "Wed 8th Jul, 2015, 8.00pm"
       if date_holder.text.split(', ')[1]
         listing_info[:listing_date] = date_holder.text.split(', ')[0] + ' ' + date_holder.text.split(', ')[1]
         listing_info[:listing_time] = date_holder.text.split(', ').last
       else
          listing_info[:listing_date] = date_holder.text.split(', ')[0]
          listing_info[:listing_time] = date_holder.text.split(', ').last
       end

       # REFINE ON THE ARTISTS eg remove the with if any, split by > if any
       listing_info[:listing_artists] = listing.css('.ListingAct blockquote p i').text  

       # store listing infos into the result array
       result << listing_info

      end # end of iteration through the individual listings


    end # end of iteration through pages

    # result = result.to_json
    puts "RESULT IS #{result}"

    # rescue Exception => e
    #   puts "error with a command found"
    # end

  end # end of task

end
