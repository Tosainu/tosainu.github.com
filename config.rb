Time.zone = 'Tokyo'

activate :blog do |blog|
  blog.prefix = "blog"

  blog.permalink = "{year}-{month}-{day}/{title}.html"
  blog.sources = "articles/{year}/{month}/{day}-{title}.html"
  blog.default_extension = ".md"

  blog.layout = "post"
  blog.calendar_template = "blog/calendar.html"
  blog.generate_day_pages = false
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
activate :sprockets

# markdown
require 'lib/custom_renderer'

set :markdown_engine, :redcarpet
set :markdown, {
  :renderer => CustomRenderer,
  :fenced_code_blocks => true,
  :footnotes => true,
  :strikethrough => true,
  :tables => true
}

# slim
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
  deploy.deploy_method = :git
  deploy.branch = 'gh-pages'

  if ENV['GH_TOKEN'] then
    deploy.remote = "https://#{ENV['GH_TOKEN']}@github.com/Tosainu/blog.git"
  end
end

configure :development do
  activate :livereload

  Slim::Engine.options[:pretty] = true
end

configure :build do
  activate :minify_css
  activate :minify_javascript

  Slim::Engine.options[:pretty] = false
end
