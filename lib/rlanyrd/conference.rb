module Rlanyrd

  class Conference
  
    attr_accessor :name, :url, :city, :country, :date, :tags
    
    def initialize(params = {})
      @name = params[:name]
      @url = params[:url]
      @city = params[:city]
      @country = params[:country]
      @date = params[:date]
      @tags = params[:tags]
    end
  
  end

end