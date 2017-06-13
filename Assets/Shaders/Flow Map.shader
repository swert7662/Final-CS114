Shader "Custom/Flow Map"{
	Properties{
		_MainTex("Albedo", 2D) = "white" {}
		_Color("Tint", Color) = (1,1,1,1)
		_FlowMap("Flow Map", 2D) = "white" {}
		_FlowSpeed("Flow Speed", float) = 0.1
	}

	SubShader{
		Pass{
			CGPROGRAM
			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram
			#include "UnityCG.cginc"

			float4 _Color;
			sampler2D _MainTex;
			sampler2D _FlowMap;
			float _FlowSpeed;

			struct VertexData {
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 uv : TEXCOORD0;
			};

			struct Interpolators {
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
				half2 uv : TEXCOORD0;
			};

			Interpolators MyVertexProgram(VertexData v){
				Interpolators i;
				i.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				i.uv = v.uv;
				i.color = v.color * _Color;
				return i;
			}

			float4 MyFragmentProgram(Interpolators i) : SV_Target{
				//Calculate flow direction with flow map
				float3 flowDir = tex2D(_FlowMap, i.uv) * 2.0f - 1.0f;
				flowDir *= _FlowSpeed;
				//Phases offset by .5
				float phase1 = frac(_Time[1] * 0.5f + 0.5f);
				float phase2 = frac(_Time[1] * 0.5f + 1.0f);
				//Update start/end positions based on phases
				float3 start = tex2D(_MainTex, i.uv + flowDir.xy * phase1);
				float3 end = tex2D(_MainTex, i.uv + flowDir.xy * phase2);
				//Create the interpolant for lerp function
				float flowLerp = abs((0.5f - phase1) / 0.5f);
				//Update position between start and end
				float3 flow = lerp(start, end, flowLerp);
				//Color based on updated position
				float4 color = float4(flow, 1.0f) * i.color;
				color.rgb *= color.a;
				return color;
			}
		ENDCG
		}
	}
}
