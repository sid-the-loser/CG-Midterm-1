// Written by Sidharth S, referenced from Canvas

// This shader is for toon shading and color grading. It makes its own lighting system to make the sharp shade changes-
// the toon shading possible!

Shader "Custom/ToonShader"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1) // displays a property on unity editor that lets you select a color
        _RampTex ("Ramp Texture", 2D) = "white" {} // texture that we will be using as the shadow
        _ColorTint ("Color Tint", Color) = (1, 1, 1, 1) // displays a color selector in unity editor
    }
    SubShader
    {
        CGPROGRAM

        #pragma surface surf ToonRamp

        float4 _Color; // getting the color from properties 
        sampler2D _RampTex; // getting the ramp texture from properties
        float4 _ColorTint; // getting the color tint from properties

        struct Input
        {
            float2 uv_MainTex; // Gets the uv of the player texture (however, we are not using this at all in this-
                               // shader)
        };

        float4 LightingToonRamp(SurfaceOutput s, fixed3 lightDir, fixed atten) // defining our custom toon shader-
                                                                               // lighting
        {
            float diff = dot(s.Normal, lightDir); // gets the dot product between the normal of the surface of the-
                                                  // object and the direction of the light
            float2 rh = diff * 0.5 + 0.5; // gets a uv value that will be taken from the ramp texture and used to blend-
                                          // the color of the object to look shaded
            float3 ramp = tex2D(_RampTex, rh).rgb; // gets the particular uv from the ramp texture and stores it in-
                                                   // "ramp"

            float4 c; // c is used to keep track of the color of the pixel on the object surface
            c.rgb = s.Albedo * _LightColor0.rgb * ramp; // all of the values are blended together to form the final-
                                                        // pixel color
            c.a = s.Alpha; // the alpha is set directly from the surface
            return c;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Color.rgb * _ColorTint.rgb; // The albedo/diffuse color of the surface is set to the value we-
                                                    // get from properties and the tint color is multiplied to it to-
                                                    // add the tint/color grading effect
        }
        
        ENDCG
    }
    FallBack "Diffuse" // fallback, in case something breaks in the shader that we wrote
}
