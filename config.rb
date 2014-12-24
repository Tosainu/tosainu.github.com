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

# slim
set :slim, {
  :format => :html,
  :pretty => false,
  :sort_attrs => false,
  :streaming => false,
  :tabsize => 2
}

# syntax highlighting
activate :syntax, {
  :css_class => 'hl',
  :line_numbers => true
}

# directory_index
activate :directory_indexes

# Reload the browser automatically whenever files change
activate :livereload

# Disqus
activate :disqus do |d|
  d.shortname = 'tosainu'
end

# google analytics
activate :google_analytics do |ga|
  ga.tracking_id = 'UA-57978655-1'
end

activate :deploy do |deploy|
  deploy.method = :git
end

# Build-specific configuration
configure :build do
  activate :minify_css
  activate :minify_javascript
end
