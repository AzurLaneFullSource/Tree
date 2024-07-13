local var0_0 = type
local var1_0 = string.sub
local var2_0 = string.byte
local var3_0 = string.format
local var4_0 = string.match
local var5_0 = string.gmatch
local var6_0 = string.gsub
local var7_0 = string.lower
local var8_0 = string.rep
local var9_0 = require("bit").tohex
local var10_0 = {
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

assert(#var10_0 == 255)

local var11_0 = setmetatable({
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
	__index = var10_0
})
local var12_0 = {
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

assert(var12_0[255] == "ud")

local var13_0 = {
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
local var14_0 = {
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
local var15_0 = {
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

assert(var15_0[126] == "fcomipFf")

local var16_0 = {
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
local var17_0 = {
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
local var18_0 = {
	"es",
	"cs",
	"ss",
	"ds",
	"fs",
	"gs",
	"segr6",
	"segr7"
}
local var19_0 = {
	D = 4,
	M = 8,
	Y = 32,
	W = 2,
	Q = 8,
	X = 16,
	B = 1
}
local var20_0 = {
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

local function var21_0(arg0_1, arg1_1, arg2_1)
	local var0_1 = arg0_1.code
	local var1_1 = arg0_1.pos
	local var2_1 = ""
	local var3_1 = arg0_1.hexdump

	if var3_1 > 0 then
		for iter0_1 = arg0_1.start, var1_1 - 1 do
			var2_1 = var2_1 .. var3_0("%02X", var2_0(var0_1, iter0_1, iter0_1))
		end

		if var3_1 < #var2_1 then
			var2_1 = var1_0(var2_1, 1, var3_1) .. ". "
		else
			var2_1 = var2_1 .. var8_0(" ", var3_1 - #var2_1 + 2)
		end
	end

	if arg2_1 then
		arg1_1 = arg1_1 .. " " .. arg2_1
	end

	if arg0_1.o16 then
		arg1_1 = "o16 " .. arg1_1
		arg0_1.o16 = false
	end

	if arg0_1.a32 then
		arg1_1 = "a32 " .. arg1_1
		arg0_1.a32 = false
	end

	if arg0_1.rep then
		arg1_1 = arg0_1.rep .. " " .. arg1_1
		arg0_1.rep = false
	end

	if arg0_1.rex then
		local var4_1 = (arg0_1.rexw and "w" or "") .. (arg0_1.rexr and "r" or "") .. (arg0_1.rexx and "x" or "") .. (arg0_1.rexb and "b" or "") .. (arg0_1.vexl and "l" or "")

		if arg0_1.vexv and arg0_1.vexv ~= 0 then
			var4_1 = var4_1 .. "v" .. arg0_1.vexv
		end

		if var4_1 ~= "" then
			arg1_1 = arg0_1.rex .. "." .. var4_1 .. " " .. var6_0(arg1_1, "^ ", "")
		elseif arg0_1.rex == "vex" then
			arg1_1 = var6_0("v" .. arg1_1, "^v ", "")
		end

		arg0_1.rexw = false
		arg0_1.rexr = false
		arg0_1.rexx = false
		arg0_1.rexb = false
		arg0_1.rex = false
		arg0_1.vexl = false
		arg0_1.vexv = false
	end

	if arg0_1.seg then
		local var5_1, var6_1 = var6_0(arg1_1, "%[", "[" .. arg0_1.seg .. ":")

		if var6_1 == 0 then
			arg1_1 = arg0_1.seg .. " " .. arg1_1
		else
			arg1_1 = var5_1
		end

		arg0_1.seg = false
	end

	if arg0_1.lock then
		arg1_1 = "lock " .. arg1_1
		arg0_1.lock = false
	end

	local var7_1 = arg0_1.imm

	if var7_1 then
		local var8_1 = arg0_1.symtab[var7_1]

		if var8_1 then
			arg1_1 = arg1_1 .. "\t->" .. var8_1
		end
	end

	arg0_1.out(var3_0("%08x  %s%s\n", arg0_1.addr + arg0_1.start, var2_1, arg1_1))

	arg0_1.mrm = false
	arg0_1.vexv = false
	arg0_1.start = var1_1
	arg0_1.imm = nil
end

local function var22_0(arg0_2)
	arg0_2.o16 = false
	arg0_2.seg = false
	arg0_2.lock = false
	arg0_2.rep = false
	arg0_2.rexw = false
	arg0_2.rexr = false
	arg0_2.rexx = false
	arg0_2.rexb = false
	arg0_2.rex = false
	arg0_2.a32 = false
	arg0_2.vexl = false
end

local function var23_0(arg0_3)
	arg0_3.pos = arg0_3.stop + 1

	var22_0(arg0_3)

	return var21_0(arg0_3, "(incomplete)")
end

local function var24_0(arg0_4)
	var22_0(arg0_4)

	return var21_0(arg0_4, "(unknown)")
end

local function var25_0(arg0_5, arg1_5, arg2_5)
	if arg1_5 + arg2_5 - 1 > arg0_5.stop then
		return var23_0(arg0_5)
	end

	local var0_5 = arg0_5.code

	if arg2_5 == 1 then
		return (var2_0(var0_5, arg1_5, arg1_5))
	elseif arg2_5 == 2 then
		local var1_5, var2_5 = var2_0(var0_5, arg1_5, arg1_5 + 1)

		return var1_5 + var2_5 * 256
	else
		local var3_5, var4_5, var5_5, var6_5 = var2_0(var0_5, arg1_5, arg1_5 + 3)
		local var7_5 = var3_5 + var4_5 * 256 + var5_5 * 65536 + var6_5 * 16777216

		arg0_5.imm = var7_5

		return var7_5
	end
end

local function var26_0(arg0_6, arg1_6, arg2_6)
	local var0_6
	local var1_6
	local var2_6
	local var3_6
	local var4_6
	local var5_6
	local var6_6
	local var7_6
	local var8_6
	local var9_6 = arg0_6.code
	local var10_6 = arg0_6.pos
	local var11_6 = arg0_6.stop
	local var12_6 = arg0_6.vexl

	for iter0_6 in var5_0(arg2_6, ".") do
		local var13_6

		if iter0_6 == "V" or iter0_6 == "U" then
			if arg0_6.rexw then
				var2_6 = "Q"
				arg0_6.rexw = false
			elseif arg0_6.o16 then
				var2_6 = "W"
				arg0_6.o16 = false
			else
				var2_6 = iter0_6 == "U" and arg0_6.x64 and "Q" or "D"
			end

			var1_6 = var17_0[var2_6]
		elseif iter0_6 == "T" then
			if arg0_6.rexw then
				var2_6 = "Q"
				arg0_6.rexw = false
			else
				var2_6 = "D"
			end

			var1_6 = var17_0[var2_6]
		elseif iter0_6 == "B" then
			var2_6 = "B"
			var1_6 = arg0_6.rex and var17_0.B64 or var17_0.B
		elseif var4_0(iter0_6, "[WDQMXYFG]") then
			var2_6 = iter0_6

			if var2_6 == "X" and var12_6 then
				var2_6 = "Y"
				arg0_6.vexl = false
			end

			var1_6 = var17_0[var2_6]
		elseif iter0_6 == "P" then
			var2_6 = arg0_6.o16 and "X" or "M"
			arg0_6.o16 = false

			if var2_6 == "X" and var12_6 then
				var2_6 = "Y"
				arg0_6.vexl = false
			end

			var1_6 = var17_0[var2_6]
		elseif iter0_6 == "S" then
			arg1_6 = arg1_6 .. var7_0(var2_6)
		elseif iter0_6 == "s" then
			local var14_6 = var25_0(arg0_6, var10_6, 1)

			if not var14_6 then
				return
			end

			var13_6 = var14_6 <= 127 and var3_0("+0x%02x", var14_6) or var3_0("-0x%02x", 256 - var14_6)
			var10_6 = var10_6 + 1
		elseif iter0_6 == "u" then
			local var15_6 = var25_0(arg0_6, var10_6, 1)

			if not var15_6 then
				return
			end

			var13_6 = var3_0("0x%02x", var15_6)
			var10_6 = var10_6 + 1
		elseif iter0_6 == "b" then
			local var16_6 = var25_0(arg0_6, var10_6, 1)

			if not var16_6 then
				return
			end

			var13_6 = var1_6[var16_6 / 16 + 1]
			var10_6 = var10_6 + 1
		elseif iter0_6 == "w" then
			local var17_6 = var25_0(arg0_6, var10_6, 2)

			if not var17_6 then
				return
			end

			var13_6 = var3_0("0x%x", var17_6)
			var10_6 = var10_6 + 2
		elseif iter0_6 == "o" then
			if arg0_6.x64 then
				local var18_6 = var25_0(arg0_6, var10_6, 4)

				if not var18_6 then
					return
				end

				local var19_6 = var25_0(arg0_6, var10_6 + 4, 4)

				if not var19_6 then
					return
				end

				var13_6 = var3_0("[0x%08x%08x]", var19_6, var18_6)
				var10_6 = var10_6 + 8
			else
				local var20_6 = var25_0(arg0_6, var10_6, 4)

				if not var20_6 then
					return
				end

				var13_6 = var3_0("[0x%08x]", var20_6)
				var10_6 = var10_6 + 4
			end
		elseif iter0_6 == "i" or iter0_6 == "I" then
			local var21_6 = var19_0[var2_6]

			if var21_6 == 8 and arg0_6.x64 and iter0_6 == "I" then
				local var22_6 = var25_0(arg0_6, var10_6, 4)

				if not var22_6 then
					return
				end

				local var23_6 = var25_0(arg0_6, var10_6 + 4, 4)

				if not var23_6 then
					return
				end

				var13_6 = var3_0("0x%08x%08x", var23_6, var22_6)
			else
				if var21_6 == 8 then
					var21_6 = 4
				end

				local var24_6 = var25_0(arg0_6, var10_6, var21_6)

				if not var24_6 then
					return
				end

				if var2_6 == "Q" and (var24_6 < 0 or var24_6 > 2147483647) then
					var24_6 = 4294967296 - var24_6
					var13_6 = var3_0(var24_6 > 65535 and "-0x%08x" or "-0x%x", var24_6)
				else
					var13_6 = var3_0(var24_6 > 65535 and "0x%08x" or "0x%x", var24_6)
				end
			end

			var10_6 = var10_6 + var21_6
		elseif iter0_6 == "j" then
			local var25_6 = var19_0[var2_6]

			if var25_6 == 8 then
				var25_6 = 4
			end

			local var26_6 = var25_0(arg0_6, var10_6, var25_6)

			if not var26_6 then
				return
			end

			if var2_6 == "B" and var26_6 > 127 then
				var26_6 = var26_6 - 256
			elseif var26_6 > 2147483647 then
				var26_6 = var26_6 - 4294967296
			end

			var10_6 = var10_6 + var25_6

			local var27_6 = var26_6 + var10_6 + arg0_6.addr

			if var27_6 > 4294967295 and not arg0_6.x64 then
				var27_6 = var27_6 - 4294967296
			end

			arg0_6.imm = var27_6

			if var2_6 == "W" then
				var13_6 = var3_0("word 0x%04x", var27_6 % 65536)
			elseif arg0_6.x64 then
				local var28_6 = var27_6 % 16777216

				var13_6 = var3_0("0x%02x%06x", (var27_6 - var28_6) / 16777216, var28_6)
			else
				var13_6 = "0x" .. var9_0(var27_6)
			end
		elseif iter0_6 == "R" then
			local var29_6 = var2_0(var9_6, var10_6 - 1, var10_6 - 1) % 8

			if arg0_6.rexb then
				var29_6 = var29_6 + 8
				arg0_6.rexb = false
			end

			var13_6 = var1_6[var29_6 + 1]
		elseif iter0_6 == "a" then
			var13_6 = var1_6[1]
		elseif iter0_6 == "c" then
			var13_6 = "cl"
		elseif iter0_6 == "d" then
			var13_6 = "dx"
		elseif iter0_6 == "1" then
			var13_6 = "1"
		else
			if not var3_6 then
				var3_6 = arg0_6.mrm

				if not var3_6 then
					if var11_6 < var10_6 then
						return var23_0(arg0_6)
					end

					var3_6 = var2_0(var9_6, var10_6, var10_6)
					var10_6 = var10_6 + 1
				end

				var5_6 = var3_6 % 8
				var3_6 = (var3_6 - var5_6) / 8
				var4_6 = var3_6 % 8
				var3_6 = (var3_6 - var4_6) / 8
				var8_6 = ""

				if var3_6 < 3 then
					if var5_6 == 4 then
						if var11_6 < var10_6 then
							return var23_0(arg0_6)
						end

						var6_6 = var2_0(var9_6, var10_6, var10_6)
						var10_6 = var10_6 + 1
						var5_6 = var6_6 % 8
						var6_6 = (var6_6 - var5_6) / 8
						var7_6 = var6_6 % 8
						var6_6 = (var6_6 - var7_6) / 8

						if arg0_6.rexx then
							var7_6 = var7_6 + 8
							arg0_6.rexx = false
						end

						if var7_6 == 4 then
							var7_6 = nil
						end
					end

					if var3_6 > 0 or var5_6 == 5 then
						local var30_6 = var3_6

						if var30_6 ~= 1 then
							var30_6 = 4
						end

						local var31_6 = var25_0(arg0_6, var10_6, var30_6)

						if not var31_6 then
							return
						end

						if var3_6 == 0 then
							var5_6 = nil
						end

						if var5_6 or var7_6 or not var6_6 and arg0_6.x64 and not arg0_6.a32 then
							if var30_6 == 1 and var31_6 > 127 then
								var8_6 = var3_0("-0x%x", 256 - var31_6)
							elseif var31_6 >= 0 and var31_6 <= 2147483647 then
								var8_6 = var3_0("+0x%x", var31_6)
							else
								var8_6 = var3_0("-0x%x", 4294967296 - var31_6)
							end
						else
							var8_6 = var3_0(arg0_6.x64 and not arg0_6.a32 and (not (var31_6 >= 0) or not (var31_6 <= 2147483647)) and "0xffffffff%08x" or "0x%08x", var31_6)
						end

						var10_6 = var10_6 + var30_6
					end
				end

				if var5_6 and arg0_6.rexb then
					var5_6 = var5_6 + 8
					arg0_6.rexb = false
				end

				if arg0_6.rexr then
					var4_6 = var4_6 + 8
					arg0_6.rexr = false
				end
			end

			if iter0_6 == "m" then
				if var3_6 == 3 then
					var13_6 = var1_6[var5_6 + 1]
				else
					local var32_6 = arg0_6.a32 and var17_0.D or arg0_6.aregs
					local var33_6 = ""
					local var34_6 = ""

					if var5_6 then
						var33_6 = var32_6[var5_6 + 1]
					elseif not var6_6 and arg0_6.x64 and not arg0_6.a32 then
						var33_6 = "rip"
					end

					arg0_6.a32 = false

					if var7_6 then
						if var5_6 then
							var33_6 = var33_6 .. "+"
						end

						var34_6 = var32_6[var7_6 + 1]

						if var6_6 > 0 then
							var34_6 = var34_6 .. "*" .. 2^var6_6
						end
					end

					var13_6 = var3_0("[%s%s%s]", var33_6, var34_6, var8_6)
				end

				if var3_6 < 3 and (not var4_0(arg2_6, "[aRrgp]") or var4_0(arg2_6, "t")) then
					var13_6 = var20_0[var2_6] .. " " .. var13_6
				end
			elseif iter0_6 == "r" then
				var13_6 = var1_6[var4_6 + 1]
			elseif iter0_6 == "g" then
				var13_6 = var18_0[var4_6 + 1]
			elseif iter0_6 == "p" then
				-- block empty
			elseif iter0_6 == "f" then
				var13_6 = "st" .. var5_6
			elseif iter0_6 == "x" then
				if var4_6 == 0 and arg0_6.lock and not arg0_6.x64 then
					var13_6 = "CR8"
					arg0_6.lock = false
				else
					var13_6 = "CR" .. var4_6
				end
			elseif iter0_6 == "v" then
				if arg0_6.vexv then
					var13_6 = var1_6[arg0_6.vexv + 1]
					arg0_6.vexv = false
				end
			elseif iter0_6 == "y" then
				var13_6 = "DR" .. var4_6
			elseif iter0_6 == "z" then
				var13_6 = "TR" .. var4_6
			elseif iter0_6 == "l" then
				var12_6 = false
			elseif iter0_6 == "t" then
				-- block empty
			else
				error("bad pattern `" .. arg2_6 .. "'")
			end
		end

		if var13_6 then
			var0_6 = var0_6 and var0_6 .. ", " .. var13_6 or var13_6
		end
	end

	arg0_6.pos = var10_6

	return var21_0(arg0_6, arg1_6, var0_6)
end

local var27_0

local function var28_0(arg0_7)
	local var0_7 = arg0_7.mrm

	if not var0_7 then
		local var1_7 = arg0_7.pos

		if var1_7 > arg0_7.stop then
			return nil
		end

		var0_7 = var2_0(arg0_7.code, var1_7, var1_7)
		arg0_7.pos = var1_7 + 1
		arg0_7.mrm = var0_7
	end

	return var0_7
end

local function var29_0(arg0_8, arg1_8, arg2_8)
	if not arg1_8 then
		return var24_0(arg0_8)
	end

	if var4_0(arg1_8, "%|") then
		local var0_8

		if arg0_8.rep then
			var0_8 = arg0_8.rep == "rep" and "%|([^%|]*)" or "%|[^%|]*%|[^%|]*%|([^%|]*)"
			arg0_8.rep = false
		elseif arg0_8.o16 then
			var0_8 = "%|[^%|]*%|([^%|]*)"
			arg0_8.o16 = false
		else
			var0_8 = "^[^%|]*"
		end

		arg1_8 = var4_0(arg1_8, var0_8)

		if not arg1_8 then
			return var24_0(arg0_8)
		end
	end

	if var4_0(arg1_8, "%$") then
		local var1_8 = var28_0(arg0_8)

		if not var1_8 then
			return var23_0(arg0_8)
		end

		arg1_8 = var4_0(arg1_8, var1_8 >= 192 and "^[^%$]*" or "%$(.*)")

		if arg1_8 == "" then
			return var24_0(arg0_8)
		end
	end

	if arg1_8 == "" then
		return var24_0(arg0_8)
	end

	local var2_8, var3_8 = var4_0(arg1_8, "^([a-z0-9 ]*)(.*)")

	if var3_8 == "" and arg2_8 then
		var3_8 = arg2_8
	end

	return var27_0[var1_0(var3_8, 1, 1)](arg0_8, var2_8, var3_8)
end

local function var30_0(arg0_9, arg1_9)
	local var0_9 = arg0_9.pos
	local var1_9 = arg1_9[var2_0(arg0_9.code, var0_9, var0_9)]

	arg0_9.pos = var0_9 + 1

	return var29_0(arg0_9, var1_9)
end

var27_0 = {
	[""] = function(arg0_10, arg1_10, arg2_10)
		return var21_0(arg0_10, arg1_10)
	end,
	B = var26_0,
	W = var26_0,
	D = var26_0,
	Q = var26_0,
	V = var26_0,
	U = var26_0,
	T = var26_0,
	M = var26_0,
	X = var26_0,
	P = var26_0,
	F = var26_0,
	G = var26_0,
	Y = var26_0,
	[":"] = function(arg0_11, arg1_11, arg2_11)
		arg0_11[arg2_11 == ":" and arg1_11 or var1_0(arg2_11, 2)] = arg1_11

		if arg0_11.pos - arg0_11.start > 5 then
			return var24_0(arg0_11)
		end
	end,
	["*"] = function(arg0_12, arg1_12, arg2_12)
		return var27_0[arg1_12](arg0_12, arg1_12, var1_0(arg2_12, 2))
	end,
	["!"] = function(arg0_13, arg1_13, arg2_13)
		local var0_13 = var28_0(arg0_13)

		if not var0_13 then
			return var23_0(arg0_13)
		end

		return var29_0(arg0_13, var16_0[arg1_13][(var0_13 - var0_13 % 8) / 8 % 8 + 1], var1_0(arg2_13, 2))
	end,
	sz = function(arg0_14, arg1_14, arg2_14)
		if arg0_14.o16 then
			arg0_14.o16 = false
		else
			arg2_14 = var4_0(arg2_14, ",(.*)")

			if arg0_14.rexw then
				local var0_14 = var4_0(arg2_14, ",(.*)")

				if var0_14 then
					arg2_14 = var0_14
					arg0_14.rexw = false
				end
			end
		end

		arg2_14 = var4_0(arg2_14, "^[^,]*")

		return var29_0(arg0_14, arg2_14)
	end,
	opc2 = function(arg0_15, arg1_15, arg2_15)
		return var30_0(arg0_15, var12_0)
	end,
	opc3 = function(arg0_16, arg1_16, arg2_16)
		return var30_0(arg0_16, var13_0[arg2_16])
	end,
	vm = function(arg0_17, arg1_17, arg2_17)
		return var29_0(arg0_17, var14_0[arg0_17.mrm])
	end,
	fp = function(arg0_18, arg1_18, arg2_18)
		local var0_18 = var28_0(arg0_18)

		if not var0_18 then
			return var23_0(arg0_18)
		end

		local var1_18 = var0_18 % 8
		local var2_18 = arg2_18 * 8 + (var0_18 - var1_18) / 8 % 8

		if var0_18 >= 192 then
			var2_18 = var2_18 + 64
		end

		local var3_18 = var15_0[var2_18]

		if var0_0(var3_18) == "table" then
			var3_18 = var3_18[var1_18 + 1]
		end

		return var29_0(arg0_18, var3_18)
	end,
	rex = function(arg0_19, arg1_19, arg2_19)
		if arg0_19.rex then
			return var24_0(arg0_19)
		end

		for iter0_19 in var5_0(arg2_19, ".") do
			arg0_19["rex" .. iter0_19] = true
		end

		arg0_19.rex = "rex"
	end,
	vex = function(arg0_20, arg1_20, arg2_20)
		if arg0_20.rex then
			return var24_0(arg0_20)
		end

		arg0_20.rex = "vex"

		local var0_20 = arg0_20.pos

		if arg0_20.mrm then
			arg0_20.mrm = nil
			var0_20 = var0_20 - 1
		end

		local var1_20 = var2_0(arg0_20.code, var0_20, var0_20)

		if not var1_20 then
			return var23_0(arg0_20)
		end

		local var2_20 = var0_20 + 1

		if var1_20 < 128 then
			arg0_20.rexr = true
		end

		local var3_20 = 1

		if arg2_20 == "3" then
			var3_20 = var1_20 % 32
			var1_20 = (var1_20 - var3_20) / 32

			local var4_20 = var1_20 % 2

			var1_20 = (var1_20 - var4_20) / 2

			if var4_20 == 0 then
				arg0_20.rexb = true
			end

			if var1_20 % 2 == 0 then
				arg0_20.rexx = true
			end

			var1_20 = var2_0(arg0_20.code, var2_20, var2_20)

			if not var1_20 then
				return var23_0(arg0_20)
			end

			var2_20 = var2_20 + 1

			if var1_20 >= 128 then
				arg0_20.rexw = true
			end
		end

		arg0_20.pos = var2_20

		local var5_20

		if var3_20 == 1 then
			var5_20 = var12_0
		elseif var3_20 == 2 then
			var5_20 = var13_0["38"]
		elseif var3_20 == 3 then
			var5_20 = var13_0["3a"]
		else
			return var24_0(arg0_20)
		end

		local var6_20 = var1_20 % 4
		local var7_20 = (var1_20 - var6_20) / 4

		if var6_20 == 1 then
			arg0_20.o16 = "o16"
		elseif var6_20 == 2 then
			arg0_20.rep = "rep"
		elseif var6_20 == 3 then
			arg0_20.rep = "repne"
		end

		local var8_20 = var7_20 % 2
		local var9_20 = (var7_20 - var8_20) / 2

		if var8_20 ~= 0 then
			arg0_20.vexl = true
		end

		arg0_20.vexv = (-1 - var9_20) % 16

		return var30_0(arg0_20, var5_20)
	end,
	nop = function(arg0_21, arg1_21, arg2_21)
		return var29_0(arg0_21, arg0_21.rex and arg2_21 or "nop")
	end,
	emms = function(arg0_22, arg1_22, arg2_22)
		if arg0_22.rex ~= "vex" then
			return var21_0(arg0_22, "emms")
		elseif arg0_22.vexl then
			arg0_22.vexl = false

			return var21_0(arg0_22, "zeroall")
		else
			return var21_0(arg0_22, "zeroupper")
		end
	end
}

local function var31_0(arg0_23, arg1_23, arg2_23)
	arg1_23 = arg1_23 or 0

	local var0_23 = arg2_23 and arg1_23 + arg2_23 or #arg0_23.code

	arg1_23 = arg1_23 + 1
	arg0_23.start = arg1_23
	arg0_23.pos = arg1_23
	arg0_23.stop = var0_23
	arg0_23.imm = nil
	arg0_23.mrm = false

	var22_0(arg0_23)

	while var0_23 >= arg0_23.pos do
		var30_0(arg0_23, arg0_23.map1)
	end

	if arg0_23.pos ~= arg0_23.start then
		var23_0(arg0_23)
	end
end

local function var32_0(arg0_24, arg1_24, arg2_24)
	local var0_24 = {
		code = arg0_24,
		addr = (arg1_24 or 0) - 1,
		out = arg2_24 or io.write,
		symtab = {},
		disass = var31_0
	}

	var0_24.hexdump = 16
	var0_24.x64 = false
	var0_24.map1 = var10_0
	var0_24.aregs = var17_0.D

	return var0_24
end

local function var33_0(arg0_25, arg1_25, arg2_25)
	local var0_25 = var32_0(arg0_25, arg1_25, arg2_25)

	var0_25.x64 = true
	var0_25.map1 = var11_0
	var0_25.aregs = var17_0.Q

	return var0_25
end

local function var34_0(arg0_26, arg1_26, arg2_26)
	var32_0(arg0_26, arg1_26, arg2_26):disass()
end

local function var35_0(arg0_27, arg1_27, arg2_27)
	var33_0(arg0_27, arg1_27, arg2_27):disass()
end

local function var36_0(arg0_28)
	if arg0_28 < 8 then
		return var17_0.D[arg0_28 + 1]
	end

	return var17_0.X[arg0_28 - 7]
end

local function var37_0(arg0_29)
	if arg0_29 < 16 then
		return var17_0.Q[arg0_29 + 1]
	end

	return var17_0.X[arg0_29 - 15]
end

return {
	create = var32_0,
	create64 = var33_0,
	disass = var34_0,
	disass64 = var35_0,
	regname = var36_0,
	regname64 = var37_0
}
