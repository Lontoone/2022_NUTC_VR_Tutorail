using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TutorialAnwserLinstener : MonoBehaviour
{
    public string ans;
    public GameObject okBtns;
    private void Awake()
    {
        StickSenserToSkin.OnTrigger += Check;
        
    }
    private void OnEnable()
    {
        okBtns.SetActive(false);
    }
    private void OnDestroy()
    {
        StickSenserToSkin.OnTrigger -= Check;
    }

    private void Check(string _position)
    {
        if (_position == ans)
        {
            okBtns.SetActive(true);
        }
    }
}
