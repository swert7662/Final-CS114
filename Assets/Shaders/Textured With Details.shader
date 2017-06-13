﻿Shader "Custom/Textured With Details"{
	Properties{
		_Tint("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Texture", 2D) = "white" {}
		_DetailTex("Detail Texture", 2D) = "gray" {}
	}

	Subshader{

		Pass {
			CGPROGRAM

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "UnityCG.cginc"

			float4 _Tint;

			sampler2D _MainTex, _DetailTex;
			float4 _MainTex_ST, _DetailTex_ST;

			struct Interpolators {
				float4 position : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 uvDetail : TEXCOORD1;
			};

			struct VertexData {
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};
			//Vert program transforms model vertices to screen space
			Interpolators MyVertexProgram(VertexData v) {
				Interpolators i;
				i.position = mul(UNITY_MATRIX_MVP, v.position);
				//i.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw; //change to UnityCG.cginc macro
				i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				i.uvDetail = TRANSFORM_TEX(v.uv, _DetailTex);
				return i;
			}
			//Frag program colors pixels on screen
			float4 MyFragmentProgram(Interpolators i) : SV_TARGET{
				float4 color = tex2D(_MainTex, i.uv) * _Tint;
				color *= tex2D(_DetailTex, i.uvDetail) * unity_ColorSpaceDouble; //Uniform change based on color space
				return color;
			}

			ENDCG
		}

	}
}
