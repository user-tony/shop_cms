/*
    //自动完成组件
    <div class="multilevelSelect">
            <select name="test1"></select>
            <select name="test2"></select>
            <select name="test3"></select>
        </div>
    
    $('.multilevelSelect').wowoj_ui_multilevelSelect({
                data : [
                    {treeNode:'北京',value:1,childNode:[
                        {treeNode:'东城区',value:11,childNode:[]},
                        {treeNode:'西城区',value:12,childNode:[
                            {treeNode:'西城区1',value:121,childNode:[]},
                            {treeNode:'西城区2',value:122,childNode:[]}
                            ]
                        }
                        ]
                    },
                    {treeNode:'吉林',value:2,childNode:[
                        
                        {treeNode:'南关区',value:22,childNode:[
                            {treeNode:'南关区1',value:221,childNode:[]},
                            {treeNode:'南关区2',value:222,childNode:[]}
                            ]
                        },
                        {treeNode:'朝阳区',value:21,childNode:[]}
                        ]
                    }
                ]
            });
    
*/
//自定义选择器 {selects : ['#test4','#test5','#test6'],data:...}

//JSON tree 类
function NodeTree(tree,parent){
    this._tree = tree;
    this._children = [];
    this.parent = parent;
    
    if(tree.childNode && tree.childNode.length > 0){
        for(var i = 0; i < tree.childNode.length; i++){
            this._children[i] = new NodeTree(tree.childNode[i],this);
        }
    }
}

//取得节点属性
NodeTree.prototype.prop = function(prop){
    return this._tree[prop];
};

//取得子节点个数
NodeTree.prototype.size = function(){
    return this._children.length;
};

//是否具有子节点
NodeTree.prototype.hasChild = function(){
    return this.size() > 0 ? true : false;
};

//取得某个子节点
NodeTree.prototype.getNodeAt = function(index){
    return this._children[index];
};

//取得最后一个子节点
NodeTree.prototype.getLastNode = function(index){
    return this.getNodeAt[this.size() - 1];
};

//取得某个id值的子节点
NodeTree.prototype.getNodeByValue = function(value){
    for(var i = 0; i < this._children.length; i++){
        if(this._children[i]._tree.value == value){
            return this._children[i];
        }
    }
    return null;
};

//取得某个深度的子节点
NodeTree.prototype.getDeepNodeByValue = function(args){
    if(!args || arguments.length < 1){
        return this;
    }

    if(args.length == 1){
        return this.getNodeByValue(args[0]);
    }
    
    var cargs = [];
    for(var i = 1; i < args.length; i++){
        cargs[i-1] = args[i];
    }
    return this.getNodeByValue(args[0]).getDeepNodeByValue(cargs);
};


//for custom format
function createNodeTree(treesAry){
    return new NodeTree({childNode : treesAry, value : 'home', treeNode : '根节点'});
}

jQuery.fn.extend({
    wowoj_ui_multilevelSelect: function(o){
        if(!o.selects && this.data('hasInit')){
            return this.data('gridTableObj');
        }
        
        //初始化选项
        var o = jQuery.extend({}, o);
        if(!o.data){ return false; }
        
        var selects;
        if(o.selects){
            selects = $(o.selects.join(','));
        }else{
            selects = $('select',this);
        }

        var trees = createNodeTree(o.data);

        selects.each(function(i,select){
            $(select).change(function(e){
                replaceNextAll(i);
            });
        }); 
        
        function replaceNextAll(i){
            var index = i + 1;
            
            if(index >= selects.length){ return ; }
            
            var values = [];
            for(var i = 0; i < index; i++){
                values.push(selects[i].value);
            }
            
            var strees = trees.getDeepNodeByValue(values);
            replaceItems(selects[index],strees.prop('childNode'));
            replaceNextAll(index);
        }
        
        function replaceItems(select,data){
            while(select.length > 0){
                select.remove(0);
            }
            var option;
            for(var i = 0, len = data.length; i < len; i++){
                option = document.createElement('option');
                option.text = data[i].treeNode;
                option.value = data[i].value;
                select.add(option,null);
            }
        }
        
        function changeIndex(index, value){
            selects[index].value = value;
            replaceNextAll(index);
        }
        
        function initSelects(){
            replaceItems(selects[0],trees.prop('childNode'));
            replaceNextAll(0);
        }
        
        initSelects();
        //api 记录
        this.data('gridTableObj',{
            dom : this,
            blur : function(){},
            selects : selects,
            changeIt : function(select){
                $(select).change();
            },
            change : function(select){    //改变选项
                $(select).change();
            },
            changeIndex : changeIndex,
            unload : function(){
                
            }
        });
        this.data('hasInit', 'true');
        return this.data('gridTableObj');
    }
});