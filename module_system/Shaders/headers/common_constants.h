// Constains Native Functions and Libraries

#if !defined (PS_2_X)
	#error "define high quality shader profile: PS_2_X ( ps_2_b or ps_2_a )"
#endif



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
	float4 vPointLightColor;	//average color of lights
	
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