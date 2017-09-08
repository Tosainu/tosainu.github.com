module CustomHelpers
  def page_title
    title = ''
    title << current_page.data.title << ' | ' if current_page.data.title
    title << data.site.title
  end

  def page_description
    if is_blog_article?
      strip_tags(current_article.summary).gsub(/\s+/, ' ').strip[0..150]
    else
      data.site.description
    end
  end

  def page_image
    if is_blog_article?
      if img = Nokogiri::HTML.parse(current_article.body).at_css('img')
        img['src']
      else
        data.author.avatar
      end
    else
      data.author.avatar
    end
  end

  def page_year
    if current_article.present?
      current_article.date.year
    elsif page_metadata['year']
      page_metadata['year']
    end
  end

  def page_metadata
    current_resource.metadata[:locals]
  end

  def formatted_year
    Date.new(page_metadata['year']).strftime('%Y')
  end

  def formatted_year_month
    Date.new(page_metadata['year'],
             page_metadata['month']).strftime('%Y/%m')
  end

  def formatted_year_month_day
    Date.new(page_metadata['year'],
             page_metadata['month'],
             page_metadata['day']).strftime('%Y/%m/%d')
  end
end
