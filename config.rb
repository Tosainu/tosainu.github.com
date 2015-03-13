activate :livereload
activate :directory_indexes
activate :autoprefixer

set :css_dir, 'css'
set :images_dir, 'img'
set :layouts_dir, '_layouts'

set :slim, {
  :format     => :html,
  :pretty     => true,
  :sort_attrs => false,
  :streaming  => false,
  :tabsize    => 2
}

helpers do
  def page_title
    title = ""
    if current_page.data.title
      title << current_page.data.title << ' | '
    end
    title << "Tosainu's Portfolio"
  end
end

configure :development do
  set :debug_assets, true
end

configure :build do
  activate :minify_css
end
