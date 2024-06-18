local var0_0 = class("WSMap", import("...BaseEntity"))

var0_0.Fields = {
	map = "table",
	rtQuads = "userdata",
	wsMapQuads = "table",
	wsMapArtifactsFA = "table",
	wsMapPath = "table",
	wsMapCells = "table",
	wsMapAttachments = "table",
	world = "table",
	rtTop = "userdata",
	rtTargetArrow = "userdata",
	rtItems = "userdata",
	rtEffectA = "userdata",
	wsTerrainEffects = "table",
	wsPool = "table",
	rtEffectB = "userdata",
	twTimerId = "number",
	wsMapArtifacts = "table",
	displayRangeTimer = "table",
	wsMapFleets = "table",
	transform = "userdata",
	wsMapResource = "table",
	twTimer = "userdata",
	rtCells = "userdata",
	displayRangeLines = "table",
	wsTimer = "table",
	wsMapItems = "table",
	transportDisplay = "number",
	wsCarryItems = "table",
	rangeVisible = "boolean",
	wsMapTransports = "table",
	rtEffectC = "userdata"
}
var0_0.Listeners = {
	onRemoveCarry = "OnRemoveCarry",
	onUpdateAttachment = "OnUpdateAttachment",
	onUpdateTerrain = "OnUpdateTerrain",
	onUpdateFleetFOV = "OnUpdateFleetFOV",
	onAddAttachment = "OnAddAttachment",
	onRemoveAttachment = "OnRemoveAttachment",
	onAddCarry = "OnAddCarry"
}
var0_0.EventUpdateEventTips = "WSMap.EventUpdateEventTips"

function var0_0.Setup(arg0_1, arg1_1)
	arg0_1.map = arg1_1
	arg0_1.wsMapQuads = {}
	arg0_1.wsMapItems = {}
	arg0_1.wsMapCells = {}
	arg0_1.wsMapFleets = {}
	arg0_1.wsMapArtifacts = {}
	arg0_1.wsMapArtifactsFA = {}
	arg0_1.wsMapTransports = {}
	arg0_1.wsMapAttachments = {}
	arg0_1.wsTerrainEffects = {}
	arg0_1.wsCarryItems = {}
	arg0_1.wsMapPath = WSMapPath.New()

	arg0_1.wsMapPath:Setup(arg0_1.map.theme)

	arg0_1.wsMapResource = WSMapResource.New()

	arg0_1.wsMapResource:Setup(arg0_1.map)

	arg0_1.transportDisplay = WorldConst.TransportDisplayNormal

	pg.DelegateInfo.New(arg0_1)
end

function var0_0.Dispose(arg0_2)
	pg.DelegateInfo.Dispose(arg0_2)
	arg0_2.wsMapPath:Dispose()
	arg0_2:ClearTargetArrow()
	arg0_2:Unload()
	arg0_2:Clear()
end

function var0_0.Load(arg0_3, arg1_3)
	local var0_3 = {}

	table.insert(var0_3, function(arg0_4)
		arg0_3:InitPlane(arg0_4)
	end)
	table.insert(var0_3, function(arg0_5)
		arg0_3.wsMapResource:Load(arg0_5)
	end)
	table.insert(var0_3, function(arg0_6)
		arg0_3:InitClutter()
		arg0_3:InitMap()
		arg0_6()
	end)
	seriesAsync(var0_3, arg1_3)
end

function var0_0.Unload(arg0_7)
	arg0_7:DisposeMap()
	arg0_7.wsMapResource:Unload()

	if arg0_7.transform then
		PoolMgr.GetInstance():ReturnPrefab("world/object/world_plane", "world_plane", arg0_7.transform.gameObject, true)

		arg0_7.transform = nil
	end
end

