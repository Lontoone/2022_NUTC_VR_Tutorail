using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class UltroSoundCamera : MonoBehaviour
{
    public Material ultroSoundDiff;
    public Material ultroSoundShadow;
    public Material ultroSoundNoise;
    public Material ultroSoundMix;
    public Material ultroSoundBlur;
    public Material sectorMaterial;

    public float diffIntensity = 10;
    [Range(1, 10)]
    public int downSizeFactor = 4;
    public int blurIt = 3;
    public Vector2 blurCenter = new Vector2(0.5f, 0);
    [Range(0.0001f, 0.9f)]
    public float blurSize = 5;

    public float delayTime = 0.2f;
    private float timeCounter = 0;

    public void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (Time.time - timeCounter < delayTime) { return; }
        timeCounter = Time.time;

        int rtw = source.width;
        int rth = source.height;
        //�ù��j�p���֨�
        RenderTexture mainTexBuffer = RenderTexture.GetTemporary(rtw, rth, 0);
        RenderTexture reflectTexBuffer = RenderTexture.GetTemporary(rtw / downSizeFactor, rth / downSizeFactor, 0); //�����Ϯg�K��
        RenderTexture diffTexBuffer = RenderTexture.GetTemporary(rtw / downSizeFactor, rth / downSizeFactor, 0); //�G�׮t���K��  (��ĳ�ҽk)
        RenderTexture intensityBuffer = RenderTexture.GetTemporary(rtw / downSizeFactor, rth / downSizeFactor, 0); //�G�׮t���K��  (��ĳ�ҽk)

        //�򥻰���
        ultroSoundDiff.SetFloat("_DiffIntensity", diffIntensity);
        Graphics.Blit(source, reflectTexBuffer, ultroSoundDiff);

        //���T����
        Graphics.Blit(source, mainTexBuffer, ultroSoundNoise);

        //�t����
        ultroSoundDiff.SetFloat("_DiffIntensity", 1);
        Graphics.Blit(mainTexBuffer, diffTexBuffer, ultroSoundDiff);
        //�t����=>�j�׹�
        Graphics.Blit(diffTexBuffer, intensityBuffer, ultroSoundShadow);


        //���T + ���� + ���v
        ultroSoundMix.SetTexture("_ReflectionTex", reflectTexBuffer);
        ultroSoundMix.SetTexture("_IntensityTex", intensityBuffer);
        RenderTexture.ReleaseTemporary(diffTexBuffer); //�^����ȮɥΪ�buffer
        Graphics.Blit(mainTexBuffer, diffTexBuffer, ultroSoundMix);        

        RenderTexture.ReleaseTemporary(mainTexBuffer);
        ultroSoundBlur.SetFloat("_BlurSize", blurSize);
        ultroSoundBlur.SetVector("_BlurCenter", blurCenter);
        ultroSoundBlur.SetFloat("_Iteration", blurIt);

        
        Graphics.Blit(diffTexBuffer, mainTexBuffer, ultroSoundBlur);

        //����
        Graphics.Blit(mainTexBuffer, destination, sectorMaterial);
        //Graphics.Blit(mainTexBuffer, destination);


        RenderTexture.ReleaseTemporary(mainTexBuffer);
        RenderTexture.ReleaseTemporary(reflectTexBuffer);
        RenderTexture.ReleaseTemporary(diffTexBuffer);
        RenderTexture.ReleaseTemporary(intensityBuffer);
        /*
        */
    }
}
