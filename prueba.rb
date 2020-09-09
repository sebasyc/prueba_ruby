require 'net/http'
require 'openssl'
require 'json'

url = 'https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=w2nVBEvhq59h1SFuEmT3BqVFXehndb3O8gMOAYhA'

def request(url)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.request(request)
    JSON.parse(response.read_body)
end

data = request(url)

def buid_web_page
    head ='<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mars Rover Photos</title>
</head>
<body>
    <ul>'
    foot ='</ul>
</body>
</html>'
    return head + foot
end

# data.each do |key, value|
#     if key == "photos"
#         value.each do |photos|
#             photos.each do |key, value|
#                 puts "<li> #{value}</li>" if key == "img_src"
#             end
#         end
#     end
# end

index = buid_web_page()

File.write('./index.html', index)