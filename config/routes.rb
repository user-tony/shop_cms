Mangocms::Application.routes.draw do

  require 'resque/server'
  mount Resque::Server.new, :at => "/resque"

  devise_for :members, :controllers => { :registrations => "members/registrations", :sessions => "members/sessions", :passwords => "members/passwords"}
  # 首页
  root :to => "main#index"

  #网站前台
  #---------------------------------------
  # 用户登录
  match 'sign_in', :to => 'main#list', :channel_id => 'sign_in'
  # 用户注册
  match 'sign_up', :to => 'main#list', :channel_id => 'sign_up'
  # 弹窗登陆
  match 'pop_sign', :to => 'main#list', :channel_id => 'pop_sign'
  # 文章列表页
  match ':channel_id', :to => 'articles#list', :channel_id => /articles/
  # 文章显示页
  match ':channel_id/:id', :to => 'articles#show', :channel_id => /articles/, :id => /\d+/
  # 留言页面
  match 'questions/:channel_id', :to => 'questions#index', :channel_id => /[a-z_]+/
  # 留言提交
  match 'questions/:channel_id/answer_create', :to => 'questions#answer_create', :channel_id => /[a-z_]+/
  # 留言顶一下提交
  match 'questions/:channel_id/answer_top', :to => 'questions#answer_top', :channel_id => /[a-z_]+/
  # 产品列表页
  match 'product/:channel_id', :to => 'products#list', :channel_id => /product/
  # 产品内容页
  match 'product/:channel_id/:id', :to => 'products#show', :channel_id => /product/, :category_id => /[a-z_]+/, :id => /\d+/
  # 产品验证
  match 'service_verifies/verify', :to => 'service_verifies#verify'
  # 产品验证提交
  match 'service_verifies/verify_save', :to => 'service_verifies#verify_save'
  # 前台商城路由
  match 'shop', :to => 'shop_products#index', :channel_id => "shop"
  # 商城列表页
  match ':channel_id/:category_id', :to => 'shop_products#index', :channel_id => /shop/, :category_id => /\d+/
  # 商城内容页
  match ':channel_id/show/:id', :to => 'shop_products#show', :channel_id => /shop/, :id => /\d+/
  # 商城ajax评论
  match '/shop_products/ajax_comments/:id', :to => 'shop_products#ajax_comments', :id => /\d+/
  # 商城ajax购买记录
  match '/shop_products/ajax_buy_logs/:id', :to => 'shop_products#ajax_buy_logs', :id => /\d+/
  # 订单信息内容页
  match "/shop/:channel_id/:id", :to => 'shop_products#order_info', :channel_id => /order_manager/, :id => /\d+/
  #商城搜索
  match "/shop/index/search/:search_condition", :to => "shop/index#search"
  #招聘信息
  match 'zhaopin/:id', :to => 'zhaopins#show', :channel_id => /\d+/
  #栏目地址
  match '/page/:channel_id', :to => 'main#list', :channel_id => /[a-z_]+/
  #内容地址
  match '/page/:channel_id/:id', :to => 'main#show', :channel_id => /[a-z_]+/, :id => /\d+/

  #---------------------------------------
  #文章
  resources :articles
  #前台支付接口
  namespace :payment do
    resources :alipay do
      collection do
        get :get_page
        get :return_page
        post :notify_page
      end
    end
    resources :alipay_secured do
      collection do
        get :get_page
        post :notify_page
      end
    end
    resources :chinabank do
      collection do
        get :get_page
        post :return_page
        post :notify_page
      end
    end
  end

  #用户详细信息路由
  resources :member_infos do
    collection do
      get :edit_info
      post :update_info
      get :judge_member
      get :judge_useremail
    end
  end

  namespace :shop do
    resources :index do
      collection do
        get :search
      end
    end
    resources :products
    resources :cart
  end

  #前台问答
  resources :questions do
    collection do
      post :answer_create
      post :answer_top
    end
  end


  resources :shop_products do
    collection do
      get :list
      get :order_address
      post :submit_order
      get :my_cart   #我的购物车
      get :add_product   #添加商品
      post :buy_product   #立即购买
      get :modify_cart_info   #修改购物车信息
      post :add_order_address  #添加订单收货地址
      delete :destroy_product       #删除产品
      delete :clear_cart            #清楚购物车
      post :delete_order_address  #删除订单地址
      post :generate_order        #生成订单
      post :comment_save
      get :get_address_info
      get :ajax_comments          #异步获取评论
      get :ajax_buy_logs          #异步获取购买记录
    end
    member do
      get :order_info
    end
  end

  resources :logistics do
    collection do
      get :request_logistics
    end
  end

  # 富文本框路径
  mount Ckeditor::Engine => '/ckeditor'
  #服务验证
  resources :service_verifies do
    collection do
      get :verify
      post :verify_save
    end
  end

  #用户中心
  namespace :my do
    resources :orders do
      member do
        get :delete
        get :show
        get :payment
        get :payment_save
      end
    end
  end
  #——-----------------------------------------————————下面是后台路由——————--------------------————————————-------------------——-——————————-
  #cms后台
  #后台管理路由
  namespace :admin do
    #后台用户路由
    resources :members do
      collection do
        post :search
      end
    end

    #后台问题路由
    resources :questions

    #后台回答
    resources :answers do
      collection do
        get  :search
        post :reply_answer_create
        post :batch_operation
      end
      member do
        get :channel_index
        get :answer_admin
        get :ajax_replay_answer_delete
        get :ajax_replay_answer_auth #异步单个审核

      end
    end

    #商品管理
    resources :shop_categories do
      collection do
        get :tree_info    #左侧树信息
      end
      member do
        get :new_category
      end
    end

    #-------------------------招聘信息---------------------------------------------
    resources  :zhaopins do
      collection do
        get  :search
      end
      member do
        get :channel_index
      end
    end

    #-------------------------信息管理---------------------------------------------
    #产品分类管理
    resources :product_categories do
      collection do
        get :tree_info
      end
      member do
        get :new_child
      end
    end


    #产品管理
    resources :products do
      collection do
        get :delete_attachment
        post :frame_add_attachment
        post :delete_product_image
        get  :search
      end
      member do
        get :channel_index
        get :frame_form
        post :attachment
        post :content_create
        get :upload
        get :product_content
      end
    end

    #服务验证管理
    resources :service_verifies do
      collection do
        get :import
        post :import_save
        get :export
        post :export_save
      end
      member do
        get :operation
      end
    end

    #序列号分类管理
    resources :service_categories do

    end

    #文章路由
    resources :articles do
      collection do
        get  :search
        post :delete_product_image
        post :frame_add_attachment
        get :delete_article_image
      end
      member do
        put :update_article
        get :channel_index
        get :frame_form
        get :new_article
      end
    end

    #自定义页面路由
    resources :custom_pages do
      member do
        get :channel_index
        get :link_channel
      end
    end

    #-----------------------------------------------------------------------------
    #商品路由
    resources :shop_products do
      collection do
        post :frame_add_attachment
        post :delete_product_image
        get  :search
      end
      member do
        get :frame_form
        post :attachment
        get :upload
      end
    end


    #套餐路由
    resources :shop_packages do
      collection do
        get :frame_add_attachment
      end
      member do
        get :frame_form
      end
    end
    #订单路由
    resources :shop_orders do
      collection do
        get :export_xls
      end
      member do
        get :preview
      end
    end

    #后台管理员路由
    resources :managers do
      collection do
        get :login
        post :check_login
        get :exists_attach
      end
      member do
        get :modify_password
        post :update_password
        get :logout
      end
    end

    #后台全局变量分类路由
    resources :global_variable_categories do
      collection do
        post :sort
      end
    end

    #后台全局变量路由
    resources :global_variables do
      member do
        get :delete_var
        get :new_image
        get :edit_image
        post :create_image
        post :update_image
      end
      collection do
        post :update_all
        get :exists_attach
      end
    end

    #后台友情链接路由
    resources :friendly_websites

    #后台首页
    resources :main
    #模板管理
    resources :templates do
      member do
        get :default_template
        get :list
      end
    end
    #模板资源文件管理
    resources :skins do
      collection do
        get :upload_file
        post :upload
        get :delete
        get :edit_file
        post :update_file
      end
    end

    #栏目管理
    resources :channels do
      member do
        get :new_child
        get :check_destroy
      end
      collection do
        get :exists_attach
        get :tree_info
        get :template_json_info
      end
    end
    #系统模型管理
    resources :info_models

    #评论管理
    resources :comments do
      collection do
        get :batch_act
      end
    end
  end
end