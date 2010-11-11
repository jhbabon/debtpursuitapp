class CustomFormBuilder < ActionView::Helpers::FormBuilder

  def form_head(text)
    @template.content_tag(:header,
                          @template.content_tag(:h2, text),
                          :class => "form_head")
  end

  def form_errors(errors)
    @template.content_tag(:div, errors, :class => "errors") unless errors.blank?
  end

  def instructions(text)
    @template.content_tag(:footer, text, :class => "instructions")
  end

  # link: blogs.inxsasia.com/hemant/2006/12/random_ruby_and.html
  %w(text_field password_field check_box).each do |selector|
    src = <<-END_SRC
    def #{selector}(attribute, options={})
      lb = options[:label].blank? ? label(attribute) : options[:label]
      if !options[:required].blank? && options[:required] == true
        lb = @template.content_tag(:span, '*', :class => 'required') + " " + lb
      end

      options.delete(:label) unless options[:label].blank?
      options.delete(:required) unless options[:required].blank?

      fieldset({ :field_label => lb,
                 :field_input => super })
    end
    END_SRC
    class_eval src, __FILE__, __LINE__
  end

  def submit(value="Save", options={})
    cancel = options[:cancel].blank? ? "" : " or #{options[:cancel]}"
    options.delete(:cancel) unless options[:cancel].blank?
    fieldset({ :field_input => @template.raw("#{super}#{cancel}") }, { :class => "last" })
  end

  private

  def fieldset(fields={ :field_label => "", :field_input => "" }, options={})
    @template.content_tag :fieldset, :class => %W(fieldset #{options[:class]}) do
      @template.content_tag(:div, fields[:field_label], :class => "label") +
      @template.content_tag(:div, fields[:field_input], :class => "input")
    end
  end
end
