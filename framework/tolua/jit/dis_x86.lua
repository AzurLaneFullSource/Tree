local var0 = type
local var1 = string.sub
local var2 = string.byte
local var3 = string.format
local var4 = string.match
local var5 = string.gmatch
local var6 = string.gsub
local var7 = string.lower
local var8 = string.rep
local var9 = require("bit").tohex
local var10 = {
	[0] = "addBmr",
	"addVmr",
	"addBrm",
	"addVrm",
	"addBai",
	"addVai",
	"push es",
	"pop es",
	"orBmr",
	"orVmr",
	"orBrm",
	"orVrm",
	"orBai",
	"orVai",
	"push cs",
	"opc2*",
	"adcBmr",
	"adcVmr",
	"adcBrm",
	"adcVrm",
	"adcBai",
	"adcVai",
	"push ss",
	"pop ss",
	"sbbBmr",
	"sbbVmr",
	"sbbBrm",
	"sbbVrm",
	"sbbBai",
	"sbbVai",
	"push ds",
	"pop ds",
	"andBmr",
	"andVmr",
	"andBrm",
	"andVrm",
	"andBai",
	"andVai",
	"es:seg",
	"daa",
	"subBmr",
	"subVmr",
	"subBrm",
	"subVrm",
	"subBai",
	"subVai",
	"cs:seg",
	"das",
	"xorBmr",
	"xorVmr",
	"xorBrm",
	"xorVrm",
	"xorBai",
	"xorVai",
	"ss:seg",
	"aaa",
	"cmpBmr",
	"cmpVmr",
	"cmpBrm",
	"cmpVrm",
	"cmpBai",
	"cmpVai",
	"ds:seg",
	"aas",
	"incVR",
	"incVR",
	"incVR",
	"incVR",
	"incVR",
	"incVR",
	"incVR",
	"incVR",
	"decVR",
	"decVR",
	"decVR",
	"decVR",
	"decVR",
	"decVR",
	"decVR",
	"decVR",
	"pushUR",
	"pushUR",
	"pushUR",
	"pushUR",
	"pushUR",
	"pushUR",
	"pushUR",
	"pushUR",
	"popUR",
	"popUR",
	"popUR",
	"popUR",
	"popUR",
	"popUR",
	"popUR",
	"popUR",
	"sz*pushaw,pusha",
	"sz*popaw,popa",
	"boundVrm",
	"arplWmr",
	"fs:seg",
	"gs:seg",
	"o16:",
	"a16",
	"pushUi",
	"imulVrmi",
	"pushBs",
	"imulVrms",
	"insb",
	"insVS",
	"outsb",
	"outsVS",
	"joBj",
	"jnoBj",
	"jbBj",
	"jnbBj",
	"jzBj",
	"jnzBj",
	"jbeBj",
	"jaBj",
	"jsBj",
	"jnsBj",
	"jpeBj",
	"jpoBj",
	"jlBj",
	"jgeBj",
	"jleBj",
	"jgBj",
	"arith!Bmi",
	"arith!Vmi",
	"arith!Bmi",
	"arith!Vms",
	"testBmr",
	"testVmr",
	"xchgBrm",
	"xchgVrm",
	"movBmr",
	"movVmr",
	"movBrm",
	"movVrm",
	"movVmg",
	"leaVrm",
	"movWgm",
	"popUm",
	"nop*xchgVaR|pause|xchgWaR|repne nop",
	"xchgVaR",
	"xchgVaR",
	"xchgVaR",
	"xchgVaR",
	"xchgVaR",
	"xchgVaR",
	"xchgVaR",
	"sz*cbw,cwde,cdqe",
	"sz*cwd,cdq,cqo",
	"call farViw",
	"wait",
	"sz*pushfw,pushf",
	"sz*popfw,popf",
	"sahf",
	"lahf",
	"movBao",
	"movVao",
	"movBoa",
	"movVoa",
	"movsb",
	"movsVS",
	"cmpsb",
	"cmpsVS",
	"testBai",
	"testVai",
	"stosb",
	"stosVS",
	"lodsb",
	"lodsVS",
	"scasb",
	"scasVS",
	"movBRi",
	"movBRi",
	"movBRi",
	"movBRi",
	"movBRi",
	"movBRi",
	"movBRi",
	"movBRi",
	"movVRI",
	"movVRI",
	"movVRI",
	"movVRI",
	"movVRI",
	"movVRI",
	"movVRI",
	"movVRI",
	"shift!Bmu",
	"shift!Vmu",
	"retBw",
	"ret",
	"vex*3$lesVrm",
	"vex*2$ldsVrm",
	"movBmi",
	"movVmi",
	"enterBwu",
	"leave",
	"retfBw",
	"retf",
	"int3",
	"intBu",
	"into",
	"iretVS",
	"shift!Bm1",
	"shift!Vm1",
	"shift!Bmc",
	"shift!Vmc",
	"aamBu",
	"aadBu",
	"salc",
	"xlatb",
	"fp*0",
	"fp*1",
	"fp*2",
	"fp*3",
	"fp*4",
	"fp*5",
	"fp*6",
	"fp*7",
	"loopneBj",
	"loopeBj",
	"loopBj",
	"sz*jcxzBj,jecxzBj,jrcxzBj",
	"inBau",
	"inVau",
	"outBua",
	"outVua",
	"callVj",
	"jmpVj",
	"jmp farViw",
	"jmpBj",
	"inBad",
	"inVad",
	"outBda",
	"outVda",
	"lock:",
	"int1",
	"repne:rep",
	"rep:",
	"hlt",
	"cmc",
	"testb!Bm",
	"testv!Vm",
	"clc",
	"stc",
	"cli",
	"sti",
	"cld",
	"std",
	"incb!Bm",
	"incd!Vm"
}

