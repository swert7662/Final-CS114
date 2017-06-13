Shader "Custom/My First Lighting Shader"{
	Properties{
		_Tint("Tint", Color) = (1, 1, 1, 1)
		_MainTex("Albedo", 2D) = "white" {}
		[NoScaleOffset] _NormalMap("Normals", 2D) = "bump" {}
		_BumpScale("Bump Scale", Float) = 1
		[NoScaleOffset] _MetallicMap("Metallic", 2D) = "white" {}
		[Gamma] _Metallic("Metallic", Range(0, 1)) = 0
		_Smoothness("Smoothness", Range(0, 1)) = 0.5
		_DetailTex("Detail Albedo", 2D) = "gray" {}
		[NoScaleOffset] _DetailNormalMap("Detail Normals", 2D) = "bump" {}
		_DetailBumpScale("Detail Bump Scale", Float) = 1
		[NoScaleOffset] _EmissionMap("Emission", 2D) = "black" {}
		_Emission("Emission", Color) = (0, 0, 0)
		[NoScaleOffset] _OcclusionMap("Occlusion", 2D) = "white" {}
		_OcclusionStrength("Occlusion Strength", Range(0, 1)) = 1
		[NoScaleOffset] _DetailMask("Detail Mask", 2D) = "white" {}
	}
	CGINCLUDE

		#define BINORMAL_PER_FRAGMENT

	ENDCG
	Subshader{

		Pass {
			Tags{
			"LightMode" = "ForwardBase"
		}
			CGPROGRAM

			#pragma target 3.0
			//Features are optional maps/masks the user can add to materials
			#pragma shader_feature _METALLIC_MAP
			#pragma shader_feature _ _SMOOTHNESS_ALBEDO _SMOOTHNESS_METALLIC
			#pragma shader_feature _OCCLUSION_MAP
			#pragma shader_feature _EMISSION_MAP
			#pragma shader_feature _DETAIL_MASK

			#pragma multi_compile _ VERTEXLIGHT_ON

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#define FORWARD_BASE_PASS

			#include "My Lighting.cginc"
			
			ENDCG
		}
		//Second Pass for additional lights
		Pass{
			Tags{
				"LightMode" = "ForwardAdd"
			}
			
			Blend One One	//Makes the render add light instead of replace, default is One Zero	
			ZWrite Off //Doesnt need to write to the depth buffer again, first pass did
			CGPROGRAM

			#pragma target 3.0

			#pragma shader_feature _METALLIC_MAP
			#pragma shader_feature _ _SMOOTHNESS_ALBEDO _SMOOTHNESS_METALLIC
			#pragma shader_feature _DETAIL_MASK
			//#pragma multi_compile DIRECTIONAL DIRECTIONAL_COOKIE POINT SPOT
			#pragma multi_compile_fwdadd

			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			#include "My Lighting.cginc"

			ENDCG
		}
	}
	CustomEditor "MyLightingShaderGUI"
}
