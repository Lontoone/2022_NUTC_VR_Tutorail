Shader "Unlit/AE_Bloom"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _Bloom ("Texture", 2D) = "white" { }
    }
    SubShader
    {
        CGINCLUDE
        
        #include "UnityCG.cginc"
        sampler2D _MainTex;
        float4 _MainTex_ST;
        float4 _MainTex_TexelSize;
        sampler2D _Bloom;
        float _LuminanceThreshold;
        float _BlurSize;

        struct v2f
        {
            float4 pos : SV_POSITION;
            float2 uv : TEXCOORD0;
        };
        struct v2fBloom
        {
            float4 pos : SV_POSITION;
            //xy紀錄_Maintex紋理，zw紀錄Bloom模糊後較亮區域的紋理
            float4 uv : TEXCOORD0;
        };
        //亮部與原圖混合用:
        v2fBloom vertBloom(appdata_img v)
        {
            v2fBloom o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv.xy = v.texcoord; //maintex紋理
            o.uv.zw = v.texcoord; //bloom區域紋理
            #if UNITY_UV_STARTS_AT_TOP //平台差異化處理
                if (_MainTex_TexelSize .y < 0)
                {
                    o.uv.w = 1 - o.uv.w;
                }
            #endif
            return o;
        }
        //分析較量區域
        v2f vertExtractBright(appdata_img v)
        {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv = v.texcoord;
            return o;
        }
        fixed luminance(float4 col)
        {
            return 0.2125 * col.r + 0.7154 * col.g + 0.0721 * col.b;
        }

        float4 fragExtractBright(v2f i ): SV_TARGET
        {
            float4 c = tex2D(_MainTex, i.uv);
            //保留亮度高於閥值的區塊
            float val = clamp(luminance(c) - _LuminanceThreshold, 0, 1);
            return c * val; //brightness
        }
        float4 fragBloom(v2fBloom i) : SV_TARGET
        {
            return tex2D(_MainTex, i.uv.xy) + tex2D(_Bloom, i.uv.zw);
        }

        ENDCG

        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            //抽取較亮區域
            CGPROGRAM
            #pragma vertex vertExtractBright
            #pragma fragment fragExtractBright
            ENDCG

        }        
        //blur處理
        UsePass "Unlit/AE/BLUR_VER"
        UsePass "Unlit/AE/BLUR_HOR"
        
        //套用效果
        pass
        {
            CGPROGRAM
            #pragma vertex vertBloom
            #pragma fragment fragBloom
            ENDCG

        }

    }
    Fallback Off
}