function var0_0.InitPlane(arg0_8, arg1_8)
	PoolMgr.GetInstance():GetPrefab("world/object/world_plane", "world_plane", true, function(arg0_9)
		arg0_8.transform = arg0_9.transform

		setActive(arg0_8.transform, false)

		arg0_8.rtQuads = arg0_8.transform:Find("quads")
		arg0_8.rtItems = arg0_8.transform:Find("items")
		arg0_8.rtCells = arg0_8.transform:Find("cells")
		arg0_8.rtTop = arg0_8.transform:Find("top")
		arg0_8.rtEffectA = arg0_8.transform:Find("effect-a-1-999")
		arg0_8.rtEffectB = arg0_8.transform:Find("effect-b-1001-1999")
		arg0_8.rtEffectC = arg0_8.transform:Find("effect-c-2001-2999")

		local var0_9 = arg0_8.map

		assert(var0_9 and var0_9.active, "map not exist or map not active.")

		local var1_9 = var0_9.theme
		local var2_9 = arg0_8.transform

		var2_9.name = "plane"
		var2_9.anchoredPosition3D = Vector3(var1_9.offsetx, var1_9.offsety, var1_9.offsetz) + WorldConst.DefaultMapOffset

		local var3_9 = var2_9:Find("display")
		local var4_9 = var3_9:Find("mask/sea")

		setImageAlpha(var4_9, 0)
		GetSpriteFromAtlasAsync("chapter/pic/" .. var1_9.assetSea, var1_9.assetSea, function(arg0_10)
			if var4_9 then
				setImageSprite(var4_9, arg0_10, false)
				setImageAlpha(var4_9, 1)
			end
		end)

		local var5_9 = Vector2(10000, 10000)
		local var6_9 = Vector2.zero
		local var7_9 = Vector2(WorldConst.MaxColumn, WorldConst.MaxRow)
		local var8_9 = Vector2(-WorldConst.MaxColumn, -WorldConst.MaxRow)

		for iter0_9 = 0, WorldConst.MaxRow - 1 do
			for iter1_9 = 0, WorldConst.MaxColumn - 1 do
				if var0_9:GetCell(iter0_9, iter1_9) then
					var5_9.x = math.min(var5_9.x, iter1_9)
					var5_9.y = math.min(var5_9.y, WorldConst.MaxRow * 0.5 - iter0_9 - 1)
					var7_9.x = math.min(var7_9.x, iter1_9)
					var7_9.y = math.min(var7_9.y, iter0_9)
					var8_9.x = math.max(var8_9.x, iter1_9)
					var8_9.y = math.max(var8_9.y, iter0_9)
				end
			end
		end

		local var9_9 = var1_9.cellSize + var1_9.cellSpace

		var5_9.x = var5_9.x * var9_9.x
		var5_9.y = var5_9.y * var9_9.y
		var6_9.x = (var8_9.x - var7_9.x + 1) * var9_9.x
		var6_9.y = (var8_9.y - var7_9.y + 1) * var9_9.y
		var3_9.anchoredPosition = var5_9 + var6_9 * 0.5
		var3_9.sizeDelta = var6_9

		local var10_9 = Vector2(math.floor(var3_9.sizeDelta.x / var9_9.x), math.floor(var3_9.sizeDelta.y / var9_9.y))
		local var11_9 = var3_9:Find("linev")
		local var12_9 = var11_9:GetChild(0)
		local var13_9 = var11_9:GetComponent(typeof(GridLayoutGroup))

		var13_9.cellSize = Vector2(WorldConst.LineCross, var3_9.sizeDelta.y)
		var13_9.spacing = Vector2(var9_9.x - WorldConst.LineCross, 0)
		var13_9.padding.left = math.floor(var13_9.spacing.x)

		for iter2_9 = var11_9.childCount - 1, math.max(var10_9.x - 1, 0), -1 do
			if iter2_9 > 0 then
				Destroy(var11_9:GetChild(iter2_9))
			end
		end

		for iter3_9 = var11_9.childCount, var10_9.x - 2 do
			Instantiate(var12_9).transform:SetParent(var11_9, false)
		end

		local var14_9 = var3_9:Find("lineh")
		local var15_9 = var14_9:GetChild(0)
		local var16_9 = var14_9:GetComponent(typeof(GridLayoutGroup))

		var16_9.cellSize = Vector2(var3_9.sizeDelta.x, WorldConst.LineCross)
		var16_9.spacing = Vector2(0, var9_9.y - WorldConst.LineCross)
		var16_9.padding.top = math.floor(var16_9.spacing.y)

		for iter4_9 = var14_9.childCount - 1, math.max(var10_9.y - 1, 0), -1 do
			if iter4_9 > 0 then
				Destroy(var14_9:GetChild(iter4_9))
			end
		end

		for iter5_9 = var14_9.childCount, var10_9.y - 2 do
			Instantiate(var15_9).transform:SetParent(var14_9, false)
		end

		arg1_8()
	end)
end

function var0_0.InitClutter(arg0_11)
	arg0_11.twTimer = LeanTween.value(arg0_11.transform.gameObject, 1, 0, WorldConst.QuadBlinkDuration):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

	arg0_11.wsTimer:AddInMapTween(arg0_11.twTimer.uniqueId)
	arg0_11:NewTargetArrow()
end

function var0_0.InitMap(arg0_12)
	local var0_12 = arg0_12.map
	local var1_12 = var0_12.theme
	local var2_12 = _.values(var0_12.cells)

	table.sort(var2_12, function(arg0_13, arg1_13)
		return arg0_13.row < arg1_13.row or arg0_13.row == arg1_13.row and arg0_13.column < arg1_13.column
	end)

	for iter0_12, iter1_12 in ipairs(var2_12) do
		local var3_12 = arg0_12:NewQuad(iter1_12)

		arg0_12.wsMapQuads[WSMapQuad.GetName(iter1_12.row, iter1_12.column)] = var3_12

		local var4_12 = arg0_12:NewCell(iter1_12)

		arg0_12.wsMapCells[WSMapCell.GetName(iter1_12.row, iter1_12.column)] = var4_12
	end

	for iter2_12, iter3_12 in ipairs(var0_12.config.float_items) do
		local var5_12 = iter3_12[1]
		local var6_12 = iter3_12[2]
		local var7_12 = var0_12:GetCell(var5_12, var6_12)

		if var7_12 then
			local var8_12 = arg0_12:GetItem(var5_12, var6_12)

			if not var8_12 then
				var8_12 = arg0_12:NewItem(var7_12)
				arg0_12.wsMapItems[WSMapItem.GetName(var7_12.row, var7_12.column)] = var8_12
			end

			local var9_12 = arg0_12:NewArtifact(var8_12, iter3_12)

			table.insert(arg0_12.wsMapArtifacts, var9_12)
		end
	end

	for iter4_12, iter5_12 in ipairs(var2_12) do
		for iter6_12, iter7_12 in ipairs(iter5_12.attachments) do
			local var10_12 = arg0_12:GetCell(iter7_12.row, iter7_12.column)

			if iter7_12.type == WorldMapAttachment.TypeArtifact then
				local var11_12 = arg0_12:GetItem(iter5_12.row, iter5_12.column)

				if not var11_12 then
					var11_12 = arg0_12:NewItem(iter5_12)
					arg0_12.wsMapItems[WSMapItem.GetName(iter5_12.row, iter5_12.column)] = var11_12
				end

				local var12_12 = arg0_12:NewArtifact(var11_12, iter7_12:GetArtifaceInfo(), iter7_12)

				table.insert(arg0_12.wsMapArtifactsFA, var12_12)
			else
				local var13_12 = arg0_12:NewAttachment(var10_12, iter7_12)

				table.insert(arg0_12.wsMapAttachments, var13_12)
			end
		end
	end

	for iter8_12, iter9_12 in ipairs(var0_12:GetNormalFleets()) do
		local var14_12 = arg0_12:NewFleet(iter9_12)

		table.insert(arg0_12.wsMapFleets, var14_12)

		for iter10_12, iter11_12 in ipairs(iter9_12:GetCarries()) do
			local var15_12 = arg0_12:NewCarryItem(iter9_12, iter11_12)

			table.insert(arg0_12.wsCarryItems, var15_12)
		end
	end

	arg0_12:FlushFleets()
	var0_12:AddListener(WorldMap.EventUpdateFleetFOV, arg0_12.onUpdateFleetFOV)
