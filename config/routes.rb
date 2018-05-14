Rails.application.routes.draw do

  mount API::Base, at: '/api'
  #制定swagger路由挂载到哪个路径
  mount GrapeSwaggerRails::Engine => '/api/doc'

end
