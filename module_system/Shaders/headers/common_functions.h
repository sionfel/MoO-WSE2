// Includes Native Constants and Definitions

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

float4 skinning_deform(float4 vPosition, float4 vBlendWeights, float4 vBlendIndices )
{
	return 	  mul(matWorldArray[vBlendIndices.x], vPosition /*- matBoneOriginArray[vBlendIndices.x]*/) * vBlendWeights.x
			+ mul(matWorldArray[vBlendIndices.y], vPosition /*- matBoneOriginArray[vBlendIndices.y]*/) * vBlendWeights.y
			+ mul(matWorldArray[vBlendIndices.z], vPosition /*- matBoneOriginArray[vBlendIndices.z]*/) * vBlendWeights.z
			+ mul(matWorldArray[vBlendIndices.w], vPosition /*- matBoneOriginArray[vBlendIndices.w]*/) * vBlendWeights.w;
}

#endif