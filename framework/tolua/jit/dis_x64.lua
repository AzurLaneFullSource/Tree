local var0_0 = require((string.match(..., ".*%.") or "") .. "dis_x86")

return {
	create = var0_0.create64,
	disass = var0_0.disass64,
	regname = var0_0.regname64
}
