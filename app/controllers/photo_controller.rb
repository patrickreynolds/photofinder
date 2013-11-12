require 'rubygems'
require 'nokogiri'
require 'open-uri'

class PhotoController < ApplicationController
  def index
  end

  def show

  	@url = params[:search_input]
  	if(@url[0] != "h")
  		@url = "http://" + @url
  	end
  	@page = Nokogiri::HTML(open(@url))
  	@imageTags = @page.css('img[src]')

  	# Function that recieves an array of elements and returns an 
	# array of those elements converted to strings
	def convertElementsToString (arrayOfElements)
		convertedElements = Array.new

		arrayOfElements.each do |elem|
			# Array of all image tags as strings Ex. <img alt="xxxx" src="xxx" />						
			convertedElements.push(elem.to_s)
		end
		
		return convertedElements
	end


	# Function that takes in the root url, along with array of <img src=""> strings
	# and returns an array of each full http url
	def stripImageTags(rootURL, imageTagsArray)
		listOfImageLinks = Array.new

		imageTagsArray.each do |imgString|
			firstCharacter = imgString.index("src") + 5
			endingQuote = imgString[firstCharacter..-1].index("\"") + firstCharacter
			
			urlPath = imgString[firstCharacter...endingQuote]

			if urlPath[0] != "h"
				if urlPath[0] == "/"
					urlPath = rootURL + urlPath
				else 
					urlPath = rootURL + "/" + urlPath
				end
			end

			listOfImageLinks.push(urlPath)
		end
		return listOfImageLinks
	end

	@convertedImageTags = convertElementsToString(@imageTags)
	@finalListOfImageLinks = stripImageTags(@url, @convertedImageTags) # Recieving an array of full http:// url links to images

  end
end
