local var0_0 = require((string.match(..., ".*%.") or "") .. "dis_mips")

return {
	create = var0_0.create_el,
	disass = var0_0.disass_el,
	regname = var0_0.regname
}
