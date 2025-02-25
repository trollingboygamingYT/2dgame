using UnityEngine;

public class PlayerHealth : MonoBehaviour
{
    public float healthAmount = 100;
    public float maxHealth = 100;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        // Optionally, set the starting health to max health
        healthAmount = maxHealth;
    }

    // Update is called once per frame
    void Update()
    {
        if (healthAmount <= 0)
        {
            Die(); // Call the Die function when health reaches 0
        }
    }

    public void TakeDamage(float damage)
    {
        healthAmount -= damage;
        healthAmount = Mathf.Clamp(healthAmount, 0, maxHealth); // Ensure health stays between 0 and maxHealth
    }

    void Die()
    {
        // Disable the player or trigger death-related logic
        Debug.Log("Player has died");
        // Example: Disable the player object
        gameObject.SetActive(false);
    }

    // Detect collision with an object named "Enemy"
    void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("Enemy"))
        {
            TakeDamage(20); // Take 20 damage when colliding with an enemy
            Debug.Log("Collided with Enemy, Health: " + healthAmount);
        }
    }

    // If you're using triggers instead of collisions:
    // void OnTriggerEnter2D(Collider2D other)
    // {
    //     if (other.gameObject.CompareTag("Enemy"))
    //     {
    //         TakeDamage(20); // Take 20 damage when touching an enemy
    //         Debug.Log("Touched Enemy, Health: " + healthAmount);
    //     }
    // }
}
