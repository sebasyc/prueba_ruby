require 'net/http'
require 'openssl'
require 'json'

def request(url)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response = http.request(request)
    JSON.parse(response.read_body)
end

def buid_web_page
    body = request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=w2nVBEvhq59h1SFuEmT3BqVFXehndb3O8gMOAYhA')

    html ="<!DOCTYPE html>
    <html>
    <head>
        <link rel='stylesheet' href='style.css'>
        <title>Mars Rover Photos</title>
    </head>
    <body>
        <ul> \n"

    body.each do |arr, value|
        if arr == "photos"
            value.each do |photos|
                photos.each do |key, value|
                    if key == "img_src"
                        html += "\t\t\t<li>\n"
                        html += "\t\t\t\t<img src='#{value}'>\n"
                        html += "\t\t\t</li>\n"
                    end
                end
            end
        end
    end

    foot ="</ul>
</body>
</html>"

    return html + foot
end

index = buid_web_page()

File.write('./index.html', index)