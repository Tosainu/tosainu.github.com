require 'lib/custom_renderer'
require 'lib/external_link_attributes'

Time.zone = 'Tokyo'

activate :automatic_alt_tags
activate :autoprefixer
activate :directory_indexes
activate :disqus, shortname: 'tosainu'
activate :sprockets

activate :blog do |blog|
  blog.prefix = 'entry'
  blog.sources = '{year}/{month}/{day}-{title}.html'
  blog.default_extension = '.md'

  blog.layout = 'post'
  blog.permalink = '{year}/{month}/{day}/{title}.html'
  blog.tag_template = 'entry/tag.html'
  blog.calendar_template = 'entry/calendar.html'
  blog.generate_day_pages = false

  blog.summary_length = nil
  blog.summary_separator = /(READMORE)/

  blog.paginate = true
  blog.per_page = 5
  blog.page_link = 'page/{num}'
end

page '/feed.xml', layout: false

# template engines
set :markdown_engine, :redcarpet
set :markdown, renderer:           CustomRenderer,
               fenced_code_blocks: true,
               footnotes:          true,
               strikethrough:      true,
               tables:             true

set :slim, format:     :html,
           pretty:     false

# rack middlewares
use ExternalLinkAttributes, host: 'blog.myon.info'

activate :deploy do |deploy|
  deploy.deploy_method = :git
  deploy.branch = 'gh-pages'
  deploy.remote = 'git@github.com:Tosainu/blog.git'
end

configure :development do
  activate :livereload, no_swf: true
  set :debug_assets, true
end

configure :build do
  activate :asset_hash, ignore: %r{^assets/.*}
  activate :minify_css
  activate :minify_javascript
end
