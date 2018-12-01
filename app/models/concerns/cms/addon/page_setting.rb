module Cms::Addon
  module PageSetting
    extend ActiveSupport::Concern
    extend SS::Addon

    included do
      field :auto_description, type: String, default: "enabled"
      field :auto_keywords, type: String, default: "enabled"
      field :keywords, type: SS::Extensions::Words
      field :max_name_length, type: Integer, default: 80
      permit_params :auto_keywords, :auto_description
      permit_params :keywords
      permit_params :max_name_length
    end

    def auto_keywords_options
      [
        [I18n.t("ss.options.state.enabled"), "enabled"],
        [I18n.t("ss.options.state.disabled"), "disabled"],
      ]
    end

    def auto_description_options
      [
        [I18n.t("ss.options.state.enabled"), "enabled"],
        [I18n.t("ss.options.state.disabled"), "disabled"],
      ]
    end

    def auto_keywords_enabled?
      auto_keywords == "enabled"
    end

    def auto_description_enabled?
      auto_description == "enabled"
    end

    def max_name_length_options
      [ 80, 0 ].map do |v|
        [ I18n.t("cms.options.max_name_length.#{v}"), v ]
      end
    end
  end
end
