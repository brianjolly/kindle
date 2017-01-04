# encoding: UTF-8

require 'rexml/document'
require 'xmlsimple'
require 'json'

#num = 7225

head = <<-DOC
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Footnotes - Getting started with your Kindle</title>
<link rel="stylesheet" href="KUG.css" type="text/css" />
</head>
<body>
<div>
DOC

puts head

(0..8674).each do |num|
	entry = `diatheke -b StrongsHebrew -f internal -e UTF8 -k #{num}`

	strong_num = /(\d+)/.match(entry.lines.first)
	print "<p id='#{strong_num}'>"
	entry.each_line do |line|
		res = line.gsub(/(\d+)/) do |s|
			s = "<a href='footnotes.html##{s}'>#{s}</a>"
		end
		print res
	end
	puts '</p>'
end

close = <<-DOC
</div>
</body>
</html>
DOC

puts close
