///////////////////////////////////////////////////////////////////////////////////
//
// Mount&Blade Warband Shaders
// You can add edit main shaders and lighting system with this file.
// You cannot change fx_configuration.h file since it holds application dependent 
// configration parameters. Sorry its not well documented. 
// Please send your feedbacks to our forums.
//
// All rights reserved.
// www.taleworlds.com
//
//
///////////////////////////////////////////////////////////////////////////////////
// compile_fx.bat:
// ------------------------------
// @echo off
// fxc /D PS_2_X=ps_2_a /T fx_2_0 /Fo mb_2a.fxo mb.fx
// fxc /D PS_2_X=ps_2_b /T fx_2_0 /Fo mb_2b.fxo mb.fx
// pause>nul
///////////////////////////////////////////////////////////////////////////////////


#if !defined (PS_2_X)
	#error "define high quality shader profile: PS_2_X ( ps_2_b or ps_2_a )"
#endif

#include "fx_configuration.h"	// source code dependent configration definitions..
//#include "common_functions.h"	// source code dependent configration definitions..

////////////////////////////////////////////////////////////////////////////////
//definitions: 
#define NUM_LIGHTS					10
#define NUM_SIMUL_LIGHTS			4
#define NUM_WORLD_MATRICES			32

#define PCF_NONE					0
#define PCF_DEFAULT					1
#define PCF_NVIDIA					2


#define INCLUDE_VERTEX_LIGHTING
#define VERTEX_LIGHTING_SCALER   0.5f	//used for diffuse calculation
#define VERTEX_LIGHTING_SPECULAR_SCALER   1.0f

#define USE_PRECOMPILED_SHADER_LISTS


//put this to un-reachable code blocks..
#define GIVE_ERROR_HERE {for(int i = 0; i < 1000; i++)		{Output.RGBColor *= Output.RGBColor;}}
#define GIVE_ERROR_HERE_VS {for(int i = 0; i < 1000; i++)		{Out.Pos *= Out.Pos;}}

//#define NO_GAMMA_CORRECTIONS

#ifdef NO_GAMMA_CORRECTIONS
	#define INPUT_TEX_GAMMA(col_rgb) (col_rgb) = (col_rgb)
	#define INPUT_OUTPUT_GAMMA(col_rgb) (col_rgb) = (col_rgb)
	#define OUTPUT_GAMMA(col_rgb) (col_rgb) = (col_rgb)
#else
	#define INPUT_TEX_GAMMA(col_rgb) (col_rgb) = pow((col_rgb), input_gamma.x) 
	#define INPUT_OUTPUT_GAMMA(col_rgb) (col_rgb) = pow((col_rgb), output_gamma.x) 
	#define OUTPUT_GAMMA(col_rgb) (col_rgb) = pow((col_rgb), output_gamma_inv.x) 
#endif
	
#ifdef DONT_INIT_OUTPUTS
	#pragma warning( disable : 4000)
	#define INITIALIZE_OUTPUT(structure, var)	structure var;
#else
	#define INITIALIZE_OUTPUT(structure, var)	structure var = (structure)0;
#endif

#pragma warning( disable : 3571)	//pow(f,e)


//Categories..
#define OUTPUT_STRUCTURES
#define FUNCTIONS

//Constant categories
#define PER_MESH_CONSTANTS
#define PER_FRAME_CONSTANTS
#define PER_SCENE_CONSTANTS
#define APPLICATION_CONSTANTS

//Shader categories
#define MISC_SHADERS
#define UI_SHADERS
#define SHADOW_RELATED_SHADERS
#define WATER_SHADERS
#define SKYBOX_SHADERS
#define HAIR_SHADERS
#define FACE_SHADERS
#define FLORA_SHADERS
#define MAP_SHADERS
#define SOFT_PARTICLE_SHADERS
#define STANDART_SHADERS
#define STANDART_RELATED_SHADER
#define OCEAN_SHADERS
#ifdef USE_NEW_TREE_SYSTEM
#define NEWTREE_SHADERS
#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef PER_MESH_CONSTANTS
	float4x4 matWorldViewProj;		// Matrix used to convert from Local to World to View to Projection Space
	float4x4 matWorldView;			// Matrix used to convert from Local to World to View Space
	float4x4 matWorld;				// Matrix used to convert from Local to World Space

	float4x4 matWaterWorldViewProj;
	float4x4 matWorldArray[NUM_WORLD_MATRICES] : WORLDMATRIXARRAY;
	//float4   matBoneOriginArray[NUM_WORLD_MATRICES];

	float4 vMaterialColor = float4(255.f/255.f, 230.f/255.f, 200.f/255.f, 1.0f);
	float4 vMaterialColor2;
	float fMaterialPower = 16.f;
	float4 vSpecularColor = float4(5, 5, 5, 5);
	float4 texture_offset = {0,0,0,0};

	int iLightPointCount;
	int	   iLightIndices[NUM_SIMUL_LIGHTS] = { 0, 1, 2, 3};
	
	bool bUseMotionBlur = false;
	float4x4 matMotionBlur;
#endif

////////////////////////////////////////
#ifdef PER_FRAME_CONSTANTS
	float time_var = 0.0f;
	float4x4 matWaterViewProj;
#endif

////////////////////////////////////////
#ifdef PER_SCENE_CONSTANTS
	float fFogDensity = 0.05f;
	float fRainSpecular = 0.0f;
	//float fBloodDarken = 0.75f;
	int fCursorVisible = 1;

	float3 vSkyLightDir;
	float4 vSkyLightColor;
	float3 vSunDir;
	float4 vSunColor;
	
	float4 vAmbientColor = float4(64.f/255.f, 64.f/255.f, 64.f/255.f, 0.5f);
	float4 vGroundAmbientColor = float4(84.f/255.f, 44.f/255.f, 54.f/255.f, 0.7f);

	float4 vCameraPos;
	float4x4 matSunViewProj;
	float4x4 matView;
	float4x4 matViewProj;
	
	float3 vLightPosDir[NUM_LIGHTS];
	float4 vLightDiffuse[NUM_LIGHTS];
	float4 vPointLightColor;	//agerage color of lights
	
	float reflection_factor;
	
#endif

////////////////////////////////////////
#ifdef APPLICATION_CONSTANTS
	bool use_depth_effects = false;
	float far_clip_Inv;
	float4 vDepthRT_HalfPixel_ViewportSizeInv;

	float fShadowMapNextPixel = 1.0f / 4096;
	float fShadowMapSize = 4096;

	static const float input_gamma = 2.2f;
	float4 output_gamma = float4(2.2f, 2.2f, 2.2f, 2.2f);			//STR: float4 yapyldy
	float4 output_gamma_inv = float4(1.0f / 2.2f, 1.0f / 2.2f, 1.0f / 2.2f, 1.0f / 2.2f);
	
	int bNightVision = 0;
	int bReticleOffset = 0;
	int bDirectionalOffset = 0;
	
	/*
	float4 bTopReticleColor = float4(0, 0, 1, 1);
	float4 bRightReticleColor = float4(0, 1, 0, 1);
	float4 bLeftReticleColor = float4(1, 0, 0, 1);
	*/

	float4 debug_vector = {0,0,0,1};
	
	float spec_coef = 1.0f;	//valid value after module_data!
	
	
	static const float map_normal_detail_factor = 1.4f;
	static const float uv_2_scale = 1.237;
	static const float fShadowBias = 0.00002f;//-0.000002f;
	
	#ifdef USE_NEW_TREE_SYSTEM
		float flora_detail = 40.0f;
		#define flora_detail_fade 		(flora_detail*FLORA_DETAIL_FADE_MUL)
		#define flora_detail_fade_inv 	(flora_detail-flora_detail_fade)
		#define flora_detail_clip 		(max(0,flora_detail_fade - 20.0f))
	#endif

#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Texture&Samplers
#if defined(USE_SHARED_DIFFUSE_MAP) || !defined(USE_DEVICE_TEXTURE_ASSIGN)
	texture diffuse_texture;
#endif

#ifndef USE_DEVICE_TEXTURE_ASSIGN
	texture diffuse_texture_2;
	texture specular_texture;
	texture normal_texture;
	texture env_texture;
	texture shadowmap_texture;

	texture cubic_texture;
	
	texture depth_texture;
	texture screen_texture;

	#ifdef USE_REGISTERED_SAMPLERS
	sampler ReflectionTextureSampler 	: register(fx_ReflectionTextureSampler_RegisterS 		) = sampler_state	{  Texture = env_texture;		}; 
	sampler EnvTextureSampler			: register(fx_EnvTextureSampler_RegisterS				) = sampler_state	{  Texture = env_texture;		}; 
	sampler Diffuse2Sampler 			: register(fx_Diffuse2Sampler_RegisterS 				) = sampler_state	{  Texture = diffuse_texture_2;	}; 
	sampler NormalTextureSampler		: register(fx_NormalTextureSampler_RegisterS			) = sampler_state	{  Texture = normal_texture;	}; 
	sampler SpecularTextureSampler 		: register(fx_SpecularTextureSampler_RegisterS 			) = sampler_state	{  Texture = specular_texture;	}; 
	sampler DepthTextureSampler 		: register(fx_DepthTextureSampler_RegisterS 			) = sampler_state	{  Texture = depth_texture;	    }; 
	sampler CubicTextureSampler 		: register(fx_CubicTextureSampler_RegisterS 			) = sampler_state	{  Texture = cubic_texture;	    }; 
	sampler ShadowmapTextureSampler 	: register(fx_ShadowmapTextureSampler_RegisterS 		) = sampler_state	{  Texture = shadowmap_texture;	};
	sampler ScreenTextureSampler 		: register(fx_ScreenTextureSampler_RegisterS			) = sampler_state	{  Texture = screen_texture;	};
	sampler MeshTextureSampler 			: register(fx_MeshTextureSampler_RegisterS 				) = sampler_state	{  Texture = diffuse_texture;	}; 
	sampler ClampedTextureSampler 		: register(fx_ClampedTextureSampler_RegisterS 			) = sampler_state	{  Texture = diffuse_texture;	}; 
	sampler FontTextureSampler 			: register(fx_FontTextureSampler_RegisterS 				) = sampler_state	{  Texture = diffuse_texture;	}; 
	sampler CharacterShadowTextureSampler:register(fx_CharacterShadowTextureSampler_RegisterS	) = sampler_state	{  Texture = diffuse_texture;	}; 
	sampler MeshTextureSamplerNoFilter 	: register(fx_MeshTextureSamplerNoFilter_RegisterS 		) = sampler_state	{  Texture = diffuse_texture;	}; 
	sampler DiffuseTextureSamplerNoWrap : register(fx_DiffuseTextureSamplerNoWrap_RegisterS 	) = sampler_state	{  Texture = diffuse_texture;	};
	sampler GrassTextureSampler 		: register(fx_GrassTextureSampler_RegisterS 			) = sampler_state	{  Texture = diffuse_texture;	}; 
	#else 
	
	
	sampler ReflectionTextureSampler 	= sampler_state	{  Texture = env_texture;		AddressU = CLAMP; AddressV = CLAMP; MinFilter = LINEAR; MagFilter = LINEAR;	}; 
	sampler EnvTextureSampler			= sampler_state	{  Texture = env_texture;		AddressU = WRAP;  AddressV = WRAP;  MinFilter = LINEAR; MagFilter = LINEAR;	}; 
	sampler Diffuse2Sampler 			= sampler_state	{  Texture = diffuse_texture_2;	AddressU = WRAP; AddressV = WRAP; MinFilter = LINEAR; MagFilter = LINEAR;	}; 
	sampler NormalTextureSampler		= sampler_state	{  Texture = normal_texture;	AddressU = WRAP; AddressV = WRAP; MinFilter = LINEAR; MagFilter = LINEAR;	}; 
	sampler SpecularTextureSampler 		= sampler_state	{  Texture = specular_texture;	AddressU = WRAP; AddressV = WRAP; MinFilter = LINEAR; MagFilter = LINEAR;	}; 
	sampler DepthTextureSampler 		= sampler_state	{  Texture = depth_texture;		AddressU = CLAMP; AddressV = CLAMP; MinFilter = LINEAR; MagFilter = LINEAR;    }; 
	sampler CubicTextureSampler 		= sampler_state	{  Texture = cubic_texture;	 	AddressU = CLAMP; AddressV = CLAMP; MinFilter = LINEAR; MagFilter = LINEAR;   }; 
	sampler ShadowmapTextureSampler 	= sampler_state	{  Texture = shadowmap_texture;	AddressU = CLAMP; AddressV = CLAMP; MinFilter = NONE; MagFilter = NONE;	};
	sampler ScreenTextureSampler 		= sampler_state	{  Texture = screen_texture;	AddressU = CLAMP; AddressV = CLAMP; MinFilter = LINEAR; MagFilter = LINEAR;	};
	sampler MeshTextureSampler 			= sampler_state	{  Texture = diffuse_texture;	AddressU = WRAP; AddressV = WRAP; MinFilter = LINEAR; MagFilter = LINEAR;	}; 
	sampler ClampedTextureSampler 		= sampler_state	{  Texture = diffuse_texture;	AddressU = CLAMP; AddressV = CLAMP; MinFilter = LINEAR; MagFilter = LINEAR;	}; 
	sampler FontTextureSampler 			= sampler_state	{  Texture = diffuse_texture;	AddressU = WRAP; AddressV = WRAP; MinFilter = LINEAR; MagFilter = LINEAR;	}; 
	sampler CharacterShadowTextureSampler= sampler_state	{  Texture = diffuse_texture;	AddressU = BORDER; AddressV = BORDER; MinFilter = LINEAR; MagFilter = LINEAR;	}; 
	sampler MeshTextureSamplerNoFilter 	= sampler_state	{  Texture = diffuse_texture;	AddressU = WRAP; AddressV = WRAP; MinFilter = NONE; MagFilter = NONE;	}; 
	sampler DiffuseTextureSamplerNoWrap = sampler_state	{  Texture = diffuse_texture;	AddressU = CLAMP; AddressV = CLAMP; MinFilter = LINEAR; MagFilter = LINEAR;	};
	sampler GrassTextureSampler 		= sampler_state	{  Texture = diffuse_texture;	AddressU = CLAMP; AddressV = CLAMP; MinFilter = LINEAR; MagFilter = LINEAR;	}; 
	
	#endif
	
#else 

	sampler ReflectionTextureSampler 	: register(fx_ReflectionTextureSampler_RegisterS 		); 
	sampler EnvTextureSampler			: register(fx_EnvTextureSampler_RegisterS				); 
	sampler Diffuse2Sampler 			: register(fx_Diffuse2Sampler_RegisterS 				); 
	sampler NormalTextureSampler		: register(fx_NormalTextureSampler_RegisterS			); 
	sampler SpecularTextureSampler 		: register(fx_SpecularTextureSampler_RegisterS 			); 
	sampler DepthTextureSampler 		: register(fx_DepthTextureSampler_RegisterS 			);  
	sampler DepthTextureSampler 		: register(fx_CubicTextureSampler_RegisterS 			);
	sampler ShadowmapTextureSampler 	: register(fx_ShadowmapTextureSampler_RegisterS 		);
	sampler ScreenTextureSampler 		: register(fx_ScreenTextureSampler_RegisterS			);
		
	#ifdef USE_SHARED_DIFFUSE_MAP
		sampler MeshTextureSampler 			: register(fx_MeshTextureSampler_RegisterS 				) = sampler_state	{  Texture = diffuse_texture;	}; 
		sampler ClampedTextureSampler 		: register(fx_ClampedTextureSampler_RegisterS 			) = sampler_state	{  Texture = diffuse_texture;	}; 
		sampler FontTextureSampler 			: register(fx_FontTextureSampler_RegisterS 				) = sampler_state	{  Texture = diffuse_texture;	}; 
		sampler CharacterShadowTextureSampler:register(fx_CharacterShadowTextureSampler_RegisterS	) = sampler_state	{  Texture = diffuse_texture;	}; 
		sampler MeshTextureSamplerNoFilter 	: register(fx_MeshTextureSamplerNoFilter_RegisterS 		) = sampler_state	{  Texture = diffuse_texture;	}; 
		sampler DiffuseTextureSamplerNoWrap : register(fx_DiffuseTextureSamplerNoWrap_RegisterS 	) = sampler_state	{  Texture = diffuse_texture;	};
		sampler GrassTextureSampler 		: register(fx_GrassTextureSampler_RegisterS 			) = sampler_state	{  Texture = diffuse_texture;	}; 
	#else   
		sampler MeshTextureSampler 			: register(fx_MeshTextureSampler_RegisterS 				); 
		sampler ClampedTextureSampler 		: register(fx_ClampedTextureSampler_RegisterS 			); 
		sampler FontTextureSampler 			: register(fx_FontTextureSampler_RegisterS 				); 
		sampler CharacterShadowTextureSampler:register(fx_CharacterShadowTextureSampler_RegisterS	); 
		sampler MeshTextureSamplerNoFilter 	: register(fx_MeshTextureSamplerNoFilter_RegisterS 		); 
		sampler DiffuseTextureSamplerNoWrap : register(fx_DiffuseTextureSamplerNoWrap_RegisterS 	);
		sampler GrassTextureSampler 		: register(fx_GrassTextureSampler_RegisterS 			); 
	#endif
#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef OUTPUT_STRUCTURES

struct PS_OUTPUT
{
	float4 RGBColor : COLOR;
};

#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef FUNCTIONS
float GetSunAmount(uniform const int PcfMode, float4 ShadowTexCoord, float2 ShadowTexelPos)
{
	float sun_amount;
	if (PcfMode == PCF_NVIDIA)
	{
		//sun_amount = tex2D(ShadowmapTextureSampler, ShadowTexCoord).r;
		sun_amount = tex2Dproj(ShadowmapTextureSampler, ShadowTexCoord).r;
	}
	else
	{
		float2 lerps = frac(ShadowTexelPos);
		//read in bilerp stamp, doing the shadow checks
		float sourcevals[4];
		sourcevals[0] = (tex2D(ShadowmapTextureSampler, ShadowTexCoord).r < ShadowTexCoord.z)? 0.0f: 1.0f;
		sourcevals[1] = (tex2D(ShadowmapTextureSampler, ShadowTexCoord + float2(fShadowMapNextPixel, 0)).r < ShadowTexCoord.z)? 0.0f: 1.0f;
		sourcevals[2] = (tex2D(ShadowmapTextureSampler, ShadowTexCoord + float2(0, fShadowMapNextPixel)).r < ShadowTexCoord.z)? 0.0f: 1.0f;
		sourcevals[3] = (tex2D(ShadowmapTextureSampler, ShadowTexCoord + float2(fShadowMapNextPixel, fShadowMapNextPixel)).r < ShadowTexCoord.z)? 0.0f: 1.0f;

		// lerp between the shadow values to calculate our light amount
		sun_amount = lerp(lerp(sourcevals[0], sourcevals[1], lerps.x), lerp(sourcevals[2], sourcevals[3], lerps.x), lerps.y);
	}
	return sun_amount;
}

float4 playstationify(float4 vPos)
{
	
	int vRes = 120;
	int hRes = 160;
	
	float4 projection = mul(matWorldViewProj, vPos);
	
	float4 vertex = projection;
	vertex.xyz = projection.xyz / projection.w;
	vertex.x = floor(hRes * vertex.x) / hRes;
	vertex.y = floor(vRes * vertex.y) / vRes;
	vertex.xyz *= projection.w;
	
	if(vertex.w > 0)
		vertex /= vertex.w;
	
	return vertex;
}

float3 flashlight(float distance, float3 viewDir, float3 worldNormal, float falloff = 1)
{
	
	float atten = saturate(falloff / distance); // Determine Light Attenuation (falloff by distance)
	//float3 camDir = matView[0];					// This matrix holds the base camera direction inside the index 0.
	//camDir.x *= -1;								// Flip the Y and swap x and y to rotate it 90 degrees i.e. camDir.yxz
	
	float3 camDir = matView[2];					// This matrix holds the transformed camera direction inside the index 2.
	
	float lightCone = saturate(dot(normalize(viewDir), normalize(camDir)));		// Basically does a cone based on Camera's facing
	lightCone = pow(lightCone, 15);													// This tightens the cone angle
    float3 flashlight = saturate(saturate(dot(camDir, worldNormal))) * atten * lightCone;	// You could tint the light by multiplying it by a color here
	
	return flashlight;
}

////////////////////////////////////////
float get_fog_amount(float d)
{
	//return 1/(d * fFogDensity * 20);
	//   return saturate((fFogEnd - d) / (fFogEnd - fFogStart));
	return 1.0f / exp2(d * fFogDensity);
	//return 1.0f / exp ((d * fFogDensity) * (d * fFogDensity));
}

float get_fog_amount_new(float d, float wz)
{
	
	wz = max(wz, 0.05f);
	float valleys = pow(wz, -1);
	
	//you can implement world.z based algorithms here
	return get_fog_amount(4 * d * fFogDensity + (valleys * d * d * fFogDensity));
}

float get_fog_amount_map(float d, float wz)
{
	wz = max(wz, 0.05f);
	float valleys = pow(wz, -1);
	//you can implement world.z based algorithms here
	return get_fog_amount(3 * d * fFogDensity + (valleys * d * 2 * fFogDensity));
}

////////////////////////////////////////
static const float2 specularShift = float2(0.138 - 0.5, 0.254 - 0.5);
static const float2 specularExp = float2(256.0, 32.0)*0.7;
static const float3 specularColor0 = float3(0.9, 1.0, 1.0)*0.898 * 0.99;
static const float3 specularColor1 = float3(1.0, 0.9, 1.0)*0.74 * 0.99;

float HairSingleSpecularTerm(float3 T, float3 H, float exponent)
{
    float dotTH = dot(T, H);
    float sinTH = sqrt(1.0 - dotTH*dotTH);
    return pow(sinTH, exponent);
}

float3 ShiftTangent(float3 T, float3 N, float shiftAmount)
{
    return normalize(T + shiftAmount * N);
}

float3 calculate_hair_specular(float3 normal, float3 tangent, float3 lightVec, float3 viewVec, float2 tc)
{
	// shift tangents
	float shiftTex = tex2D(Diffuse2Sampler, tc).a;
	
	float3 T1 = ShiftTangent(tangent, normal, specularShift.x + shiftTex);
	float3 T2 = ShiftTangent(tangent, normal, specularShift.y + shiftTex);

	float3 H = normalize(lightVec + viewVec);
	float3 specular = vSunColor * specularColor0 * HairSingleSpecularTerm(T1, H, specularExp.x);
	float3 specular2 = vSunColor * specularColor1 * HairSingleSpecularTerm(T2, H, specularExp.y);
	float specularMask = tex2D(Diffuse2Sampler, tc * 10.0f).a;	// modulate secondary specular term with noise
	specular2 *= specularMask;
	float specularAttenuation = saturate(1.75 * dot(normal, lightVec) + 0.25);
	specular = (specular + specular2) * specularAttenuation;
	
	return specular;
}

float HairDiffuseTerm(float3 N, float3 L)
{
    return saturate(0.75 * dot(N, L) + 0.25);
}

float face_NdotL(float3 n, float3 l) 
{

	float wNdotL = dot(n.xyz, l.xyz);
	return saturate(max(0.2f * (wNdotL + 0.9f),wNdotL));
}

float4 calculate_point_lights_diffuse(const float3 vWorldPos, const float3 vWorldN, const bool face_like_NdotL, const bool exclude_0) 
{
	const int exclude_index = 0;
	
	float4 total = 0;
	for(int j = 0; j < iLightPointCount; j++)
	{
		if(!exclude_0 || j != exclude_index)
		{
			int i = iLightIndices[j];
			float3 point_to_light = vLightPosDir[i]-vWorldPos;
			float LD = dot(point_to_light, point_to_light);
			float3 L = normalize(point_to_light);
			float wNdotL = dot(vWorldN, L);
			
			float fAtten = VERTEX_LIGHTING_SCALER / LD;
			//compute diffuse color
			if(face_like_NdotL) {
				total += max(0.2f * (wNdotL + 0.9f), wNdotL) * vLightDiffuse[i] * fAtten;
			}
			else {
				total += saturate(wNdotL) * vLightDiffuse[i] * fAtten;
	}
		}
	}
	return total;
}

float4 calculate_point_lights_specular(const float3 vWorldPos, const float3 vWorldN, const float3 vWorldView, const bool exclude_0)
{
	//const int exclude_index = 0;
	
	float4 total = 0;
	for(int i = 0; i < iLightPointCount; i++)
	{
		//if(!exclude_0 || j != exclude_index)	//commenting out exclude_0 will introduce double effect of light0, but prevents loop bug of fxc
		{
			//int i = iLightIndices[j];
			float3 point_to_light = vLightPosDir[i]-vWorldPos;
			float LD = dot(point_to_light, point_to_light);
			float3 L = normalize(point_to_light);
					
			float fAtten = VERTEX_LIGHTING_SPECULAR_SCALER / LD;
				
			float3 vHalf = normalize( vWorldView + L );
			total += fAtten * vLightDiffuse[i] * pow( saturate(dot(vHalf, vWorldN)), fMaterialPower); 
		}
	}
	return total;
}


float4 get_ambientTerm( int ambientTermType, float3 normal, float3 DirToSky, float sun_amount )
{
	float4 ambientTerm;
	if(ambientTermType == 0)	//constant
	{
		ambientTerm = vAmbientColor;
	}
	else if(ambientTermType == 1)	//hemisphere
	{
		float4 g_vGroundColorTEMP = vGroundAmbientColor * sun_amount;
		float4 g_vSkyColorTEMP = vAmbientColor;
		
		float lerpFactor = (dot(normal, DirToSky) + 1.0f) * 0.5f;
		
		float4 hemiColor = lerp( g_vGroundColorTEMP, g_vSkyColorTEMP, lerpFactor);
		ambientTerm = hemiColor;
	}
	else //if(ambientTermType == 2)	//ambient cube 
	{
		float4 cubeColor = texCUBE(CubicTextureSampler, normal);
		ambientTerm = vAmbientColor * cubeColor;
	}
	return ambientTerm;
}

float4x4 build_instance_frame_matrix(float3 vInstanceData0, float3 vInstanceData1, float3 vInstanceData2, float3 vInstanceData3) 
{
	const float3 position = vInstanceData0.xyz;
	//const float  scale = vInstanceData0.w;
	
	
	float3 frame_s = vInstanceData1;
	float3 frame_f = vInstanceData2;
	float3 frame_u = vInstanceData3;//cross(frame_s, frame_f);;
	
	float4x4 matWorldOfInstance  = {float4(frame_s.x, frame_f.x, frame_u.x, position.x ), 
									float4(frame_s.y, frame_f.y, frame_u.y, position.y ), 
									float4(frame_s.z, frame_f.z, frame_u.z, position.z ), 
									float4(0.0f, 0.0f, 0.0f, 1.0f )  };

	return matWorldOfInstance;
}

//dstn Flat Map Experiment

float anime_smoothstep(float smoothValue)
{
	
	float anime_smooth = smoothstep(0.35, 0.50, smoothValue);
	
	/* So that I don't have to hunt around and replaces
	the smoothstep values in all the eight or so entires
	I declare this function that does nothing but a fixed
	variant of smoothstep and you can declare offsets for
	min and max so you can blend textures or normals at 
	a different pace than you might use for flattening or the like*/
	
	return anime_smooth;
}

float map_smoothstep(float smoothValue, float offset_min = 0, float offset_max = 0)
{
	
	float map_smooth = smoothstep(15 + offset_min, 40 + offset_max, smoothValue);
	
	/* So that I don't have to hunt around and replaces
	the smoothstep values in all the eight or so entires
	I declare this function that does nothing but a fixed
	variant of smoothstep and you can declare offsets for
	min and max so you can blend textures or normals at 
	a different pace than you might use for flattening or the like*/
	
	return map_smooth;
}

float map_flatten(float vCameraHeight, float vCurrentHeight)
{
	float flatten, flattened_height;
	flatten = map_smoothstep(vCameraHeight);
	flattened_height = lerp(vCurrentHeight, 0, flatten);
	
	/* This one is frankly, super simple. Based on
	the camera's altitude, lerp between the vertices'
	height and an arbitrary height.				*/
	
	return flattened_height;
}


float4 skinning_deform(float4 vPosition, float4 vBlendWeights, float4 vBlendIndices )
{
	return 	  mul(matWorldArray[vBlendIndices.x], vPosition /*- matBoneOriginArray[vBlendIndices.x]*/) * vBlendWeights.x
			+ mul(matWorldArray[vBlendIndices.y], vPosition /*- matBoneOriginArray[vBlendIndices.y]*/) * vBlendWeights.y
			+ mul(matWorldArray[vBlendIndices.z], vPosition /*- matBoneOriginArray[vBlendIndices.z]*/) * vBlendWeights.z
			+ mul(matWorldArray[vBlendIndices.w], vPosition /*- matBoneOriginArray[vBlendIndices.w]*/) * vBlendWeights.w;
}

// I placed it just under float g_DOF_Range = ***;
// Courtesy of Ian Taylor @ https://www.chilliant.com/rgb2hsv.html
// Y'all know I cannot math like this.

  float3 HUEtoRGB(in float H)
  {
    float R = abs(H * 6 - 3) - 1;
    float G = 2 - abs(H * 6 - 2);
    float B = 2 - abs(H * 6 - 4);
    return saturate(float3(R,G,B));
  }
 
  float Epsilon = 1e-10;

  float3 RGBtoHCV(in float3 RGB)
  {
    // Based on work by Sam Hocevar and Emil Persson
    float4 P = (RGB.g < RGB.b) ? float4(RGB.bg, -1.0, 2.0/3.0) : float4(RGB.gb, 0.0, -1.0/3.0);
    float4 Q = (RGB.r < P.x) ? float4(P.xyw, RGB.r) : float4(RGB.r, P.yzx);
    float C = Q.x - min(Q.w, Q.y);
    float H = abs((Q.w - Q.y) / (6 * C + Epsilon) + Q.z);
    return float3(H, C, Q.x);
  }

float3 RGBtoHSV(in float3 RGB)
  {
    float3 HCV = RGBtoHCV(RGB);
    float S = HCV.y / (HCV.z + Epsilon);
    return float3(HCV.x, S, HCV.z);
  }
 

  float3 HSVtoRGB(in float3 HSV)
  {
    float3 RGB = HUEtoRGB(HSV.x);
    return ((RGB - 1) * HSV.y + 1) * HSV.z;
  }
/////////////////////////////////////////////
/*float3 darkenBlood(in float3 BloodColor)
{
	// Dustin threw something in here, Darken Blood
	float3 redness = RGBtoHSV(BloodColor);

	float darken = 1.0f;
	
	if( 	redness.x < 0.1
		&&	redness.y > 0.5
		&&	redness.z < 0.9
		||  redness.x > 0.9
		&&	redness.y > 0.5
		&&	redness.z < 0.9
		){
		darken *= fBloodDarken;
	}
	
	return float3(BloodColor * darken);
}
*/

// Spot Light Support
#define NUM_SPOT_LIGHTS					31
int iSpotLightCount	=	NUM_SPOT_LIGHTS;	// Total Spot Light Count
float3 vSpotLightPos[NUM_SPOT_LIGHTS];
float3 vSpotLightDir[NUM_SPOT_LIGHTS];
float4 vSpotLightColor[NUM_SPOT_LIGHTS];
float vSpotLightFalloff[NUM_SPOT_LIGHTS];
float vSpotLightCone[NUM_SPOT_LIGHTS];

float3 angleToVector(float3 angle) 
{ 
	// Convert angle to radians 
	angle.x = (angle.x) * 3.14159265 / 180; 
	angle.z = (angle.z - 90) * 3.14159265 / 180; 

	float sinYaw = sin(angle.z); 
	float cosYaw = cos(angle.z); 

	float sinPitch = sin(angle.x); 
	float cosPitch = cos(angle.x);

	float3 direction; 
	direction.x = cosPitch * cosYaw; 
	direction.y = cosPitch * sinYaw; 
	direction.z = -sinPitch;

	return direction;
}

float4 calculate_spot_lights_diffuse(const float3 vWorldPos, const float3 vWorldN) 
{
	
	float4 total = 0;
	for(int j = 0; j < iSpotLightCount; j++)
	{
		
			float3 spotLightPos = vSpotLightPos[j];
			
			if(distance(spotLightPos, vCameraPos) < 30)
			{
			float3 spotLightDir = angleToVector(vSpotLightDir[j]);
			float4 spotLightColor = vSpotLightColor[j];
			float falloff = vSpotLightFalloff[j];
			float angle = vSpotLightCone[j];
			
			float3 L = normalize(spotLightPos - vWorldPos);							// Point Light!
			
			falloff /= distance(spotLightPos, vWorldPos) / 5;						// Falloff!
			
			float atten = pow(saturate(dot(L, spotLightDir)), angle);				// Cone!
			
			total += saturate(dot(normalize(vWorldN), L)) * atten * falloff * spotLightColor;		// Light * Cone * Color!
			}
	}
	return total;
}

#define DEFINE_TECHNIQUES(tech_name, vs_name, ps_name)	\
				technique tech_name	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_name(PCF_NONE); \
							PixelShader = compile ps_2_a ps_name(PCF_NONE);} } \
				technique tech_name##_SHDW	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_name(PCF_DEFAULT); \
							PixelShader = compile ps_2_a ps_name(PCF_DEFAULT);} } \
				technique tech_name##_SHDWNVIDIA	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_name(PCF_NVIDIA); \
							PixelShader = compile ps_2_a ps_name(PCF_NVIDIA);} } 

#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define	DEFINE_LIGHTING_TECHNIQUE(tech_name, use_dxt5, use_bumpmap, use_skinning, use_specularfactor, use_specularmap)
							

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef MISC_SHADERS	//notexture, clear_floating_point_buffer, diffuse_no_shadow, simple_shading, simple_shading_no_filter, no_shading, no_shading_no_alpha

//shared vs_font
struct VS_OUTPUT_FONT
{
	float4 Pos					: POSITION;
	float  Fog				    : FOG;
	
	float4 Color				: COLOR0;
	float2 Tex0					: TEXCOORD0;
};
VS_OUTPUT_FONT vs_font(float4 vPosition : POSITION, float4 vColor : COLOR, float2 tc : TEXCOORD0)
{
	VS_OUTPUT_FONT Out;

	Out.Pos = mul(matWorldViewProj, vPosition);

	float3 P = mul(matWorldView, vPosition); //position in view space

	Out.Tex0 = tc;
	Out.Color = vColor * vMaterialColor;

	//apply fog
	float d = length(P);
	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);

	return Out;
}
VertexShader vs_font_compiled_2_0 = compile vs_2_0 vs_font();

//---
struct VS_OUTPUT_NOTEXTURE
{
	float4 Pos           : POSITION;
	float4 Color         : COLOR0;
	float  Fog           : FOG;
};
VS_OUTPUT_NOTEXTURE vs_main_notexture(float4 vPosition : POSITION, float4 vColor : COLOR)
{
	VS_OUTPUT_NOTEXTURE Out;

	Out.Pos = mul(matWorldViewProj, vPosition);
	Out.Color = vColor * vMaterialColor;
	float3 P = mul(matWorldView, vPosition); //position in view space
	//apply fog
	float d = length(P);
	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);

	return Out;
}
PS_OUTPUT ps_main_notexture( VS_OUTPUT_NOTEXTURE In ) 
{ 
	PS_OUTPUT Output;
	Output.RGBColor = In.Color;
	return Output;
}
technique notexture
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_notexture();
		PixelShader = compile ps_2_a ps_main_notexture();
	}
}

