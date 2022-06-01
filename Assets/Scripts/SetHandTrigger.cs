using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//TEMP ¼È®É¸}¥»
public class SetHandTrigger : MonoBehaviour
{

    void Start()
    {
        //BoundsSetting boundsSetting = GetComponent<BoundsSetting>();
        FindObjectOfType<ImageDisplayControl>().trigger = gameObject.GetComponent<Collider>();
    }

}
