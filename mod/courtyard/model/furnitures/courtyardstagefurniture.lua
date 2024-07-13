local var0_0 = class("CourtYardStageFurniture", import(".CourtYardCanPutFurniture"))

function var0_0.AllowDepthType(arg0_1)
	return {
		CourtYardConst.DEPTH_TYPE_MAT,
		CourtYardConst.DEPTH_TYPE_SHIP,
		CourtYardConst.DEPTH_TYPE_FURNITURE
	}
end

return var0_0
