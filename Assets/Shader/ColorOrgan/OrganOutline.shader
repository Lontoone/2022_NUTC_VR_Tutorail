// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/OrganOutline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _Color ("outline color", Color) = (1, 0, 0, 1)
        _OutlineWidth ("Outline width", Range(0.0, 1.0)) = .005
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100
        
        pass
        {
            Cull Front
            ZTest Always
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            float4 _Color;
            float _OutlineWidth = 0.5;

            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                float3 norm = normalize(v.normal);
                v.vertex.xyz += v.normal * _OutlineWidth;
                o.pos = UnityObjectToClipPos(v.vertex);

                return o;
            }
            fixed4 frag(v2f i) : COLOR
            {
                return _Color;
            }
            ENDCG

        }
        
        Pass
        {
            Cull Back
            Blend SrcAlpha OneMinusSrcAlpha
            /*
            SetTexture [_MainTex]
            {
                Combine Primary * Texture
            }*/
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD1;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

                return o;
            }
            fixed4 frag(v2f i) : SV_TARGET
            {
                float4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG

        }
    }
}
