using UnityEngine;

public class FPSCounter : MonoBehaviour {
    public int frameRange = 60;

    public int avgFPS { get; private set; }
    public int hiFPS { get; private set; }
    public int loFPS { get; private set; }

    int[] fpsBuffer;
    int fpsBufferIndex;

    void InitializeBuffer()
    {
        if (frameRange <= 0)
        {
            frameRange = 1;
        }
        fpsBuffer = new int[frameRange];
        fpsBufferIndex = 0;
    }

    void UpdateBuffer()
    {
        fpsBuffer[fpsBufferIndex++] = (int)(1f / Time.unscaledDeltaTime);
        if (fpsBufferIndex >= frameRange)
        {
            fpsBufferIndex = 0;
        }
    }

    void CalculateFPS()
    {
        int sum = 0;
        int hi = 0;
        int lo = int.MaxValue;

        for (int i = 0; i < frameRange; i++)
        {
            int fps = fpsBuffer[i];
            sum += fps;
            if (fps > hi)
                hi = fps;
            if (fps < lo)
                lo = fps;
        }
        avgFPS = sum / frameRange;
        hiFPS = hi;
        loFPS = lo;
    }

    private void Update()
    {
        if (fpsBuffer == null || fpsBuffer.Length != frameRange)
        {
            InitializeBuffer();
        }
        UpdateBuffer();
        CalculateFPS();
    }
}
