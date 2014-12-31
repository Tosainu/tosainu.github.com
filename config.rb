Time.zone = 'Tokyo'

activate :blog do |blog|
  blog.prefix = "blog"

  blog.permalink = "{year}-{month}-{day}/{title}.html"
  blog.sources = "articles/{year}/{month}/{day}-{title}.html"
  blog.default_extension = ".md"

  blog.layout = "_layouts/post"
  blog.calendar_template = "blog/calendar.html"
  blog.tag_template = "blog/tag.html"

  # summary
  blog.summary_length = nil
  blog.summary_separator = /(READMORE)/

  # Enable pagination
  blog.paginate = true
  blog.per_page = 3
  blog.page_link = "page/{num}"
end

page "/feed.xml", layout: false

activate :directory_indexes

set :css_dir, 'css'
set :images_dir, 'img'
set :js_dir, 'js'
set :layouts_dir, '_layouts'
set :partials_dir, '_partials'

# markdown
set :markdown_engine, :redcarpet
set :markdown, {
  :fenced_code_blocks => true,
  :footnotes => true,
  :tables => true
}

# syntax highlighting
activate :syntax, {
  :css_class => 'hl',
  :line_numbers => true
}

# slim
Slim::Engine.disable_option_validator!
set :slim, {
  :format => :html,
  :sort_attrs => false,
  :streaming => false,
  :tabsize => 2
}

# Disqus
activate :disqus do |d|
  d.shortname = 'tosainu'
end

activate :deploy do |deploy|
  deploy.method = :git
end

configure :development do
  activate :livereload, :no_swf => true

  Slim::Engine.options[:pretty] = true
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  set :ga_key, 'UA-57978655-1'

  Slim::Engine.options[:pretty] = false
end
