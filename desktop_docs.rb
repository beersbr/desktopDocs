require 'redcarpet'
require 'date'

STYLES = <<-STYLE
<style>
body{
	font-family: verdana, sans-serif;
	font-size: 14px;
}

code{
	white-space: pre;
}
</style>
STYLE

HEADER = lambda {|title| "<!doctype html><html><head>#{STYLES}<title>#{title}</title></head><body><div><sub>[<a href=\"javascript:window.history.back();\">Back</a>]</sub></div>" }
FOOTER = "<div><sub>[<a href=\"javascript:window.history.back();\">Back</a>]</sub></div><body></html>"

inputFile = ARGV[0]
outputFile = ARGV[1] 

if not File.exists? inputFile
	throw "Could not find file: #{inputFile}"
end


if outputFile.nil?
	outputname = "#{inputFile}.html"
else
	outputname = outputFile
end


# create the docs directory if it doesnt already exist
Dir.mkdir "docs" if not(Dir.exists? "docs")
Dir.mkdir "markdown" if not (Dir.exists? "markdown")

# delete the current index.html if it exists
File.unlink "./index.html" if (File.exists? "./index.html")

# create the generator
HtmlGen = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true, :forced_code_blocks => true)

File.open("index.html", "w+"){ |html|
	html.puts "<!doctype html>"
	html.puts "<html><head><title>Desktop Docs</title><link rel=Stylesheet href=\"./docstyle.css\" media=screen></head><body>"
	html.puts "<h1> Desktop Docs </h1>"
	html.puts "<sub>Updated at #{DateTime.now.to_s}</sub>"
	html.puts "<div><ul>"

	puts "Generating #{inputFile}"

	File.open("#{outputname}", "w+"){ |fd|
		File.open("#{inputFile}", "r"){ |fr|
			fd.puts HEADER.call(inputFile)
			fdata = ""
			while(line = fr.gets)
				fdata += line
				# fd.puts(HtmlGen.render(line))
			end

			fd.puts(HtmlGen.render(fdata))
		}

		fd.puts FOOTER
	}

	html.puts "</ul></div></body></html>"
}