end

function var0_0.DisposeMap(arg0_14)
	arg0_14.map:RemoveListener(WorldMap.EventUpdateFleetFOV, arg0_14.onUpdateFleetFOV)
	_.each(arg0_14.wsCarryItems, function(arg0_15)
		arg0_14:DisposeCarryItem(arg0_15)
	end)

	arg0_14.wsCarryItems = {}

	_.each(arg0_14.wsMapFleets, function(arg0_16)
		arg0_14:DisposeFleet(arg0_16)
	end)

	arg0_14.wsMapFleets = {}

	_.each(arg0_14.wsMapAttachments, function(arg0_17)
		arg0_14:DisposeAttachment(arg0_17)
	end)

	arg0_14.wsMapAttachments = {}

	_.each(arg0_14.wsMapArtifacts, function(arg0_18)
		arg0_14:DisposeArtifact(arg0_18)
	end)

	arg0_14.wsMapArtifacts = {}

	for iter0_14, iter1_14 in pairs(arg0_14.wsMapTransports) do
		arg0_14:DisposeTransport(iter1_14)
	end

	arg0_14.wsMapTransports = {}

	_.each(arg0_14.wsMapArtifactsFA, function(arg0_19)
		arg0_14:DisposeArtifact(arg0_19)
	end)

	arg0_14.wsMapArtifactsFA = {}

	for iter2_14, iter3_14 in pairs(arg0_14.wsMapCells) do
		arg0_14:DisposeCell(iter3_14)
	end

	arg0_14.wsMapCells = {}

	for iter4_14, iter5_14 in pairs(arg0_14.wsMapItems) do
		arg0_14:DisposeItem(iter5_14)
	end

	arg0_14.wsMapItems = {}

	for iter6_14, iter7_14 in pairs(arg0_14.wsMapQuads) do
		arg0_14:DisposeQuad(iter7_14)
	end

	arg0_14.wsMapQuads = {}

	for iter8_14, iter9_14 in ipairs(arg0_14.wsTerrainEffects) do
		arg0_14:DisposeTerrainEffect(iter9_14)
	end

	arg0_14.wsTerrainEffects = {}
end

function var0_0.OnAddAttachment(arg0_20, arg1_20, arg2_20, arg3_20)
	local var0_20 = arg0_20:GetCell(arg2_20.row, arg2_20.column)

	assert(var0_20, "cell not exist: " .. arg2_20.row .. ", " .. arg2_20.column)

	if arg3_20.type == WorldMapAttachment.TypeArtifact then
		local var1_20 = arg0_20:GetItem(arg2_20.row, arg2_20.column)

		if not var1_20 then
			var1_20 = arg0_20:NewItem(arg2_20)
			arg0_20.wsMapItems[WSMapItem.GetName(arg2_20.row, arg2_20.column)] = var1_20
		end

		local var2_20 = arg0_20:NewArtifact(var1_20, arg3_20:GetArtifaceInfo(), arg3_20)

		table.insert(arg0_20.wsMapArtifactsFA, var2_20)
	else
		local var3_20 = arg0_20:NewAttachment(var0_20, arg3_20)

		table.insert(arg0_20.wsMapAttachments, var3_20)
		arg0_20:OnUpdateAttachment(nil, arg3_20)
	end
end

function var0_0.OnRemoveAttachment(arg0_21, arg1_21, arg2_21, arg3_21)
	if arg3_21.type == WorldMapAttachment.TypeArtifact then
		for iter0_21 = #arg0_21.wsMapArtifactsFA, 1, -1 do
			local var0_21 = arg0_21.wsMapArtifactsFA[iter0_21]

			if var0_21.attachment == arg3_21 then
				arg0_21:DisposeArtifact(var0_21)
				table.remove(arg0_21.wsMapArtifactsFA, iter0_21)

				break
			end
		end
	else
		for iter1_21 = #arg0_21.wsMapAttachments, 1, -1 do
			local var1_21 = arg0_21.wsMapAttachments[iter1_21]

			if var1_21.attachment == arg3_21 then
				arg0_21:DisposeAttachment(var1_21)
				table.remove(arg0_21.wsMapAttachments, iter1_21)
				arg0_21:OnUpdateAttachment(nil, arg3_21)

				break
			end
		end
	end
end

