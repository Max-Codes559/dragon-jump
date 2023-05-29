shader_type canvas_item;

uniform vec4 change_color: hint_color = vec4(1.0);
uniform float change_modifier: hint_range(0.0, 1.0, 0.01);

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.rgb = mix(color.rgb, change_color.rgb, change_modifier);
	COLOR = color;
	
}