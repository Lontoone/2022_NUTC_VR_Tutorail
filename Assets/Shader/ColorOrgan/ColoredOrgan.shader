Shader "Unlit/ColoredOrgan"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _Color ("color", Color) = (1, 1, 1, 1)
        _Specular ("Specular", Color) = (1, 1, 1, 1)
        _Gloss ("Gloss", Range(8.0, 256)) = 20
        
        _BumpMap ("Normal map", 2D) = "bump" { }//bump= 預設為模型本身的法線
        _BumpSacle ("Bump scale", float) = 1
        _Color ("Main Color", Color) = (1, 1, 1, 1)
        _Alpha ("alpha", float) = 1
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" }
        LOD 100
        Stencil
        {
            Ref 1 // ReferenceValue = 1
            Comp Always // Comparison Function - Make the stencil test always pass.
            Pass Replace // Write the reference value into the buffer.

        }
        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            //  *** 變數 ***
            sampler2D _MainTex;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            float _BumpSacle;
            float4 _MainTex_ST;
            fixed4 _Specular;
            float _Gloss;
            float4 _Color;
            float _Alpha;

            //  *** 結構 ***
            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                //注意tangent比normal多個w分量決定副切線的方向
                float4 tangent : tangent;
                float4 texcoord : TEXCOORD0;
            };
            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD0;
                float3 lightDir : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
            };

            //  *** 著色器 ***
            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                //計算UV
                o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                o.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;

                TANGENT_SPACE_ROTATION; //巨集：模型space=>tangent space的轉換
                //將光線方向從模型座標至tangent座標
                o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
                //將視角方向從模型座標至tangent座標
                o.viewDir = mul(rotation, ObjSpaceViewDir(v.vertex)).xyz;

                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                fixed3 tangentLightDir = normalize(i.lightDir);
                fixed3 tangentViewDir = normalize(i.viewDir);
                //採樣normal map
                fixed4 packedNormal = tex2D(_BumpMap, i.uv.zw);
                //fixed3 tangentNormal = UnpackNormal(packedNormal); 等同於 tangentNormal.xy=(packedNormal.xy * 2 -1 )*_BumpSacle; 但只能在normal map貼圖使用
                fixed3 tangentNormal;
                tangentNormal.xy = (packedNormal.xy * 2 - 1) * _BumpSacle;
                tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));

                //模型貼圖顏色
                fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;
                //疊上環境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                //漫射光=pass中的顏色 * 貼圖色 * 強度
                fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(tangentNormal, tangentLightDir));
                //使用Blinn-Phong高光反射模型
                fixed3 halfDir = normalize(tangentLightDir + tangentViewDir);
                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(tangentNormal, halfDir)), _Gloss);

                return fixed4(ambient + diffuse + specular, _Alpha);
            }
            ENDCG

        }
    }
    Fallback "Specular"
}
