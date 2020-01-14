require "uri"
require "net/http"
require "json"

##############################################################

API_KEY ='api_key=sVUepGID5ZZxEibIiUKyHAuLWG6TKTLLbkoJmxD3'

##############################################################

# Método para hacer la petición y parsear la respuesta.
def request(address)
    url = URI("#{address}#{API_KEY}")
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true

    request = Net::HTTP::Get.new(url)

    response = https.request(request)
    JSON.parse(response.read_body)
end

##############################################################

#Método de construción y recopilación del contenido en la API [Mars Rover Photos / Images.JPG]
def build_web_page()
    data = request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&')["photos"][0..855]
    photos = data.map { |x| x['img_src']}
    html_top = 
    "<html> \n
    <head> \n
    </head> \n
    <body>
    <ul> \n
    "

    photos.each do |photo|
        html_top += "<li><img src=\"#{photo}\"></li>\n"
    end

    html = html_top + "\n</ul>\n</body> \n
    </html>"

        
    File.write("index.html", html)
    return nil
end

##############################################################

#Método de recopilación del contenido en la API [Mars Rover Photos/ Camera Names[] / Total Photos]
def photos_count()
    photos_data = request('https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=1000&')["photos"][0..855] 

    photos_data.each do |camera|
        count = 0
        puts "Camara: #{camera['camera']['full_name']}"
        puts"Total de fotos: #{camera['rover']['cameras'].count}"
        puts "\n"
    end
    return nil
end

##############################################################

puts build_web_page()
puts photos_count()