#!/bin/ruby
#curl -H "X-TrackerToken: 8e61f6b98c172e7074964adde929d943" -X GET i

verb = ARGV[0]
storyID = ARGV[1]

urlstring = "http://www.pivotaltracker.com/services/v3/projects/378939/stories/#{storyID}"

require 'net/http'
require 'uri'
require 'rexml/document'

url = URI.parse(urlstring)
req = Net::HTTP::Get.new(url.path)
req.add_field 'X-TrackerToken', '8e61f6b98c172e7074964adde929d943' 

res = Net::HTTP.start(url.host, url.port) {|http|
  http.request(req)
}

xml_data = res.body
puts xml_data
story_name = ""

doc = REXML::Document.new(xml_data)
doc.elements.each('story/name') do |element|
	story_name = element.text
end

message = "[#{verb} ##{storyID}] #{story_name}"

File.open("/tmp/msg", 'w') {|f| f.write(message) }


system("git commit -t /tmp/msg")
