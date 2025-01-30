// Taken from https://www.shadertoy.com/view/XXjGDt
// Modified to include a grey overlay, and to also 
// chromakey out the black background
#define PIXEL_SIZE_FAC 700.0
#define SPIN_EASE 0.5
#define colour_2 vec4(0.0, 156.0 / 255.0, 1.0, 1.0)
#define colour_1 vec4(0.85, 0.2, 0.2, 1.0)
#define colour_3 vec4(0.0, 0.0, 0.0, 1.0)
#define spin_amount 0.7
#define contrast 1.5

// Define black background color
const vec3 BACKGROUND_COLOR = vec3(0.0, 0.0, 0.0);
const float TOLERANCE = 0.01;

const vec4 greyOverlay = vec4(40.0 / 255.0, 40.0 / 255.0, 40.0 / 255.0, 0.7); // Transparent grey


void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec4 inputColor = texture(iChannel0, fragCoord / iResolution.xy); // Sample current screen color

    // Check if the pixel matches the background color (within tolerance)
    if (distance(inputColor.rgb, BACKGROUND_COLOR) < TOLERANCE)
    {
        // Apply shader effect only to black background
        float pixel_size = length(iResolution.xy) / PIXEL_SIZE_FAC;
        vec2 uv = (floor(fragCoord.xy * (1.0 / pixel_size)) * pixel_size - 0.5 * iResolution.xy) / length(iResolution.xy) - vec2(0.0, 0.0);
        float uv_len = length(uv);

        float speed = (iTime * SPIN_EASE * 0.1) + 302.2;
        float new_pixel_angle = (atan(uv.y, uv.x)) + speed - SPIN_EASE * 20.0 * (1.0 * spin_amount * uv_len + (1.0 - 1.0 * spin_amount));
        vec2 mid = (iResolution.xy / length(iResolution.xy)) / 2.0;
        uv = (vec2((uv_len * cos(new_pixel_angle) + mid.x), (uv_len * sin(new_pixel_angle) + mid.y)) - mid);

        uv *= 30.0;
        speed = iTime * (1.0);
        vec2 uv2 = vec2(uv.x + uv.y);

        for (int i = 0; i < 5; i++)
        {
            uv2 += uv + cos(length(uv));
            uv += 0.5 * vec2(cos(5.1123314 + 0.353 * uv2.y + speed * 0.131121), sin(uv2.x - 0.113 * speed));
            uv -= 1.0 * cos(uv.x + uv.y) - 1.0 * sin(uv.x * 0.711 - uv.y);
        }

        float contrast_mod = (0.25 * contrast + 0.5 * spin_amount + 1.2);
        float paint_res = min(2.0, max(0.0, length(uv) * (0.035) * contrast_mod));
        float c1p = max(0.0, 1.0 - contrast_mod * abs(1.0 - paint_res));
        float c2p = max(0.0, 1.0 - contrast_mod * abs(paint_res));
        float c3p = 1.0 - min(1.0, c1p + c2p);

        vec4 ret_col = (0.3 / contrast) * colour_1 + (1.0 - 0.3 / contrast) * (colour_1 * c1p + colour_2 * c2p + vec4(c3p * colour_3.rgb, c3p * colour_1.a)) + 0.3 * max(c1p * 5.0 - 4.0, 0.0) + 0.4 * max(c2p * 5.0 - 4.0, 0.0);

        // Add transparent grey overlay if within bounds
        vec2 overlayMin = vec2(0, 0); // Top-left bound (normalized coordinates)
        vec2 overlayMax = vec2(1, 1); // Bottom-right bound (normalized coordinates)
        bool insideOverlay = fragCoord.x / iResolution.x > overlayMin.x && fragCoord.x / iResolution.x < overlayMax.x &&
                            fragCoord.y / iResolution.y > overlayMin.y && fragCoord.y / iResolution.y < overlayMax.y;

        // Apply overlay if within the square area
        fragColor = insideOverlay ? mix(ret_col, greyOverlay, greyOverlay.a) : ret_col;

        // fragColor = ret_col;

    }
    else
    {
        // Keep the original color for non-black pixels
        fragColor = inputColor;
    }
}

