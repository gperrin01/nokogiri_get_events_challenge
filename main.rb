# Must get Artist, City, Venue, Date, Price

# page http://www.wegottickets.com/searchresults/page/1/all

# 'div .ListingOuter' is div with all info
  # <div class="searchResultsPrice">£10.00 + £1.00 Booking fee = <strong>£11.00</strong></div>
  # split text after <strong> then after </ and you got full price
  # page.css('.searchResultsPrice').text  # warnign, only gives me 9 results although 10 on the page

  # inside of each,
    # .ListingAct blockquote h3 a links to the specific page
    # .ListingAct blockquote p : venue, city, date&time, artists


# Pages - iterate up to : text of Last 'a .pagination_link' that is inside 'div .paginator'
 # page = Nokogiri::HTML(open("http://www.wegottickets.com/searchresults/page/1/all"))






# 1) Prepare to iterate through ALL the pages
last_page_num = page.css('a.pagination_link').last.children.first.text.to_i

(1..last_page_num).each do |page_num|
  page = Nokogiri::HTML(open("http://www.wegottickets.com/searchresults/page/#{page_num}/all"))

end 
