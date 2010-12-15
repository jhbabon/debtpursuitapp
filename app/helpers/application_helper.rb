module ApplicationHelper
  # link:
  # http://rpheath.com/posts/304-tabbed-navigation-in-rails-refactored
  def navigation(*links)
    buttons = ''
    links.each do |link|
      link_css = link == @current_tab ? "selected" : ""
      buttons << content_tag(:span,
                             link_to(t("app.main_nav.#{link.to_s}"),
                                     send("#{link.to_s}_path"),
                                     :class => link_css),
                             :class => %w(tab))
    end

    content_tag(:nav, raw(buttons), :class => %w(main_nav))
  end

  def subnavigation(*links)
    subnav = content_tag(:dt, "#{t("app.sub_nav.more_options")}:")
    links.each do |link|
      subnav_link = case link
      when Symbol
        link_to(t("app.links.#{link.to_s}"), send("#{link.to_s}_path"))
      when String
        link
      else
        ''
      end
      subnav << content_tag(:dd, raw(subnav_link))
    end

    content_tag :nav do
      content_tag(:dl, raw(subnav), :class => %w(sub_nav))
    end
  end

  def mark_amount(amount)
    css = amount.to_s.include?("-") ? "debt" : "loan"
    content_tag(:span, amount, :class => css)
  end
end