//---
struct VS_OUTPUT_CLEAR_FLOATING_POINT_BUFFER
{
	float4 Pos			: POSITION;
};
VS_OUTPUT_CLEAR_FLOATING_POINT_BUFFER vs_clear_floating_point_buffer(float4 vPosition : POSITION)
{
	VS_OUTPUT_CLEAR_FLOATING_POINT_BUFFER Out;

	Out.Pos = mul(matWorldViewProj, vPosition);

	return Out;
}
PS_OUTPUT ps_clear_floating_point_buffer()
{
	PS_OUTPUT Out;
	Out.RGBColor = float4(0.0f, 0.0f, 0.0f, 0.0f);
	return Out;
}
technique clear_floating_point_buffer
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_clear_floating_point_buffer();
		PixelShader = compile ps_2_a ps_clear_floating_point_buffer();
	}
}

//---
struct VS_OUTPUT_FONT_X
{
	float4 Pos					: POSITION;
	float4 Color					: COLOR0;
	float2 Tex0					: TEXCOORD0;
	float  Fog				    : FOG;
};

VS_OUTPUT_FONT_X vs_main_no_shadow(float4 vPosition : POSITION, float3 vNormal : NORMAL, float2 tc : TEXCOORD0, float4 vColor : COLOR0, float4 vLightColor : COLOR1)
{
	VS_OUTPUT_FONT_X Out;

	Out.Pos = mul(matWorldViewProj, vPosition);

	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal)); //normal in world space
	float3 P = mul(matWorldView, vPosition); //position in view space

	Out.Tex0 = tc;

	float4 diffuse_light = vAmbientColor + vLightColor;
	diffuse_light += saturate(dot(vWorldN, -vSkyLightDir)) * vSkyLightColor;
	diffuse_light += saturate(dot(vWorldN, -vSunDir)) * vSunColor;
	Out.Color = (vMaterialColor * vColor * diffuse_light);

	//apply fog
	float d = length(P);

	Out.Fog = get_fog_amount_new(d, vWorldPos.z);

	return Out;
}
PS_OUTPUT ps_main_no_shadow(VS_OUTPUT_FONT_X In) 
{ 
	PS_OUTPUT Output;
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0);
	INPUT_TEX_GAMMA(tex_col.rgb);
	Output.RGBColor =  In.Color * tex_col;
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	return Output;
}
PS_OUTPUT ps_main_no_shadow_custom_ui(VS_OUTPUT_FONT_X In) 
{ 
	PS_OUTPUT Output;
	
	float2 tile_offset = (In.Tex0.y > 0.5) ? float2((bDirectionalOffset % 8) * 0.125, 0) : float2((bReticleOffset % 4) * 0.25, floor((bReticleOffset % 16) / 4) * 0.125);
	
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0 + tile_offset);
	INPUT_TEX_GAMMA(tex_col.rgb);
	
	float3 hsv = RGBtoHSV(tex_col.rgb);
	
	tex_col = (hsv.y > 0.5 && hsv.z > 0.25 && In.Tex0.y < 0.5)? In.Color : tex_col;
	tex_col.a = (tex_col.r > 0.05 || tex_col.g > 0.05 || tex_col.b > 0.01) ? tex_col.a : 0;
	
	Output.RGBColor = (In.Tex0.y > 0.5) ? In.Color * tex_col : tex_col;
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	return Output;
}
PS_OUTPUT ps_main_no_shadow_cursor(VS_OUTPUT_FONT_X In) 
{ 
	PS_OUTPUT Output;
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0);
	INPUT_TEX_GAMMA(tex_col.rgb);
	Output.RGBColor =  In.Color * tex_col * fCursorVisible;
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	return Output;
}
PS_OUTPUT ps_simple_no_filtering(VS_OUTPUT_FONT_X In) 
{ 
	PS_OUTPUT Output;
	float4 tex_col = tex2D(MeshTextureSamplerNoFilter, In.Tex0);
	INPUT_TEX_GAMMA(tex_col.rgb);
	Output.RGBColor =  In.Color * tex_col;
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	return Output;
}
PS_OUTPUT ps_no_shading(VS_OUTPUT_FONT In) 
{ 
	PS_OUTPUT Output;
	Output.RGBColor =  In.Color;
	//Output.RGBColor *= tex2D(DiffuseTextureSamplerNoWrap, In.Tex0);
	Output.RGBColor *= tex2D(MeshTextureSampler, In.Tex0);
//	Output.RGBColor = float4(1,0,0,1);
	return Output;
}
PS_OUTPUT ps_no_shading_no_alpha(VS_OUTPUT_FONT In) 
{ 
	PS_OUTPUT Output;
	Output.RGBColor =  In.Color;
	Output.RGBColor *= tex2D(MeshTextureSamplerNoFilter, In.Tex0);
	Output.RGBColor.a = 1.0f;
	return Output;
}

technique diffuse_no_shadow
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_no_shadow();
		PixelShader = compile ps_2_a ps_main_no_shadow();
	}
}
technique simple_shading //Uses gamma
{
	pass P0
	{
		VertexShader = vs_font_compiled_2_0;
		PixelShader = compile ps_2_a ps_main_no_shadow();
	}
}
technique simple_shading_custom_ui //Uses gamma
{
	pass P0
	{
		VertexShader = vs_font_compiled_2_0;
		PixelShader = compile ps_2_a ps_main_no_shadow_custom_ui();
	}
}
technique simple_shading_cursor //Uses gamma
{
	pass P0
	{
		VertexShader = vs_font_compiled_2_0;
		PixelShader = compile ps_2_a ps_main_no_shadow_cursor();
	}
}
technique simple_shading_no_filter //Uses gamma
{
	pass P0
	{
		VertexShader = vs_font_compiled_2_0;
		PixelShader = compile ps_2_a ps_simple_no_filtering();
	}
}
technique no_shading
{
	pass P0
	{
		VertexShader = vs_font_compiled_2_0;
		PixelShader = compile ps_2_a ps_no_shading();
	}
}
technique no_shading_no_alpha
{
	pass P0
	{
		VertexShader = vs_font_compiled_2_0;
		PixelShader = compile ps_2_a ps_no_shading_no_alpha();
	}
}

#endif

///////////////////////////////////////////////
#ifdef UI_SHADERS
PS_OUTPUT ps_font_uniform_color(VS_OUTPUT_FONT In) 
{ 
	PS_OUTPUT Output;
	Output.RGBColor =  In.Color;
	Output.RGBColor.a *= tex2D(FontTextureSampler, In.Tex0).a;
	return Output;
}
PS_OUTPUT ps_font_background(VS_OUTPUT_FONT In) 
{ 
	PS_OUTPUT Output;
	Output.RGBColor.a = 1.0f; //In.Color.a;
	Output.RGBColor.rgb = tex2D(FontTextureSampler, In.Tex0).rgb + In.Color.rgb;
	//	Output.RGBColor.rgb += 1.0f - In.Color.a;
	
	return Output;
}
PS_OUTPUT ps_font_outline(VS_OUTPUT_FONT In) 
{ 
	float4 sample = tex2D(FontTextureSampler, In.Tex0);
	PS_OUTPUT Output;
	Output.RGBColor =  In.Color;
	Output.RGBColor.a = (1.0f - sample.r) + sample.a;
	
	Output.RGBColor.rgb *= sample.a + 0.05f;
	
	Output.RGBColor	= saturate(Output.RGBColor);
	
	return Output;
}

technique font_uniform_color
{
	pass P0
	{
		VertexShader = vs_font_compiled_2_0;
		PixelShader = compile ps_2_a ps_font_uniform_color();
	}
}
technique font_background
{
	pass P0
	{
		VertexShader = vs_font_compiled_2_0;
		PixelShader = compile ps_2_a ps_font_background();
	}
}
technique font_outline
{
	pass P0
	{
		VertexShader = vs_font_compiled_2_0;
		PixelShader = compile ps_2_a ps_font_outline();
	}
}

#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef SHADOW_RELATED_SHADERS

struct VS_OUTPUT_SHADOWMAP
{

	float4 Pos          : POSITION;
	float2 Tex0			: TEXCOORD0;
	float  Depth		: TEXCOORD1;
};
VS_OUTPUT_SHADOWMAP vs_main_shadowmap_skin (float4 vPosition : POSITION, float2 tc : TEXCOORD0, float4 vBlendWeights : BLENDWEIGHT, float4 vBlendIndices : BLENDINDICES)
{
	VS_OUTPUT_SHADOWMAP Out;

	float4 vObjectPos = skinning_deform(vPosition, vBlendWeights, vBlendIndices);
	
	Out.Pos = mul(matWorldViewProj, vObjectPos);
	Out.Depth = Out.Pos.z/ Out.Pos.w;
	Out.Tex0 = tc;

	return Out;
}
VS_OUTPUT_SHADOWMAP vs_main_shadowmap (float4 vPosition : POSITION, float3 vNormal : NORMAL, float2 tc : TEXCOORD0)
{
	VS_OUTPUT_SHADOWMAP Out;
	Out.Pos = mul(matWorldViewProj, vPosition);
	Out.Depth = Out.Pos.z/Out.Pos.w;
	
	if (1)
	{
		float3 vScreenNormal = mul((float3x3)matWorldViewProj, vNormal); //normal in screen space
		Out.Depth -= vScreenNormal.z * (fShadowBias);
	}

	Out.Tex0 = tc;
	return Out;
}
VS_OUTPUT_SHADOWMAP vs_main_shadowmap_biased (float4 vPosition : POSITION, float3 vNormal : NORMAL, float2 tc : TEXCOORD0)
{
	VS_OUTPUT_SHADOWMAP Out;
	Out.Pos = mul(matWorldViewProj, vPosition);
	Out.Depth = Out.Pos.z/Out.Pos.w;
	
	if (1)
	{
		float3 vScreenNormal = mul((float3x3)matWorldViewProj, vNormal); //normal in screen space
		Out.Depth -= vScreenNormal.z * (fShadowBias);
		
		Out.Pos.z += (0.0025f);	//extra bias!
	}

	Out.Tex0 = tc;
	return Out;
}

PS_OUTPUT ps_main_shadowmap(VS_OUTPUT_SHADOWMAP In)
{ 
	PS_OUTPUT Output;
	Output.RGBColor.a = tex2D(MeshTextureSampler, In.Tex0).a;
	Output.RGBColor.a -= 0.5f;
	clip(Output.RGBColor.a);
	
	Output.RGBColor.rgb = In.Depth;// + fShadowBias;

	return Output;
}
VS_OUTPUT_SHADOWMAP vs_main_shadowmap_light(uniform const bool skinning, float4 vPosition : POSITION, float3 vNormal : NORMAL, float2 tc : TEXCOORD0,
											float4 vBlendWeights : BLENDWEIGHT, float4 vBlendIndices : BLENDINDICES)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_SHADOWMAP, Out);

	return Out;
}
PS_OUTPUT ps_main_shadowmap_light(VS_OUTPUT_SHADOWMAP In)
{ 
	PS_OUTPUT Output;
	
	Output.RGBColor = float4(1,0,0,1);
	
	return Output;
}
PS_OUTPUT ps_render_character_shadow(VS_OUTPUT_SHADOWMAP In)
{ 
	PS_OUTPUT Output;
	Output.RGBColor = 1.0f;
	//!! Output.RGBColor.rgb = In.Depth;
	//!! Output.RGBColor.a = 1.0f;
	return Output;
}

VertexShader vs_main_shadowmap_compiled = compile vs_2_0 vs_main_shadowmap();
VertexShader vs_main_shadowmap_skin_compiled = compile vs_2_0 vs_main_shadowmap_skin();

PixelShader ps_main_shadowmap_compiled = compile ps_2_a ps_main_shadowmap();
PixelShader ps_main_shadowmap_light_compiled = compile ps_2_a ps_main_shadowmap_light();
PixelShader ps_render_character_shadow_compiled = compile ps_2_a ps_render_character_shadow();


technique renderdepth
{
	pass P0
	{
		VertexShader = vs_main_shadowmap_compiled;
		PixelShader = ps_main_shadowmap_compiled;
	}
}
technique renderdepth_biased
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_shadowmap_biased();
		PixelShader = ps_main_shadowmap_compiled;
	}
}

technique renderdepthwithskin
{
	pass P0
	{
		VertexShader = vs_main_shadowmap_skin_compiled;
		PixelShader = ps_main_shadowmap_compiled;
	}
}
technique renderdepth_light
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_shadowmap_light(false);
		PixelShader = ps_main_shadowmap_light_compiled;
	}
}
technique renderdepthwithskin_light
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_shadowmap_light(true);
		PixelShader = ps_main_shadowmap_light_compiled;
	}
}

technique render_character_shadow
{
	pass P0
	{
		VertexShader = vs_main_shadowmap_compiled;
		PixelShader = ps_render_character_shadow_compiled;
	}
}
technique render_character_shadow_with_skin
{
	pass P0
	{
		VertexShader = vs_main_shadowmap_skin_compiled;
		PixelShader = ps_render_character_shadow_compiled;
	}
}

//--
float blurred_read_alpha(float2 texCoord)
{
	float3 sample_start = tex2D(CharacterShadowTextureSampler, texCoord).rgb;
	
	static const int SAMPLE_COUNT = 4;
	static const float2 offsets[SAMPLE_COUNT] = {
		-1, 1,
		 1, 1,
		0, 2,
		0, 3,
	};
	
	float blur_amount = saturate(1.0f - texCoord.y);
	blur_amount*=blur_amount;
	float sampleDist = (6.0f / 256.0f) * blur_amount;
	float sample = sample_start;
	
	for (int i = 0; i < SAMPLE_COUNT; i++) {
		float2 sample_pos = texCoord + sampleDist * offsets[i];
		float sample_here = tex2D(CharacterShadowTextureSampler, sample_pos).a;
		sample += sample_here;
	}

	sample /= SAMPLE_COUNT+1;
	return sample;
}
struct VS_OUTPUT_CHARACTER_SHADOW
{
	float4 Pos				    : POSITION;
	float  Fog                  : FOG;
	
	float2 Tex0					: TEXCOORD0;
	float4 Color			    : COLOR0;
	float4 SunLight				: TEXCOORD1;
	float4 ShadowTexCoord		: TEXCOORD2;
	float2 ShadowTexelPos		: TEXCOORD3;
};
VS_OUTPUT_CHARACTER_SHADOW vs_character_shadow (uniform const int PcfMode, float4 vPosition : POSITION, float3 vNormal : NORMAL, float2 tc : TEXCOORD0, float4 vColor : COLOR)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_CHARACTER_SHADOW, Out);
	
	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	if (PcfMode != PCF_NONE)
	{
		//shadow mapping variables
		float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal));

		float wNdotSun = max(-0.0001, dot(vWorldN, -vSunDir));
		Out.SunLight = ( wNdotSun) * vSunColor;

		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	}

	Out.Pos = mul(matWorldViewProj, vPosition);
	Out.Tex0 = tc;
	Out.Color = vColor * vMaterialColor;
	
	float3 P = mul(matWorldView, vPosition); //position in view space
	float d = length(P);
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);

	return Out;
}
PS_OUTPUT ps_character_shadow(uniform const int PcfMode, VS_OUTPUT_CHARACTER_SHADOW In)
{ 
	PS_OUTPUT Output;
	
	if (PcfMode == PCF_NONE)
	{
		Output.RGBColor.a = blurred_read_alpha(In.Tex0) * In.Color.a;
	}
	else
	{
		float sun_amount = 0.05f + GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
		//		sun_amount *= sun_amount;
		Output.RGBColor.a = saturate(blurred_read_alpha(In.Tex0) * In.Color.a * sun_amount);
	}
	Output.RGBColor.rgb = In.Color.rgb;
	//Output.RGBColor = float4(tex2D(CharacterShadowTextureSampler, In.Tex0).a, 0, 0, 1);

	//!! Output.RGBColor.a *= 0.1f;
	return Output;
}

DEFINE_TECHNIQUES(character_shadow, vs_character_shadow, ps_character_shadow)


PS_OUTPUT ps_character_shadow_new(uniform const int PcfMode, VS_OUTPUT_CHARACTER_SHADOW In)
{ 
	PS_OUTPUT Output;
	
	if (PcfMode == PCF_NONE)
	{
		Output.RGBColor.a = tex2D(CharacterShadowTextureSampler, In.Tex0).r * In.Color.a;
	}
	else
	{
		float sun_amount = 0.05f + GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
		//		sun_amount *= sun_amount;
		Output.RGBColor.a = saturate(tex2D(CharacterShadowTextureSampler, In.Tex0).r * In.Color.a * sun_amount);
	}
	Output.RGBColor.rgb = In.Color.rgb;
	//Output.RGBColor = float4(tex2D(CharacterShadowTextureSampler, In.Tex0).a, 0, 0, 1);
	return Output;
}

DEFINE_TECHNIQUES(character_shadow_new, vs_character_shadow, ps_character_shadow_new)

#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef WATER_SHADERS
struct VS_OUTPUT_WATER
{
	float4 Pos          : POSITION;
	float2 Tex0         : TEXCOORD0;
	float4 LightDir_Alpha	: TEXCOORD1;//light direction for bump
	float4 LightDif		: TEXCOORD2;//light diffuse for bump
	float3 CameraDir	: TEXCOORD3;//camera direction for bump
	float4 PosWater		: TEXCOORD4;//position according to the water camera
	float  Fog          : FOG;
	
	float4 projCoord 	: TEXCOORD5;
	float  Depth    	: TEXCOORD6; 
};
VS_OUTPUT_WATER vs_main_water(float4 vPosition : POSITION, float3 vNormal : NORMAL, float4 vColor : COLOR, float2 tc : TEXCOORD0,  float3 vTangent : TANGENT, float3 vBinormal : BINORMAL)
{
	VS_OUTPUT_WATER Out = (VS_OUTPUT_WATER) 0;

	Out.Pos = mul(matWorldViewProj, vPosition);
	//!Out.Pos = mul(matViewProj, vPosition);
	
	Out.PosWater = mul(matWaterWorldViewProj, vPosition);

	float3 vWorldPos = (float3)mul(matWorld,vPosition);
	float3 point_to_camera_normal = normalize(vCameraPos - vWorldPos);

	float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal)); //normal in world space
	float3 vWorld_binormal = normalize(mul((float3x3)matWorld, vBinormal)); //normal in world space
	float3 vWorld_tangent  = normalize(mul((float3x3)matWorld, vTangent)); //normal in world space
	
	float3 P = mul(matWorldView, vPosition); //position in view space

	float3x3 TBNMatrix = float3x3(vWorld_tangent, vWorld_binormal, vWorldN); 

	Out.CameraDir = mul(TBNMatrix, point_to_camera_normal);

	Out.Tex0 = tc + texture_offset.xy;

	Out.LightDif = 0; //vAmbientColor;
	float totalLightPower = 0;

	//directional lights, compute diffuse color
	Out.LightDir_Alpha.xyz = mul(TBNMatrix, -vSunDir);
	Out.LightDif += vSunColor * vColor;
	totalLightPower += length(vSunColor.xyz);
	
	Out.LightDir_Alpha.a = vColor.a;

	//apply fog
	float d = length(P);
	Out.Fog = get_fog_amount_map(d, vWorldPos.z);
	
	if(use_depth_effects) 
	{
		Out.projCoord.xy = (float2(Out.Pos.x, -Out.Pos.y)+Out.Pos.w)/2;
		Out.projCoord.xy += (vDepthRT_HalfPixel_ViewportSizeInv.xy * Out.Pos.w);
		Out.projCoord.zw = Out.Pos.zw;
		Out.Depth = Out.Pos.z * far_clip_Inv;
	}
	
	return Out;
}
PS_OUTPUT ps_main_water( VS_OUTPUT_WATER In, uniform const bool use_high, uniform const bool apply_depth, uniform const bool mud_factor )
{ 
	PS_OUTPUT Output;
	
	const bool rgb_normalmap = false; //!apply_depth;
	
	float3 normal;
	if(rgb_normalmap)
	{
		normal = (2.0f * tex2D(NormalTextureSampler, In.Tex0).rgb - 1.0f);
	}
	else
	{
		normal.xy = (2.0f * tex2D(NormalTextureSampler, In.Tex0).ag - 1.0f);
		normal.z = sqrt(1.0f - dot(normal.xy, normal.xy));
	}
	
	if(!apply_depth)
	{
		normal = float3(0,0,1);
	}
	
	float NdotL = saturate(dot(normal, In.LightDir_Alpha.xyz));
	//float NdotL = saturate(dot(detail_normal, In.LightDir));
	
	//float3 scaledNormal = normalize(normal * float3(0.2f, 0.2f, 1.0f));
	//float light_amount = (0.1f + NdotL) * 0.6f;
	
	float3 vView = normalize(In.CameraDir);
	
	float4 tex;
	if(apply_depth)
	{
		tex = tex2D(ReflectionTextureSampler, (0.25f * normal.xy) + float2(0.5f + 0.5f * (In.PosWater.x / In.PosWater.w), 0.5f - 0.5f * (In.PosWater.y / In.PosWater.w)));
	}
	else
	{
		//for objects use env map (they use same texture register)
		tex = tex2D(EnvTextureSampler, (vView - normal).yx * 3.4f);
	}
	INPUT_OUTPUT_GAMMA(tex.rgb);
	
	Output.RGBColor = 0.01f * NdotL * In.LightDif;
	if(mud_factor)
	{
	   Output.RGBColor *= 0.125f;
	}
	
	//float fresnel = saturate( 1 - dot(In.CameraDir + 0.45, normal) ) + 0.01;
	//fresnel = saturate(fresnel * 2);
	// Fresnel term
	float fresnel = 1-(saturate(dot(vView, normal)));
	fresnel = 0.0204f + 0.9796 * (fresnel * fresnel * fresnel * fresnel * fresnel);

	if(!apply_depth)
	{
		fresnel = min(fresnel, 0.01f);
	}
	if(mud_factor)
	{
		Output.RGBColor.rgb += lerp( tex.rgb*float3(0.105, 0.175, 0.160)*fresnel, tex.rgb, fresnel);
	}
	else
	{
		Output.RGBColor.rgb += (tex.rgb * fresnel);
	}
	Output.RGBColor.a = 1.0f - 0.3f * In.CameraDir.z;
	
	float vertex_alpha = In.LightDir_Alpha.a;
	Output.RGBColor.a *= vertex_alpha;
	
	if(mud_factor)
	{
		Output.RGBColor.a = 1.0f;
	}
	
	
	//static float3 g_cDownWaterColor = {12.0f/255.0f, 26.0f/255.0f, 36.0f/255.0f};
	//static float3 g_cUpWaterColor   = {33.0f/255.0f, 52.0f/255.0f, 77.0f/255.0f};
	const float3 g_cDownWaterColor = mud_factor ? float3(4.5f/255.0f, 8.0f/255.0f, 6.0f/255.0f) : float3(1.0f/255.0f, 4.0f/255.0f, 6.0f/255.0f);
	const float3 g_cUpWaterColor   = mud_factor ? float3(5.0f/255.0f, 7.0f/255.0f, 7.0f/255.0f) : float3(1.0f/255.0f, 5.0f/255.0f, 10.0f/255.0f);
	
	float3 cWaterColor = lerp( g_cUpWaterColor, g_cDownWaterColor,  saturate(dot(vView, normal)));

	if(!apply_depth)
	{
		cWaterColor = In.LightDif.xyz;
	}
	
	float fog_fresnel_factor = saturate(dot(In.CameraDir, normal));
	fog_fresnel_factor *= fog_fresnel_factor;
	fog_fresnel_factor *= fog_fresnel_factor;
	if(!apply_depth)
	{
		fog_fresnel_factor *= 0.1f;
		fog_fresnel_factor += 0.05f;
	}
	Output.RGBColor.rgb += cWaterColor * fog_fresnel_factor;
	
	if(mud_factor)
	{
		Output.RGBColor.rgb += float3(0.022f, 0.02f, 0.005f) * (1.0f - saturate(dot(vView, normal)));
	}
	
	
	if(apply_depth && use_depth_effects) {
	
		float depth = tex2Dproj(DepthTextureSampler, In.projCoord).r;
	
		float alpha_factor;
		if((depth+0.0005) < In.Depth) {
			alpha_factor = 1;
		}else {
			alpha_factor = saturate(/*max(0, */(depth - In.Depth) * 2048);
		}
		
		Output.RGBColor.w *= alpha_factor;
		
		
		//add some alpha to deep areas?
		Output.RGBColor.w += saturate((depth - In.Depth) * 32);
		
		
		static const bool use_refraction = true;
		
		if(use_refraction && use_high) {
			float4 coord_start = In.projCoord; //float2(0.5f + 0.5f * (In.PosWater.x / In.PosWater.w), 0.45 + 0.5f * (In.PosWater.y / In.PosWater.w));
			float4 coord_disto = coord_start;
			coord_disto.xy += (normal.xy * saturate(Output.RGBColor.w) * 0.1f);
			float depth_here = tex2D(DepthTextureSampler, coord_disto).r;
			float4 refraction;
			if(depth_here < depth)
				refraction = tex2Dproj(ScreenTextureSampler, coord_disto);
			else
				refraction = tex2Dproj(ScreenTextureSampler, coord_start);
			INPUT_OUTPUT_GAMMA(refraction.rgb);
	
			Output.RGBColor.rgb = lerp(Output.RGBColor.rgb, refraction.rgb, /*0.145f * fog_fresnel_factor*/ saturate(1.0f - Output.RGBColor.w) * 0.55f);
			if(Output.RGBColor.a>0.1f)
			{
				Output.RGBColor.a *= 1.75f;
			}
			if(mud_factor)
			{
				Output.RGBColor.a *= 1.25f;
			}
		}
	}

	
	//float3 H = normalize(In.LightDir + In.CameraDir); //half vector
	//float4 ColorSpec = fresnel * tex * pow(saturate(dot(H, normalize(normal + float3(normal.xy,0)) )), 100.0f) * In.LightDif;
	//Output.RGBColor.rgb += ColorSpec.rgb;
			
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	Output.RGBColor.a = saturate(Output.RGBColor.a);
	if(!apply_depth)
	{
		Output.RGBColor.a = 1.0f;
	}
	
	return Output;
}
technique watermap
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_water();
		PixelShader = compile ps_2_a ps_main_water(false, true, false);
	}
}
technique watermap_high
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_water();
		PixelShader = compile PS_2_X ps_main_water(true, true, false);
	}
}
technique watermap_mud
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_water();
		PixelShader = compile ps_2_a ps_main_water(false, true, true);
	}
}
technique watermap_mud_high
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_water();
		PixelShader = compile PS_2_X ps_main_water(true, true, true);
	}
}
/*technique watermap_for_objects
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_water();
		PixelShader = compile PS_2_X ps_main_water(true, false);
	}
}*/

#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef SKYBOX_SHADERS
PS_OUTPUT ps_skybox_shading(VS_OUTPUT_FONT In) 
{ 
	PS_OUTPUT Output;
	Output.RGBColor =  In.Color;
	Output.RGBColor *= tex2D(MeshTextureSampler, In.Tex0);
	
	return Output;
}

PS_OUTPUT ps_skybox_shading_new(uniform bool use_hdr, VS_OUTPUT_FONT In) 
{ 
	PS_OUTPUT Output;
	
	if(use_hdr) {
		
		Output.RGBColor =  In.Color;
		Output.RGBColor *= tex2D(Diffuse2Sampler, In.Tex0);
		
		// expand to floating point.. (RGBE)
		float2 scaleBias = float2(vSpecularColor.x, vSpecularColor.y);
		
		//float exFactor16 = dot(tex2D(MeshTextureSampler, In.Tex0).rgb, 0.25);	//fake.
		float exFactor16 = tex2D(EnvTextureSampler, In.Tex0).r;
		float exFactor8 = floor(exFactor16*255)/255;
		Output.RGBColor.rgb *= exp2(exFactor16 * scaleBias.x + scaleBias.y);
		
		//Output.RGBColor.rgb = tex2D(EnvTextureSampler, In.Tex0);
		
	}else {
		//switch to old style
		Output.RGBColor =  In.Color;
		float4 tex_col = tex2D(MeshTextureSampler, In.Tex0);
		INPUT_TEX_GAMMA(tex_col.rgb);
		Output.RGBColor *= tex_col;
	}
	
	Output.RGBColor.a = 1;
	
	//gamma correct?
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	
	if(In.Color.a == 0.0f)
	{
		Output.RGBColor.rgb = saturate(Output.RGBColor.rgb);
	}
	
	return Output;
}

VS_OUTPUT_FONT vs_skybox(float4 vPosition : POSITION, float4 vColor : COLOR, float2 tc : TEXCOORD0)
{
	VS_OUTPUT_FONT Out;

	Out.Pos = mul(matWorldViewProj, vPosition);
	Out.Pos.z = Out.Pos.w;

	float3 P = vPosition; //position in view space

	Out.Tex0 = tc;
	Out.Color = vColor * vMaterialColor;

	//apply fog
	P.z *= 0.2f;
	float d = length(P);
	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);
	
	Out.Color.a = (vWorldPos.z < -10.0f) ? 0.0f : 1.0f;
	
	return Out;
}

VertexShader vs_skybox_compiled = compile vs_2_0 vs_skybox();

technique skybox
{
	pass P0
	{
		VertexShader = vs_skybox_compiled;
		PixelShader = compile ps_2_a ps_skybox_shading();
	}
}

technique skybox_new
{
	pass P0
	{
		VertexShader = vs_skybox_compiled;
		PixelShader = compile ps_2_a ps_skybox_shading_new(false);
	}
}

technique skybox_new_HDR
{
	pass P0
	{
		VertexShader = vs_skybox_compiled;
		PixelShader = compile ps_2_a ps_skybox_shading_new(true);
	}
}
#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef STANDART_RELATED_SHADER //these are going to be same with standart!

struct VS_OUTPUT
{
	float4 Pos					: POSITION;
	float  Fog				    : FOG;
	
	float4 Color				: COLOR0;
	float2 Tex0					: TEXCOORD0;
	float4 SunLight				: TEXCOORD1;
	float4 ShadowTexCoord		: TEXCOORD2;
	float2 ShadowTexelPos		: TEXCOORD3;
	
	float3 ViewDir				: TEXCOORD4;
	float3 WorldNormal			: TEXCOORD5;
	float3 WorldPos				: TEXCOORD6;
	
};

VS_OUTPUT vs_main(uniform const int PcfMode, uniform const bool UseSecondLight, float4 vPosition : POSITION, float3 vNormal : NORMAL, float2 tc : TEXCOORD0, float4 vColor : COLOR0, float4 vLightColor : COLOR1)
{
	INITIALIZE_OUTPUT(VS_OUTPUT, Out);

	Out.Pos = mul(matWorldViewProj, vPosition);

	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal)); //normal in world space

	Out.Tex0 = tc;
	float NdotL = dot(-vSunDir, vWorldN);
	float4 diffuse_light = (vAmbientColor + vGroundAmbientColor /*+ ((vSkyLightColor) * smoothstep(0.5, 0.52, NdotL))*/);
	
	Out.ViewDir = normalize(vCameraPos.xyz - vWorldPos.xyz);
	Out.WorldNormal = vWorldN;
	Out.WorldPos = vWorldPos;
	
	//apply fog
	float3 P = mul(matWorldView, vPosition); //position in view space
	float d = length(P);
	
	if(bNightVision == 1)
		diffuse_light.rgb += flashlight(d, Out.ViewDir, Out.WorldNormal);
	
	//   diffuse_light.rgb *= gradient_factor * (gradient_offset + vWorldN.z);
	/*
	if (UseSecondLight)
	{
		diffuse_light += vLightColor;
	}

	//directional lights, compute diffuse color
	diffuse_light += saturate(dot(vWorldN, -vSkyLightDir)) * vSkyLightColor;

	//point lights
	#ifndef USE_LIGHTING_PASS
	diffuse_light += calculate_point_lights_diffuse(vWorldPos, vWorldN, false, false);
	#endif
	*/
	//apply material color
	//	Out.Color = min(1, vMaterialColor * vColor * diffuse_light);
	Out.Color = (vMaterialColor * vColor * diffuse_light);

	//shadow mapping variables
	float wNdotSun = saturate(dot(vWorldN, -vSunDir));
	Out.SunLight = (wNdotSun) * vSunColor * vMaterialColor * vColor;
	if (PcfMode != PCF_NONE)
	{
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	}
	
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);
	return Out;
}

VS_OUTPUT vs_main_Instanced(uniform const int PcfMode, uniform const bool UseSecondLight, float4 vPosition : POSITION, float3 vNormal : NORMAL, float2 tc : TEXCOORD0, float4 vColor : COLOR0, float4 vLightColor : COLOR1,
							 //instance data:
						   float3   vInstanceData0 : TEXCOORD1,
						   float3   vInstanceData1 : TEXCOORD2,
						   float3   vInstanceData2 : TEXCOORD3,
						   float3   vInstanceData3 : TEXCOORD4)
{
	INITIALIZE_OUTPUT(VS_OUTPUT, Out);

	float4x4 matWorldOfInstance = build_instance_frame_matrix(vInstanceData0, vInstanceData1, vInstanceData2, vInstanceData3);
	
	//-- Out.Pos = mul(matWorldViewProj, vPosition);
    Out.Pos = mul(matWorldOfInstance, float4(vPosition.xyz, 1.0f));
    Out.Pos = mul(matViewProj, Out.Pos);

	float4 vWorldPos = (float4)mul(matWorldOfInstance,vPosition);
	float3 vWorldN = normalize(mul((float3x3)matWorldOfInstance, vNormal)); //normal in world space

	Out.Tex0 = tc;

	float4 diffuse_light = vAmbientColor;
	//   diffuse_light.rgb *= gradient_factor * (gradient_offset + vWorldN.z);

	if (UseSecondLight)
	{
		diffuse_light += vLightColor;
	}

	//directional lights, compute diffuse color
	
	//apply fog
	float4 P = mul(matView, vWorldPos); //position in view space
	float d = length(P.xyz);
	
	diffuse_light += saturate(dot(vWorldN, -vSkyLightDir)) * vSkyLightColor;
	
	if(bNightVision == 1)
	diffuse_light.rgb += flashlight(d, normalize(vCameraPos.xyz - vWorldPos.xyz), vWorldN);

	//point lights
	#ifndef USE_LIGHTING_PASS
	diffuse_light += calculate_point_lights_diffuse(vWorldPos, vWorldN, false, false);
	#endif
	
	//apply material color
	//	Out.Color = min(1, vMaterialColor * vColor * diffuse_light);
	Out.Color = (vMaterialColor * vColor * diffuse_light);

	//shadow mapping variables
	float wNdotSun = saturate(dot(vWorldN, -vSunDir));
	Out.SunLight = (wNdotSun) * vSunColor * vMaterialColor * vColor;
	if (PcfMode != PCF_NONE)
	{
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	}
	

	Out.Fog = get_fog_amount_new(d, vWorldPos.z);
	return Out;
}


PS_OUTPUT ps_main(VS_OUTPUT In, uniform const int PcfMode)
{
	/*PS_OUTPUT Output;
	
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0);
	INPUT_TEX_GAMMA(tex_col.rgb);
	
	float sun_amount = 1.0f; 
	if ((PcfMode != PCF_NONE))
	{
		sun_amount = GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
	}
	Output.RGBColor =  tex_col * ((In.Color + In.SunLight * sun_amount));
	
	// gamma correct
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	
	return Output;*/
	
		PS_OUTPUT Output;
	// Registering Maps, etc
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0);
	float4 specular = float4(0.6, 0.6, 0.6, 1);
	float3 viewDir = In.ViewDir;
	float3 normal = In.WorldNormal;
	float sun_amount = tex2Dproj(ShadowmapTextureSampler, In.ShadowTexCoord).r;
	
	
	float4 lamps = calculate_point_lights_diffuse(In.WorldPos, normal, false, false);
	lamps = lamps.r > 0.5 ? lamps : float4(0,0,0,1);
	INPUT_TEX_GAMMA(tex_col.rgb);
	
	float fresnel = 1-(saturate(dot(viewDir, In.WorldNormal)));
	fresnel = smoothstep(0.82, 0.85, fresnel);

    float NdotL = dot(-vSunDir, normal); // Normal dot Lighting Direction
    float3 halfVector = normalize(-vSunDir + viewDir);
    float NdotH = dot(normal, halfVector); // Normal dot Half Vector
	
	NdotL = smoothstep(0.05, 0.08, NdotL);
	
	sun_amount = smoothstep(0.5, 0.51, sun_amount);
	
	float4 isLit = NdotL * sun_amount;
	
	float4 sunLight = vSunColor * isLit;	
	
	Output.RGBColor.rgb =  (tex_col * saturate(In.Color + lamps + sunLight + fresnel * vSunColor * max(sun_amount, 0.25)));
	
	// if(bNightVision == 1)
	// {
	// Output.RGBColor.rgb += (saturate(dot(In.ViewDir.xyz, normal.xyz)) * 0.05f); // Take the dot from camera view to the normal of the object being rendered. The more flat on, the more illumination
	// }
	
	Output.RGBColor.a = tex_col.a;
	
	// Output.RGBColor.rgb = NdotL;
	// gamma correct
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	
	/* Entirely Native Shader
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0);
	INPUT_TEX_GAMMA(tex_col.rgb);
	
	float sun_amount = 1.0f; 
	if ((PcfMode != PCF_NONE))
	{
		sun_amount = GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
	}
	Output.RGBColor =  tex_col * ((In.Color + In.SunLight * sun_amount));
	
	// gamma correct
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	*/
	return Output;
}