function var0_0.OnUpdateAttachment(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22:FindAttachments(arg2_22.row, arg2_22.column)

	_.each(var0_22, function(arg0_23)
		arg0_23:Update(arg1_22)
	end)

	if arg0_22:FindFleet(arg2_22.row, arg2_22.column) then
		arg0_22:FlushFleets()
	end

	arg0_22:DispatchEvent(var0_0.EventUpdateEventTips)
end

function var0_0.OnUpdateTerrain(arg0_24, arg1_24, arg2_24)
	local var0_24, var1_24 = arg0_24:GetTerrainEffect(arg2_24.row, arg2_24.column)

	if var0_24 then
		arg0_24:DisposeTerrainEffect(var0_24)
		table.remove(arg0_24.wsTerrainEffects, var1_24)
	end

	local var2_24 = arg2_24:GetTerrain()

	if var2_24 == WorldMapCell.TerrainStream or var2_24 == WorldMapCell.TerrainWind or var2_24 == WorldMapCell.TerrainIce or var2_24 == WorldMapCell.TerrainPoison then
		local var3_24 = arg0_24:NewTerrainEffect(arg2_24)

		table.insert(arg0_24.wsTerrainEffects, var3_24)
	end
end

function var0_0.OnAddCarry(arg0_25, arg1_25, arg2_25, arg3_25)
	local var0_25 = arg0_25:NewCarryItem(arg2_25, arg3_25)

	table.insert(arg0_25.wsCarryItems, var0_25)
end

function var0_0.OnRemoveCarry(arg0_26, arg1_26, arg2_26, arg3_26)
	for iter0_26 = #arg0_26.wsCarryItems, 1, -1 do
		local var0_26 = arg0_26.wsCarryItems[iter0_26]

		if var0_26.carryItem == arg3_26 then
			arg0_26:DisposeCarryItem(var0_26)
			table.remove(arg0_26.wsCarryItems, iter0_26)

			break
		end
	end
end

function var0_0.OnUpdateFleetFOV(arg0_27)
	arg0_27:FlushFleets()
end

function var0_0.NewQuad(arg0_28, arg1_28)
	local var0_28 = WPool:Get(WSMapQuad)
	local var1_28 = WSMapQuad.GetResName()

	var0_28.transform = arg0_28.wsPool:Get(var1_28).transform

	var0_28.transform:SetParent(arg0_28.rtQuads, false)

	var0_28.twTimer = arg0_28.twTimer

	var0_28:Setup(arg1_28, arg0_28.map.theme)

	return var0_28
end

function var0_0.DisposeQuad(arg0_29, arg1_29)
	local var0_29 = WSMapQuad.GetResName()

	arg0_29.wsPool:Return(var0_29, arg1_29.transform.gameObject)
	WPool:Return(arg1_29)
end

function var0_0.NewItem(arg0_30, arg1_30)
	local var0_30 = WPool:Get(WSMapItem)
	local var1_30 = WSMapItem.GetResName()

	var0_30.transform = arg0_30.wsPool:Get(var1_30).transform

	var0_30.transform:SetParent(arg0_30.rtItems, false)
	var0_30:Setup(arg1_30, arg0_30.map.theme)

	return var0_30
end

function var0_0.DisposeItem(arg0_31, arg1_31)
	local var0_31 = WSMapItem.GetResName()

	arg0_31.wsPool:Return(var0_31, arg1_31.transform.gameObject)
	WPool:Return(arg1_31)
end

function var0_0.NewCell(arg0_32, arg1_32)
	local var0_32 = WPool:Get(WSMapCell)
	local var1_32 = WSMapCell.GetResName()

	var0_32.transform = arg0_32.wsPool:Get(var1_32).transform

	var0_32.transform:SetParent(arg0_32.rtCells, false)

	var0_32.wsMapResource = arg0_32.wsMapResource
	var0_32.wsTimer = arg0_32.wsTimer

	var0_32:Setup(arg0_32.map, arg1_32)
	var0_32.rtFog:SetParent(arg0_32.rtCells:Find("fogs"), true)
	arg1_32:AddListener(WorldMapCell.EventAddAttachment, arg0_32.onAddAttachment)
	arg1_32:AddListener(WorldMapCell.EventRemoveAttachment, arg0_32.onRemoveAttachment)
	arg1_32:AddListener(WorldMapCell.EventUpdateTerrain, arg0_32.onUpdateTerrain)
	arg0_32:OnUpdateTerrain(nil, arg1_32)

	return var0_32
end

function var0_0.DisposeCell(arg0_33, arg1_33)
	local var0_33 = arg1_33.cell

	arg1_33.rtFog:SetParent(arg1_33.transform, true)
	var0_33:RemoveListener(WorldMapCell.EventAddAttachment, arg0_33.onAddAttachment)
	var0_33:RemoveListener(WorldMapCell.EventRemoveAttachment, arg0_33.onRemoveAttachment)
	var0_33:RemoveListener(WorldMapCell.EventUpdateTerrain, arg0_33.onUpdateTerrain)

	local var1_33 = WSMapCell.GetResName()

	arg0_33.wsPool:Return(var1_33, arg1_33.transform.gameObject)
	WPool:Return(arg1_33)
end

function var0_0.NewTransport(arg0_34, arg1_34, arg2_34, arg3_34)
	local var0_34 = WPool:Get(WSMapTransport)
	local var1_34 = WSMapTransport.GetResName()

	var0_34.transform = arg0_34.wsPool:Get(var1_34).transform

	var0_34.transform:SetParent(arg0_34.rtQuads, false)

	var0_34.wsMapPath = arg0_34.wsMapPath

	var0_34:Setup(arg1_34, arg2_34, arg3_34, arg0_34.map)

	return var0_34
end

function var0_0.DisposeTransport(arg0_35, arg1_35)
	local var0_35 = WSMapTransport.GetResName()

	arg0_35.wsPool:Return(var0_35, arg1_35.transform.gameObject)
	WPool:Return(arg1_35)
end

function var0_0.NewAttachment(arg0_36, arg1_36, arg2_36)
	local var0_36 = WPool:Get(WSMapAttachment)
	local var1_36 = WSMapAttachment.GetResName(arg2_36)

	var0_36.transform = arg0_36.wsPool:Get(var1_36).transform

	var0_36.transform:SetParent(arg1_36.rtAttachments, false)

	var0_36.twTimer = arg0_36.twTimer

	var0_36:Setup(arg0_36.map, arg1_36.cell, arg2_36)
	arg2_36:AddListener(WorldMapAttachment.EventUpdateFlag, arg0_36.onUpdateAttachment)
	arg2_36:AddListener(WorldMapAttachment.EventUpdateData, arg0_36.onUpdateAttachment)
	arg2_36:AddListener(WorldMapAttachment.EventUpdateLurk, arg0_36.onUpdateAttachment)

	return var0_36
end

function var0_0.DisposeAttachment(arg0_37, arg1_37)
	local var0_37 = arg1_37.attachment

	var0_37:RemoveListener(WorldMapAttachment.EventUpdateFlag, arg0_37.onUpdateAttachment)
	var0_37:RemoveListener(WorldMapAttachment.EventUpdateData, arg0_37.onUpdateAttachment)
	var0_37:RemoveListener(WorldMapAttachment.EventUpdateLurk, arg0_37.onUpdateAttachment)

	local var1_37 = WSMapAttachment.GetResName(var0_37)

	arg0_37.wsPool:Return(var1_37, arg1_37.transform.gameObject)
	WPool:Return(arg1_37)
end

function var0_0.NewArtifact(arg0_38, arg1_38, arg2_38, arg3_38)
	local var0_38 = WPool:Get(WSMapArtifact)

	var0_38.transform:SetParent(arg1_38.rtArtifacts, false)
	var0_38:Setup(arg2_38, arg0_38.map.theme, arg3_38)

	return var0_38
end

function var0_0.DisposeArtifact(arg0_39, arg1_39)
	WPool:Return(arg1_39)
end

function var0_0.GetTerrainEffectParent(arg0_40, arg1_40)
	if arg1_40 == WorldMapCell.TerrainStream then
		return arg0_40.rtEffectB
	elseif arg1_40 == WorldMapCell.TerrainWind then
		return arg0_40.rtEffectC
	elseif arg1_40 == WorldMapCell.TerrainIce then
		return arg0_40.rtEffectA
	elseif arg1_40 == WorldMapCell.TerrainPoison then
		return arg0_40.rtEffectA
	else
		assert(false, "terrain type error: " .. arg1_40)
	end
end

function var0_0.NewTerrainEffect(arg0_41, arg1_41)
	local var0_41 = WPool:Get(WSMapCellEffect)

	var0_41.transform = createNewGameObject("mapCellEffect")

	var0_41.transform:SetParent(arg0_41:GetTerrainEffectParent(arg1_41:GetTerrain()), false)
	var0_41:Setup(arg1_41, arg0_41.map.theme)

	return var0_41
end

function var0_0.DisposeTerrainEffect(arg0_42, arg1_42)
	local var0_42 = arg1_42.transform

	WPool:Return(arg1_42)
	Destroy(var0_42)
end

function var0_0.GetTerrainEffect(arg0_43, arg1_43, arg2_43)
	for iter0_43, iter1_43 in ipairs(arg0_43.wsTerrainEffects) do
		if iter1_43.cell.row == arg1_43 and iter1_43.cell.column == arg2_43 then
			return iter1_43, iter0_43
		end
	end
end

function var0_0.NewFleet(arg0_44, arg1_44)
	local var0_44 = WPool:Get(WSMapFleet)
	local var1_44 = WSMapFleet.GetResName()

	var0_44.transform = arg0_44.wsPool:Get(var1_44).transform

	var0_44.transform:SetParent(arg0_44.rtCells, false)
	var0_44:Setup(arg1_44, arg0_44.map.theme)
	var0_44.rtRetreat:SetParent(arg0_44.rtTop, false)
	arg1_44:AddListener(WorldMapFleet.EventAddCarry, arg0_44.onAddCarry)
	arg1_44:AddListener(WorldMapFleet.EventRemoveCarry, arg0_44.onRemoveCarry)

	return var0_44
end

function var0_0.DisposeFleet(arg0_45, arg1_45)
	arg1_45.fleet:RemoveListener(WorldMapFleet.EventAddCarry, arg0_45.onAddCarry)
	arg1_45.fleet:RemoveListener(WorldMapFleet.EventRemoveCarry, arg0_45.onRemoveCarry)
	arg1_45.rtRetreat:SetParent(arg1_45.transform, false)
	arg0_45.wsPool:Return(WSMapFleet.GetResName(), arg1_45.transform.gameObject)
	WPool:Return(arg1_45)
end

function var0_0.NewCarryItem(arg0_46, arg1_46, arg2_46)
	local var0_46 = WPool:Get(WSCarryItem)
	local var1_46 = WSCarryItem.GetResName()

	var0_46.transform = arg0_46.wsPool:Get(var1_46).transform

	var0_46.transform:SetParent(arg0_46.rtCells, false)
	var0_46:Setup(arg1_46, arg2_46, arg0_46.map.theme)

	return var0_46
end

function var0_0.DisposeCarryItem(arg0_47, arg1_47)
	arg0_47.wsPool:Return(WSCarryItem.GetResName(), arg1_47.transform.gameObject)
	WPool:Return(arg1_47)
end

function var0_0.GetCarryItem(arg0_48, arg1_48)
	return _.detect(arg0_48.wsCarryItems, function(arg0_49)
		return arg0_49.carryItem == arg1_48
	end)
end

function var0_0.FindCarryItems(arg0_50, arg1_50)
	return _.filter(arg0_50.wsCarryItems, function(arg0_51)
		return arg0_51.fleet == arg1_50
	end)
end

function var0_0.GetFleet(arg0_52, arg1_52)
	arg1_52 = arg1_52 or arg0_52.map:GetFleet()

	return _.detect(arg0_52.wsMapFleets, function(arg0_53)
		return arg0_53.fleet == arg1_52
	end)
end

function var0_0.FindFleet(arg0_54, arg1_54, arg2_54)
	return _.detect(arg0_54.wsMapFleets, function(arg0_55)
		return arg0_55.fleet.row == arg1_54 and arg0_55.fleet.column == arg2_54
	end)
end

function var0_0.GetCell(arg0_56, arg1_56, arg2_56)
	local var0_56 = WSMapCell.GetName(arg1_56, arg2_56)

	return arg0_56.wsMapCells[var0_56]
end

function var0_0.GetAttachment(arg0_57, arg1_57, arg2_57, arg3_57)
	return _.detect(arg0_57.wsMapAttachments, function(arg0_58)
		return arg0_58.attachment.row == arg1_57 and arg0_58.attachment.column == arg2_57 and arg0_58.attachment.type == arg3_57
	end)
end

function var0_0.FindAttachments(arg0_59, arg1_59, arg2_59)
	return _.filter(arg0_59.wsMapAttachments, function(arg0_60)
		return arg0_60.attachment.row == arg1_59 and arg0_60.attachment.column == arg2_59
	end)
end

function var0_0.GetQuad(arg0_61, arg1_61, arg2_61)
	local var0_61 = WSMapQuad.GetName(arg1_61, arg2_61)

	return arg0_61.wsMapQuads[var0_61]
end

function var0_0.GetItem(arg0_62, arg1_62, arg2_62)
	local var0_62 = WSMapItem.GetName(arg1_62, arg2_62)

	return arg0_62.wsMapItems[var0_62]
end

function var0_0.GetTransport(arg0_63, arg1_63, arg2_63, arg3_63)
	local var0_63 = WSMapTransport.GetName(arg1_63, arg2_63, arg3_63)

	return arg0_63.wsMapTransports[var0_63]
end

function var0_0.UpdateRangeVisible(arg0_64, arg1_64)
	if arg0_64.rangeVisible ~= arg1_64 then
		arg0_64.rangeVisible = arg1_64

		if arg1_64 then
			arg0_64:DisplayMoveRange()
		else
			arg0_64:HideMoveRange()
		end
	end
end

function var0_0.DisplayMoveRange(arg0_65)
	arg0_65.displayRangeLines = {}

	local var0_65 = arg0_65.map:GetFleet()
	local var1_65 = nowWorld():GetMoveRange(var0_65)
	local var2_65 = 0

	for iter0_65, iter1_65 in ipairs(var1_65) do
		local var3_65 = arg0_65:GetQuad(iter1_65.row, iter1_65.column)

		setImageAlpha(var3_65.rtWalkQuad, math.pow(0.75, iter1_65.stay and iter1_65.stay - 1 or 0))
		setLocalScale(var3_65.rtWalkQuad, Vector3.zero)

		local var4_65 = ManhattonDist(var0_65, iter1_65)

		var2_65 = math.max(var2_65, var4_65)

		local var5_65 = {
			line = iter1_65
		}

		function var5_65.func()
			var5_65.uid = LeanTween.scale(var3_65.rtWalkQuad, Vector3.one, 0.2):setEase(LeanTweenType.easeInOutSine).uniqueId

			arg0_65.wsTimer:AddInMapTween(var5_65.uid)
		end

		arg0_65.displayRangeLines[var4_65] = arg0_65.displayRangeLines[var4_65] or {}

		table.insert(arg0_65.displayRangeLines[var4_65], var5_65)
	end

	if var2_65 > 0 then
		local var6_65 = 0

		arg0_65.displayRangeTimer = arg0_65.wsTimer:AddInMapTimer(function()
			var6_65 = var6_65 + 1

			if arg0_65.displayRangeLines[var6_65] then
				for iter0_67, iter1_67 in ipairs(arg0_65.displayRangeLines[var6_65]) do
					iter1_67.func()
				end
			end
		end, 0.1, var2_65)

		arg0_65.displayRangeTimer:Start()
	end
end

function var0_0.HideMoveRange(arg0_68)
	if arg0_68.displayRangeTimer then
		arg0_68.wsTimer:RemoveInMapTimer(arg0_68.displayRangeTimer)

		arg0_68.displayRangeTimer = nil
	end

	if arg0_68.displayRangeLines then
		for iter0_68, iter1_68 in pairs(arg0_68.displayRangeLines) do
			for iter2_68, iter3_68 in ipairs(iter1_68) do
				if iter3_68.uid then
					arg0_68.wsTimer:RemoveInMapTween(iter3_68.uid)
				end

				local var0_68 = iter3_68.line
				local var1_68 = arg0_68:GetQuad(var0_68.row, var0_68.column)

				setImageAlpha(var1_68.rtWalkQuad, 0)
				setLocalScale(var1_68.rtWalkQuad, Vector3.one)
			end
		end

		arg0_68.displayRangeLines = nil
	end
end

function var0_0.MovePath(arg0_69, arg1_69, arg2_69, arg3_69, arg4_69, arg5_69)
	local var0_69 = arg0_69.map
	local var1_69 = _.map(arg2_69, function(arg0_70)
		return arg0_69:GetQuad(arg0_70.row, arg0_70.column)
	end)
	local var2_69

	if arg5_69 then
		var2_69 = WPool:Get(WSMapEffect)
		var2_69.transform = createNewGameObject("mapEffect")

		var2_69.transform:SetParent(arg1_69.transform, false)

		var2_69.transform.anchoredPosition3D = Vector3.zero
		var2_69.transform.localEulerAngles = Vector3(arg0_69.map.theme.angle, 0, 0)
		var2_69.modelOrder = arg1_69.modelOrder

		var2_69:Setup(WorldConst.GetWindEffect())
		var2_69:Load()
	end

	local var3_69 = 0

	for iter0_69, iter1_69 in ipairs(var1_69) do
		LeanTween.cancel(iter1_69.rtWalkQuad)
		setLocalScale(iter1_69.rtWalkQuad, Vector3.one)
		setImageAlpha(iter1_69.rtWalkQuad, 0)
		LeanTween.alpha(iter1_69.rtWalkQuad, 1, arg2_69[iter0_69].duration / 2):setDelay(var3_69)

		var3_69 = var3_69 + arg2_69[iter0_69].duration / 2
	end

	local var4_69 = 0
	local var5_69

	local function var6_69(arg0_71, arg1_71, arg2_71)
		var4_69 = var4_69 + 1

		if var4_69 <= #var1_69 then
			local var0_71 = var1_69[var4_69]

			LeanTween.cancel(var0_71.rtWalkQuad)
			setImageAlpha(var0_71.rtWalkQuad, 1)
			LeanTween.alpha(var0_71.rtWalkQuad, 0, arg2_69[var4_69].duration)
		end
	end

	local var7_69

	local function var8_69()
		arg0_69.wsMapPath:RemoveListener(WSMapPath.EventArrivedStep, var6_69)
		arg0_69.wsMapPath:RemoveListener(WSMapPath.EventArrived, var8_69)
		_.each(var1_69, function(arg0_73)
			LeanTween.cancel(arg0_73.rtWalkQuad)
			setImageAlpha(arg0_73.rtWalkQuad, 0)
		end)

		if arg5_69 then
			local var0_72 = var2_69.transform

			WPool:Return(var2_69)
			Destroy(var0_72)
		end
	end

	arg0_69.wsMapPath:AddListener(WSMapPath.EventArrivedStep, var6_69)
	arg0_69.wsMapPath:AddListener(WSMapPath.EventArrived, var8_69)
	arg0_69.wsMapPath:UpdateObject(arg1_69)
	arg0_69.wsMapPath:UpdateAction(arg5_69 and WorldConst.ActionDrag or WorldConst.ActionMove)
	arg0_69.wsMapPath:UpdateDirType(arg4_69)
	arg0_69.wsMapPath:StartMove(arg3_69, arg2_69, arg5_69 and 100 or 0)

	return arg0_69.wsMapPath
end

function var0_0.FlushFleets(arg0_74)
	arg0_74:FlushFleetVisibility()
	arg0_74:FlushFleetRetreatBtn()
	arg0_74:FlushEnemyFightingMark()
	arg0_74:FlushTransportDisplay()

	local var0_74 = arg0_74.map:GetFleet()

	_.each(arg0_74.wsMapFleets, function(arg0_75)
		arg0_75:UpdateSelected(arg0_75.fleet == var0_74)
	end)
end

function var0_0.FlushFleetRetreatBtn(arg0_76)
	local var0_76 = arg0_76.map:GetFleet()

	_.each(arg0_76.wsMapFleets, function(arg0_77)
		local var0_77 = arg0_77.fleet
		local var1_77 = arg0_76.map:GetCell(var0_77.row, var0_77.column)
		local var2_77 = var1_77:ExistEnemy() and var0_77 == var0_76 and not WorldConst.IsWorldGuideEnemyId(var1_77:GetStageEnemy().id)

		setActive(arg0_77.rtRetreat, var2_77)

		if var2_77 then
			arg0_77.rtRetreat.localPosition = arg0_76.rtTop:InverseTransformPoint(arg0_77.transform.position) + Vector3(89, 0, 0)
			arg0_77.rtRetreat.localEulerAngles = Vector3(-arg0_76.map.theme.angle, 0, 0)

			arg0_77.rtRetreat:SetAsLastSibling()
		end
	end)
end

function var0_0.FlushEnemyFightingMark(arg0_78)
	_.each(arg0_78.wsMapAttachments, function(arg0_79)
		local var0_79 = arg0_79.attachment

		if WorldMapAttachment.IsEnemyType(var0_79.type) then
			arg0_79:UpdateIsFighting(arg0_78.map:ExistFleet(var0_79.row, var0_79.column))
		end
	end)
end

function var0_0.FlushTransportVisibleByFleet(arg0_80)
	for iter0_80, iter1_80 in pairs(arg0_80.wsMapTransports) do
		if not _.any(arg0_80.wsMapFleets, function(arg0_81)
			return ManhattonDist({
				row = arg0_81.fleet.row,
				column = arg0_81.fleet.column
			}, {
				row = iter1_80.row,
				column = iter1_80.column
			}) <= 1
		end) then
			arg0_80:DisposeTransport(iter1_80)

			arg0_80.wsMapTransports[iter0_80] = nil
		end
	end

	_.each(arg0_80.wsMapFleets, function(arg0_82)
		for iter0_82 = WorldConst.DirNone, WorldConst.DirLeft do
			local var0_82 = WorldConst.DirToLine(iter0_82)
			local var1_82 = arg0_80.map:GetCell(arg0_82.fleet.row + var0_82.row, arg0_82.fleet.column + var0_82.column)

			if var1_82 then
				for iter1_82 = WorldConst.DirUp, WorldConst.DirLeft do
					if bit.band(var1_82.dir, bit.lshift(1, iter1_82)) > 0 then
						local var2_82 = WSMapTransport.GetName(var1_82.row, var1_82.column, iter1_82)
						local var3_82 = arg0_80.wsMapTransports[var2_82]

						if not var3_82 then
							var3_82 = arg0_80:NewTransport(var1_82.row, var1_82.column, iter1_82)
							arg0_80.wsMapTransports[var2_82] = var3_82

							setActive(var3_82.rtClick, false)
						end

						local var4_82 = _.any(arg0_80.wsMapFleets, function(arg0_83)
							return arg0_83.fleet.row == var1_82.row and arg0_83.fleet.column == var1_82.column
						end)

						var3_82:UpdateAlpha(var4_82 and 1 or 0)
						setActive(var3_82.rtForbid, arg0_80.map.config.is_transfer == 0)
					end
				end
			end
		end
	end)
end

function var0_0.FlushFleetVisibility(arg0_84)
	underscore.each(arg0_84.wsMapFleets, function(arg0_85)
		local var0_85 = arg0_85.fleet
		local var1_85 = arg0_84.map:GetCell(var0_85.row, var0_85.column)
		local var2_85 = not var1_85:ExistEnemy() and not var1_85:InFog()

		arg0_85:UpdateActive(var2_85)
		_.each(arg0_84:FindCarryItems(var0_85), function(arg0_86)
			arg0_86:UpdateActive(var2_85)
		end)
	end)
end

function var0_0.UpdateSubmarineSupport(arg0_87)
	_.each(arg0_87.wsMapFleets, function(arg0_88)
		arg0_88:UpdateSubmarineSupport()
	end)
end

function var0_0.FlushMovingAttachment(arg0_89, arg1_89)
	if arg1_89.transform.parent ~= arg0_89.rtCells then
		arg1_89.transform:SetParent(arg0_89.rtCells, true)
	end

	local var0_89 = {
		row = arg1_89.attachment.row,
		column = arg1_89.attachment.column
	}

	if WorldMapAttachment.IsEnemyType(arg1_89.attachment.type) then
		local var1_89 = arg0_89:FindFleet(var0_89.row, var0_89.column)

		if var1_89 then
			var1_89:UpdateActive(true)
			setActive(var1_89.rtRetreat, false)
			arg1_89:UpdateIsFighting(false)
		end
	end

	arg0_89:FlushMovingAttachmentOrder(arg1_89, var0_89)
end

function var0_0.FlushMovingAttachmentOrder(arg0_90, arg1_90, arg2_90)
	local var0_90 = arg0_90:GetCell(arg2_90.row, arg2_90.column).cell

	setActive(arg1_90.transform, var0_90:GetInFOV() and not var0_90:InFog())
	arg1_90:SetModelOrder(arg1_90.attachment:GetModelOrder(), arg2_90.row)
end

function var0_0.UpdateTransportDisplay(arg0_91, arg1_91)
	if arg0_91.transportDisplay ~= arg1_91 then
		arg0_91.transportDisplay = arg1_91

		arg0_91:FlushTransportDisplay()
	end
end

function var0_0.FlushTransportDisplay(arg0_92)
	if arg0_92.transportDisplay == WorldConst.TransportDisplayNormal then
		arg0_92:FlushTransportVisibleByFleet()
	else
		arg0_92:FlushTransportVisibleByState()
	end
end

function var0_0.FlushTransportVisibleByState(arg0_93)
	local var0_93 = arg0_93.map:GetCellsInFOV()

	for iter0_93, iter1_93 in pairs(arg0_93.wsMapTransports) do
		if not _.any(var0_93, function(arg0_94)
			return arg0_94.row == iter1_93.row and arg0_94.column == iter1_93.column
		end) then
			arg0_93:DisposeTransport(iter1_93)

			arg0_93.wsMapTransports[iter0_93] = nil
		end
	end

	local var1_93 = WorldConst.DirUp

	_.each(var0_93, function(arg0_95)
		for iter0_95 = var1_93, WorldConst.DirLeft do
			if bit.band(arg0_95.dir, bit.lshift(1, iter0_95)) > 0 then
				local var0_95 = WSMapTransport.GetName(arg0_95.row, arg0_95.column, iter0_95)
				local var1_95 = arg0_93.wsMapTransports[var0_95]

				if not var1_95 then
					var1_95 = arg0_93:NewTransport(arg0_95.row, arg0_95.column, iter0_95)
					arg0_93.wsMapTransports[var0_95] = var1_95
				end

				setActive(var1_95.rtForbid, arg0_93.transportDisplay == WorldConst.TransportDisplayGuideForbid)
				setActive(var1_95.rtDanger, arg0_93.transportDisplay == WorldConst.TransportDisplayGuideDanger)
				var1_95:UpdateAlpha(1)
			end
		end
	end)
end

function var0_0.NewTargetArrow(arg0_96)
	arg0_96.rtTargetArrow = arg0_96.wsPool:Get("arrow_tpl").transform

	setActive(arg0_96.rtTargetArrow, false)
end

function var0_0.DisplayTargetArrow(arg0_97, arg1_97, arg2_97)
	local var0_97 = arg0_97:GetCell(arg1_97, arg2_97)

	arg0_97.rtTargetArrow:SetParent(var0_97.transform, false)

	arg0_97.rtTargetArrow.anchoredPosition = Vector2.zero
	arg0_97.rtTargetArrow.localEulerAngles = Vector3(-arg0_97.map.theme.angle, 0, 0)
	arg0_97.rtTargetArrow:GetComponent(typeof(Canvas)).sortingOrder = WorldConst.LOFleet + defaultValue(arg1_97, 0) * 10

	setActive(arg0_97.rtTargetArrow, true)
end

function var0_0.HideTargetArrow(arg0_98)
	arg0_98.rtTargetArrow:SetParent(arg0_98.transform, false)
	setActive(arg0_98.rtTargetArrow, false)
end

function var0_0.ClearTargetArrow(arg0_99)
	arg0_99.wsPool:Return("arrow_tpl", arg0_99.rtTargetArrow)
end

function var0_0.ShowScannerMap(arg0_100, arg1_100)
	for iter0_100, iter1_100 in pairs(arg0_100.wsMapQuads) do
		if arg1_100 then
			iter1_100:UpdateStatic(true, true)
		else
			iter1_100:UpdateStatic(false)
		end
	end
end

return var0_0
