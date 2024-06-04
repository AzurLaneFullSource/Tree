local var0 = class("CourtYardStageFurniture", import(".CourtYardCanPutFurniture"))

function var0.AllowDepthType(arg0)
	return {
		CourtYardConst.DEPTH_TYPE_MAT,
		CourtYardConst.DEPTH_TYPE_SHIP,
		CourtYardConst.DEPTH_TYPE_FURNITURE
	}
end

return var0
