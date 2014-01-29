module ApplicationHelper
  require 'net/http'
  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def awesome(icon, tip = nil)
    icon = "icon-#{icon}"
    if tip
      content_tag(:i, '', class: icon, data_tooltip: '', title: tip)
    else
      content_tag(:i, '', class: icon)
    end
  end

  # https://github.com/slim-template/slim/issues/151#issuecomment-15882033 
  def dom_attrs(record)
    { id: dom_id(record), class: dom_class(record) }
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end

  def get_partner_token
    uri = URI.parse('http://widget.sendshapes.com')
    http = Net::HTTP.new(uri.host, uri.port)
    
    request = Net::HTTP::Get.new("/api_create_partner_token?api_key=ZSBzaG9y-dCB2ZWhl-bWVuY2Ug-b2YgYW55-IGNhcm5h-bCB==")
    response = http.request(request)

    response.code



  end



end
