require 'redcarpet'
require 'date'

puts "Remember to put all your markdown in a markdown folder, named with camel notation. The ruby script will do the rest"

HEADER = lambda {|title| "<!doctype html><html><head><link rel=Stylesheet href=\"../docstyle.css\" media=screen><title>#{title}</title></head><body><div><sub>[<a href=\"javascript:window.history.back();\">Back</a>]</sub></div>" }
FOOTER = "<div><sub>[<a href=\"javascript:window.history.back();\">Back</a>]</sub></div><body></html>"

outputname = "index.html"

# create the docs directory if it doesnt already exist
Dir.mkdir "docs" if not(Dir.exists? "docs")
Dir.mkdir "markdown" if not (Dir.exists? "markdown")

# delete the current index.html if it exists
File.unlink "./index.html" if (File.exists? "./index.html")

# create the generator
HtmlGen = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)


File.open("index.html", "w+"){ |html|
	html.puts "<!doctype html>"
	html.puts "<html><head><title>Desktop Docs</title><link rel=Stylesheet href=\"./docstyle.css\" media=screen></head><body>"
	html.puts "<h1> Desktop Docs </h1>"
	html.puts "<sub>Updated at #{DateTime.now.to_s}</sub>"
	html.puts "<div><ul>"

	Dir.foreach("./markdown/"){ |link|
		next if not(link =~ /^([a-zA-Z0-9]*)\.md$/)
		filename = $~[1]

		puts "Generating #{filename}"

		html.puts "<li><a href=\"docs\\#{$~[1]}.html\">#{($~[1]).gsub(/([a-z])([A-Z])/, "\\1 \\2")}</a></li>"

		File.open("./docs/#{filename}.html", "w+"){ |fd|
			File.open("./markdown/#{filename}.md", "r"){ |fr|
				fd.puts HEADER.call(filename)
				fdata = ""
				while(line = fr.gets)
					fdata += line
					# fd.puts(HtmlGen.render(line))
				end

				fd.puts(HtmlGen.render(fdata))
			}

			fd.puts FOOTER
		}
	
	}

	html.puts "</ul></div></body></html>"
}