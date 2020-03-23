module ApplicationHelper
  def make_link options={}
    link = options[:value].first
    link_to link, link
  end
end
