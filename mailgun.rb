require 'csv'
require 'rest-client'
require 'multimap'

API_KEY = 'REPLACE THIS'
MAILGUN_DOMAIN = 'markupwand.mailgun.org'

def send_complex_message(to_name, to_email, custom_message)
  text = <<EMAIL
Hi %name%,

%message%

I am very delighted to invite you to my wedding with Valli, on Thursday, the 15th of November. Please be there
to wish us. Your presence would make the moment more special.

When    :  November 15, 2012 (2 days after Diwali)
Where   :  SP. CT. House, No 7, 
           Meenakshipuram Road, 
           Arimalam, Pudukkottai http://goo.gl/maps/yeUPa 
           (74km from Trichy, 20km from Pudukkottai)
Contact : 09986016485 (my number)

I'll be happy to arrange all the logistics - just hit reply :)

Yours,
Alagu
EMAIL

  html = File.open('email.html', 'r').read

  data = Multimap.new
  data[:from] = "Alagu <allagappan@gmail.com>"
  data[:to] = "#{to_name} <#{to_email}>"
  data[:subject] = "Wedding Invitation"
  custom_text = text.gsub("%name%", to_name).gsub("%message%", custom_message)
  custom_html = html.gsub("%name%", to_name).gsub("%message%", custom_message)
  data[:text] = custom_text
  data[:html] = custom_html
  data[:attachment] = File.new(File.join("invite.ics"))
  data[:attachment] = File.new(File.join("invitation.jpg"))
  puts "Sending email to #{to_name} <#{to_email}> (#{custom_message})"
  RestClient.post "https://api:key-#{API_KEY}"\
  "@api.mailgun.net/v2/#{MAILGUN_DOMAIN}/messages", data
end


people = CSV.parse(File.read('people-prod.txt'))

people.each do |person|
  name = person[0]
  email = person[1]
  message = person[2] == nil ? "" : person[2] 
  send_complex_message(name, email, message)
end
