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
            value.each do |photo|
                photo.each do |key, value|
                    if key == "img_src"
                        html += "\t\t\t<li>"
                        html += "<img src='#{value}'>"
                        html += "</li>\n"
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

def photos_count
    hash_nasa = request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&api_key=w2nVBEvhq59h1SFuEmT3BqVFXehndb3O8gMOAYhA')

    a_camera = []
    names = 0
    hash_names = {}

    hash_nasa.each do |arr, value|
        if arr == "photos"
            value.each do |photo|
                photo.each do |key, cam|
                    if key == "camera"
                        cam.each do |k, v|
                            if k == "name"
                                names = v
                                a_camera = a_camera.append(names) 
                                hash_names[names] = a_camera.count(names)
                            end
                        end
                    end
                end
            end
        end
    end
    return hash_names
end

puts "Cantidad de fotos por cámara:"
puts photos_count()
