local var0 = class("WSMap", import("...BaseEntity"))

var0.Fields = {
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
var0.Listeners = {
	onRemoveCarry = "OnRemoveCarry",
	onUpdateAttachment = "OnUpdateAttachment",
	onUpdateTerrain = "OnUpdateTerrain",
	onUpdateFleetFOV = "OnUpdateFleetFOV",
	onAddAttachment = "OnAddAttachment",
	onRemoveAttachment = "OnRemoveAttachment",
	onAddCarry = "OnAddCarry"
}
var0.EventUpdateEventTips = "WSMap.EventUpdateEventTips"

function var0.Setup(arg0, arg1)
	arg0.map = arg1
	arg0.wsMapQuads = {}
	arg0.wsMapItems = {}
	arg0.wsMapCells = {}
	arg0.wsMapFleets = {}
	arg0.wsMapArtifacts = {}
	arg0.wsMapArtifactsFA = {}
	arg0.wsMapTransports = {}
	arg0.wsMapAttachments = {}
	arg0.wsTerrainEffects = {}
	arg0.wsCarryItems = {}
	arg0.wsMapPath = WSMapPath.New()

	arg0.wsMapPath:Setup(arg0.map.theme)

	arg0.wsMapResource = WSMapResource.New()

	arg0.wsMapResource:Setup(arg0.map)

	arg0.transportDisplay = WorldConst.TransportDisplayNormal

	pg.DelegateInfo.New(arg0)
end

function var0.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0.wsMapPath:Dispose()
	arg0:ClearTargetArrow()
	arg0:Unload()
	arg0:Clear()
end

function var0.Load(arg0, arg1)
	local var0 = {}

	table.insert(var0, function(arg0)
		arg0:InitPlane(arg0)
	end)
	table.insert(var0, function(arg0)
		arg0.wsMapResource:Load(arg0)
	end)
	table.insert(var0, function(arg0)
		arg0:InitClutter()
		arg0:InitMap()
		arg0()
	end)
	seriesAsync(var0, arg1)
end

function var0.Unload(arg0)
	arg0:DisposeMap()
	arg0.wsMapResource:Unload()

	if arg0.transform then
		PoolMgr.GetInstance():ReturnPrefab("world/object/world_plane", "world_plane", arg0.transform.gameObject, true)

		arg0.transform = nil
	end
end

function var0.InitPlane(arg0, arg1)
	PoolMgr.GetInstance():GetPrefab("world/object/world_plane", "world_plane", true, function(arg0)
		arg0.transform = arg0.transform

		setActive(arg0.transform, false)

		arg0.rtQuads = arg0.transform:Find("quads")
		arg0.rtItems = arg0.transform:Find("items")
		arg0.rtCells = arg0.transform:Find("cells")
		arg0.rtTop = arg0.transform:Find("top")
		arg0.rtEffectA = arg0.transform:Find("effect-a-1-999")
		arg0.rtEffectB = arg0.transform:Find("effect-b-1001-1999")
		arg0.rtEffectC = arg0.transform:Find("effect-c-2001-2999")

		local var0 = arg0.map

		assert(var0 and var0.active, "map not exist or map not active.")

		local var1 = var0.theme
		local var2 = arg0.transform

		var2.name = "plane"
		var2.anchoredPosition3D = Vector3(var1.offsetx, var1.offsety, var1.offsetz) + WorldConst.DefaultMapOffset

		local var3 = var2:Find("display")
		local var4 = var3:Find("mask/sea")

		setImageAlpha(var4, 0)
		GetSpriteFromAtlasAsync("chapter/pic/" .. var1.assetSea, var1.assetSea, function(arg0)
			if var4 then
				setImageSprite(var4, arg0, false)
				setImageAlpha(var4, 1)
			end
		end)

		local var5 = Vector2(10000, 10000)
		local var6 = Vector2.zero
		local var7 = Vector2(WorldConst.MaxColumn, WorldConst.MaxRow)
		local var8 = Vector2(-WorldConst.MaxColumn, -WorldConst.MaxRow)

		for iter0 = 0, WorldConst.MaxRow - 1 do
			for iter1 = 0, WorldConst.MaxColumn - 1 do
				if var0:GetCell(iter0, iter1) then
					var5.x = math.min(var5.x, iter1)
					var5.y = math.min(var5.y, WorldConst.MaxRow * 0.5 - iter0 - 1)
					var7.x = math.min(var7.x, iter1)
					var7.y = math.min(var7.y, iter0)
					var8.x = math.max(var8.x, iter1)
					var8.y = math.max(var8.y, iter0)
				end
			end
		end

		local var9 = var1.cellSize + var1.cellSpace

		var5.x = var5.x * var9.x
		var5.y = var5.y * var9.y
		var6.x = (var8.x - var7.x + 1) * var9.x
		var6.y = (var8.y - var7.y + 1) * var9.y
		var3.anchoredPosition = var5 + var6 * 0.5
		var3.sizeDelta = var6

		local var10 = Vector2(math.floor(var3.sizeDelta.x / var9.x), math.floor(var3.sizeDelta.y / var9.y))
		local var11 = var3:Find("linev")
		local var12 = var11:GetChild(0)
		local var13 = var11:GetComponent(typeof(GridLayoutGroup))

		var13.cellSize = Vector2(WorldConst.LineCross, var3.sizeDelta.y)
		var13.spacing = Vector2(var9.x - WorldConst.LineCross, 0)
		var13.padding.left = math.floor(var13.spacing.x)

		for iter2 = var11.childCount - 1, math.max(var10.x - 1, 0), -1 do
			if iter2 > 0 then
				Destroy(var11:GetChild(iter2))
			end
		end

		for iter3 = var11.childCount, var10.x - 2 do
			Instantiate(var12).transform:SetParent(var11, false)
		end

		local var14 = var3:Find("lineh")
		local var15 = var14:GetChild(0)
		local var16 = var14:GetComponent(typeof(GridLayoutGroup))

		var16.cellSize = Vector2(var3.sizeDelta.x, WorldConst.LineCross)
		var16.spacing = Vector2(0, var9.y - WorldConst.LineCross)
		var16.padding.top = math.floor(var16.spacing.y)

		for iter4 = var14.childCount - 1, math.max(var10.y - 1, 0), -1 do
			if iter4 > 0 then
				Destroy(var14:GetChild(iter4))
			end
		end

		for iter5 = var14.childCount, var10.y - 2 do
			Instantiate(var15).transform:SetParent(var14, false)
		end

		arg1()
	end)
end

function var0.InitClutter(arg0)
	arg0.twTimer = LeanTween.value(arg0.transform.gameObject, 1, 0, WorldConst.QuadBlinkDuration):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

	arg0.wsTimer:AddInMapTween(arg0.twTimer.uniqueId)
	arg0:NewTargetArrow()
end

function var0.InitMap(arg0)
	local var0 = arg0.map
	local var1 = var0.theme
	local var2 = _.values(var0.cells)

	table.sort(var2, function(arg0, arg1)
		return arg0.row < arg1.row or arg0.row == arg1.row and arg0.column < arg1.column
	end)

	for iter0, iter1 in ipairs(var2) do
		local var3 = arg0:NewQuad(iter1)

		arg0.wsMapQuads[WSMapQuad.GetName(iter1.row, iter1.column)] = var3

		local var4 = arg0:NewCell(iter1)

		arg0.wsMapCells[WSMapCell.GetName(iter1.row, iter1.column)] = var4
	end

	for iter2, iter3 in ipairs(var0.config.float_items) do
		local var5 = iter3[1]
		local var6 = iter3[2]
		local var7 = var0:GetCell(var5, var6)

		if var7 then
			local var8 = arg0:GetItem(var5, var6)

			if not var8 then
				var8 = arg0:NewItem(var7)
				arg0.wsMapItems[WSMapItem.GetName(var7.row, var7.column)] = var8
			end

			local var9 = arg0:NewArtifact(var8, iter3)

			table.insert(arg0.wsMapArtifacts, var9)
		end
	end

	for iter4, iter5 in ipairs(var2) do
		for iter6, iter7 in ipairs(iter5.attachments) do
			local var10 = arg0:GetCell(iter7.row, iter7.column)

			if iter7.type == WorldMapAttachment.TypeArtifact then
				local var11 = arg0:GetItem(iter5.row, iter5.column)

				if not var11 then
					var11 = arg0:NewItem(iter5)
					arg0.wsMapItems[WSMapItem.GetName(iter5.row, iter5.column)] = var11
				end

				local var12 = arg0:NewArtifact(var11, iter7:GetArtifaceInfo(), iter7)

				table.insert(arg0.wsMapArtifactsFA, var12)
			else
				local var13 = arg0:NewAttachment(var10, iter7)

				table.insert(arg0.wsMapAttachments, var13)
			end
		end
	end

	for iter8, iter9 in ipairs(var0:GetNormalFleets()) do
		local var14 = arg0:NewFleet(iter9)

		table.insert(arg0.wsMapFleets, var14)

		for iter10, iter11 in ipairs(iter9:GetCarries()) do
			local var15 = arg0:NewCarryItem(iter9, iter11)

			table.insert(arg0.wsCarryItems, var15)
		end
	end

	arg0:FlushFleets()
	var0:AddListener(WorldMap.EventUpdateFleetFOV, arg0.onUpdateFleetFOV)
end

function var0.DisposeMap(arg0)
	arg0.map:RemoveListener(WorldMap.EventUpdateFleetFOV, arg0.onUpdateFleetFOV)
	_.each(arg0.wsCarryItems, function(arg0)
		arg0:DisposeCarryItem(arg0)
	end)

	arg0.wsCarryItems = {}

	_.each(arg0.wsMapFleets, function(arg0)
		arg0:DisposeFleet(arg0)
	end)

	arg0.wsMapFleets = {}

	_.each(arg0.wsMapAttachments, function(arg0)
		arg0:DisposeAttachment(arg0)
	end)

	arg0.wsMapAttachments = {}

	_.each(arg0.wsMapArtifacts, function(arg0)
		arg0:DisposeArtifact(arg0)
	end)

	arg0.wsMapArtifacts = {}

	for iter0, iter1 in pairs(arg0.wsMapTransports) do
		arg0:DisposeTransport(iter1)
	end

	arg0.wsMapTransports = {}

	_.each(arg0.wsMapArtifactsFA, function(arg0)
		arg0:DisposeArtifact(arg0)
	end)

	arg0.wsMapArtifactsFA = {}

	for iter2, iter3 in pairs(arg0.wsMapCells) do
		arg0:DisposeCell(iter3)
	end

	arg0.wsMapCells = {}

	for iter4, iter5 in pairs(arg0.wsMapItems) do
		arg0:DisposeItem(iter5)
	end

	arg0.wsMapItems = {}

	for iter6, iter7 in pairs(arg0.wsMapQuads) do
		arg0:DisposeQuad(iter7)
	end

	arg0.wsMapQuads = {}

	for iter8, iter9 in ipairs(arg0.wsTerrainEffects) do
		arg0:DisposeTerrainEffect(iter9)
	end

	arg0.wsTerrainEffects = {}
end

function var0.OnAddAttachment(arg0, arg1, arg2, arg3)
	local var0 = arg0:GetCell(arg2.row, arg2.column)

	assert(var0, "cell not exist: " .. arg2.row .. ", " .. arg2.column)

	if arg3.type == WorldMapAttachment.TypeArtifact then
		local var1 = arg0:GetItem(arg2.row, arg2.column)

		if not var1 then
			var1 = arg0:NewItem(arg2)
			arg0.wsMapItems[WSMapItem.GetName(arg2.row, arg2.column)] = var1
		end

		local var2 = arg0:NewArtifact(var1, arg3:GetArtifaceInfo(), arg3)

		table.insert(arg0.wsMapArtifactsFA, var2)
	else
		local var3 = arg0:NewAttachment(var0, arg3)

		table.insert(arg0.wsMapAttachments, var3)
		arg0:OnUpdateAttachment(nil, arg3)
	end
end

function var0.OnRemoveAttachment(arg0, arg1, arg2, arg3)
	if arg3.type == WorldMapAttachment.TypeArtifact then
		for iter0 = #arg0.wsMapArtifactsFA, 1, -1 do
			local var0 = arg0.wsMapArtifactsFA[iter0]

			if var0.attachment == arg3 then
				arg0:DisposeArtifact(var0)
				table.remove(arg0.wsMapArtifactsFA, iter0)

				break
			end
		end
	else
		for iter1 = #arg0.wsMapAttachments, 1, -1 do
			local var1 = arg0.wsMapAttachments[iter1]

			if var1.attachment == arg3 then
				arg0:DisposeAttachment(var1)
				table.remove(arg0.wsMapAttachments, iter1)
				arg0:OnUpdateAttachment(nil, arg3)

				break
			end
		end
	end
end

function var0.OnUpdateAttachment(arg0, arg1, arg2)
	local var0 = arg0:FindAttachments(arg2.row, arg2.column)

	_.each(var0, function(arg0)
		arg0:Update(arg1)
	end)

	if arg0:FindFleet(arg2.row, arg2.column) then
		arg0:FlushFleets()
	end

	arg0:DispatchEvent(var0.EventUpdateEventTips)
end

function var0.OnUpdateTerrain(arg0, arg1, arg2)
	local var0, var1 = arg0:GetTerrainEffect(arg2.row, arg2.column)

	if var0 then
		arg0:DisposeTerrainEffect(var0)
		table.remove(arg0.wsTerrainEffects, var1)
	end

	local var2 = arg2:GetTerrain()

	if var2 == WorldMapCell.TerrainStream or var2 == WorldMapCell.TerrainWind or var2 == WorldMapCell.TerrainIce or var2 == WorldMapCell.TerrainPoison then
		local var3 = arg0:NewTerrainEffect(arg2)

		table.insert(arg0.wsTerrainEffects, var3)
	end
end

function var0.OnAddCarry(arg0, arg1, arg2, arg3)
	local var0 = arg0:NewCarryItem(arg2, arg3)

	table.insert(arg0.wsCarryItems, var0)
end

function var0.OnRemoveCarry(arg0, arg1, arg2, arg3)
	for iter0 = #arg0.wsCarryItems, 1, -1 do
		local var0 = arg0.wsCarryItems[iter0]

		if var0.carryItem == arg3 then
			arg0:DisposeCarryItem(var0)
			table.remove(arg0.wsCarryItems, iter0)

			break
		end
	end
end

function var0.OnUpdateFleetFOV(arg0)
	arg0:FlushFleets()
end

function var0.NewQuad(arg0, arg1)
	local var0 = WPool:Get(WSMapQuad)
	local var1 = WSMapQuad.GetResName()

	var0.transform = arg0.wsPool:Get(var1).transform

	var0.transform:SetParent(arg0.rtQuads, false)

	var0.twTimer = arg0.twTimer

	var0:Setup(arg1, arg0.map.theme)

	return var0
end

function var0.DisposeQuad(arg0, arg1)
	local var0 = WSMapQuad.GetResName()

	arg0.wsPool:Return(var0, arg1.transform.gameObject)
	WPool:Return(arg1)
end

function var0.NewItem(arg0, arg1)
	local var0 = WPool:Get(WSMapItem)
	local var1 = WSMapItem.GetResName()

	var0.transform = arg0.wsPool:Get(var1).transform

	var0.transform:SetParent(arg0.rtItems, false)
	var0:Setup(arg1, arg0.map.theme)

	return var0
end

function var0.DisposeItem(arg0, arg1)
	local var0 = WSMapItem.GetResName()

	arg0.wsPool:Return(var0, arg1.transform.gameObject)
	WPool:Return(arg1)
end

function var0.NewCell(arg0, arg1)
	local var0 = WPool:Get(WSMapCell)
	local var1 = WSMapCell.GetResName()

	var0.transform = arg0.wsPool:Get(var1).transform

	var0.transform:SetParent(arg0.rtCells, false)

	var0.wsMapResource = arg0.wsMapResource
	var0.wsTimer = arg0.wsTimer

	var0:Setup(arg0.map, arg1)
	var0.rtFog:SetParent(arg0.rtCells:Find("fogs"), true)
	arg1:AddListener(WorldMapCell.EventAddAttachment, arg0.onAddAttachment)
	arg1:AddListener(WorldMapCell.EventRemoveAttachment, arg0.onRemoveAttachment)
	arg1:AddListener(WorldMapCell.EventUpdateTerrain, arg0.onUpdateTerrain)
	arg0:OnUpdateTerrain(nil, arg1)

	return var0
end

function var0.DisposeCell(arg0, arg1)
	local var0 = arg1.cell

	arg1.rtFog:SetParent(arg1.transform, true)
	var0:RemoveListener(WorldMapCell.EventAddAttachment, arg0.onAddAttachment)
	var0:RemoveListener(WorldMapCell.EventRemoveAttachment, arg0.onRemoveAttachment)
	var0:RemoveListener(WorldMapCell.EventUpdateTerrain, arg0.onUpdateTerrain)

	local var1 = WSMapCell.GetResName()

	arg0.wsPool:Return(var1, arg1.transform.gameObject)
	WPool:Return(arg1)
end

function var0.NewTransport(arg0, arg1, arg2, arg3)
	local var0 = WPool:Get(WSMapTransport)
	local var1 = WSMapTransport.GetResName()

	var0.transform = arg0.wsPool:Get(var1).transform

	var0.transform:SetParent(arg0.rtQuads, false)

	var0.wsMapPath = arg0.wsMapPath

	var0:Setup(arg1, arg2, arg3, arg0.map)

	return var0
end

function var0.DisposeTransport(arg0, arg1)
	local var0 = WSMapTransport.GetResName()

	arg0.wsPool:Return(var0, arg1.transform.gameObject)
	WPool:Return(arg1)
end

function var0.NewAttachment(arg0, arg1, arg2)
	local var0 = WPool:Get(WSMapAttachment)
	local var1 = WSMapAttachment.GetResName(arg2)

	var0.transform = arg0.wsPool:Get(var1).transform

	var0.transform:SetParent(arg1.rtAttachments, false)

	var0.twTimer = arg0.twTimer

	var0:Setup(arg0.map, arg1.cell, arg2)
	arg2:AddListener(WorldMapAttachment.EventUpdateFlag, arg0.onUpdateAttachment)
	arg2:AddListener(WorldMapAttachment.EventUpdateData, arg0.onUpdateAttachment)
	arg2:AddListener(WorldMapAttachment.EventUpdateLurk, arg0.onUpdateAttachment)

	return var0
end

function var0.DisposeAttachment(arg0, arg1)
	local var0 = arg1.attachment

	var0:RemoveListener(WorldMapAttachment.EventUpdateFlag, arg0.onUpdateAttachment)
	var0:RemoveListener(WorldMapAttachment.EventUpdateData, arg0.onUpdateAttachment)
	var0:RemoveListener(WorldMapAttachment.EventUpdateLurk, arg0.onUpdateAttachment)

	local var1 = WSMapAttachment.GetResName(var0)

	arg0.wsPool:Return(var1, arg1.transform.gameObject)
	WPool:Return(arg1)
end

function var0.NewArtifact(arg0, arg1, arg2, arg3)
	local var0 = WPool:Get(WSMapArtifact)

	var0.transform:SetParent(arg1.rtArtifacts, false)
	var0:Setup(arg2, arg0.map.theme, arg3)

	return var0
end

function var0.DisposeArtifact(arg0, arg1)
	WPool:Return(arg1)
end

function var0.GetTerrainEffectParent(arg0, arg1)
	if arg1 == WorldMapCell.TerrainStream then
		return arg0.rtEffectB
	elseif arg1 == WorldMapCell.TerrainWind then
		return arg0.rtEffectC
	elseif arg1 == WorldMapCell.TerrainIce then
		return arg0.rtEffectA
	elseif arg1 == WorldMapCell.TerrainPoison then
		return arg0.rtEffectA
	else
		assert(false, "terrain type error: " .. arg1)
	end
end

function var0.NewTerrainEffect(arg0, arg1)
	local var0 = WPool:Get(WSMapCellEffect)

	var0.transform = createNewGameObject("mapCellEffect")

	var0.transform:SetParent(arg0:GetTerrainEffectParent(arg1:GetTerrain()), false)
	var0:Setup(arg1, arg0.map.theme)

	return var0
end

function var0.DisposeTerrainEffect(arg0, arg1)
	local var0 = arg1.transform

	WPool:Return(arg1)
	Destroy(var0)
end

function var0.GetTerrainEffect(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg0.wsTerrainEffects) do
		if iter1.cell.row == arg1 and iter1.cell.column == arg2 then
			return iter1, iter0
		end
	end
end

function var0.NewFleet(arg0, arg1)
	local var0 = WPool:Get(WSMapFleet)
	local var1 = WSMapFleet.GetResName()

	var0.transform = arg0.wsPool:Get(var1).transform

	var0.transform:SetParent(arg0.rtCells, false)
	var0:Setup(arg1, arg0.map.theme)
	var0.rtRetreat:SetParent(arg0.rtTop, false)
	arg1:AddListener(WorldMapFleet.EventAddCarry, arg0.onAddCarry)
	arg1:AddListener(WorldMapFleet.EventRemoveCarry, arg0.onRemoveCarry)

	return var0
end

function var0.DisposeFleet(arg0, arg1)
	arg1.fleet:RemoveListener(WorldMapFleet.EventAddCarry, arg0.onAddCarry)
	arg1.fleet:RemoveListener(WorldMapFleet.EventRemoveCarry, arg0.onRemoveCarry)
	arg1.rtRetreat:SetParent(arg1.transform, false)
	arg0.wsPool:Return(WSMapFleet.GetResName(), arg1.transform.gameObject)
	WPool:Return(arg1)
end

function var0.NewCarryItem(arg0, arg1, arg2)
	local var0 = WPool:Get(WSCarryItem)
	local var1 = WSCarryItem.GetResName()

	var0.transform = arg0.wsPool:Get(var1).transform

	var0.transform:SetParent(arg0.rtCells, false)
	var0:Setup(arg1, arg2, arg0.map.theme)

	return var0
end

function var0.DisposeCarryItem(arg0, arg1)
	arg0.wsPool:Return(WSCarryItem.GetResName(), arg1.transform.gameObject)
	WPool:Return(arg1)
end

function var0.GetCarryItem(arg0, arg1)
	return _.detect(arg0.wsCarryItems, function(arg0)
		return arg0.carryItem == arg1
	end)
end

function var0.FindCarryItems(arg0, arg1)
	return _.filter(arg0.wsCarryItems, function(arg0)
		return arg0.fleet == arg1
	end)
end

function var0.GetFleet(arg0, arg1)
	arg1 = arg1 or arg0.map:GetFleet()

	return _.detect(arg0.wsMapFleets, function(arg0)
		return arg0.fleet == arg1
	end)
end

function var0.FindFleet(arg0, arg1, arg2)
	return _.detect(arg0.wsMapFleets, function(arg0)
		return arg0.fleet.row == arg1 and arg0.fleet.column == arg2
	end)
end

function var0.GetCell(arg0, arg1, arg2)
	local var0 = WSMapCell.GetName(arg1, arg2)

	return arg0.wsMapCells[var0]
end

function var0.GetAttachment(arg0, arg1, arg2, arg3)
	return _.detect(arg0.wsMapAttachments, function(arg0)
		return arg0.attachment.row == arg1 and arg0.attachment.column == arg2 and arg0.attachment.type == arg3
	end)
end

function var0.FindAttachments(arg0, arg1, arg2)
	return _.filter(arg0.wsMapAttachments, function(arg0)
		return arg0.attachment.row == arg1 and arg0.attachment.column == arg2
	end)
end

function var0.GetQuad(arg0, arg1, arg2)
	local var0 = WSMapQuad.GetName(arg1, arg2)

	return arg0.wsMapQuads[var0]
end

function var0.GetItem(arg0, arg1, arg2)
	local var0 = WSMapItem.GetName(arg1, arg2)

	return arg0.wsMapItems[var0]
end

function var0.GetTransport(arg0, arg1, arg2, arg3)
	local var0 = WSMapTransport.GetName(arg1, arg2, arg3)

	return arg0.wsMapTransports[var0]
end

function var0.UpdateRangeVisible(arg0, arg1)
	if arg0.rangeVisible ~= arg1 then
		arg0.rangeVisible = arg1

		if arg1 then
			arg0:DisplayMoveRange()
		else
			arg0:HideMoveRange()
		end
	end
end

function var0.DisplayMoveRange(arg0)
	arg0.displayRangeLines = {}

	local var0 = arg0.map:GetFleet()
	local var1 = nowWorld():GetMoveRange(var0)
	local var2 = 0

	for iter0, iter1 in ipairs(var1) do
		local var3 = arg0:GetQuad(iter1.row, iter1.column)

		setImageAlpha(var3.rtWalkQuad, math.pow(0.75, iter1.stay and iter1.stay - 1 or 0))
		setLocalScale(var3.rtWalkQuad, Vector3.zero)

		local var4 = ManhattonDist(var0, iter1)

		var2 = math.max(var2, var4)

		local var5 = {
			line = iter1
		}

		function var5.func()
			var5.uid = LeanTween.scale(var3.rtWalkQuad, Vector3.one, 0.2):setEase(LeanTweenType.easeInOutSine).uniqueId

			arg0.wsTimer:AddInMapTween(var5.uid)
		end

		arg0.displayRangeLines[var4] = arg0.displayRangeLines[var4] or {}

		table.insert(arg0.displayRangeLines[var4], var5)
	end

	if var2 > 0 then
		local var6 = 0

		arg0.displayRangeTimer = arg0.wsTimer:AddInMapTimer(function()
			var6 = var6 + 1

			if arg0.displayRangeLines[var6] then
				for iter0, iter1 in ipairs(arg0.displayRangeLines[var6]) do
					iter1.func()
				end
			end
		end, 0.1, var2)

		arg0.displayRangeTimer:Start()
	end
end

function var0.HideMoveRange(arg0)
	if arg0.displayRangeTimer then
		arg0.wsTimer:RemoveInMapTimer(arg0.displayRangeTimer)

		arg0.displayRangeTimer = nil
	end

	if arg0.displayRangeLines then
		for iter0, iter1 in pairs(arg0.displayRangeLines) do
			for iter2, iter3 in ipairs(iter1) do
				if iter3.uid then
					arg0.wsTimer:RemoveInMapTween(iter3.uid)
				end

				local var0 = iter3.line
				local var1 = arg0:GetQuad(var0.row, var0.column)

				setImageAlpha(var1.rtWalkQuad, 0)
				setLocalScale(var1.rtWalkQuad, Vector3.one)
			end
		end

		arg0.displayRangeLines = nil
	end
end

function var0.MovePath(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg0.map
	local var1 = _.map(arg2, function(arg0)
		return arg0:GetQuad(arg0.row, arg0.column)
	end)
	local var2

	if arg5 then
		var2 = WPool:Get(WSMapEffect)
		var2.transform = createNewGameObject("mapEffect")

		var2.transform:SetParent(arg1.transform, false)

		var2.transform.anchoredPosition3D = Vector3.zero
		var2.transform.localEulerAngles = Vector3(arg0.map.theme.angle, 0, 0)
		var2.modelOrder = arg1.modelOrder

		var2:Setup(WorldConst.GetWindEffect())
		var2:Load()
	end

	local var3 = 0

	for iter0, iter1 in ipairs(var1) do
		LeanTween.cancel(iter1.rtWalkQuad)
		setLocalScale(iter1.rtWalkQuad, Vector3.one)
		setImageAlpha(iter1.rtWalkQuad, 0)
		LeanTween.alpha(iter1.rtWalkQuad, 1, arg2[iter0].duration / 2):setDelay(var3)

		var3 = var3 + arg2[iter0].duration / 2
	end

	local var4 = 0
	local var5

	local function var6(arg0, arg1, arg2)
		var4 = var4 + 1

		if var4 <= #var1 then
			local var0 = var1[var4]

			LeanTween.cancel(var0.rtWalkQuad)
			setImageAlpha(var0.rtWalkQuad, 1)
			LeanTween.alpha(var0.rtWalkQuad, 0, arg2[var4].duration)
		end
	end

	local var7

	local function var8()
		arg0.wsMapPath:RemoveListener(WSMapPath.EventArrivedStep, var6)
		arg0.wsMapPath:RemoveListener(WSMapPath.EventArrived, var8)
		_.each(var1, function(arg0)
			LeanTween.cancel(arg0.rtWalkQuad)
			setImageAlpha(arg0.rtWalkQuad, 0)
		end)

		if arg5 then
			local var0 = var2.transform

			WPool:Return(var2)
			Destroy(var0)
		end
	end

	arg0.wsMapPath:AddListener(WSMapPath.EventArrivedStep, var6)
	arg0.wsMapPath:AddListener(WSMapPath.EventArrived, var8)
	arg0.wsMapPath:UpdateObject(arg1)
	arg0.wsMapPath:UpdateAction(arg5 and WorldConst.ActionDrag or WorldConst.ActionMove)
	arg0.wsMapPath:UpdateDirType(arg4)
	arg0.wsMapPath:StartMove(arg3, arg2, arg5 and 100 or 0)

	return arg0.wsMapPath
end

function var0.FlushFleets(arg0)
	arg0:FlushFleetVisibility()
	arg0:FlushFleetRetreatBtn()
	arg0:FlushEnemyFightingMark()
	arg0:FlushTransportDisplay()

	local var0 = arg0.map:GetFleet()

	_.each(arg0.wsMapFleets, function(arg0)
		arg0:UpdateSelected(arg0.fleet == var0)
	end)
end

function var0.FlushFleetRetreatBtn(arg0)
	local var0 = arg0.map:GetFleet()

	_.each(arg0.wsMapFleets, function(arg0)
		local var0 = arg0.fleet
		local var1 = arg0.map:GetCell(var0.row, var0.column)
		local var2 = var1:ExistEnemy() and var0 == var0 and not WorldConst.IsWorldGuideEnemyId(var1:GetStageEnemy().id)

		setActive(arg0.rtRetreat, var2)

		if var2 then
			arg0.rtRetreat.localPosition = arg0.rtTop:InverseTransformPoint(arg0.transform.position) + Vector3(89, 0, 0)
			arg0.rtRetreat.localEulerAngles = Vector3(-arg0.map.theme.angle, 0, 0)

			arg0.rtRetreat:SetAsLastSibling()
		end
	end)
end

function var0.FlushEnemyFightingMark(arg0)
	_.each(arg0.wsMapAttachments, function(arg0)
		local var0 = arg0.attachment

		if WorldMapAttachment.IsEnemyType(var0.type) then
			arg0:UpdateIsFighting(arg0.map:ExistFleet(var0.row, var0.column))
		end
	end)
end

function var0.FlushTransportVisibleByFleet(arg0)
	for iter0, iter1 in pairs(arg0.wsMapTransports) do
		if not _.any(arg0.wsMapFleets, function(arg0)
			return ManhattonDist({
				row = arg0.fleet.row,
				column = arg0.fleet.column
			}, {
				row = iter1.row,
				column = iter1.column
			}) <= 1
		end) then
			arg0:DisposeTransport(iter1)

			arg0.wsMapTransports[iter0] = nil
		end
	end

	_.each(arg0.wsMapFleets, function(arg0)
		for iter0 = WorldConst.DirNone, WorldConst.DirLeft do
			local var0 = WorldConst.DirToLine(iter0)
			local var1 = arg0.map:GetCell(arg0.fleet.row + var0.row, arg0.fleet.column + var0.column)

			if var1 then
				for iter1 = WorldConst.DirUp, WorldConst.DirLeft do
					if bit.band(var1.dir, bit.lshift(1, iter1)) > 0 then
						local var2 = WSMapTransport.GetName(var1.row, var1.column, iter1)
						local var3 = arg0.wsMapTransports[var2]

						if not var3 then
							var3 = arg0:NewTransport(var1.row, var1.column, iter1)
							arg0.wsMapTransports[var2] = var3

							setActive(var3.rtClick, false)
						end

						local var4 = _.any(arg0.wsMapFleets, function(arg0)
							return arg0.fleet.row == var1.row and arg0.fleet.column == var1.column
						end)

						var3:UpdateAlpha(var4 and 1 or 0)
						setActive(var3.rtForbid, arg0.map.config.is_transfer == 0)
					end
				end
			end
		end
	end)
end

function var0.FlushFleetVisibility(arg0)
	underscore.each(arg0.wsMapFleets, function(arg0)
		local var0 = arg0.fleet
		local var1 = arg0.map:GetCell(var0.row, var0.column)
		local var2 = not var1:ExistEnemy() and not var1:InFog()

		arg0:UpdateActive(var2)
		_.each(arg0:FindCarryItems(var0), function(arg0)
			arg0:UpdateActive(var2)
		end)
	end)
end

function var0.UpdateSubmarineSupport(arg0)
	_.each(arg0.wsMapFleets, function(arg0)
		arg0:UpdateSubmarineSupport()
	end)
end

function var0.FlushMovingAttachment(arg0, arg1)
	if arg1.transform.parent ~= arg0.rtCells then
		arg1.transform:SetParent(arg0.rtCells, true)
	end

	local var0 = {
		row = arg1.attachment.row,
		column = arg1.attachment.column
	}

	if WorldMapAttachment.IsEnemyType(arg1.attachment.type) then
		local var1 = arg0:FindFleet(var0.row, var0.column)

		if var1 then
			var1:UpdateActive(true)
			setActive(var1.rtRetreat, false)
			arg1:UpdateIsFighting(false)
		end
	end

	arg0:FlushMovingAttachmentOrder(arg1, var0)
end

function var0.FlushMovingAttachmentOrder(arg0, arg1, arg2)
	local var0 = arg0:GetCell(arg2.row, arg2.column).cell

	setActive(arg1.transform, var0:GetInFOV() and not var0:InFog())
	arg1:SetModelOrder(arg1.attachment:GetModelOrder(), arg2.row)
end

function var0.UpdateTransportDisplay(arg0, arg1)
	if arg0.transportDisplay ~= arg1 then
		arg0.transportDisplay = arg1

		arg0:FlushTransportDisplay()
	end
end

function var0.FlushTransportDisplay(arg0)
	if arg0.transportDisplay == WorldConst.TransportDisplayNormal then
		arg0:FlushTransportVisibleByFleet()
	else
		arg0:FlushTransportVisibleByState()
	end
end

function var0.FlushTransportVisibleByState(arg0)
	local var0 = arg0.map:GetCellsInFOV()

	for iter0, iter1 in pairs(arg0.wsMapTransports) do
		if not _.any(var0, function(arg0)
			return arg0.row == iter1.row and arg0.column == iter1.column
		end) then
			arg0:DisposeTransport(iter1)

			arg0.wsMapTransports[iter0] = nil
		end
	end

	local var1 = WorldConst.DirUp

	_.each(var0, function(arg0)
		for iter0 = var1, WorldConst.DirLeft do
			if bit.band(arg0.dir, bit.lshift(1, iter0)) > 0 then
				local var0 = WSMapTransport.GetName(arg0.row, arg0.column, iter0)
				local var1 = arg0.wsMapTransports[var0]

				if not var1 then
					var1 = arg0:NewTransport(arg0.row, arg0.column, iter0)
					arg0.wsMapTransports[var0] = var1
				end

				setActive(var1.rtForbid, arg0.transportDisplay == WorldConst.TransportDisplayGuideForbid)
				setActive(var1.rtDanger, arg0.transportDisplay == WorldConst.TransportDisplayGuideDanger)
				var1:UpdateAlpha(1)
			end
		end
	end)
end

function var0.NewTargetArrow(arg0)
	arg0.rtTargetArrow = arg0.wsPool:Get("arrow_tpl").transform

	setActive(arg0.rtTargetArrow, false)
end

function var0.DisplayTargetArrow(arg0, arg1, arg2)
	local var0 = arg0:GetCell(arg1, arg2)

	arg0.rtTargetArrow:SetParent(var0.transform, false)

	arg0.rtTargetArrow.anchoredPosition = Vector2.zero
	arg0.rtTargetArrow.localEulerAngles = Vector3(-arg0.map.theme.angle, 0, 0)
	arg0.rtTargetArrow:GetComponent(typeof(Canvas)).sortingOrder = WorldConst.LOFleet + defaultValue(arg1, 0) * 10

	setActive(arg0.rtTargetArrow, true)
end

function var0.HideTargetArrow(arg0)
	arg0.rtTargetArrow:SetParent(arg0.transform, false)
	setActive(arg0.rtTargetArrow, false)
end

function var0.ClearTargetArrow(arg0)
	arg0.wsPool:Return("arrow_tpl", arg0.rtTargetArrow)
end

function var0.ShowScannerMap(arg0, arg1)
	for iter0, iter1 in pairs(arg0.wsMapQuads) do
		if arg1 then
			iter1:UpdateStatic(true, true)
		else
			iter1:UpdateStatic(false)
		end
	end
end

return var0
