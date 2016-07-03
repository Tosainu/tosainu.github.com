require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'
require 'lib/katex'

class CustomRenderer < Redcarpet::Render::HTML
  class RougePlugin
    include Rouge::Plugins::Redcarpet
  end

  def initialize(options={})
    @katex = KaTeX.new
    super options
  end

  def codespan(code)
    if code =~ /^\$(.*)\$$/
      @katex.render_to_string $1
    else
      "<code>#{code}</code>"
    end
  end

  def block_code(code, language)
    if code =~ /^\$\$(.*)\$\$$/m
      @katex.render_to_string $1, displayMode: true
    else
      RougePlugin.new.block_code(code, language)
    end
  end
end
