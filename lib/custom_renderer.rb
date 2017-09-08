require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'
require 'lib/katex'

class CustomRenderer < Redcarpet::Render::HTML
  class RougePlugin
    include Rouge::Plugins::Redcarpet
  end

  def initialize(options = {})
    super options
    @katex = KaTeX.new
  end

  def codespan(code)
    if code =~ /^\$(.*)\$$/
      @katex.render_to_string Regexp.last_match(1)
    else
      "<code>#{CGI.escapeHTML(code)}</code>"
    end
  end

  def block_code(code, language)
    if language == 'katex'
      @katex.render_to_string code, displayMode: true
    else
      RougePlugin.new.block_code(code, language)
    end
  end
end
