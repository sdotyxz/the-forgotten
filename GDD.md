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

### 3.4 1-bit 风格实现详解

#### 核心概念
**1-bit** 意味着画面只使用 **1 位色深** —— 每个像素只有两种可能：
- `0` = 纯黑 (#000000)
- `1` = 纯白 (#FFFFFF)

**没有灰色、没有渐变、没有半透明。**

#### Godot 4.6 实现步骤

**1. 项目设置**
```
项目 → 项目设置 → 渲染 → 纹理:
└── 关闭 Canvas Textures (如果不需要)

渲染 → 环境:
└── 默认环境: 新建环境，背景设为纯色(白或黑)
```

**2. 相机设置 (关键)**
```
Camera3D 节点:
├── Projection: Orthogonal (正交投影)
├── Size: 10-20 (根据场景大小调整)
├── Position: (10, 10, 10) 等距位置
├── Rotation: (-30°, 45°, 0°) 经典等距角度
└── 关闭 Perspective (透视)
```
**等距角度公式:**
- X 旋转: `-30°` (俯视角度)
- Y 旋转: `45°` (侧面角度)
- 组合产生经典 "2.5D" 等距视角

**3. 材质设置 (关键)**

创建两个基础材质资源:

**`black_material.tres`** (黑色物体)
```
StandardMaterial3D:
├── Albedo: #000000 (纯黑)
├── Shading Mode: Unshaded (无光照)
├── Disable Ambient Light: true
└── Disable Receive Shadows: true
```

**`white_material.tres`** (白色物体)
```
StandardMaterial3D:
├── Albedo: #FFFFFF (纯白)
├── Shading Mode: Unshaded (无光照)
├── Disable Ambient Light: true
└── Disable Receive Shadows: true
```

**重要:** 使用 **Unshaded** 模式，完全关闭 Godot 的光照计算，确保颜色就是纯黑白。

#### 光影的表现方法

既然不能用传统光照，如何表现 "光与影"？

**方法 1: 材质本身区分 (推荐)**
```
面向 "光源" 的面 → 白色材质
背向 "光源" 的面 → 黑色材质
```
每个模型手动指定材质，模拟固定光源方向。

**方法 2: 抖动图案 (Dithering)**
用棋盘格图案模拟 "灰度":
```
■□■□■□  50% 灰度效果
□■□■□■
■□■□■□
```

在 Godot 中实现抖动的 3 种方式:

| 方式 | 实现 | 适用场景 |
|------|------|----------|
| **A. 贴图抖动** | 制作黑白棋盘格纹理，应用到材质 | 地板、大面积表面 |
| **B. Shader 抖动** | 后处理 shader，根据深度抖动 | 全局效果，自动 |
| **C. 模型面片** | 交替使用黑白材质的三角形 | 物体表面的阴影 |

**方式 A (贴图抖动) 示例:**
```gdscript
# 创建 2x2 像素纹理
var img = Image.create(2, 2, false, Image.FORMAT_RGB8)
img.set_pixel(0, 0, Color.BLACK)
img.set_pixel(1, 1, Color.BLACK)
img.set_pixel(0, 1, Color.WHITE)
img.set_pixel(1, 0, Color.WHITE)
var tex = ImageTexture.create_from_image(img)
material.albedo_texture = tex
material.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
```

**方式 B (后处理 Shader) 推荐:**
```glsl
// 全屏后处理 shader
shader_type canvas_item;

uniform sampler2D screen_texture;
uniform float dither_scale = 1.0;

// Bayer 4x4 抖动矩阵
const float bayer[16] = float[](
    0.0, 8.0, 2.0, 10.0,
    12.0, 4.0, 14.0, 6.0,
    3.0, 11.0, 1.0, 9.0,
    15.0, 7.0, 13.0, 5.0
);

void fragment() {
    vec4 color = texture(screen_texture, SCREEN_UV);
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    
    // 应用抖动
    ivec2 pos = ivec2(mod(FRAGCOORD.xy * dither_scale, 4.0));
    float threshold = bayer[pos.y * 4 + pos.x] / 16.0;
    
    // 黑白化
    float result = step(threshold, gray);
    COLOR = vec4(vec3(result), 1.0);
}
```

**方法 3: 几何剪影 (最省事)**
直接用黑白两色的几何体拼搭，不追求 "真实光影"，而是追求 **图形设计感**:
- 黑色物体 = 阴影中的物体
- 白色物体 = 光照下的物体
- 黑白相邻 = 强烈的图形对比

#### 像素完美设置

确保渲染锐利，无模糊:

```
项目设置:
├── 渲染 → 纹理 → 画布纹理: 关闭 Filter
├── 渲染 → 抗锯齿: 关闭 (或使用 FXAA，但可能模糊)
└── 视口 → 渲染 → 默认纹理过滤: Nearest

材质设置:
└── Texture Filter: Nearest (最近邻，无插值)
```

#### 背景处理

**方案 1: 纯色背景**
```
WorldEnvironment:
└── Background → Color: #FFFFFF 或 #000000
```

**方案 2: 1-bit 渐变 (抖动)**
使用大尺寸棋盘格纹理作为背景，营造 "伪渐变" 效果。

#### 实例: 椅子在 1-bit 风格下的表现

```
传统 3D:        1-bit 风格:
┌────────┐     ┌────────┐
│ 渐变阴影│  →  │██████│  (黑色 = 阴影面)
│ 材质贴图│     │░░░░░░│  (抖动 = 过渡)
│ 光照计算│     │      │  (白色 = 受光面)
└────────┘     └────────┘
```

**具体实现:**
1. 导入 KayKit `chair_A.gltf`
2. 删除原材质，创建新材质
3. 靠背 → `white_material` (面向光源)
4. 座面 → `white_material` (顶面)
5. 椅腿 → `black_material` (侧面/背面)
6. 腿部阴影区域 → 小面积 `black_material` 几何体贴片

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
