local var0_0 = class("IslandGroundSystemVO", import(".IslandSystemVO"))

function var0_0.GetBehaviourTree(arg0_1)
	return nil
end

function var0_0.GetType(arg0_2)
	return IslandConst.SYSTEM_TYPE_GROUND
end

function var0_0.GetAssetPath(arg0_3)
	return "ui/FloorTileRenderer"
end

function var0_0.GetSize(arg0_4)
	local var0_4 = IslandConst.AGORA_LEVEL_2_SIZE[#IslandConst.AGORA_LEVEL_2_SIZE]

	return Vector2(var0_4, var0_4)
end

function var0_0.GetMapLeftBottomPoint(arg0_5)
	local var0_5 = arg0_5:GetSize()
	local var1_5 = AgoraCalc.GetSizeCoord(var0_5)

	return Vector2(var1_5.x, var1_5.w)
end

function var0_0.GetPosition(arg0_6)
	local var0_6 = arg0_6:GetMapLeftBottomPoint()

	return AgoraCalc.MapPosition2WorldPosition(var0_6) + IslandConst.AGORA_POSITION_OFFSET + IslandConst.AGORA_GROUND_OFFSET
end

function var0_0.MapPoint2GroundPoint(arg0_7, arg1_7)
	return arg1_7 - arg0_7:GetMapLeftBottomPoint()
end

return var0_0
