Shader "Custom/Cube Map Shader"{
	Properties{
		_Tint("Tint", Color) = (1, 1, 1, 1)
		_CubeMap("Cube Map", Cube) = "white" {}
	}

	Subshader{

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			samplerCUBE _CubeMap;

			struct v2f {
				float4 pos : SV_Position;
				half3 uv : TEXCOORD0;
			};

			v2f vert(appdata_img v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.vertex.xyz * half3(-1,1,1); // mirror so cubemap projects as expected
				return o;
			}

			fixed4 frag(v2f i) : SV_Target{
				return texCUBE(_CubeMap, i.uv);
			}
		ENDCG
		}

	}
}
