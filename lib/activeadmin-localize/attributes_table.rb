module ActiveAdmin
  module Views
    class LocalizedAttributesTable < ActiveAdmin::Views::AttributesTable
      builder_method :localize_attributes_table_for

      def row(*args, &block)
        _locales = ActiveAdmin::Localize.locales

        title   = args[0]
        options = args.extract_options!
        classes = [:row]
        if options[:class]
          classes << options[:class]
        elsif title.present?
          classes << "row-#{ActiveAdmin::Dependency.rails.parameterize(title.to_s)}"
        end
        options[:class] = classes.join(' ')

        _locales.each_with_index do |locale, index|
          @table << tr do
            if index == 0
              th :rowspan => _locales.length do
                header_content_for(title)
              end
            end
            @collection.each do |record|
              td do
                I18n.with_locale locale do
                  (
                    #image_tag("activeadmin-localize/#{locale.to_s}.svg", alt: locale.to_s, title: locale.to_s, width: 20, height: 15) +
                    #' ' +
                    content_for(record, block || title)
                  ).html_safe
                end
              end
            end
          end
        end
      end

      protected

      def default_id_for_prefix
        'attributes_table'
      end

      def default_class_name
        'attributes_table'
      end

    end
  end
end
