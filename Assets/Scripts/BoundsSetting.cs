using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoundsSetting : MonoBehaviour
{

    public Collider range;
    private Bounds bounds;
    [SerializeField]
    private Transform moveTarget;
    public bool zUp = false;
    private void Start()
    {
        bounds = range.bounds;
    }

    public Vector2 GetRatio(Vector3 _triggerPos)
    {
        Vector3 _offset = _triggerPos - bounds.min;
        float _x_ratio = _offset.x / bounds.size.x;
        float _z_ratio;
        if (zUp)
        {
            _z_ratio = _offset.z / bounds.size.z;
        }
        else
        {
            _z_ratio = _offset.y / bounds.size.y;
        }

        return new Vector2(_x_ratio, _z_ratio);
    }

    public void MoveTarget(Vector2 _ratio)
    {
        Vector3 realPos;
        if (zUp)
        {
            realPos = new Vector3(
                _ratio.x * bounds.size.x + bounds.min.x,
                moveTarget.position.y,
                _ratio.y * bounds.size.y + bounds.min.z);
        }
        else
        {
            realPos = new Vector3(
                _ratio.x * bounds.size.x + bounds.min.x,
                _ratio.y * bounds.size.y + bounds.min.y,
                moveTarget.position.z);
        }
        moveTarget.position = realPos;
    }
}
