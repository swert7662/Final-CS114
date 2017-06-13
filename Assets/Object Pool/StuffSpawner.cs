using UnityEngine;

public class StuffSpawner : MonoBehaviour {

    [System.Serializable]
    public struct FloatRange{
        public float min, max;

        public float RandomInRange{
            get{
                return Random.Range(min, max);
            }
        }
    }

    public FloatRange timeBetweenSpawns, scale, randomVelocity, angularVelocity;
    public float velocity;

    public Stuff[] stuffPrefabs;
    public Material stuffMaterial;

    float timeSinceLastSpawn;
    float currentSpawnDelay;

    void FixedUpdate(){
        timeSinceLastSpawn += Time.deltaTime;
        if (timeSinceLastSpawn >= currentSpawnDelay){
            timeSinceLastSpawn -= currentSpawnDelay;
            currentSpawnDelay = timeBetweenSpawns.RandomInRange;
            SpawnStuff();
        }
    }


    void SpawnStuff(){
        //Get a random prefab
        Stuff prefab = stuffPrefabs[Random.Range(0, stuffPrefabs.Length)];
        //Spawn based on randomly selected prefab
        Stuff spawn = prefab.GetPooledInstance<Stuff>();
        //Set starting position to that of spawner
        spawn.transform.localPosition = transform.position;
        //Random scaled spawn
        spawn.transform.localScale = Vector3.one * scale.RandomInRange;
        //Random rotated spawn
        spawn.transform.localRotation = Random.rotation;

        //Additional velocity added in random direction and angle
        spawn.Body.velocity = transform.up * velocity +
            Random.onUnitSphere * randomVelocity.RandomInRange;
        spawn.Body.angularVelocity =
            Random.onUnitSphere * angularVelocity.RandomInRange;

        //Give spawn a colored material
        //spawn.GetComponent<MeshRenderer>().material = stuffMaterial;
        spawn.SetMaterial(stuffMaterial);

    }
}
