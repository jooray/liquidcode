#!/usr/local/bin/ruby
require 'rubygems'
require 'RMagick'
require 'rqrcode'
require 'csv'
require 'active_support/all'
require './liquidcode.rb'

# Reads CSV with this header:
# Surname;FirstName;Title;Email;Tel;Mobile;Position;PGPID;PGPFP

CSV.foreach("businesscards.csv", :headers => true, :header_converters => :symbol, :row_sep => :auto, :col_sep => ";") do |row|
a_surname=ActiveSupport::Inflector.transliterate(row[:surname])
a_firstname=ActiveSupport::Inflector.transliterate(row[:firstname])
puts a_surname

if row[:pgpid]
mecard="MECARD:N:#{a_surname},#{a_firstname};TEL:#{row[:mobile]};EMAIL:#{row[:email]};ORG:COMPANY NAME;NOTE:PGP #{row[:pgpid]} FP #{row[:pgpfp]};;"
else
mecard="MECARD:N:#{a_surname},#{a_firstname};TEL:#{row[:mobile]};EMAIL:#{row[:email]};ORG:COMPANY NAME;URL:http://www.company.com/;;"
end

size = minimum_qr_size_from_string(mecard)
qr = RQRCode::QRCode.new( mecard, :size => size, :level => :h )

qrcode_data = qrcode_liquid_image(qr, 'white', 'black', true, 10)

f = File.new("businesscards/#{a_surname.downcase}.png",'w')
f.write(qrcode_data)
f.close

end
