local var0_0 = require("jit")

assert(var0_0.version_num == 20100, "LuaJIT core/library version mismatch")

local var1_0 = require("bit")
local var2_0 = "luaJIT_BC_"

local function var3_0()
	io.stderr:write("Save LuaJIT bytecode: luajit -b[options] input output\n  -l        Only list bytecode.\n  -s        Strip debug info (default).\n  -g        Keep debug info.\n  -n name   Set module name (default: auto-detect from input name).\n  -t type   Set output file type (default: auto-detect from output name).\n  -a arch   Override architecture for object files (default: native).\n  -o os     Override OS for object files (default: native).\n  -e chunk  Use chunk string as input.\n  --        Stop handling options.\n  -         Use stdin as input and/or stdout as output.\n\nFile types: c h obj o raw (default)\n")
	os.exit(1)
end

local function var4_0(arg0_2, ...)
	if arg0_2 then
		return arg0_2, ...
	end

	io.stderr:write("luajit: ", ...)
	io.stderr:write("\n")
	os.exit(1)
end

local function var5_0(arg0_3)
	if type(arg0_3) == "function" then
		return arg0_3
	end

	if arg0_3 == "-" then
		arg0_3 = nil
	end

	return var4_0(loadfile(arg0_3))
end

local function var6_0(arg0_4, arg1_4)
	if arg0_4 == "-" then
		return io.stdout
	end

	return var4_0(io.open(arg0_4, arg1_4))
end

local var7_0 = {
	obj = "obj",
	c = "c",
	h = "h",
	o = "obj",
	raw = "raw"
}
local var8_0 = {
	arm64 = true,
	arm = true,
	mips = true,
	arm64be = true,
	x64 = true,
	x86 = true,
	ppc = true,
	mipsel = true
}
local var9_0 = {
	dragonfly = true,
	osx = true,
	openbsd = true,
	netbsd = true,
	freebsd = true,
	solaris = true,
	windows = true,
	linux = true
}

local function var10_0(arg0_5, arg1_5, arg2_5)
	arg0_5 = string.lower(arg0_5)

	local var0_5 = var4_0(arg1_5[arg0_5], "unknown ", arg2_5)

	return var0_5 == true and arg0_5 or var0_5
end

local function var11_0(arg0_6)
	local var0_6 = string.match(string.lower(arg0_6), "%.(%a+)$")

	return var7_0[var0_6] or "raw"
end

local function var12_0(arg0_7)
	var4_0(string.match(arg0_7, "^[%w_.%-]+$"), "bad module name")

	return string.gsub(arg0_7, "[%.%-]", "_")
end

local function var13_0(arg0_8)
	if type(arg0_8) == "string" then
		local var0_8 = string.match(arg0_8, "[^/\\]+$")

		if var0_8 then
			arg0_8 = var0_8
		end

		local var1_8 = string.match(arg0_8, "^(.*)%.[^.]*$")

		if var1_8 then
			arg0_8 = var1_8
		end

		arg0_8 = string.match(arg0_8, "^[%w_.%-]+")
	else
		arg0_8 = nil
	end

	var4_0(arg0_8, "cannot derive module name, use -n name")

	return string.gsub(arg0_8, "[%.%-]", "_")
end

local function var14_0(arg0_9, arg1_9, arg2_9)
	local var0_9, var1_9 = arg0_9:write(arg2_9)

	if var0_9 and arg1_9 ~= "-" then
		var0_9, var1_9 = arg0_9:close()
	end

	var4_0(var0_9, "cannot write ", arg1_9, ": ", var1_9)
end

local function var15_0(arg0_10, arg1_10)
	local var0_10 = var6_0(arg0_10, "wb")

	var14_0(var0_10, arg0_10, arg1_10)
end

