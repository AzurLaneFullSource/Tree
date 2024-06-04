local var0 = require("jit")

assert(var0.version_num == 20100, "LuaJIT core/library version mismatch")

local var1 = require("bit")
local var2 = "luaJIT_BC_"

local function var3()
	io.stderr:write("Save LuaJIT bytecode: luajit -b[options] input output\n  -l        Only list bytecode.\n  -s        Strip debug info (default).\n  -g        Keep debug info.\n  -n name   Set module name (default: auto-detect from input name).\n  -t type   Set output file type (default: auto-detect from output name).\n  -a arch   Override architecture for object files (default: native).\n  -o os     Override OS for object files (default: native).\n  -e chunk  Use chunk string as input.\n  --        Stop handling options.\n  -         Use stdin as input and/or stdout as output.\n\nFile types: c h obj o raw (default)\n")
	os.exit(1)
end

local function var4(arg0, ...)
	if arg0 then
		return arg0, ...
	end

	io.stderr:write("luajit: ", ...)
	io.stderr:write("\n")
	os.exit(1)
end

local function var5(arg0)
	if type(arg0) == "function" then
		return arg0
	end

	if arg0 == "-" then
		arg0 = nil
	end

	return var4(loadfile(arg0))
end

local function var6(arg0, arg1)
	if arg0 == "-" then
		return io.stdout
	end

	return var4(io.open(arg0, arg1))
end

local var7 = {
	obj = "obj",
	c = "c",
	h = "h",
	o = "obj",
	raw = "raw"
}
local var8 = {
	arm64 = true,
	arm = true,
	mips = true,
	arm64be = true,
	x64 = true,
	x86 = true,
	ppc = true,
	mipsel = true
}
local var9 = {
	dragonfly = true,
	osx = true,
	openbsd = true,
	netbsd = true,
	freebsd = true,
	solaris = true,
	windows = true,
	linux = true
}

local function var10(arg0, arg1, arg2)
	arg0 = string.lower(arg0)

	local var0 = var4(arg1[arg0], "unknown ", arg2)

	return var0 == true and arg0 or var0
end

local function var11(arg0)
	local var0 = string.match(string.lower(arg0), "%.(%a+)$")

	return var7[var0] or "raw"
end

local function var12(arg0)
	var4(string.match(arg0, "^[%w_.%-]+$"), "bad module name")

	return string.gsub(arg0, "[%.%-]", "_")
end

local function var13(arg0)
	if type(arg0) == "string" then
		local var0 = string.match(arg0, "[^/\\]+$")

		if var0 then
			arg0 = var0
		end

		local var1 = string.match(arg0, "^(.*)%.[^.]*$")

		if var1 then
			arg0 = var1
		end

		arg0 = string.match(arg0, "^[%w_.%-]+")
	else
		arg0 = nil
	end

	var4(arg0, "cannot derive module name, use -n name")

	return string.gsub(arg0, "[%.%-]", "_")
end

local function var14(arg0, arg1, arg2)
	local var0, var1 = arg0:write(arg2)

	if var0 and arg1 ~= "-" then
		var0, var1 = arg0:close()
	end

	var4(var0, "cannot write ", arg1, ": ", var1)
end

local function var15(arg0, arg1)
	local var0 = var6(arg0, "wb")

	var14(var0, arg0, arg1)
end

