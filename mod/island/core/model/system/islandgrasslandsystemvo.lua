local var0_0 = class("IslandGrassLandSystemVO", import(".IslandGroundSystemVO"))

function var0_0.GetType(arg0_1)
	return IslandConst.SYSTEM_TYPE_GRASSLAND
end

function var0_0.GetAssetPath(arg0_2)
	return nil
end

function var0_0.MapPoint2GroundPoint(arg0_3, arg1_3)
	local var0_3 = var0_0.super.MapPoint2GroundPoint(arg0_3, arg1_3)

	return Vector2(var0_3.x - 1, var0_3.y - 1)
end

return var0_0
