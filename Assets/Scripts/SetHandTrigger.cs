using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//TEMP �Ȯɸ}��
public class SetHandTrigger : MonoBehaviour
{

    void Start()
    {
        //BoundsSetting boundsSetting = GetComponent<BoundsSetting>();
        FindObjectOfType<ImageDisplayControl>().trigger = gameObject.GetComponent<Collider>();
    }

}
