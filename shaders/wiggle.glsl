// Chatgpt generate wiggle shader
#define TAU 6.28318530718

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Get the screen space UV coordinates
    vec2 uv = fragCoord.xy / iResolution.xy;

    // Set the amount of wiggle based on time
    float time = iTime * 0.5;  // Adjust this value to change the speed of the wiggle
    float wiggleStrength = 0.003; // Adjust this value to change how much the screen wiggles

    // Apply a sine-cosine perturbation to the UV coordinates
    vec2 wiggle = vec2(sin(time + uv.y * TAU), cos(time + uv.x * TAU)) * wiggleStrength;

    // Apply the wiggle to the UV coordinates
    uv += wiggle;

    // Sample the texture at the new, perturbed UV coordinates
    fragColor = texture(iChannel0, uv);
}

