local var0 = require((string.match(..., ".*%.") or "") .. "dis_mips")

return {
	create = var0.create_el,
	disass = var0.disass_el,
	regname = var0.regname
}
