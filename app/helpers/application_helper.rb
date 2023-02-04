module ApplicationHelper
  def page_title(page_title = '')
    base_title = 'FROM COACH'
    page_title.empty? ? base_title : page_title + ' | ' + base_title
  end
end
