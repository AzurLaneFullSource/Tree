local var0_0 = require((string.match(..., ".*%.") or "") .. "dis_mips")

return {
	create = var0_0.create,
	disass = var0_0.disass,
	regname = var0_0.regname
}