VertexShader vs_main_compiled_PCF_NONE_true = compile vs_2_0 vs_main(PCF_NONE, true);
VertexShader vs_main_compiled_PCF_DEFAULT_true = compile vs_2_0 vs_main(PCF_DEFAULT, true);
VertexShader vs_main_compiled_PCF_NVIDIA_true = compile vs_2_a vs_main(PCF_NVIDIA, true);

VertexShader vs_main_compiled_PCF_NONE_false = compile vs_2_0 vs_main(PCF_NONE, false);
VertexShader vs_main_compiled_PCF_DEFAULT_false = compile vs_2_0 vs_main(PCF_DEFAULT, false);
VertexShader vs_main_compiled_PCF_NVIDIA_false = compile vs_2_a vs_main(PCF_NVIDIA, false);

PixelShader ps_main_compiled_PCF_NONE = compile ps_2_a ps_main(PCF_NONE);
PixelShader ps_main_compiled_PCF_DEFAULT = compile ps_2_a ps_main(PCF_DEFAULT);
PixelShader ps_main_compiled_PCF_NVIDIA = compile ps_2_a ps_main(PCF_NVIDIA);


technique diffuse
{
	pass P0
	{
		VertexShader = vs_main_compiled_PCF_NONE_true;
		PixelShader = ps_main_compiled_PCF_NONE;
	}
}
technique diffuse_SHDW
{
	pass P0
	{
		VertexShader = vs_main_compiled_PCF_DEFAULT_true;
		PixelShader = ps_main_compiled_PCF_DEFAULT;
	}
}
technique diffuse_SHDWNVIDIA
{
	pass P0
	{
		VertexShader = vs_main_compiled_PCF_NVIDIA_true;
		PixelShader = ps_main_compiled_PCF_NVIDIA;
	}
}
DEFINE_LIGHTING_TECHNIQUE(diffuse, 0, 0, 0, 0, 0)

technique diffuse_dynamic
{
	pass P0
	{
		VertexShader = vs_main_compiled_PCF_NONE_false;
		PixelShader = ps_main_compiled_PCF_NONE;
	}
}
technique diffuse_dynamic_SHDW
{
	pass P0
	{
		VertexShader = vs_main_compiled_PCF_DEFAULT_false;
		PixelShader = ps_main_compiled_PCF_DEFAULT;
	}
}
technique diffuse_dynamic_SHDWNVIDIA
{
	pass P0
	{
		VertexShader = vs_main_compiled_PCF_NVIDIA_false;
		PixelShader = ps_main_compiled_PCF_NVIDIA;
	}
}
DEFINE_LIGHTING_TECHNIQUE(diffuse_dynamic, 0, 0, 0, 0, 0)


technique diffuse_dynamic_Instanced
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_Instanced(PCF_NONE, false);
		PixelShader = ps_main_compiled_PCF_NONE;
	}
}

technique diffuse_dynamic_Instanced_SHDW
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_Instanced(PCF_DEFAULT, false);
		PixelShader = ps_main_compiled_PCF_DEFAULT;
	}
}

technique diffuse_dynamic_Instanced_SHDWNVIDIA
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_Instanced(PCF_NVIDIA, false);
		PixelShader = ps_main_compiled_PCF_NVIDIA;
	}
}

technique envmap_metal
{
	pass P0
	{
		VertexShader = vs_main_compiled_PCF_NONE_true;
		PixelShader = ps_main_compiled_PCF_NONE;
	}
}
technique envmap_metal_SHDW
{
	pass P0
	{
		VertexShader = vs_main_compiled_PCF_DEFAULT_true;
		PixelShader = ps_main_compiled_PCF_DEFAULT;
	}
}
technique envmap_metal_SHDWNVIDIA
{
	pass P0
	{
		VertexShader = vs_main_compiled_PCF_NVIDIA_true;
		PixelShader = ps_main_compiled_PCF_NVIDIA;
	}
}
DEFINE_LIGHTING_TECHNIQUE(envmap_metal, 0, 0, 0, 0, 0)

//-----
struct VS_OUTPUT_BUMP
{
	float4 Pos					: POSITION;
	float4 VertexColor			: COLOR0;
	float2 Tex0					: TEXCOORD0;
	float3 SunLightDir			: TEXCOORD1;//sun light dir in pixel coordinates
	float3 SkyLightDir			: TEXCOORD2;//light diffuse for bump
	float4 PointLightDir		: TEXCOORD3;//light ambient for bump
	float4 ShadowTexCoord		: TEXCOORD4;
	float2 ShadowTexelPos		: TEXCOORD5;
	float  Fog					: FOG;
	
	float3 ViewDir				: TEXCOORD6;
	float3 WorldNormal			: TEXCOORD7;
};
VS_OUTPUT_BUMP vs_main_bump (uniform const int PcfMode, float4 vPosition : POSITION, float3 vNormal : NORMAL, float2 tc : TEXCOORD0,  float3 vTangent : TANGENT, float3 vBinormal : BINORMAL, float4 vVertexColor : COLOR0, float4 vPointLightDir : COLOR1)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_BUMP, Out);

	Out.Pos = mul(matWorldViewProj, vPosition);
	Out.Tex0 = tc;


	float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal)); //normal in world space
	float3 vWorld_binormal = normalize(mul((float3x3)matWorld, vBinormal)); //normal in world space
	float3 vWorld_tangent  = normalize(mul((float3x3)matWorld, vTangent)); //normal in world space

	float3 P = mul(matWorldView, vPosition); //position in view space

	float3x3 TBNMatrix = float3x3(vWorld_tangent, vWorld_binormal, vWorldN); 

	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	if (PcfMode != PCF_NONE)
	{	
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	}

	Out.SunLightDir = mul(TBNMatrix, -vSunDir);
	Out.SkyLightDir = mul(TBNMatrix, -vSkyLightDir);
	
	#ifdef USE_LIGHTING_PASS
	Out.PointLightDir = vWorldPos;
	#else
	Out.PointLightDir.rgb = 2.0f * vPointLightDir.rgb - 1.0f;
	Out.PointLightDir.a = vPointLightDir.a;
	#endif
	
	Out.VertexColor = vVertexColor;
	
	//STR: note that these are not in TBN space.. (used for fresnel only..)
	Out.ViewDir = normalize(vCameraPos.xyz - vWorldPos.xyz); //normalize(mul(TBNMatrix, (vCameraPos.xyz - vWorldPos.xyz) ));	// 
	//Out.ViewDir = mul(TBNMatrix, Out.ViewDir);

	Out.WorldNormal = vWorldN;
	//Out.WorldNormal = mul(TBNMatrix, Out.WorldNormal);

	//apply fog
	float d = length(P);
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);

	return Out;
}
PS_OUTPUT ps_main_bump( VS_OUTPUT_BUMP In, uniform const int PcfMode )
{ 
	PS_OUTPUT Output;
	
	float4 total_light = vAmbientColor;//In.LightAmbient;
	
	float3 normal;
	normal.xy = (2.0f * tex2D(NormalTextureSampler, In.Tex0).ag - 1.0f);
	normal.z = sqrt(1.0f - dot(normal.xy, normal.xy));

	if (PcfMode != PCF_NONE)
	{
		float sun_amount = 0.03f + GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
		total_light += ((saturate(dot(In.SunLightDir.xyz, normal.xyz)) * (sun_amount))) * vSunColor;
	}
	else
	{
		total_light += saturate(dot(In.SunLightDir.xyz, normal.xyz)) * vSunColor;
	}
	total_light += saturate(dot(In.SkyLightDir.xyz, normal.xyz)) * vSkyLightColor;
	
	#ifndef USE_LIGHTING_PASS
		total_light += saturate(dot(In.PointLightDir.xyz, normal.xyz)) * vPointLightColor;
	#endif
	
	if(bNightVision == 1)
	total_light.rgb += flashlight(length(mul(matView, In.PointLightDir.xyz)), In.ViewDir, normal);

	Output.RGBColor.rgb = total_light.rgb;
	Output.RGBColor.a = 1.0f;
	Output.RGBColor *= vMaterialColor;
	
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0);
	INPUT_TEX_GAMMA(tex_col.rgb);

	Output.RGBColor *= tex_col;
	Output.RGBColor *= In.VertexColor;
	
	//	Output.RGBColor = saturate(Output.RGBColor);
	OUTPUT_GAMMA(Output.RGBColor.rgb);

	return Output;
}
PS_OUTPUT ps_main_bump_simple( VS_OUTPUT_BUMP In, uniform const int PcfMode )
{ 
	PS_OUTPUT Output;
	
	float4 total_light = vAmbientColor;//In.LightAmbient;
/*-	//Parallax mapping:
	//float viewVec_len = length(In.ViewDir);
	//float3 viewVec = In.ViewDir / viewVec_len;
	float3 viewVec = normalize(In.ViewDir);
	{
		float2 plxCoeffs = float2(0.04, -0.02) * debug_vector.w;
		float height = tex2D(NormalTextureSampler, In.Tex0).a;
		float offset = height * plxCoeffs.x + plxCoeffs.y;
		In.Tex0 = In.Tex0 + offset * viewVec.xy;
	}
*/
	
	float3 normal = (2.0f * tex2D(NormalTextureSampler, In.Tex0).rgb - 1.0f);

	float sun_amount = 1.0f;
	if (PcfMode != PCF_NONE)
	{
		if (PcfMode == PCF_NVIDIA)
			sun_amount = saturate( 0.15f + GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos) );
		else
			sun_amount = GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);	//cannot fit 64 instruction
	}
	total_light += ((saturate(dot(In.SunLightDir.xyz, normal.xyz)) * (sun_amount * sun_amount))) * vSunColor;
	
	total_light += saturate(dot(In.SkyLightDir.xyz, normal.xyz)) * vSkyLightColor;
	#ifndef USE_LIGHTING_PASS
		total_light += saturate(dot(In.PointLightDir.xyz, normal.xyz)) * vPointLightColor;
	#endif
	
	if(bNightVision == 1)
	total_light.rgb += flashlight(length(mul(matView, In.PointLightDir.xyz)), In.ViewDir, normal);

	Output.RGBColor.rgb = total_light.rgb;
	Output.RGBColor.a = 1.0f;
	Output.RGBColor *= vMaterialColor;
	
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0);
	INPUT_TEX_GAMMA(tex_col.rgb);

	Output.RGBColor *= tex_col;
	Output.RGBColor *= In.VertexColor;
	
	//	Output.RGBColor = saturate(Output.RGBColor);
	
	
	float fresnel = 1-(saturate(dot( In.ViewDir, In.WorldNormal)));
	//-float fresnel = 1-(saturate(dot( viewVec, In.WorldNormal)));

	// Output.RGBColor.rgb *= fresnel; 
	Output.RGBColor.rgb *= max(0.6,fresnel*fresnel+0.1); 
	
	Output.RGBColor.rgb = OUTPUT_GAMMA(Output.RGBColor.rgb);


	return Output;
}
PS_OUTPUT ps_main_bump_simple_multitex( VS_OUTPUT_BUMP In, uniform const int PcfMode )
{ 
	PS_OUTPUT Output;
	
	float4 total_light = vAmbientColor;//In.LightAmbient;
	
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0);
	float4 tex_col2 = tex2D(Diffuse2Sampler, In.Tex0 * uv_2_scale);
	
	float4 multi_tex_col = tex_col;
	float inv_alpha = (1.0f - In.VertexColor.a);
	multi_tex_col.rgb *= inv_alpha;
	multi_tex_col.rgb += tex_col2.rgb * In.VertexColor.a;
	
	//!!
	INPUT_TEX_GAMMA(multi_tex_col.rgb);

	float3 normal = (2.0f * tex2D(NormalTextureSampler, In.Tex0).rgb - 1.0f);

	float sun_amount = 1.0f;
	if (PcfMode != PCF_NONE)
	{
		if (PcfMode == PCF_NVIDIA)
			sun_amount = saturate( 0.15f + GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos) );
		else
			sun_amount = GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);	//cannot fit 64 instruction
	}
	total_light += (saturate(dot(In.SunLightDir.xyz, normal.xyz)) * (sun_amount)) * vSunColor;
	
	total_light += saturate(dot(In.SkyLightDir.xyz, normal.xyz)) * vSkyLightColor;
	#ifndef USE_LIGHTING_PASS
		total_light += saturate(dot(In.PointLightDir.xyz, normal.xyz)) * vPointLightColor;
	#endif
	
	if(bNightVision == 1)
	total_light.rgb += flashlight(length(mul(matView, In.PointLightDir.xyz)), In.ViewDir, normal);

	Output.RGBColor.rgb = total_light.rgb;
	Output.RGBColor.a = 1.0f;
	//	Output.RGBColor *= vMaterialColor;
	

	
	Output.RGBColor *= multi_tex_col;
	//Output.RGBColor.rgb *= In.VertexColor.rgb; //Remove Colors from Scene Ground 
	Output.RGBColor.a *= In.PointLightDir.a;
	
	
	float fresnel = 1-(saturate(dot( normalize(In.ViewDir), normalize(In.WorldNormal))));
	// Output.RGBColor.rgb *= fresnel; 
	Output.RGBColor.rgb *= max(0.6,fresnel*fresnel+0.1); 
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	
	
	return Output;
}

VertexShader vs_main_bump_compiled_PCF_NONE = compile vs_2_0 vs_main_bump(PCF_NONE);
VertexShader vs_main_bump_compiled_PCF_DEFAULT = compile vs_2_0 vs_main_bump(PCF_DEFAULT);
VertexShader vs_main_bump_compiled_PCF_NVIDIA = compile vs_2_a vs_main_bump(PCF_NVIDIA);


technique bumpmap
{
	pass P0
	{
		VertexShader = vs_main_bump_compiled_PCF_NONE;
		PixelShader = compile ps_2_a ps_main_bump(PCF_NONE);
	}
}
technique bumpmap_SHDW
{
	pass P0
	{
		VertexShader = vs_main_bump_compiled_PCF_DEFAULT;
		PixelShader = compile ps_2_a ps_main_bump(PCF_DEFAULT);
	}
}
technique bumpmap_SHDWNVIDIA
{
	pass P0
	{
		VertexShader = vs_main_bump_compiled_PCF_NVIDIA;
		PixelShader = compile ps_2_a ps_main_bump(PCF_NVIDIA);
	}
}

DEFINE_LIGHTING_TECHNIQUE(bumpmap, 1, 1, 0, 0, 0)

//-----
technique dot3
{
	pass P0
	{
		VertexShader = vs_main_bump_compiled_PCF_NONE;
		PixelShader = compile ps_2_a ps_main_bump_simple(PCF_NONE);
	}
}
technique dot3_SHDW
{
	pass P0
	{
		VertexShader = vs_main_bump_compiled_PCF_DEFAULT;
		PixelShader = compile ps_2_a ps_main_bump_simple(PCF_DEFAULT);
	}
}
technique dot3_SHDWNVIDIA
{
	pass P0
	{
		VertexShader = vs_main_bump_compiled_PCF_NVIDIA;
		PixelShader = compile ps_2_a ps_main_bump_simple(PCF_NVIDIA);
	}
}
DEFINE_LIGHTING_TECHNIQUE(dot3, 0, 1, 0, 0, 0)
//-----
technique dot3_multitex
{
	pass P0
	{
		VertexShader = vs_main_bump_compiled_PCF_NONE;
		PixelShader = compile ps_2_a ps_main_bump_simple_multitex(PCF_NONE);
	}
}
technique dot3_multitex_SHDW
{
	pass P0
	{
		VertexShader = vs_main_bump_compiled_PCF_DEFAULT;
		PixelShader = compile ps_2_a ps_main_bump_simple_multitex(PCF_DEFAULT);
	}
}
technique dot3_multitex_SHDWNVIDIA
{
	pass P0
	{
		VertexShader = vs_main_bump_compiled_PCF_NVIDIA;
		PixelShader = compile ps_2_a ps_main_bump_simple_multitex(PCF_NVIDIA);
	}
}
DEFINE_LIGHTING_TECHNIQUE(dot3_multitex, 0, 1, 0, 0, 0)
//---
struct VS_OUTPUT_ENVMAP_SPECULAR
{
	float4 Pos					: POSITION;
	float  Fog				    : FOG;
	
	float4 Color				: COLOR0;
	float4 Tex0					: TEXCOORD0;
	float4 SunLight				: TEXCOORD1;
	float4 ShadowTexCoord		: TEXCOORD2;
	float2 ShadowTexelPos		: TEXCOORD3;
	float3 vSpecular            : TEXCOORD4;
};
VS_OUTPUT_ENVMAP_SPECULAR vs_envmap_specular(uniform const int PcfMode, float4 vPosition : POSITION, float3 vNormal : NORMAL, float2 tc : TEXCOORD0, float4 vColor : COLOR0)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_ENVMAP_SPECULAR, Out);

	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal)); //normal in world space
	
	//apply fog
	float3 P = mul(matWorldView, vPosition); //position in view space
	float d = length(P);
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);
	
	if(bUseMotionBlur)	//motion blur flag!?!
	{
		float4 vWorldPos1 = mul(matMotionBlur, vPosition);
		float3 delta_vector = vWorldPos1 - vWorldPos;
		float maxMoveLength = length(delta_vector);
		float3 moveDirection = delta_vector / maxMoveLength; //normalize(delta_vector);
		
		if(maxMoveLength > 0.25f)
		{
			maxMoveLength = 0.25f;
			vWorldPos1.xyz = vWorldPos.xyz + delta_vector * maxMoveLength;
		}
		
		float delta_coefficient_sharp = (dot(vWorldN, moveDirection) > 0.12f) ? 1 : 0;

		float y_factor = saturate(vPosition.y+0.15);
		vWorldPos = lerp(vWorldPos, vWorldPos1, delta_coefficient_sharp * y_factor);

		float delta_coefficient_smooth = saturate(dot(vWorldN, moveDirection) + 0.5f);

		float extra_alpha = 0.1f;
		float start_alpha = (1.0f+extra_alpha);
		float end_alpha = start_alpha - 1.8f;
		float alpha = saturate(lerp(start_alpha, end_alpha, delta_coefficient_smooth));
		vColor.a = saturate(0.5f - vPosition.y) + alpha + 0.25;
		
		Out.Pos = mul(matViewProj, vWorldPos);
	}
	else 
	{
		Out.Pos = mul(matWorldViewProj, vPosition);
	}

	Out.Tex0.xy = tc;

	float3 relative_cam_pos = normalize(vCameraPos - vWorldPos);
	float2 envpos;
	float3 tempvec = relative_cam_pos - vWorldN;
	float3 vHalf = normalize(relative_cam_pos - vSunDir);
	float3 fSpecular = spec_coef * vSunColor * vSpecularColor * pow( saturate( dot( vHalf, vWorldN) ), fMaterialPower);
	Out.vSpecular = fSpecular;
	Out.vSpecular *= vColor.rgb;

	envpos.x = (tempvec.y);// + tempvec.x);
	envpos.y = tempvec.z;
	envpos += 1.0f;
	//   envpos *= 0.5f;

	Out.Tex0.zw = envpos;

	float4 diffuse_light = vAmbientColor;
	
	if(bNightVision == 1)
	diffuse_light.rgb += flashlight(d, relative_cam_pos, vWorldN);
	//   diffuse_light.rgb *= gradient_factor * (gradient_offset + vWorldN.z);


	//directional lights, compute diffuse color
	diffuse_light += saturate(dot(vWorldN, -vSkyLightDir)) * vSkyLightColor;

	//point lights
	#ifndef USE_LIGHTING_PASS
	diffuse_light += calculate_point_lights_diffuse(vWorldPos, vWorldN, false, false);
	#endif
	
	//apply material color
	//	Out.Color = min(1, vMaterialColor * vColor * diffuse_light);
	Out.Color = (vMaterialColor * vColor * diffuse_light);
	//shadow mapping variables
	float wNdotSun = max(-0.0001f,dot(vWorldN, -vSunDir));
	Out.SunLight = (wNdotSun) * vSunColor * vMaterialColor * vColor;
	Out.SunLight.a = vColor.a;

	if (PcfMode != PCF_NONE)
	{
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	}
	

	return Out;
}


VS_OUTPUT_ENVMAP_SPECULAR vs_envmap_specular_Instanced(uniform const int PcfMode, float4 vPosition : POSITION, float3 vNormal : NORMAL, 
														float2 tc : TEXCOORD0, float4 vColor : COLOR0,
														 //instance data:
													   float3   vInstanceData0 : TEXCOORD1, float3   vInstanceData1 : TEXCOORD2,
													   float3   vInstanceData2 : TEXCOORD3, float3   vInstanceData3 : TEXCOORD4)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_ENVMAP_SPECULAR, Out);

	float4x4 matWorldOfInstance = build_instance_frame_matrix(vInstanceData0, vInstanceData1, vInstanceData2, vInstanceData3);

	float4 vWorldPos = mul(matWorldOfInstance, vPosition);
	float3 vWorldN = normalize(mul((float3x3)matWorldOfInstance, vNormal));	
	
	
	if(bUseMotionBlur)	//motion blur flag!?!
	{
		float4 vWorldPos1;
		float3 moveDirection;
		if(true)	//instanced meshes dont have valid matMotionBlur!
		{
			const float blur_len = 0.2f;
			moveDirection = -normalize( float3(matWorldOfInstance[0][0],matWorldOfInstance[1][0],matWorldOfInstance[2][0]) );	//using x axis !
			moveDirection.y -= blur_len * 0.285;	//low down blur for big blur_lens (show more like a spline)
			vWorldPos1 = vWorldPos + float4(moveDirection,0) * blur_len;
		}
		else
		{
			vWorldPos1 = mul(matMotionBlur, vPosition);
			moveDirection = normalize(vWorldPos1 - vWorldPos);
		}
		
		   
		float delta_coefficient_sharp = (dot(vWorldN, moveDirection) > 0.12f) ? 1 : 0;

		float y_factor = saturate(vPosition.y+0.15);
		vWorldPos = lerp(vWorldPos, vWorldPos1, delta_coefficient_sharp * y_factor);

		float delta_coefficient_smooth = saturate(dot(vWorldN, moveDirection) + 0.5f);

		float extra_alpha = 0.1f;
		float start_alpha = (1.0f+extra_alpha);
		float end_alpha = start_alpha - 1.8f;
		float alpha = saturate(lerp(start_alpha, end_alpha, delta_coefficient_smooth));
		vColor.a = saturate(0.5f - vPosition.y) + alpha + 0.25;
	}
	
	Out.Pos = mul(matViewProj, vWorldPos);

	Out.Tex0.xy = tc;
	
	//apply fog
	float3 P = mul(matView, vWorldPos); //position in view space
	float d = length(P);
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);

	float3 relative_cam_pos = normalize(vCameraPos - vWorldPos);
	float2 envpos;
	float3 tempvec = relative_cam_pos - vWorldN;
	float3 vHalf = normalize(relative_cam_pos - vSunDir);
	float3 fSpecular = spec_coef * vSunColor * vSpecularColor * pow( saturate( dot( vHalf, vWorldN) ), fMaterialPower);
	Out.vSpecular = fSpecular;
	Out.vSpecular *= vColor.rgb;

	envpos.x = (tempvec.y);// + tempvec.x);
	envpos.y = tempvec.z;
	envpos += 1.0f;
	//   envpos *= 0.5f;

	Out.Tex0.zw = envpos;

	float4 diffuse_light = vAmbientColor;
	//   diffuse_light.rgb *= gradient_factor * (gradient_offset + vWorldN.z);


	//directional lights, compute diffuse color
	diffuse_light += saturate(dot(vWorldN, -vSkyLightDir)) * vSkyLightColor;

	//point lights
	#ifndef USE_LIGHTING_PASS
	diffuse_light += calculate_point_lights_diffuse(vWorldPos, vWorldN, false, false);
	#endif
	
	if(bNightVision == 1)
	diffuse_light.rgb += flashlight(d, relative_cam_pos, vWorldN);
	
	//apply material color
	//	Out.Color = min(1, vMaterialColor * vColor * diffuse_light);
	Out.Color = (vMaterialColor * vColor * diffuse_light);
	//shadow mapping variables
	float wNdotSun = max(-0.0001f,dot(vWorldN, -vSunDir));
	Out.SunLight = (wNdotSun) * vSunColor * vMaterialColor * vColor;
	Out.SunLight.a = vColor.a;

	if (PcfMode != PCF_NONE)
	{
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	}

	return Out;
}

PS_OUTPUT ps_envmap_specular(VS_OUTPUT_ENVMAP_SPECULAR In, uniform const int PcfMode)
{
	PS_OUTPUT Output;
	
	// Compute half vector for specular lighting
	//   float3 vHalf = normalize(normalize(-ViewPos) + normalize(g_vLight - ViewPos));
	float4 texColor = tex2D(MeshTextureSampler, In.Tex0.xy);
	INPUT_TEX_GAMMA(texColor.rgb);
	
	float3 specTexture = tex2D(SpecularTextureSampler, In.Tex0.xy).rgb;
	float3 fSpecular = specTexture * In.vSpecular.rgb;
	
	//	float3 relative_cam_pos = normalize(vCameraPos - In.worldPos);
	//	float3 vHalf = normalize(relative_cam_pos - vSunDir);
	/*	
	float2 envpos;
	float3 tempvec =relative_cam_pos -  In.worldNormal ;
//	envpos.x = tempvec.x;
//	envpos.y = tempvec.z;
	envpos.xy = tempvec.xz;
	envpos += 1.0f;
	envpos *= 0.5f;
*/	
	float3 envColor = tex2D(EnvTextureSampler, In.Tex0.zw).rgb;
	
	// Compute normal dot half for specular light
	//	float4 fSpecular = 4.0f * specColor * vSpecularColor * pow( saturate( dot( vHalf, normalize( In.worldNormal) ) ), fMaterialPower);

	
	if ((PcfMode != PCF_NONE))
	{
		
		float sun_amount = 0.1f + GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
		//		sun_amount *= sun_amount;
		float4 vcol = In.Color;
		vcol.rgb += (In.SunLight.rgb + fSpecular) * sun_amount;
		Output.RGBColor = (texColor * vcol);
		Output.RGBColor.rgb += (In.SunLight * sun_amount + 0.3f) * (In.Color.rgb * envColor.rgb * specTexture);
	}
	else
	{
		float4 vcol = In.Color;
		vcol.rgb += (In.SunLight.rgb + fSpecular);
		Output.RGBColor = (texColor * vcol);
		Output.RGBColor.rgb += (In.SunLight + 0.3f) * (In.Color.rgb * envColor.rgb * specTexture);
	}

	OUTPUT_GAMMA(Output.RGBColor.rgb);
	
	Output.RGBColor.a = 1.0f;
	
	if(bUseMotionBlur)
		Output.RGBColor.a = In.SunLight.a;
		
	return Output;
}


PS_OUTPUT ps_envmap_specular_singlespec(VS_OUTPUT_ENVMAP_SPECULAR In, uniform const int PcfMode)	//only differs by black-white specular texture usage
{
	PS_OUTPUT Output;
	
	// Compute half vector for specular lighting
	
	float2 spectex_Col = tex2D(SpecularTextureSampler, In.Tex0.xy).ag;
	float specTexture = dot(spectex_Col, spectex_Col) * 0.5;
	float3 fSpecular = specTexture * In.vSpecular.rgb;
	
	float4 texColor = saturate( (saturate(In.Color+0.5f)*specTexture)*2.0f+0.25f);
	// INPUT_TEX_GAMMA(texColor.rgb);
	
	//	float3 relative_cam_pos = normalize(vCameraPos - In.worldPos);
	//	float3 vHalf = normalize(relative_cam_pos - vSunDir);
	/*	
	float2 envpos;
	float3 tempvec =relative_cam_pos -  In.worldNormal ;
//	envpos.x = tempvec.x;
//	envpos.y = tempvec.z;
	envpos.xy = tempvec.xz;
	envpos += 1.0f;
	envpos *= 0.5f;
*/	
	float3 envColor = tex2D(EnvTextureSampler, In.Tex0.zw).rgb;
	
	// Compute normal dot half for specular light
	//	float4 fSpecular = 4.0f * specColor * vSpecularColor * pow( saturate( dot( vHalf, normalize( In.worldNormal) ) ), fMaterialPower);

	
	if ((PcfMode != PCF_NONE))
	{
		float sun_amount = 0.1f + GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
		//		sun_amount *= sun_amount;
		float4 vcol = In.Color;
		vcol.rgb += (In.SunLight.rgb + fSpecular) * sun_amount;
		Output.RGBColor = (texColor * vcol);
		Output.RGBColor.rgb += (In.SunLight * sun_amount + 0.3f) * (In.Color.rgb * envColor.rgb * specTexture);
	}
	else
	{
		float4 vcol = In.Color;
		vcol.rgb += (In.SunLight.rgb + fSpecular);
		Output.RGBColor = (texColor * vcol);
		Output.RGBColor.rgb += (In.SunLight + 0.3f) * (In.Color.rgb * envColor.rgb * specTexture);
	}

	OUTPUT_GAMMA(Output.RGBColor.rgb);
	
	Output.RGBColor.a = 1.0f;
	/*
	if(bUseMotionBlur)
		Output.RGBColor.a = In.SunLight.a;
	*/
	
	return Output;
}

DEFINE_TECHNIQUES(envmap_specular_diffuse, vs_envmap_specular, ps_envmap_specular)
DEFINE_TECHNIQUES(envmap_specular_diffuse_Instanced, vs_envmap_specular_Instanced, ps_envmap_specular)
DEFINE_TECHNIQUES(watermap_for_objects, vs_envmap_specular, ps_envmap_specular_singlespec)

//---
struct VS_OUTPUT_BUMP_DYNAMIC
{
	float4 Pos					: POSITION;
	float4 VertexColor			: COLOR0;
	float2 Tex0					: TEXCOORD0;
	#ifndef USE_LIGHTING_PASS
	float3 vec_to_light_0		: TEXCOORD1;
	float3 vec_to_light_1		: TEXCOORD2;
	float3 vec_to_light_2		: TEXCOORD3;
	#endif
	//    float4 vec_to_light_3		: TEXCOORD4;
	//    float4 vec_to_light_4		: TEXCOORD5;
	//    float4 vec_to_light_5		: TEXCOORD6;
	//    float4 vec_to_light_6		: TEXCOORD7;
	float  Fog					: FOG;
};
VS_OUTPUT_BUMP_DYNAMIC vs_main_bump_interior (float4 vPosition : POSITION, float3 vNormal : NORMAL, float2 tc : TEXCOORD0,  float3 vTangent : TANGENT, float3 vBinormal : BINORMAL, float4 vVertexColor : COLOR0)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_BUMP_DYNAMIC, Out);

	float4 vWorldPos = (float4)mul(matWorld,vPosition);
   Out.Pos = mul(matWorldViewProj, vPosition);
   Out.Tex0 = tc;
   
   float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal)); //normal in world space
   float3 vWorld_binormal = normalize(mul((float3x3)matWorld, vBinormal)); //normal in world space
   float3 vWorld_tangent  = normalize(mul((float3x3)matWorld, vTangent)); //normal in world space


   float3x3 TBNMatrix = float3x3(vWorld_tangent, vWorld_binormal, vWorldN); 

	#ifndef USE_LIGHTING_PASS
	float3 point_to_light = vLightPosDir[iLightIndices[0]]-vWorldPos.xyz;
	Out.vec_to_light_0.xyz =  mul(TBNMatrix, point_to_light);
	point_to_light = vLightPosDir[iLightIndices[1]]-vWorldPos.xyz;
	Out.vec_to_light_1.xyz =  mul(TBNMatrix, point_to_light);
	point_to_light = vLightPosDir[iLightIndices[2]]-vWorldPos.xyz;
	Out.vec_to_light_2.xyz =  mul(TBNMatrix, point_to_light);
	#endif
	
   	Out.VertexColor = vVertexColor;

   //apply fog
   float3 P = mul(matWorldView, vPosition); //position in view space
   float d = length(P);
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);
   return Out;
}
PS_OUTPUT ps_main_bump_interior( VS_OUTPUT_BUMP_DYNAMIC In)
{ 
    PS_OUTPUT Output;
    
    float4 total_light = vAmbientColor;//In.LightAmbient;
    

	#ifndef USE_LIGHTING_PASS
	float3 normal;
	normal.xy = (2.0f * tex2D(NormalTextureSampler, In.Tex0).ag - 1.0f);
	normal.z = sqrt(1.0f - dot(normal.xy, normal.xy));
 
//	float3 abs_min_vec_to_light = float3(100000, 100000, 100000);
    
//	float LD = In.vec_to_light_0.w;
	float LD = dot(In.vec_to_light_0.xyz,In.vec_to_light_0.xyz);
	float3 L = normalize(In.vec_to_light_0.xyz);
	float wNdotL = dot(normal, L);
	total_light += saturate(wNdotL) * vLightDiffuse[iLightIndices[0]] /(LD);
	
//	LD = In.vec_to_light_1.w;
	LD = dot(In.vec_to_light_1.xyz,In.vec_to_light_1.xyz);
	L = normalize(In.vec_to_light_1.xyz);
	wNdotL = dot(normal, L);
	total_light += saturate(wNdotL) * vLightDiffuse[iLightIndices[1]] /(LD);

//	LD = In.vec_to_light_2.w;
	LD = dot(In.vec_to_light_2.xyz,In.vec_to_light_2.xyz);
	L = normalize(In.vec_to_light_2.xyz);
	wNdotL = dot(normal, L);
	total_light += saturate(wNdotL) * vLightDiffuse[iLightIndices[2]] /(LD);
	#endif

//	Output.RGBColor = saturate(total_light * 0.6f) * 1.66f;
	Output.RGBColor = float4(total_light.rgb, 1.0);
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0);
    INPUT_TEX_GAMMA(tex_col.rgb);

	Output.RGBColor *= tex_col;
	Output.RGBColor *= In.VertexColor;
	
//	Output.RGBColor = saturate(Output.RGBColor);
    Output.RGBColor.rgb = saturate(OUTPUT_GAMMA(Output.RGBColor.rgb));
    Output.RGBColor.a = In.VertexColor.a;

	return Output;
}

technique bumpmap_interior
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_bump_interior();
		PixelShader = compile ps_2_a ps_main_bump_interior();
	}
}

struct VS_OUTPUT_BUMP_DYNAMIC_NEW
{
	float4 Pos					: POSITION;
	float4 VertexColor			: COLOR0;
	float2 Tex0					: TEXCOORD0;
	#ifndef USE_LIGHTING_PASS
	float3 vec_to_light_0		: TEXCOORD1;
	float3 vec_to_light_1		: TEXCOORD2;
	float3 vec_to_light_2		: TEXCOORD3;
	#endif
	float3 ViewDir				: TEXCOORD4;
	float Dist				: TEXCOORD5;
	
	float  Fog					: FOG;
};


