# THE FORGOTTEN
## 游戏设计文档 (GDD)
**赛事:** Mini Jam 204: Café  
**主题:** 咖啡馆  
**开发周期:** 72 小时  
**引擎:** Godot 4.6  
**美术风格:** 1-bit 像素风等距 3D

---

## 1. 电梯演讲

一款极简风的寻物解谜游戏，场景设定在咖啡馆中。玩家通过旋转 1-bit 等距视角的场景，在桌椅和顾客之间寻找失落的物品。不同的角度会揭示不同的秘密。

**核心钩子:** *所见取决于所立之处。*

---

## 2. 核心循环

```
查看物品清单 → 旋转场景 → 发现隐藏物品 → 点击收集 → 下一关
```

1. 每关显示 3-5 个待找物品（列在屏幕顶部）
2. 玩家自由旋转咖啡馆场景（鼠标拖动）
3. 物品可能藏在家具后面或与背景融为一体
4. 点击收集找到的物品
5. 找齐所有物品解锁下一关

---

## 3. 美术风格

### 3.1 美术方向
- **1-bit 黑白:** 纯黑纯白，无灰色
- **等距 3D:** 45° 视角，正交相机
- **抖动图案:** 使用棋盘格图案表现深度和阴影
- **像素完美:** 锐利边缘，复古 Macintosh 美学

### 3.2 视觉参考
- Obra Dinn（1-bit 抖动效果）
- Papers, Please（UI 风格）
- 经典等距像素艺术

### 3.3 场景元素
| 物体 | 风格 |
|------|------|
| 桌子/椅子 | 简单立方体，黑色描边 |
| 顾客 | 方块人物，极简细节 |
| 物品 | 独特剪影，稍小的比例 |
| 地板 | 平铺图案，交替抖动 |
| 墙壁 | 纯黑或纯白 |

---

## 4. 美术资源

### 4.1 资源包清单

| 资源包 | 来源 | 模型数 | 用途 |
|--------|------|--------|------|
| **Restaurant Bits** | KayKit ( itch.io ) | 144 | 桌椅、吧台、厨房设备、食物 |
| **Prototype Bits** | KayKit ( itch.io ) | 72 | 基础几何体、箱子、门 |
| **Mini Characters** | Kenney | 12 | 顾客角色 |

### 4.2 KayKit : Restaurant Bits
**路径:** `D:/GameAssets/KayKit/extracted/restaurant-bits/KayKit_Restaurant_Bits_1.0_FREE/Assets/gltf/`

**核心资源:**

| 类型 | 模型名称 | 用途 |
|------|---------|------|
| **桌椅** | `chair_A`, `chair_B`, `chair_stool` | 顾客座位 |
| **吧台** | `counter`, `counter_corner`, `counter_sink` | 咖啡吧台 |
| **厨房设备** | `oven`, `fridge`, `stove`, `sink` | 厨房区域 |
| **餐具** | `plate`, `bowl`, `cup`, `mug`, `glass` | 桌面装饰 |
| **食物** | `burger`, `pizza`, `donut`, `coffee`, `soda` | 餐点道具 |
| **装饰** | `plant`, `lamp`, `picture_frame` | 环境装饰 |
| **容器** | `crate`, `crate_buns`, `crate_cheese` | 储物/隐藏物品 |

### 4.3 KayKit : Prototype Bits
**路径:** `D:/GameAssets/KayKit/extracted/prototype-bits/KayKit_Prototype_Bits_1.1_FREE/Assets/gltf/`

**核心资源:**

| 类型 | 模型名称 | 用途 |
|------|---------|------|
| **基础体** | `Cube_Prototype_Large_A/B`, `Cube_Prototype_Small` | 拼搭补充 |
| **容器** | `Box_A/B/C`, `Barrel_A/B/C` | 储物箱/桶 |
| **门** | `Door_A`, `Door_B` | 门框装饰 |
| **平台** | `Platform_*` | 地面层级 |
| **梯子** | `Ladder` | 装饰元素 |
| **硬币** | `Coin_A/B/C` | 可改为小物件 |

### 4.4 Kenney : Mini Characters
**路径:** `D:/GameAssets/Kenney/extracted/3D/mini-characters/Models/GLB format/`

**核心资源:**

| 模型 | 用途 |
|------|------|
| `character-male-a` ~ `f` | 男性顾客 (6种) |
| `character-female-a` ~ `f` | 女性顾客 (6种) |
| `aid-glasses` | 👓 眼镜物品 |

### 4.5 隐藏物品 (DIY 低模)

| 物品 | 制作方法 |
|------|---------|
| 🔑 **钥匙** | Prototype `Cube_Prototype_Small` × 2 十字交叉 |
| 📱 **手机** | Prototype `Box_A` 压扁 (scale 0.1, 0.02, 0.2) |
| 🎧 **耳机** | 两个小球体 + 弧形细条 (Godot 内组合) |
| 📖 **书籍** | Prototype `Box_B` + `Box_C` 堆叠 |
| 💼 **包包** | Restaurant `crate` 或 Prototype `Box_A` |
| 👓 **眼镜** | Kenney `aid-glasses` ✅ |

---

## 5. 游戏机制

### 5.1 旋转
- **鼠标拖动** 水平旋转场景
- **平滑旋转**（非离散步进）
- 完整 360° 视角
- 靠近 90° 倍数时自动吸附（可选优化）

### 5.2 隐藏物品
**物品类型:**
- 🔑 钥匙
- 📱 手机
- 📖 书籍
- 🎧 耳机
- 👓 眼镜
- 💼 包包

**隐藏机制:**
| 机制 | 说明 |
|------|------|
| 遮挡 | 物品在特定角度被桌椅遮挡 |
| 伪装 | 黑色物品放在黑色表面，白色放在白色表面 |
| 尺寸 | 小物品藏在角落 |
| 反射 | 物品只在特定角度可见 |

