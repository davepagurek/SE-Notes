#!/usr/bin/env ruby

class Converter
  #require 'redcarpet'
  require 'pandoc-ruby'

  #class DisplayRenderer < Redcarpet::Render::HTML
    #def doc_header
      #<<-HEADER
        #<script type="text/x-mathjax-config">
          #MathJax.Hub.Config({
            #tex2jax: {
              #inlineMath: [ ['$','$'], ["\\(","\\)"] ],
              #displayMath: [ ['$$','$$'], ["\\[","\\]"] ],
              #processEscapes: true
            #},
          #});
        #</script>
        #<script type="text/javascript" src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_HTML"></script>
      #HEADER
    #end

    #def block_code(code, language)
      #"<pre><code lang=\"#{language}\">" + code + "</code></pre>"
    #end
  #end

  #def initialize
    #@renderer = DisplayRenderer.new(with_toc_data: true)
    #@markdown = Redcarpet::Markdown.new(@renderer, fenced_code_blocks: true, disable_indented_code_blocks: true, tables: true)
  #end

  def walk(path)
    Dir.foreach(path) do |child|
      next if child.start_with?("..")
      full_path = File.join(path, child)
      if File.directory?(full_path)
        write_index_page(full_path)
        walk(full_path) unless child.start_with?(".")
      elsif File.extname(full_path) == ".md"
        write_page(full_path)
      end
    end
  end

  def write_page(path)
    output_path = File.join(File.dirname(path), File.basename(path, ".md")) + ".html"
    contents = File.read(path)
    File.write(
      output_path,
      PandocRuby
        .new(contents, :standalone, from: "markdown_github+tex_math_dollars")
        .to_html(
          :no_wrap,
          :mathjax,
          tab_stop: 2,
          css: "/SE-Notes/style.css"
        )
    )
  end

  def write_index_page(path)
    output_path = File.join(path, "index.html")
    File.write(
      output_path,
      <<-HTML
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <meta http-equiv="Content-Style-Type" content="text/css">
  <meta name="generator" content="pandoc">
  <title></title>
  <style type="text/css">code{white-space: pre;}</style>
  <link rel="stylesheet" href="/SE-Notes/style.css" type="text/css">
</head>
<body>
  <h1>#{path}</h1>
  <ul>
  #{
  Dir.entries(path).select{|f| File.directory?(f) && !f.start_with?(".") && f != "vendor"}.map{|f|
    "<li><a href='#{f}'>#{f}</a></li>"
  }.join("\n")
  }
  #{
  Dir.entries(path).select{|f| f.end_with?(".md")}.map{|f|
    "<li><a href='#{File.join(File.dirname(f), File.basename(f, ".md")) + ".html"}'>#{f}</a></li>"
  }.join("\n")
  }
  </ul>
</body>
</html>
HTML
    )
  end

  def convert
    walk(".")
  end
end

Converter.new.convert
