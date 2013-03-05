#encoding: UTF-8

#  rake db:seed                           初始化数据
#  rake db:seed delete_all                删除初始化数据
##
 
if ARGV[1].present? &&  ARGV[1] == "delete_all"
  Product.delete_all!
  ShopProduct.delete_all!
  ProductContent.delete_all!
  #清空产品分类
  ProductCategory.where("id != 1").delete_all!
  #清空商品分类
  ShopCategory.where("id != 1").delete_all!
  p "All data cleanup is completed..."
  raise "Congratulations on your"
else
  Article.transaction do
    #添加父级产品分类
    book = ProductCategory.create(:name => "图书",
      :path_customize => "books",
      :parent_node => true,
      :parent_id => 1
    )
    p "1"
    #添加父级的子分类
    animation = ProductCategory.create(:name => "动漫",
      :path_customize => "animation",
      :parent_node => false,
      :parent_id => book.id
    )

    p "3"
    product = Product.create(:name => "龙珠（套装共42册", :product_category_id => animation.id)

    ProductContent.create(:item_id => product.id, :item_type => Product.to_s, :content => " ")


    p "4"
    shop_book = ShopCategory.create(:name => "图书",
      :path_customize => "books",
      :parent_node => true,
      :parent_id => 1
    )

    p "5"
    ShopCategory.create(:name => "家用电器",
      :path_customize => "home",
      :parent_node => true,
      :parent_id => 1
    )
    ShopCategory.create(:name => "手机数码",
      :path_customize => "mobile",
      :parent_node => true,
      :parent_id => 1
    )

    p "6"
    ShopCategory.create(:name => "手机数码",
      :path_customize => "mobile",
      :parent_node => true,
      :parent_id => 1
    )

    #添加父级的子分类
    shop_animation = ShopCategory.create(:name => "动漫",
      :path_customize => "animation",
      :parent_node => false,
      :parent_id => shop_book.id
    )
  
    shop_product = ShopProduct.create(:name => "龙珠（套装共42册)",
      :price => 698,
      :market_price => 1198,
      :product_status => 1,
      :product_id => product.id,
      :description => "传说中，地球四处散落着7颗龙珠。
                       如果谁将他们收集起来就可以实现自己的愿望，
                       人们为了得到它而不断的你争我夺……每年都会有一场以龙珠为奖品的
                      《天下第一武道大会》
                       ……在地球的一个角落，生活着孙悟空这个茁壮的孩子，
                       他的身份其实是赛亚人卡卡罗特。"
    )
    shop_product.shop_product_category_relations.create(:shop_category_id => shop_animation.id)
  
    ProductContent.create(:item_id => shop_product.id,
      :item_type => ShopProduct.to_s,
      :content => "《DRAGON BALL》译名《龙珠》（又名：七龙珠）是日本著名漫画家鸟山明的得意作品，1984年登场，1992年又推出《龙珠》续集。这部长篇巨作在《少年跳跃》上连载7年。
　　根据《龙珠》的漫画故事，还推出了《龙珠》的系列动画片，无论是TV版还是剧场版，
都吸引了无数的龙珠迷，掀起了一股股“龙珠”的热潮。
　　传说中，地球四处散落着7颗龙珠。如果谁将他们收集起来就可以实现自己的愿望，
人们为了得到它而不断的你争我夺……每年都会有一场以龙珠为奖品的《天下第一武道大会》
……在地球的一个角落，生活着孙悟空这个茁壮的孩子，他的身份其实是赛亚人卡卡罗特。
因为婴儿时的变身能力不够而被派往地球，其实是为了毁灭地球生物而变成殖民地，
但他生来和平，
丝毫不知自己的身世……这种战斗力超强的种族“赛亚人”与宇宙中另一些种族
“那美克星人”等等间发生了无数惊险有趣又富有教育意义的故事……这就是日本著名漫画家“鸟山明”
创造的《七龙珠》世界。 ")

    shop_product = ShopProduct.create(:name => "头文字D",
      :price => 1698,
      :market_price => 11198,
      :product_status => 1,
      :product_id => product.id,
      :description => "传说中，地球四处散落着7颗龙珠。
                       如果谁将他们收集起来就可以实现自己的愿望，
                       人们为了得到它而不断的你争我夺……每年都会有一场以龙珠为奖品的
                      《头文字D》
                       ……在地球的一个角落，生活着孙悟空这个茁壮的孩子，
                       他的身份其实是赛亚人卡卡罗特。"
    )
    shop_product.shop_product_category_relations.create(:shop_category_id => shop_animation.id)

    ProductContent.create(:item_id => shop_product.id,
      :item_type => ShopProduct.to_s,
      :content => "《头文字D》译名《头文字D珠》（又名：头文字D）是日本著名漫画家鸟山明的得意作品，1984年登场，1992年又推出《头文字D》续集。这部长篇巨作在《少年跳跃》上连载7年。
　　根据《龙珠》的漫画故事，还推出了《龙珠》的系列动画片，无论是TV版还是剧场版，
都吸引了无数的龙珠迷，掀起了一股股“龙珠”的热潮。
　　传说中，地球四处散落着7颗龙珠。如果谁将他们收集起来就可以实现自己的愿望，
人们为了得到它而不断的你争我夺……每年都会有一场以龙珠为奖品的《天下第一武道大会》
……在地球的一个角落，生活着孙悟空这个茁壮的孩子，他的身份其实是赛亚人卡卡罗特。
因为婴儿时的变身能力不够而被派往地球，其实是为了毁灭地球生物而变成殖民地，
但他生来和平，
丝毫不知自己的身世……这种战斗力超强的种族“赛亚人”与宇宙中另一些种族
“那美克星人”等等间发生了无数惊险有趣又富有教育意义的故事……这就是日本著名漫画家“鸟山明”
创造的《七龙珠》世界。 ")



    shop_product = ShopProduct.create(:name => "死神",
      :price => 698,
      :market_price => 1198,
      :product_status => 1,
      :product_id => product.id,
      :description => "传说中，地球四处散落着7颗龙珠。
                       如果谁将他们收集起来就可以实现自己的愿望，
                       人们为了得到它而不断的你争我夺……每年都会有一场以龙珠为奖品的
                      《死神》
                       ……在地球的一个角落，生活着孙悟空这个茁壮的孩子，
                       他的身份其实是赛亚人卡卡罗特。"
    )
    shop_product.shop_product_category_relations.create(:shop_category_id => shop_animation.id)

    ProductContent.create(:item_id => shop_product.id,
      :item_type => ShopProduct.to_s,
      :content => "《死神》译名《死神》（又名：死神）是日本著名漫画家鸟山明的得意作品，1984年登场，1992年又推出《死神》续集。这部长篇巨作在《死神》上连载7年。
　　根据《龙珠》的漫画故事，还推出了《龙珠》的系列动画片，无论是TV版还是剧场版，
都吸引了无数的龙珠迷，掀起了一股股“龙珠”的热潮。
　　传说中，地球四处散落着7颗龙珠。如果谁将他们收集起来就可以实现自己的愿望，
人们为了得到它而不断的你争我夺……每年都会有一场以龙珠为奖品的《天下第一武道大会》
……在地球的一个角落，生活着孙悟空这个茁壮的孩子，他的身份其实是赛亚人卡卡罗特。
因为婴儿时的变身能力不够而被派往地球，其实是为了毁灭地球生物而变成殖民地，
但他生来和平，
丝毫不知自己的身世……这种战斗力超强的种族“赛亚人”与宇宙中另一些种族
“那美克星人”等等间发生了无数惊险有趣又富有教育意义的故事……这就是日本著名漫画家“鸟山明”
创造的《七龙珠》世界。 ")


  end
end

