require 'xmlsimple'
require 'json'

#http://openscriptures.github.io/morphhb/parsing/HebrewMorphologyCodes.html

File.open("gen1.sword", "r") do |f|
	everything = Array.new

	f.each_line do |line|
		parts = line.split(/\A([a-zA-Z]+)\s(\d+):(\d+): /)
		book=parts[1]
		chp=parts[2]
		verse=parts[3]
		id="#{book}#{chp}:#{verse}"
		xml="<verse id='#{id}' book='#{book}' chapter='#{chp}' versenum='#{verse}'>#{parts[4]}</verse>"

		parsed = XmlSimple.new({'ForceArray' => true}).xml_in(xml)

		#puts parsed.lemma

		#puts xml
		#puts "------------------------"
		
		everything.push(parsed)
	end
		puts everything
		#puts JSON.generate(everything)
end
