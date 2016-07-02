require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

class CustomRenderer < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
end
