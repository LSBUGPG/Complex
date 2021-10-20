Shader "Unlit/Complex"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 c = float2(i.uv.x, i.uv.y);
                float2 z = c;
                int depth = 20;
                float count = 0.0;
                for (int i = 0; i < depth; ++i)
                {
                    float2 z2 = float2(z.x * z.x - z.y * z.y, 2 * z.x * z.y);
                    z = z2 + c;
                    if (length(z) > 2.0)
                    {
                        count = float(i + 1) / float(depth);
                        break;
                    }
                }
                fixed4 col = tex2D(_MainTex, fixed2(count, 0.0));
                return col * step(1.0 / depth, float(count));
            }
            ENDCG
        }
    }
}
