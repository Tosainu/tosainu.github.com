require 'rack-plastic'

class ExternalLinkAttributes < Rack::Plastic
  def initialize(app, options = {})
    super app, options
  end

  def change_nokogiri_doc(doc)
    doc.css('a').each do |a|
      href = a.get_attribute('href')

      next unless href =~ /^http/i
      next if URI(href).host =~ /#{@options[:host]}/

      next unless a['target'].blank?
      next unless a.get_attribute('rel').blank?

      a['target'] = '_blank'
      a.set_attribute('rel', 'nofollow noopener')
    end

    doc
  end
end
