class FancyFormBuilder < ActionView::Helpers::FormBuilder
  def form_error(msg = nil)
    msg ||=  "#{@template.pluralize(self.object.errors.count, "error")} prohibited this form from being saved" unless self.object.errors.empty?
    unless msg.blank?
      @template.content_tag :div, :class  => "alert" do
        msg
      end
    end
  end

  # TODO: refactor
  %w(text_area text_field password_field).each do |selector|
    src = <<-end_src
    def #{selector}(method, options = {})
      lb = fancy_label(method, :overlay  => true, :label => options[:label])

      tooltip = fancy_tooltip(method, options)

      options[:class] = %w(input overlay)
      options[:class] << %w(error) unless self.object.errors[method].blank?
      options['data-id'] = method.to_s
      data_class = %w(input)
      data_class << options['data-class'] if options['data-class']
      options['data-class'] = data_class.join(" ")
      data_effect = %w(overlay hintable)
      data_effect << options['data-effect'] if options['data-effect']
      options['data-effect'] = data_effect.join(" ")

      fancy_fieldset(lb + super + tooltip)
    end
    end_src
    class_eval src, __FILE__, __LINE__
  end

  def check_box(method, options = {})
    lb = fancy_label(method, :label => options[:label])

    tooltip = fancy_tooltip(method, options)

    options[:class] = %w(input)
    options[:class] << %w(error) unless self.object.errors[method].blank?
    options['data-id'] = method.to_s
    data_class = %w(input)
    data_class << options['data-class'] if options['data-class']
    options['data-class'] = data_class.join(" ")
    data_effect = %w(hintable)
    data_effect << options['data-effect'] if options['data-effect']
    options['data-effect'] = data_effect.join(" ")

    fancy_fieldset(super + lb + tooltip)
  end

  def select(method, choices, options = {}, html_options = {})
    lb = fancy_label(method, :label => options[:label])

    tooltip = fancy_tooltip(method, options)

    html_options[:class] = %w(error) unless self.object.errors[method].blank?
    html_options['data-id'] = method.to_s
    data_class = %w(input)
    data_class << options['data-class'] if options['data-class']
    html_options['data-class'] = data_class.join(" ")
    data_effect = %w(hintable)
    data_effect << options['data-effect'] if options['data-effect']
    html_options['data-effect'] = data_effect.join(" ")

    fancy_fieldset(lb + @template.raw("<br />") + super + tooltip)
  end

  def radio_button(method, tag_value, options = {})
    if tag_value.is_a?(Array)
      values = tag_value
    else
      values = [tag_value]
    end

    buttons = values.map { |value|
      tag_value = value;
      lb = fancy_label("#{method.to_s}_#{tag_value}",
                       :label => tag_value.humanize);
      button = super + lb
    }.join
    wrapper = @template.content_tag(:div,
                                    @template.raw(buttons),
                                    'data-id' => method.to_s,
                                    'data-effect' => 'hintable',
                                    :class => "radio_buttons")

    tooltip = fancy_tooltip(method, options)
    fancy_fieldset(fancy_label(method, :label => options[:label]) +
                   @template.raw("<br />") +
                   wrapper +
                   tooltip)
  end

  def submit(value = "Save", options = {})
    cancel = options[:cancel].blank? ? "" : " or #{options[:cancel]}"
    options.delete(:cancel) unless options[:cancel].blank?
    options[:class] = %w(button main large)
    fancy_fieldset("#{super}#{cancel}")
  end

  protected

  def fancy_label(attribute, options = {})
    css = %w(label)
    css << %w(overlay) if options[:overlay]
    css << options[:class]

    data_ref = options.has_key?('data-ref') ? options['data-ref'] : attribute.to_s
    data_class = "label"
    data_effect = "overlay" if options[:overlay]

    label(attribute,
          options[:label],
          :class  => css,
          'data-ref'  => data_ref,
          'data-class'  => data_class,
          'data-effect'  => data_effect)
  end

  def fancy_tooltip(attribute, options = {})
    unless options[:tooltip] ==  false
      hint = options[:hint]
      if self.object.errors[attribute].blank?
        if self.object.class.validators_on(attribute).map(&:class).include? ActiveModel::Validations::PresenceValidator
          hint = hint.blank? ? "Required" : @template.raw("#{hint}<hr />Required")
        end
        hint.blank? ? "" : @template.content_tag(:div, hint, :class  => "tooltip", "data-ref"  => attribute.to_s, "data-class" => "tooltip")
      else
        @template.content_tag :div, :class  => %w(tooltip error), "data-ref"  => attribute.to_s, "data-class" => "tooltip" do
          @template.raw(self.object.errors[attribute].map{ |e|  e.humanize }.join("<hr />"))
        end
      end
    else
      ""
    end
  end

  def fancy_fieldset(str = "")
    @template.content_tag(:fieldset, @template.raw(str), :class  => "fieldset") unless str.blank?
  end
end
