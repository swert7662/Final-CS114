using UnityEngine;

public class StuffSpawnerRing : MonoBehaviour {

    public int numberOfSpawners;

    public float radius, tiltAngle;

    public StuffSpawner spawnerPrefab;
    public Material[] stuffMaterials;

    void Awake()
    {
        for (int i = 0; i < numberOfSpawners; i++)
        {
            CreateSpawner(i);
        }
    }

    void CreateSpawner(int index)
    {
        Transform rotater = new GameObject("Rotater").transform;
        rotater.SetParent(transform, false);
        //Spawn spawners in an evenly spaced ring
        rotater.localRotation =
            Quaternion.Euler(0f, index * 360f / numberOfSpawners, 0f);

        StuffSpawner spawner = Instantiate<StuffSpawner>(spawnerPrefab);
        spawner.transform.SetParent(rotater, false);
        //Transforms the spawner to the z-radius distance
        spawner.transform.localPosition = new Vector3(0f, 0f, radius);
        //Rotates the angle of the spawner
        spawner.transform.localRotation = Quaternion.Euler(tiltAngle, 0f, 0f);
        //Randomly select material to be used by spawner
        spawner.stuffMaterial = stuffMaterials[index % stuffMaterials.Length];
    }
}