VS_OUTPUT_BUMP_DYNAMIC_NEW vs_main_bump_interior_new (float4 vPosition : POSITION, float3 vNormal : NORMAL, float2 tc : TEXCOORD0,  float3 vTangent : TANGENT, float3 vBinormal : BINORMAL, float4 vVertexColor : COLOR0)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_BUMP_DYNAMIC_NEW, Out);

	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	Out.Pos = mul(matWorldViewProj, vPosition);
	Out.Tex0 = tc;

	float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal)); //normal in world space
	float3 vWorld_binormal = normalize(mul((float3x3)matWorld, vBinormal)); //normal in world space
	float3 vWorld_tangent  = normalize(mul((float3x3)matWorld, vTangent)); //normal in world space


	float3x3 TBNMatrix = float3x3(vWorld_tangent, vWorld_binormal, vWorldN); 

	#ifndef USE_LIGHTING_PASS
	float3 point_to_light = vLightPosDir[iLightIndices[0]]-vWorldPos.xyz;
	Out.vec_to_light_0.xyz =  mul(TBNMatrix, point_to_light);
	point_to_light = vLightPosDir[iLightIndices[1]]-vWorldPos.xyz;
	Out.vec_to_light_1.xyz =  mul(TBNMatrix, point_to_light);
	point_to_light = vLightPosDir[iLightIndices[2]]-vWorldPos.xyz;
	Out.vec_to_light_2.xyz =  mul(TBNMatrix, point_to_light);
	#endif
	
	Out.VertexColor = vVertexColor;
	
	float3 viewdir = normalize(vCameraPos.xyz - vWorldPos.xyz);
	Out.ViewDir =  mul(TBNMatrix, viewdir);

	//apply fog
	float3 P = mul(matWorldView, vPosition); //position in view space
	float d = length(P);
	Out.Dist = d;
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);
	return Out;
}

//uses standart-style normal maps
PS_OUTPUT ps_main_bump_interior_new( VS_OUTPUT_BUMP_DYNAMIC_NEW In, uniform const bool use_specularmap ) //ps_main_bump_interior with std normalmaps
{ 
	PS_OUTPUT Output;
	
	float4 total_light = vAmbientColor;
	
	

	// effective lights!?

	#ifndef USE_LIGHTING_PASS
	float3 normal = 2.0f * tex2D(NormalTextureSampler, In.Tex0).rgb - 1.0f;
	
	
	//	float LD = In.vec_to_light_0.w;
	float LD_0 = saturate(1.0f / dot(In.vec_to_light_0.xyz,In.vec_to_light_0.xyz));
	float3 L_0 = normalize(In.vec_to_light_0.xyz);
	float wNdotL_0 = dot(normal, L_0);
	total_light += saturate(wNdotL_0) * vLightDiffuse[ iLightIndices[0] ] * (LD_0);

	//	LD = In.vec_to_light_1.w;
	float LD_1 = saturate(1.0f / dot(In.vec_to_light_1.xyz,In.vec_to_light_1.xyz));
	float3 L_1 = normalize(In.vec_to_light_1.xyz);
	float wNdotL_1 = dot(normal, L_1);
	total_light += saturate(wNdotL_1) * vLightDiffuse[ iLightIndices[1] ] * (LD_1);

	//	LD = In.vec_to_light_2.w;
	float LD_2 = saturate(1.0f / dot(In.vec_to_light_2.xyz,In.vec_to_light_2.xyz));
	float3 L_2 = normalize(In.vec_to_light_2.xyz);
	float wNdotL_2 = dot(normal, L_2);
	total_light += saturate(wNdotL_2) * vLightDiffuse[ iLightIndices[2] ] * (LD_2);
	#endif
	
	if(bNightVision == 1)
	total_light.rgb += flashlight(In.Dist, In.ViewDir, normal);
	
	//	Output.RGBColor = saturate(total_light * 0.6f) * 1.66f;
	Output.RGBColor = float4(total_light.rgb, 1.0);
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0);
	INPUT_TEX_GAMMA(tex_col.rgb);

	Output.RGBColor *= tex_col;
	Output.RGBColor *= In.VertexColor;
	
	if(use_specularmap)
	{
		float4 fSpecular = 0;
		
		//light0 specular
		float4 light0_specColor = vLightDiffuse[ iLightIndices[0] ] * LD_0;
		float3 vHalf_0 = normalize( In.ViewDir + L_0 );
		fSpecular = light0_specColor * pow( saturate(dot(vHalf_0, normal)), fMaterialPower);
		
		/* makes 65 instruction:
		//light1 specular
		float4 light1_specColor = vLightDiffuse[ iLightIndices[1] ] * LD_1;
		float3 vHalf_1 = normalize( In.ViewDir + L_1 );
		fSpecular += light1_specColor * pow( saturate(dot(vHalf_1, normal)), fMaterialPower);
		*/
		//light2 specular
		//float4 light2_specColor = vLightDiffuse[2] * LD_2;
		//float3 vHalf_2 = normalize( In.ViewDir + L_2 );
		//fSpecular += light2_specColor * pow( saturate(dot(vHalf_2, normal)), fMaterialPower);
		
		float4 specColor = 0.1 * spec_coef * vSpecularColor;
		//float spec_tex_factor = dot(tex2D(SpecularTextureSampler, In.Tex0).rgb,0.33);
		//get more precision from specularmap
			
		float spec_tex_factor = tex2D(SpecularTextureSampler, In.Tex0).rgb;
		specColor *= spec_tex_factor;
		
		Output.RGBColor += specColor * fSpecular;
	}
	
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	Output.RGBColor = saturate(Output.RGBColor);
	Output.RGBColor.a = In.VertexColor.a;
	
	return Output;
}

technique bumpmap_interior_new
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_bump_interior_new();
		PixelShader = compile ps_2_a ps_main_bump_interior_new(false);
	}
}

technique bumpmap_interior_new_specmap
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_bump_interior_new();
		PixelShader = compile ps_2_a ps_main_bump_interior_new(true);
	}
}

DEFINE_LIGHTING_TECHNIQUE(bumpmap_interior, 1, 1, 0, 0, 0)
#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef STANDART_SHADERS


struct VS_OUTPUT_STANDART 
{
	float4 Pos					: POSITION;
	float  Fog					: FOG;
	
	float4 VertexColor			: COLOR0;
	#ifdef INCLUDE_VERTEX_LIGHTING 
	float3 VertexLighting		: COLOR1;
	#endif
	
	float2 Tex0					: TEXCOORD0;
	float3 SunLightDir			: TEXCOORD1;
	float3 SkyLightDir			: TEXCOORD2;
	#ifndef USE_LIGHTING_PASS 
	float4 PointLightDir		: TEXCOORD3;
	#endif
	float4 ShadowTexCoord		: TEXCOORD4;
	float2 ShadowTexelPos		: TEXCOORD5;
	float3 ViewDir				: TEXCOORD6;
};

VS_OUTPUT_STANDART vs_main_standart (uniform const int PcfMode, uniform const bool use_bumpmap, uniform const bool use_skinning, 
										float4 vPosition : POSITION, float3 vNormal : NORMAL, float2 tc : TEXCOORD0,  float3 vTangent : TANGENT, float3 vBinormal : BINORMAL, 
										float4 vVertexColor : COLOR0, float4 vBlendWeights : BLENDWEIGHT, float4 vBlendIndices : BLENDINDICES)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_STANDART, Out);
	
	float4 vObjectPos;
	float3 vObjectN, vObjectT, vObjectB;
	
	if(use_skinning) {
		vObjectPos = skinning_deform(vPosition, vBlendWeights, vBlendIndices);
		
		vObjectN = normalize(  mul((float3x3)matWorldArray[vBlendIndices.x], vNormal) * vBlendWeights.x
									+ mul((float3x3)matWorldArray[vBlendIndices.y], vNormal) * vBlendWeights.y
									+ mul((float3x3)matWorldArray[vBlendIndices.z], vNormal) * vBlendWeights.z
									+ mul((float3x3)matWorldArray[vBlendIndices.w], vNormal) * vBlendWeights.w);
									
		if(use_bumpmap)
		{
			vObjectT = normalize(  mul((float3x3)matWorldArray[vBlendIndices.x], vTangent) * vBlendWeights.x
										+ mul((float3x3)matWorldArray[vBlendIndices.y], vTangent) * vBlendWeights.y
										+ mul((float3x3)matWorldArray[vBlendIndices.z], vTangent) * vBlendWeights.z
										+ mul((float3x3)matWorldArray[vBlendIndices.w], vTangent) * vBlendWeights.w);
			
			// vObjectB = normalize(  mul((float3x3)matWorldArray[vBlendIndices.x], vBinormal) * vBlendWeights.x
			// 				+ mul((float3x3)matWorldArray[vBlendIndices.y], vBinormal) * vBlendWeights.y
			// 				+ mul((float3x3)matWorldArray[vBlendIndices.z], vBinormal) * vBlendWeights.z
			// 				+ mul((float3x3)matWorldArray[vBlendIndices.w], vBinormal) * vBlendWeights.w);
			vObjectB = /*normalize*/( cross( vObjectN, vObjectT ));	
			bool left_handed = (dot(cross(vNormal,vTangent),vBinormal) < 0.0f);
			if(left_handed) {
				vObjectB = -vObjectB;
			}
		}
	}
	else {
		vObjectPos = vPosition;
		
		vObjectN = vNormal;
									
		if(use_bumpmap)
		{
			vObjectT = vTangent;
			vObjectB = vBinormal;
		}
	}
	
	float4 vWorldPos = mul(matWorld, vObjectPos);
	float3 vWorldN = normalize(mul((float3x3)matWorld, vObjectN));	
	
	const bool use_motion_blur = bUseMotionBlur && (!use_skinning);
	
	if(use_motion_blur)	//motion blur flag!?!
	{
		#ifdef STATIC_MOVEDIR //(used in instanced rendering )
			const float blur_len = 0.25f;
			float3 moveDirection = -normalize( float3(matWorld[0][0],matWorld[1][0],matWorld[2][0]) );
			moveDirection.y -= blur_len * 0.285;	//low down blur for big blur_lens (show more like a spline)
			float4 vWorldPos1 = vWorldPos + float4(moveDirection,0) * blur_len;
		#else 
			float4 vWorldPos1 = mul(matMotionBlur, vObjectPos);
			float3 moveDirection = normalize(vWorldPos1 - vWorldPos);
		#endif
		
		   
		float delta_coefficient_sharp = (dot(vWorldN, moveDirection) > 0.1f) ? 1 : 0;

		float y_factor = saturate(vObjectPos.y+0.15);
		vWorldPos = lerp(vWorldPos, vWorldPos1, delta_coefficient_sharp * y_factor);

		float delta_coefficient_smooth = saturate(dot(vWorldN, moveDirection) + 0.5f);

		float extra_alpha = 0.1f;
		float start_alpha = (1.0f+extra_alpha);
		float end_alpha = start_alpha - 1.8f;
		float alpha = saturate(lerp(start_alpha, end_alpha, delta_coefficient_smooth));
		vVertexColor.a = saturate(0.5f - vObjectPos.y) + alpha + 0.25;
	}

	if(use_motion_blur)
	{
		Out.Pos = mul(matViewProj, vWorldPos);
	}
	else 
	{
		Out.Pos = mul(matWorldViewProj, vObjectPos);
	}

	Out.Tex0 = tc;
	
	
	if(use_bumpmap)
	{
		float3 vWorld_binormal = normalize(mul((float3x3)matWorld, vObjectB));
		float3 vWorld_tangent  = normalize(mul((float3x3)matWorld, vObjectT));
		float3x3 TBNMatrix = float3x3(vWorld_tangent, vWorld_binormal, vWorldN); 

		Out.SunLightDir = normalize(mul(TBNMatrix, -vSunDir));
		//Out.SkyLightDir = mul(TBNMatrix, -vSkyLightDir);
		Out.SkyLightDir = mul(TBNMatrix, float3(0,0,1)); //STR_TEMP!?
		Out.VertexColor = vVertexColor;
		
		
		//point lights
		#ifdef INCLUDE_VERTEX_LIGHTING
		Out.VertexLighting = calculate_point_lights_diffuse(vWorldPos, vWorldN, false, true);
		#endif
		
		#ifndef USE_LIGHTING_PASS 
		const int effective_light_index = iLightIndices[0];
		float3 point_to_light = vLightPosDir[effective_light_index]-vWorldPos.xyz;
		Out.PointLightDir.xyz = mul(TBNMatrix, normalize(point_to_light));
		
		float LD = dot(point_to_light, point_to_light);
		Out.PointLightDir.a = saturate(1.0f/LD);	//prevent bloom for 1 meters
		#endif
		
		float3 viewdir = normalize(vCameraPos.xyz - vWorldPos.xyz);
		Out.ViewDir =  mul(TBNMatrix, viewdir);
		
		#ifndef USE_LIGHTING_PASS
		if (PcfMode == PCF_NONE)
		{
			Out.ShadowTexCoord = calculate_point_lights_specular(vWorldPos, vWorldN, viewdir, true);
		}
		#endif
	}
	else {

		Out.VertexColor = vVertexColor;
		#ifdef INCLUDE_VERTEX_LIGHTING
		Out.VertexLighting = calculate_point_lights_diffuse(vWorldPos, vWorldN, false, false);
		#endif
		
		Out.ViewDir =  normalize(vCameraPos.xyz - vWorldPos.xyz);
		
		Out.SunLightDir = vWorldN;
		#ifndef USE_LIGHTING_PASS
		Out.SkyLightDir = calculate_point_lights_specular(vWorldPos, vWorldN, Out.ViewDir, false);
		#endif
	}
	Out.VertexColor.a *= vMaterialColor.a;

	

	if (PcfMode != PCF_NONE)
	{
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	}
	
	//apply fog
	float3 P = mul(matWorldView, vObjectPos); //position in view space
	float d = length(P);
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);
	
	if(bNightVision == 1)
		Out.VertexLighting += flashlight(d, Out.ViewDir, vWorldN);
	
	// Out.VertexLighting += calculate_spot_lights_diffuse(vWorldPos, vWorldN);
		
	return Out;
}


VS_OUTPUT_STANDART vs_main_standart_Instanced (uniform const int PcfMode, uniform const bool use_bumpmap, uniform const bool use_skinning, 
										float4 vPosition : POSITION, float3 vNormal : NORMAL, float2 tc : TEXCOORD0,  float3 vTangent : TANGENT, float3 vBinormal : BINORMAL, 
										float4 vVertexColor : COLOR0, float4 vBlendWeights : BLENDWEIGHT, float4 vBlendIndices : BLENDINDICES,
									   //instance data:
									   float3   vInstanceData0 : TEXCOORD1, float3   vInstanceData1 : TEXCOORD2,
									   float3   vInstanceData2 : TEXCOORD3, float3   vInstanceData3 : TEXCOORD4)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_STANDART, Out);
	
	float4 vObjectPos;
	float3 vObjectN, vObjectT, vObjectB;
	
	if(use_skinning) {
		//no skinned instancing support yet!
		GIVE_ERROR_HERE_VS;
	}
	else {
		vObjectPos = vPosition;
		
		vObjectN = vNormal;
									
		if(use_bumpmap)
		{
			vObjectT = vTangent;
			vObjectB = vBinormal;
		}
	}
	
	float4x4 matWorldOfInstance = build_instance_frame_matrix(vInstanceData0, vInstanceData1, vInstanceData2, vInstanceData3);

	float4 vWorldPos = mul(matWorldOfInstance, vObjectPos);
	float3 vWorldN = normalize(mul((float3x3)matWorldOfInstance, vObjectN));	
	
	
	const bool use_motion_blur = bUseMotionBlur && (!use_skinning);
	
	if(use_motion_blur)	//motion blur flag!?!
	{
		float4 vWorldPos1;
		float3 moveDirection;
		if(true)	//instanced meshes dont have valid matMotionBlur!
		{
			const float blur_len = 0.2f;
			moveDirection = -normalize( float3(matWorldOfInstance[0][0],matWorldOfInstance[1][0],matWorldOfInstance[2][0]) );	//using x axis !
			moveDirection.y -= blur_len * 0.285;	//low down blur for big blur_lens (show more like a spline)
			vWorldPos1 = vWorldPos + float4(moveDirection,0) * blur_len;
		}
		else
		{		
			vWorldPos1 = mul(matMotionBlur, vObjectPos);
			moveDirection = normalize(vWorldPos1 - vWorldPos);
		}
		
		   
		float delta_coefficient_sharp = (dot(vWorldN, moveDirection) > 0.1f) ? 1 : 0;

		float y_factor = saturate(vObjectPos.y+0.15);
		vWorldPos = lerp(vWorldPos, vWorldPos1, delta_coefficient_sharp * y_factor);

		float delta_coefficient_smooth = saturate(dot(vWorldN, moveDirection) + 0.5f);

		float extra_alpha = 0.1f;
		float start_alpha = (1.0f+extra_alpha);
		float end_alpha = start_alpha - 1.8f;
		float alpha = saturate(lerp(start_alpha, end_alpha, delta_coefficient_smooth));
		vVertexColor.a = saturate(0.5f - vObjectPos.y) + alpha + 0.25;
	}
	
	
	//-- Out.Pos = mul(matWorldViewProj, vObjectPos);
    Out.Pos = mul(matViewProj, vWorldPos);
	
	Out.Tex0 = tc;
	
	
	if(use_bumpmap)
	{
		float3 vWorld_binormal = normalize(mul((float3x3)matWorldOfInstance, vObjectB));
		float3 vWorld_tangent  = normalize(mul((float3x3)matWorldOfInstance, vObjectT));
		float3x3 TBNMatrix = float3x3(vWorld_tangent, vWorld_binormal, vWorldN); 

		Out.SunLightDir = normalize(mul(TBNMatrix, -vSunDir));
		//Out.SkyLightDir = mul(TBNMatrix, -vSkyLightDir);
		Out.SkyLightDir = mul(TBNMatrix, float3(0,0,1)); //STR_TEMP!?
		Out.VertexColor = vVertexColor;
		
		
		//point lights
		#ifdef INCLUDE_VERTEX_LIGHTING
		Out.VertexLighting = calculate_point_lights_diffuse(vWorldPos, vWorldN, false, true);
		#endif
		
		#ifndef USE_LIGHTING_PASS 
		const int effective_light_index = iLightIndices[0];
		float3 point_to_light = vLightPosDir[effective_light_index]-vWorldPos.xyz;
		Out.PointLightDir.xyz = mul(TBNMatrix, normalize(point_to_light));
		
		float LD = dot(point_to_light, point_to_light);
		Out.PointLightDir.a = saturate(1.0f/LD);	//prevent bloom for 1 meters
		#endif
		
		float3 viewdir = normalize(vCameraPos.xyz - vWorldPos.xyz);
		Out.ViewDir =  mul(TBNMatrix, viewdir);
		
		#ifndef USE_LIGHTING_PASS
		if (PcfMode == PCF_NONE)
		{
			Out.ShadowTexCoord = calculate_point_lights_specular(vWorldPos, vWorldN, viewdir, true);
		}
		#endif
	}
	else {

		Out.VertexColor = vVertexColor;
		#ifdef INCLUDE_VERTEX_LIGHTING
		Out.VertexLighting = calculate_point_lights_diffuse(vWorldPos, vWorldN, false, false);
		#endif
		
		Out.ViewDir =  normalize(vCameraPos.xyz - vWorldPos.xyz);
		
		Out.SunLightDir = vWorldN;
		#ifndef USE_LIGHTING_PASS
		Out.SkyLightDir = calculate_point_lights_specular(vWorldPos, vWorldN, Out.ViewDir, false);
		#endif
	}

	Out.VertexColor.a *= vMaterialColor.a;
	

	if (PcfMode != PCF_NONE)
	{
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	}
	
	//apply fog
	float3 P = mul(matView, vWorldPos); //position in view space
	float d = length(P);
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);
	
	
	if(bNightVision == 1)
		Out.VertexLighting += flashlight(d, Out.ViewDir, vWorldN);
	
	//Out.VertexLighting += calculate_spot_lights_diffuse(vWorldPos, vWorldN);
	
	return Out;
}


PS_OUTPUT ps_main_standart ( VS_OUTPUT_STANDART In, uniform const int PcfMode, 
									uniform const bool use_bumpmap, uniform const bool use_specularfactor, 
									uniform const bool use_specularmap, uniform const bool ps2x, 
									uniform const bool use_aniso, uniform const bool terrain_color_ambient = true,
									uniform const bool use_bloodmap = false/*, uniform const bool use_retror = false,*/)
{ 
	PS_OUTPUT Output;
	
	float3 normal;
	if(use_bumpmap) {
		normal = (2.0f * tex2D(NormalTextureSampler, In.Tex0) - 1.0f);
	}
	else 
	{
		normal = In.SunLightDir;
	}	
	
	float sun_amount = 1;
	if (PcfMode != PCF_NONE)
	{
		if((PcfMode == PCF_NVIDIA) || ps2x)		//we have more ins count for shadow, add some ambient factor to sun amount
			sun_amount = 0.05f + GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
		else
			sun_amount = GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
	}
		
	//define ambient term:
	const int ambientTermType = ( terrain_color_ambient && (ps2x || !use_specularfactor) ) ? 1 : 0;
	const float3 DirToSky = use_bumpmap ? In.SkyLightDir : float3(0.0f, 0.0f, 1.0f);
	float4 total_light = get_ambientTerm(ambientTermType, normal, DirToSky, sun_amount);
	
	
	float3 aniso_specular = 0;
	if(use_aniso) {
		if(!ps2x){
			GIVE_ERROR_HERE;
		}
		float3 direction = float3(0,1,0);
		aniso_specular  = calculate_hair_specular(normal, direction, ((use_bumpmap) ?  In.SunLightDir : -vSunDir), In.ViewDir, In.Tex0);
	}
		
	if( use_bumpmap) 
	{
		total_light.rgb += (saturate(dot(In.SunLightDir.xyz, normal.xyz)) + aniso_specular) * sun_amount * vSunColor;
	
		if(ps2x || !use_specularfactor) {
			total_light += saturate(dot(In.SkyLightDir.xyz, normal.xyz)) * vSkyLightColor;
		}
		#ifdef INCLUDE_VERTEX_LIGHTING
		if(ps2x || !use_specularfactor || (PcfMode == PCF_NONE))
		{
			total_light.rgb += In.VertexLighting;
		}
		#endif
		
		
		#ifndef USE_LIGHTING_PASS 
			float light_atten = In.PointLightDir.a;
			const int effective_light_index = iLightIndices[0];
			total_light += saturate(dot(In.PointLightDir.xyz, normal.xyz) * vLightDiffuse[effective_light_index]  * light_atten);
		#endif
	}
	else {
		total_light.rgb += (saturate(dot(-vSunDir, normal.xyz)) + aniso_specular) * sun_amount * vSunColor;
		
		if(ambientTermType != 1 && !ps2x) {
			total_light += saturate(dot(-vSkyLightDir.xyz, normal.xyz)) * vSkyLightColor;
		}
		#ifdef INCLUDE_VERTEX_LIGHTING
		total_light.rgb += In.VertexLighting;
		#endif
	}

	if (PcfMode != PCF_NONE)
		Output.RGBColor.rgb = total_light.rgb;
	else
		Output.RGBColor.rgb = min(total_light.rgb, 2.0f);
		
	// Output.RGBColor.rgb = total_light.rgb;	//saturate?
	Output.RGBColor.rgb *= vMaterialColor.rgb;
	
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0);
	
	if(use_bloodmap)
	{
		float4 tex2_col = tex2D(Diffuse2Sampler, In.Tex0);
		float bloodAmount = distance(In.VertexColor.rgb, float3(1,1,1));
		bloodAmount *= 0.25f;
		Output.RGBColor.rgb *= lerp(tex_col.rgb, tex2_col.rgb, bloodAmount * tex2_col.a);
		INPUT_TEX_GAMMA(Output.RGBColor.rgb);
	}
	else {
		INPUT_TEX_GAMMA(tex_col.rgb);
		Output.RGBColor.rgb *= tex_col.rgb;
		Output.RGBColor.rgb *= In.VertexColor.rgb;
	}
	
	
	
	//add specular terms 
	if(use_specularfactor) {
		float4 fSpecular = 0;
		
		float4 specColor = 0.1 * spec_coef * vSpecularColor;
		if(use_specularmap) {
		
		
			//float spec_tex_factor = dot(tex2D(SpecularTextureSampler, In.Tex0).rgb,0.33);
			//get more precision from specularmap
			
			float spec_tex_factor = tex2D(SpecularTextureSampler, In.Tex0).rgb;
			
			
			specColor *= spec_tex_factor;
		}
		else //if(use_specular_alpha)	//is that always true?
		{
			specColor *= tex_col.a;
		}
		
		float4 sun_specColor = specColor * vSunColor * sun_amount;
		
		//sun specular
		float3 vHalf = normalize( In.ViewDir + ((use_bumpmap) ?  In.SunLightDir : -vSunDir) );
		fSpecular = sun_specColor * pow( saturate(dot(vHalf, normal)), fMaterialPower);
		if(PcfMode != PCF_DEFAULT)	//we have 64 ins limit 
		{
			fSpecular *= In.VertexColor;
		}
		
		if(use_bumpmap) 
		{
			if(PcfMode == PCF_NONE)	//add point lights' specular color for indoors
			{
				fSpecular.rgb += specColor * In.ShadowTexCoord.rgb;	//ShadowTexCoord => point lights specular! (calculate_point_lights_specular)
			}
			
			//add more effects for ps2a version:
			if(ps2x || (PcfMode == PCF_NONE)) {
			
				#ifndef USE_LIGHTING_PASS 
				//effective point light specular
				float light_atten = In.PointLightDir.a;
				const int effective_light_index = iLightIndices[0];
				float4 light_specColor = specColor * vLightDiffuse[effective_light_index] * (light_atten * 0.5); 	//dec. spec term to remove "effective light change" artifacts
				vHalf = normalize( In.ViewDir + In.PointLightDir );
				fSpecular += light_specColor * pow( saturate(dot(vHalf, normal)), fMaterialPower);
				#endif
			}
		}
		else
		{
			//fSpecular.rgb += specColor * In.SkyLightDir * 0.1;	//SkyLightDir-> holds lights specular color (calculate_point_lights_specular)
			fSpecular.rgb += (specColor + In.SkyLightDir) * 0.1;	//SkyLightDir-> holds lights specular color (calculate_point_lights_specular)
		}
			
		Output.RGBColor += fSpecular;
	}
	else if(use_specularmap) {
		GIVE_ERROR_HERE; 
	}
	
	OUTPUT_GAMMA(Output.RGBColor.rgb);	
	
	
	//if we dont use alpha channel for specular-> use it for alpha
	Output.RGBColor.a = In.VertexColor.a;	//we dont control bUseMotionBlur to fit in 64 instruction
	
	if( (!use_specularfactor) || use_specularmap) {
		Output.RGBColor.a *= tex_col.a;
	}

	return Output;
}

PS_OUTPUT ps_main_standart_d2 ( VS_OUTPUT_STANDART In, uniform const int PcfMode, 
									uniform const bool use_bumpmap, uniform const bool use_specularfactor, 
									uniform const bool use_specularmap, uniform const bool ps2x, 
									uniform const bool use_aniso, uniform const bool terrain_color_ambient = true,
									uniform const bool use_bloodmap = false)
{ 
	PS_OUTPUT Output;

	float3 normal;
	if(use_bumpmap) {
		normal = (2.0f * tex2D(Diffuse2Sampler, In.Tex0) - 1.0f);
	}
	else 
	{
		normal = In.SunLightDir;
	}
	
	
	float sun_amount = 1;
	if (PcfMode != PCF_NONE)
	{
		if((PcfMode == PCF_NVIDIA) || ps2x)		//we have more ins count for shadow, add some ambient factor to sun amount
			sun_amount = 0.05f + GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
		else
			sun_amount = GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
	}
		
	//define ambient term:
	const int ambientTermType = ( terrain_color_ambient && (ps2x || !use_specularfactor) ) ? 1 : 0;
	const float3 DirToSky = use_bumpmap ? In.SkyLightDir : float3(0.0f, 0.0f, 1.0f);
	float4 total_light = get_ambientTerm(ambientTermType, normal, DirToSky, sun_amount);
	
	
	float3 aniso_specular = 0;
	if(use_aniso) {
		if(!ps2x){
			GIVE_ERROR_HERE;
		}
		float3 direction = float3(0,1,0);
		aniso_specular  = calculate_hair_specular(normal, direction, ((use_bumpmap) ?  In.SunLightDir : -vSunDir), In.ViewDir, In.Tex0);
	}
		
	if( use_bumpmap) 
	{
		total_light.rgb += (saturate(dot(In.SunLightDir.xyz, normal.xyz)) + aniso_specular) * sun_amount * vSunColor;
	
		if(ps2x || !use_specularfactor) {
			total_light += saturate(dot(In.SkyLightDir.xyz, normal.xyz)) * vSkyLightColor;
		}
		#ifdef INCLUDE_VERTEX_LIGHTING
		if(ps2x || !use_specularfactor || (PcfMode == PCF_NONE))
		{
			total_light.rgb += In.VertexLighting;
		}
		#endif
		
		#ifndef USE_LIGHTING_PASS 
			float light_atten = In.PointLightDir.a;
			const int effective_light_index = iLightIndices[0];
			total_light += saturate(dot(In.PointLightDir.xyz, normal.xyz) * vLightDiffuse[effective_light_index]  * light_atten);
		#endif
	}
	else {
		total_light.rgb += (saturate(dot(-vSunDir, normal.xyz)) + aniso_specular) * sun_amount * vSunColor;
		
		if(ambientTermType != 1 && !ps2x) {
			total_light += saturate(dot(-vSkyLightDir.xyz, normal.xyz)) * vSkyLightColor;
		}
		#ifdef INCLUDE_VERTEX_LIGHTING
		total_light.rgb += In.VertexLighting;
		#endif
	}

	if (PcfMode != PCF_NONE)
		Output.RGBColor.rgb = total_light.rgb;
	else
		Output.RGBColor.rgb = min(total_light.rgb, 2.0f);
		
	// Output.RGBColor.rgb = total_light.rgb;	//saturate?
	Output.RGBColor.rgb *= vMaterialColor.rgb;
	
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0);
	
	if(use_bloodmap)
	{
		float4 tex2_col = tex2D(Diffuse2Sampler, In.Tex0);
		float bloodAmount = distance(In.VertexColor.rgb, float3(1,1,1));
		bloodAmount *= 0.25f;
		Output.RGBColor.rgb *= lerp(tex_col.rgb, tex2_col.rgb, bloodAmount * tex2_col.a);
		INPUT_TEX_GAMMA(Output.RGBColor.rgb);
	}
	else {
		INPUT_TEX_GAMMA(tex_col.rgb);
		Output.RGBColor.rgb *= tex_col.rgb;
		Output.RGBColor.rgb *= In.VertexColor.rgb;
	}
	
	
	
	//add specular terms 
	if(use_specularfactor) {
		float4 fSpecular = 0;
		
		float4 specColor = 0.1 * spec_coef * vSpecularColor;
		if(use_specularmap) {
		
		
			//float spec_tex_factor = dot(tex2D(SpecularTextureSampler, In.Tex0).rgb,0.33);
			//get more precision from specularmap
			
			float spec_tex_factor = tex2D(SpecularTextureSampler, In.Tex0).rgb;
			
			
			specColor *= spec_tex_factor;
		}
		else //if(use_specular_alpha)	//is that always true?
		{
			specColor *= tex_col.a;
		}
		
		float4 sun_specColor = specColor * vSunColor * sun_amount;
		
		//sun specular
		float3 vHalf = normalize( In.ViewDir + ((use_bumpmap) ?  In.SunLightDir : -vSunDir) );
		fSpecular = sun_specColor * pow( saturate(dot(vHalf, normal)), fMaterialPower);
		if(PcfMode != PCF_DEFAULT)	//we have 64 ins limit 
		{
			fSpecular *= In.VertexColor;
		}
		
		if(use_bumpmap) 
		{
			if(PcfMode == PCF_NONE)	//add point lights' specular color for indoors
			{
				fSpecular.rgb += specColor * In.ShadowTexCoord.rgb;	//ShadowTexCoord => point lights specular! (calculate_point_lights_specular)
			}
			
			//add more effects for ps2a version:
			if(ps2x || (PcfMode == PCF_NONE)) {
			
				#ifndef USE_LIGHTING_PASS 
				//effective point light specular
				float light_atten = In.PointLightDir.a;
				const int effective_light_index = iLightIndices[0];
				float4 light_specColor = specColor * vLightDiffuse[effective_light_index] * (light_atten * 0.5); 	//dec. spec term to remove "effective light change" artifacts
				vHalf = normalize( In.ViewDir + In.PointLightDir );
				fSpecular += light_specColor * pow( saturate(dot(vHalf, normal)), fMaterialPower);
				#endif
			}
		}
		else
		{
			//fSpecular.rgb += specColor * In.SkyLightDir * 0.1;	//SkyLightDir-> holds lights specular color (calculate_point_lights_specular)
			fSpecular.rgb += (specColor + In.SkyLightDir) * 0.1;	//SkyLightDir-> holds lights specular color (calculate_point_lights_specular)
		}
			
		Output.RGBColor += fSpecular;
	}
	else if(use_specularmap) {
		GIVE_ERROR_HERE; 
	}
	
	OUTPUT_GAMMA(Output.RGBColor.rgb);	
	
	
	//if we dont use alpha channel for specular-> use it for alpha
	Output.RGBColor.a = In.VertexColor.a;	//we dont control bUseMotionBlur to fit in 64 instruction
	
	if( (!use_specularfactor) || use_specularmap) {
		Output.RGBColor.a *= tex_col.a;
	}

	return Output;
}

PS_OUTPUT ps_main_standart_old_good( VS_OUTPUT_STANDART In, uniform const int PcfMode, uniform const bool use_specularmap, uniform const bool use_aniso )
{
	PS_OUTPUT Output;
	
	
	float sun_amount = 1;
	if (PcfMode != PCF_NONE)
	{
		sun_amount = 0.03f + GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
	}

	float3 normal = (2.0f * tex2D(NormalTextureSampler, In.Tex0) - 1.0f);
	
	//define ambient term:
	static const int ambientTermType = 1;
	float3 DirToSky = In.SkyLightDir;
	float4 total_light = get_ambientTerm(ambientTermType, normal, DirToSky, sun_amount);
	
	float4 specColor = vSunColor * (vSpecularColor*0.1);
	if(use_specularmap) {
		//float spec_tex_factor = dot(tex2D(SpecularTextureSampler, In.Tex0).rgb,0.33);
		//get more precision from specularmap
			
		float spec_tex_factor = tex2D(SpecularTextureSampler, In.Tex0).rgb;
		specColor *= spec_tex_factor;
	}
	
	float3 vHalf = normalize(In.ViewDir + In.SunLightDir);
	float4 fSpecular = specColor * pow( saturate(dot(vHalf, normal)), fMaterialPower); // saturate(dot(In.SunLightDir, normal));
	
	
	if(use_aniso) {
		float3 tangent_ = float3(0,1,0);
		fSpecular.rgb += calculate_hair_specular(normal, tangent_, In.SunLightDir, In.ViewDir, In.Tex0);
	}
	else {
		fSpecular.rgb *= spec_coef;
	}
	
		
	total_light += (saturate(dot(In.SunLightDir.xyz, normal.xyz)) + fSpecular) * sun_amount * vSunColor;
	total_light += saturate(dot(In.SkyLightDir.xyz, normal.xyz)) * vSkyLightColor;
	
	
	#ifndef USE_LIGHTING_PASS 
	float light_atten = In.PointLightDir.a;
	const int effective_light_index = iLightIndices[0];
	total_light += saturate(dot(In.PointLightDir.xyz, normal.xyz)) * vLightDiffuse[effective_light_index]  * light_atten;
	#endif
	
	#ifdef INCLUDE_VERTEX_LIGHTING
		total_light.rgb += In.VertexLighting;
	#endif
	

	Output.RGBColor.rgb = total_light.rgb; //saturate(total_light.rgb);	//false!
	Output.RGBColor.a = 1.0f;
	Output.RGBColor *= vMaterialColor;
	
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0);
	INPUT_TEX_GAMMA(tex_col.rgb);

	Output.RGBColor *= tex_col;
	Output.RGBColor *= In.VertexColor;
	
	OUTPUT_GAMMA(Output.RGBColor.rgb);	
	Output.RGBColor.a = In.VertexColor.a * tex_col.a;

	return Output;
}

