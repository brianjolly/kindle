# encoding: UTF-8
require 'rexml/document'
require 'xmlsimple'
require 'json'

#http://openscriptures.github.io/morphhb/parsing/HebrewMorphologyCodes.html
#diatheke -b OSHB -o fmcvaplsbwgeixM -f internal -l en -e UTF8 -k Gen 1:1
#diatheke -b OSHB -o fmcvaplsbwgeixM -f internal -l en -e UTF8 -k Gen 1

#File.open("gen2.sword", "r") do |f|
File.open(ARGV[0], "r") do |f|
	everything = ""

	head = <<-DOC
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Tanakh</title>
<link rel="stylesheet" href="KUG.css" type="text/css" />
</head>
<body>
<div>
	DOC

	puts head

	@verses = Array.new

	f.each_line do |line|
		parts = line.split(/\A([a-zA-Z]+)\s(\d+):(\d+): /)
		book=parts[1]
		chp=parts[2]
		versenum=parts[3]
		id="#{book}#{chp}:#{versenum}"
		xml="<verse id='#{id}' book='#{book}' chapter='#{chp}' versenum='#{versenum}'>#{parts[4]}</verse>"

		verse = Hash.new
		verse['id'] = id
		verse['book'] = book
		verse['chapter'] = chp
		verse['versenum'] = versenum
		verse['words'] = Array.new

		doc = REXML::Document.new(xml)

		doc.elements.each do |ele|
			words = Array.new
			ele.elements.each do |ele_child|
				parsed = XmlSimple.new({'ForceArray' => false, 'KeepRoot' => false}).xml_in("<word>#{ele_child.to_s}</word>")
				if parsed.has_key? 'w'
					if parsed['w'].has_key? 'savlm' #'lemma'
						lemmas = parsed['w']['savlm'].split(' ')
						lemmas.each do |l|
							lparts = l.split(':')
							parsed['w'][lparts[0]] = lparts[1]
							parsed['w'].delete('savlm')
						end
					end
				end
				verse['words'].push(parsed)
			end
			@verses.push(verse)
		end
	end

	@verses.each do |verse|
		print "<p dir='rtl' id='#{verse['id']}'>#{verse['versenum']} "

		verse['words'].each do |word|
			if word.has_key? 'w'
				if word['w'].has_key? 'seg'
					if word['w']['seg'].class == Array
						word['w']['seg'].each do |s|
							print "<a href='StrongsHebrew.html##{word['w']['strong']}'> #{s['content'].reverse} </a>"
						end
					elsif word['w']['seg'].class == Hash
						print "<a href='StrongsHebrew.html##{word['w']['strong']}'> #{word['w']['seg']['content'].reverse} </a>"
					end
				end
			end
		end
		puts "</p>"
	end

	close = <<-DOC
</div>
</body>
</html>
	DOC

	puts close

end
