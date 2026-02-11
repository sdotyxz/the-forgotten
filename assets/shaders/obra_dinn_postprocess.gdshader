shader_type canvas_item;

// 屏幕纹理和深度纹理
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;
uniform sampler2D depth_texture : hint_depth_texture, filter_nearest;

// 抖动纹理（Bayer 矩阵或蓝噪声）
uniform sampler2D dither_texture : hint_default_white, filter_nearest;
uniform sampler2D noise_texture : hint_default_white, filter_nearest;

// 相机四角的射线方向（由脚本传入）
uniform vec3 bl_ray : hint_color = vec3(-0.5, -0.5, -1.0);
uniform vec3 tl_ray : hint_color = vec3(-0.5, 0.5, -1.0);
uniform vec3 tr_ray : hint_color = vec3(0.5, 0.5, -1.0);
uniform vec3 br_ray : hint_color = vec3(0.5, -0.5, -1.0);

// 参数
uniform float tiling : hint_range(1.0, 512.0) = 192.0;
uniform float edge_threshold : hint_range(0.0, 1.0) = 0.1;
uniform float depth_threshold : hint_range(0.0, 1.0) = 0.1;
uniform bool use_cube_projection = true;
uniform bool invert_colors = false;

// Bayer 4x4 矩阵（备用）
const float bayer[16] = float[](
    0.0/16.0, 8.0/16.0, 2.0/16.0, 10.0/16.0,
    12.0/16.0, 4.0/16.0, 14.0/16.0, 6.0/16.0,
    3.0/16.0, 11.0/16.0, 1.0/16.0, 9.0/16.0,
    15.0/16.0, 7.0/16.0, 13.0/16.0, 5.0/16.0
);

// 旋转矩阵（避免抖动对齐世界轴）
const mat3 rot_matrix = mat3(
    vec3(0.9473740, -0.1985178, 0.2511438),
    vec3(0.2511438, 0.9473740, -0.1985178),
    vec3(-0.1985178, 0.2511438, 0.9473740)
);

// 根据屏幕 UV 重建世界空间方向向量
vec3 reconstruct_ray(vec2 uv) {
    vec3 bottom = mix(bl_ray, br_ray, uv.x);
    vec3 top = mix(tl_ray, tr_ray, uv.x);
    return normalize(mix(bottom, top, uv.y));
}

// 立方体投影（最稳定的 3D 抖动）
float cube_project(sampler2D tex, vec2 texel_size, vec3 dir) {
    // 应用旋转向量
    dir = rot_matrix * dir;
    
    vec2 uv_coords;
    float abs_x = abs(dir.x);
    float abs_y = abs(dir.y);
    float abs_z = abs(dir.z);
    
    // 根据主要轴向选择投影面
    if (abs_x > abs_y && abs_x > abs_z) {
        uv_coords = dir.yz / abs_x;
    } else if (abs_z > abs_x && abs_z > abs_y) {
        uv_coords = dir.xy / abs_z;
    } else {
        uv_coords = dir.xz / abs_y;
    }
    
    return texture(tex, texel_size * tiling * uv_coords).r;
}

// 圆柱投影
float cylinder_project(sampler2D tex, vec2 texel_size, vec3 dir) {
    float u = 0.5 + (atan(dir.x, -dir.z) / 3.14159265);
    float v = 0.5 + dir.y * 0.5;
    return texture(tex, texel_size * tiling * vec2(u, v)).r;
}

// 球面 UV 投影
float sphere_project(sampler2D tex, vec2 texel_size, vec3 dir) {
    float u = 0.5 + 0.5 * (atan(dir.x, -dir.z) / 3.14159265);
    float v = 0.5 - (acos(dir.y) / 3.14159265);
    return texture(tex, texel_size * tiling * vec2(u, v)).r;
}

// 深度边缘检测
float detect_depth_edge(vec2 uv, vec2 texel_size) {
    float center = texture(depth_texture, uv).r;
    float up = texture(depth_texture, uv + vec2(0.0, texel_size.y)).r;
    float down = texture(depth_texture, uv + vec2(0.0, -texel_size.y)).r;
    float left = texture(depth_texture, uv + vec2(-texel_size.x, 0.0)).r;
    float right = texture(depth_texture, uv + vec2(texel_size.x, 0.0)).r;
    
    float max_diff = max(
        max(abs(center - up), abs(center - down)),
        max(abs(center - left), abs(center - right))
    );
    
    return step(edge_threshold, max_diff);
}

// Sobel 边缘检测（基于亮度）
float sobel_edge(vec2 uv, vec2 texel_size) {
    vec3 up = texture(screen_texture, uv + vec2(0.0, 1.0) * texel_size).rgb;
    vec3 down = texture(screen_texture, uv + vec2(0.0, -1.0) * texel_size).rgb;
    vec3 left = texture(screen_texture, uv + vec2(-1.0, 0.0) * texel_size).rgb;
    vec3 right = texture(screen_texture, uv + vec2(1.0, 0.0) * texel_size).rgb;
    vec3 center = texture(screen_texture, uv).rgb;
    
    // 转灰度
    float luma_center = dot(center, vec3(0.299, 0.587, 0.114));
    float luma_up = dot(up, vec3(0.299, 0.587, 0.114));
    float luma_down = dot(down, vec3(0.299, 0.587, 0.114));
    float luma_left = dot(left, vec3(0.299, 0.587, 0.114));
    float luma_right = dot(right, vec3(0.299, 0.587, 0.114));
    
    float gx = luma_left - luma_right;
    float gy = luma_up - luma_down;
    
    return length(vec2(gx, gy));
}

void fragment() {
    vec2 texel_size = 1.0 / vec2(textureSize(screen_texture, 0));
    
    // 采样屏幕颜色
    vec3 screen_color = texture(screen_texture, SCREEN_UV).rgb;
    float depth = texture(depth_texture, SCREEN_UV).r;
    
    // 计算亮度
    float lum = dot(screen_color, vec3(0.299, 0.587, 0.114));
    
    // 重建射线方向
    vec3 ray = reconstruct_ray(SCREEN_UV);
    
    // 计算抖动值
    float dither_val;
    vec2 dither_texel = 1.0 / vec2(textureSize(dither_texture, 0));
    
    if (use_cube_projection) {
        dither_val = cube_project(dither_texture, dither_texel, ray);
    } else {
        // 屏幕空间 Bayer（备用）
        int x = int(FRAGCOORD.x) % 4;
        int y = int(FRAGCOORD.y) % 4;
        dither_val = bayer[y * 4 + x];
    }
    
    // 边缘检测（深度 + 亮度）
    float depth_edge = detect_depth_edge(SCREEN_UV, texel_size);
    float sobel = sobel_edge(SCREEN_UV, texel_size);
    float is_edge = step(0.05, depth_edge + sobel * 0.5);
    
    // 合成
    float result;
    if (is_edge > 0.5) {
        // 边缘：根据深度判断前后
        result = (depth < depth_threshold) ? 1.0 : 0.0;
    } else {
        // 内部：抖动比较
        result = (lum <= clamp(dither_val, 0.1, 0.9)) ? 0.0 : 1.0;
    }
    
    // 颜色反转选项
    if (invert_colors) {
        result = 1.0 - result;
    }
    
    COLOR = vec4(vec3(result), 1.0);
}