#ifdef USE_PRECOMPILED_SHADER_LISTS
																		//use_bumpmap, use_skinning, 
VertexShader standart_vs_noshadow[] = { compile vs_2_0 vs_main_standart(PCF_NONE, 0,0), 
										compile vs_2_0 vs_main_standart(PCF_NONE, 0,1), 
										compile vs_2_0 vs_main_standart(PCF_NONE, 1,0), 
										compile vs_2_0 vs_main_standart(PCF_NONE, 1,1)};
										
VertexShader standart_vs_default[] = { 	compile vs_2_0 vs_main_standart(PCF_DEFAULT, 0,0), 
										compile vs_2_0 vs_main_standart(PCF_DEFAULT, 0,1), 
										compile vs_2_0 vs_main_standart(PCF_DEFAULT, 1,0), 
										compile vs_2_0 vs_main_standart(PCF_DEFAULT, 1,1)};
										                            
VertexShader standart_vs_nvidia[] = { 	compile vs_2_0 vs_main_standart(PCF_NVIDIA, 0,0), 	//ps_main_standart compiled versions?!
										compile vs_2_0 vs_main_standart(PCF_NVIDIA, 0,1), 
										compile vs_2_0 vs_main_standart(PCF_NVIDIA, 1,0), 
										compile vs_2_0 vs_main_standart(PCF_NVIDIA, 1,1)};
										
#define DEFINE_STANDART_TECHNIQUE(tech_name, use_bumpmap, use_skinning, use_specularfactor, use_specularmap, use_aniso, terraincolor, use_bloodmap)	\
				technique tech_name	\
				{ pass P0 { VertexShader = standart_vs_noshadow[(2*use_bumpmap) + use_skinning]; \
							PixelShader = compile ps_2_a ps_main_standart(PCF_NONE, use_bumpmap, use_specularfactor, use_specularmap, false, use_aniso, terraincolor, use_bloodmap);} } \
				technique tech_name##_SHDW	\
				{ pass P0 { VertexShader = standart_vs_default[(2*use_bumpmap) + use_skinning]; \
							PixelShader = compile ps_2_a ps_main_standart(PCF_DEFAULT, use_bumpmap, use_specularfactor, use_specularmap, false, use_aniso, terraincolor, use_bloodmap);} } \
				technique tech_name##_SHDWNVIDIA	\
				{ pass P0 { VertexShader = standart_vs_nvidia[(2*use_bumpmap) + use_skinning]; \
							PixelShader = compile ps_2_a ps_main_standart(PCF_NVIDIA, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso, terraincolor, use_bloodmap);} }  \
				DEFINE_LIGHTING_TECHNIQUE(tech_name, 0, use_bumpmap, use_skinning, use_specularfactor, use_specularmap)

							
#define DEFINE_STANDART_TECHNIQUE_HIGH(tech_name, use_bumpmap, use_skinning, use_specularfactor, use_specularmap, use_aniso, terraincolor, use_bloodmap)	\
				technique tech_name	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart(PCF_NONE, use_bumpmap, use_skinning); \
							PixelShader = compile PS_2_X ps_main_standart(PCF_NONE, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso, terraincolor, use_bloodmap);} } \
				technique tech_name##_SHDW	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart(PCF_DEFAULT, use_bumpmap, use_skinning); \
							PixelShader = compile PS_2_X ps_main_standart(PCF_DEFAULT, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso, terraincolor, use_bloodmap);} } \
				technique tech_name##_SHDWNVIDIA	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart(PCF_NVIDIA, use_bumpmap, use_skinning); \
							PixelShader = compile ps_2_a ps_main_standart(PCF_NVIDIA, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso, terraincolor, use_bloodmap);} } \
				DEFINE_LIGHTING_TECHNIQUE(tech_name, 0, use_bumpmap, use_skinning, use_specularfactor, use_specularmap)
				
#define DEFINE_STANDART_TECHNIQUE_INSTANCED(tech_name, use_bumpmap, use_skinning, use_specularfactor, use_specularmap, use_aniso, terraincolor)	\
				technique tech_name	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart_Instanced(PCF_NONE, use_bumpmap, false); \
							PixelShader = compile PS_2_X ps_main_standart(PCF_NONE, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso, terraincolor);} } \
				technique tech_name##_SHDW	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart_Instanced(PCF_DEFAULT, use_bumpmap, false); \
							PixelShader = compile PS_2_X ps_main_standart(PCF_DEFAULT, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso, terraincolor);} } \
				technique tech_name##_SHDWNVIDIA	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart_Instanced(PCF_NVIDIA, use_bumpmap, false); \
							PixelShader = compile ps_2_a ps_main_standart(PCF_NVIDIA, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso, terraincolor);} } //lighting?
							
							
#define DEFINE_STANDART_TECHNIQUE_HIGH_INSTANCED(tech_name, use_bumpmap, use_skinning, use_specularfactor, use_specularmap, use_aniso)	\
				technique tech_name	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart_Instanced(PCF_NONE, use_bumpmap, use_skinning); \
							PixelShader = compile PS_2_X ps_main_standart(PCF_NONE, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso);} } \
				technique tech_name##_SHDW	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart_Instanced(PCF_DEFAULT, use_bumpmap, use_skinning); \
							PixelShader = compile PS_2_X ps_main_standart(PCF_DEFAULT, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso);} } \
				technique tech_name##_SHDWNVIDIA	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart_Instanced(PCF_NVIDIA, use_bumpmap, use_skinning); \
							PixelShader = compile ps_2_a ps_main_standart(PCF_NVIDIA, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso);} } 
							
#else 

#define DEFINE_STANDART_TECHNIQUE(tech_name, use_bumpmap, use_skinning, use_specularfactor, use_specularmap, use_aniso, use_bloodmap)	\
				technique tech_name	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart(PCF_NONE, use_bumpmap, use_skinning); \
							PixelShader = compile ps_2_a ps_main_standart(PCF_NONE, use_bumpmap, use_specularfactor, use_specularmap, false, use_aniso, use_bloodmap);} } \
				technique tech_name##_SHDW	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart(PCF_DEFAULT, use_bumpmap, use_skinning); \
							PixelShader = compile ps_2_a ps_main_standart(PCF_DEFAULT, use_bumpmap, use_specularfactor, use_specularmap, false, use_aniso, use_bloodmap);} } \
				technique tech_name##_SHDWNVIDIA	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart(PCF_NVIDIA, use_bumpmap, use_skinning); \
							PixelShader = compile ps_2_a ps_main_standart(PCF_NVIDIA, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso, use_bloodmap);} }  \
				DEFINE_LIGHTING_TECHNIQUE(tech_name, 0, use_bumpmap, use_skinning, use_specularfactor, use_specularmap)

							

#define DEFINE_STANDART_TECHNIQUE_HIGH(tech_name, use_bumpmap, use_skinning, use_specularfactor, use_specularmap, use_aniso, use_bloodmap)	\
				technique tech_name	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart(PCF_NONE, use_bumpmap, use_skinning); \
							PixelShader = compile PS_2_X ps_main_standart(PCF_NONE, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso, use_bloodmap);} } \
				technique tech_name##_SHDW	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart(PCF_DEFAULT, use_bumpmap, use_skinning); \
							PixelShader = compile PS_2_X ps_main_standart(PCF_DEFAULT, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso, use_bloodmap);} } \
				technique tech_name##_SHDWNVIDIA	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart(PCF_NVIDIA, use_bumpmap, use_skinning); \
							PixelShader = compile ps_2_a ps_main_standart(PCF_NVIDIA, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso, use_bloodmap);} } \
				DEFINE_LIGHTING_TECHNIQUE(tech_name, 0, use_bumpmap, use_skinning, use_specularfactor, use_specularmap)
				
#define DEFINE_STANDART_TECHNIQUE_INSTANCED(tech_name, use_bumpmap, use_skinning, use_specularfactor, use_specularmap, use_aniso)	\
				technique tech_name	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart_Instanced(PCF_NONE, use_bumpmap, false); \
							PixelShader = compile PS_2_X ps_main_standart(PCF_NONE, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso);} } \
				technique tech_name##_SHDW	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart_Instanced(PCF_DEFAULT, use_bumpmap, false); \
							PixelShader = compile PS_2_X ps_main_standart(PCF_DEFAULT, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso);} } \
				technique tech_name##_SHDWNVIDIA	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart_Instanced(PCF_NVIDIA, use_bumpmap, false); \
							PixelShader = compile ps_2_a ps_main_standart(PCF_NVIDIA, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso);} } // lighting?
							
							
#define DEFINE_STANDART_TECHNIQUE_HIGH_INSTANCED(tech_name, use_bumpmap, use_skinning, use_specularfactor, use_specularmap, use_aniso)	\
				technique tech_name	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart_Instanced(PCF_NONE, use_bumpmap, use_skinning); \
							PixelShader = compile PS_2_X ps_main_standart(PCF_NONE, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso);} } \
				technique tech_name##_SHDW	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart_Instanced(PCF_DEFAULT, use_bumpmap, use_skinning); \
							PixelShader = compile PS_2_X ps_main_standart(PCF_DEFAULT, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso);} } \
				technique tech_name##_SHDWNVIDIA	\
				{ pass P0 { VertexShader = compile vs_2_0 vs_main_standart_Instanced(PCF_NVIDIA, use_bumpmap, use_skinning); \
							PixelShader = compile ps_2_a ps_main_standart(PCF_NVIDIA, use_bumpmap, use_specularfactor, use_specularmap, true, use_aniso);} } 

#endif //USE_PRECOMPILED_SHADER_LISTS

DEFINE_STANDART_TECHNIQUE( standart_noskin_bump_nospecmap, 				true, false, true, false, false, true, false)
DEFINE_STANDART_TECHNIQUE( standart_noskin_bump_specmap, 				true, false, true, true,  false, true, false)
DEFINE_STANDART_TECHNIQUE( standart_skin_bump_nospecmap, 				true, true,  true, false, false, true, false)
DEFINE_STANDART_TECHNIQUE( standart_skin_bump_specmap, 					true, true,  true, true,  false, true, false)
                        
//high versions: 
DEFINE_STANDART_TECHNIQUE_HIGH( standart_skin_bump_nospecmap_high, 		true, true,  true, false, false, true, false)
DEFINE_STANDART_TECHNIQUE_HIGH( standart_skin_bump_specmap_high, 		true, true,  true, true , false, true, false)
DEFINE_STANDART_TECHNIQUE_HIGH( standart_skin_bump_specmap_high_blood, 	true, true,  true, true , false, true, true)
DEFINE_STANDART_TECHNIQUE_HIGH( standart_noskin_bump_nospecmap_high, 	true, false,  true, false, false, true, false)
DEFINE_STANDART_TECHNIQUE_HIGH( standart_noskin_bump_specmap_high, 		true, false,  true, true , false, true, false)
                                                                                      
//-----------------------------------------------
//nobump versions:
DEFINE_STANDART_TECHNIQUE( standart_noskin_nobump_nospecmap, 			false, false, true, false, false, true, false)
DEFINE_STANDART_TECHNIQUE( standart_noskin_nobump_specmap, 				false, false, true, true , false, true, false)
DEFINE_STANDART_TECHNIQUE( standart_skin_nobump_nospecmap, 				false,  true, true, false, false, true, false)
DEFINE_STANDART_TECHNIQUE( standart_skin_nobump_specmap, 				false,  true, true, true , false, true, false)
                                                                                        
//-----------------------------------------------
//nospec versions:
//
DEFINE_STANDART_TECHNIQUE( standart_noskin_nobump_nospec, 				false, false, false, false, false, true, false)
DEFINE_STANDART_TECHNIQUE( standart_noskin_bump_nospec, 				true,  false, false, false, false, true, false)
DEFINE_STANDART_TECHNIQUE( standart_noskin_bump_nospec_noterraincolor, 	true,  false, false, false, false, false, false)
DEFINE_STANDART_TECHNIQUE( standart_skin_nobump_nospec, 				false,  true, false, false, false, true, false)
DEFINE_STANDART_TECHNIQUE( standart_skin_bump_nospec, 					true,   true, false, false, false, true, false)
                                                                                         
//nospec_high
DEFINE_STANDART_TECHNIQUE_HIGH( standart_noskin_bump_nospec_high, 				true, false, false, false, false, true, false)
DEFINE_STANDART_TECHNIQUE_HIGH( standart_noskin_bump_nospec_high_noterraincolor,true, false, false, false, false, false, false)
DEFINE_STANDART_TECHNIQUE_HIGH( standart_skin_bump_nospec_high, 				true,  true, false, false, false, true, false)


///--------
DEFINE_STANDART_TECHNIQUE_INSTANCED( standart_noskin_bump_nospecmap_Instanced, 					true, false, true, false, false, true)
DEFINE_STANDART_TECHNIQUE_INSTANCED( standart_noskin_nobump_specmap_Instanced, 					false, false, true, true , false, true)
DEFINE_STANDART_TECHNIQUE_INSTANCED( standart_noskin_bump_specmap_Instanced, 					true, false, true, true,  false, true)
DEFINE_STANDART_TECHNIQUE_INSTANCED( standart_noskin_nobump_nospecmap_Instanced, 				false, false, true, false, false, true)
DEFINE_STANDART_TECHNIQUE_INSTANCED( standart_noskin_bump_nospec_high_Instanced, 				true, false, false, false, false, true)
DEFINE_STANDART_TECHNIQUE_INSTANCED( standart_noskin_bump_nospec_high_noterraincolor_Instanced, true, false, false, false, false, false)

DEFINE_STANDART_TECHNIQUE_HIGH_INSTANCED( standart_noskin_bump_specmap_high_Instanced, 		true, false,  true, true , false)
DEFINE_STANDART_TECHNIQUE_HIGH_INSTANCED( standart_noskin_bump_nospecmap_high_Instanced, 	true, false,  true, false, false)

technique standart_bumps_d2
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_standart(PCF_NONE, true, true);
		//PixelShader = compile PS_2_X ps_main_standart(PCF_NONE, true, true, false, true, true);
		PixelShader = compile PS_2_X ps_main_standart_d2(PCF_NONE, true, true,  true, false, false, true, false);
	}
}

//aniso versions:       
// technique nospecular_skin_bumpmap_high_aniso
technique standart_skin_bump_nospecmap_high_aniso
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_standart(PCF_NONE, true, true);
		//PixelShader = compile PS_2_X ps_main_standart(PCF_NONE, true, true, false, true, true);
		PixelShader = compile PS_2_X ps_main_standart_old_good(PCF_NONE, false, true);
	}
}
technique standart_skin_bump_nospecmap_high_aniso_SHDW
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_standart(PCF_DEFAULT, true, true);
		//PixelShader = compile PS_2_X ps_main_standart(PCF_DEFAULT, true, true, false, true, true);
		PixelShader = compile PS_2_X ps_main_standart_old_good(PCF_DEFAULT, false, true);
	}
}
technique standart_skin_bump_nospecmap_high_aniso_SHDWNVIDIA
{
	pass P0
	{
		VertexShader = compile vs_2_a vs_main_standart(PCF_NVIDIA, true, true);
		//PixelShader = compile ps_2_a ps_main_standart(PCF_NVIDIA, true, true, false, true, true);
		PixelShader = compile ps_2_a ps_main_standart_old_good(PCF_NVIDIA, false, true);
	}
}

// technique specular_skin_bumpmap_high_aniso
technique standart_skin_bump_specmap_high_aniso
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_standart(PCF_NONE, true, true);
		//PixelShader = compile PS_2_X ps_main_standart(PCF_NONE, true, true, true, true, true);
		PixelShader = compile PS_2_X ps_main_standart_old_good(PCF_NONE, true, true);
	}
}
technique standart_skin_bump_specmap_high_aniso_SHDW
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_standart(PCF_DEFAULT, true, true);
		//PixelShader = compile PS_2_X ps_main_standart(PCF_DEFAULT, true, true, true, true, true);
		PixelShader = compile PS_2_X ps_main_standart_old_good(PCF_DEFAULT, true, true);
	}
}
technique standart_skin_bump_specmap_high_aniso_SHDWNVIDIA
{
	pass P0
	{
		VertexShader = compile vs_2_a vs_main_standart(PCF_NVIDIA, true, true);
		//PixelShader = compile ps_2_a ps_main_standart(PCF_NVIDIA, true, true, true, true);
		PixelShader = compile ps_2_a ps_main_standart_old_good(PCF_NVIDIA, true, true);
	}
}


// !  technique specular_diffuse -> standart_noskin_nobump_specmap
// !  technique specular_diffuse_skin -> standart_skin_nobump_specmap
// !  technique specular_alpha -> standart_noskin_nobump_nospecmap
// !  technique specular_alpha_skin -> standart_skin_nobump_nospecmap
////////////////////////////
#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef HAIR_SHADERS

struct VS_OUTPUT_SIMPLE_HAIR
{
	float4 Pos					: POSITION;
	float4 Color				: COLOR0;
	float2 Tex0					: TEXCOORD0;
	float4 SunLight				: TEXCOORD1;
	float4 ShadowTexCoord		: TEXCOORD2;
	float2 ShadowTexelPos		: TEXCOORD3;
	float  Fog				    : FOG;
};

VS_OUTPUT_SIMPLE_HAIR vs_hair (uniform const int PcfMode, float4 vPosition : POSITION, float3 vNormal : NORMAL, float2 tc : TEXCOORD0, float4 vColor : COLOR0)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_SIMPLE_HAIR, Out);
	
	Out.Pos = mul(matWorldViewProj, vPosition);

	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal)); //normal in world space

	float3 P = mul(matWorldView, vPosition); //position in view space

	Out.Tex0 = tc;

	float4 diffuse_light = vAmbientColor;
	//   diffuse_light.rgb *= gradient_factor * (gradient_offset + vWorldN.z);

	//directional lights, compute diffuse color
	diffuse_light += saturate(dot(vWorldN, -vSkyLightDir)) * vSkyLightColor;

	//point lights
	#ifndef USE_LIGHTING_PASS
	diffuse_light += calculate_point_lights_diffuse(vWorldPos, vWorldN, true, false);
	#endif
	
	//apply material color
	//	Out.Color = min(1, vMaterialColor * vColor * diffuse_light);
	Out.Color = vColor * diffuse_light;

	//shadow mapping variables
	float wNdotSun = dot(vWorldN, -vSunDir);
	Out.SunLight =  max(0.2f * (wNdotSun + 0.9f),wNdotSun) * vSunColor * vColor;
	if (PcfMode != PCF_NONE)
	{
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	}
	
	//apply fog
	float d = length(P);

	Out.Fog = get_fog_amount_new(d, vWorldPos.z);
	return Out;
}
PS_OUTPUT ps_hair(VS_OUTPUT_SIMPLE_HAIR In, uniform const int PcfMode)
{
	PS_OUTPUT Output;
	
	float4 tex1_col = tex2D(MeshTextureSampler, In.Tex0);
	float4 tex2_col = tex2D(Diffuse2Sampler, In.Tex0);
	
	float4 final_col;
	
	INPUT_TEX_GAMMA(tex1_col.rgb);
	
	final_col = tex1_col * vMaterialColor;
	
	float alpha = saturate(((2.0f * vMaterialColor2.a ) + tex2_col.a) - 1.9f);
	final_col.rgb *= (1.0f - alpha);
	final_col.rgb += tex2_col.rgb * alpha;
	
	//    tex_col = tex2_col * vMaterialColor2.a + tex1_col * (1.0f - vMaterialColor2.a);
	
	
	float4 total_light = In.Color;
	if ((PcfMode != PCF_NONE))
	{
		float sun_amount = GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
		total_light.rgb += In.SunLight.rgb * sun_amount;
	}
	else
	{
		total_light.rgb += In.SunLight.rgb;
	}
	Output.RGBColor =  final_col * total_light;
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	return Output;
}

DEFINE_TECHNIQUES(hair_shader, vs_hair, ps_hair)


struct VS_INPUT_HAIR
{
	float4 vPosition : POSITION;
	float3 vNormal : NORMAL;
	float3 vTangent : BINORMAL;
	
	float2 tc : TEXCOORD0;
	float4 vColor : COLOR0;
};
struct VS_OUTPUT_HAIR
{
	float4 Pos					: POSITION;
	float2 Tex0					: TEXCOORD0;
	
	float4 VertexLighting		: TEXCOORD1;
	
	float3 viewVec				: TEXCOORD2;
	float3 normal				: TEXCOORD3;
	float3 tangent				: TEXCOORD4;
	float4 VertexColor			: COLOR0;
	
	
	float4 ShadowTexCoord		: TEXCOORD6;
	float2 ShadowTexelPos		: TEXCOORD7;
	float  Fog				    : FOG;
};

VS_OUTPUT_HAIR vs_hair_aniso (uniform const int PcfMode, VS_INPUT_HAIR In)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_HAIR, Out);

	Out.Pos = mul(matWorldViewProj, In.vPosition);

	float4 vWorldPos = (float4)mul(matWorld,In.vPosition);
	float3 vWorldN = normalize(mul((float3x3)matWorld, In.vNormal)); //normal in world space

	float3 P = mul(matWorldView, In.vPosition); //position in view space

	Out.Tex0 = In.tc;

	float4 diffuse_light = vAmbientColor;
	//   diffuse_light.rgb *= gradient_factor * (gradient_offset + vWorldN.z);

	//directional lights, compute diffuse color
	diffuse_light += saturate(dot(vWorldN, -vSkyLightDir)) * vSkyLightColor;

	//point lights
	#ifndef USE_LIGHTING_PASS
	diffuse_light += calculate_point_lights_diffuse(vWorldPos, vWorldN, true, false);
	#endif
	
	//apply material color
	Out.VertexLighting = saturate(In.vColor * diffuse_light);
	
	Out.VertexColor = In.vColor;
	
	if(true) {
		float3 Pview = vCameraPos - vWorldPos;
		Out.normal = normalize( mul( matWorld, In.vNormal ) );
		Out.tangent = normalize( mul( matWorld, In.vTangent ) );
		Out.viewVec = normalize( Pview );
	}
	
	if (PcfMode != PCF_NONE)
	{
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	}
	
	//apply fog
	float d = length(P);
	
	if(bNightVision == 1)
		Out.VertexLighting.rgb += flashlight(d, Out.viewVec, vWorldN);

	Out.Fog = get_fog_amount_new(d, vWorldPos.z);
	return Out;
}
PS_OUTPUT ps_hair_aniso(VS_OUTPUT_HAIR In, uniform const int PcfMode)
{
	PS_OUTPUT Output;

	//vMaterialColor2.a -> age slider 0..1
	//vMaterialColor -> hair color
	
	float3 lightDir = -vSunDir;
	float3 hairBaseColor = vMaterialColor.rgb;


	// diffuse term
	float3 diffuse = hairBaseColor * vSunColor.rgb * In.VertexColor.rgb * HairDiffuseTerm(In.normal, lightDir);
			

	float4 tex1_col = tex2D(MeshTextureSampler, In.Tex0);
	INPUT_TEX_GAMMA(tex1_col.rgb);
	float4 tex2_col = tex2D(Diffuse2Sampler, In.Tex0);
	float alpha = saturate(((2.0f * vMaterialColor2.a ) + tex2_col.a) - 1.9f);
	
	float4 final_col = tex1_col;
	final_col.rgb *= hairBaseColor;
	final_col.rgb *= (1.0f - alpha);
	final_col.rgb += tex2_col.rgb * alpha;
		
	float sun_amount = 1;
	if ((PcfMode != PCF_NONE))
	{
		 sun_amount = GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
	}
	
	float3 specular = calculate_hair_specular(In.normal, In.tangent, lightDir, In.viewVec, In.Tex0);
	
	float4 total_light = vAmbientColor;
	total_light.rgb += (((diffuse + specular) * sun_amount));
	
	//float4 total_light = vAmbientColor;
	//total_light.rgb += diffuse+ * sun_amount;
	total_light.rgb += In.VertexLighting.rgb;
	
	Output.RGBColor.rgb = total_light * final_col.rgb;
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	
	Output.RGBColor.a = tex1_col.a * vMaterialColor.a;
	
	Output.RGBColor = saturate(Output.RGBColor);	//do not bloom!	
	
	return Output;
}

technique hair_shader_aniso
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_hair_aniso(PCF_NONE);
		PixelShader = compile PS_2_X ps_hair_aniso(PCF_NONE);
	}
}
technique hair_shader_aniso_SHDW
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_hair_aniso(PCF_DEFAULT);
		PixelShader = compile PS_2_X ps_hair_aniso(PCF_DEFAULT);
	}
}
technique hair_shader_aniso_SHDWNVIDIA
{
	pass P0
	{
		VertexShader = compile vs_2_a vs_hair_aniso(PCF_NVIDIA);
		PixelShader = compile ps_2_a ps_hair_aniso(PCF_NVIDIA);
	}
}

#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef FACE_SHADERS

struct VS_OUTPUT_SIMPLE_FACE
{
	float4 Pos					: POSITION;
	float4 Color				: COLOR0;
	float2 Tex0					: TEXCOORD0;
	float4 SunLight				: TEXCOORD1;
	float4 ShadowTexCoord		: TEXCOORD2;
	float2 ShadowTexelPos		: TEXCOORD3;
	float  Fog				    : FOG;
};
VS_OUTPUT_SIMPLE_FACE vs_face (uniform const int PcfMode, float4 vPosition : POSITION, float3 vNormal : NORMAL, float2 tc : TEXCOORD0, float4 vColor : COLOR0)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_SIMPLE_FACE, Out);

	Out.Pos = mul(matWorldViewProj, vPosition);

	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal)); //normal in world space

	float3 P = mul(matWorldView, vPosition); //position in view space
	
		//apply fog
	float d = length(P);

	Out.Fog = get_fog_amount_new(d, vWorldPos.z);

	Out.Tex0 = tc;

	float4 diffuse_light = vAmbientColor;
	//   diffuse_light.rgb *= gradient_factor * (gradient_offset + vWorldN.z);

	//directional lights, compute diffuse color
	diffuse_light += saturate(dot(vWorldN, -vSkyLightDir)) * vSkyLightColor;

	//point lights
	#ifndef USE_LIGHTING_PASS
	diffuse_light += calculate_point_lights_diffuse(vWorldPos, vWorldN, true, false);
	#endif
	
	float3 viewdir = normalize(vCameraPos.xyz - vWorldPos.xyz);
	
	if(bNightVision == 1)
		diffuse_light.rgb += flashlight(d, viewdir, vWorldN);
	
	//apply material color
	//	Out.Color = min(1, vMaterialColor * vColor * diffuse_light);
	Out.Color = vMaterialColor * vColor * diffuse_light;

	//shadow mapping variables
	float wNdotSun = dot(vWorldN, -vSunDir);
	Out.SunLight =  max(0.2f * (wNdotSun + 0.9f),wNdotSun) * vSunColor * vMaterialColor * vColor;
	if (PcfMode != PCF_NONE)
	{
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	}
	
	return Out;
}
PS_OUTPUT ps_face(VS_OUTPUT_SIMPLE_FACE In, uniform const int PcfMode)
{
	PS_OUTPUT Output;
	
	float4 tex1_col = tex2D(MeshTextureSampler, In.Tex0);
	float4 tex2_col = tex2D(Diffuse2Sampler, In.Tex0);
	
	float4 tex_col;
	
	tex_col = tex2_col * In.Color.a + tex1_col * (1.0f - In.Color.a);
	
	INPUT_TEX_GAMMA(tex_col.rgb);
	
	if ((PcfMode != PCF_NONE))
	{
		float sun_amount = GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
		//		sun_amount *= sun_amount;
		Output.RGBColor =  tex_col * ((In.Color + In.SunLight * sun_amount));
	}
	else
	{
		Output.RGBColor = tex_col * (In.Color + In.SunLight);
	}
	// gamma correct
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	Output.RGBColor.a = vMaterialColor.a;
	
	return Output;
}

DEFINE_TECHNIQUES(face_shader, vs_face, ps_face)

DEFINE_LIGHTING_TECHNIQUE(face_shader, 0, 0, 0, 0, 0)

////////////////////////////////////////
struct VS_INPUT_FACE
{
	float4 Position 	: POSITION;
	float2 TC 			: TEXCOORD0; 
	
	float4 VertexColor	: COLOR0; 
	
	float3 Normal 		: NORMAL;
	float3 Tangent 		: TANGENT;
	float3 Binormal 	: BINORMAL;
};
struct VS_OUTPUT_FACE
{
	float4 Pos					: POSITION;
	float  Fog				    : FOG;

	float4 VertexColor			: COLOR0;
	float2 Tex0					: TEXCOORD0;

	float3 WorldPos             : TEXCOORD1;
	float3 ViewVec              : TEXCOORD2;
	
	float3 SunLightDir			: TEXCOORD3;
	float4 PointLightDir		: TEXCOORD4;
	
	float4 ShadowTexCoord		: TEXCOORD5;
	float2 ShadowTexelPos		: TEXCOORD6;
#ifdef  INCLUDE_VERTEX_LIGHTING
	float3 VertexLighting		: TEXCOORD7;
#endif
};

VS_OUTPUT_STANDART vs_main_standart_face_mod (uniform const int PcfMode, 
										uniform const bool use_bumpmap, 
										float4 vPosition : POSITION, 
										float3 vNormal : NORMAL, 
										float2 tc : TEXCOORD0,  
										float3 vTangent : TANGENT, 
										float3 vBinormal : BINORMAL, 
										float4 vVertexColor : COLOR0, 
										float4 vBlendWeights : BLENDWEIGHT,
										float4 vBlendIndices : BLENDINDICES)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_STANDART, Out);

	
	float4 vObjectPos;
	float3 vObjectN, vObjectT, vObjectB;
	
	vObjectPos = vPosition;
	
	vObjectN = vNormal;
	if(use_bumpmap) {
		vObjectT = vTangent;
		vObjectB = vBinormal;
	}
		
	float4 vWorldPos = mul(matWorld, vObjectPos);
	Out.Pos = mul(matWorldViewProj, vPosition);
	Out.Tex0 = tc;

	
	float3 vWorldN = normalize(mul((float3x3)matWorld, vObjectN));
	
	float3x3 TBNMatrix;
	if(use_bumpmap) {
		float3 vWorld_binormal = normalize(mul((float3x3)matWorld, vObjectB));
		float3 vWorld_tangent  = normalize(mul((float3x3)matWorld, vObjectT));
		TBNMatrix = float3x3(vWorld_tangent, vWorld_binormal, vWorldN); 
	}
	

	if (PcfMode != PCF_NONE)
	{
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
	}

	if(use_bumpmap) {
		Out.SunLightDir = normalize(mul(TBNMatrix, -vSunDir));
		Out.SkyLightDir = mul(TBNMatrix, -vSkyLightDir);
	} else {
		Out.SunLightDir = vWorldN;
	}
	Out.VertexColor = vVertexColor;
	
	
	//point lights
	#ifdef INCLUDE_VERTEX_LIGHTING
	Out.VertexLighting = calculate_point_lights_diffuse(vWorldPos, vWorldN, true, true);
	#endif
	
	
	#ifndef USE_LIGHTING_PASS 
	const int effective_light_index = iLightIndices[0];
	float3 point_to_light = vLightPosDir[effective_light_index]-vWorldPos.xyz;
	float LD = dot(point_to_light, point_to_light);
	Out.PointLightDir.a = saturate(1.0f/LD);	//prevent bloom for 1 meters
	
	if(use_bumpmap) {
		Out.PointLightDir.xyz = mul(TBNMatrix, normalize(point_to_light));
	} else {
		Out.PointLightDir.xyz = normalize(point_to_light);
	}
	#endif
	
	
	if(use_bumpmap) {
		Out.ViewDir =  mul(TBNMatrix, normalize(vCameraPos.xyz - vWorldPos.xyz));
	}
	else {
		Out.ViewDir =  normalize(vCameraPos.xyz - vWorldPos.xyz);
	}
	
	float3 P = mul(matWorldView, vObjectPos); //position in view space
	
	//apply fog
	float d = length(P);
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);

	return Out;
}

PS_OUTPUT ps_main_standart_face_mod( VS_OUTPUT_STANDART In, uniform const int PcfMode, 
										uniform const bool use_bumpmap, uniform const bool use_ps2a )
{ 
	PS_OUTPUT Output;

	float4 total_light = vAmbientColor;//In.LightAmbient;

	float3 normal;
	
	if(use_bumpmap)
	{
		float3 tex1_norm, tex2_norm;
		tex1_norm = tex2D(NormalTextureSampler, In.Tex0);
		
		if(use_ps2a) {//add old's normal map with ps2a 
			tex2_norm = tex2D(SpecularTextureSampler, In.Tex0);
			normal = lerp(tex1_norm, tex2_norm, In.VertexColor.a);	// blend normals different?
			normal = 2.0f * normal - 1.0f;		
			normal = normalize(normal);
		}
		else {
			normal = (2 * tex1_norm - 1);
		}
	}
	else {
		normal = In.SunLightDir.xyz;
	}
	
	float sun_amount = 1;
	if (PcfMode != PCF_NONE)
	{
		sun_amount = GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
	}
	
	if(use_bumpmap)
	{
		total_light += face_NdotL(In.SunLightDir.xyz, normal.xyz) * sun_amount * vSunColor;
		if(use_ps2a) {
			total_light += face_NdotL(In.SkyLightDir.xyz, normal.xyz) * vSkyLightColor;
		}
	}
	else 
	{
		total_light += face_NdotL(-vSunDir, normal.xyz) * sun_amount * vSunColor;
		if(use_ps2a) {
			total_light += face_NdotL(-vSkyLightDir, normal.xyz) * vSkyLightColor;
		}
	}

	float3 point_lighting = 0;
	#ifndef USE_LIGHTING_PASS 
		float light_atten = In.PointLightDir.a * 0.9f;
		const int effective_light_index = iLightIndices[0];
		point_lighting += light_atten * face_NdotL(In.PointLightDir.xyz, normal.xyz) * vLightDiffuse[effective_light_index];
	#endif
	
	#ifdef INCLUDE_VERTEX_LIGHTING
		if(use_ps2a) { point_lighting += In.VertexLighting; }
	#endif
	total_light.rgb += point_lighting;

	if (PcfMode != PCF_NONE)
		Output.RGBColor.rgb = total_light.rgb;
	else
		Output.RGBColor.rgb = min(total_light.rgb, 2.0f);
		
	// Output.RGBColor.rgb = total_light.rgb;
	
	float4 tex1_col = tex2D(MeshTextureSampler, In.Tex0);
	float4 tex2_col = tex2D(Diffuse2Sampler, In.Tex0);
	float4 tex_col = lerp(tex1_col, tex2_col, In.VertexColor.a);
	
	INPUT_TEX_GAMMA(tex_col.rgb);
	
	Output.RGBColor *= tex_col;
	Output.RGBColor.rgb *= (In.VertexColor.rgb * vMaterialColor.rgb);
	
	if(use_ps2a) {
		float fSpecular = 0;
		
		float4 specColor =  vSpecularColor * vSunColor;	//float4(1.0, 0.9, 0.8, 1.0) * 2;//
		if(false) {	//we dont have specularmap yet-> used for normalmap2
			specColor *= tex2D(SpecularTextureSampler, In.Tex0);
		}
		
		float3 vHalf = normalize( In.ViewDir + In.SunLightDir );
		fSpecular = specColor * pow( saturate(dot(vHalf, normal)), fMaterialPower) * sun_amount; 
		
		float fresnel = saturate(1.0f - dot(In.ViewDir, normal));
		Output.RGBColor += fresnel * fSpecular;
	}
	
	//Output.RGBColor = saturate(Output.RGBColor);
	Output.RGBColor.rgb = saturate( OUTPUT_GAMMA(Output.RGBColor.rgb) );	//do not bloom!
	Output.RGBColor.a = vMaterialColor.a;
	////
	//Output.RGBColor = face_NdotL(In.PointLightDir.xyz, normal.xyz) * vLightDiffuse[effective_light_index] * In.PointLightDir.a;
	//Output.RGBColor.rgb += In.VertexLighting;
	//Output.RGBColor.a = 1;

	return Output;
}

