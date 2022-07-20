using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LookThroughOrganController : MonoBehaviour
{
    private LookThroughOrganControllerUI currentUI;
    //public Image liverEye, garEye;
    //public Color transparent;    
    public LookThroughOrganControllerUI test;
    [ContextMenu("test")]
    private void Test()
    {
        SelectOrgan(test);
    }

    public void SelectOrgan(LookThroughOrganControllerUI _obj)
    {
        if (currentUI != null)
        {
            currentUI.Close();
        }
        if (_obj != null && currentUI != _obj)
        {
            _obj.Open();
            currentUI = _obj;
        }
        else if (currentUI==_obj) {
            currentUI = null;
            _obj.Close();
        }

    }
    
}

public struct OpButtonsGroup {
    public GameObject organ;
    public Image eyeImage;
}


