module LiquidFilters
  
  # 加法运算
  #
  # 作者：李季
  # 更新时间：2012-05-08
  def add(num1, num2)
    num1 + num2
  end
  
  # 减法运算
  #
  # 作者：李季
  # 更新时间：2012-05-08
  def sub(num1, num2)
    num1 - num2
  end
  
  # 乘法运算
  #
  # 作者：李季
  # 更新时间：2012-05-08
  def mul(num1, num2)
    num1.to_i * num2.to_i
  end
  
  # 除法运算
  #
  # 作者：李季
  # 更新时间：2012-05-08
  def div(num1, num2)
    num1 / num2
  end
  
  # 获取物流信息
  #
  # 作者：李季
  # 更新时间：2012-05-08
  def logistics(order_id)
    Logistic.get_logistics(order_id)
  end
  
  # 获取最新的物流信息
  #
  # 作者：李季
  # 更新时间：2012-05-09
  def newest_logistic(order_id)
    result = Logistic.get_logistic(order_id)
    "#{result['time']} #{result['context']}"
  end
  
  # 根据时间对数字进行累加
  #
  # 作者：李季
  # 最后更新时间：2012-05-09
  def time_count(init_num, init_time, time, step)
    Utils::CmsExtend.time_count(init_num, init_time, time, step)
  end
end