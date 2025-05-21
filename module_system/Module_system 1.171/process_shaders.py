from module_shaders import *
import struct

def write_int(ofile, value):
	ofile.write(struct.pack('I', value))

def write_str(ofile, value):
	write_int(ofile, len(value))
	for c in value:
		ofile.write(struct.pack('c', c))

def write_shaders(postfx_params_list):
	ofile = open("./WSE2 BRFs/core_shaders.brf", "wb")
	# ofile = open("D:/Games/Mount&Blade Warband/Modules/Clean/Resource/core_shaders.brf", "wb")
	write_str(ofile, "rfver ")
	write_int(ofile, 1)
	write_str(ofile, "core_shaders")
	write_int(ofile, len(shaders))
	for shader in shaders:
		write_str(ofile, shader[0])
		write_int(ofile, shader[3]|shf_uses_hlsl)
		write_int(ofile, shader[4])
		write_str(ofile, shader[1])
		write_str(ofile, shader[2])
		write_int(ofile, len(shader[5]))
		for alternative in shader[5]:
			write_str(ofile, alternative)
		write_int(ofile, 0)
	write_str(ofile, "end")
	ofile.close()

print "Exporting shaders..."
write_shaders(shaders)
