Shader "Unlit/UltroSoundShadow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _AccIntensity ("Acc Intensity", float) = 1
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100
        //模擬上白下暗的深度陰影
        pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainTex_TexelSize;
            float _AccIntensity;
            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 toSource : TEXCOORD1;
            };

            v2f vert(appdata_base v)
            {
                v2f output;
                output.pos = UnityObjectToClipPos(v.vertex);
                float2 sourcePosition = float2(0.5, 1);
                output.uv = v.texcoord.xy;
                output.toSource = sourcePosition - v.texcoord.xy;

                return output;
            }

            half4 frag(v2f input) : SV_Target
            {
                half4 output = half4(0, 0, 0, 1);
                float2 normalizedToSource = input.toSource / length(input.toSource);
                float2 texelToSource = float2(normalizedToSource * _MainTex_TexelSize.y);

                //float whiteIntensity = 1 - tanh((1 - input.uv.y) * 9);

                // _TexelSize.w is automatically assigned by Unity to the texture’s height
                for (int i = 0; i < _MainTex_TexelSize.w; i++)
                {
                    output += tex2D(_MainTex, input.uv + texelToSource * i)*_AccIntensity;
                }

                return(1 - output) ;
                //return output;
                //return tex2D(_MainTex, input.uv);

            }

            ENDCG

        }
    }
}