local function var16(arg0, arg1, arg2)
	local var0 = var6(arg1, "w")

	if arg0.type == "c" then
		var0:write(string.format("#ifdef _cplusplus\nextern \"C\"\n#endif\n#ifdef _WIN32\n__declspec(dllexport)\n#endif\nconst unsigned char %s%s[] = {\n", var2, arg0.modname))
	else
		var0:write(string.format("#define %s%s_SIZE %d\nstatic const unsigned char %s%s[] = {\n", var2, arg0.modname, #arg2, var2, arg0.modname))
	end

	local var1 = {}
	local var2 = 0
	local var3 = 0

	for iter0 = 1, #arg2 do
		local var4 = tostring(string.byte(arg2, iter0))

		var3 = var3 + #var4 + 1

		if var3 > 78 then
			var0:write(table.concat(var1, ",", 1, var2), ",\n")

			var2, var3 = 0, #var4 + 1
		end

		var2 = var2 + 1
		var1[var2] = var4
	end

	var14(var0, arg1, table.concat(var1, ",", 1, var2) .. "\n};\n")
end

local function var17(arg0, arg1, arg2, arg3)
	arg3.cdef("typedef struct {\n  uint8_t emagic[4], eclass, eendian, eversion, eosabi, eabiversion, epad[7];\n  uint16_t type, machine;\n  uint32_t version;\n  uint32_t entry, phofs, shofs;\n  uint32_t flags;\n  uint16_t ehsize, phentsize, phnum, shentsize, shnum, shstridx;\n} ELF32header;\ntypedef struct {\n  uint8_t emagic[4], eclass, eendian, eversion, eosabi, eabiversion, epad[7];\n  uint16_t type, machine;\n  uint32_t version;\n  uint64_t entry, phofs, shofs;\n  uint32_t flags;\n  uint16_t ehsize, phentsize, phnum, shentsize, shnum, shstridx;\n} ELF64header;\ntypedef struct {\n  uint32_t name, type, flags, addr, ofs, size, link, info, align, entsize;\n} ELF32sectheader;\ntypedef struct {\n  uint32_t name, type;\n  uint64_t flags, addr, ofs, size;\n  uint32_t link, info;\n  uint64_t align, entsize;\n} ELF64sectheader;\ntypedef struct {\n  uint32_t name, value, size;\n  uint8_t info, other;\n  uint16_t sectidx;\n} ELF32symbol;\ntypedef struct {\n  uint32_t name;\n  uint8_t info, other;\n  uint16_t sectidx;\n  uint64_t value, size;\n} ELF64symbol;\ntypedef struct {\n  ELF32header hdr;\n  ELF32sectheader sect[6];\n  ELF32symbol sym[2];\n  uint8_t space[4096];\n} ELF32obj;\ntypedef struct {\n  ELF64header hdr;\n  ELF64sectheader sect[6];\n  ELF64symbol sym[2];\n  uint8_t space[4096];\n} ELF64obj;\n")

	local var0 = var2 .. arg0.modname
	local var1 = false
	local var2 = false

	if arg0.arch == "x64" or arg0.arch == "arm64" or arg0.arch == "arm64be" then
		var1 = true
	elseif arg0.arch == "ppc" or arg0.arch == "mips" then
		var2 = true
	end

	local function var3(arg0)
		return arg0
	end

	local var4 = var3
	local var5 = var3

	if arg3.abi("be") ~= var2 then
		var3 = var1.bswap

		function var4(arg0)
			return var1.rshift(var1.bswap(arg0), 16)
		end

		if var1 then
			local var6 = arg3.cast("int64_t", 4294967296)

			function var5(arg0)
				return var1.bswap(arg0) * var6
			end
		else
			var5 = var3
		end
	end

	local var7 = arg3.new(var1 and "ELF64obj" or "ELF32obj")
	local var8 = var7.hdr

	if arg0.os == "bsd" or arg0.os == "other" then
		local var9 = assert(io.open("/bin/ls", "rb"))
		local var10 = var9:read(9)

		var9:close()
		arg3.copy(var7, var10, 9)
		var4(var8.emagic[0] == 127, "no support for writing native object files")
	else
		var8.emagic = "\x7FELF"
		var8.eosabi = ({
			freebsd = 9,
			openbsd = 12,
			solaris = 6,
			netbsd = 2
		})[arg0.os] or 0
	end

	var8.eclass = var1 and 2 or 1
	var8.eendian = var2 and 2 or 1
	var8.eversion = 1
	var8.type = var4(1)
	var8.machine = var4(({
		arm64 = 183,
		arm = 40,
		mips = 8,
		arm64be = 183,
		x64 = 62,
		x86 = 3,
		ppc = 20,
		mipsel = 8
	})[arg0.arch])

	if arg0.arch == "mips" or arg0.arch == "mipsel" then
		var8.flags = var3(1342181382)
	end

	var8.version = var3(1)
	var8.shofs = var5(arg3.offsetof(var7, "sect"))
	var8.ehsize = var4(arg3.sizeof(var8))
	var8.shentsize = var4(arg3.sizeof(var7.sect[0]))
	var8.shnum = var4(6)
	var8.shstridx = var4(2)

	local var11 = arg3.offsetof(var7, "space")
	local var12 = 1

	for iter0, iter1 in ipairs({
		".symtab",
		".shstrtab",
		".strtab",
		".rodata",
		".note.GNU-stack"
	}) do
		local var13 = var7.sect[iter0]

		var13.align = var5(1)
		var13.name = var3(var12)

		arg3.copy(var7.space + var12, iter1)

		var12 = var12 + #iter1 + 1
	end

	var7.sect[1].type = var3(2)
	var7.sect[1].link = var3(3)
	var7.sect[1].info = var3(1)
	var7.sect[1].align = var5(8)
	var7.sect[1].ofs = var5(arg3.offsetof(var7, "sym"))
	var7.sect[1].entsize = var5(arg3.sizeof(var7.sym[0]))
	var7.sect[1].size = var5(arg3.sizeof(var7.sym))
	var7.sym[1].name = var3(1)
	var7.sym[1].sectidx = var4(4)
	var7.sym[1].size = var5(#arg2)
	var7.sym[1].info = 17
	var7.sect[2].type = var3(3)
	var7.sect[2].ofs = var5(var11)
	var7.sect[2].size = var5(var12)
	var7.sect[3].type = var3(3)
	var7.sect[3].ofs = var5(var11 + var12)
	var7.sect[3].size = var5(#var0 + 1)

	arg3.copy(var7.space + var12 + 1, var0)

	local var14 = var12 + #var0 + 2

	var7.sect[4].type = var3(1)
	var7.sect[4].flags = var5(2)
	var7.sect[4].ofs = var5(var11 + var14)
	var7.sect[4].size = var5(#arg2)
	var7.sect[5].type = var3(1)
	var7.sect[5].ofs = var5(var11 + var14 + #arg2)

	local var15 = var6(arg1, "wb")

	var15:write(arg3.string(var7, arg3.sizeof(var7) - 4096 + var14))
	var14(var15, arg1, arg2)
end

local function var18(arg0, arg1, arg2, arg3)
	arg3.cdef("typedef struct {\n  uint16_t arch, nsects;\n  uint32_t time, symtabofs, nsyms;\n  uint16_t opthdrsz, flags;\n} PEheader;\ntypedef struct {\n  char name[8];\n  uint32_t vsize, vaddr, size, ofs, relocofs, lineofs;\n  uint16_t nreloc, nline;\n  uint32_t flags;\n} PEsection;\ntypedef struct __attribute((packed)) {\n  union {\n    char name[8];\n    uint32_t nameref[2];\n  };\n  uint32_t value;\n  int16_t sect;\n  uint16_t type;\n  uint8_t scl, naux;\n} PEsym;\ntypedef struct __attribute((packed)) {\n  uint32_t size;\n  uint16_t nreloc, nline;\n  uint32_t cksum;\n  uint16_t assoc;\n  uint8_t comdatsel, unused[3];\n} PEsymaux;\ntypedef struct {\n  PEheader hdr;\n  PEsection sect[2];\n  // Must be an even number of symbol structs.\n  PEsym sym0;\n  PEsymaux sym0aux;\n  PEsym sym1;\n  PEsymaux sym1aux;\n  PEsym sym2;\n  PEsym sym3;\n  uint32_t strtabsize;\n  uint8_t space[4096];\n} PEobj;\n")

	local var0 = var2 .. arg0.modname
	local var1 = false

	if arg0.arch == "x86" then
		var0 = "_" .. var0
	elseif arg0.arch == "x64" then
		local var2 = true
	end

	local var3 = "   /EXPORT:" .. var0 .. ",DATA "

	local function var4(arg0)
		return arg0
	end

	local var5 = var4

	if arg3.abi("be") then
		var4 = var1.bswap

		function var5(arg0)
			return var1.rshift(var1.bswap(arg0), 16)
		end
	end

	local var6 = arg3.new("PEobj")
	local var7 = var6.hdr

	var7.arch = var5(({
		ppc = 498,
		arm = 448,
		mips = 870,
		mipsel = 870,
		x64 = 34404,
		x86 = 332
	})[arg0.arch])
	var7.nsects = var5(2)
	var7.symtabofs = var4(arg3.offsetof(var6, "sym0"))
	var7.nsyms = var4(6)
	var6.sect[0].name = ".drectve"
	var6.sect[0].size = var4(#var3)
	var6.sect[0].flags = var4(1051136)
	var6.sym0.sect = var5(1)
	var6.sym0.scl = 3
	var6.sym0.name = ".drectve"
	var6.sym0.naux = 1
	var6.sym0aux.size = var4(#var3)
	var6.sect[1].name = ".rdata"
	var6.sect[1].size = var4(#arg2)
	var6.sect[1].flags = var4(1076887616)
	var6.sym1.sect = var5(2)
	var6.sym1.scl = 3
	var6.sym1.name = ".rdata"
	var6.sym1.naux = 1
	var6.sym1aux.size = var4(#arg2)
	var6.sym2.sect = var5(2)
	var6.sym2.scl = 2
	var6.sym2.nameref[1] = var4(4)
	var6.sym3.sect = var5(-1)
	var6.sym3.scl = 2
	var6.sym3.value = var4(1)
	var6.sym3.name = "@feat.00"

	arg3.copy(var6.space, var0)

	local var8 = #var0 + 1

	var6.strtabsize = var4(var8 + 4)
	var6.sect[0].ofs = var4(arg3.offsetof(var6, "space") + var8)

	arg3.copy(var6.space + var8, var3)

	local var9 = var8 + #var3

	var6.sect[1].ofs = var4(arg3.offsetof(var6, "space") + var9)

	local var10 = var6(arg1, "wb")

	var10:write(arg3.string(var6, arg3.sizeof(var6) - 4096 + var9))
	var14(var10, arg1, arg2)
end

local function var19(arg0, arg1, arg2, arg3)
	arg3.cdef("typedef struct\n{\n  uint32_t magic, cputype, cpusubtype, filetype, ncmds, sizeofcmds, flags;\n} mach_header;\ntypedef struct\n{\n  mach_header; uint32_t reserved;\n} mach_header_64;\ntypedef struct {\n  uint32_t cmd, cmdsize;\n  char segname[16];\n  uint32_t vmaddr, vmsize, fileoff, filesize;\n  uint32_t maxprot, initprot, nsects, flags;\n} mach_segment_command;\ntypedef struct {\n  uint32_t cmd, cmdsize;\n  char segname[16];\n  uint64_t vmaddr, vmsize, fileoff, filesize;\n  uint32_t maxprot, initprot, nsects, flags;\n} mach_segment_command_64;\ntypedef struct {\n  char sectname[16], segname[16];\n  uint32_t addr, size;\n  uint32_t offset, align, reloff, nreloc, flags;\n  uint32_t reserved1, reserved2;\n} mach_section;\ntypedef struct {\n  char sectname[16], segname[16];\n  uint64_t addr, size;\n  uint32_t offset, align, reloff, nreloc, flags;\n  uint32_t reserved1, reserved2, reserved3;\n} mach_section_64;\ntypedef struct {\n  uint32_t cmd, cmdsize, symoff, nsyms, stroff, strsize;\n} mach_symtab_command;\ntypedef struct {\n  int32_t strx;\n  uint8_t type, sect;\n  int16_t desc;\n  uint32_t value;\n} mach_nlist;\ntypedef struct {\n  uint32_t strx;\n  uint8_t type, sect;\n  uint16_t desc;\n  uint64_t value;\n} mach_nlist_64;\ntypedef struct\n{\n  uint32_t magic, nfat_arch;\n} mach_fat_header;\ntypedef struct\n{\n  uint32_t cputype, cpusubtype, offset, size, align;\n} mach_fat_arch;\ntypedef struct {\n  struct {\n    mach_header hdr;\n    mach_segment_command seg;\n    mach_section sec;\n    mach_symtab_command sym;\n  } arch[1];\n  mach_nlist sym_entry;\n  uint8_t space[4096];\n} mach_obj;\ntypedef struct {\n  struct {\n    mach_header_64 hdr;\n    mach_segment_command_64 seg;\n    mach_section_64 sec;\n    mach_symtab_command sym;\n  } arch[1];\n  mach_nlist_64 sym_entry;\n  uint8_t space[4096];\n} mach_obj_64;\ntypedef struct {\n  mach_fat_header fat;\n  mach_fat_arch fat_arch[2];\n  struct {\n    mach_header hdr;\n    mach_segment_command seg;\n    mach_section sec;\n    mach_symtab_command sym;\n  } arch[2];\n  mach_nlist sym_entry;\n  uint8_t space[4096];\n} mach_fat_obj;\n")

	local var0 = "_" .. var2 .. arg0.modname
	local var1 = false
	local var2 = false
	local var3 = 4
	local var4 = "mach_obj"

	if arg0.arch == "x64" then
		var2, var3, var4 = true, 8, "mach_obj_64"
	elseif arg0.arch == "arm" then
		var1, var4 = true, "mach_fat_obj"
	elseif arg0.arch == "arm64" then
		var2, var3, var1, var4 = true, 8, true, "mach_fat_obj"
	else
		var4(arg0.arch == "x86", "unsupported architecture for OSX")
	end

	local function var5(arg0, arg1)
		return var1.band(arg0 + arg1 - 1, -arg1)
	end

	local var6 = var1.bswap
	local var7 = arg3.new(var4)
	local var8 = var5(arg3.offsetof(var7, "space") + #var0 + 2, var3)
	local var9 = ({
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
	})[arg0.arch]
	local var10 = ({
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
	})[arg0.arch]

	if var1 then
		var7.fat.magic = var6(3405691582)
		var7.fat.nfat_arch = var6(#var10)
	end

	for iter0 = 0, #var10 - 1 do
		local var11 = 0

		if var1 then
			local var12 = var7.fat_arch[iter0]

			var12.cputype = var6(var9[iter0 + 1])
			var12.cpusubtype = var6(var10[iter0 + 1])
			var11 = arg3.offsetof(var7, "arch") + iter0 * arg3.sizeof(var7.arch[0])
			var12.offset = var6(var11)
			var12.size = var6(var8 - var11 + #arg2)
		end

		local var13 = var7.arch[iter0]

		var13.hdr.magic = var2 and 4277009103 or 4277009102
		var13.hdr.cputype = var9[iter0 + 1]
		var13.hdr.cpusubtype = var10[iter0 + 1]
		var13.hdr.filetype = 1
		var13.hdr.ncmds = 2
		var13.hdr.sizeofcmds = arg3.sizeof(var13.seg) + arg3.sizeof(var13.sec) + arg3.sizeof(var13.sym)
		var13.seg.cmd = var2 and 25 or 1
		var13.seg.cmdsize = arg3.sizeof(var13.seg) + arg3.sizeof(var13.sec)
		var13.seg.vmsize = #arg2
		var13.seg.fileoff = var8 - var11
		var13.seg.filesize = #arg2
		var13.seg.maxprot = 1
		var13.seg.initprot = 1
		var13.seg.nsects = 1

		arg3.copy(var13.sec.sectname, "__data")
		arg3.copy(var13.sec.segname, "__DATA")

		var13.sec.size = #arg2
		var13.sec.offset = var8 - var11
		var13.sym.cmd = 2
		var13.sym.cmdsize = arg3.sizeof(var13.sym)
		var13.sym.symoff = arg3.offsetof(var7, "sym_entry") - var11
		var13.sym.nsyms = 1
		var13.sym.stroff = arg3.offsetof(var7, "sym_entry") + arg3.sizeof(var7.sym_entry) - var11
		var13.sym.strsize = var5(#var0 + 2, var3)
	end

	var7.sym_entry.type = 15
	var7.sym_entry.sect = 1
	var7.sym_entry.strx = 1

	arg3.copy(var7.space + 1, var0)

	local var14 = var6(arg1, "wb")

	var14:write(arg3.string(var7, var8))
	var14(var14, arg1, arg2)
end

local function var20(arg0, arg1, arg2)
	local var0, var1 = pcall(require, "ffi")

	var4(var0, "FFI library required to write this file type")

	if arg0.os == "windows" then
		return var18(arg0, arg1, arg2, var1)
	elseif arg0.os == "osx" then
		return var19(arg0, arg1, arg2, var1)
	else
		return var17(arg0, arg1, arg2, var1)
	end
end

local function var21(arg0, arg1)
	local var0 = var5(arg0)

	require("jit.bc").dump(var0, var6(arg1, "w"), true)
end

local function var22(arg0, arg1, arg2)
	local var0 = var5(arg1)
	local var1 = string.dump(var0, arg0.strip)
	local var2 = arg0.type

	if not var2 then
		var2 = var11(arg2)
		arg0.type = var2
	end

	if var2 == "raw" then
		var15(arg2, var1)
	else
		if not arg0.modname then
			arg0.modname = var13(arg1)
		end

		if var2 == "obj" then
			var20(arg0, arg2, var1)
		else
			var16(arg0, arg2, var1)
		end
	end
end

local function var23(...)
	local var0 = {
		...
	}
	local var1 = 1
	local var2 = false
	local var3 = {
		type = false,
		strip = true,
		modname = false,
		arch = var0.arch,
		os = string.lower(var0.os)
	}

	while var1 <= #var0 do
		local var4 = var0[var1]

		if type(var4) == "string" and string.sub(var4, 1, 1) == "-" and var4 ~= "-" then
			table.remove(var0, var1)

			if var4 == "--" then
				break
			end

			for iter0 = 2, #var4 do
				local var5 = string.sub(var4, iter0, iter0)

				if var5 == "l" then
					var2 = true
				elseif var5 == "s" then
					var3.strip = true
				elseif var5 == "g" then
					var3.strip = false
				else
					if var0[var1] == nil or iter0 ~= #var4 then
						var3()
					end

					if var5 == "e" then
						if var1 ~= 1 then
							var3()
						end

						var0[1] = var4(loadstring(var0[1]))
					elseif var5 == "n" then
						var3.modname = var12(table.remove(var0, var1))
					elseif var5 == "t" then
						var3.type = var10(table.remove(var0, var1), var7, "file type")
					elseif var5 == "a" then
						var3.arch = var10(table.remove(var0, var1), var8, "architecture")
					elseif var5 == "o" then
						var3.os = var10(table.remove(var0, var1), var9, "OS name")
					else
						var3()
					end
				end
			end
		else
			var1 = var1 + 1
		end
	end

	if var2 then
		if #var0 == 0 or #var0 > 2 then
			var3()
		end

		var21(var0[1], var0[2] or "-")
	else
		if #var0 ~= 2 then
			var3()
		end

		var22(var3, var0[1], var0[2])
	end
end

return {
	start = var23
}
