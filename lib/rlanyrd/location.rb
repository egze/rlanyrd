module Rlanyrd

  class Location
  
    attr_accessor :name, :url, :url_to_parse
    
    def initialize(name, url, url_to_parse = nil)
      @name = name
      @url = url
      @url_to_parse = url_to_parse
    end
      
    def conferences(follow_pagination = true)
      doc = Nokogiri::HTML(open(self.url_to_parse || self.url))
      confs = doc.css(".conference")
      results = confs.inject([]) do |arr, conf|
        name = conf.at_css(".summary.url").text.strip
        url = "http://lanyrd.com" + conf.at_css(".summary.url")[:href]
        city = conf.css(".location a").last.text.strip
        city_url = conf.css(".location a").last[:href]
        date = Date.parse(conf.at_css(".dtstart")[:title])
        tags = conf.css(".tags li a").map {|t| t.text.strip }
        arr << Rlanyrd::Conference.new(name: name, url: url, city: self.class.new(city, city_url), country: self, date: date, tags: tags)
      end
      if follow_pagination
        pagination = doc.css(".pagination li a").last
        if pagination
          2.upto(pagination.text.to_i) do |page|
            results += Rlanyrd::Location.new(self.name, self.url, self.url + "?page=#{page}").conferences(false)
          end
        end
      end
      results
    end  
    
      
    def self.all
      doc = Nokogiri::HTML(open("http://lanyrd.com/places/"))
      doc.css(".large-country-listing li a").map {|a| self.new(a.text.strip, "http://lanyrd.com" + a[:href]) }
    end

  end

end