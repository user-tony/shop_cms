#encoding: UTF-8
class Admin::SkinsController < Admin::BaseController

  
  # 首页
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-4-10
  def index
    @file_list = []
    @dir_list = []
    
    @path = params["path"] if params["path"]
    skin_path = "#{Skin::RAILS_ROOT}#{@path}"
    redirect_skin_index "<#@path>目录不存在."  unless File.exists?(skin_path)
     
    #上级目录地址
    @parent_path = File.dirname(@path) if @path.present?

    Dir["#{skin_path}/*"].each do |f|
      if File.file?(f)
        extname = File.extname(f)
        @file_list << {
          :name => File.basename(f),
          :date => File.ctime(f),
          :size => File.size(f),
          :extname => extname.blank? ? "other" : extname[1..-1]
        }
      end
      if File.directory?(f)
        @dir_list << {
          :name => File.basename(f),
          :date => File.ctime(f),
          :size => Dir["#{f}/*"].size
        }
      end
    end
    
  end

  
  # 上传文件
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-4-10
  def upload_file
    @path = params[:path]
  end

  # 处理上传文件
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-4-10
  def upload
    path = params[:path]
    skin_path = "#{Rails.root}/public/#{path}"
    unless File.exists?(skin_path)
      flash[:error] = "路径错误。"
      redirect_to admin_skins_path and return
    end
    msg = []
    #多文件上传处理
    temp_uplocad = params[:file]
    if temp_uplocad.present?&& temp_uplocad.size>0
      p "*" * 120
      p temp_uplocad
      temp_uplocad.each do |u|
        msg << save_file(u, skin_path)
      end
      flash[:success] = "《#{msg.join("|")}》如果有没上传成功的文件请检查文件名是否重复。"
    else
      flash[:error] = "请选择上传文件。"
    end    
    redirect_to admin_skins_path(:path => path)
  end

  # 编辑文件
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-4-10
  def edit_file
    @path = params[:path]
    @name = params[:name]
    skin_path = "#{Rails.root}/public/#{@path}/#{@name}"
    unless File.exists?(skin_path)
      flash[:notice] = "《#{@name}》 文件不存在。"
      redirect_to admin_skins_path and return
    end
    @extname = File.extname(skin_path)
    File.open(skin_path, "r") do |f|
      @content = f.read
    end
  end

  # 更新文件
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-4-10
  def update_file
    @path = params[:path]
    @name = params[:name]
    skin_path = "#{Rails.root}/public/#{@path}/#{@name}"
    unless File.exists?(skin_path)
      flash[:notice] = "《#{@name}》 文件不存在。"
      redirect_to admin_skins_path and return
    end
    File.open(skin_path, "w") do |f|
      f.write(params[:content])
    end
    flash[:success] = "文件更新成功。"
    redirect_to admin_skins_path(:path => @path)
  end

  # 删除
  #
  # 作者: 朱文博
  # 最后更新时间: 2012-4-10
  def delete
    unless params[:path]||params[:name].present?
      flash[:error] = "文件名或路径错误。"
      redirect_to admin_skins_path and return
    end
    skin_path = "#{Rails.root}/public/#{params[:path]}/#{params[:name]}"
    unless File.exists?(skin_path)
      flash[:notice] = "《#{params[:name]}》 文件不存在。"
      redirect_to admin_skins_path and return
    end
    File.delete(skin_path)
    flash[:success] = "删除操作成功。"
    redirect_to admin_skins_path(:path => params[:path])
  end

  private
  #处理上传文件
  # 作者: 朱文博
  # 最后更新时间: 2012-4-10
   def save_file(file, path)
     if File.exists?("#{path}/#{file.original_filename}")
      return "文件《#{file.original_filename}》重名"
     end
      if !file.original_filename.empty?
        File.open("#{path}/#{file.original_filename}", "wb") do |f|
          f.write(file.read)
        end
        return "#{file.original_filename}上传成功。"
      end
    end

    #跳转到资源管理主页
   # 作者: 佟立家
   # 最后更新时间: 2012-7-16 9:49:55
    def redirect_skin_index(message)
      flash[:notice] =  message
      redirect_to admin_skins_path and return
    end

end