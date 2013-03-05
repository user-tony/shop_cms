#encoding: UTF-8
class My::BaseController < BaseController
  # 验证用户是否登陆
  #
  # 作者：佟立家
  # 更新时间：2012-6-29 14:43:09
  before_filter :authenticate_member!
end
