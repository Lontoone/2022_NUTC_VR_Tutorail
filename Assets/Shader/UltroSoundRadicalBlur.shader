Shader "Unlit/UltroSoundRadicalBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _BlurSize ("blur Size", float) = 5
        _BlurCenter ("blur center", vector) = (0.5, 0, 0, 0)
        _Iteration ("Iteration", float) = 20
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
            float2 uv : TEXCOORD0;
        };

        sampler2D _MainTex;
        float4 _MainTex_TexelSize;
        float4 _MainTex_ST;
        float _BlurSize;
        float2 _BlurCenter;
        float _Iteration;

        float getAngle(float m)
        {
            return atan(m);
        }
        float2 rotate(float2 v, float angle)
        {
            float x = v.x * cos(angle) - v.y * sin(angle);
            float y = v.x * sin(angle) + v.y * cos(angle);
            return float2(x, y);
        }

        v2f vert(appdata_img v)
        {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

            //float2 toCenter = _BlurCenter - v.texcoord;
            //float angle = atan(toCenter.y / toCenter.x);
            //half2 uv = v.texcoord;

            return o;
        }
        float4 frag(v2f i) : SV_TARGET
        {
            //float2 blurVector = (_BlurCenter.xy - i.uv.xy) * _BlurSize;
            float r = length((_BlurCenter.xy - i.uv.xy));
            float angle=acos((i.uv.x - _BlurCenter.x )/r); //取標準化範圍的x
            //float angle = atan(blurVector.y / blurVector.x); !Not Work
            angle *=sign(i.uv.y - _BlurCenter.y); //因arccos(x)不分上下，所以使用y軸判斷

            float4 acumulateColor = float4(0, 0, 0, 0);
            
            for (int it = -_Iteration; it <= _Iteration; it++)
            {
                float phi = angle + radians(it*_BlurSize);
                float2 _arcuv = float2(_BlurCenter.x + r * cos(phi), _BlurCenter.y + r * sin(phi));

                acumulateColor += tex2D(_MainTex, _arcuv);
                //i.uv.xy += blurVector;

            }

            return acumulateColor / _Iteration;
        }
        
        ENDCG

        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            NAME "BLUR_VER"

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            ENDCG

        }
    }
    Fallback "Off"
}