assert(#var10 == 255)

local var11 = setmetatable({
	[96] = false,
	[69] = "rex*rb",
	[130] = false,
	[66] = "rex*x",
	[30] = false,
	[97] = false,
	[197] = "vex*2",
	[22] = false,
	[70] = "rex*rx",
	[206] = false,
	[72] = "rex*w",
	[68] = "rex*r",
	[79] = "rex*wrxb",
	[103] = "a32:",
	[65] = "rex*b",
	[71] = "rex*rxb",
	[6] = false,
	[99] = "movsxdVrDmt",
	[7] = false,
	[74] = "rex*wx",
	[196] = "vex*3",
	[75] = "rex*wxb",
	[154] = false,
	[14] = false,
	[73] = "rex*wb",
	[78] = "rex*wrx",
	[39] = false,
	[47] = false,
	[76] = "rex*wr",
	[55] = false,
	[77] = "rex*wrb",
	[63] = false,
	[214] = false,
	[212] = false,
	[23] = false,
	[213] = false,
	[98] = false,
	[64] = "rex*",
	[234] = false,
	[31] = false,
	[67] = "rex*xb"
}, {
	__index = var10
})
local var12 = {
	[0] = "sldt!Dmp",
	"sgdt!Ump",
	"larVrm",
	"lslVrm",
	nil,
	"syscall",
	"clts",
	"sysret",
	"invd",
	"wbinvd",
	nil,
	"ud1",
	nil,
	"$prefetch!Bm",
	"femms",
	"3dnowMrmu",
	"movupsXrm|movssXrvm|movupdXrm|movsdXrvm",
	"movupsXmr|movssXmvr|movupdXmr|movsdXmvr",
	"movhlpsXrm$movlpsXrm|movsldupXrm|movlpdXrm|movddupXrm",
	"movlpsXmr||movlpdXmr",
	"unpcklpsXrvm||unpcklpdXrvm",
	"unpckhpsXrvm||unpckhpdXrvm",
	"movlhpsXrm$movhpsXrm|movshdupXrm|movhpdXrm",
	"movhpsXmr||movhpdXmr",
	"$prefetcht!Bm",
	"hintnopVm",
	"hintnopVm",
	"hintnopVm",
	"hintnopVm",
	"hintnopVm",
	"hintnopVm",
	"hintnopVm",
	"movUmx$",
	"movUmy$",
	"movUxm$",
	"movUym$",
	"movUmz$",
	nil,
	"movUzm$",
	nil,
	"movapsXrm||movapdXrm",
	"movapsXmr||movapdXmr",
	"cvtpi2psXrMm|cvtsi2ssXrvVmt|cvtpi2pdXrMm|cvtsi2sdXrvVmt",
	"movntpsXmr|movntssXmr|movntpdXmr|movntsdXmr",
	"cvttps2piMrXm|cvttss2siVrXm|cvttpd2piMrXm|cvttsd2siVrXm",
	"cvtps2piMrXm|cvtss2siVrXm|cvtpd2piMrXm|cvtsd2siVrXm",
	"ucomissXrm||ucomisdXrm",
	"comissXrm||comisdXrm",
	"wrmsr",
	"rdtsc",
	"rdmsr",
	"rdpmc",
	"sysenter",
	"sysexit",
	nil,
	"getsec",
	"opc3*38",
	nil,
	"opc3*3a",
	nil,
	nil,
	nil,
	nil,
	nil,
	"cmovoVrm",
	"cmovnoVrm",
	"cmovbVrm",
	"cmovnbVrm",
	"cmovzVrm",
	"cmovnzVrm",
	"cmovbeVrm",
	"cmovaVrm",
	"cmovsVrm",
	"cmovnsVrm",
	"cmovpeVrm",
	"cmovpoVrm",
	"cmovlVrm",
	"cmovgeVrm",
	"cmovleVrm",
	"cmovgVrm",
	"movmskpsVrXm$||movmskpdVrXm$",
	"sqrtpsXrm|sqrtssXrm|sqrtpdXrm|sqrtsdXrm",
	"rsqrtpsXrm|rsqrtssXrvm",
	"rcppsXrm|rcpssXrvm",
	"andpsXrvm||andpdXrvm",
	"andnpsXrvm||andnpdXrvm",
	"orpsXrvm||orpdXrvm",
	"xorpsXrvm||xorpdXrvm",
	"addpsXrvm|addssXrvm|addpdXrvm|addsdXrvm",
	"mulpsXrvm|mulssXrvm|mulpdXrvm|mulsdXrvm",
	"cvtps2pdXrm|cvtss2sdXrvm|cvtpd2psXrm|cvtsd2ssXrvm",
	"cvtdq2psXrm|cvttps2dqXrm|cvtps2dqXrm",
	"subpsXrvm|subssXrvm|subpdXrvm|subsdXrvm",
	"minpsXrvm|minssXrvm|minpdXrvm|minsdXrvm",
	"divpsXrvm|divssXrvm|divpdXrvm|divsdXrvm",
	"maxpsXrvm|maxssXrvm|maxpdXrvm|maxsdXrvm",
	"punpcklbwPrvm",
	"punpcklwdPrvm",
	"punpckldqPrvm",
	"packsswbPrvm",
	"pcmpgtbPrvm",
	"pcmpgtwPrvm",
	"pcmpgtdPrvm",
	"packuswbPrvm",
	"punpckhbwPrvm",
	"punpckhwdPrvm",
	"punpckhdqPrvm",
	"packssdwPrvm",
	"||punpcklqdqXrvm",
	"||punpckhqdqXrvm",
	"movPrVSm",
	"movqMrm|movdquXrm|movdqaXrm",
	"pshufwMrmu|pshufhwXrmu|pshufdXrmu|pshuflwXrmu",
	"pshiftw!Pvmu",
	"pshiftd!Pvmu",
	"pshiftq!Mvmu||pshiftdq!Xvmu",
	"pcmpeqbPrvm",
	"pcmpeqwPrvm",
	"pcmpeqdPrvm",
	"emms*|",
	"vmreadUmr||extrqXmuu$|insertqXrmuu$",
	"vmwriteUrm||extrqXrm$|insertqXrm$",
	nil,
	nil,
	"||haddpdXrvm|haddpsXrvm",
	"||hsubpdXrvm|hsubpsXrvm",
	"movVSmMr|movqXrm|movVSmXr",
	"movqMmr|movdquXmr|movdqaXmr",
	"joVj",
	"jnoVj",
	"jbVj",
	"jnbVj",
	"jzVj",
	"jnzVj",
	"jbeVj",
	"jaVj",
	"jsVj",
	"jnsVj",
	"jpeVj",
	"jpoVj",
	"jlVj",
	"jgeVj",
	"jleVj",
	"jgVj",
	"setoBm",
	"setnoBm",
	"setbBm",
	"setnbBm",
	"setzBm",
	"setnzBm",
	"setbeBm",
	"setaBm",
	"setsBm",
	"setnsBm",
	"setpeBm",
	"setpoBm",
	"setlBm",
	"setgeBm",
	"setleBm",
	"setgBm",
	"push fs",
	"pop fs",
	"cpuid",
	"btVmr",
	"shldVmru",
	"shldVmrc",
	nil,
	nil,
	"push gs",
	"pop gs",
	"rsm",
	"btsVmr",
	"shrdVmru",
	"shrdVmrc",
	"fxsave!Dmp",
	"imulVrm",
	"cmpxchgBmr",
	"cmpxchgVmr",
	"$lssVrm",
	"btrVmr",
	"$lfsVrm",
	"$lgsVrm",
	"movzxVrBmt",
	"movzxVrWmt",
	"|popcntVrm",
	"ud2Dp",
	"bt!Vmu",
	"btcVmr",
	"bsfVrm",
	"bsrVrm|lzcntVrm|bsrWrm",
	"movsxVrBmt",
	"movsxVrWmt",
	"xaddBmr",
	"xaddVmr",
	"cmppsXrvmu|cmpssXrvmu|cmppdXrvmu|cmpsdXrvmu",
	"$movntiVmr|",
	"pinsrwPrvWmu",
	"pextrwDrPmu",
	"shufpsXrvmu||shufpdXrvmu",
	"$cmpxchg!Qmp",
	"bswapVR",
	"bswapVR",
	"bswapVR",
	"bswapVR",
	"bswapVR",
	"bswapVR",
	"bswapVR",
	"bswapVR",
	"||addsubpdXrvm|addsubpsXrvm",
	"psrlwPrvm",
	"psrldPrvm",
	"psrlqPrvm",
	"paddqPrvm",
	"pmullwPrvm",
	"|movq2dqXrMm|movqXmr|movdq2qMrXm$",
	"pmovmskbVrMm||pmovmskbVrXm",
	"psubusbPrvm",
	"psubuswPrvm",
	"pminubPrvm",
	"pandPrvm",
	"paddusbPrvm",
	"padduswPrvm",
	"pmaxubPrvm",
	"pandnPrvm",
	"pavgbPrvm",
	"psrawPrvm",
	"psradPrvm",
	"pavgwPrvm",
	"pmulhuwPrvm",
	"pmulhwPrvm",
	"|cvtdq2pdXrm|cvttpd2dqXrm|cvtpd2dqXrm",
	"$movntqMmr||$movntdqXmr",
	"psubsbPrvm",
	"psubswPrvm",
	"pminswPrvm",
	"porPrvm",
	"paddsbPrvm",
	"paddswPrvm",
	"pmaxswPrvm",
	"pxorPrvm",
	"|||lddquXrm",
	"psllwPrvm",
	"pslldPrvm",
	"psllqPrvm",
	"pmuludqPrvm",
	"pmaddwdPrvm",
	"psadbwPrvm",
	"maskmovqMrm||maskmovdquXrm$",
	"psubbPrvm",
	"psubwPrvm",
	"psubdPrvm",
	"psubqPrvm",
	"paddbPrvm",
	"paddwPrvm",
	"padddPrvm",
	"ud"
}

assert(var12[255] == "ud")

local var13 = {
	["38"] = {
		[0] = "pshufbPrvm",
		"phaddwPrvm",
		"phadddPrvm",
		"phaddswPrvm",
		"pmaddubswPrvm",
		"phsubwPrvm",
		"phsubdPrvm",
		"phsubswPrvm",
		"psignbPrvm",
		"psignwPrvm",
		"psigndPrvm",
		"pmulhrswPrvm",
		"||permilpsXrvm",
		"||permilpdXrvm",
		nil,
		nil,
		"||pblendvbXrma",
		nil,
		nil,
		nil,
		"||blendvpsXrma",
		"||blendvpdXrma",
		"||permpsXrvm",
		"||ptestXrm",
		"||broadcastssXrm",
		"||broadcastsdXrm",
		"||broadcastf128XrlXm",
		nil,
		"pabsbPrm",
		"pabswPrm",
		"pabsdPrm",
		nil,
		"||pmovsxbwXrm",
		"||pmovsxbdXrm",
		"||pmovsxbqXrm",
		"||pmovsxwdXrm",
		"||pmovsxwqXrm",
		"||pmovsxdqXrm",
		nil,
		nil,
		"||pmuldqXrvm",
		"||pcmpeqqXrvm",
		"||$movntdqaXrm",
		"||packusdwXrvm",
		"||maskmovpsXrvm",
		"||maskmovpdXrvm",
		"||maskmovpsXmvr",
		"||maskmovpdXmvr",
		"||pmovzxbwXrm",
		"||pmovzxbdXrm",
		"||pmovzxbqXrm",
		"||pmovzxwdXrm",
		"||pmovzxwqXrm",
		"||pmovzxdqXrm",
		"||permdXrvm",
		"||pcmpgtqXrvm",
		"||pminsbXrvm",
		"||pminsdXrvm",
		"||pminuwXrvm",
		"||pminudXrvm",
		"||pmaxsbXrvm",
		"||pmaxsdXrvm",
		"||pmaxuwXrvm",
		"||pmaxudXrvm",
		"||pmulddXrvm",
		"||phminposuwXrm",
		nil,
		nil,
		nil,
		"||psrlvVSXrvm",
		"||psravdXrvm",
		"||psllvVSXrvm",
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		"||pbroadcastdXrlXm",
		"||pbroadcastqXrlXm",
		"||broadcasti128XrlXm",
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		"||pbroadcastbXrlXm",
		"||pbroadcastwXrlXm",
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		"||pmaskmovXrvVSm",
		nil,
		"||pmaskmovVSmXvr",
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		"||aesencXrvm",
		"||aesenclastXrvm",
		"||aesdecXrvm",
		"||aesdeclastXrvm",
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		"|||crc32TrBmt",
		"|||crc32TrVmt",
		nil,
		nil,
		nil,
		nil,
		nil,
		"| sarxVrmv| shlxVrmv| shrxVrmv"
	},
	["3a"] = {
		[0] = "||permqXrmu",
		"||permpdXrmu",
		"||pblenddXrvmu",
		nil,
		"||permilpsXrmu",
		"||permilpdXrmu",
		"||perm2f128Xrvmu",
		nil,
		"||roundpsXrmu",
		"||roundpdXrmu",
		"||roundssXrvmu",
		"||roundsdXrvmu",
		"||blendpsXrvmu",
		"||blendpdXrvmu",
		"||pblendwXrvmu",
		"palignrPrvmu",
		nil,
		nil,
		nil,
		nil,
		"||pextrbVmXru",
		"||pextrwVmXru",
		"||pextrVmSXru",
		"||extractpsVmXru",
		"||insertf128XrvlXmu",
		"||extractf128XlXmYru",
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		"||pinsrbXrvVmu",
		"||insertpsXrvmu",
		"||pinsrXrvVmuS",
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		"||inserti128Xrvmu",
		"||extracti128XlXmYru",
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		"||dppsXrvmu",
		"||dppdXrvmu",
		"||mpsadbwXrvmu",
		nil,
		"||pclmulqdqXrvmu",
		nil,
		"||perm2i128Xrvmu",
		nil,
		nil,
		nil,
		"||blendvpsXrvmb",
		"||blendvpdXrvmb",
		"||pblendvbXrvmb",
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		"||pcmpestrmXrmu",
		"||pcmpestriXrmu",
		"||pcmpistrmXrmu",
		"||pcmpistriXrmu",
		[223] = "||aeskeygenassistXrmu",
		[240] = "||| rorxVrmu"
	}
}
local var14 = {
	[217] = "vmmcall",
	[194] = "vmlaunch",
	[222] = "skinit",
	[248] = "swapgs",
	[223] = "invlpga",
	[196] = "vmxoff",
	[220] = "stgi",
	[193] = "vmcall",
	[221] = "clgi",
	[195] = "vmresume",
	[218] = "vmload",
	[201] = "mwait",
	[219] = "vmsave",
	[200] = "monitor",
	[216] = "vmrun",
	[249] = "rdtscp"
}
local var15 = {
	[0] = "faddFm",
	"fmulFm",
	"fcomFm",
	"fcompFm",
	"fsubFm",
	"fsubrFm",
	"fdivFm",
	"fdivrFm",
	"fldFm",
	nil,
	"fstFm",
	"fstpFm",
	"fldenvVm",
	"fldcwWm",
	"fnstenvVm",
	"fnstcwWm",
	"fiaddDm",
	"fimulDm",
	"ficomDm",
	"ficompDm",
	"fisubDm",
	"fisubrDm",
	"fidivDm",
	"fidivrDm",
	"fildDm",
	"fisttpDm",
	"fistDm",
	"fistpDm",
	nil,
	"fld twordFmp",
	nil,
	"fstp twordFmp",
	"faddGm",
	"fmulGm",
	"fcomGm",
	"fcompGm",
	"fsubGm",
	"fsubrGm",
	"fdivGm",
	"fdivrGm",
	"fldGm",
	"fisttpQm",
	"fstGm",
	"fstpGm",
	"frstorDmp",
	nil,
	"fnsaveDmp",
	"fnstswWm",
	"fiaddWm",
	"fimulWm",
	"ficomWm",
	"ficompWm",
	"fisubWm",
	"fisubrWm",
	"fidivWm",
	"fidivrWm",
	"fildWm",
	"fisttpWm",
	"fistWm",
	"fistpWm",
	"fbld twordFmp",
	"fildQm",
	"fbstp twordFmp",
	"fistpQm",
	"faddFf",
	"fmulFf",
	"fcomFf",
	"fcompFf",
	"fsubFf",
	"fsubrFf",
	"fdivFf",
	"fdivrFf",
	"fldFf",
	"fxchFf",
	{
		"fnop"
	},
	nil,
	{
		"fchs",
		"fabs",
		nil,
		nil,
		"ftst",
		"fxam"
	},
	{
		"fld1",
		"fldl2t",
		"fldl2e",
		"fldpi",
		"fldlg2",
		"fldln2",
		"fldz"
	},
	{
		"f2xm1",
		"fyl2x",
		"fptan",
		"fpatan",
		"fxtract",
		"fprem1",
		"fdecstp",
		"fincstp"
	},
	{
		"fprem",
		"fyl2xp1",
		"fsqrt",
		"fsincos",
		"frndint",
		"fscale",
		"fsin",
		"fcos"
	},
	"fcmovbFf",
	"fcmoveFf",
	"fcmovbeFf",
	"fcmovuFf",
	nil,
	{
		nil,
		"fucompp"
	},
	nil,
	nil,
	"fcmovnbFf",
	"fcmovneFf",
	"fcmovnbeFf",
	"fcmovnuFf",
	{
		nil,
		nil,
		"fnclex",
		"fninit"
	},
	"fucomiFf",
	"fcomiFf",
	nil,
	"fadd toFf",
	"fmul toFf",
	nil,
	nil,
	"fsub toFf",
	"fsubr toFf",
	"fdivr toFf",
	"fdiv toFf",
	"ffreeFf",
	nil,
	"fstFf",
	"fstpFf",
	"fucomFf",
	"fucompFf",
	nil,
	nil,
	"faddpFf",
	"fmulpFf",
	nil,
	{
		nil,
		"fcompp"
	},
	"fsubrpFf",
	"fsubpFf",
	"fdivrpFf",
	"fdivpFf",
	nil,
	nil,
	nil,
	nil,
	{
		"fnstsw ax"
	},
	"fucomipFf",
	"fcomipFf"
}

assert(var15[126] == "fcomipFf")

local var16 = {
	arith = {
		"add",
		"or",
		"adc",
		"sbb",
		"and",
		"sub",
		"xor",
		"cmp"
	},
	shift = {
		"rol",
		"ror",
		"rcl",
		"rcr",
		"shl",
		"shr",
		"sal",
		"sar"
	},
	testb = {
		"testBmi",
		"testBmi",
		"not",
		"neg",
		"mul",
		"imul",
		"div",
		"idiv"
	},
	testv = {
		"testVmi",
		"testVmi",
		"not",
		"neg",
		"mul",
		"imul",
		"div",
		"idiv"
	},
	incb = {
		"inc",
		"dec"
	},
	incd = {
		"inc",
		"dec",
		"callUmp",
		"$call farDmp",
		"jmpUmp",
		"$jmp farDmp",
		"pushUm"
	},
	sldt = {
		"sldt",
		"str",
		"lldt",
		"ltr",
		"verr",
		"verw"
	},
	sgdt = {
		"vm*$sgdt",
		"vm*$sidt",
		"$lgdt",
		"vm*$lidt",
		"smsw",
		nil,
		"lmsw",
		"vm*$invlpg"
	},
	bt = {
		nil,
		nil,
		nil,
		nil,
		"bt",
		"bts",
		"btr",
		"btc"
	},
	cmpxchg = {
		nil,
		"sz*,cmpxchg8bQmp,cmpxchg16bXmp",
		nil,
		nil,
		nil,
		nil,
		"vmptrld|vmxon|vmclear",
		"vmptrst"
	},
	pshiftw = {
		nil,
		nil,
		"psrlw",
		nil,
		"psraw",
		nil,
		"psllw"
	},
	pshiftd = {
		nil,
		nil,
		"psrld",
		nil,
		"psrad",
		nil,
		"pslld"
	},
	pshiftq = {
		nil,
		nil,
		"psrlq",
		nil,
		nil,
		nil,
		"psllq"
	},
	pshiftdq = {
		nil,
		nil,
		"psrlq",
		"psrldq",
		nil,
		nil,
		"psllq",
		"pslldq"
	},
	fxsave = {
		"$fxsave",
		"$fxrstor",
		"$ldmxcsr",
		"$stmxcsr",
		nil,
		"lfenceDp$",
		"mfenceDp$",
		"sfenceDp$clflush"
	},
	prefetch = {
		"prefetch",
		"prefetchw"
	},
	prefetcht = {
		"prefetchnta",
		"prefetcht0",
		"prefetcht1",
		"prefetcht2"
	}
}
local var17 = {
	B = {
		"al",
		"cl",
		"dl",
		"bl",
		"ah",
		"ch",
		"dh",
		"bh",
		"r8b",
		"r9b",
		"r10b",
		"r11b",
		"r12b",
		"r13b",
		"r14b",
		"r15b"
	},
	B64 = {
		"al",
		"cl",
		"dl",
		"bl",
		"spl",
		"bpl",
		"sil",
		"dil",
		"r8b",
		"r9b",
		"r10b",
		"r11b",
		"r12b",
		"r13b",
		"r14b",
		"r15b"
	},
	W = {
		"ax",
		"cx",
		"dx",
		"bx",
		"sp",
		"bp",
		"si",
		"di",
		"r8w",
		"r9w",
		"r10w",
		"r11w",
		"r12w",
		"r13w",
		"r14w",
		"r15w"
	},
	D = {
		"eax",
		"ecx",
		"edx",
		"ebx",
		"esp",
		"ebp",
		"esi",
		"edi",
		"r8d",
		"r9d",
		"r10d",
		"r11d",
		"r12d",
		"r13d",
		"r14d",
		"r15d"
	},
	Q = {
		"rax",
		"rcx",
		"rdx",
		"rbx",
		"rsp",
		"rbp",
		"rsi",
		"rdi",
		"r8",
		"r9",
		"r10",
		"r11",
		"r12",
		"r13",
		"r14",
		"r15"
	},
	M = {
		"mm0",
		"mm1",
		"mm2",
		"mm3",
		"mm4",
		"mm5",
		"mm6",
		"mm7",
		"mm0",
		"mm1",
		"mm2",
		"mm3",
		"mm4",
		"mm5",
		"mm6",
		"mm7"
	},
	X = {
		"xmm0",
		"xmm1",
		"xmm2",
		"xmm3",
		"xmm4",
		"xmm5",
		"xmm6",
		"xmm7",
		"xmm8",
		"xmm9",
		"xmm10",
		"xmm11",
		"xmm12",
		"xmm13",
		"xmm14",
		"xmm15"
	},
	Y = {
		"ymm0",
		"ymm1",
		"ymm2",
		"ymm3",
		"ymm4",
		"ymm5",
		"ymm6",
		"ymm7",
		"ymm8",
		"ymm9",
		"ymm10",
		"ymm11",
		"ymm12",
		"ymm13",
		"ymm14",
		"ymm15"
	}
}
local var18 = {
	"es",
	"cs",
	"ss",
	"ds",
	"fs",
	"gs",
	"segr6",
	"segr7"
}
local var19 = {
	D = 4,
	M = 8,
	Y = 32,
	W = 2,
	Q = 8,
	X = 16,
	B = 1
}
local var20 = {
	G = "qword",
	F = "dword",
	M = "qword",
	Y = "yword",
	Q = "qword",
	X = "xword",
	D = "dword",
	W = "word",
	B = "byte"
}

local function var21(arg0, arg1, arg2)
	local var0 = arg0.code
	local var1 = arg0.pos
	local var2 = ""
	local var3 = arg0.hexdump

	if var3 > 0 then
		for iter0 = arg0.start, var1 - 1 do
			var2 = var2 .. var3("%02X", var2(var0, iter0, iter0))
		end

		if var3 < #var2 then
			var2 = var1(var2, 1, var3) .. ". "
		else
			var2 = var2 .. var8(" ", var3 - #var2 + 2)
		end
	end

	if arg2 then
		arg1 = arg1 .. " " .. arg2
	end

	if arg0.o16 then
		arg1 = "o16 " .. arg1
		arg0.o16 = false
	end

	if arg0.a32 then
		arg1 = "a32 " .. arg1
		arg0.a32 = false
	end

	if arg0.rep then
		arg1 = arg0.rep .. " " .. arg1
		arg0.rep = false
	end

	if arg0.rex then
		local var4 = (arg0.rexw and "w" or "") .. (arg0.rexr and "r" or "") .. (arg0.rexx and "x" or "") .. (arg0.rexb and "b" or "") .. (arg0.vexl and "l" or "")

		if arg0.vexv and arg0.vexv ~= 0 then
			var4 = var4 .. "v" .. arg0.vexv
		end

		if var4 ~= "" then
			arg1 = arg0.rex .. "." .. var4 .. " " .. var6(arg1, "^ ", "")
		elseif arg0.rex == "vex" then
			arg1 = var6("v" .. arg1, "^v ", "")
		end

		arg0.rexw = false
		arg0.rexr = false
		arg0.rexx = false
		arg0.rexb = false
		arg0.rex = false
		arg0.vexl = false
		arg0.vexv = false
	end

	if arg0.seg then
		local var5, var6 = var6(arg1, "%[", "[" .. arg0.seg .. ":")

		if var6 == 0 then
			arg1 = arg0.seg .. " " .. arg1
		else
			arg1 = var5
		end

		arg0.seg = false
	end

	if arg0.lock then
		arg1 = "lock " .. arg1
		arg0.lock = false
	end

	local var7 = arg0.imm

	if var7 then
		local var8 = arg0.symtab[var7]

		if var8 then
			arg1 = arg1 .. "\t->" .. var8
		end
	end

	arg0.out(var3("%08x  %s%s\n", arg0.addr + arg0.start, var2, arg1))

	arg0.mrm = false
	arg0.vexv = false
	arg0.start = var1
	arg0.imm = nil
end

local function var22(arg0)
	arg0.o16 = false
	arg0.seg = false
	arg0.lock = false
	arg0.rep = false
	arg0.rexw = false
	arg0.rexr = false
	arg0.rexx = false
	arg0.rexb = false
	arg0.rex = false
	arg0.a32 = false
	arg0.vexl = false
end

local function var23(arg0)
	arg0.pos = arg0.stop + 1

	var22(arg0)

	return var21(arg0, "(incomplete)")
end

local function var24(arg0)
	var22(arg0)

	return var21(arg0, "(unknown)")
end

local function var25(arg0, arg1, arg2)
	if arg1 + arg2 - 1 > arg0.stop then
		return var23(arg0)
	end

	local var0 = arg0.code

	if arg2 == 1 then
		return (var2(var0, arg1, arg1))
	elseif arg2 == 2 then
		local var1, var2 = var2(var0, arg1, arg1 + 1)

		return var1 + var2 * 256
	else
		local var3, var4, var5, var6 = var2(var0, arg1, arg1 + 3)
		local var7 = var3 + var4 * 256 + var5 * 65536 + var6 * 16777216

		arg0.imm = var7

		return var7
	end
end

local function var26(arg0, arg1, arg2)
	local var0
	local var1
	local var2
	local var3
	local var4
	local var5
	local var6
	local var7
	local var8
	local var9 = arg0.code
	local var10 = arg0.pos
	local var11 = arg0.stop
	local var12 = arg0.vexl

	for iter0 in var5(arg2, ".") do
		local var13

		if iter0 == "V" or iter0 == "U" then
			if arg0.rexw then
				var2 = "Q"
				arg0.rexw = false
			elseif arg0.o16 then
				var2 = "W"
				arg0.o16 = false
			else
				var2 = iter0 == "U" and arg0.x64 and "Q" or "D"
			end

			var1 = var17[var2]
		elseif iter0 == "T" then
			if arg0.rexw then
				var2 = "Q"
				arg0.rexw = false
			else
				var2 = "D"
			end

			var1 = var17[var2]
		elseif iter0 == "B" then
			var2 = "B"
			var1 = arg0.rex and var17.B64 or var17.B
		elseif var4(iter0, "[WDQMXYFG]") then
			var2 = iter0

			if var2 == "X" and var12 then
				var2 = "Y"
				arg0.vexl = false
			end

			var1 = var17[var2]
		elseif iter0 == "P" then
			var2 = arg0.o16 and "X" or "M"
			arg0.o16 = false

			if var2 == "X" and var12 then
				var2 = "Y"
				arg0.vexl = false
			end

			var1 = var17[var2]
		elseif iter0 == "S" then
			arg1 = arg1 .. var7(var2)
		elseif iter0 == "s" then
			local var14 = var25(arg0, var10, 1)

			if not var14 then
				return
			end

			var13 = var14 <= 127 and var3("+0x%02x", var14) or var3("-0x%02x", 256 - var14)
			var10 = var10 + 1
		elseif iter0 == "u" then
			local var15 = var25(arg0, var10, 1)

			if not var15 then
				return
			end

			var13 = var3("0x%02x", var15)
			var10 = var10 + 1
		elseif iter0 == "b" then
			local var16 = var25(arg0, var10, 1)

			if not var16 then
				return
			end

			var13 = var1[var16 / 16 + 1]
			var10 = var10 + 1
		elseif iter0 == "w" then
			local var17 = var25(arg0, var10, 2)

			if not var17 then
				return
			end

			var13 = var3("0x%x", var17)
			var10 = var10 + 2
		elseif iter0 == "o" then
			if arg0.x64 then
				local var18 = var25(arg0, var10, 4)

				if not var18 then
					return
				end

				local var19 = var25(arg0, var10 + 4, 4)

				if not var19 then
					return
				end

				var13 = var3("[0x%08x%08x]", var19, var18)
				var10 = var10 + 8
			else
				local var20 = var25(arg0, var10, 4)

				if not var20 then
					return
				end

				var13 = var3("[0x%08x]", var20)
				var10 = var10 + 4
			end
		elseif iter0 == "i" or iter0 == "I" then
			local var21 = var19[var2]

			if var21 == 8 and arg0.x64 and iter0 == "I" then
				local var22 = var25(arg0, var10, 4)

				if not var22 then
					return
				end

				local var23 = var25(arg0, var10 + 4, 4)

				if not var23 then
					return
				end

				var13 = var3("0x%08x%08x", var23, var22)
			else
				if var21 == 8 then
					var21 = 4
				end

				local var24 = var25(arg0, var10, var21)

				if not var24 then
					return
				end

				if var2 == "Q" and (var24 < 0 or var24 > 2147483647) then
					var24 = 4294967296 - var24
					var13 = var3(var24 > 65535 and "-0x%08x" or "-0x%x", var24)
				else
					var13 = var3(var24 > 65535 and "0x%08x" or "0x%x", var24)
				end
			end

			var10 = var10 + var21
		elseif iter0 == "j" then
			local var25 = var19[var2]

			if var25 == 8 then
				var25 = 4
			end

			local var26 = var25(arg0, var10, var25)

			if not var26 then
				return
			end

			if var2 == "B" and var26 > 127 then
				var26 = var26 - 256
			elseif var26 > 2147483647 then
				var26 = var26 - 4294967296
			end

			var10 = var10 + var25

			local var27 = var26 + var10 + arg0.addr

			if var27 > 4294967295 and not arg0.x64 then
				var27 = var27 - 4294967296
			end

			arg0.imm = var27

			if var2 == "W" then
				var13 = var3("word 0x%04x", var27 % 65536)
			elseif arg0.x64 then
				local var28 = var27 % 16777216

				var13 = var3("0x%02x%06x", (var27 - var28) / 16777216, var28)
			else
				var13 = "0x" .. var9(var27)
			end
		elseif iter0 == "R" then
			local var29 = var2(var9, var10 - 1, var10 - 1) % 8

			if arg0.rexb then
				var29 = var29 + 8
				arg0.rexb = false
			end

			var13 = var1[var29 + 1]
		elseif iter0 == "a" then
			var13 = var1[1]
		elseif iter0 == "c" then
			var13 = "cl"
		elseif iter0 == "d" then
			var13 = "dx"
		elseif iter0 == "1" then
			var13 = "1"
		else
			if not var3 then
				var3 = arg0.mrm

				if not var3 then
					if var11 < var10 then
						return var23(arg0)
					end

					var3 = var2(var9, var10, var10)
					var10 = var10 + 1
				end

				var5 = var3 % 8
				var3 = (var3 - var5) / 8
				var4 = var3 % 8
				var3 = (var3 - var4) / 8
				var8 = ""

				if var3 < 3 then
					if var5 == 4 then
						if var11 < var10 then
							return var23(arg0)
						end

						var6 = var2(var9, var10, var10)
						var10 = var10 + 1
						var5 = var6 % 8
						var6 = (var6 - var5) / 8
						var7 = var6 % 8
						var6 = (var6 - var7) / 8

						if arg0.rexx then
							var7 = var7 + 8
							arg0.rexx = false
						end

						if var7 == 4 then
							var7 = nil
						end
					end

					if var3 > 0 or var5 == 5 then
						local var30 = var3

						if var30 ~= 1 then
							var30 = 4
						end

						local var31 = var25(arg0, var10, var30)

						if not var31 then
							return
						end

						if var3 == 0 then
							var5 = nil
						end

						if var5 or var7 or not var6 and arg0.x64 and not arg0.a32 then
							if var30 == 1 and var31 > 127 then
								var8 = var3("-0x%x", 256 - var31)
							elseif var31 >= 0 and var31 <= 2147483647 then
								var8 = var3("+0x%x", var31)
							else
								var8 = var3("-0x%x", 4294967296 - var31)
							end
						else
							var8 = var3(arg0.x64 and not arg0.a32 and (not (var31 >= 0) or not (var31 <= 2147483647)) and "0xffffffff%08x" or "0x%08x", var31)
						end

						var10 = var10 + var30
					end
				end

				if var5 and arg0.rexb then
					var5 = var5 + 8
					arg0.rexb = false
				end

				if arg0.rexr then
					var4 = var4 + 8
					arg0.rexr = false
				end
			end

			if iter0 == "m" then
				if var3 == 3 then
					var13 = var1[var5 + 1]
				else
					local var32 = arg0.a32 and var17.D or arg0.aregs
					local var33 = ""
					local var34 = ""

					if var5 then
						var33 = var32[var5 + 1]
					elseif not var6 and arg0.x64 and not arg0.a32 then
						var33 = "rip"
					end

					arg0.a32 = false

					if var7 then
						if var5 then
							var33 = var33 .. "+"
						end

						var34 = var32[var7 + 1]

						if var6 > 0 then
							var34 = var34 .. "*" .. 2^var6
						end
					end

					var13 = var3("[%s%s%s]", var33, var34, var8)
				end

				if var3 < 3 and (not var4(arg2, "[aRrgp]") or var4(arg2, "t")) then
					var13 = var20[var2] .. " " .. var13
				end
			elseif iter0 == "r" then
				var13 = var1[var4 + 1]
			elseif iter0 == "g" then
				var13 = var18[var4 + 1]
			elseif iter0 == "p" then
				-- block empty
			elseif iter0 == "f" then
				var13 = "st" .. var5
			elseif iter0 == "x" then
				if var4 == 0 and arg0.lock and not arg0.x64 then
					var13 = "CR8"
					arg0.lock = false
				else
					var13 = "CR" .. var4
				end
			elseif iter0 == "v" then
				if arg0.vexv then
					var13 = var1[arg0.vexv + 1]
					arg0.vexv = false
				end
			elseif iter0 == "y" then
				var13 = "DR" .. var4
			elseif iter0 == "z" then
				var13 = "TR" .. var4
			elseif iter0 == "l" then
				var12 = false
			elseif iter0 == "t" then
				-- block empty
			else
				error("bad pattern `" .. arg2 .. "'")
			end
		end

		if var13 then
			var0 = var0 and var0 .. ", " .. var13 or var13
		end
	end

	arg0.pos = var10

	return var21(arg0, arg1, var0)
end

local var27

local function var28(arg0)
	local var0 = arg0.mrm

	if not var0 then
		local var1 = arg0.pos

		if var1 > arg0.stop then
			return nil
		end

		var0 = var2(arg0.code, var1, var1)
		arg0.pos = var1 + 1
		arg0.mrm = var0
	end

	return var0
end

local function var29(arg0, arg1, arg2)
	if not arg1 then
		return var24(arg0)
	end

	if var4(arg1, "%|") then
		local var0

		if arg0.rep then
			var0 = arg0.rep == "rep" and "%|([^%|]*)" or "%|[^%|]*%|[^%|]*%|([^%|]*)"
			arg0.rep = false
		elseif arg0.o16 then
			var0 = "%|[^%|]*%|([^%|]*)"
			arg0.o16 = false
		else
			var0 = "^[^%|]*"
		end

		arg1 = var4(arg1, var0)

		if not arg1 then
			return var24(arg0)
		end
	end

	if var4(arg1, "%$") then
		local var1 = var28(arg0)

		if not var1 then
			return var23(arg0)
		end

		arg1 = var4(arg1, var1 >= 192 and "^[^%$]*" or "%$(.*)")

		if arg1 == "" then
			return var24(arg0)
		end
	end

	if arg1 == "" then
		return var24(arg0)
	end

	local var2, var3 = var4(arg1, "^([a-z0-9 ]*)(.*)")

	if var3 == "" and arg2 then
		var3 = arg2
	end

	return var27[var1(var3, 1, 1)](arg0, var2, var3)
end

local function var30(arg0, arg1)
	local var0 = arg0.pos
	local var1 = arg1[var2(arg0.code, var0, var0)]

	arg0.pos = var0 + 1

	return var29(arg0, var1)
end

var27 = {
	[""] = function(arg0, arg1, arg2)
		return var21(arg0, arg1)
	end,
	B = var26,
	W = var26,
	D = var26,
	Q = var26,
	V = var26,
	U = var26,
	T = var26,
	M = var26,
	X = var26,
	P = var26,
	F = var26,
	G = var26,
	Y = var26,
	[":"] = function(arg0, arg1, arg2)
		arg0[arg2 == ":" and arg1 or var1(arg2, 2)] = arg1

		if arg0.pos - arg0.start > 5 then
			return var24(arg0)
		end
	end,
	["*"] = function(arg0, arg1, arg2)
		return var27[arg1](arg0, arg1, var1(arg2, 2))
	end,
	["!"] = function(arg0, arg1, arg2)
		local var0 = var28(arg0)

		if not var0 then
			return var23(arg0)
		end

		return var29(arg0, var16[arg1][(var0 - var0 % 8) / 8 % 8 + 1], var1(arg2, 2))
	end,
	sz = function(arg0, arg1, arg2)
		if arg0.o16 then
			arg0.o16 = false
		else
			arg2 = var4(arg2, ",(.*)")

			if arg0.rexw then
				local var0 = var4(arg2, ",(.*)")

				if var0 then
					arg2 = var0
					arg0.rexw = false
				end
			end
		end

		arg2 = var4(arg2, "^[^,]*")

		return var29(arg0, arg2)
	end,
	opc2 = function(arg0, arg1, arg2)
		return var30(arg0, var12)
	end,
	opc3 = function(arg0, arg1, arg2)
		return var30(arg0, var13[arg2])
	end,
	vm = function(arg0, arg1, arg2)
		return var29(arg0, var14[arg0.mrm])
	end,
	fp = function(arg0, arg1, arg2)
		local var0 = var28(arg0)

		if not var0 then
			return var23(arg0)
		end

		local var1 = var0 % 8
		local var2 = arg2 * 8 + (var0 - var1) / 8 % 8

		if var0 >= 192 then
			var2 = var2 + 64
		end

		local var3 = var15[var2]

		if var0(var3) == "table" then
			var3 = var3[var1 + 1]
		end

		return var29(arg0, var3)
	end,
	rex = function(arg0, arg1, arg2)
		if arg0.rex then
			return var24(arg0)
		end

		for iter0 in var5(arg2, ".") do
			arg0["rex" .. iter0] = true
		end

		arg0.rex = "rex"
	end,
	vex = function(arg0, arg1, arg2)
		if arg0.rex then
			return var24(arg0)
		end

		arg0.rex = "vex"

		local var0 = arg0.pos

		if arg0.mrm then
			arg0.mrm = nil
			var0 = var0 - 1
		end

		local var1 = var2(arg0.code, var0, var0)

		if not var1 then
			return var23(arg0)
		end

		local var2 = var0 + 1

		if var1 < 128 then
			arg0.rexr = true
		end

		local var3 = 1

		if arg2 == "3" then
			var3 = var1 % 32
			var1 = (var1 - var3) / 32

			local var4 = var1 % 2

			var1 = (var1 - var4) / 2

			if var4 == 0 then
				arg0.rexb = true
			end

			if var1 % 2 == 0 then
				arg0.rexx = true
			end

			var1 = var2(arg0.code, var2, var2)

			if not var1 then
				return var23(arg0)
			end

			var2 = var2 + 1

			if var1 >= 128 then
				arg0.rexw = true
			end
		end

		arg0.pos = var2

		local var5

		if var3 == 1 then
			var5 = var12
		elseif var3 == 2 then
			var5 = var13["38"]
		elseif var3 == 3 then
			var5 = var13["3a"]
		else
			return var24(arg0)
		end

		local var6 = var1 % 4
		local var7 = (var1 - var6) / 4

		if var6 == 1 then
			arg0.o16 = "o16"
		elseif var6 == 2 then
			arg0.rep = "rep"
		elseif var6 == 3 then
			arg0.rep = "repne"
		end

		local var8 = var7 % 2
		local var9 = (var7 - var8) / 2

		if var8 ~= 0 then
			arg0.vexl = true
		end

		arg0.vexv = (-1 - var9) % 16

		return var30(arg0, var5)
	end,
	nop = function(arg0, arg1, arg2)
		return var29(arg0, arg0.rex and arg2 or "nop")
	end,
	emms = function(arg0, arg1, arg2)
		if arg0.rex ~= "vex" then
			return var21(arg0, "emms")
		elseif arg0.vexl then
			arg0.vexl = false

			return var21(arg0, "zeroall")
		else
			return var21(arg0, "zeroupper")
		end
	end
}

local function var31(arg0, arg1, arg2)
	arg1 = arg1 or 0

	local var0 = arg2 and arg1 + arg2 or #arg0.code

	arg1 = arg1 + 1
	arg0.start = arg1
	arg0.pos = arg1
	arg0.stop = var0
	arg0.imm = nil
	arg0.mrm = false

	var22(arg0)

	while var0 >= arg0.pos do
		var30(arg0, arg0.map1)
	end

	if arg0.pos ~= arg0.start then
		var23(arg0)
	end
end

local function var32(arg0, arg1, arg2)
	local var0 = {
		code = arg0,
		addr = (arg1 or 0) - 1,
		out = arg2 or io.write,
		symtab = {},
		disass = var31
	}

	var0.hexdump = 16
	var0.x64 = false
	var0.map1 = var10
	var0.aregs = var17.D

	return var0
end

local function var33(arg0, arg1, arg2)
	local var0 = var32(arg0, arg1, arg2)

	var0.x64 = true
	var0.map1 = var11
	var0.aregs = var17.Q

	return var0
end

local function var34(arg0, arg1, arg2)
	var32(arg0, arg1, arg2):disass()
end

local function var35(arg0, arg1, arg2)
	var33(arg0, arg1, arg2):disass()
end

local function var36(arg0)
	if arg0 < 8 then
		return var17.D[arg0 + 1]
	end

	return var17.X[arg0 - 7]
end

local function var37(arg0)
	if arg0 < 16 then
		return var17.Q[arg0 + 1]
	end

	return var17.X[arg0 - 15]
end

return {
	create = var32,
	create64 = var33,
	disass = var34,
	disass64 = var35,
	regname = var36,
	regname64 = var37
}
