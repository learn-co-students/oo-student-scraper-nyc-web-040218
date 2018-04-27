require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    people_html = Nokogiri::HTML(html)

    people = []

    people_html.css(".student-card").each do |person|
      title = person.css("h4").text
      people << person[title.to_sym] = {
        :name => person.css("h4").text,
        :location => person.css(".student-location").text,
        :profile_url => person.css("a").attribute("href").value
      }
    end
    people
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    profiles_html = Nokogiri::HTML(html)
    profile = {
      # :name => profiles_html.css("h1").text,
      # :location => profiles_html.css(".profile-location").text,
      :profile_quote => profiles_html.css(".profile-quote").text,
      :bio => profiles_html.css(".description-holder p").text
    }

    # GET PROFILE LINKS
    profiles_html.css(".social-icon-container a").each do |ur|
      if ur.attribute("href").value.include?("twitter")
        profile[:twitter] = ur.attribute("href").value
      elsif ur.attribute("href").value.include?("linkedin")
        profile[:linkedin] = ur.attribute("href").value
      elsif ur.attribute("href").value.include?("git")
        profile[:github] = ur.attribute("href").value
      # elsif ur.attribute("href").value.include?("#{profiles_html.css('h1').text.gsub(/\s+/, "")+'.com'}")
      else
        profile[:blog] = ur.attribute("href").value
      end
    end
    # binding.pry
    profile
  end

end
