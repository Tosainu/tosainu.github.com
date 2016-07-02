module CustomHelpers
  def page_title
    title = ""
    if current_page.data.title
      title << current_page.data.title
      if yield_content(:title)
        title << ' ' << yield_content(:title)
      end
      title << ' | '
    end
    title << data.site.title
  end
end
