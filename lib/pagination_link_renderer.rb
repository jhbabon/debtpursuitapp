class PaginationLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer

  protected

  def page_number(page)
    if page == current_page
      tag(:span, page, :class => "current")
    else
      tag(:span, link(page, page, :rel => rel_value(page)))
    end
  end

  def previous_or_next_page(page, text, classname)
    if page
      tag(:span, link(text, page), :class => classname)
    else
      tag(:span, text, :class => classname + ' disabled')
    end
  end

  def html_container(html)
    tag(:nav, html, container_attributes)
  end
end
