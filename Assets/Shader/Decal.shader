Shader "Unlit/Decal"
{
    Properties
    {
        _MainTex ("Decal Texture", 2D) = "white" { }
    }

    SubShader
    {
        Tags { "Queue" = "Geometry+1" }

        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM

            #pragma target 3.0
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 screenUV : TEXCOORD0;
                float3 ray : TEXCOORD1;
            };
            
            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.screenUV = ComputeScreenPos(o.pos); //剪裁空間=> Viewport空間。 左下(0,0) ~ 右上(1,1)
                o.ray = UnityObjectToViewPos(v.vertex).xyz * float3(-1, -1, 1); //以camera為原點，相對於camera的位移座標
                return o;
            }

            sampler2D _MainTex;
            sampler2D _CameraDepthTexture; //需C#設定 camera.depthTextureMode |= DepthTextureMode.Depth;
            float4 frag(v2f i) : SV_Target
            {
                i.ray = i.ray * (_ProjectionParams.z / i.ray.z); //將向量的終點由頂點位置投影到了相機far plane (所有點都會沿著放射線落在far plane上)
                float2 uv = i.screenUV.xy / i.screenUV.w; //除以w後xy分量在[0,1]區間，用來作爲UV去讀取_CameraDepthTexture。

                float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv);

                // 要轉換成線性的深度值 //
                depth = Linear01Depth(depth);
                
                float4 vpos = float4(i.ray * depth, 1);
                float3 wpos = mul(unity_CameraToWorld, vpos).xyz;
                float3 opos = mul(unity_WorldToObject, float4(wpos, 1)).xyz;
                clip(float3(0.5, 0.5, 0.5) - abs(opos.xyz));

                // 轉換到 [0,1] 區間 //
                float2 texUV = opos.xz + 0.5; //不考慮y

                float4 col = tex2D(_MainTex, texUV);
                return col;
                //return (depth,1,1,1);
            }
            ENDCG

        }
    }

    Fallback Off
}
