module ApplicationHelper
  def form_errors_expander(errors)
    unless errors.blank?
      head = content_tag(:h2, "#{pluralize(errors.count, "error")} prohibited this form from being saved:")
      body = content_tag(:ul, raw(errors.map { |e| content_tag(:li, "#{e}")}.join))
      head + body
    end
  end
end
