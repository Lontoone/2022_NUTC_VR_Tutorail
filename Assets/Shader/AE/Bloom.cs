using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways]
public class Bloom : MonoBehaviour
{
    public Material mat;

    [Range(0, 4)]
    public float iterations = 3;
    [Range(0.3f, 3)]
    public float blurSpeard = 0.6f;
    [Range(1, 8)]
    public int dowbSample = 2; //壓縮影像
    [Range(0, 1.2f)] //正常亮度不超過1，但HDR就有可能超過
    public float luminanceThreshold = 0.6f;
    private void OnEnable() {
        Camera camera = Camera.main;
        camera.depthTextureMode |= DepthTextureMode.Depth;

        //法線與深度 xy=法線  zw=深度
        //camera.depthTextureMode = DepthTextureMode.DepthNormals;
    }

    public void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (mat != null)
        {
            mat.SetFloat("_LuminanceThreshold", luminanceThreshold);

            int rtw = source.width / dowbSample;
            int rth = source.height / dowbSample;
            //螢幕大小的快取
            RenderTexture buffer = RenderTexture.GetTemporary(rtw, rth, 0);
            buffer.filterMode = FilterMode.Bilinear;

            //先使用第一個pass分析原圖較亮的部分
            Graphics.Blit(source, buffer, mat, 0);

            for (int i = 0; i < iterations; i++)
            {
                mat.SetFloat("_BlurSize", 1 + i * blurSpeard);
                RenderTexture buffer1 = RenderTexture.GetTemporary(rtw, rth, 0);
                //垂直 (N*1)
                Graphics.Blit(buffer, buffer1, mat, 1);

                RenderTexture.ReleaseTemporary(buffer);
                buffer = buffer1;
                buffer1 = RenderTexture.GetTemporary(rtw, rth, 0);

                //水平 (1*N)
                Graphics.Blit(buffer, buffer1, mat, 2);
                RenderTexture.ReleaseTemporary(buffer);
                buffer = buffer1;
            }

            mat.SetTexture("_Bloom", buffer);
            Graphics.Blit(source, destination, mat, 3);
            RenderTexture.ReleaseTemporary(buffer);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}