local function var16_0(arg0_11, arg1_11, arg2_11)
	local var0_11 = var6_0(arg1_11, "w")

	if arg0_11.type == "c" then
		var0_11:write(string.format("#ifdef _cplusplus\nextern \"C\"\n#endif\n#ifdef _WIN32\n__declspec(dllexport)\n#endif\nconst unsigned char %s%s[] = {\n", var2_0, arg0_11.modname))
	else
		var0_11:write(string.format("#define %s%s_SIZE %d\nstatic const unsigned char %s%s[] = {\n", var2_0, arg0_11.modname, #arg2_11, var2_0, arg0_11.modname))
	end

	local var1_11 = {}
	local var2_11 = 0
	local var3_11 = 0

	for iter0_11 = 1, #arg2_11 do
		local var4_11 = tostring(string.byte(arg2_11, iter0_11))

		var3_11 = var3_11 + #var4_11 + 1

		if var3_11 > 78 then
			var0_11:write(table.concat(var1_11, ",", 1, var2_11), ",\n")

			var2_11, var3_11 = 0, #var4_11 + 1
		end

		var2_11 = var2_11 + 1
		var1_11[var2_11] = var4_11
	end

	var14_0(var0_11, arg1_11, table.concat(var1_11, ",", 1, var2_11) .. "\n};\n")
end

local function var17_0(arg0_12, arg1_12, arg2_12, arg3_12)
	arg3_12.cdef("typedef struct {\n  uint8_t emagic[4], eclass, eendian, eversion, eosabi, eabiversion, epad[7];\n  uint16_t type, machine;\n  uint32_t version;\n  uint32_t entry, phofs, shofs;\n  uint32_t flags;\n  uint16_t ehsize, phentsize, phnum, shentsize, shnum, shstridx;\n} ELF32header;\ntypedef struct {\n  uint8_t emagic[4], eclass, eendian, eversion, eosabi, eabiversion, epad[7];\n  uint16_t type, machine;\n  uint32_t version;\n  uint64_t entry, phofs, shofs;\n  uint32_t flags;\n  uint16_t ehsize, phentsize, phnum, shentsize, shnum, shstridx;\n} ELF64header;\ntypedef struct {\n  uint32_t name, type, flags, addr, ofs, size, link, info, align, entsize;\n} ELF32sectheader;\ntypedef struct {\n  uint32_t name, type;\n  uint64_t flags, addr, ofs, size;\n  uint32_t link, info;\n  uint64_t align, entsize;\n} ELF64sectheader;\ntypedef struct {\n  uint32_t name, value, size;\n  uint8_t info, other;\n  uint16_t sectidx;\n} ELF32symbol;\ntypedef struct {\n  uint32_t name;\n  uint8_t info, other;\n  uint16_t sectidx;\n  uint64_t value, size;\n} ELF64symbol;\ntypedef struct {\n  ELF32header hdr;\n  ELF32sectheader sect[6];\n  ELF32symbol sym[2];\n  uint8_t space[4096];\n} ELF32obj;\ntypedef struct {\n  ELF64header hdr;\n  ELF64sectheader sect[6];\n  ELF64symbol sym[2];\n  uint8_t space[4096];\n} ELF64obj;\n")

	local var0_12 = var2_0 .. arg0_12.modname
	local var1_12 = false
	local var2_12 = false

	if arg0_12.arch == "x64" or arg0_12.arch == "arm64" or arg0_12.arch == "arm64be" then
		var1_12 = true
	elseif arg0_12.arch == "ppc" or arg0_12.arch == "mips" then
		var2_12 = true
	end

	local function var3_12(arg0_13)
		return arg0_13
	end

	local var4_12 = var3_12
	local var5_12 = var3_12

	if arg3_12.abi("be") ~= var2_12 then
		var3_12 = var1_0.bswap

		function var4_12(arg0_14)
			return var1_0.rshift(var1_0.bswap(arg0_14), 16)
		end

		if var1_12 then
			local var6_12 = arg3_12.cast("int64_t", 4294967296)

			function var5_12(arg0_15)
				return var1_0.bswap(arg0_15) * var6_12
			end
		else
			var5_12 = var3_12
		end
	end

	local var7_12 = arg3_12.new(var1_12 and "ELF64obj" or "ELF32obj")
	local var8_12 = var7_12.hdr

	if arg0_12.os == "bsd" or arg0_12.os == "other" then
		local var9_12 = assert(io.open("/bin/ls", "rb"))
		local var10_12 = var9_12:read(9)

		var9_12:close()
		arg3_12.copy(var7_12, var10_12, 9)
		var4_0(var8_12.emagic[0] == 127, "no support for writing native object files")
	else
		var8_12.emagic = "\x7FELF"
		var8_12.eosabi = ({
			freebsd = 9,
			openbsd = 12,
			solaris = 6,
			netbsd = 2
		})[arg0_12.os] or 0
	end

	var8_12.eclass = var1_12 and 2 or 1
	var8_12.eendian = var2_12 and 2 or 1
	var8_12.eversion = 1
	var8_12.type = var4_12(1)
	var8_12.machine = var4_12(({
		arm64 = 183,
		arm = 40,
		mips = 8,
		arm64be = 183,
		x64 = 62,
		x86 = 3,
		ppc = 20,
		mipsel = 8
	})[arg0_12.arch])

	if arg0_12.arch == "mips" or arg0_12.arch == "mipsel" then
		var8_12.flags = var3_12(1342181382)
	end

	var8_12.version = var3_12(1)
	var8_12.shofs = var5_12(arg3_12.offsetof(var7_12, "sect"))
	var8_12.ehsize = var4_12(arg3_12.sizeof(var8_12))
	var8_12.shentsize = var4_12(arg3_12.sizeof(var7_12.sect[0]))
	var8_12.shnum = var4_12(6)
	var8_12.shstridx = var4_12(2)

	local var11_12 = arg3_12.offsetof(var7_12, "space")
	local var12_12 = 1

	for iter0_12, iter1_12 in ipairs({
		".symtab",
		".shstrtab",
		".strtab",
		".rodata",
		".note.GNU-stack"
	}) do
		local var13_12 = var7_12.sect[iter0_12]

		var13_12.align = var5_12(1)
		var13_12.name = var3_12(var12_12)

		arg3_12.copy(var7_12.space + var12_12, iter1_12)

		var12_12 = var12_12 + #iter1_12 + 1
	end

	var7_12.sect[1].type = var3_12(2)
	var7_12.sect[1].link = var3_12(3)
	var7_12.sect[1].info = var3_12(1)
	var7_12.sect[1].align = var5_12(8)
	var7_12.sect[1].ofs = var5_12(arg3_12.offsetof(var7_12, "sym"))
	var7_12.sect[1].entsize = var5_12(arg3_12.sizeof(var7_12.sym[0]))
	var7_12.sect[1].size = var5_12(arg3_12.sizeof(var7_12.sym))
	var7_12.sym[1].name = var3_12(1)
	var7_12.sym[1].sectidx = var4_12(4)
	var7_12.sym[1].size = var5_12(#arg2_12)
	var7_12.sym[1].info = 17
	var7_12.sect[2].type = var3_12(3)
	var7_12.sect[2].ofs = var5_12(var11_12)
	var7_12.sect[2].size = var5_12(var12_12)
	var7_12.sect[3].type = var3_12(3)
	var7_12.sect[3].ofs = var5_12(var11_12 + var12_12)
	var7_12.sect[3].size = var5_12(#var0_12 + 1)

	arg3_12.copy(var7_12.space + var12_12 + 1, var0_12)

	local var14_12 = var12_12 + #var0_12 + 2

	var7_12.sect[4].type = var3_12(1)
	var7_12.sect[4].flags = var5_12(2)
	var7_12.sect[4].ofs = var5_12(var11_12 + var14_12)
	var7_12.sect[4].size = var5_12(#arg2_12)
	var7_12.sect[5].type = var3_12(1)
	var7_12.sect[5].ofs = var5_12(var11_12 + var14_12 + #arg2_12)

	local var15_12 = var6_0(arg1_12, "wb")

	var15_12:write(arg3_12.string(var7_12, arg3_12.sizeof(var7_12) - 4096 + var14_12))
	var14_0(var15_12, arg1_12, arg2_12)
end

local function var18_0(arg0_16, arg1_16, arg2_16, arg3_16)
	arg3_16.cdef("typedef struct {\n  uint16_t arch, nsects;\n  uint32_t time, symtabofs, nsyms;\n  uint16_t opthdrsz, flags;\n} PEheader;\ntypedef struct {\n  char name[8];\n  uint32_t vsize, vaddr, size, ofs, relocofs, lineofs;\n  uint16_t nreloc, nline;\n  uint32_t flags;\n} PEsection;\ntypedef struct __attribute((packed)) {\n  union {\n    char name[8];\n    uint32_t nameref[2];\n  };\n  uint32_t value;\n  int16_t sect;\n  uint16_t type;\n  uint8_t scl, naux;\n} PEsym;\ntypedef struct __attribute((packed)) {\n  uint32_t size;\n  uint16_t nreloc, nline;\n  uint32_t cksum;\n  uint16_t assoc;\n  uint8_t comdatsel, unused[3];\n} PEsymaux;\ntypedef struct {\n  PEheader hdr;\n  PEsection sect[2];\n  // Must be an even number of symbol structs.\n  PEsym sym0;\n  PEsymaux sym0aux;\n  PEsym sym1;\n  PEsymaux sym1aux;\n  PEsym sym2;\n  PEsym sym3;\n  uint32_t strtabsize;\n  uint8_t space[4096];\n} PEobj;\n")

	local var0_16 = var2_0 .. arg0_16.modname
	local var1_16 = false

	if arg0_16.arch == "x86" then
		var0_16 = "_" .. var0_16
	elseif arg0_16.arch == "x64" then
		local var2_16 = true
	end

	local var3_16 = "   /EXPORT:" .. var0_16 .. ",DATA "

	local function var4_16(arg0_17)
		return arg0_17
	end

	local var5_16 = var4_16

	if arg3_16.abi("be") then
		var4_16 = var1_0.bswap

		function var5_16(arg0_18)
			return var1_0.rshift(var1_0.bswap(arg0_18), 16)
		end
	end

	local var6_16 = arg3_16.new("PEobj")
	local var7_16 = var6_16.hdr

	var7_16.arch = var5_16(({
		ppc = 498,
		arm = 448,
		mips = 870,
		mipsel = 870,
		x64 = 34404,
		x86 = 332
	})[arg0_16.arch])
	var7_16.nsects = var5_16(2)
	var7_16.symtabofs = var4_16(arg3_16.offsetof(var6_16, "sym0"))
	var7_16.nsyms = var4_16(6)
	var6_16.sect[0].name = ".drectve"
	var6_16.sect[0].size = var4_16(#var3_16)
	var6_16.sect[0].flags = var4_16(1051136)
	var6_16.sym0.sect = var5_16(1)
	var6_16.sym0.scl = 3
	var6_16.sym0.name = ".drectve"
	var6_16.sym0.naux = 1
	var6_16.sym0aux.size = var4_16(#var3_16)
	var6_16.sect[1].name = ".rdata"
	var6_16.sect[1].size = var4_16(#arg2_16)
	var6_16.sect[1].flags = var4_16(1076887616)
	var6_16.sym1.sect = var5_16(2)
	var6_16.sym1.scl = 3
	var6_16.sym1.name = ".rdata"
	var6_16.sym1.naux = 1
	var6_16.sym1aux.size = var4_16(#arg2_16)
	var6_16.sym2.sect = var5_16(2)
	var6_16.sym2.scl = 2
	var6_16.sym2.nameref[1] = var4_16(4)
	var6_16.sym3.sect = var5_16(-1)
	var6_16.sym3.scl = 2
	var6_16.sym3.value = var4_16(1)
	var6_16.sym3.name = "@feat.00"

	arg3_16.copy(var6_16.space, var0_16)

	local var8_16 = #var0_16 + 1

	var6_16.strtabsize = var4_16(var8_16 + 4)
	var6_16.sect[0].ofs = var4_16(arg3_16.offsetof(var6_16, "space") + var8_16)

	arg3_16.copy(var6_16.space + var8_16, var3_16)

	local var9_16 = var8_16 + #var3_16

	var6_16.sect[1].ofs = var4_16(arg3_16.offsetof(var6_16, "space") + var9_16)

	local var10_16 = var6_0(arg1_16, "wb")

	var10_16:write(arg3_16.string(var6_16, arg3_16.sizeof(var6_16) - 4096 + var9_16))
	var14_0(var10_16, arg1_16, arg2_16)
end

local function var19_0(arg0_19, arg1_19, arg2_19, arg3_19)
	arg3_19.cdef("typedef struct\n{\n  uint32_t magic, cputype, cpusubtype, filetype, ncmds, sizeofcmds, flags;\n} mach_header;\ntypedef struct\n{\n  mach_header; uint32_t reserved;\n} mach_header_64;\ntypedef struct {\n  uint32_t cmd, cmdsize;\n  char segname[16];\n  uint32_t vmaddr, vmsize, fileoff, filesize;\n  uint32_t maxprot, initprot, nsects, flags;\n} mach_segment_command;\ntypedef struct {\n  uint32_t cmd, cmdsize;\n  char segname[16];\n  uint64_t vmaddr, vmsize, fileoff, filesize;\n  uint32_t maxprot, initprot, nsects, flags;\n} mach_segment_command_64;\ntypedef struct {\n  char sectname[16], segname[16];\n  uint32_t addr, size;\n  uint32_t offset, align, reloff, nreloc, flags;\n  uint32_t reserved1, reserved2;\n} mach_section;\ntypedef struct {\n  char sectname[16], segname[16];\n  uint64_t addr, size;\n  uint32_t offset, align, reloff, nreloc, flags;\n  uint32_t reserved1, reserved2, reserved3;\n} mach_section_64;\ntypedef struct {\n  uint32_t cmd, cmdsize, symoff, nsyms, stroff, strsize;\n} mach_symtab_command;\ntypedef struct {\n  int32_t strx;\n  uint8_t type, sect;\n  int16_t desc;\n  uint32_t value;\n} mach_nlist;\ntypedef struct {\n  uint32_t strx;\n  uint8_t type, sect;\n  uint16_t desc;\n  uint64_t value;\n} mach_nlist_64;\ntypedef struct\n{\n  uint32_t magic, nfat_arch;\n} mach_fat_header;\ntypedef struct\n{\n  uint32_t cputype, cpusubtype, offset, size, align;\n} mach_fat_arch;\ntypedef struct {\n  struct {\n    mach_header hdr;\n    mach_segment_command seg;\n    mach_section sec;\n    mach_symtab_command sym;\n  } arch[1];\n  mach_nlist sym_entry;\n  uint8_t space[4096];\n} mach_obj;\ntypedef struct {\n  struct {\n    mach_header_64 hdr;\n    mach_segment_command_64 seg;\n    mach_section_64 sec;\n    mach_symtab_command sym;\n  } arch[1];\n  mach_nlist_64 sym_entry;\n  uint8_t space[4096];\n} mach_obj_64;\ntypedef struct {\n  mach_fat_header fat;\n  mach_fat_arch fat_arch[2];\n  struct {\n    mach_header hdr;\n    mach_segment_command seg;\n    mach_section sec;\n    mach_symtab_command sym;\n  } arch[2];\n  mach_nlist sym_entry;\n  uint8_t space[4096];\n} mach_fat_obj;\n")

	local var0_19 = "_" .. var2_0 .. arg0_19.modname
	local var1_19 = false
	local var2_19 = false
	local var3_19 = 4
	local var4_19 = "mach_obj"

	if arg0_19.arch == "x64" then
		var2_19, var3_19, var4_19 = true, 8, "mach_obj_64"
	elseif arg0_19.arch == "arm" then
		var1_19, var4_19 = true, "mach_fat_obj"
	elseif arg0_19.arch == "arm64" then
		var2_19, var3_19, var1_19, var4_19 = true, 8, true, "mach_fat_obj"
	else
		var4_0(arg0_19.arch == "x86", "unsupported architecture for OSX")
	end

	local function var5_19(arg0_20, arg1_20)
		return var1_0.band(arg0_20 + arg1_20 - 1, -arg1_20)
	end

	local var6_19 = var1_0.bswap
	local var7_19 = arg3_19.new(var4_19)
	local var8_19 = var5_19(arg3_19.offsetof(var7_19, "space") + #var0_19 + 2, var3_19)
	local var9_19 = ({
		x86 = {
			7
		},
		x64 = {
			16777223
		},
		arm = {
			7,
			12
		},
		arm64 = {
			16777223,
			16777228
		}
	})[arg0_19.arch]
	local var10_19 = ({
		x86 = {
			3
		},
		x64 = {
			3
		},
		arm = {
			3,
			9
		},
		arm64 = {
			3,
			0
		}
	})[arg0_19.arch]

	if var1_19 then
		var7_19.fat.magic = var6_19(3405691582)
		var7_19.fat.nfat_arch = var6_19(#var10_19)
	end

	for iter0_19 = 0, #var10_19 - 1 do
		local var11_19 = 0

		if var1_19 then
			local var12_19 = var7_19.fat_arch[iter0_19]

			var12_19.cputype = var6_19(var9_19[iter0_19 + 1])
			var12_19.cpusubtype = var6_19(var10_19[iter0_19 + 1])
			var11_19 = arg3_19.offsetof(var7_19, "arch") + iter0_19 * arg3_19.sizeof(var7_19.arch[0])
			var12_19.offset = var6_19(var11_19)
			var12_19.size = var6_19(var8_19 - var11_19 + #arg2_19)
		end

		local var13_19 = var7_19.arch[iter0_19]

		var13_19.hdr.magic = var2_19 and 4277009103 or 4277009102
		var13_19.hdr.cputype = var9_19[iter0_19 + 1]
		var13_19.hdr.cpusubtype = var10_19[iter0_19 + 1]
		var13_19.hdr.filetype = 1
		var13_19.hdr.ncmds = 2
		var13_19.hdr.sizeofcmds = arg3_19.sizeof(var13_19.seg) + arg3_19.sizeof(var13_19.sec) + arg3_19.sizeof(var13_19.sym)
		var13_19.seg.cmd = var2_19 and 25 or 1
		var13_19.seg.cmdsize = arg3_19.sizeof(var13_19.seg) + arg3_19.sizeof(var13_19.sec)
		var13_19.seg.vmsize = #arg2_19
		var13_19.seg.fileoff = var8_19 - var11_19
		var13_19.seg.filesize = #arg2_19
		var13_19.seg.maxprot = 1
		var13_19.seg.initprot = 1
		var13_19.seg.nsects = 1

		arg3_19.copy(var13_19.sec.sectname, "__data")
		arg3_19.copy(var13_19.sec.segname, "__DATA")

		var13_19.sec.size = #arg2_19
		var13_19.sec.offset = var8_19 - var11_19
		var13_19.sym.cmd = 2
		var13_19.sym.cmdsize = arg3_19.sizeof(var13_19.sym)
		var13_19.sym.symoff = arg3_19.offsetof(var7_19, "sym_entry") - var11_19
		var13_19.sym.nsyms = 1
		var13_19.sym.stroff = arg3_19.offsetof(var7_19, "sym_entry") + arg3_19.sizeof(var7_19.sym_entry) - var11_19
		var13_19.sym.strsize = var5_19(#var0_19 + 2, var3_19)
	end

	var7_19.sym_entry.type = 15
	var7_19.sym_entry.sect = 1
	var7_19.sym_entry.strx = 1

	arg3_19.copy(var7_19.space + 1, var0_19)

	local var14_19 = var6_0(arg1_19, "wb")

	var14_19:write(arg3_19.string(var7_19, var8_19))
	var14_0(var14_19, arg1_19, arg2_19)
end

local function var20_0(arg0_21, arg1_21, arg2_21)
	local var0_21, var1_21 = pcall(require, "ffi")

	var4_0(var0_21, "FFI library required to write this file type")

	if arg0_21.os == "windows" then
		return var18_0(arg0_21, arg1_21, arg2_21, var1_21)
	elseif arg0_21.os == "osx" then
		return var19_0(arg0_21, arg1_21, arg2_21, var1_21)
	else
		return var17_0(arg0_21, arg1_21, arg2_21, var1_21)
	end
end

local function var21_0(arg0_22, arg1_22)
	local var0_22 = var5_0(arg0_22)

	require("jit.bc").dump(var0_22, var6_0(arg1_22, "w"), true)
end

local function var22_0(arg0_23, arg1_23, arg2_23)
	local var0_23 = var5_0(arg1_23)
	local var1_23 = string.dump(var0_23, arg0_23.strip)
	local var2_23 = arg0_23.type

	if not var2_23 then
		var2_23 = var11_0(arg2_23)
		arg0_23.type = var2_23
	end

	if var2_23 == "raw" then
		var15_0(arg2_23, var1_23)
	else
		if not arg0_23.modname then
			arg0_23.modname = var13_0(arg1_23)
		end

		if var2_23 == "obj" then
			var20_0(arg0_23, arg2_23, var1_23)
		else
			var16_0(arg0_23, arg2_23, var1_23)
		end
	end
end

local function var23_0(...)
	local var0_24 = {
		...
	}
	local var1_24 = 1
	local var2_24 = false
	local var3_24 = {
		type = false,
		strip = true,
		modname = false,
		arch = var0_0.arch,
		os = string.lower(var0_0.os)
	}

	while var1_24 <= #var0_24 do
		local var4_24 = var0_24[var1_24]

		if type(var4_24) == "string" and string.sub(var4_24, 1, 1) == "-" and var4_24 ~= "-" then
			table.remove(var0_24, var1_24)

			if var4_24 == "--" then
				break
			end

			for iter0_24 = 2, #var4_24 do
				local var5_24 = string.sub(var4_24, iter0_24, iter0_24)

				if var5_24 == "l" then
					var2_24 = true
				elseif var5_24 == "s" then
					var3_24.strip = true
				elseif var5_24 == "g" then
					var3_24.strip = false
				else
					if var0_24[var1_24] == nil or iter0_24 ~= #var4_24 then
						var3_0()
					end

					if var5_24 == "e" then
						if var1_24 ~= 1 then
							var3_0()
						end

						var0_24[1] = var4_0(loadstring(var0_24[1]))
					elseif var5_24 == "n" then
						var3_24.modname = var12_0(table.remove(var0_24, var1_24))
					elseif var5_24 == "t" then
						var3_24.type = var10_0(table.remove(var0_24, var1_24), var7_0, "file type")
					elseif var5_24 == "a" then
						var3_24.arch = var10_0(table.remove(var0_24, var1_24), var8_0, "architecture")
					elseif var5_24 == "o" then
						var3_24.os = var10_0(table.remove(var0_24, var1_24), var9_0, "OS name")
					else
						var3_0()
					end
				end
			end
		else
			var1_24 = var1_24 + 1
		end
	end

	if var2_24 then
		if #var0_24 == 0 or #var0_24 > 2 then
			var3_0()
		end

		var21_0(var0_24[1], var0_24[2] or "-")
	else
		if #var0_24 ~= 2 then
			var3_0()
		end

		var22_0(var3_24, var0_24[1], var0_24[2])
	end
end

return {
	start = var23_0
}
