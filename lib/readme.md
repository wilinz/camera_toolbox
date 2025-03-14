```shell
lib/
│── main.dart
│── core/             # 全局核心部分
│   ├── bindings/     # 依赖注入（GetX）
│   ├── theme.dart
│   ├── constants.dart
│── data/             # 数据层
│   ├── models/
│   ├── repositories/
│   ├── services/
│── modules/          # 业务模块
│   ├── auth/
│   │   ├── auth_page.dart
│   │   ├── auth_controller.dart  # GetX 控制器
│   │   ├── auth_service.dart
│   ├── home/
│   │   ├── home_page.dart
│   │   ├── home_controller.dart
│── widgets/          # 可复用组件
│── routes/           # 路由管理
│── utils/            # 工具类
│── app.dart          # 应用入口
```