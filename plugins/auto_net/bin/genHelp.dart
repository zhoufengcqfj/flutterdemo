
var helpText = """
协议定义：
在模块目录中，新建protoJson，使用命令flutter pub run auto_net:gen 将定义的协议生成在lib/gen目录下。
例如:protoJson/getRecordInfo.json,生成lib/gen/Api.g.dart和lib/gen/bean中的bean文件。
仅支持一级子目录。

api定义：
其中，method，url，resp为必填，其他可不填。
{
  "description": "接口描述",
  "method": "get/post/put/delete-必填",
  "url": "请求路径-必填",
  "baseUrl": "请求路径公共路径，此配置优先于公共配置中的BaseUrl配置。-选填",
  "name": "接口的名称，用于生成bean-选填",
  "import": {
    "ImportBean": "package:path/to/ImportBean.dart"
  },
  "headers": {
    "key": "value"
  },
  "request": {
    "i": "[int] int数据",
    "intBox": "[Integer] Integer数据",
    "d": "[double] double数据",
    "doubleBox": "[Double] Double数据",
    "bo": "[boolean] boolean数据",
    "booleanBox": "[Boolean] Boolean数据",
    "bo2": "[bool] boolean数据",
    "booleanBox2": "[Bool] Boolean数据",
    "objectDef1": "[object] object对象",
    "objectDef2": "[Object] object对象",
    "mapDef1": "[map] HashMap对象",
    "mapDef2": "[Map] HashMap对象",
    "genType": "[<T>] 泛型类型T",
    "importBean": "[ImportBean] 泛型类型T",
    "beanReference": "[ExternalInfoBean] 引用bean文件夹下面bean",
    "genTypeReference": "[CommonBean<T>] 支持泛型类型T的引用，CommonBean定义在beans子目录中",
    "dataKey": {
      "dataNext": "[dataKey] 如果类内部有引用自身，可以使用该类的key来指定"
    }
  },
  "response": {
    "resp1": "返回结果定义，返回对象--与下面的定义二选一",
  },
  "response": "response返回String--与上面的定义二选一",
  "urlPathParam": {
    "path1": "路径参数"
  },
  "urlParam": {
    "urlParam1": "url参数"
  }
}

支持bean定义：
在模块目录中，新建beanJson，使用如下模板生成Bean。beanInfo中为生成bean的信息。
{
  "extends": {
    "name": "BaseBean",
    "import": "package:Bean/bean/BaseBean.dart"
  },
  "beanInfo": {
    "XXX": "XXX"
  }
}

使用命令flutter pub run auto_net:genBean 将定义的bean生成在lib中对应的目录下。
例如:beanJson/player/RecordInfo.json,生成lib/player/RecordInfo.g.dart。
仅支持一级子目录。

欢迎大家fork&push!

""";

void main() {
  print(helpText);
}