////////////////////
technique face_shader_high
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_standart_face_mod(PCF_NONE, true);
		PixelShader = compile ps_2_a ps_main_standart_face_mod(PCF_NONE, true, false);
	}
}
technique face_shader_high_SHDW
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_standart_face_mod(PCF_DEFAULT, true);
		PixelShader = compile ps_2_a ps_main_standart_face_mod(PCF_DEFAULT, true, false);

	}
}
technique face_shader_high_SHDWNVIDIA
{
	pass P0
	{
		VertexShader = compile vs_2_a vs_main_standart_face_mod(PCF_NVIDIA, true);
		PixelShader = compile ps_2_a ps_main_standart_face_mod(PCF_NVIDIA, true, false);
	}
}

DEFINE_LIGHTING_TECHNIQUE(face_shader_high, 0, 1, 0, 0, 0)	

////////////////////
technique faceshader_high_specular
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_standart_face_mod(PCF_NONE, true);
		PixelShader = compile PS_2_X ps_main_standart_face_mod(PCF_NONE, true, true);
	}
}
technique faceshader_high_specular_SHDW
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_standart_face_mod(PCF_DEFAULT, true);
		PixelShader = compile PS_2_X ps_main_standart_face_mod(PCF_DEFAULT, true, true);

	}
}
technique faceshader_high_specular_SHDWNVIDIA
{
	pass P0
	{
		VertexShader = compile vs_2_a vs_main_standart_face_mod(PCF_NVIDIA, true);
		PixelShader = compile ps_2_a ps_main_standart_face_mod(PCF_NVIDIA, true, true);
	}
}

DEFINE_LIGHTING_TECHNIQUE(faceshader_high_specular, 0, 1, 0, 0, 0)	


////////////////////
technique faceshader_simple
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_standart_face_mod(PCF_NONE, false);
		PixelShader = compile ps_2_a ps_main_standart_face_mod(PCF_NONE, false, false);
	}
}
technique faceshader_simple_SHDW
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_standart_face_mod(PCF_DEFAULT, false);
		PixelShader = compile ps_2_a ps_main_standart_face_mod(PCF_DEFAULT, false, false);

	}
}
technique faceshader_simple_SHDWNVIDIA
{
	pass P0
	{
		VertexShader = compile vs_2_a vs_main_standart_face_mod(PCF_NVIDIA, false);
		PixelShader = compile ps_2_a ps_main_standart_face_mod(PCF_NVIDIA, false, false);
	}
}

DEFINE_LIGHTING_TECHNIQUE(faceshader_high_specular, 0, 1, 0, 0, 0)	

////////////////////////////////////////
VS_OUTPUT vs_main_skin (float4 vPosition : POSITION, float3 vNormal : NORMAL, float2 tc : TEXCOORD0, float4 vColor : COLOR, float4 vBlendWeights : BLENDWEIGHT, float4 vBlendIndices : BLENDINDICES, uniform const int PcfMode)
{
	INITIALIZE_OUTPUT(VS_OUTPUT, Out);

	float4 vObjectPos = skinning_deform(vPosition, vBlendWeights, vBlendIndices);
	
	float3 vObjectN = normalize(  mul((float3x3)matWorldArray[vBlendIndices.x], vNormal) * vBlendWeights.x
								+ mul((float3x3)matWorldArray[vBlendIndices.y], vNormal) * vBlendWeights.y
								+ mul((float3x3)matWorldArray[vBlendIndices.z], vNormal) * vBlendWeights.z
								+ mul((float3x3)matWorldArray[vBlendIndices.w], vNormal) * vBlendWeights.w);

	float4 vWorldPos = mul(matWorld,vObjectPos);
	Out.Pos = mul(matWorldViewProj, vObjectPos);
	float3 vWorldN = normalize(mul((float3x3)matWorld, vObjectN)); //normal in world space

	float3 P = mul(matView, vWorldPos); //position in view space

	Out.Tex0 = tc;

	//light computation
	Out.Color = vAmbientColor;
	//   Out.Color.rgb *= gradient_factor * (gradient_offset + vWorldN.z);

	//directional lights, compute diffuse color
	Out.Color += saturate(dot(vWorldN, -vSkyLightDir)) * vSkyLightColor;

	//point lights
	#ifndef USE_LIGHTING_PASS
	Out.Color += calculate_point_lights_diffuse(vWorldPos, vWorldN, false, false);
	#endif
	
	//apply fog
	float d = length(P);
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);
	
	float3 viewdir = normalize(vCameraPos.xyz - vWorldPos.xyz);
	
	if(bNightVision == 1)
		Out.Color.rgb += flashlight(d, viewdir, vWorldN);

	//apply material color
	Out.Color *= vMaterialColor * vColor;
	Out.Color = min(1, Out.Color);

	//shadow mapping variables
	float wNdotSun = saturate(dot(vWorldN, -vSunDir));
	Out.SunLight = wNdotSun * vSunColor * vMaterialColor * vColor;
	if (PcfMode != PCF_NONE)
	{
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	}


	return Out;
}

technique skin_diffuse
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_skin(PCF_NONE);
		PixelShader = ps_main_compiled_PCF_NONE;
	}
}
technique skin_diffuse_SHDW
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_skin(PCF_DEFAULT);
		PixelShader = ps_main_compiled_PCF_DEFAULT;
	}
}
technique skin_diffuse_SHDWNVIDIA
{
	pass P0
	{
		VertexShader = compile vs_2_a vs_main_skin(PCF_NVIDIA);
		PixelShader = ps_main_compiled_PCF_NVIDIA;
	}
}

DEFINE_LIGHTING_TECHNIQUE(skin_diffuse, 0, 0, 1, 0, 0)	


#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef FLORA_SHADERS

struct VS_OUTPUT_FLORA
{
	float4 Pos					: POSITION;
	float  Fog				    : FOG;
	
	float4 Color				: COLOR0;
	float2 Tex0					: TEXCOORD0;
	float4 SunLight				: TEXCOORD1;
	float4 ShadowTexCoord		: TEXCOORD2;
	float2 ShadowTexelPos		: TEXCOORD3;
};

struct VS_OUTPUT_FLORA_NO_SHADOW
{
	float4 Pos					: POSITION;
	float4 Color					: COLOR0;
	float2 Tex0					: TEXCOORD0;
	float  Fog				    : FOG;
};

VS_OUTPUT_FLORA vs_flora(uniform const int PcfMode, float4 vPosition : POSITION, float4 vColor : COLOR0, float2 tc : TEXCOORD0)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_FLORA, Out);

	Out.Pos = mul(matWorldViewProj, vPosition);
	float4 vWorldPos = (float4)mul(matWorld,vPosition);


	Out.Tex0 = tc;
	//   Out.Color = vColor * vMaterialColor;
	Out.Color = vColor * (vAmbientColor + vSunColor * 0.06f); //add some sun color to simulate sun passing through leaves.
	Out.Color.a *= vMaterialColor.a;

	//   Out.Color = vColor * vMaterialColor * (vAmbientColor + vSunColor * 0.15f);
	//shadow mapping variables
	Out.SunLight = (vSunColor * 0.34f)* vMaterialColor * vColor;

	if (PcfMode != PCF_NONE)
	{
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
	}
	//shadow mapping variables end
	
	//apply fog
	float3 P = mul(matWorldView, vPosition); //position in view space
	float d = length(P);
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);

	return Out;
}


VS_OUTPUT_FLORA vs_flora_Instanced(uniform const int PcfMode, float4 vPosition : POSITION, float4 vColor : COLOR0, float2 tc : TEXCOORD0,
								   //instance data:
								   float3   vInstanceData0 : TEXCOORD1,
								   float3   vInstanceData1 : TEXCOORD2,
								   float3   vInstanceData2 : TEXCOORD3,
								   float3   vInstanceData3 : TEXCOORD4)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_FLORA, Out);
	
	float4x4 matWorldOfInstance = build_instance_frame_matrix(vInstanceData0, vInstanceData1, vInstanceData2, vInstanceData3);

	float4 vWorldPos = (float4)mul(matWorldOfInstance,vPosition);
	Out.Pos = mul(matViewProj, vWorldPos);

	Out.Tex0 = tc;
	//   Out.Color = vColor * vMaterialColor;
	Out.Color = vColor * (vAmbientColor + vSunColor * 0.06f); //add some sun color to simulate sun passing through leaves.
	Out.Color.a *= vMaterialColor.a;

	//   Out.Color = vColor * vMaterialColor * (vAmbientColor + vSunColor * 0.15f);
	//shadow mapping variables
	Out.SunLight = (vSunColor * 0.34f)* vMaterialColor * vColor;

	if (PcfMode != PCF_NONE)
	{
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
	}
	//shadow mapping variables end
	
	//apply fog
	float3 P = mul(matView, vWorldPos); //position in view space
	float d = length(P);
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);

	return Out;
}

PS_OUTPUT ps_flora(VS_OUTPUT_FLORA In, uniform const int PcfMode) 
{ 
	PS_OUTPUT Output;
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0);
	clip(tex_col.a - 0.05f);
	
	INPUT_TEX_GAMMA(tex_col.rgb);


	if (PcfMode != PCF_NONE)
	{
		float sun_amount = GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
		Output.RGBColor =  tex_col * ((In.Color + In.SunLight * sun_amount));
	}
	else
	{
		Output.RGBColor =  tex_col * ((In.Color + In.SunLight));
	}

	//Output.RGBColor = tex_col * In.Color;
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	
	return Output;
}

VS_OUTPUT_FLORA_NO_SHADOW vs_flora_no_shadow(float4 vPosition : POSITION, float4 vColor : COLOR0, float2 tc : TEXCOORD0)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_FLORA_NO_SHADOW, Out);

	Out.Pos = mul(matWorldViewProj, vPosition);
	float4 vWorldPos = (float4)mul(matWorld,vPosition);

	float3 P = mul(matWorldView, vPosition); //position in view space

	Out.Tex0 = tc;
	Out.Color = vColor * vMaterialColor;

	//apply fog
	float d = length(P);
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);

	return Out;
}

PS_OUTPUT ps_flora_no_shadow(VS_OUTPUT_FLORA_NO_SHADOW In) 
{ 
	PS_OUTPUT Output;
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0);
	clip(tex_col.a - 0.05f);
	
	INPUT_TEX_GAMMA(tex_col.rgb);

	Output.RGBColor = tex_col * In.Color;
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	
	return Output;
}

VS_OUTPUT_FLORA vs_grass(uniform const int PcfMode, float4 vPosition : POSITION, float4 vColor : COLOR0, float2 tc : TEXCOORD0)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_FLORA, Out);

	Out.Pos = mul(matWorldViewProj, vPosition);
	float4 vWorldPos = (float4)mul(matWorld,vPosition);

	float3 P = mul(matWorldView, vPosition); //position in view space

	Out.Tex0 = tc;
	Out.Color = vColor * vAmbientColor;

	//shadow mapping variables
	if (PcfMode != PCF_NONE)
	{
		Out.SunLight = (vSunColor * 0.55f) * vMaterialColor * vColor;
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
	}
	else
	{
		Out.SunLight = vSunColor * 0.5f * vColor;
	}
	//shadow mapping variables end
	//apply fog
	float d = length(P);
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);

	Out.Color.a = min(1.0f,(1.0f - (d / 50.0f)) * 2.0f);

	return Out;
}

PS_OUTPUT ps_grass(VS_OUTPUT_FLORA In, uniform const int PcfMode) 
{ 
	PS_OUTPUT Output;
	float4 tex_col = tex2D(GrassTextureSampler, In.Tex0);
	
	//    clip(tex_col.a - 0.05f);
	clip(tex_col.a - 0.1f);
	
	INPUT_TEX_GAMMA(tex_col.rgb);

	if ((PcfMode != PCF_NONE))
	{
		float sun_amount = GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
		Output.RGBColor =  tex_col * ((In.Color + In.SunLight * sun_amount));
	}
	else
	{
		Output.RGBColor =  tex_col * ((In.Color + In.SunLight));
	}

	//    	Output.RGBColor = tex_col * (In.Color + In.SunLight);
	//	Output.RGBColor = tex_col * In.Color;
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	
	return Output;
}

VS_OUTPUT_FLORA_NO_SHADOW vs_grass_no_shadow(float4 vPosition : POSITION, float4 vColor : COLOR0, float2 tc : TEXCOORD0)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_FLORA_NO_SHADOW, Out);

	Out.Pos = mul(matWorldViewProj, vPosition);
	float4 vWorldPos = (float4)mul(matWorld,vPosition);

	float3 P = mul(matWorldView, vPosition); //position in view space

	Out.Tex0 = tc;
	Out.Color = vColor * vMaterialColor;

	//apply fog
	float d = length(P);
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);

	Out.Color.a = min(1.0f,(1.0f - (d / 50.0f)) * 2.0f);

	return Out;
}

PS_OUTPUT ps_grass_no_shadow(VS_OUTPUT_FLORA_NO_SHADOW In) 
{ 
	PS_OUTPUT Output;
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0);
	
	clip(tex_col.a - 0.1f);
	
	INPUT_TEX_GAMMA(tex_col.rgb);

	Output.RGBColor = tex_col * In.Color;
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	return Output;
}

DEFINE_TECHNIQUES(flora, vs_flora, ps_flora)

technique flora_PRESHADED
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_flora_no_shadow();
		PixelShader = compile ps_2_a ps_flora_no_shadow();
	}
}
DEFINE_LIGHTING_TECHNIQUE(flora, 0, 0, 0, 0, 0)


DEFINE_TECHNIQUES(flora_Instanced, vs_flora_Instanced, ps_flora)


technique grass_no_shadow
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_grass_no_shadow();
		PixelShader = compile ps_2_a ps_grass_no_shadow();
	}
}

DEFINE_TECHNIQUES(grass, vs_grass, ps_grass)

technique grass_PRESHADED
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_grass_no_shadow();
		PixelShader = compile ps_2_a ps_grass_no_shadow();
	}
}
DEFINE_LIGHTING_TECHNIQUE(grass, 0, 0, 0, 0, 0)
#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef MAP_SHADERS

//---
struct VS_OUTPUT_MAP
{
	float4 Pos					: POSITION;
	float4 Color				: COLOR0;
	float2 Tex0					: TEXCOORD0;
	float4 SunLight				: TEXCOORD1;
	float4 ShadowTexCoord		: TEXCOORD2;
	float2 ShadowTexelPos		: TEXCOORD3;
	float  Fog				    : FOG;
	
	float3 ViewDir				: TEXCOORD6;
	float3 WorldNormal			: TEXCOORD7;
};
VS_OUTPUT_MAP vs_main_map(uniform const int PcfMode, float4 vPosition : POSITION, float3 vNormal : NORMAL, 
							float2 tc : TEXCOORD0, float4 vColor : COLOR0, float4 vLightColor : COLOR1)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_MAP, Out);

	Out.Pos = mul(matWorldViewProj, vPosition);

	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal)); //normal in world space


	Out.Tex0 = tc;

	float4 diffuse_light = vAmbientColor;

	if (true /*_UseSecondLight*/)
	{
		diffuse_light += vLightColor;
	}

	//directional lights, compute diffuse color
	diffuse_light += saturate(dot(vWorldN, -vSkyLightDir)) * vSkyLightColor;
	
	//apply material color
	//	Out.Color = min(1, vMaterialColor * vColor * diffuse_light);
	Out.Color = (vMaterialColor * vColor * diffuse_light);

	//shadow mapping variables
	float wNdotSun = saturate(dot(vWorldN, -vSunDir));
	Out.SunLight = (wNdotSun) * vSunColor * vMaterialColor * vColor;
	if (PcfMode != PCF_NONE)
	{
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	}
	
	Out.ViewDir = normalize(vCameraPos-vWorldPos);
	Out.WorldNormal = vWorldN;
	
	//apply fog
	float3 P = mul(matWorldView, vPosition); //position in view space
	float d = length(P);

	Out.Fog = get_fog_amount_map(d, vWorldPos.z);
	return Out;
}
PS_OUTPUT ps_main_map(VS_OUTPUT_MAP In, uniform const int PcfMode)
{
	PS_OUTPUT Output;
	
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0);
	INPUT_TEX_GAMMA(tex_col.rgb);
	
	float sun_amount = 1;
	if ((PcfMode != PCF_NONE))
	{
		sun_amount = GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
	}
	Output.RGBColor =  tex_col * ((In.Color + In.SunLight * sun_amount));
	
	
	//add fresnel term
	{
		float fresnel = 1-(saturate(dot( normalize(In.ViewDir), normalize(In.WorldNormal))));
		fresnel *= fresnel;
		Output.RGBColor.rgb *= max(0.6,fresnel+0.1); 
	}	
	// gamma correct
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	
	return Output;
}

DEFINE_TECHNIQUES(diffuse_map, vs_main_map, ps_main_map)	//diffuse shader with fresnel effect

//---
struct VS_OUTPUT_MAP_BUMP
{
	float4 Pos					: POSITION;
	float4 Color				: COLOR0;
	float3 Tex0					: TEXCOORD0;
	//float4 SunLight				: TEXCOORD1;
	float4 ShadowTexCoord		: TEXCOORD2;
	float2 ShadowTexelPos		: TEXCOORD3;
	float  Fog				    : FOG;
	
	float3 SunLightDir			: TEXCOORD4;
	float3 SkyLightDir			: TEXCOORD5;
	
	float3 ViewDir				: TEXCOORD6;
	float3 WorldNormal			: TEXCOORD7;
};
VS_OUTPUT_MAP_BUMP vs_main_map_bump(uniform const int PcfMode, float4 vPosition : POSITION, 
									float3 vNormal : NORMAL, float3 vTangent : TANGENT, float3 vBinormal : BINORMAL,
									float2 tc : TEXCOORD0, float4 vColor : COLOR0,float4 vLightColor : COLOR1)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_MAP_BUMP, Out);

	//dstn Flat Map Experiment
	// float4 vPositionOrig = vPosition;
	// vPosition.z = map_flatten(vCameraPos.z, vPosition.z);
	// Out.Tex0.z = map_smoothstep(vCameraPos.z);

	Out.Pos = mul(matWorldViewProj, vPosition);

	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	
	float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal)); //normal in world space
	float3 vWorld_binormal = normalize(mul((float3x3)matWorld, vBinormal)); //normal in world space
	float3 vWorld_tangent  = normalize(mul((float3x3)matWorld, vTangent)); //normal in world space
	float3x3 TBNMatrix = float3x3(vWorld_tangent, vWorld_binormal, vWorldN); 
	
	Out.Tex0.xy = tc;

	float4 diffuse_light = vAmbientColor;

	if (true /*_UseSecondLight*/)
	{
		diffuse_light += vLightColor;
	}

	//directional lights, compute diffuse color
	diffuse_light += saturate(dot(vWorldN, -vSkyLightDir)) * vSkyLightColor;
	
	//point lights
	#ifndef USE_LIGHTING_PASS
	diffuse_light += calculate_point_lights_diffuse(vWorldPos, vWorldN, false, false);
	#endif
	
	//apply material color
	//	Out.Color = min(1, vMaterialColor * vColor * diffuse_light);
	Out.Color = (vMaterialColor * vColor * diffuse_light);
	Out.Color.a = vColor.a;

	//shadow mapping variables

	//move sun light to pixel shader
	//float wNdotSun = saturate(dot(vWorldN, -vSunDir));
	//Out.SunLight = (wNdotSun) * vSunColor * vMaterialColor * vColor;
	Out.SunLightDir = normalize(mul(TBNMatrix, -vSunDir));
	
	if (PcfMode != PCF_NONE)
	{
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	}
	
	Out.ViewDir = normalize(vCameraPos-vWorldPos);
	Out.WorldNormal = vWorldN;
	
	float height = 1 / (Out.Pos.z / 10);
	
	//apply fog
	float3 P = mul(matWorldView, vPosition); //position in view space
	float d = length(P);

	Out.Fog = get_fog_amount_map(d, vWorldPos.z);
	return Out;
}
PS_OUTPUT ps_main_map_bump(VS_OUTPUT_MAP_BUMP In, uniform const int PcfMode)
{
	PS_OUTPUT Output;
	
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0.xy);
	// float4 blend_col = tex2D(Diffuse2Sampler, In.Tex0.xy);
	// tex_col = lerp(tex_col, blend_col, In.Tex0.z);
	INPUT_TEX_GAMMA(tex_col.rgb);
	
	
	float3 normal = lerp((2.0f * tex2D(NormalTextureSampler, In.Tex0.xy * map_normal_detail_factor).rgb - 1.0f), 1.0f, In.Tex0.z);
	
	/*if (In.Tex0.z == 1)
	{
		normal = 1.0;
	}*/
	
	//float wNdotSun = saturate(dot(vWorldN, -vSunDir));
	//Out.SunLight = (wNdotSun) * vSunColor * vMaterialColor * vColor;
	float4 In_SunLight = saturate(dot(normal, In.SunLightDir)) * vSunColor * vMaterialColor;// * vColor;  vertex color needed??
	
	float sun_amount = 1;
	if ((PcfMode != PCF_NONE))
	{
		sun_amount = GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
	}
	Output.RGBColor =  lerp(tex_col * ((In.Color + In_SunLight * sun_amount)), tex_col, In.Tex0.z);
	
	
	//add fresnel term
	{
		float fresnel = 1-(saturate(dot( normalize(In.ViewDir), normalize(In.WorldNormal))));
		fresnel *= fresnel;
		Output.RGBColor.rgb *= max(0.6,fresnel+0.1); 
	}	
	// gamma correct
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	
	
	return Output;
}

DEFINE_TECHNIQUES(diffuse_map_bump, vs_main_map_bump, ps_main_map_bump)	//diffuse shader with fresnel effect + bumpmapping(if shader_quality medium)..

//---
struct VS_OUTPUT_MAP_MOUNTAIN
{
	float4 Pos					: POSITION;
	float  Fog				    : FOG;
	
	float4 Color				: COLOR0;
	float4 Tex0					: TEXCOORD0;
	float4 SunLight				: TEXCOORD1;
	float4 ShadowTexCoord		: TEXCOORD2;
	float2 ShadowTexelPos		: TEXCOORD3;
	
	float3 ViewDir				: TEXCOORD6;
	float3 WorldNormal			: TEXCOORD7;
};

VS_OUTPUT_MAP_MOUNTAIN vs_map_mountain(uniform const int PcfMode, float4 vPosition : POSITION, float3 vNormal : NORMAL, 
										float2 tc : TEXCOORD0, float4 vColor : COLOR0, float4 vLightColor : COLOR1)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_MAP_MOUNTAIN, Out);

	//dstn Flat Map Experiment
	//float4 vPositionOrig = vPosition;
	// vPosition.z = map_flatten(vCameraPos.z, vPosition.z);
	//Out.Tex0.w = map_smoothstep(vCameraPos.z);

	Out.Pos = mul(matWorldViewProj, vPosition);

	// float4 vWorldPos = (float4)mul(matWorld,vPositionOrig);
	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal)); //normal in world space

	float3 P = mul(matWorldView, vPosition); //position in view space

	Out.Tex0.xy = tc;
	Out.Tex0.z = /*saturate*/(0.7f * (vWorldPos.z - 1.5f));

	float4 diffuse_light = vAmbientColor;
	if (true /*_UseSecondLight*/)
	{
		diffuse_light += vLightColor;
	}

	//directional lights, compute diffuse color
	diffuse_light += saturate(dot(vWorldN, -vSkyLightDir)) * vSkyLightColor;

	//apply material color
	//	Out.Color = min(1, vMaterialColor * vColor * diffuse_light);
	Out.Color = (vMaterialColor * vColor * diffuse_light);

	//shadow mapping variables
	float wNdotSun = saturate(dot(vWorldN, -vSunDir));
	Out.SunLight = (wNdotSun) * vSunColor;
	if (PcfMode != PCF_NONE)
	{
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	}
	
	
	Out.ViewDir = normalize(vCameraPos-vWorldPos);
	Out.WorldNormal = vWorldN;
	
	
	//apply fog
	float d = length(P);

	Out.Fog = get_fog_amount_map(d, vWorldPos.z);
	return Out;
}

PS_OUTPUT ps_map_mountain(VS_OUTPUT_MAP_MOUNTAIN In, uniform const int PcfMode)
{
	PS_OUTPUT Output;
	
	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0.xy);
	// float4 blend_col = tex2D(Diffuse2Sampler, In.Tex0.xy);
	INPUT_TEX_GAMMA(tex_col.rgb);
	
	tex_col.rgb += saturate(In.Tex0.z * (tex_col.a) - 1.5f);
	tex_col.a = 1.0f;
	
	//tex_col = lerp(tex_col, blend_col, In.Tex0.w);
	
	if ((PcfMode != PCF_NONE))
	{
		float sun_amount = GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
		//		sun_amount *= sun_amount;
		Output.RGBColor =  saturate(tex_col) * ((In.Color + In.SunLight * sun_amount));
	}
	else
	{
		Output.RGBColor = saturate(tex_col) * (In.Color + In.SunLight);
	}
	
	{
		float fresnel = 1-(saturate(dot( In.ViewDir, In.WorldNormal)));
	//	fresnel *= fresnel;
		Output.RGBColor.rgb *= max(0.6,fresnel+0.1); 
	}	
	
	
	// gamma correct
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	
	
	return Output;
}

DEFINE_TECHNIQUES(map_mountain, vs_map_mountain, ps_map_mountain)


//---
struct VS_OUTPUT_MAP_MOUNTAIN_BUMP
{
	float4 Pos					: POSITION;
	float4 Color					: COLOR0;
	float3 Tex0					: TEXCOORD0;
	//float4 SunLight				: TEXCOORD1;
	float4 ShadowTexCoord		: TEXCOORD2;
	float2 ShadowTexelPos		: TEXCOORD3;
	float  Fog				    : FOG;
	
	float3 SunLightDir			: TEXCOORD4;
	float3 SkyLightDir			: TEXCOORD5;
	
	float3 ViewDir				: TEXCOORD6;
	float3 WorldNormal			: TEXCOORD7;
};
VS_OUTPUT_MAP_MOUNTAIN_BUMP vs_map_mountain_bump(uniform const int PcfMode, float4 vPosition : POSITION, 
												float3 vNormal : NORMAL,  float3 vTangent : TANGENT, float3 vBinormal : BINORMAL,
												float2 tc : TEXCOORD0, float4 vColor : COLOR0, float4 vLightColor : COLOR1)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_MAP_MOUNTAIN_BUMP, Out);
	
	//dstn Flat Map Experiment
	// float4 vPositionOrig = vPosition;
	// vPosition.z = map_flatten(vCameraPos.z, vPosition.z);

	Out.Pos = mul(matWorldViewProj, vPosition);

	// float4 vWorldPos = (float4)mul(matWorld,vPositionOrig);
	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal)); //normal in world space
	float3 vWorld_binormal = normalize(mul((float3x3)matWorld, vBinormal)); //normal in world space
	float3 vWorld_tangent  = normalize(mul((float3x3)matWorld, vTangent)); //normal in world space
	float3x3 TBNMatrix = float3x3(vWorld_tangent, vWorld_binormal, vWorldN); 

	float3 P = mul(matWorldView, vPosition); //position in view space

	Out.Tex0.xy = tc;
	Out.Tex0.z = /*saturate*/(0.7f * (vWorldPos.z - 1.5f));
	// Out.Tex0.w = map_smoothstep(vCameraPos.z);

	float4 diffuse_light = vAmbientColor;
	if (true /*_UseSecondLight*/)
	{
		diffuse_light += vLightColor;
	}

	//directional lights, compute diffuse color
	diffuse_light += saturate(dot(vWorldN, -vSkyLightDir)) * vSkyLightColor;

	//apply material color
	//	Out.Color = min(1, vMaterialColor * vColor * diffuse_light);
	Out.Color = (vMaterialColor * vColor * diffuse_light);

	//shadow mapping variables
	//float wNdotSun = saturate(dot(vWorldN, -vSunDir));
	//Out.SunLight = (wNdotSun) * vSunColor;
	Out.SunLightDir = normalize(mul(TBNMatrix, -vSunDir));
			
	if (PcfMode != PCF_NONE)
	{
		
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	}
	
	
	Out.ViewDir = normalize(vCameraPos-vWorldPos);
	Out.WorldNormal = vWorldN;
	
	
	//apply fog
	float d = length(P);

	Out.Fog = get_fog_amount_map(d, vWorldPos.z);
	return Out;
}
PS_OUTPUT ps_map_mountain_bump(VS_OUTPUT_MAP_MOUNTAIN_BUMP In, uniform const int PcfMode)
{
	PS_OUTPUT Output;
	
	float4 sample_col = tex2D(MeshTextureSampler, In.Tex0.xy);
	
	
	float4 tex_col = sample_col;
	
	tex_col.rgb += saturate(In.Tex0.z * (sample_col.a) - 1.5f);
	tex_col.a = 1.0f;
	/*    
	float snow = In.Tex0.z * (0.1f + sample_col.a) - 1.5f;
	if (snow > 0.5f)
	{
		tex_col = float4(1.0f,1.0f,1.0f,1.0f);
	}
*/    
	// float4 blend_col = tex2D(Diffuse2Sampler, In.Tex0.xy);
	// tex_col = lerp(tex_col, blend_col, In.Tex0.w);
	INPUT_TEX_GAMMA(tex_col.rgb);

	//float3 normal = lerp((2.0f * tex2D(NormalTextureSampler, In.Tex0 * map_normal_detail_factor).rgb - 1.0f), 1.0f, In.Tex0.w);
	float3 normal = 2.0f * tex2D(NormalTextureSampler, In.Tex0 * map_normal_detail_factor).rgb - 1.0f;
	
	//float wNdotSun = saturate(dot(vWorldN, -vSunDir));
	//Out.SunLight = (wNdotSun) * vSunColor;
	float4 In_SunLight = saturate(dot(normal, In.SunLightDir)) * vSunColor;
	

	if ((PcfMode != PCF_NONE))
	{
		float sun_amount = GetSunAmount(PcfMode, In.ShadowTexCoord, In.ShadowTexelPos);
		//		sun_amount *= sun_amount;
		//Output.RGBColor =  lerp(saturate(tex_col) * ((In.Color + In_SunLight * sun_amount)), tex_col, In.Tex0.w);
		Output.RGBColor = saturate(tex_col) * (In.Color + In_SunLight);
	}
	else
	{
		// Output.RGBColor = lerp(saturate(tex_col) * (In.Color + In_SunLight), tex_col, In.Tex0.w);;
		Output.RGBColor = saturate(tex_col) * (In.Color + In_SunLight);
	}
	
	{
		float fresnel = 1-(saturate(dot( In.ViewDir, In.WorldNormal)));
	//	fresnel *= fresnel;
		Output.RGBColor.rgb *= max(0.6,fresnel+0.1); 
	}	
	
	
	// gamma correct
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	
	
	return Output;
}

DEFINE_TECHNIQUES(map_mountain_bump, vs_map_mountain_bump, ps_map_mountain_bump)

//---
struct VS_OUTPUT_MAP_WATER
{
	float4 Pos           : POSITION;
	float4 Color	     : COLOR0;
	float2 Tex0          : TEXCOORD0;
	float3 LightDir		 : TEXCOORD1;//light direction for bump
	float3 CameraDir	 : TEXCOORD3;//camera direction for bump
	float4 PosWater		 : TEXCOORD4;//position according to the water camera
	float  Fog           : FOG;
};
VS_OUTPUT_MAP_WATER vs_map_water (uniform const bool reflections, float4 vPosition : POSITION, float3 vNormal : NORMAL, float2 tc : TEXCOORD0, float4 vColor : COLOR0, float4 vLightColor : COLOR1, float3 vTangent : TANGENT, float3 vBinormal : BINORMAL)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_MAP_WATER, Out);
	
	// dstn Flat Map Experiment
	/*float4 vPositionOrig = vPosition;
	float distance = smoothstep(30, 50, length(mul(matWorldView, vPosition)));
	vPosition.z *= distance * min(vPosition.z, 250) * 0.01f * ((1 - sin(75 * tc.x + time_var)) - (sin(35 * tc.y + 0.5f * time_var)));*/

	float4 vPositionOrig = vPosition;
	vPosition.z = map_flatten(vCameraPos.z, vPosition.z);
	
	Out.Pos = mul(matWorldViewProj, vPosition);
	

	float4 vWorldPos = (float4)mul(matWorld,vPositionOrig);
	float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal)); //normal in world space
	float3 vWorld_binormal = normalize(mul((float3x3)matWorld, vBinormal)); //normal in world space
	float3 vWorld_tangent  = normalize(mul((float3x3)matWorld, vTangent)); //normal in world space
	float3x3 TBNMatrix = float3x3(vWorld_tangent, vWorld_binormal, vWorldN); 

	float3 P = mul(matWorldView, vPosition); //position in view space

	// Out.Tex0.z =  map_smoothstep(vCameraPos.z);
	Out.Tex0.xy = tc + texture_offset.xy;
	
	

	float4 diffuse_light = vAmbientColor + vLightColor;

	//directional lights, compute diffuse color
	diffuse_light += saturate(dot(vWorldN, -vSkyLightDir)) * vSkyLightColor;

	float wNdotSun = max(-0.0001f, dot(vWorldN, -vSunDir));
	diffuse_light += (wNdotSun) * vSunColor;

	//apply material color
	//	Out.Color = min(1, vMaterialColor * vColor * diffuse_light);
	Out.Color = (vMaterialColor * vColor) * diffuse_light;
	
	//Out.Color.rgb += Out.Pos.y;
	
	
	if(reflections)
	{
		float4 water_pos = mul(matWaterViewProj, vWorldPos);
		Out.PosWater.xy = (float2(water_pos.x, -water_pos.y)+water_pos.w)/2;
		Out.PosWater.xy += (vDepthRT_HalfPixel_ViewportSizeInv.xy * water_pos.w);
		Out.PosWater.zw = water_pos.zw;
	}
	
	{
		//float3 vWorldN = float3(0,0,1); //vNormal; 
		//normalize(mul((float3x3)matWorld, vNormal)); //normal in world space
		//float3 vWorld_tangent  = float3(1,0,0); 
		//float3 vWorld_tangent  = normalize(mul((float3x3)matWorld, vTangent)); //normal in world space
		//float3 vWorld_binormal = float3(0,1,0); 
		// float3 vWorld_binormal = normalize(cross(vWorld_tangent, vNormal)); //normalize(mul((float3x3)matWorld, vBinormal)); //normal in world space

		float3x3 TBNMatrix = float3x3(vWorld_tangent, vWorld_binormal, vWorldN); 

		float3 point_to_camera_normal = normalize(vCameraPos.xyz - vWorldPos.xyz);
		Out.CameraDir = mul(TBNMatrix, -point_to_camera_normal);
		Out.LightDir = mul(TBNMatrix, -vSunDir);
	}
	
	/*
	float terminator = smoothstep(30, 50, Out.Pos.z);
	
	
	//Vertical Wave Displacements: If more than 25 units away from camera and camera isn't aiming down
	if(Out.Pos.z > 25 && vCameraPos.z < 30)
	Out.Pos.y += terminator * min(Out.Pos.z, 250) * 0.01f * ((1 - sin(75 * vWorldPos.x + time_var)) - (sin(35 * vWorldPos.y + 0.5f * time_var)));
	else
	Out.Pos.y += 0.01f * ((1 - sin(75 * vWorldPos.x + time_var)) - (sin(35 * vWorldPos.y + 0.5f * time_var)));
	*/
	
	float height = 1 / (Out.Pos.z / 10);

	//apply fog
	float d = length(P);
	Out.Fog = get_fog_amount_map(d, vWorldPos.z);
	
	return Out;
}
PS_OUTPUT ps_map_water(uniform const bool reflections, VS_OUTPUT_MAP_WATER In) 
{ 
	PS_OUTPUT Output;
	Output.RGBColor =  In.Color;

	float4 tex_col = tex2D(MeshTextureSampler, In.Tex0.xy);
	// dstn Flat Map Experiment
	//float4 blend_col = tex2D(Diffuse2Sampler, In.Tex0.xy);
	//tex_col.rgb = lerp(tex_col, blend_col * /*float3(0.25,0.35,0.5)*/ 0.85, In.Tex0.z);
	INPUT_TEX_GAMMA(tex_col.rgb);
	
	/////////////////////
	float3 normal;
	normal.xy = (2.0f * tex2D(NormalTextureSampler, In.Tex0 * 8).ag - 1.0f);
	normal.z = sqrt(1.0f - dot(normal.xy, normal.xy));
	
	float NdotL = saturate( dot(normal, In.LightDir) );
	float3 vView = normalize(In.CameraDir);

	// Fresnel term
	float fresnel = 1-(saturate(dot(vView, normal)));
	fresnel = 0.0204f + 0.9796 * (fresnel * fresnel * fresnel * fresnel * fresnel);
	Output.RGBColor.rgb += fresnel * In.Color.rgb;
	/////////////////////
		
	if(reflections)
	{
		//float4 tex = tex2D(ReflectionTextureSampler, g_HalfPixel_ViewportSizeInv.xy + 0.25f * normal.xy + float2(0.5f + 0.5f * (In.PosWater.x / In.PosWater.w), 0.5f - 0.5f * (In.PosWater.y / In.PosWater.w)));
		In.PosWater.xy += 0.35f * normal.xy;
		float4 tex = tex2Dproj(ReflectionTextureSampler, In.PosWater);
		INPUT_OUTPUT_GAMMA(tex.rgb);
		tex.rgb = min(tex.rgb, 4.0f);
		
		Output.RGBColor.rgb *= NdotL * lerp(tex_col.rgb, tex.rgb, reflection_factor);
	}
	else 
	{
		Output.RGBColor.rgb *= tex_col.rgb;
	}
	
	if (In.CameraDir.z > 0.5)
	{
	Output.RGBColor.rgb = tex2Dproj(ReflectionTextureSampler, In.PosWater);
    }

	//Output.RGBColor.rgb = lerp(Output.RGBColor.rgb, blend_col.rgb * float3(0.5,0.5,1), In.Tex0.z);
	OUTPUT_GAMMA(Output.RGBColor.rgb);	//0.5 * normal + 0.5; //
	//Output.RGBColor.rgb = In.Color.rgb;
	
	Output.RGBColor.a = In.Color.a * tex_col.a;
	
	return Output;
}

