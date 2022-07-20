using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LookThroughOrganControllerUI : MonoBehaviour
{
    public Image eye;
    public GameObject orgain;

    public void Open() {
        orgain.SetActive(true);
        eye.color = Color.white;
    }
    public void Close() {
        orgain.SetActive(false);
        eye.color = new Color(0,0,0,0.3f);
    }

}
