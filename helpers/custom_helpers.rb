module CustomHelpers
  def page_title
    title = ""
    if is_blog_article?
      title << current_article.title << ' | '
    elsif current_page.data.title
      title << current_page.data.title << ' | '
    elsif page_metadata['page_type']
      case page_metadata['page_type']
      when 'tag'
        title << 'Tag: ' << page_metadata['tagname'] << ' | '
      when 'year'
        title << formatted_year << ' | '
      when 'month'
        title << formatted_year_month << ' | '
      when 'day'
        title << formatted_year_month_day << ' | '
      end
    end
    title << data.site.title
  end

  def page_description
    if is_blog_article?
      strip_tags(current_article.body).gsub(/\s+/, ' ').strip[0..150]
    else
      data.site.description
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
             page_metadata['month']).strftime('%B %Y')
  end

  def formatted_year_month_day
    Date.new(page_metadata['year'],
             page_metadata['month'],
             page_metadata['day']).strftime('%e. %B %Y')
  end
end