technique map_water
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_map_water(false);
		PixelShader = compile ps_2_a ps_map_water(false);
	}
}
technique map_water_high
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_map_water(true);
		PixelShader = compile ps_2_a ps_map_water(true);
	}
}
#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef SOFT_PARTICLE_SHADERS
struct VS_DEPTHED_FLARE
{
	float4 Pos					: POSITION;
	float4 Color				: COLOR0;
	float2 Tex0					: TEXCOORD0;
	float  Fog				    : FOG;
	
	float4 projCoord			: TEXCOORD1;
	float  Depth				: TEXCOORD2;
};

VS_DEPTHED_FLARE vs_main_depthed_flare(float4 vPosition : POSITION, float4 vColor : COLOR, float2 tc : TEXCOORD0)
{
	VS_DEPTHED_FLARE Out;

	Out.Pos = mul(matWorldViewProj, vPosition);


	Out.Tex0 = tc;
	Out.Color = vColor * vMaterialColor;
	
	
	if(use_depth_effects) {
		Out.projCoord.xy = (float2(Out.Pos.x, -Out.Pos.y)+Out.Pos.w)/2;
		Out.projCoord.xy += (vDepthRT_HalfPixel_ViewportSizeInv.xy * Out.Pos.w);
		Out.projCoord.zw = Out.Pos.zw;
		Out.Depth = Out.Pos.z * far_clip_Inv;
	}

	//apply fog
	float3 P = mul(matWorldView, vPosition); //position in view space
	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	float d = length(P);
	Out.Fog = get_fog_amount_map(d, vWorldPos.z);

	return Out;
}

PS_OUTPUT ps_main_depthed_flare(VS_DEPTHED_FLARE In, uniform const bool sun_like, uniform const bool blend_adding) 
{ 
	PS_OUTPUT Output;
	Output.RGBColor =  In.Color;
	Output.RGBColor *= tex2D(MeshTextureSampler, In.Tex0);

	if(!blend_adding) {
		//this shader replaces "ps_main_no_shadow" which uses gamma correction..
		OUTPUT_GAMMA(Output.RGBColor.rgb);
	}
	
	if(use_depth_effects) {	//add volume to in.depth?
		float depth = tex2Dproj(DepthTextureSampler, In.projCoord).r;
		
		float alpha_factor;
		
		if(sun_like) {
			float my_depth = 0;	//STR?: wignette like volume? tc!
			alpha_factor = depth;
			float fog_factor = 1.001f - (10.f * (fFogDensity+0.001f));	//0.1 -> 0.0  & 0.01 -> 1.0
			alpha_factor *= fog_factor;
		}
		else {
			alpha_factor = saturate((depth-In.Depth) * 4096); 
		}
		
		if(blend_adding)  {
			Output.RGBColor *= alpha_factor;	//pre-multiplied alpha
		}
		else  {
			Output.RGBColor.a *= alpha_factor;
		}
	}
	
	//Output.RGBColor.rgb = float3(0.8,0,0);
	//Output.RGBColor.w = 1;
	
	return Output;
}


VertexShader vs_main_depthed_flare_compiled = compile vs_2_0 vs_main_depthed_flare();

technique soft_sunflare
{
	pass P0
	{
		VertexShader = vs_main_depthed_flare_compiled;
		PixelShader = compile ps_2_a ps_main_depthed_flare(true,true);
	}
}


technique soft_particle_add
{
	pass P0
	{
		VertexShader = vs_main_depthed_flare_compiled;
		PixelShader = compile ps_2_a ps_main_depthed_flare(false,true);
	}
}

technique soft_particle_modulate
{
	pass P0
	{
		VertexShader = vs_main_depthed_flare_compiled;
		PixelShader = compile ps_2_a ps_main_depthed_flare(false,false);
	}
}
#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef OCEAN_SHADERS

struct VS_OUTPUT_OCEAN
{
	float4 Pos          : POSITION;
	float2 Tex0         : TEXCOORD0;
	float3 LightDir		: TEXCOORD1;
	float4 LightDif		: TEXCOORD2;//light diffuse for bump
	float3 CameraDir	: TEXCOORD3;
	float4 PosWater		: TEXCOORD4;//position according to the water camera
	
	float  Fog          : FOG;
};

inline float get_wave_height_temp(const float pos[2], const float coef, const float freq1, const float freq2, const float time)
{
	return coef * sin( (pos[0]+pos[1]) * freq1 + time) * cos( (pos[0]-pos[1]) * freq2 + (time+4));// + (coef * 0.05 * sin( (pos[0]*pos[1]) * (freq1 * 200 * time) + time));
}
VS_OUTPUT_OCEAN vs_main_ocean(float4 vPosition : POSITION, float2 tc : TEXCOORD0)
{
	VS_OUTPUT_OCEAN Out = (VS_OUTPUT_OCEAN) 0;

	float4 vWorldPos = mul(matWorld,vPosition);
	
	float3 viewVec = vCameraPos.xyz - vWorldPos.xyz;
	float wave_distance_factor = (1.0f - saturate(length(viewVec) * 0.01));	//no wave after 100 meters
	
	float pos_vector[2] = {vWorldPos.x, vWorldPos.y};
	vWorldPos.z += get_wave_height_temp(pos_vector, debug_vector.z, debug_vector.x, debug_vector.y, time_var) * wave_distance_factor; 

	Out.Pos = mul(matViewProj, vWorldPos);
	
	Out.PosWater = mul(matWaterViewProj, vWorldPos);

	
	//calculate new normal:
	float3 vNormal;
	if(wave_distance_factor > 0.0f)
	{
		float3 near_wave_heights[2];
		near_wave_heights[0].xy = vWorldPos.xy + float2(0.1f, 0.0f);
		near_wave_heights[1].xy = vWorldPos.xy + float2(0.0f, 1.0f);
		
		float pos_vector0[2] = {near_wave_heights[0].x, near_wave_heights[0].y};
		near_wave_heights[0].z = get_wave_height_temp(pos_vector0, debug_vector.z, debug_vector.x, debug_vector.y, time_var);
		float pos_vector1[2] = {near_wave_heights[1].x, near_wave_heights[1].y};
		near_wave_heights[1].z = get_wave_height_temp(pos_vector1, debug_vector.z, debug_vector.x, debug_vector.y, time_var);
		
		float3 v0 = normalize(near_wave_heights[0] - vWorldPos.xyz);
		float3 v1 = normalize(near_wave_heights[1] - vWorldPos.xyz);
		
		vNormal = cross(v0,v1);
	}
	else 
	{
		vNormal = float3(0,0,1);
	}
	
	
	float3 vWorldN = vNormal; //float3(0,0,1); //normalize(mul((float3x3)matWorld, vNormal)); //normal in world space
	float3 vWorld_tangent  = float3(1,0,0); //normalize(mul((float3x3)matWorld, vTangent)); //normal in world space
	float3 vWorld_binormal = normalize(cross(vWorld_tangent, vNormal)); //float3(0,1,0); //normalize(mul((float3x3)matWorld, vBinormal)); //normal in world space

	float3x3 TBNMatrix = float3x3(vWorld_tangent, vWorld_binormal, vWorldN); 

	float3 point_to_camera_normal = normalize(vCameraPos.xyz - vWorldPos.xyz);
	Out.CameraDir = mul(TBNMatrix, point_to_camera_normal);

	Out.Tex0 = vWorldPos.xy; //tc + texture_offset.xy;	

	Out.LightDir = 0;
	Out.LightDif = vAmbientColor;

	//directional lights, compute diffuse color
	Out.LightDir += mul(TBNMatrix, -vSunDir);
	Out.LightDif += vSunColor;
	Out.LightDir = normalize(Out.LightDir);

	//apply fog
	float3 P = mul(matWorldView, vPosition); //position in view space
	float d = length(P);
	Out.Fog = get_fog_amount_map(d, vWorldPos.z);
	
	
	//Out.PosWater.xyz = vNormal;
	
	return Out;
}
PS_OUTPUT ps_main_ocean( VS_OUTPUT_OCEAN In )
{ 
	PS_OUTPUT Output;
	
	const float texture_factor = 1.0f;
	
	float3 normal;
	normal.xy = (2.0f * tex2D(NormalTextureSampler, In.Tex0 * texture_factor).ag - 1.0f);
	normal.z = sqrt(1.0f - dot(normal.xy, normal.xy));
	
	
	static const float detail_factor = 16 * texture_factor;
	float3 detail_normal;
	detail_normal.xy = (2.0f * tex2D(NormalTextureSampler, In.Tex0 * detail_factor).ag - 1.0f);
	detail_normal.z = sqrt(1.0f - dot(normal.xy, normal.xy));
	
	float NdotL = saturate(dot(normal, In.LightDir));
	
	
	float4 tex = tex2D(ReflectionTextureSampler, 0.5f * normal.xy + float2(0.5f + 0.5f * (In.PosWater.x / In.PosWater.w), 0.5f - 0.5f * (In.PosWater.y / In.PosWater.w)));
	INPUT_OUTPUT_GAMMA(tex.rgb);
	
	Output.RGBColor = 0.01f * NdotL * In.LightDif;
	
	float3 vView = normalize(In.CameraDir);

	// Fresnel term
	float fresnel = 1-(saturate(dot(vView, normal)));
	fresnel = 0.0204f + 0.9796 * (fresnel * fresnel * fresnel * fresnel * fresnel);

	Output.RGBColor.rgb += (tex.rgb * fresnel);
	Output.RGBColor.w = 1.0f - 0.3f * In.CameraDir.z;
	
	float3 cWaterColor = 2 * float3(20.0f/255.0f, 45.0f/255.0f, 100.0f/255.0f) * vSunColor;
	//float3 cWaterColor = lerp( g_cUpWaterColor, g_cDownWaterColor,  saturate(dot(vView, normal)));
	
	float fog_fresnel_factor = saturate(dot(In.CameraDir, normal));
	fog_fresnel_factor *= fog_fresnel_factor;
	fog_fresnel_factor *= fog_fresnel_factor;
	Output.RGBColor.rgb += cWaterColor * fog_fresnel_factor;
	
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	Output.RGBColor.a = 1;
	
	
	//Output.RGBColor.rgb = dot(In.PosWater.xyz, float3(0,0,1));
	//Output.RGBColor.rgb = NdotL * vSunColor;
	
	return Output;
}
technique simple_ocean
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_main_ocean();
		PixelShader = compile ps_2_a ps_main_ocean();
	}
}
#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef NEWTREE_SHADERS


VS_OUTPUT_FLORA vs_flora_billboards(uniform const int PcfMode, 
												float4 vPosition : POSITION, 
												float3 vNormal : NORMAL, 
												float2 tc : TEXCOORD0, 
												float4 vColor : COLOR0)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_FLORA, Out);

	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	
	float3 view_vec = (vCameraPos.xyz - vWorldPos.xyz);
	float dist_to_vertex = length(view_vec);
	
	/*if(dist_to_vertex < flora_detail_clip)
	{
		//Out.Pos = float4(0,0,-1,1);	// str: we can just blend but "more vs instruction" generates less pixel to process, so faster
		Out.Color.a = 0.0f;
		//return Out;
	}*/
	
	float alpha_val = saturate(0.5f + ((dist_to_vertex - flora_detail_fade) / flora_detail_fade_inv ));
	 
	
	Out.Pos = mul(matWorldViewProj, vPosition);
	
	float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal)); //normal in world space
	

	Out.Tex0 = tc;

	float4 diffuse_light = vAmbientColor;

	//directional lights, compute diffuse color
	diffuse_light += saturate(dot(vWorldN, -vSkyLightDir)) * vSkyLightColor;

	//point lights
	diffuse_light += calculate_point_lights_diffuse(vWorldPos, vWorldN, false, false);
	
	//apply material color
	Out.Color = (vMaterialColor * vColor * diffuse_light);
	Out.Color.a *= alpha_val;

	//shadow mapping variables
	float wNdotSun = saturate(dot(vWorldN, -vSunDir));
	Out.SunLight = (wNdotSun) * vSunColor * vMaterialColor * vColor;
	if (PcfMode != PCF_NONE)
	{
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	}
	
	//apply fog
	float3 P = mul(matWorldView, vPosition); //position in view space
	float d = length(P);

	Out.Fog = get_fog_amount_new(d, vWorldPos.z);
	return Out;
}


DEFINE_TECHNIQUES(tree_billboards_flora, vs_flora_billboards, ps_flora)

VS_OUTPUT_BUMP vs_main_bump_billboards (uniform const int PcfMode, float4 vPosition : POSITION, float3 vNormal : NORMAL, float2 tc : TEXCOORD0,  float3 vTangent : TANGENT, float3 vBinormal : BINORMAL, float4 vVertexColor : COLOR0, float4 vPointLightDir : COLOR1)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_BUMP, Out);

	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	
	float3 view_vec = (vCameraPos.xyz - vWorldPos.xyz);
	float dist_to_vertex = length(view_vec);
	
	if(dist_to_vertex < flora_detail_clip)
	{
		Out.Pos = float4(0,0,-1,1);	// str: we can just blend but "more vs instruction" generates less pixel to process, so faster
		return Out;
	}
	
	float alpha_val = saturate(0.5f + ((dist_to_vertex - flora_detail_fade) / flora_detail_fade_inv ));
	 

	Out.Pos = mul(matWorldViewProj, vPosition);
	Out.Tex0 = tc;


	float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal)); //normal in world space
	float3 vWorld_binormal = normalize(mul((float3x3)matWorld, vBinormal)); //normal in world space
	float3 vWorld_tangent  = normalize(mul((float3x3)matWorld, vTangent)); //normal in world space

	float3 P = mul(matWorldView, vPosition); //position in view space

	float3x3 TBNMatrix = float3x3(vWorld_tangent, vWorld_binormal, vWorldN); 

	if (PcfMode != PCF_NONE)
	{	
		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	}

	Out.SunLightDir = mul(TBNMatrix, -vSunDir);
	Out.SkyLightDir = mul(TBNMatrix, -vSkyLightDir);
	
	#ifdef USE_LIGHTING_PASS
	Out.PointLightDir = vWorldPos;
	#else
	Out.PointLightDir.rgb = 2.0f * vPointLightDir.rgb - 1.0f;
	Out.PointLightDir.a = vPointLightDir.a;
	#endif
	
	Out.VertexColor = vVertexColor;
	Out.VertexColor.a *= alpha_val;
	
	//STR: note that these are not in TBN space.. (used for fresnel only..)
	Out.ViewDir = normalize(vCameraPos.xyz - vWorldPos.xyz); //normalize(mul(TBNMatrix, (vCameraPos.xyz - vWorldPos.xyz) ));	// 
	Out.WorldNormal = vWorldN;

	//apply fog
	float d = length(P);
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);

	return Out;
}

DEFINE_TECHNIQUES(tree_billboards_dot3_alpha, vs_main_bump_billboards, ps_main_bump_simple)


#endif

/* 	float4 Pos					: POSITION;
	float  Fog					: FOG;
	
	float4 VertexColor			: COLOR0;
	#ifdef INCLUDE_VERTEX_LIGHTING 
	float3 VertexLighting		: COLOR1;
	#endif
	
	float2 Tex0					: TEXCOORD0;
	float3 SunLightDir			: TEXCOORD1;
	float3 SkyLightDir			: TEXCOORD2;
	#ifndef USE_LIGHTING_PASS 
	float4 PointLightDir		: TEXCOORD3;
	#endif
	float4 ShadowTexCoord		: TEXCOORD4;
	float2 ShadowTexelPos		: TEXCOORD5;
	float3 ViewDir				: TEXCOORD6; */

struct VS_OUTPUT_FATE_ANIME_SHADER
{
	float4 Pos           : POSITION;
	//float2 Tex0        	 : TEXCOORD0;
	float4 Color         : COLOR0;
	//float3 vBinormal : BINORMAL;
	//float4 vBlendWeights : BLENDWEIGHT;
	//float4 vBlendIndices : BLENDINDICES;
	
	float  Fog           : FOG;
};
VS_OUTPUT_FATE_ANIME_SHADER vs_fate_anime_shader_outline(float4 vPosition : POSITION, float4 vNormal : NORMAL, float4 vColor : COLOR, float2 tc : TEXCOORD0, float4 vBlendWeights : BLENDWEIGHT, float4 vBlendIndices : BLENDINDICES)
{
	VS_OUTPUT_FATE_ANIME_SHADER Out;

	// float2 offset = TransformViewToProjection(norm.xy);
	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal)); //normal in world space
	
	
	// vPosition.xyz = vNormal * 0.02;
	vPosition.xyz += vNormal * 0.01;
	//vPosition.w -= 0.1;
	float4 vObjectPos = skinning_deform(vPosition, vBlendWeights, vBlendIndices);
	vPosition = mul(matWorldViewProj, vObjectPos);
	// vPosition *= -1;
	//Out.Pos = mul(matWorldViewProj, vPosition);
	Out.Pos = vPosition;
	
	Out.Color = float4(0, 0, 0, 1);
	
	//Out.Tex0 = tc;
	float3 P = mul(matWorldView, vPosition); //position in view space
	//apply fog
	float d = length(P);
	
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);

	return Out;
}
struct VS_OUTPUT_FATE_ANIME_SHADER2
{
	float4 Pos           : POSITION;
	float2 Tex0        	 : TEXCOORD0;
	float4 Color         : COLOR0;
	
	float4 LocalPosition	: TEXCOORD2;
	float4 ScreenSpace		: TEXCOORD3;
	float4 ShadowTexCoord		: TEXCOORD4;
	float4 WorldPosition		: TEXCOORD5;	
	float3 ViewDir				: TEXCOORD6;
	float3 WorldNormal			: TEXCOORD7;
	// float4 PointLight			: TEXCOORD1;
	
	
	float  Fog           : FOG;
};

VS_OUTPUT_FATE_ANIME_SHADER2 vs_fate_anime_shader_color(float4 vPosition : POSITION, float4 vNormal : NORMAL, float4 vColor : COLOR, float2 tc : TEXCOORD0, float4 vBlendWeights : BLENDWEIGHT, float4 vBlendIndices : BLENDINDICES, float3 vTangent : TANGENT)
{
	VS_OUTPUT_FATE_ANIME_SHADER2 Out;
	
	//------------- This code belongs to MTarini from TLD shader vs_specular_alpha_skin
	float4 vObjectPos = mul(matWorldArray[vBlendIndices.x], vPosition) * vBlendWeights.x
                      + mul(matWorldArray[vBlendIndices.y], vPosition) * vBlendWeights.y
                      + mul(matWorldArray[vBlendIndices.z], vPosition) * vBlendWeights.z
                      + mul(matWorldArray[vBlendIndices.w], vPosition) * vBlendWeights.w;
	float3 vObjectN = normalize(mul((float3x3)matWorldArray[vBlendIndices.x], vNormal) * vBlendWeights.x
							  + mul((float3x3)matWorldArray[vBlendIndices.y], vNormal) * vBlendWeights.y
							  + mul((float3x3)matWorldArray[vBlendIndices.z], vNormal) * vBlendWeights.z
							  + mul((float3x3)matWorldArray[vBlendIndices.w], vNormal) * vBlendWeights.w);
	
	float4 vWorldPos = mul(matWorld,vObjectPos);
	Out.Pos = mul(matViewProj, vWorldPos);
	float3 vWorldN = normalize(mul((float3x3)matWorld, vObjectN));
	//-------------
	
	Out.Tex0 = tc;
	
	Out.WorldPosition = vWorldPos;
	Out.LocalPosition = vObjectPos;
	
	Out.ScreenSpace.xy = (float2(Out.Pos.x, -Out.Pos.y) + Out.Pos.w)/2;
	Out.ScreenSpace.xy += (vDepthRT_HalfPixel_ViewportSizeInv.xy * Out.Pos.w);
	Out.ScreenSpace.zw = Out.Pos.zw;
	
	Out.ScreenSpace.xyz = (mul(matWorldView, normalize(vObjectN)));
	//Out.ScreenSpace.xyz = normalize(mul((float3x3)transpose(matWorld), vObjectN));
	
	float4 diffuse_light;

	//directional lights, compute diffuse color
	//diffuse_light += (dot(vWorldN, -vSkyLightDir) * vSkyLightColor);
	//diffuse_light += saturate((dot(vWorldN, -vSunDir*0.5) * vSunColor));

	//point lights
	diffuse_light = calculate_point_lights_diffuse(vWorldPos, vWorldN, true, false);
	// Out.PointLight = diffuse_light;
	//diffuse_light = smoothstep(0.7,0.85,diffuse_light);
	
	
	//apply material color
	// Out.Color = (vMaterialColor * vColor ) * (diffuse_light);
	// Out.Color = vColor + saturate(diffuse_light); // > 0.5 ? float4(1,1,1,1):float4(0,0,0,1);
	
	//float4 ambient =  + ((vSkyLightColor) * isLit);
	//float4 ambient = vAmbientColor + vGroundAmbientColor + ((vSkyLightColor) * isLit);
	
	
	//Out.Color *= vMaterialColor;
	// Out.Color.rgb = 1.0;
	// * sin(tc.y * 20 *  time_var); // Cool time fade effect
	
	float3 P = mul(matWorldView, vPosition); //position in view space
	//apply fog
	float d = length(P);
	
	float4 ShadowPos = mul(matSunViewProj, vWorldPos);
	Out.ShadowTexCoord = ShadowPos;
	Out.ShadowTexCoord.z /= ShadowPos.w;
	Out.ShadowTexCoord.w = 1.0f;
	//Out.ShadowTexCoord =
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);
	Out.WorldNormal = vWorldN;
	Out.ViewDir = (vCameraPos - vWorldPos);
	
	//uniform const int PcfMode, 
	// Out.ViewDir = normalize(vCameraPos.xyz - vWorldPos.xyz);
	
	diffuse_light += vAmbientColor + vSkyLightColor;
	Out.Color = vMaterialColor * vColor;
	Out.Color.a = 1.0f;
	
	//vColor.rgb = darkenBlood(vColor.rgb);
	
	//Out.Color = vColor;
	return Out;
}

VertexShader vs_fate_anime_shader_color_compiled = compile vs_2_a vs_fate_anime_shader_color();

PS_OUTPUT ps_fate_anime_shader_color(VS_OUTPUT_FATE_ANIME_SHADER2 In, uniform const bool use_specularmap, uniform const bool use_bumpmap, uniform const bool use_emissionmap) 
{ 
	PS_OUTPUT Output;
   
    // Register Texture Maps and Uniforms
    float4 color = tex2D(MeshTextureSampler, In.Tex0);		// Register Diffuse Texture
	float4 reflection = tex2D(ReflectionTextureSampler, In.Tex0);
	float sun_amount = tex2Dproj(ShadowmapTextureSampler, In.ShadowTexCoord).r;    // Suniness
	float3 viewDir = normalize(In.ViewDir);
	
	float3 normal;
	if(use_bumpmap)
		normal = normalize(lerp((2.0f * tex2D(NormalTextureSampler, In.Tex0) - 1.0f), In.WorldNormal, 0.80));
	else
		normal = normalize(In.WorldNormal);
	
	float fresnel = 1-(saturate(dot(viewDir, normal)));

    float NdotL = dot(-vSunDir, normal); // Normal dot Lighting Direction
	float NdotS = dot(float3(0,0,1), normal); // Normal dot Sky Direction
	float NdotG = dot(float3(0,0,-1), normal); // Normal dot Ground Direction
    float3 halfVector = normalize(-vSunDir + viewDir);
	float3 skyHalfVector = normalize(float3(0,0,1) + viewDir);
    float NdotH = dot(normal, halfVector); // Normal dot Half Vector
	float SdotH = dot(float3(0,0,1), skyHalfVector);
	/*
	From Native envmap shader
	float3 relative_cam_pos = normalize(vCameraPos - vWorldPos);
	float2 envpos;
	float3 tempvec = relative_cam_pos - vWorldN;

	envpos.x = (tempvec.y);// + tempvec.x);
	envpos.y = tempvec.z;
	envpos += 1.0f;
	//   envpos *= 0.5f;

	Out.Tex0.zw = envpos;
	*/
	/*
	float2 reflectionUV;	// below kind of works, stretches along the depth though
	reflectionUV.x = (viewDir.x - normal.x) / 2 + 0.5;
	reflectionUV.y = (viewDir.z - normal.z) / 2 + 0.5;
	*/

	float3 reflectionUV	= (reflect(viewDir, normal) + 1) / 2;
	
	float4 env = tex2D(ReflectionTextureSampler, reflectionUV.xz);
	
	NdotS = (NdotS > 0) ? NdotS : 0; 
	SdotH = (SdotH > 0) ? SdotH : 0; 
	
    float4 emission;										// Register Emission Value
	if(use_emissionmap)
		{
		emission = tex2D(Diffuse2Sampler, In.Tex0);			// If using Emission map, load Diffuse2 as that map
		emission *=  abs(sin(-2 * In.LocalPosition.y + time_var));	// This varies the power of emission based on the y-axis of the model (local)
		}
   
    float4 specular;										// Register Specular Value
	float specStrength = lerp(fMaterialPower, fMaterialPower / 10, fRainSpecular);

    if(use_specularmap)
        specular = tex2D(SpecularTextureSampler, In.Tex0);	// If this shader uses Specular Maps, load it
    else
	{
        specular = float4(0.1,0.1,0.1,1);				// else set up a basic light specular
		specStrength *= 3;								// But tighten the reflections
	}
	
	/*
	These are loaded inside OpenBRF
	vMaterialColor
	vMaterialColor2
	fMaterialPower		// Used to determine the strength of the specular fSpecular = specColor * pow( saturate(dot(vHalf, normal)), fMaterialPower) * sun_amount;
	vSpecularColor 		// Since Native uses b/w speculars, this allows tinting
	*/
   
    //float4 shadow = smoothstep(0.75,0.76, dot(vSunDir, normal)) * vAmbientColor; // Basically makes a antisun to make a shadow
    float4 isLit = NdotL * sun_amount;
	//isLit = anime_smoothstep(isLit);

    isLit = isLit.r > 0.5 ? float4(1,1,1,1): float4(0,0,0,1); // If under 50% shade, make it completely shaded
	float4 sunLight = vSunColor * isLit;
	float4 skyLight = vSkyLightColor * NdotS;
	
	fresnel = smoothstep(0.85, 0.87, fresnel); 
	
	//specular *= (smoothstep(0.90, 0.92, pow((NdotH * NdotL), specStrength)) * sunLight + (pow(SdotH * NdotS, specStrength) * vSkyLightColor)); //	
	specular *= smoothstep(0.5, 0.75, pow((NdotH * NdotL), specStrength)) * sunLight + smoothstep(0.75, 0.85, (pow(SdotH * NdotS, specStrength)) * skyLight); //	
   
     

    //float sunIntensity = smoothstep(0.02, 0.05, NdotL); //Actual
	// float sunIntensity = smoothstep(0.5, 0.55, NdotL); // Test

	float4 ambient = (vAmbientColor + ((vSkyLightColor) * isLit));
    float4 light = saturate(/*(vSkyLightColor * isLit) +*/ (/*sunIntensity * */sunLight + skyLight));
	
	if(bNightVision == 1)
		light.rgb += flashlight(length(mul(matView, In.WorldPosition)), In.ViewDir, normal);
	
	// light.rgb += calculate_spot_lights_diffuse(In.WorldPosition, normal);
	
	
	// if(bNightVision == 1)	// Night Vision Test
	// {
	// light.rgb += lerp(float3(0,0,0), float3(0.25, 0.25, 0.25), smoothstep(0.55, 0.89, (saturate(dot(In.ViewDir.xyz, normal.xyz))))); // Take the dot from camera view to the normal of the object being rendered. The more flat on, the more illumination
	// }

	Output.RGBColor = color * In.Color;
    Output.RGBColor.rgb *= ambient + light + (fresnel * sunLight);
	Output.RGBColor.rgb += specular * env;
	
	//Output.RGBColor = ambient + light;
	
	Output.RGBColor = saturate(Output.RGBColor);

	if(use_emissionmap)
	{
	//OUTPUT_GAMMA(Output.RGBColor.rgb);
	/*float luminosity = (vSunColor.r * 0.299f + vSunColor.g * 0.587f + vSunColor.b * 0.114f);
	luminosity *= -1;
	luminosity += 5;*/
	Output.RGBColor.rgb += /*luminosity **/ emission * emission.a;	
	}
	
	//Output.RGBColor.rgb = env;
	
    return Output;
}

PS_OUTPUT ps_fate_anime_matcap(VS_OUTPUT_FATE_ANIME_SHADER2 In, uniform const bool use_bumpmap) 
{ 
	PS_OUTPUT Output;
   
    // Register Texture Maps and Uniforms
    
	/*
	float sun_amount = tex2Dproj(ShadowmapTextureSampler, In.ShadowTexCoord).r;    // Suniness
	float3 viewDir = normalize(In.ViewDir);
	
	float3 normal;
	if(use_bumpmap)
		normal = normalize(lerp((2.0f * tex2D(NormalTextureSampler, In.Tex0) - 1.0f), In.WorldNormal, 0.80));
	else
		normal = normalize(In.WorldNormal);
	
	//normal = In.ScreenSpace;
	
	
	//float3 reflectionUV	= (reflect(viewDir, normal));
	//float3 reflectionUV	= In.ScreenSpace;
	float3 reflectionUV	= (In.ScreenSpace + 1) / 2;
	reflectionUV.y = 1 - reflectionUV.y;
	//float3 reflectionUV	= (reflect(viewDir, In.ScreenSpace) + 1) / 2;
	
	*/
	
	//float3 reflectionUV	= (reflect(normalize(In.ViewDir), normalize(In.WorldNormal)) + 1) / 2;
	//float2 reflectionUV	= mul(matView, normalize(In.WorldNormal)).xy * 0.5 + 0.5;
	//reflectionUV.y *= -1;
	
	float3 viewPos = mul(matView, In.WorldPosition);
	float3 viewDir = normalize(viewPos);
	
	float3 viewCross = cross(viewDir, mul(matView, normalize(In.WorldNormal)));
	
	float2 reflectionUV = float2(-viewCross.y, viewCross.x);
	reflectionUV = reflectionUV * 0.5 + 0.5;
	reflectionUV.y *= -1;
	
	float4 color = tex2D(MeshTextureSampler, reflectionUV);		// Register Diffuse Texture
	//float4 color = tex2D(MeshTextureSampler, reflectionUV.xz);		// Register Diffuse Texture
	
	//
	//float fresnel = 1-(saturate(dot(viewDir, normal)));
	//
    //float NdotL = dot(-vSunDir, normal); // Normal dot Lighting Direction
	//
    //float4 isLit = smoothstep(0.15, 0.50, NdotL * sun_amount);
	//
    ////isLit = isLit.r > 0.5 ? float4(1,1,1,1): float4(0,0,0,1); // If under 50% shade, make it completely shaded
	//float4 sunLight = vSunColor * isLit;
	//
	//fresnel = smoothstep(0.85, 0.87, fresnel); 
	//
	//float4 ambient = (vAmbientColor + ((vSkyLightColor) * isLit));
    //float4 light = saturate(/*(vSkyLightColor * isLit) +*/ (/*sunIntensity * */sunLight));
	

	//Output.RGBColor = color * In.Color;
	Output.RGBColor = color;
    //Output.RGBColor.rgb *= ambient + light + (fresnel * sunLight);
	
	//Output.RGBColor.rgb = reflectionUV;
	
    return Output;
}

PS_OUTPUT ps_fate_anime_enviroment_preview(VS_OUTPUT_FATE_ANIME_SHADER2 In) 
{ 
	PS_OUTPUT Output;
	
	//float3 viewCross = cross(In.ViewDir, In.WorldNormal);
	//float3 viewNorm = float3(-viewCross.y, viewCross.x, 0.0);
   
	// float3 reflectionUV	= (reflect(normalize(In.ViewDir), normalize(In.WorldNormal)) + 1) / 2;
	float3 reflectionUV	= reflect(normalize(In.ViewDir), normalize(In.WorldNormal)) * 0.5 + 0.5;
	//float3 reflectionUV	= (reflect(normalize(viewNorm), normalize(In.WorldNormal)) + 1) / 2;
	
	float4 color = tex2D(ReflectionTextureSampler, reflectionUV.xz);
	//float4 color = tex2D(ReflectionTextureSampler, reflectionUV);
	
	Output.RGBColor = color;
	
    return Output;
}

