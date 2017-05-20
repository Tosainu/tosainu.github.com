activate :automatic_alt_tags
activate :autoprefixer
activate :directory_indexes
activate :sprockets

helpers do
  def page_title
    title = ''
    if current_page.data.title
      title << current_page.data.title << ' | '
    end
    title << 'Tosainu\'s Portfolio'
  end
end

# rack middlewares
require 'lib/external_link_attributes'
use ExternalLinkAttributes, host: 'myon.info'

activate :deploy do |deploy|
  deploy.deploy_method = :git
  deploy.branch = 'master'
  deploy.remote = 'git@github.com:Tosainu/tosainu.github.com.git'
end

configure :development do
  activate :livereload, no_swf: true

  set :debug_assets, true
  set :slim,
    format:     :html,
    pretty:     true,
    tabsize:    2
end

configure :build do
  activate :minify_css

  set :slim,
    format:     :html,
    pretty:     false
end
