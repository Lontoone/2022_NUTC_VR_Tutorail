Shader "Unlit/Sector"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _Color ("Color", Color) = (1, 1, 1, 1)
        _EndAngle ("end Angle", Range(0, 360)) = 120.0
        _StartAngle ("start Angle", Range(0, 360)) = 60
        _maxDistance("max distance",float)=1
        _innerDistance ("inner distance" , Range(0,0.5))=0.2
        _CenterOffset ("blur center", vector) = (0.5, 0.5, 0, 0)
    }
    SubShader
    {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent" "PreviewType" = "Plane" }
        
        Pass
        {
            //Blend SrcAlpha OneMinusSrcAlpha
            //ZWrite Off
            //Cull Off
            
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            sampler2D _MainTex;
            //float4 _MainTex_ST;
            float _StartAngle;
            half _EndAngle;
            half4 _Color;
            float _maxDistance;
            float _innerDistance;
            float2 _CenterOffset; //圓心位移
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
            
            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                //o.uv=TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }
            
            half4 frag(v2f i) : SV_Target
            {
                //Re-map this now rather than later
                float2 relativePos=i.uv - _CenterOffset;
                float2 pos = - ((relativePos) * 2.0 - 1.0);
                float4 col = tex2D(_MainTex,i.uv);
                
                //Calculate the angle of our current pixel around the circle
                float theta = degrees(atan2(pos.x, pos.y)) + 180.0;
                
                //Get circle and sector masks
                float circle = length(pos) <= _maxDistance && length(pos) >=_innerDistance;
                float sector = (theta <= _EndAngle) && (theta >= _StartAngle);
                
                //Return the desired colour masked by the circle and sector
                //return _Color * (circle * sector);
                return col * (circle * sector);
                
                
            }
            ENDCG

        }
    }
}
