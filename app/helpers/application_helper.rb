module ApplicationHelper
  # link:
  # http://rpheath.com/posts/304-tabbed-navigation-in-rails-refactored
  def navigation(*links)
    buttons = ''
    first = links.first
    last = links.last
    links.each do |link|
      link_css = link == @current_tab ? "selected" : ""
      button_css = link == first ? "first" : (link == last ? "last" : "")
      buttons << content_tag(:span,
                             link_to(link.to_s.humanize,
                                     send("#{link.to_s}_path"),
                                     :class => link_css),
                             :class => %W(button #{button_css}))
    end

    content_tag(:nav, raw(buttons), :class => %w(nav buttons))
  end

  def form_errors_expander(errors)
    unless errors.blank?
      head = content_tag(:h2, "#{pluralize(errors.count, "error")} prohibited this form from being saved:")
      body = content_tag(:ul, raw(errors.map { |e| content_tag(:li, "#{e}")}.join))
      head + body
    end
  end
end
