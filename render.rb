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
      next if child.start_with?(".")
      full_path = File.join(path, child)
      if File.directory?(full_path)
        write_index_page(full_path)
        walk(full_path)
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
        .markdown(contents, :standalone)
        .to_html(
          :no_wrap,
          :mathjax,
          css: "/style.css"
        )
    )
  end

  def write_index_page(path)
    puts "TODO write index page for #{path}"
  end

  def convert
    walk(".")
  end
end

Converter.new.convert
