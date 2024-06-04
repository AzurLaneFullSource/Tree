local var0 = require((string.match(..., ".*%.") or "") .. "dis_mips")

return {
	create = var0.create,
	disass = var0.disass,
	regname = var0.regname
}
