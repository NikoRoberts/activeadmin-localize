module ActiveAdmin
  module Localize
    class Engine < ::Rails::Engine
      #initializer 'ActiveAdmin::Localize precompile hook', group: :all do |app|
      config.after_initialize do
        config.assets.precompile += I18n.available_locales.map do |l|
          # "activeadmin-localize/#{l}.svg"
        end
      end
    end
  end
end