PS_OUTPUT ps_fate_shader_dots(VS_OUTPUT_FATE_ANIME_SHADER2 In) 
{ 
	PS_OUTPUT Output;
   
    // Register Texture Maps and Uniforms
    float4 color = tex2D(DiffuseTextureSamplerNoWrap, In.Tex0);
	float4 shading = tex2D(Diffuse2Sampler, In.ScreenSpace.xy/* * 2.0f*/);
    float4 specular = tex2D(SpecularTextureSampler, In.Tex0);
    float sun_amount = tex2Dproj(ShadowmapTextureSampler, In.ShadowTexCoord).r;
	
    
	float3 normal = normalize(In.WorldNormal);
	
    float3 viewDir = In.ViewDir;
    
    float NdotL = dot(-vSunDir, normal); // Normal dot Lighting Direction
    float3 halfVector = normalize(-vSunDir + viewDir);
    float NdotH = dot(normal, halfVector); // Normal dot Half Vector    
   
    float4 shadow = smoothstep(0.75,0.76, dot(vSunDir, normal)) * vAmbientColor; // Basically makes a antisun to make a shadow
    float4 isLit = NdotL * sun_amount;

    isLit = isLit.r > 0.5 ? float4(1,1,1,1): float4(0,0,0,1); // If under 50% shade, make it completely shaded
	float4 sunLight = vSunColor * isLit;

	specular = specular * pow((NdotH * NdotL), fMaterialPower);

    //float sunIntensity = smoothstep(0.02, 0.05, NdotL);

	float4 ambient = (vAmbientColor + vGroundAmbientColor + ((vSkyLightColor) * isLit));
    float4 light = saturate((vSkyLightColor * isLit) + (NdotL * sunLight));
   
    light += ambient;
   
    light.rgb -= shadow;
	
	float4 black = float4(0,0,0,1);

    Output.RGBColor = color;
    Output.RGBColor *= ambient + light;
	Output.RGBColor += (specular * sunLight * tex2D(SpecularTextureSampler, In.Tex0));	
	
	float luminosity = (Output.RGBColor.r * 0.299f + Output.RGBColor.g * 0.587f + Output.RGBColor.b * 0.114f);
	
	Output.RGBColor = color;
	
	if (luminosity < 0.15)
		Output.RGBColor.rgb *= (shading.b * shading.g);
	
	if (luminosity < 0.2 && luminosity > 0.15)
		Output.RGBColor.rgb *= shading.r;
	
	if (luminosity < 0.5 && luminosity > 0.2)
		Output.RGBColor.rgb *= shading.g;
	
	Output.RGBColor += (specular * sunLight * tex2D(SpecularTextureSampler, In.Tex0));	
	
    return Output;
}

PS_OUTPUT ps_fate_shader_camo(VS_OUTPUT_FATE_ANIME_SHADER2 In) 
{ 
	PS_OUTPUT Output;
   
	In.ScreenSpace.xy /= In.ScreenSpace.w;
    // Register Texture Maps and Uniforms
    float4 shading = tex2D(ScreenTextureSampler, In.ScreenSpace.xy);
	float3 normal = normalize(In.WorldNormal);
	
    float3 viewDir = In.ViewDir;
	float fresnel = 1-(saturate(dot(viewDir, normal)));
	
    Output.RGBColor = shading;
	Output.RGBColor.a = clamp(fresnel - abs(sin(In.WorldPosition.z - time_var * 2)), 0.05, 1);
	
    return Output;
}

PS_OUTPUT ps_fate_anime_shader_skin(VS_OUTPUT_FATE_ANIME_SHADER2 In) 
{ 
	PS_OUTPUT Output;
   
    // Register Texture Maps and Uniforms
    float4 main = tex2D(DiffuseTextureSamplerNoWrap, In.Tex0);
	float4 main_aged = tex2D(Diffuse2Sampler, In.Tex0);
	float4 specular = tex2D(SpecularTextureSampler, In.Tex0);
	float3 normal = normalize(lerp((2.0f * tex2D(NormalTextureSampler, In.Tex0) - 1.0f), In.WorldNormal, 0.55));
	//float3 normal = In.WorldNormal;
	
	float4 color;
	
	color.rgb = lerp(main.rgb, main_aged.rgb, In.Color.a);
	color.a = 1.0f;
	
	
    float sun_amount = tex2Dproj(ShadowmapTextureSampler, In.ShadowTexCoord).r;
	
    float3 viewDir = In.ViewDir;
    float fresnel = 1-(saturate(dot(viewDir, In.WorldNormal)));

    float NdotL = dot(-vSunDir, normal); // Normal dot Lighting Direction
    float3 halfVector = normalize(-vSunDir + viewDir);
    float NdotH = dot(normal, halfVector); // Normal dot Half Vector    
   
    float4 shadow = smoothstep(0.75,0.76, dot(vSunDir, normal)) * vAmbientColor; // Basically makes a antisun to make a shadow
    float4 isLit = NdotL * sun_amount;

    isLit = isLit.r > 0.5 ? float4(1,1,1,1): float4(0,0,0,1); // If under 50% shade, make it completely shaded
	float4 sunLight = vSunColor * isLit;

    //specular = specular * pow(abs(NdotH) * smoothstep(0.75, 0.78, abs(NdotL)), fMaterialPower);
	specular = specular * pow((NdotH * NdotL), fMaterialPower);
	
    float specularIntensitySmooth;
    specularIntensitySmooth = smoothstep(0.85, 0.86, specular);
    specular *= specularIntensitySmooth;
	   
    fresnel = smoothstep(0.85, 0.87, fresnel);  

    float sunIntensity = smoothstep(0.02, 0.05, NdotL);

	float4 ambient = vAmbientColor + vGroundAmbientColor + ((vSkyLightColor) * isLit);
    float4 light = saturate(ambient + (sunIntensity * sunLight));
	
	if(bNightVision == 1)
		light.rgb += flashlight(length(mul(matView, In.WorldPosition)), In.ViewDir, normal);
   
    light.rgb -= shadow * 0.25;

    Output.RGBColor = color;
    Output.RGBColor *= light + (fresnel * sunLight * 0.5f);
	Output.RGBColor += (specular * sunLight * tex2D(SpecularTextureSampler, In.Tex0));
	
    return Output;
}

technique fate_anime_shader
{
	pass P0
	{
		VertexShader = vs_fate_anime_shader_color_compiled;
		PixelShader = compile ps_2_a ps_fate_anime_shader_color(false,false,false);
	}
}

technique fate_anime_shader_emission
{
	pass P0
	{
		VertexShader = vs_fate_anime_shader_color_compiled;
		PixelShader = compile ps_2_a ps_fate_anime_shader_color(false,false,true);
	}
}

technique fate_dot_shader
{
	pass P0
	{
		VertexShader = vs_fate_anime_shader_color_compiled;
		PixelShader = compile ps_2_a ps_fate_shader_dots();
	}
}

technique fate_camo_shader
{
	pass P0
	{
		VertexShader = vs_fate_anime_shader_color_compiled;
		PixelShader = compile ps_2_a ps_fate_shader_camo();
	}
}

technique fate_matcap
{
	pass P0
	{
		VertexShader = vs_fate_anime_shader_color_compiled;
		PixelShader = compile ps_2_a ps_fate_anime_matcap(false);
	}
}

technique fate_envmap_preview
{
	pass P0
	{
		VertexShader = vs_fate_anime_shader_color_compiled;
		PixelShader = compile ps_2_a ps_fate_anime_enviroment_preview();
	}
}

technique fate_matcap_bump
{
	pass P0
	{
		VertexShader = vs_fate_anime_shader_color_compiled;
		PixelShader = compile ps_2_a ps_fate_anime_matcap(true);
	}
}


technique fate_anime_shader_skin
{
	pass P0
	{
		VertexShader = vs_fate_anime_shader_color_compiled;
		PixelShader = compile ps_2_a ps_fate_anime_shader_skin();
		//PixelShader = compile ps_2_a ps_fate_anime_shader_color(false,true,false);
	}
}

technique fate_anime_shader_spec_nobump
{
	pass P0
	{
		VertexShader = vs_fate_anime_shader_color_compiled;
		PixelShader = compile ps_2_a ps_fate_anime_shader_color(true,false,false);
		
	}
}
technique fate_anime_shader_spec_bump
{
	pass P0
	{
		VertexShader = vs_fate_anime_shader_color_compiled;
		PixelShader = compile ps_2_a ps_fate_anime_shader_color(true,true,false);
		
	}
}
technique fate_anime_shader_nospec_bump
{
	pass P0
	{
		VertexShader = vs_fate_anime_shader_color_compiled;
		PixelShader = compile ps_2_a ps_fate_anime_shader_color(false,true,false);
		
	}
}
technique fate_anime_shader_outline
{
	pass P0
	{
		CullMode = none;
		VertexShader = compile vs_2_0 vs_fate_anime_shader_outline();
		PixelShader = NULL;
		
	}
}

struct VS_OUTPUT_TICKER
{
	float4 Pos           : POSITION;	// Vertex Position, Local to Mesh
	float3 Tex0        	 : TEXCOORD0;	// Texture Coordinates form Mesh
	float4 Color         : COLOR0;		// Vertex Coloring
	
	
	float3 ViewDir		 : TEXCOORD6;
	float  Fog           : FOG;			// Pixel Shader Fog
};

VS_OUTPUT_TICKER vs_news_ticker(float4 vPosition : POSITION, float4 vColor : COLOR, float2 tc : TEXCOORD0, float3 vNormal : NORMAL, float3 vBinormal : BINORMAL, float3 vTangent : TANGENT)
{
	VS_OUTPUT_TICKER Out;							// Out is just naming the Output Varaibles
	
	float4 vWorldPos = mul(matWorld, vPosition);	// vPosition in World Space, Used for Fog.
	
	Out.Tex0.xy = tc;									// Texture Coords passed straight through
	
	
	Out.Pos = mul(matWorldViewProj, vPosition);		// vPosition in Projected World View (World Space in Camera)
	
	Out.ViewDir = normalize(vCameraPos-vWorldPos);
	
	// Native Fog Calculation //
	float3 P = mul(matWorldView, vPosition); 		// vPosition in view space
	float d = length(P);							// Distance from Camera
	Out.Tex0.z = P.z;									// Store this inside the texture coords
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);	// Pass to a function to determine fog amount

	Out.Color = vColor;								// Vertex Color passed straight through
	
	
	
	float3 vWorldN = normalize(mul((float3x3)matWorld, vNormal)); //normal in world space
	float3 vWorld_binormal = normalize(mul((float3x3)matWorld, vBinormal)); //normal in world space
	float3 vWorld_tangent  = normalize(mul((float3x3)matWorld, vTangent)); //normal in world space

	float3x3 TBNMatrix = float3x3(vWorld_tangent, vWorld_binormal, vWorldN); 

	Out.ViewDir = mul(TBNMatrix, Out.ViewDir);
	
	
	return Out;										// Output the VS Structure
}

PS_OUTPUT ps_news_ticker(VS_OUTPUT_TICKER In) 
{ 
	PS_OUTPUT Output;		// Name outputted variables Output.yaddayadda

    // Register Texture Maps and Uniforms
    float4 color = tex2D(MeshTextureSampler, In.Tex0);	// Using MeshTextureSampler is absolutely necessary to allow scrolling. The more common DiffuseTextureSamplerNoWrap, limits the texture within 0 - 1.0 UV space.
	// We load a static texture here mostly to get the blue channels offset for the scroll.

	// Our scroll offsets
	//float vertical_scroll = 0.05f * time_var;	
	//float horizontal_scroll = 0.1f * time_var;
	
	float vertical_scroll = 0.05f * time_var + color.b * 0.01f;	
	float horizontal_scroll = 0.1f * time_var + color.b * 0.01f;
	
	// The use of color.b will add a very small jump in Texture Coordinates based on the Blue Channel of the texture
	// Adds a cool glitched look. Really, it's unnecessary, but I wanted to show how we can use channels to convey nontexture data like dead or misaligned pixels in a display.
	// Without color.b you can move this to the VS and save marginal computational time (Per Vertex vs Per Pixel).

	float4 y_displaced = tex2D(MeshTextureSampler, float2(In.Tex0.x, In.Tex0.y + vertical_scroll));	
	float4 x_displaced = tex2D(MeshTextureSampler, float2(In.Tex0.x + horizontal_scroll, In.Tex0.y + (y_displaced.b * 0.01f)));
	// By scrolling the textures seperately we can have vertical scrolling effects that don't scroll horizontally
	// As well as the inverse. Basically keeps the displayed texture from scrolling at a angle

	x_displaced.r = max(0.05f, x_displaced.r); 
	// the max() function makes sure the screen at leasts has a very small backing.
	// So the screen is still displayed even if the red channel doesn't have data.
	// You can actually do a reverse affect with throw out data under a certain value
	// with something like
	// x_displaced.r = x_displaced.r > 0.5 ? x_displaced.r : 0;
	// Read this as if red > half, keep red, if not, make = 0;
	
	float4 diffuse_color = (x_displaced.r + y_displaced.g) * In.Color;
	// We're adding the horizontal red (Text) and the vertical green (Scanlines), then multiplying them by vColor
	
	diffuse_color.a = x_displaced.r + y_displaced.g;
	// Make sure the channels used in the diffuse are visible
	diffuse_color.a -= smoothstep( 0.96, 0.99, sin(25 * In.Tex0.y - (10 * time_var)));
	// Subtract a downward scrolling narrow band of scanlines
	// smoothstep makes anything less than the first value 0, and thing more than the last value 1
	// and everything between a smooth gradient between 0 and 1.
	// Multiplying the y-coordinate from the UV will make more scan lines appear per UV sheet, 25 here
	// Multiplying time makes it move much faster
	diffuse_color.a -= sin(2 * In.Tex0.y + (3 * time_var)) * 0.25f;
	// Now we subtract 2 larger, slower gradients moving upward to add a slower strobe style effect
	diffuse_color.a = max(0.15f, diffuse_color.a);
	// And make sure everything is always AT LEAST 15% opaque
	diffuse_color.a = min(0.80f, diffuse_color.a);
	// But never more than 80%

	float4 darkened = diffuse_color * 0.15f;
	float4 brightened = diffuse_color * (1.0f + max(2 * sin(In.Tex0.y + time_var) * 0.25f, 0));

    Output.RGBColor = brightened;	// Output the PS Structure
	
	INPUT_OUTPUT_GAMMA(brightened.rgb);
	OUTPUT_GAMMA(diffuse_color.rgb);
    return Output;
}

PS_OUTPUT ps_jumbotron(VS_OUTPUT_TICKER In) 
{ 
	PS_OUTPUT Output;		// Name outputted variables Output.yaddayadda

    // Register Texture Maps and Uniforms
    float4 color = tex2D(ScreenTextureSampler, In.Tex0);
	
	Output.RGBColor = color;
    return Output;
}

technique news_ticker	// Name the shader technique
{
	pass P0	// In the first pass (only one available in our engine :cry:)
	{
		VertexShader = compile vs_2_0 vs_news_ticker();	// Our Vertex Shader, compiled using vs_2_0 with no constants
		PixelShader = compile ps_2_a ps_news_ticker(); // Our Pixel Shader, compiled using ps_2_a with no constants
		
	}
}

technique jumbotron	// Name the shader technique
{
	pass P0	// In the first pass (only one available in our engine :cry:)
	{
		VertexShader = compile vs_2_0 vs_news_ticker();	// Our Vertex Shader, compiled using vs_2_0 with no constants
		PixelShader = compile ps_2_a ps_jumbotron(); // Our Pixel Shader, compiled using ps_2_a with no constants
		
	}
}

struct VS_OUTPUT_PLAYSTATION
{
	float4 Pos           : POSITION;	// Vertex Position, Local to Mesh
	float2 Tex0        	 : TEXCOORD0;	// Texture Coordinates from Mesh
	float4 Color         : COLOR0;		// Vertex Coloring
	
	float  Fog           : FOG;			// Pixel Shader Fog
	
	float4 ShadowTexCoord		: TEXCOORD2;
	//float2 ShadowTexelPos		: TEXCOORD3;
	
	//float3 SunLightDir			: TEXCOORD6;
	//float3 SkyLightDir			: TEXCOORD5;
	// Add Sunlight Color
	
	float3 ViewDir				: TEXCOORD6;
	float3 WorldNormal			: TEXCOORD7;
};

VS_OUTPUT_PLAYSTATION vs_playstation(float4 vPosition : POSITION, float4 vColor : COLOR, float2 tc : TEXCOORD0, float4 vNormal : NORMAL)
{
	VS_OUTPUT_PLAYSTATION Out;							// Out is just naming the Output Varaibles
	
	float4 vWorldPos = mul(matWorld, vPosition);	// vPosition in World Space, Used for Fog.
	
	Out.Pos = playstationify(vPosition);			// Magic
	
	Out.Tex0 = tc;									// Texture Coords passed straight through
	
	//Out.Pos = mul(matWorldViewProj, vPosition);		// vPosition in Projected World View (World Space in Camera)
	
	float3 vObjectN = vNormal;
	float3 vWorldN = normalize(mul((float3x3)matWorld, vObjectN));
	
	float NdotL = dot(-vSunDir, vWorldN);
	
	//diffuse_light += (dot(vWorldN, -vSkyLightDir) * vSkyLightColor);
	//diffuse_light += saturate((dot(vWorldN, -vSunDir*0.5) * vSunColor));

	//point lights
	float4 diffuse_light = calculate_point_lights_diffuse(vWorldPos, vWorldN, true, false);
	diffuse_light += (dot(vWorldN, -vSkyLightDir) * vSkyLightColor);
	//diffuse_light += saturate((dot(vWorldN, -vSunDir*0.5) * vSunColor));
	
	float4 Lighting = diffuse_light + vAmbientColor + vSunColor * NdotL;
	
	
	// Native Fog Calculation //
	float3 P = mul(matWorldView, vPosition); 		// vPosition in view space
	float d = length(P);							// Distance from Camera
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);	// Pass to a function to determine fog amount
	
	float4 ShadowPos = mul(matSunViewProj, vWorldPos);
	Out.ShadowTexCoord = ShadowPos;
	Out.ShadowTexCoord.z /= ShadowPos.w;
	Out.ShadowTexCoord.w = 1.0f;
	//Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
	Out.WorldNormal = vWorldN;
	Out.ViewDir = normalize(vCameraPos-vWorldPos);

	if(bNightVision == 1)
		Lighting.rgb += flashlight(d, Out.ViewDir, vWorldN);

	Out.Color = vColor * Lighting;								// Vertex Color * Vertex Lighting
	//Out.Color.rgb = floor(Out.Color.rgb * 5)/5;
	return Out;										// Output the VS Structure
}

PS_OUTPUT ps_playstation(VS_OUTPUT_PLAYSTATION In) 
{ 
	PS_OUTPUT Output;		// Name outputted variables Output.yaddayadda

    // Register Texture Maps and Uniforms
    float4 diffuse_color = tex2D(MeshTextureSampler, In.Tex0);	// Using MeshTextureSampler is absolutely necessary to allow scrolling. The more common DiffuseTextureSamplerNoWrap, limits the texture within 0 - 1.0 UV space.
	
	float3 normal = In.WorldNormal;
	float sun_amount = tex2Dproj(ShadowmapTextureSampler, In.ShadowTexCoord).r;

	Output.RGBColor = diffuse_color * ((In.Color * sun_amount) + vAmbientColor);
    //Output.RGBColor *= light + (fresnel * sunLight * 0.5f);
    return Output;
}

technique playstation	// Name the shader technique
{
	pass P0	// In the first pass (only one available in our engine :cry:)
	{
		VertexShader = compile vs_2_0 vs_playstation();	// Our Vertex Shader, compiled using vs_2_0 with no constants
		PixelShader = compile ps_2_a ps_playstation(); // Our Pixel Shader, compiled using ps_2_a with no constants
		
	}
}

struct VS_INPUT_FATE_HAIR
{
	float4 vPosition : POSITION;
	float3 vNormal : NORMAL;
	float3 vTangent : BINORMAL;
	
	float2 tc : TEXCOORD0;
	float4 vColor : COLOR0;
};
struct VS_OUTPUT_FATE_HAIR
{
	float4 Pos					: POSITION;
	float2 Tex0					: TEXCOORD0;
	
	float4 VertexLighting		: TEXCOORD1;
	
	float3 viewVec				: TEXCOORD2;
	float3 normal				: TEXCOORD3;
	float3 tangent				: TEXCOORD4;
	float4 VertexColor			: COLOR0;
	
	
	float4 ShadowTexCoord		: TEXCOORD6;
	float2 ShadowTexelPos		: TEXCOORD7;
	float  Fog				    : FOG;
};

VS_OUTPUT_FATE_HAIR vs_fate_hair_aniso (VS_INPUT_FATE_HAIR In)
{
	INITIALIZE_OUTPUT(VS_OUTPUT_HAIR, Out);

	Out.Pos = mul(matWorldViewProj, In.vPosition);

	float4 vWorldPos = (float4)mul(matWorld,In.vPosition);
	float3 vWorldN = normalize(mul((float3x3)matWorld, In.vNormal)); //normal in world space

	float3 P = mul(matWorldView, In.vPosition); //position in view space

	Out.Tex0 = In.tc;

	float4 diffuse_light = vAmbientColor;
	//   diffuse_light.rgb *= gradient_factor * (gradient_offset + vWorldN.z);

	//directional lights, compute diffuse color
	diffuse_light += saturate(dot(vWorldN, -vSkyLightDir)) * vSkyLightColor;

	//point lights
	#ifndef USE_LIGHTING_PASS
	diffuse_light += calculate_point_lights_diffuse(vWorldPos, vWorldN, true, false);
	#endif
	
	//apply material color
	
	Out.VertexLighting = saturate(In.vColor * diffuse_light);
	
	Out.VertexColor = In.vColor;
	

		float3 Pview = vCameraPos - vWorldPos;
		Out.normal = normalize( mul( matWorld, In.vNormal ) );
		Out.tangent = normalize( mul( matWorld, In.vTangent ) );
		Out.viewVec = normalize( Pview );


		float4 ShadowPos = mul(matSunViewProj, vWorldPos);
		Out.ShadowTexCoord = ShadowPos;
		Out.ShadowTexCoord.z /= ShadowPos.w;
		Out.ShadowTexCoord.w = 1.0f;
		Out.ShadowTexelPos = Out.ShadowTexCoord * fShadowMapSize;
		//shadow mapping variables end
	//apply fog
	float d = length(P);

	Out.Fog = get_fog_amount_new(d, vWorldPos.z);
	
	
	return Out;
}
PS_OUTPUT ps_fate_hair_aniso(VS_OUTPUT_FATE_HAIR In)
{
	PS_OUTPUT Output;

	//vMaterialColor2.a -> age slider 0..1
	//vMaterialColor -> hair color
	
	float3 lightDir = -vSunDir;
	float3 hairBaseColor = vMaterialColor.rgb;


	// diffuse term
	float3 diffuse = hairBaseColor * vSunColor.rgb * In.VertexColor.rgb * HairDiffuseTerm(In.normal, lightDir);
			

	float4 tex1_col = tex2D(MeshTextureSampler, In.Tex0);
	INPUT_TEX_GAMMA(tex1_col.rgb);
	float4 tex2_col = tex2D(Diffuse2Sampler, In.Tex0);
	float alpha = saturate(((2.0f * vMaterialColor2.a ) + tex2_col.a) - 1.9f);
	
	float4 final_col = tex1_col;
	final_col.rgb *= hairBaseColor;
	final_col.rgb *= (1.0f - alpha);
	final_col.rgb += tex2_col.rgb * alpha;
		
	float sun_amount = tex2Dproj(ShadowmapTextureSampler, In.ShadowTexCoord).r;

	
	float3 specular = calculate_hair_specular(In.normal, In.tangent, lightDir, In.viewVec, In.Tex0);
	
	float4 total_light = vAmbientColor;
	total_light.rgb += (((diffuse + specular) * sun_amount));
	
	//float4 total_light = vAmbientColor;
	//total_light.rgb += diffuse+ * sun_amount;
	total_light.rgb += In.VertexLighting.rgb;
	
	Output.RGBColor.rgb = total_light * final_col.rgb;
	OUTPUT_GAMMA(Output.RGBColor.rgb);
	
	Output.RGBColor.a = tex1_col.a * vMaterialColor.a;
	
	Output.RGBColor = saturate(Output.RGBColor);	//do not bloom!	
	
	return Output;
}

technique fate_hair_shader_aniso
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_fate_hair_aniso();
		PixelShader = compile ps_2_a ps_fate_hair_aniso();
	}
}

VS_OUTPUT_FONT_X vs_beam_align(float4 vPosition : POSITION, float4 vColor : COLOR, float2 tc : TEXCOORD0, float3 vNormal: NORMAL)
{
	VS_OUTPUT_FONT_X Out;

	//Out.Pos = mul(matWorldViewProj, vPosition);
	
	//float4 newPos = vPosition;
	//newPos = mul(newPos, matWorld);
	
	float4 vWorldPos = (float4)mul(matWorld,vPosition);
	float3 worldPos = mul(matWorld,float4(0,0,0,1)).xyz;
	float4x4 matViewTranspose = transpose(matView);
	float3 normal =  normalize( mul( matWorld, vNormal ) );
	
	float3 dist = vCameraPos - worldPos;
	float3 ViewDir = normalize(vCameraPos-worldPos);
	
	float angle = atan2(dist.x, dist.z);
	
	//float angle = atan2(ViewDir.x, ViewDir.z);
	
	float3x3 rotMatrix;
	float cosinus = cos(angle);
	float sinus = sin(angle);

	// Rotation matrix in Y
	rotMatrix[0].xyz = float3(cosinus, 0, sinus);
	rotMatrix[1].xyz = float3(0, 1, 0);
	rotMatrix[2].xyz = float3(- sinus, 0, cosinus);

	// The position of the vertex after the rotation
	float4 newPos = float4(mul(rotMatrix, vPosition * float4(1, 1, 0, 0)), 1);
	
	Out.Pos = mul(matWorldViewProj, newPos);
	
	/*float3 u_axis = float3(0,1,0);
	float3 pos = (vPosition.x * matViewTranspose[0] + vPosition.y * float4(normalize(u_axis), 0.0)).xyz;
	Out.Pos.xyz = mul(matWorldViewProj, pos);*/
	
	Out.Tex0 = tc;
	Out.Color = vColor * vMaterialColor;

	//apply fog
	float3 P = mul(matWorldView, vPosition); //position in view space
	//float4 vWorldPos = (float4)mul(matWorld,vPosition);
	float d = length(P);
	Out.Fog = get_fog_amount_map(d, vWorldPos.z);

	return Out;
}

PS_OUTPUT ps_beam_align(VS_OUTPUT_FONT_X In) 
{ 
	PS_OUTPUT Output;
	Output.RGBColor =  In.Color;
	Output.RGBColor *= tex2D(MeshTextureSampler, In.Tex0);

		/* OUTPUT_GAMMA(Output.RGBColor.rgb);
	
		float depth = tex2Dproj(DepthTextureSampler, In.projCoord).r;
		
		float alpha_factor = saturate((depth-In.Depth) * 4096);
		
		Output.RGBColor *= alpha_factor; */
	
	return Output;
}

technique beam_add_shader
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_beam_align();
		PixelShader = compile ps_2_a ps_beam_align();
	}
}

// Eldrich Shader
// Use vertexColor to alter the vertex positions of vertices before moving them inside the skin deformation matrix.
// 2 Horror Types, Eyes and Tendrils
// Eyes: Red Channel, untouched. Green if < 1, use it to determine the Amount of Shrinking and Growing the spheres do, Blue if < 1 use it as an offset of which the grow/shrink occurs so it doesn't just pulsate logicallu.
// Tendrils: Red: untouched. Green, amount to deform tendril along x/y (Vertical), Blue amount to deform tendril along x/z (depth from Forward). 

VS_OUTPUT_FATE_ANIME_SHADER2 vs_fate_eldrich(float4 vPosition : POSITION, 	float4 vNormal : NORMAL, 			float4 vColor : COLOR, 
											 float2 tc : TEXCOORD0, 		float4 vBlendWeights : BLENDWEIGHT, float4 vBlendIndices : BLENDINDICES, 
											 float3 vTangent : TANGENT,		uniform const bool is_eyes = false, uniform const bool is_tendrils = false)
{
	VS_OUTPUT_FATE_ANIME_SHADER2 Out;
	
	// So, idea will be to alter the vertex positions.
	
	if(is_tendrils)
	{
		if(vColor.g < 1.0){
		vPosition.x += 0.25 * vColor.g * sin(time_var + 100 * vPosition.y);
		}
		
		if(vColor.b < 1.0){
		vPosition.z += 0.25 * vColor.b * sin(time_var + 100 * vPosition.z);
		}
	}
	
	// Eyes will add or subtract the vPosition along their normals
	if(is_eyes && vColor.g < 1.0f)
	{
		float seed = vColor.b * 255;
		vPosition.xyz += 0.1 * vNormal * vColor.g * sin(seed + time_var * vColor.b * 2);
		tc.x += 0.5 * sin(time_var) - 0.1 * sin(12 * time_var + seed);
		tc.y += 0.15 * sin(0.15 * time_var);
	}
	
	//------------- This code belongs to MTarini from TLD shader vs_specular_alpha_skin
	float4 vObjectPos = mul(matWorldArray[vBlendIndices.x], vPosition) * vBlendWeights.x
                      + mul(matWorldArray[vBlendIndices.y], vPosition) * vBlendWeights.y
                      + mul(matWorldArray[vBlendIndices.z], vPosition) * vBlendWeights.z
                      + mul(matWorldArray[vBlendIndices.w], vPosition) * vBlendWeights.w;
	float3 vObjectN = normalize(mul((float3x3)matWorldArray[vBlendIndices.x], vNormal) * vBlendWeights.x
							  + mul((float3x3)matWorldArray[vBlendIndices.y], vNormal) * vBlendWeights.y
							  + mul((float3x3)matWorldArray[vBlendIndices.z], vNormal) * vBlendWeights.z
							  + mul((float3x3)matWorldArray[vBlendIndices.w], vNormal) * vBlendWeights.w);
	
	float4 vWorldPos = mul(matWorld,vObjectPos);
	Out.Pos = mul(matViewProj, vWorldPos);
	float3 vWorldN = normalize(mul((float3x3)matWorld, vObjectN));
	//-------------
	
	Out.Tex0 = tc;
	
	Out.WorldPosition = vWorldPos;
	Out.LocalPosition = vObjectPos;
	
	Out.ScreenSpace.xy = (float2(Out.Pos.x, -Out.Pos.y) + Out.Pos.w)/2;
	Out.ScreenSpace.xy += (vDepthRT_HalfPixel_ViewportSizeInv.xy * Out.Pos.w);
	Out.ScreenSpace.zw = Out.Pos.zw;
	
	float4 diffuse_light;

	//directional lights, compute diffuse color
	//diffuse_light += (dot(vWorldN, -vSkyLightDir) * vSkyLightColor);
	//diffuse_light += saturate((dot(vWorldN, -vSunDir*0.5) * vSunColor));

	//point lights
	diffuse_light = calculate_point_lights_diffuse(vWorldPos, vWorldN, true, false);
	diffuse_light = smoothstep(0.8,0.81,diffuse_light);
	
	
	//apply material color
	// Out.Color = (vMaterialColor * vColor ) * (diffuse_light);
	// Out.Color = vColor + saturate(diffuse_light); // > 0.5 ? float4(1,1,1,1):float4(0,0,0,1);
	
	//float4 ambient =  + ((vSkyLightColor) * isLit);
	//float4 ambient = vAmbientColor + vGroundAmbientColor + ((vSkyLightColor) * isLit);
	
	
	//Out.Color *= vMaterialColor;
	// Out.Color.rgb = 1.0;
	// * sin(tc.y * 20 *  time_var); // Cool time fade effect
	
	float3 P = mul(matWorldView, vPosition); //position in view space
	//apply fog
	float d = length(P);
	
	float4 ShadowPos = mul(matSunViewProj, vWorldPos);
	Out.ShadowTexCoord = ShadowPos;
	Out.ShadowTexCoord.z /= ShadowPos.w;
	Out.ShadowTexCoord.w = 1.0f;
	//Out.ShadowTexCoord =
	Out.Fog = get_fog_amount_new(d, vWorldPos.z);
	Out.WorldNormal = vWorldN;
	Out.ViewDir = normalize(vCameraPos-vWorldPos);
	//uniform const int PcfMode, 
	// Out.ViewDir = normalize(vCameraPos.xyz - vWorldPos.xyz);
	
	/*diffuse_light += vAmbientColor + vSkyLightColor;
	Out.Color = vMaterialColor * vColor * diffuse_light;
	Out.Color.a = 1.0f;*/
	Out.Color = float4(vColor.r, 1, 1, 1);
	return Out;
}
technique eldrich_eyes
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_fate_eldrich(true, false);
		PixelShader = compile ps_2_a ps_fate_anime_shader_color(false, false, false);
	}
}
technique eldrich_tendrils
{
	pass P0
	{
		VertexShader = compile vs_2_0 vs_fate_eldrich(false, true);
		PixelShader = compile ps_2_a ps_fate_anime_shader_color(false, false, false);
	}
}

float fScrollVelocity = 0.006f;

// My biggest change was to fold them together into a single VertexShader instead of two when it's a really minor change.
// and also making the scroll velocity float a global so you can modify it on the fly inside the engine.
VS_OUTPUT_FONT vs_menu_move(float4 vPosition : POSITION, float4 vColor : COLOR, float2 tc : TEXCOORD0, uniform const bool move_right = false)
{
    VS_OUTPUT_FONT Out;

	float vel = fScrollVelocity; // velocity
	if(move_right == true){
		tc.x += vel * time_var;
	}
	else{
		tc.x -= vel * time_var;
	}

    Out.Pos = mul(matWorldViewProj, vPosition);

    float3 P = mul(matWorldView, vPosition).xyz; //position in view space

    Out.Tex0 = tc;
    Out.Color = vColor * vMaterialColor;

    //apply fog
    float d = length(P);
    float4 vWorldPos = (float4)mul(matWorld,vPosition);
    Out.Fog = get_fog_amount_new(d, vWorldPos.z);

    return Out;
}

// This bit is interesting, I don't know the name of this technique, so I'm going to call it precompiling
// Normally you do the compilation at the technique definition level, but, since you may incur compiling
// at multiple techniques, for commonly used shaders, it's more performant to precompile them. In this case
// it is less than necessary since it is only used once, but, I have never done it, so it was fun to use.

VertexShader vs_menu_move_compiled_2_0 = compile vs_2_0 vs_menu_move(false);
VertexShader vs_menu_dust_compiled_2_0 = compile vs_2_0 vs_menu_move(true);

technique main_menu_move
{
    pass P0
    {
        VertexShader = vs_menu_move_compiled_2_0;
        PixelShader = compile ps_2_0 ps_no_shading();
    }
}

technique main_menu_dust
{
    pass P0
    {
        VertexShader = vs_menu_dust_compiled_2_0;
        PixelShader = compile ps_2_0 ps_no_shading();
    }
}


PS_OUTPUT ps_gen_cloud(VS_OUTPUT_TICKER In) 
{ 
	PS_OUTPUT Output;

    // Register Texture Maps and Uniforms
	float vertical_scroll = 0.05 * time_var;	
	float horizontal_scroll = 0.05 * time_var;
	
	float stati = tex2D(MeshTextureSampler, float2(In.Tex0.x /* In.Tex0.z*/, In.Tex0.y /* In.Tex0.z*/)).b;
    float lowres = tex2D(MeshTextureSampler, float2(In.Tex0.x + horizontal_scroll, In.Tex0.y + vertical_scroll)).r;
	float midres = tex2D(MeshTextureSampler, float2(In.Tex0.x - horizontal_scroll, In.Tex0.y)).g;
	float highres = tex2D(MeshTextureSampler, float2(In.Tex0.x + horizontal_scroll, In.Tex0.y - vertical_scroll)).b;
	float color = stati * lowres * midres * highres;
	//color = saturate(clamp(color - 0.1, 0, 1) * 5);
	//color = smoothstep(0.01, 0.35, color);
	
    Output.RGBColor.rgb = saturate(color * In.Tex0.z * -0.25);	// Output the PS Structure
	Output.RGBColor.a = smoothstep(0.15, 0.5, color);
    return Output;
}

technique volumetric_clouds
{
    pass P0
    {
        VertexShader = compile vs_2_0 vs_news_ticker();
        PixelShader = compile ps_2_a ps_gen_cloud();
    }
}

// BSDF Attempt in DX9
