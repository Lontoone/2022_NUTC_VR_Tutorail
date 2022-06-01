Shader "Unlit/AE"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
    }
    SubShader
    {
        ZTest Always
        Cull Off
        ZWrite Off
        //組織程式碼用
        CGINCLUDE

        #include "UnityCG.cginc"

        struct v2f
        {
            float4 pos : SV_POSITION;
            float2 uv[5] : TEXCOORD0;
        };

        sampler2D _MainTex;
        float4 _MainTex_TexelSize;
        float4 _MainTex_ST;
        float _BlurSize;

        v2f vertBlurVertical(appdata_img v)
        {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            half2 uv = v.texcoord;

            // 該uv座標鄰近的紋理像素陣列
            //因為頂點到片段著色器是線性內插，所以不影響結果
            //做5*1的陣列，分別是中心與其兩邊的2個
            o.uv[0] = uv ;
            o.uv[1] = uv + float2(0, _MainTex_TexelSize.y * 1) * _BlurSize;
            o.uv[2] = uv - float2(0, _MainTex_TexelSize.y * 1) * _BlurSize;
            o.uv[3] = uv + float2(0, _MainTex_TexelSize.y * 2) * _BlurSize;
            o.uv[4] = uv - float2(0, _MainTex_TexelSize.y * 2) * _BlurSize;

            return o;
        }
        v2f vertBlurHorizontal(appdata_img v)
        {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            half2 uv = v.texcoord;

            // 該uv座標鄰近的紋理像素陣列
            //因為頂點到片段著色器是線性內插，所以不影響結果
            //做5*1的陣列，分別是中心與其兩邊的2個
            o.uv[0] = uv ;
            o.uv[1] = uv + float2(_MainTex_TexelSize.x * 1, 0) * _BlurSize;
            o.uv[2] = uv - float2(_MainTex_TexelSize.x * 1, 0) * _BlurSize;
            o.uv[3] = uv + float2(_MainTex_TexelSize.x * 2, 0) * _BlurSize;
            o.uv[4] = uv - float2(_MainTex_TexelSize.x * 2, 0) * _BlurSize;

            return o;
        }

        //兩個Pass共用的方法
        float4 frag(v2f i) : SV_TARGET
        {
            //因為對稱性，所以只須紀錄3個加權值
            float weight[3] = {
                0.4026, 0.2442, 0.0545
            };
            
            float3 sum = tex2D(_MainTex, i.uv[0]).rgb * weight[0];
            //一次計算對稱的兩邊
            for (int it = 1; it < 3; it++)
            {
                sum += tex2D(_MainTex, i.uv[it * 2 - 1]).rgb * weight[it];
                sum += tex2D(_MainTex, i.uv[it * 2]).rgb * weight[it];
            }
            return float4(sum, 1);
        }
        
        ENDCG

        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            NAME "BLUR_VER"

            CGPROGRAM

            #pragma vertex vertBlurVertical
            #pragma fragment frag
            
            ENDCG

        }
        
        Pass
        {
            NAME "BLUR_HOR"

            CGPROGRAM

            #pragma vertex vertBlurHorizontal
            #pragma fragment frag
            
            ENDCG

        }
    }
    Fallback "Off"
}