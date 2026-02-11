# 规格文档

## ADDED Requirements

### Requirement: 1-bit 后处理渲染
系统 SHALL 实现全屏后处理 Shader，输出纯黑白图像。

#### Scenario: 渲染场景
- **WHEN** 游戏运行时
- **THEN** 场景显示为 1-bit 黑白风格
- **AND** 物体边缘清晰可见
- **AND** 阴影使用 Bayer 抖动表现

### Requirement: 场景旋转控制
系统 SHALL 支持用户通过鼠标拖动旋转场景。

#### Scenario: 鼠标拖动旋转
- **WHEN** 用户按住鼠标左键拖动
- **THEN** 场景水平旋转
- **AND** 旋转角度实时更新

#### Scenario: 重置视角
- **WHEN** 用户按下 R 键
- **THEN** 场景旋转角度重置为初始值

### Requirement: 物品收集
系统 SHALL 允许用户点击收集隐藏物品。

#### Scenario: 发现物品
- **WHEN** 用户在场景中点击物品
- **THEN** 物品被标记为已收集
- **AND** 更新物品清单 UI

#### Scenario: 完成关卡
- **WHEN** 用户收集所有物品
- **THEN** 显示关卡完成提示
- **AND** 解锁下一关

### Requirement: UI 显示
系统 SHALL 显示物品清单和进度。

#### Scenario: 显示清单
- **WHEN** 游戏进行中
- **THEN** 屏幕顶部显示待找物品清单
- **AND** 显示当前进度 X/3
