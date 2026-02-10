shader_type canvas_item;

## 简化版 1-bit 后处理 shader
## 如果完整版有问题，用这个版本

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform sampler2D depth_texture : hint_depth_texture, filter_nearest;

uniform float edge_threshold : hint_range(0.0, 0.5) = 0.02;
uniform float brightness_threshold : hint_range(0.0, 1.0) = 0.5;
uniform bool invert_colors : hint_default(false);

// Bayer 4x4 矩阵
const float bayer[16] = float[](
    0.0, 8.0, 2.0, 10.0,
    12.0, 4.0, 14.0, 6.0,
    3.0, 11.0, 1.0, 9.0,
    15.0, 7.0, 13.0, 5.0
);

void fragment() {
    vec2 texel_size = 1.0 / vec2(textureSize(screen_texture, 0));
    
    // 采样屏幕颜色
    vec3 color = texture(screen_texture, SCREEN_UV).rgb;
    float depth = texture(depth_texture, SCREEN_UV).r;
    
    // 亮度
    float lum = dot(color, vec3(0.299, 0.587, 0.114));
    
    // 简单的深度边缘检测
    float center = depth;
    float up = texture(depth_texture, SCREEN_UV + vec2(0.0, texel_size.y)).r;
    float down = texture(depth_texture, SCREEN_UV + vec2(0.0, -texel_size.y)).r;
    float left = texture(depth_texture, SCREEN_UV + vec2(-texel_size.x, 0.0)).r;
    float right = texture(depth_texture, SCREEN_UV + vec2(texel_size.x, 0.0)).r;
    
    float max_diff = max(
        max(abs(center - up), abs(center - down)),
        max(abs(center - left), abs(center - right))
    );
    
    bool is_edge = max_diff > edge_threshold;
    
    // Bayer 抖动
    int x = int(FRAGCOORD.x) % 4;
    int y = int(FRAGCOORD.y) % 4;
    float dither = bayer[y * 4 + x] / 16.0;
    
    // 合成
    float result;
    if (is_edge) {
        result = 0.0; // 边缘黑色
    } else {
        result = (lum + brightness_threshold * 0.5 > dither) ? 1.0 : 0.0;
    }
    
    if (invert_colors) {
        result = 1.0 - result;
    }
    
    COLOR = vec4(vec3(result), 1.0);
}
