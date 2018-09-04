require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html_content = open(index_url)
    node_site = Nokogiri::HTML(html_content)

    scraped_list=[]

    node_site.css(".roster-cards-container .student-card").each do |card|
      scraped_list << {
                        name: "#{card.css(".student-name").text}",
                        location: "#{card.css(".student-location").text}",
                        profile_url: "#{card.css("a").first["href"]}"
                      }
    end
    scraped_list
  end

  def self.scrape_profile_page(profile_url)
    html_content= open(profile_url)
    scraped_content=Nokogiri::HTML(html_content)

    scraped_list=[]
    scraped_content.css(".vitals-container").each do |card|
      binding.pry
      count=0
      num_social=card.css(".social-icon-container a").count
      while count < num_social
        value = card.css(".social-icon-container a")[count]["href"]
        key=value.scan(/\/\b(...*)\./).flatten[0]
        key = key.split(".")[-1] if key.include?(".")
          if key != "blog"
            key=key.to_sym
          else
            key=:blog
          end
        hash={key => value}
        scraped_list << hash
        count+=1
      end
      scraped_list << {profile_quote: "#{card.css(".profile-quote").text.strip}"}
    end



    # scraped_list << {
    #                   "#{card.css(".social-icon-container a")[0]["href"].split(".")[1]}:" "#{card.css(".social-icon-container a")[0]["href"]}" if "#{card.css(".social-icon-container a")[0]["href"]}".is_a?String,
    #                   "#{card.css(".social-icon-container a")[1]["href"].split(".")[1]}:" "#{card.css(".social-icon-container a")[1]["href"]}" if "#{card.css(".social-icon-container a")[1]["href"]}".is_a?String,
    #                   "#{card.css(".social-icon-container a")[2]["href"].split(".")[1]}:" "#{card.css(".social-icon-container a")[2]["href"]}" if "#{card.css(".social-icon-container a")[2]["href"]}".is_a?String,
    #                   profile_quote: "#{card.css(".profile-quote").text.strip}"
    #                 }
    # end

    scraped_content.css(".details-container").each do |card|
    scraped_list << {
                      #blog: "#{card.css("a").first["href"]}",
                      bio: "#{card.css(".bio-block .description-holder").text.strip}"
                    }
    end

    scraped_list
  end

end
