module Job::Cms::CopyNodes::CmsParts
  extend ActiveSupport::Concern
  include Sys::SiteCopy::Cache
  include Job::Cms::CopyNodes::CmsContents

  def copy_cms_part(src_part)
    src_part = src_part.becomes_with_route
    copy_cms_content(:parts, src_part, copy_cms_part_options)
  rescue => e
    @task.log("#{src_part.filename}(#{src_part.id}): パーツのコピーに失敗しました。")
    Rails.logger.error("#{e.class} (#{e.message}):\n  #{e.backtrace.join("\n  ")}")
  end

  def copy_cms_parts
    Cms::Part.site(@cur_site).where(filename: /^#{@cur_node.filename}\//).each do |part|
      copy_cms_part(part)
    end
  end

  def resolve_part_reference(id)
    id
  end

  private

  def copy_cms_part_options
    {
      before: method(:before_copy_cms_part),
      after: method(:after_copy_cms_part)
    }
  end

  def before_copy_cms_part(src_part)
    @task.log("#{src_part.filename}(#{src_part.id}): パーツのコピーを開始します。")
  end

  def after_copy_cms_part(src_part, dest_part)
    @task.log("#{dest_part.filename}(#{dest_part.id}): パーツをコピーしました。")
  end
end
