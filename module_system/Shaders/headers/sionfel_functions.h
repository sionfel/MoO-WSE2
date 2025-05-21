// Includes non-Native Functions and Libraries

#ifdef FUNCTIONS

/* The bot says
	The playstationify function is a vertex shader that applies a "pixelated" effect to the rendered geometry. 
	This is achieved by quantizing the vertex positions and texture coordinates in order to create a low-resolution, blocky look.

	The function takes in a vertex position (vPos) in world space and transforms it into screen space using the world-view-projection matrix (matWorldViewProj). 
	The resulting position (projection) is then divided by its w-coordinate, which maps it from clip space to normalized device coordinates (NDC).

	Next, the x and y coordinates of the vertex are quantized by dividing them by the resolution of the screen, rounding to the nearest integer, and then multiplying by the resolution again. 
	This creates a grid of discrete pixels, which effectively limits the precision of the vertex positions and texture coordinates.

	Finally, the quantized vertex position is multiplied by the w-coordinate and, if the w-coordinate is positive, 
	the position is divided by the w-coordinate to bring it back into clip space. The resulting position is then returned as the output of the function.

	Overall, this function applies a "pixelated" effect to the rendered geometry, which can be used to create a retro or stylized look.
*/
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
	
	float3 camDir = matView[2];					// This matrix holds the transformed camera direction inside the index 2.
	
	float lightCone = saturate(dot(normalize(viewDir), normalize(camDir)));		// Basically does a cone based on Camera's facing
	lightCone = pow(lightCone, 15);	// This tightens the cone angle
    float3 flashlight = saturate(saturate(dot(camDir, worldNormal))) * atten * lightCone;	// You could tint the light by multiplying it by a color here
	
	return flashlight;
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

float3 darkenBlood(in float3 BloodColor)
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


// Spot Light Support

/* struct spotLight
{
	float3 Pos;
	float3 Dir;
	float4 Color;
	float Falloff;
	float Cone;
}; */

#define NUM_SPOT_LIGHTS					10
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
// Put the source url here, dstn
float4x4 rotationMatrix(float3 axis, float angle)
{
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;
    
    return float4x4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
                0.0,                                0.0,                                0.0,                                1.0);
}
// from: https://gamedev.stackexchange.com/questions/188636/cylindrical-billboarding-around-an-arbitrary-axis-in-geometry-shader
float3x3 AxisBillboard(float3 upAxis, float3 viewDirection) {
    float3 rightAxis = normalize(cross(upAxis, viewDirection));
    float3 forwardAxis = cross(rightAxis, upAxis);

    float3x3 result;
    result[0].xyz = rightAxis;
    result[1].xyz = upAxis;
    result[2].xyz = forwardAxis;

    return transpose(result);
}
// Adapted from : https://docs.unity3d.com/Packages/com.unity.shadergraph@6.9/manual/Rotate-About-Axis-Node.html
float3 RotateByDegrees(float3 In, float3 Axis, float Rotation)
{
    Rotation = radians(Rotation);
    float s = sin(Rotation);
    float c = cos(Rotation);
    float one_minus_c = 1.0 - c;

    Axis = normalize(Axis);
    float3x3 rot_mat = 
    {   one_minus_c * Axis.x * Axis.x + c, one_minus_c * Axis.x * Axis.y - Axis.z * s, one_minus_c * Axis.z * Axis.x + Axis.y * s,
        one_minus_c * Axis.x * Axis.y + Axis.z * s, one_minus_c * Axis.y * Axis.y + c, one_minus_c * Axis.y * Axis.z - Axis.x * s,
        one_minus_c * Axis.z * Axis.x - Axis.y * s, one_minus_c * Axis.y * Axis.z + Axis.x * s, one_minus_c * Axis.z * Axis.z + c
    };
    return mul(rot_mat, In);
}

float3 RotateByDegreesLocally(float3 In, float3 Axis, float Rotation)
{
    Rotation = radians(Rotation);
    float s = sin(Rotation);
    float c = cos(Rotation);
    float one_minus_c = 1.0 - c;
	
    Axis = normalize(Axis) + In;
    float3x3 rot_mat = 
    {   one_minus_c * Axis.x * Axis.x + c, one_minus_c * Axis.x * Axis.y - Axis.z * s, one_minus_c * Axis.z * Axis.x + Axis.y * s,
        one_minus_c * Axis.x * Axis.y + Axis.z * s, one_minus_c * Axis.y * Axis.y + c, one_minus_c * Axis.y * Axis.z - Axis.x * s,
        one_minus_c * Axis.z * Axis.x - Axis.y * s, one_minus_c * Axis.y * Axis.z + Axis.x * s, one_minus_c * Axis.z * Axis.z + c
    };
    return mul(rot_mat, In);
}

float AverageSunAmount(float4 ShadowTexCoord)
{
		
		static const int SAMPLE_COUNT = 8;
		static float2 offsets[SAMPLE_COUNT] = {
		-1, -1,
		  0, -1,
		  1, -1,
		 -1,  0,
		  1,  0,
		 -1,  1,
		  0,  1,
		  1,  1,
		};
		
		float _sun_amount = 0;
		
		for (int i = 0; i < SAMPLE_COUNT; i++) {
			_sun_amount +=  tex2D(ShadowmapTextureSampler, ShadowTexCoord + fShadowMapNextPixel * offsets[i]).r;
		}
		
		return _sun_amount / SAMPLE_COUNT;
}

float4 retroReflection(float4 retroMap, float3 cameraDir, float3 lightDir, float3 surfaceNormal)
{
	float dLtoS = saturate(dot(lightDir, surfaceNormal));
	float dEtoS = smoothstep(0.5, 0.75, saturate(dot(cameraDir, surfaceNormal)));
	//float dEtoS = pow(saturate(dot(cameraDir, surfaceNormal)), 15);

	//return float4(retroMap * pow(dEtoS * pow(dLtoS, 10), 10));
	//return float4(retroMap * pow(dEtoS * pow(dLtoS, 10), 10));
	return float4(retroMap * dEtoS * pow(saturate(dot(cameraDir, lightDir)), 10));
}

float4 ai_retroReflection(float4 retroMap, float3 cameraDir, float3 lightDir, float3 surfaceNormal)
{
    // Calculate the dot product of the light direction and the surface normal
    float dLtoS = saturate(dot(lightDir, surfaceNormal));

    // Calculate the dot product of the camera direction and the surface normal
    float dEtoS = saturate(dot(cameraDir, surfaceNormal));

    // Calculate the cosine of the angle between the camera direction and the light direction
    float cosTheta = saturate(dot(cameraDir, lightDir));

    // Calculate the Fresnel term
    float fresnelTerm = pow(1 - cosTheta, 5);

    // Calculate the final reflection color
    float4 reflectionColor = retroMap * dEtoS * fresnelTerm;

    return reflectionColor;
}

float4 ai2_retroReflection(float4 retroMap, float3 cameraDir, float3 lightDir, float3 surfaceNormal)
{
    // Compute the angle between the light direction and the surface normal
    float angle = dot(lightDir, surfaceNormal);
    
    // Use the angle to calculate the retroreflection value
    // This value will be high when the angle is close to 90 degrees
    // and low when the angle is close to 0 degrees
    float retroValue = pow(saturate(1.0 - abs(angle - 1.0)), 5);
    
    // Compute the amount of light that is reflected back to the camera
    float dEtoS = smoothstep(0.5, 0.75, saturate(dot(cameraDir, surfaceNormal)));
    
    // Return the final retroreflection value
    return float4(retroMap * dEtoS * retroValue);
}


#endif