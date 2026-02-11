## ADDED Requirements

### Requirement: 吧台区域配置
咖啡馆场景 SHALL 包含一个完整的吧台区域。

#### Scenario: 吧台元素完整
- **WHEN** 场景加载完成
- **THEN** 吧台区域 SHALL 包含收银员NPC、咖啡机和收银台

### Requirement: 桌椅布置
咖啡馆场景 SHALL 包含6-8张桌子，混合双人桌和四人桌。

#### Scenario: 桌子数量和类型
- **WHEN** 场景加载完成
- **THEN** 场景 SHALL 包含6-8张桌子
- **AND** 桌子类型 SHALL 包含双人桌和四人桌

### Requirement: 顾客布置
咖啡馆场景 SHALL 包含7-8个顾客NPC坐在不同位置。

#### Scenario: 顾客数量和位置
- **WHEN** 场景加载完成
- **THEN** 场景 SHALL 包含7-8个顾客NPC
- **AND** 顾客 SHALL 分布在不同桌子和位置

### Requirement: 窗户装饰
左侧墙壁 SHALL 包含窗户和百叶窗装饰。

#### Scenario: 窗户元素存在
- **WHEN** 场景加载完成
- **THEN** 左侧墙壁 SHALL 显示窗户
- **AND** 窗户 SHALL 有百叶窗装饰

### Requirement: 待找物品放置
场景 SHALL 包含手机、书籍、钥匙等待找物品，放置在桌上或地面。

#### Scenario: 物品可见性
- **WHEN** 场景加载完成
- **THEN** 场景 SHALL 包含手机、书籍、钥匙
- **AND** 物品 SHALL 放置在桌面上或地面可见位置
