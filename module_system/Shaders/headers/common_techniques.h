
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define	DEFINE_LIGHTING_TECHNIQUE(tech_name, use_dxt5, use_bumpmap, use_skinning, use_specularfactor, use_specularmap)