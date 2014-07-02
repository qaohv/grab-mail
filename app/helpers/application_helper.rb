module ApplicationHelper
  def breadcrumbs(*args)
    bc = "<ol class=\"breadcrumb\">"
    args.flatten.each do |argument|
      bc += "<li>#{argument}</li>"
    end
    bc += "</ol>"
    bc.html_safe
  end
end
