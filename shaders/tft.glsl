// User tweakable setting: how many faux pixels tall the screen should be
const float pseudoPixelRows = 320.0;  // Higher = smaller pixels
const float strength = 1;

void _scanline(inout vec3 color, vec2 fragCoord, float pixelSize)
{
    float scanline = step(1.2, mod(fragCoord.y, pixelSize));
    float grille   = step(1.2, mod(fragCoord.x, pixelSize));
    color *= max(1.0 - strength, scanline * grille);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord / iResolution.xy;
    vec3 color = texture(iChannel0, uv).rgb;

    // Compute pixelSize based on screen height, but keep it integer
    float pixelSize = floor(iResolution.y / pseudoPixelRows);
    pixelSize = max(1.0, pixelSize); // avoid zero division

    _scanline(color, fragCoord, pixelSize);

    fragColor = vec4(color, 1.0);
}
