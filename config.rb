Time.zone = 'Tokyo'

page '/feed.xml', layout: false

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

activate :automatic_alt_tags
activate :autoprefixer
activate :directory_indexes
activate :sprockets

# markdown
require 'lib/custom_renderer'

set :markdown_engine, :redcarpet
set :markdown, {
  renderer:           CustomRenderer,
  fenced_code_blocks: true,
  footnotes:          true,
  strikethrough:      true,
  tables:             true,
}

# rack middlewares
require 'lib/external_link_attributes'
use ExternalLinkAttributes, host: 'blog.myon.info'

activate :disqus do |d|
  d.shortname = 'tosainu'
end

activate :deploy do |deploy|
  deploy.deploy_method = :git
  deploy.branch = 'gh-pages'
  deploy.remote = 'git@github.com:Tosainu/blog.git'
end

configure :development do
  activate :livereload, :no_swf => true

  set :debug_assets, true
  set :slim,
    format:     :html,
    pretty:     true,
    tabsize:    2
end

configure :build do
  activate :asset_hash, :ignore => %r{^assets/.*}
  activate :minify_css
  activate :minify_javascript

  set :slim,
    format:     :html,
    pretty:     false
end
