module Gws::Addon::Share
  module History
    extend ActiveSupport::Concern
    extend SS::Addon

    included do
      after_save :save_history_for_save
      after_destroy :save_history_for_destroy
    end

    def histories
      @histroies ||= Gws::Share::History.where(model: reference_model, item_id: id)
    end

    def skip_gws_history
      @skip_gws_history = true
    end

    private

    def save_history_for_save
      return if @db_changes.blank?

      if @db_changes.key?('_id')
        save_history mode: 'create'
      else
        save_history mode: 'update', updated_fields: @db_changes.keys.reject { |s| s =~ /_hash$/ }
      end
    end

    def save_history_for_destroy
      save_history mode: 'delete' # @flagged_for_destroy
    end

    def save_history(overwrite_params = {})
      return if @skip_gws_history

      site_id = @cur_site.try(:id)
      site_id ||= self.site_id rescue nil
      return unless site_id

      history_file_count = Dir.glob(self.path + "*_history[0-9]*").count
      srcname = "history" + (history_file_count - 1).to_s

      item = Gws::Share::History.new(
        cur_user: @cur_user,
        site_id: site_id,
        name: reference_name,
        model: reference_model,
        uploadfile_name: name,
        uploadfile_filename: filename,
        uploadfile_srcname: srcname,
        uploadfile_size: size,
        uploadfile_content_type: content_type,
        item_id: id
      )
      item.attributes = overwrite_params
      item.save
    end
  end
end
