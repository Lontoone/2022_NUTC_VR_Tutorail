using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ResultUIManager : MonoBehaviour
{
    public GameObject resultPanle;
    public static ResultUIManager instance;
    public Text text;
    private Coroutine openUI;
    private void Awake()
    {
        instance = this;
    }


    public void SetCorrect( string _text){
        if (openUI == null) {
            text.text = _text;
            openUI= StartCoroutine(CloseUICoro());
        }
    }

    IEnumerator CloseUICoro() {
        resultPanle.SetActive(true);
        yield return new WaitForSeconds(5);
        resultPanle.SetActive(false);
        openUI = null;
    }
}
