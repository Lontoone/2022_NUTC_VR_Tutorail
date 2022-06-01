using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ImageDisplayControl : MonoBehaviour
{
    public Collider trigger;

    public BoundsSetting bodyBounds;
    public BoundsSetting ImageBounds;

    private void Update()
    {
        if (trigger != null &&
            trigger.bounds.Intersects(bodyBounds.range.bounds))
        {
            Vector2 _offset_ratio = bodyBounds.GetRatio(trigger.transform.position);
            ImageBounds.MoveTarget(_offset_ratio);

        }
    }
}
