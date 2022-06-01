Shader "Unlit/UltroSoundBlend"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _SkinNoiseTex ("Skin Noise Tex", 2D) = "white" { }
        _SkinRange("SkinRange", Range(1,10))=5
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
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
                float2 noiseTex:TEXCOORD1;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            //傳入已融合雜訊的圖
            sampler2D _MainTex;
            float4 _MainTex_ST;
            //高光
            sampler2D _ReflectionTex;
            //intensity
            sampler2D _IntensityTex;

            sampler2D _SkinNoiseTex;
            float4 _SkinNoiseTex_ST;
            float _SkinRange;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.zw = TRANSFORM_TEX(v.noiseTex, _SkinNoiseTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv.xy);
                float4 reflection = tex2D(_ReflectionTex, i.uv.xy);
                float4 intensity = tex2D(_IntensityTex, i.uv.xy);

                //skin表層顏色
                float whiteIntensity = 1 - (tanh((1 - i.uv.y) * _SkinRange))*0.5-0.5;
                fixed4 skinCol=tex2D(_SkinNoiseTex,i.uv.zw);                
                
                float4 res=(col + reflection) * intensity + whiteIntensity*skinCol;
                return res*0.6;
                //return intensity;

            }
            ENDCG

        }
    }
}
