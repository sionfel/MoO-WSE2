		Sionfel's Shader Toolkit
All code, unless otherwise noted in the file, is property of Taleworlds. I have modified it for readability
though this particular version isn't entirely Native. It has all sorts of modifications within the common_*
files. No worries though. I will eventually get around to making a clean version. Eventually.



compile_fx.bat
	- Batch file to run fxc.exe, converts the files in shaders/ to an engine readable mb.fx
fxc.exe
	- Microsoft Dx9 Compiler Program
mb.fx
	- The compiler export. Copy over to your mod root folder!
readme.txt
	- This file! This is the contents of this file!
headers/
	-common_constants.h
		- Native Constants
	-common_functions.h
		- Native Functions
	-common_techniques.h
		- Native Techniques
	-fx_configuration.h
		- Application dependent configuration parameters
	-sionfel_constants.h
		- Mod Shader Specific Constants
	-sionfel_functions.h
		- Mod Shader Specific Functions
	-sionfel_techniques.h
		- Mod Shader Specific Techniques, Empty
reference/
	-mb_src.fx
		- This mod's shader file before being split, just as a back up
	-vc_src.fx
		- The shader files included with the VC modding kit
	-wb_src.fx
		- The original mb_src included in the Shader Files
shaders/
	-mb_src.fx
		- This is the "root" shader file that is used by the compiler to figure out what it needs to include
	-native_shaders.fx
		- Native Shaders, these have been modified however
	-postFX.fx
		- The postFX shader. It does not get compiled before being brought over to the mod folder. Maybe move to reference?



Previous Readme:
mb.fx:
- You can add edit main shaders and lighting system with this file. 
- Use compile_fx.bat to compile fxo files. (mb_2a.fxo and mb_2b.fxo)

postfx.fx:
- This file is used for HDR and DoF effects. You cannot modify postFX pipeline
  and render targets but apply changes to generate different tonemappings or effects.
- This file is compiled on-demand according to selected module_postfx parameters.

- We don't give you the source codes for earlyz.fxo since its not directly related 
with the lighting or shading and contains hardcoded depth rendering.
- Do not change fx_configuration.h file since it holds application dependent 
configuration parameters. 

Please send your feedbacks to our forums or PM me(Serdar). 

						All rights reserved.
						 www.taleworlds.com
