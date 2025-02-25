using UnityEngine;
using UnityEngine.UI;

public class HealthHeart : MonoBehaviour
{
    public Sprite fullHeart, slightlyDamage1, slightlyDamage2, damaged1, damaged2, halfDamaged1, halfDamaged2, moreBroken, nearlyBroken, Broken;
    Image heartImage;

    private void Awake()
    {
        heartImage = GetComponent<Image>();
    }

    public void SetHeartImage(HeartStatus status)
    {
        // Adjust the RectTransform to scale correctly
        RectTransform rectTransform = heartImage.GetComponent<RectTransform>();
        rectTransform.localScale = new Vector3(1f, 1f, 1f);  // Ensure scale is set to 1, 1, 1

        // Optionally adjust the size to make it fit perfectly
        rectTransform.sizeDelta = new Vector2(50f, 50f);  // Set this to the desired size for your hearts

        switch (status)
        {
            case HeartStatus.Broken:
                heartImage.sprite = Broken;
                break;
            case HeartStatus.NearlyBroken:
                heartImage.sprite = nearlyBroken;
                break;
            case HeartStatus.MoreBroken1:
                heartImage.sprite = moreBroken;
                break;
            case HeartStatus.halfDamaged2:
                heartImage.sprite = halfDamaged2;
                break;
            case HeartStatus.halfDamaged1:
                heartImage.sprite = halfDamaged1;
                break;
            case HeartStatus.damaged2:
                heartImage.sprite = damaged2;
                break;
            case HeartStatus.damaged1:
                heartImage.sprite = damaged1;  // Fixed the case here
                break;
            case HeartStatus.slightlyDamage2:
                heartImage.sprite = slightlyDamage2;
                break;
            case HeartStatus.slightlyDamage1:
                heartImage.sprite = slightlyDamage1;
                break;
            case HeartStatus.fullHeart:
                heartImage.sprite = fullHeart;
                break;
        }
    }
}

public enum HeartStatus
{
    Broken = 0,
    NearlyBroken = 1,
    MoreBroken2 = 2,
    MoreBroken1 = 3,
    halfDamaged2 = 4,
    halfDamaged1 = 5,
    damaged2 = 6,
    damaged1 = 7,
    slightlyDamage2 = 8,
    slightlyDamage1 = 9,
    fullHeart = 10,
}
