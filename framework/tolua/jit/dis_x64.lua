local var0 = require((string.match(..., ".*%.") or "") .. "dis_x86")

return {
	create = var0.create64,
	disass = var0.disass64,
	regname = var0.regname64
}
