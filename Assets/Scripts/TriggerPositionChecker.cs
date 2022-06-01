using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class TriggerPositionChecker : MonoBehaviour
{

    
    private XRIDefaultInputActions inputRef;
    private InputAction trigger;
    public float checkLength = 10;
    public float checkradius = 0.5f;

    private void Awake()
    {
        inputRef = new XRIDefaultInputActions();
        trigger = inputRef.XRIRightHand.Activate;
        trigger.Enable();
        trigger.performed += Activate;
    }

    private void OnDestroy()
    {
        trigger.Disable();
    }

    private void Activate(InputAction.CallbackContext _act) {
        
        //Collider[] res= Physics.OverlapCapsule(transform.position, )
    }
}
