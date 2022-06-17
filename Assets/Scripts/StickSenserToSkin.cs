using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using System;
public class StickSenserToSkin : MonoBehaviour
{
    public LayerMask skinMeshLayer;

    [SerializeField]
    private Transform sensorPoint;

    [SerializeField]
    private float rayDistance = 10;

    //手把長度
    private float stickLength;
    //手把傾斜向量
    private Vector3 alignDir;

    //trigger輸入
    private XRIDefaultInputActions inputRef;
    private InputAction trigger;
    public float checkLength = 10;
    public float checkradius = 0.5f;

    public static event Action<string> OnTrigger;


    private void Start()
    {
        stickLength = (sensorPoint.position - transform.position).magnitude;
    }
    private void Awake()
    {
        inputRef = new XRIDefaultInputActions();
        trigger = inputRef.XRIRightHand.Select;
        trigger.Enable();
        trigger.performed += Activate;
    }

    private void OnDestroy()
    {
        trigger.Disable();
    }

    private void Activate(InputAction.CallbackContext _act)
    {
        Check();
    }

    [ContextMenu("Check Test")]
    private void Check()
    {
        alignDir = (sensorPoint.position - transform.position).normalized;
        Vector3 _endPos = transform.position + alignDir * checkLength;
        Collider[] res = Physics.OverlapCapsule(transform.position, _endPos, checkradius);
        for (int i = 0; i < res.Length; i++)
        {
            if (res[i].gameObject.tag == "Bad")
            {
                //答對了 UI
                if (res[i].gameObject.name == "cyst")
                {
                    Debug.Log("Cyst");
                    OnTrigger?.Invoke("Cyst");
                    ResultUIManager.instance.SetCorrect("觀察到肝囊腫");
                }
                if (res[i].gameObject.name == "rock")
                {
                    Debug.Log("rock");
                    OnTrigger?.Invoke("rock");
                    ResultUIManager.instance.SetCorrect("觀察到膽結石");
                }
            }
            else {
                OnTrigger?.Invoke("");
            }
        }
    }
    void Update()
    {
        alignDir = (sensorPoint.position - transform.position).normalized;
        Vector3 _rayStart = transform.position - alignDir * rayDistance; //往後退保留ray空間

        RaycastHit hit;

        if (Physics.Raycast(_rayStart, alignDir, out hit, rayDistance * 2, skinMeshLayer))
        {
            Vector3 _stickPoint = hit.point;
            Vector3 _movePoint = _stickPoint - alignDir * stickLength;
            transform.position = _movePoint;
        }
        else
        {
            transform.localPosition = Vector3.zero;
        }



    }
}
