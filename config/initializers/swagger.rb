GrapeSwaggerRails.options.tap do |o|
  #项目名称
  o.app_name       = 'GrapeRailsTemplate'
  #调用api
  o.url            = '/api/doc/swagger'
  o.app_url        = ''
  #客户端的校验
  o.api_auth       = 'basic'
  o.api_key_name   = 'Authorization'
  o.api_key_type   = 'header'
  o.hide_url_input = true

  #要打开swagger界面需要打开校验
  o.before_filter do |request|
    unless Rails.env.development?
      authenticate_or_request_with_http_basic do |username, password|
        username == 'tdh' && password == '123'
      end
    end
  end
end
