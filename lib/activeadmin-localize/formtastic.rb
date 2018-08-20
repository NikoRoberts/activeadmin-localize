module Formtastic
  class FormBuilder
    def localized_input(name, args = {})
      t = self.object.send("#{name}_translations")
      field = ActiveAdmin::Localize::Field.new(self.object, name)
      ret = ''
      self.semantic_fields_for "#{name}_translations", field do |lf|
        ::ActiveAdmin::Localize.locales.each do |locale|
          if args[:input_html].blank?
            args[:input_html]=({ :value => (t.nil? || t[locale.to_s].nil?) ? '' : t[locale.to_s] })
          else
            args[:input_html].merge!({ :value => (t.nil? || t[locale.to_s].nil?) ? '' : t[locale.to_s] })
          end
          flag_code = locale.to_s.include?("-") ? locale.to_s.split("-")[1].downcase : locale.to_s

          label = ''
          label += CGI.escapeHTML(self.object.class.human_attribute_name(name))
          label += " "
          # label += template.image_tag("activeadmin-localize/#{flag_code}.svg", alt: locale.to_s, title: locale.to_s, width: 20, height: 15)

          if args[:as] == :ckeditor
            prep = "<h3 style='margin: 10px 0px 0px 10px;'>#{label}</h3>#{'<abbr>*</abbr>' if field.required?}".html_safe
            args[:label] = false
          else
            prep = ''.html_safe
            args[:label] = label.html_safe
          end
          args[:required] = field.required?

          ret << prep + lf.input(locale, args)
        end
      end

      template.concat(ret.html_safe) if template.output_buffer && template.assigns[:has_many_block]
      ret.html_safe
    end
  end
end
