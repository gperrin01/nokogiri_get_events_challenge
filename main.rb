
# 'div .ListingOuter' is div with all info
  # page.css('.searchResultsPrice').text  # warnign, only gives me 9 results although 10 on the page
  # inside of each,     # .ListingAct blockquote h3 a links to the specific page


# 1) Prepare to iterate through ALL the pages
last_page_num = page.css('a.pagination_link').last.children.first.text.to_i

(1..last_page_num).each do |page_num|

  page = Nokogiri::HTML(open("http://www.wegottickets.com/searchresults/page/#{page_num}/all"))

  # On each page, all results are shown inside this 'div .ListingOuter'
  page.css('div.ListingOuter').each do |listing|

   # get the price inside that listing's "searchResultsPrice"
   listing_price = listing.css('.searchResultsPrice').text.split('= ').last.to_i

   # get rest of info inside ".ListingAct blockquote p"
   listing_name = listing.css('.ListingAct blockquote h3').text
   listing_venue_city = listing.css('.ListingAct blockquote p .venuetown').text
   listing_venue_name = listing.css('.ListingAct blockquote p .venuename').text

   # grabbing the date
   date_holder = listing.css('.ListingAct blockquote p')
   date_holder.css('.venuetown').remove 
   date_holder.css('.venuename').remove 
   date_holder.css('i').remove
   # date_holder.text now is e.g. "Wed 8th Jul, 2015, 8.00pm"
   listing_date = date_holder.text.split(', ')[0] + ' ' + date_holder.text.split(', ')[1]
   listing_time = date_holder.text.split(', ').last

   # REFINE ON THE ARTISTS eg remove the with if any, split by > if any
   listing_artists = listing.css('.ListingAct blockquote p i').text  

  end # end of iteration through the individual listings





end # end of iteration through pages
