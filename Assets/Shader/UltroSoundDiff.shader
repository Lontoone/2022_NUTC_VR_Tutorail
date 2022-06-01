Shader "Unlit/UltroSoundDiff"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }        
        _EdgeSize ("Textel Size", float) = 1

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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 uvabove : TEXCOORD1;
                float4 vertex : SV_POSITION;
                float2 noise_uv : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainTex_TexelSize;
            float _EdgeSize;
            float _DiffIntensity=10;

            v2f vert(appdata v)
            {
                v2f o;
                //假設音波來源是上中央
                float2 sourcePosition = float2(0.5, 1);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //o.noise_uv = TRANSFORM_TEX(v.uv, _NoiseTex);
                //上緣uv位置
                o.uvabove = v.uv.xy + (sourcePosition - v.uv.xy) * _MainTex_TexelSize.y * _EdgeSize;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 above_col = tex2D(_MainTex, i.uvabove);
                
                return  abs(above_col - col) * _DiffIntensity ;
            }
            ENDCG

        }
    }
}
