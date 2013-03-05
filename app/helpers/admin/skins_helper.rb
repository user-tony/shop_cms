module Admin::SkinsHelper
  #文件单位换算
  #朱文博
  def file_size(size)
    return size if size < 1
    return "%5.2f KB" % (size.to_f/1024) if size < 1024*1024
    "%5.2f MB" % (size.to_f/(1024*1024)) if (size < 1024*1024*1024)
  end

  #文件类型判断
  #朱文博
  def extname_view(ext)
    if ext == ".js"
      "text/javascript"
    elsif ext == ".css"
      "text/css"
    else
      "text/html"
    end
  end

end
