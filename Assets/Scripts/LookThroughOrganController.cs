using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LookThroughOrganController : MonoBehaviour
{
    private GameObject currentObj;

    public void SelectOrgan(GameObject _obj)
    {
        if (currentObj != null)
        {
            currentObj.SetActive(false);
        }
        if (_obj != null && currentObj != _obj)
            _obj.SetActive(true);
        currentObj = _obj;
    }

    public void ClearAll()
    {
        currentObj.SetActive(false);
    }
}