### 5.3 难度递进
| 关卡 | 咖啡馆状态 | 物品数 | 挑战 |
|------|-----------|--------|------|
| 1 | 空旷，早晨 | 3 | 教学，明显位置 |
| 2 | 少量顾客 | 4 | 基础遮挡 |
| 3 | 午餐高峰 | 5 | 移动顾客，伪装 |
| 4 | 打烊凌乱 | 5 | 杂乱，相似物品 |
| 5 | 夜间模式 | 5 | 有限视野（聚光灯） |

### 5.4 移动顾客（第3关起）
- 顾客沿预定路径行走
- 可能暂时遮挡物品视线
- 为观察增加时机元素

---

## 6. 操作控制

| 输入 | 动作 |
|------|------|
| 鼠标拖动 | 旋转场景 |
| 左键点击 | 选择/收集物品 |
| 滚轮 | 放大/缩小（可选） |
| R | 重置旋转 |
| H | 提示（高亮区域） |

---

## 7. UI 设计

### 7.1 HUD 元素
```
┌─────────────────────────────────┐
│  寻找: 🔑 📱 📖 🎧 👓      3/5   │  ← 物品清单
├─────────────────────────────────┤
│                                 │
│      [ 旋转中的场景 ]            │  ← 主视口
│                                 │
├─────────────────────────────────┤
│  第 1 关    时间: 02:34         │  ← 进度
└─────────────────────────────────┘
```

### 7.2 视觉语言
- **字体:** 像素/位图字体（等宽）
- **边框:** 2px 黑色描边
- **图标:** 简单 1-bit 剪影
- **反馈:** 成功找到时闪烁白色

---

## 8. 技术规格

### 8.1 Godot 设置
- **渲染器:** 兼容模式（像素完美）
- **相机:** 正交，等距角度
- **场景:** 3D 无光照材质（仅用黑白）

### 8.2 材质设置
```
所有模型统一材质:
├── Black_Material (反照率: #000000)
└── White_Material (反照率: #FFFFFF)

KayKit 资源处理:
- 移除原始贴图
- 应用纯色材质
- 保持低多边形优势
```

### 8.3 旋转实现
```gdscript
# 伪代码
func _input(event):
    if event is InputEventMouseMotion and dragging:
        rotation.y += event.relative.x * sensitivity
```

---

## 9. 关卡设计

### 9.1 布局模板
```
    [窗户]
[吧台]         [桌2]
               [桌3]
    [桌1]      [桌4]
          [门]
```

### 9.2 资源使用示例
**第 1 关 - 空旷早晨:**
- 桌椅: `chair_A` + `counter` 组合
- 装饰: `plant` × 2, `lamp` × 1
- 物品: 钥匙(桌上)、手机(吧台后)

**第 2 关 - 少量顾客:**
- 添加: `character-male-a`, `character-female-b`
- 添加: `crate` 作为隐藏点

**第 3 关 - 午餐高峰:**
- 添加: `burger`, `pizza`, `coffee` 餐点装饰
- 顾客移动路径

### 9.3 物品放置规则
- 至少一个物品需要旋转才能看到
- 没有完全被隐藏的物品（总有某个角度可见）
- 物品绝不会在顾客体内
- 平衡：每关 2 个简单、2 个中等、1 个困难

---

## 10. 音效（可选）

| 音效 | 触发事件 |
|------|---------|
| 点击声 | 找到物品 |
| 呼呼声 | 旋转开始/停止 |
| 清脆音 | 关卡完成 |
| 环境音 | 咖啡馆背景噪音 |

---

## 11. 72 小时开发范围

### 必须有（第 1-2 天）
- [ ] 基础 3D 场景 + 旋转
- [ ] 导入 KayKit 资源并应用黑白材质
- [ ] 3 个关卡
- [ ] 5 种隐藏物品
- [ ] 点击收集机制
- [ ] 胜利条件

### 锦上添花（第 3 天）
- [ ] 移动顾客
- [ ] 更多关卡（共 5 个）
- [ ] 音效
- [ ] 找到时的粒子特效
- [ ] 计时/计分

### 时间不够就砍掉
- 夜间模式聚光灯
- 缩放功能
- 提示系统
- 存档/读档

---

## 12. 风险规避

| 风险 | 规避措施 |
|------|---------|
| 3D 太复杂 | KayKit 低多边形资源 |
| 旋转手感差 | 尽早测试，调整灵敏度 |
| 物品太难找 | 悬停时添加剪影高亮 |
| 性能问题 | 低多边形，简单着色器 |

---

## 13. 项目结构

```
the-forgotten/
├── scenes/
│   ├── main.tscn
│   ├── cafe_level_1.tscn
│   ├── cafe_level_2.tscn
│   └── cafe_level_3.tscn
├── scripts/
│   ├── camera_controller.gd
│   ├── item_manager.gd
│   └── game_manager.gd
├── assets/
│   ├── models/
│   │   ├── kaykit_restaurant/     # Restaurant Bits gltf
│   │   ├── kaykit_prototype/      # Prototype Bits gltf
│   │   └── kenney_characters/     # Mini Characters glb
│   ├── materials/
│   │   ├── black_material.tres
│   │   └── white_material.tres
│   └── fonts/
└── export_presets.cfg
```

---

## 14. 资源参考链接

- **KayKit Restaurant Bits:** https://kaylousberg.itch.io/restaurant-bits
- **KayKit Prototype Bits:** https://kaylousberg.itch.io/prototype-bits
- **Kenney Mini Characters:** (本地资源库)

---

**下一步:** 创建 Godot 项目，导入资源并制作旋转原型。
