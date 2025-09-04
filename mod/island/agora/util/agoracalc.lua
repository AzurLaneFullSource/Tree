local var0_0 = class("AgoraCalc")

function var0_0.GetSizeCoord(arg0_1)
	local var0_1 = (arg0_1.x - 1) / 2
	local var1_1 = (arg0_1.y - 1) / 2
	local var2_1 = math.ceil(var0_1)
	local var3_1 = math.floor(var0_1) * -1
	local var4_1 = math.ceil(var1_1)
	local var5_1 = math.floor(var1_1) * -1

	return Vector4(var3_1, var4_1, var2_1, var5_1)
end

function var0_0.GetArea(arg0_2, arg1_2)
	local var0_2 = {}
	local var1_2 = var0_0.GetSizeCoord(arg1_2)

	for iter0_2 = var1_2.x, var1_2.z do
		for iter1_2 = var1_2.w, var1_2.y do
			table.insert(var0_2, Vector2(iter0_2, iter1_2) + arg0_2)
		end
	end

	return var0_2
end

function var0_0.GetAreaCenterPos(arg0_3)
	local var0_3 = math.huge
	local var1_3 = -math.huge
	local var2_3 = math.huge
	local var3_3 = -math.huge

	for iter0_3, iter1_3 in ipairs(arg0_3) do
		if var1_3 < iter1_3.x then
			var1_3 = iter1_3.x
		end

		if var0_3 > iter1_3.x then
			var0_3 = iter1_3.x
		end

		if var3_3 < iter1_3.y then
			var3_3 = iter1_3.y
		end

		if var2_3 > iter1_3.y then
			var2_3 = iter1_3.y
		end
	end

	local var4_3 = (var1_3 + var0_3) * 0.5
	local var5_3 = (var2_3 + var3_3) * 0.5

	return Vector3(var4_3, 0, var5_3)
end

function var0_0.GetCenterScreenPos()
	local var0_4 = IslandCameraMgr.instance._mainCamera

	return (var0_0.CameraPosToHitPoint(var0_4, IslandConst.LAYER_AGORA))
end

function var0_0.ScreenPostion2MapPosition(arg0_5)
	local var0_5 = IslandCameraMgr.instance._mainCamera
	local var1_5 = var0_0.ScreenToHitPoint(var0_5, arg0_5, IslandConst.LAYER_AGORA)

	if var1_5 then
		return var0_0.WorldPosition2MapPosition(var1_5)
	else
		return nil
	end
end

function var0_0.WorldPosition2MapPosition(arg0_6)
	return Vector2(math.ceil(arg0_6.x), math.ceil(arg0_6.z))
end

function var0_0.WorldPosition2ScreenPosition(arg0_7)
	return IslandCameraMgr.instance._mainCamera:WorldToScreenPoint(arg0_7)
end

function var0_0.ScreenPosition2LocalPosition(arg0_8, arg1_8)
	local var0_8 = pg.UIMgr.GetInstance().uiCameraComp
	local var1_8 = IslandCameraMgr.instance._mainCamera:ScreenToViewportPoint(arg1_8)
	local var2_8 = var0_8:ViewportToScreenPoint(var1_8)
	local var3_8 = arg0_8:GetComponent("RectTransform")

	return (LuaHelper.ScreenToLocal(var3_8, var2_8, var0_8))
end

function var0_0.GetCenterMapPos()
	local var0_9 = var0_0.GetCenterScreenPos()

	if var0_9 then
		return var0_0.WorldPosition2MapPosition(var0_9)
	else
		return nil
	end
end

function var0_0.MapPosition2WorldPosition(arg0_10)
	return Vector3(arg0_10.x, 0, arg0_10.y)
end

function var0_0.CameraPosToHitPoint(arg0_11, arg1_11)
	local var0_11 = arg0_11.transform.position
	local var1_11 = arg0_11.transform.forward
	local var2_11 = LuaHelper.NameToLayer(arg1_11)
	local var3_11, var4_11 = Physics.Raycast(var0_11, var1_11, nil, math.huge, var2_11)

	if var3_11 then
		return var4_11.point
	else
		return nil
	end
end

