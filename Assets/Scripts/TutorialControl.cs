using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TutorialControl : MonoBehaviour
{
    public GameObject[] panels;
    private int page = 0;

    public void MovePage(int opt)
    {
        panels[page].SetActive(false);
        page = Mathf.Clamp(page + opt, 0, panels.Length - 1);
        panels[page].SetActive(true);
    }

    private void Start()
    {
        //StickSenserToSkin.OnTrigger += Check;
        for (int i=1;i<panels.Length;i++) {
            panels[i].SetActive(false);
        }
    }

    public void MoveToPage(int pageIndex) {
        panels[page].SetActive(false);
        page = pageIndex;
        panels[pageIndex].SetActive(true);

    }

#if UNITY_EDITOR
    /*
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space)) {
            MovePage(1);
        }
    }
    */
    [ContextMenu("Move Page")]
    public void TestMovePage() {
        MovePage(1);
    }
#endif

    private void OnDestroy()
    {
        //StickSenserToSkin.OnTrigger -= Check;
    }
    /*
    private void Check(string _position)
    {
        if (_position == "Cyst")
        {

        }
        else if (_position == "rock")
        {

        }
    }*/
    // TODO: Quest correct
}
