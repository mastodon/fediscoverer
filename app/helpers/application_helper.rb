module ApplicationHelper
  include FaspBase::ApplicationHelper

  TRENDS_TABS = {
    content: :content_trends_path,
    hashtags: :hashtag_trends_path,
    links: :link_trends_path
  }.freeze
end