function var0_0.ScreenToHitPoint(arg0_12, arg1_12, arg2_12)
	local var0_12 = pg.UIMgr.GetInstance().uiCameraComp
	local var1_12 = arg1_12
	local var2_12 = var0_12:ScreenToViewportPoint(Vector3(var1_12.x, var1_12.y, 0))
	local var3_12 = arg0_12:ViewportPointToRay(var2_12)
	local var4_12 = LuaHelper.NameToLayer(arg2_12)
	local var5_12, var6_12 = Physics.Raycast(var3_12, nil, math.huge, var4_12)

	if var5_12 then
		return var6_12.point
	else
		return nil
	end
end

function var0_0.GetUniqueId(arg0_13, arg1_13)
	return arg0_13 * 100 + arg1_13
end

function var0_0.RevertFormUniqueId(arg0_14)
	return math.floor(arg0_14 * 0.01)
end

function var0_0.DecodeLayer(arg0_15)
	local var0_15 = LuaHelper.DecodeAgoraLayerProt(arg0_15)
	local var1_15, var2_15 = var0_0.GroundPoint2MapPoint(var0_15[2], var0_15[3])

	return var0_0.GetUniqueId(var0_15[0], 1), var0_15[1], var1_15, var2_15
end

function var0_0.EncodeLayer(arg0_16)
	return _.map(arg0_16, function(arg0_17)
		local var0_17 = var0_0.RevertFormUniqueId(arg0_17.id)
		local var1_17, var2_17 = var0_0.MapPoint2GroundPoint(arg0_17.x, arg0_17.y)

		return LuaHelper.EncodeAgoraLayerProt(var0_17, arg0_17.shapeId, var1_17, var2_17)
	end)
end

function var0_0.GetGroundLeftBottomPoint()
	local var0_18 = IslandConst.AGORA_LEVEL_2_SIZE[#IslandConst.AGORA_LEVEL_2_SIZE]
	local var1_18 = Vector2(var0_18, var0_18)
	local var2_18 = AgoraCalc.GetSizeCoord(var1_18)

	return Vector2(var2_18.x, var2_18.w)
end

function var0_0.MapPoint2GroundPoint(arg0_19, arg1_19)
	local var0_19 = var0_0.GetGroundLeftBottomPoint()
	local var1_19 = Vector2(arg0_19, arg1_19) - var0_19

	return var1_19.x, var1_19.y
end

function var0_0.GroundPoint2MapPoint(arg0_20, arg1_20)
	local var0_20 = var0_0.GetGroundLeftBottomPoint()
	local var1_20 = Vector2(arg0_20, arg1_20) + var0_20

	return var1_20.x, var1_20.y
end

function var0_0.EncodePlaced(arg0_21)
	return _.map(arg0_21, function(arg0_22)
		return {
			id = arg0_22.id,
			x = arg0_22.x,
			y = arg0_22.y,
			dir = arg0_22.dir
		}
	end)
end

function var0_0.GetChangePlacementList(arg0_23, arg1_23)
	local function var0_23(arg0_24, arg1_24)
		for iter0_24, iter1_24 in ipairs(arg1_24) do
			if iter1_24.id == arg0_24.id then
				return true
			end
		end

		return false
	end

	local function var1_23(arg0_25, arg1_25)
		local var0_25

		for iter0_25, iter1_25 in ipairs(arg1_25) do
			if iter1_25.id == arg0_25.id then
				var0_25 = iter1_25

				break
			end
		end

		return not arg0_25:IsSame(var0_25)
	end

	local var2_23 = _.select(arg0_23, function(arg0_26)
		return not var0_23(arg0_26, arg1_23)
	end)
	local var3_23 = _.select(arg1_23, function(arg0_27)
		return not var0_23(arg0_27, arg0_23)
	end)

	return _.select(arg0_23, function(arg0_28)
		return not var0_23(arg0_28, var2_23) and not var0_23(arg0_28, var3_23) and var1_23(arg0_28, arg1_23)
	end), var3_23, var2_23
end

function var0_0.BuildScreenShootSavePath(arg0_29)
	return Application.persistentDataPath .. "/screen_scratch/island_theme" .. arg0_29 .. ".jpg"
end

return var0_0
