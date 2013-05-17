module ApplicationHelper
  def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(safe_links_only: true, hard_wrap: true, filter_html: true), autolink: true, strikethrough: true)
  end

  def all_user_list
    User.all.map { |v| { id: v.id, name: v.name } }.to_json
  end

  def kudos_prompt
    if Meeting.last.kudos_period_open?(Time.zone.now)
      render 'shared/kudos_prompt'
    end
  end
end
