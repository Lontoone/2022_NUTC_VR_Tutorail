using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UI;

public class ResultUIManager : MonoBehaviour
{
    public GameObject resultPanle;
    public GameObject correctImg, wrongImg;
    public static ResultUIManager instance;
    public Text text;
    private Coroutine openUI;
    private void Awake()
    {
        instance = this;
    }


    public void SetCorrect( string _text){
        if (openUI == null) {
            correctImg.SetActive(true);
            wrongImg.SetActive(false);
            text.text = _text;
            openUI= StartCoroutine(CloseUICoro());
        }
    }

    public void SetWrong(string _text)
    {
        if (openUI == null)
        {
            correctImg.SetActive(false);
            wrongImg.SetActive(true);
            text.text = _text;
            openUI = StartCoroutine(CloseUICoro());
        }
    }

    IEnumerator CloseUICoro() {
        resultPanle.SetActive(true);
        yield return new WaitForSeconds(5);
        resultPanle.SetActive(false);
        openUI = null;
    }

    public void Update()
    {
        if (Keyboard.current.spaceKey.wasReleasedThisFrame)
        {
            SetWrong("µª¿ù¤F");
        }
    }
}
