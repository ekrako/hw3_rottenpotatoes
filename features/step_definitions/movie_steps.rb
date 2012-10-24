# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert_not_nil (page.body=~/(<td>#{e1}<\/td>).+(<td>#{e2}<\/td>)/m)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(", ").each do |e| 
    if uncheck
      uncheck("ratings_#{e}") 
    else
      check("ratings_#{e}") 
    end
  end
end

Then /I should( not)? see the following ratings: (.*)/ do |notshown, rating_list|
  rating_list.split(", ").each do |text| 
    if notshown
      assert_nil (page.body=~/(<td>#{text}<\/td>)/)
    else
      assert_not_nil (page.body=~/(<td>#{text}<\/td>)/)
    end
  end
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

Then /^I should see all of the movies$/ do
  Movie.all_ratings.each do |text|
    if page.respond_to? :should
      page.should have_content("<td>#{text}")
    else
      assert_equal page.all('table#movies tbody tr').count , Movie.count
    end
  end
end

Given /^I (un)?check all the checkboxes$/ do |uncheck|
  Movie.all_ratings.each do |e| 
    if uncheck
      uncheck("ratings_#{e}") 
    else
      check("ratings_#{e}") 
    end
  end
end
