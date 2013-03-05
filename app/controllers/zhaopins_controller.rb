#encoding: UTF-8
class ZhaopinsController < BaseController


#  def index
#    render_404("该栏目不存在。") and return unless channel = Channel.find_by_id(params[:channel_id])
#    jobs = Zhaopin.ct_desc
#    jobs = jobs.page(params[:page]).per(10)
#    template_id = channel.template_id_list
#    liquid_render template_id, :liquid => {
#      "channel" => channel,
#      "list" => jobs
#    }
#  end
  
  def show
    #获得栏目模型信息
    render_404 and return unless zhaopin = Zhaopin.find_by_id(params[:id])
    render_404("该栏目不存在。") and return unless channel = zhaopin.channel
    template_id = channel.template_id_detail
    liquid_render template_id, :liquid => {
      "channel" => channel,
      "job" => zhaopin
    }


  end
end
