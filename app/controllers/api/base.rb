module API
  class Base < Grape::API
    # 支持挂载
    mount V1::Blogs

    # 、初始化文档
    add_swagger_documentation(
      info: {
        title: 'GrapeRailsTemplate API Documentation',
        contact_email: 'tdh@qq.com'
      },
      mount_path: '/doc/swagger',
      doc_version: '0.1.0'
    )

  end
end
