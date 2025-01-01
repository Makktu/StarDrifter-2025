shader_type canvas_item;

uniform float brightness : hint_range(0.0, 2.0) = 1.05;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

float Less(float x, float value) {
    return 1.0 - step(value, x);
}

float Between(float x, float lower, float upper) {
    return step(lower, x) * (1.0 - step(upper, x));
}

float GEqual(float x, float value) {
    return step(value, x);
}

void fragment() {
    // Get the screen texture directly without UV manipulation
    vec2 uv = SCREEN_UV;

    // Calculate the RGB separation grid
    vec2 pixel_size = SCREEN_PIXEL_SIZE * 3.0;  // Adjust the 3.0 to change grid size
    vec2 grid_uv = floor(uv / pixel_size);
    float grid_pattern = mod(grid_uv.x + grid_uv.y, 3.0);

    // Sample the screen
    vec4 screen_color = texture(SCREEN_TEXTURE, uv);

    // Apply the RGB separation effect
    vec4 newColour = screen_color;
    if (grid_pattern < 1.0) {
        newColour.gb *= 0.5;  // Emphasize red
    } else if (grid_pattern < 2.0) {
        newColour.rb *= 0.5;  // Emphasize green
    } else {
        newColour.rg *= 0.5;  // Emphasize blue
    }

    COLOR = newColour * brightness;
}