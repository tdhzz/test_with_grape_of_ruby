module API
  module V1
    class Blogs < Grape::API
      include Default

      # content_type :json, 'application/json'
      # content_type :xml,'application/xml'
      # content_type :txt,'text/plain'
      # content_type :binary, 'application/octet-stream'

      # default_format :json
      #http协议校验
      # http_basic do |username, password|
      #   username == 'test' and password == 'hello'
      # end

      # 校验
      # before do
      #request:拿到当前请求的对象，header（头部）无论大小写拿到的都是驼峰格式的信息
      #   unless request.headers['X-Api-Secret-Key'] == 'api_secret_key'
      #直接拦截error！
      #     # error! :forbidden, 403
      #     error!({code: 1, message: 'forbidden'}, 403)
      #   end
      # end

      after do
      end

      before_validation do
      end

      after_validation do
      end

      get '/test/filter' do
        raise NoMethodError
      end

      # # 一般放在别的地方
      # helpers do
      #   def buil_response code: 0, data:nil
      #     {code: code,data: data}
      #   end

      #   params :id_validator do |options|
      #     requires :id, type: Integer
      #   end
      # end

      # # 捕获错误
      # rescue_from ActiveRecord::RecordNotFound do |e|
      #   error!({code: 1, error:'not found'}, 404)
      # end

      # rescue_from NoMethodError do |e|
      #   error!({code: 1, error:'system error'}, 422)
      # end

      # rescue_from NoMethodError,Art do |e|
      #   error!({code: 1, error:'system error'}, 422)
      # end

      # rescue_from :all



      # 别名: namespace, resource, group, segment
      resources :blogs do

        before do
        end

        # /blogs/3/comments
        route_param :id do
          resources :comments do
            get do
              build_response(data: "blog #{params[:id]} comments")
            end
          end
        end

        #返回值
        get do
          build_response(data: {blogs: []})
        end

        desc "获得博客详情"
        params do
          # requires :id, type: Integer
          # use :id_validator，a:1
          use :id_validator
        end

        #因为这个id其他元素会被解释为id这个变量，所以要给他用正则限定整数至少一位
        get ':id', requirements: { id: /\d+/ } do
          build_response(data: "id #{params[:id]}")
        end

        #API参数
        #描述
        desc "创建blog"
        params do
          #requires(必须)
          requires :title, type: String, desc: "博客标题"
          #as别名
          requires :content, type: String, desc: "博客内容", as: :body
          #optional(非必须)，allow_blank：如果要传就不允许为空

          # o.api_auth       = 'basic'
          # o.api_key_name   = 'Authorization'
          # o.api_key_type   = 'header'
          optional :tags, type: Array, desc: "博客标签", allow_blank: false
          #symbol符号,默认值为pending，会自动转化为字符类型，加数组限定格式
          optional :state, type: Symbol, default: :pending, desc: "博客状态", values: [:pending, :done]
          #国际化操作，加校验
          optional :meta_name, type: { value: String, message: "meta_name比必须为字符串" },
          #在一处校验要格式匹配 regexp: { value: /^s\-/, message: "不合法" }
            regexp: /^s\-/

          optional :cover, type: File
          #given如果cover提供了，就要执行下面代码
          given :cover do
            requires :weight, type: Integer, values: { value: ->(v) { v >= -1 }, message: "weight必须大于等于-1" }
          end
          #数组
          optional :comments, type: Array do
            requires :content, type: String, allow_blank: false
          end
          #哈希
          optional :category, type: Hash do
            requires :id, type: Integer
          end
        end

        # post do
        #   Blog.create title: params[:title]
        # end

        post do
          build_response(data: params)
        end

        desc "博客修改"
        params do
          use :id_validator
        end

        put ':id' do
          build_response(data: "put #{params[:id]}")
        end

        desc "博客删除"
        params do
          use :id_validator
        end
        delete ':id' do
          build_response(data: "delete #{params[:id]}")
        end

        #3.2(3.1)
        # /blogs/hot
        # /blogs/hot/pop
        # /blogs/hot/pop/3
        get 'hot(/pop(/:id))' do
          build_response(data: "hot #{params[:id]}")
        end

        #返回最近的博客，hidden(是否展示)
        get 'latest', hidden: true do
          #必须为完整路径
          redirect '/api/blogs/latest'
        end

        #返回最欢迎的博客
        get 'popular' do
          #改变状态码 boby(直接覆盖)，content_type (改变类型)，head（改变头部信息）
          status 400
          build_response(data: 'popular')
        end
      end

      # #收集api信息
      # add_swagger_documentation(
      #   info:{
      #     title: 'GrapeRailsTemplate API Documentation',
      #     contact_email:''
      #     },
      #     #添加返回api信息的路由与/config/initializers的配置path相同
      #     mount_path: '/doc/swagger',
      #     doc_version: '0.1.0'
      #   )

      # 路由调试
      # rails c
      # 打印所有路由
      # API:Base.routes
      # 多少个路由
      # API:Base.routes.length
      # API:Base.recognize_path ‘v1、blogs’

      # rails grape：routes
    end
  end
end
