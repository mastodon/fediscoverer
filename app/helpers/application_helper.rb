module ApplicationHelper
  TRENDS_TABS = {
    content: :content_trends_path,
    hashtags: :hashtag_trends_path,
    links: :link_trends_path
  }.freeze

  def render_notification(message, type: :notice)
    tag.section(message, class: "alert alert-#{type}")
  end

  def render_tabs(tabs, active:, scope:)
    rendered_tabs = tabs.map do |key, path|
      text = t(key, scope:)
      link_to text, send(path), aria: { selected: (key == active) }
    end
    tag.nav safe_join(rendered_tabs), role: "tablist"
  end
end
