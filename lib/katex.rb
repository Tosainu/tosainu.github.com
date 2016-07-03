require 'execjs'

class KaTeX
  def initialize
    @katex = ExecJS.compile(File.read('source/assets/katex/katex.min.js'))
  end

  def render_to_string(string, options = {})
    @katex.call 'katex.renderToString', string, options
  end
end
