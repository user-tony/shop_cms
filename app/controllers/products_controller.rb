#encoding: UTF-8
class ProductsController < BaseController


  #产品显示页
  def show
    #获得栏目模型信息
    render_404 and return unless product = Product.find_by_id(params[:id])
    render_404("该栏目不存在。") and return unless channel = product.product_category.channel
    template_id = channel.template_id_detail
    liquid_render template_id, :liquid => {
      "product" => product,
      "channel" => channel
        
    }
   
  end

  #产品例表页
  def list
    render_404("该栏目不存在。") and return unless channel = Channel.find_by_id(params[:channel_id])
    if params[:category_id].present?
      product_categories = []
      category = ProductCategory.find_by_id(params[:category_id])
      product_categories  <<  category.id
    else
      product_categories = channel.product_categories.inject([]){ |array, category| array << category.id;array}
    end
    products = Product.ct_desc.where(:product_category_id => product_categories)
    products = products.page(params[:page]).per(10)
    template_id = channel.template_id_list
    liquid_render template_id, :liquid => {
      "product_category" => category,
      "channel" => channel,
      "list" => products
    }
  end
  

 

end
