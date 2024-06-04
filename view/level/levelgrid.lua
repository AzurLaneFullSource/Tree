local var0 = class("LevelGrid", import("..base.BasePanel"))
local var1 = require("Mgr/Pool/PoolPlural")

var0.MapDefaultPos = Vector3(420, -1000, -1000)

function var0.init(arg0)
	var0.super.init(arg0)

	arg0.levelCam = GameObject.Find("LevelCamera"):GetComponent(typeof(Camera))
	GameObject.Find("LevelCamera/Canvas"):GetComponent(typeof(Canvas)).sortingOrder = ChapterConst.PriorityMin
	arg0.quadTws = {}
	arg0.presentTws = {}
	arg0.markTws = {}
	arg0.tweens = {}
	arg0.markQuads = {}
	arg0.pools = {}
	arg0.edgePools = {}
	arg0.poolParent = GameObject.Find("__Pool__")
	arg0.opBtns = {}
	arg0.itemCells = {}
	arg0.attachmentCells = {}
	arg0.extraAttachmentCells = {}
	arg0.weatherCells = {}
	arg0.onShipStepChange = nil
	arg0.onShipArrived = nil
	arg0.lastSelectedId = -1
	arg0.quadState = -1
	arg0.subTeleportTargetLine = nil
	arg0.missileStrikeTargetLine = nil
	arg0.cellEdges = {}
	arg0.walls = {}
	arg0.material_Add = LoadAny("ui/commonUI_atlas", "add", typeof(Material))
	arg0.loader = AutoLoader.New()
end

function var0.ExtendItem(arg0, arg1, arg2)
	if IsNil(arg0[arg1]) then
		arg0[arg1] = arg2
	end
end

function var0.getFleetPool(arg0, arg1)
	local var0 = "fleet_" .. arg1
	local var1 = arg0.pools[var0]

	if not var1 then
		local var2 = arg0.shipTpl

		if arg1 == FleetType.Submarine then
			var2 = arg0.subTpl
		elseif arg1 == FleetType.Transport then
			var2 = arg0.transportTpl
		end

		var1 = var1.New(var2.gameObject, 2)
		arg0.pools[var0] = var1
	end

	return var1
end

function var0.getChampionPool(arg0, arg1)
	local var0 = "champion_" .. arg1
	local var1 = arg0.pools[var0]

	if not var1 then
		local var2 = arg0.championTpl

		if arg1 == ChapterConst.TemplateOni then
			var2 = arg0.oniTpl
		elseif arg1 == ChapterConst.TemplateEnemy then
			var2 = arg0.enemyTpl
		end

		var1 = var1.New(var2.gameObject, 3)
		arg0.pools[var0] = var1
	end

	return var1
end

function var0.AddEdgePool(arg0, arg1, arg2, arg3, arg4, arg5)
	if arg0.edgePools[arg1] then
		return
	end

	local var0 = GameObject.New(arg1)

	var0:AddComponent(typeof(Image)).enabled = false
	arg0.edgePools[arg1] = var1.New(var0, 32)

	local var1
	local var2

	parallelAsync({
		function(arg0)
			if not arg3 then
				arg0()

				return
			end

			arg0.loader:LoadReference(arg2, arg3, typeof(Sprite), function(arg0)
				var1 = arg0

				arg0()
			end)
		end,
		function(arg0)
			if not arg5 then
				arg0()

				return
			end

			arg0.loader:LoadReference(arg2, arg5, typeof(Material), function(arg0)
				var2 = arg0

				arg0()
			end)
		end
	}, function()
		local function var0(arg0)
			local var0 = go(arg0):GetComponent(typeof(Image))

			var0.enabled = true
			var0.color = type(arg4) == "table" and Color.New(unpack(arg4)) or Color.white
			var0.sprite = arg3 and var1 or nil
			var0.material = arg5 and var2 or nil
		end

		local var1 = arg0.edgePools[arg1]

		if var1.prefab then
			var0(var1.prefab)
		end

		if var1.items then
			for iter0, iter1 in pairs(var1.items) do
				var0(iter1)
			end
		end

		if arg0.cellEdges[arg1] and next(arg0.cellEdges[arg1]) then
			for iter2, iter3 in pairs(arg0.cellEdges[arg1]) do
				var0(iter3)
			end
		end
	end)
end

function var0.GetEdgePool(arg0, arg1)
	assert(arg1, "Missing Key")

	local var0 = arg0.edgePools[arg1]

	assert(var0, "Must Create Pool before Using")

	return var0
end

function var0.initAll(arg0, arg1)
	seriesAsync({
		function(arg0)
			arg0:initPlane()
			arg0:initDrag()
			onNextTick(arg0)
		end,
		function(arg0)
			if arg0.exited then
				return
			end

			arg0:initTargetArrow()
			arg0:InitDestinationMark()
			onNextTick(arg0)
		end,
		function(arg0)
			if arg0.exited then
				return
			end

			for iter0 = 0, ChapterConst.MaxRow - 1 do
				for iter1 = 0, ChapterConst.MaxColumn - 1 do
					arg0:initCell(iter0, iter1)
				end
			end

			arg0:UpdateItemCells()
			arg0:updateQuadCells(ChapterConst.QuadStateFrozen)
			onNextTick(arg0)
		end,
		function(arg0)
			if arg0.exited then
				return
			end

			arg0:AddEdgePool("SubmarineHunting", "ui/commonUI_atlas", "white_dot", {
				1,
				0,
				0
			}, "add")
			arg0:UpdateFloor()
			arg0:updateAttachments()
			arg0:InitWalls()
			arg0:InitIdolsAnim()
			onNextTick(arg0)
		end,
		function(arg0)
			if arg0.exited then
				return
			end

			parallelAsync({
				function(arg0)
					arg0:initFleets(arg0)
				end,
				function(arg0)
					arg0:initChampions(arg0)
				end
			}, arg0)
		end,
		function()
			arg0:OnChangeSubAutoAttack()
			arg0:updateQuadCells(ChapterConst.QuadStateNormal)
			existCall(arg1)
		end
	})
end

function var0.clearAll(arg0)
	for iter0, iter1 in pairs(arg0.tweens) do
		LeanTween.cancel(iter0)
	end

	table.clear(arg0.tweens)
	arg0.loader:Clear()

	if not IsNil(arg0.cellRoot) then
		arg0:clearFleets()
		arg0:clearChampions()
		arg0:clearTargetArrow()
		arg0:ClearDestinationMark()
		arg0:ClearIdolsAnim()

		for iter2, iter3 in pairs(arg0.itemCells) do
			iter3:Clear()
		end

		table.clear(arg0.itemCells)

		for iter4, iter5 in pairs(arg0.attachmentCells) do
			iter5:Clear()
		end

		table.clear(arg0.attachmentCells)

		for iter6, iter7 in pairs(arg0.extraAttachmentCells) do
			iter7:Clear()
		end

		table.clear(arg0.extraAttachmentCells)

		for iter8, iter9 in pairs(arg0.weatherCells) do
			iter9:Clear()
		end

		table.clear(arg0.weatherCells)

		for iter10 = 0, ChapterConst.MaxRow - 1 do
			for iter11 = 0, ChapterConst.MaxColumn - 1 do
				arg0:clearCell(iter10, iter11)
			end
		end

		for iter12, iter13 in pairs(arg0.walls) do
			iter13:Clear()
		end

		table.clear(arg0.walls)
		arg0:clearPlane()
	end

	arg0.material_Add = nil

	for iter14, iter15 in pairs(arg0.edgePools) do
		iter15:Clear()
	end

	arg0.edgePools = nil

	for iter16, iter17 in pairs(arg0.pools) do
		iter17:ClearItems()
	end

	arg0.pools = nil
	GetOrAddComponent(arg0._tf, "EventTriggerListener").enabled = false

	if arg0.dragTrigger then
		ClearEventTrigger(arg0.dragTrigger)

		arg0.dragTrigger = nil
	end

	LeanTween.cancel(arg0._tf)
end

local var2 = 640

function var0.initDrag(arg0)
	local var0, var1, var2 = getSizeRate()
	local var3 = arg0.contextData.chapterVO
	local var4 = var3.theme
	local var5 = var2 * 0.5 / math.tan(math.deg2Rad * var4.fov * 0.5)
	local var6 = math.deg2Rad * var4.angle
	local var7 = Vector3(0, -math.sin(var6), -math.cos(var6))
	local var8 = Vector3(var4.offsetx, var4.offsety, var4.offsetz) + var0.MapDefaultPos
	local var9 = Vector3.Dot(var7, var8)
	local var10 = var0 * math.clamp((var5 - var9) / var5, 0, 1)
	local var11 = arg0.plane:Find("display").anchoredPosition
	local var12 = var2 - var8.x - var11.x
	local var13 = var0.MapDefaultPos.y - var8.y - var11.y
	local var14, var15, var16, var17 = var3:getDragExtend()

	arg0.leftBound = var12 - var15
	arg0.rightBound = var12 + var14
	arg0.topBound = var13 + var17
	arg0.bottomBound = var13 - var16
	arg0._tf.sizeDelta = Vector2(var1 * 2, var2 * 2)
	arg0.dragTrigger = GetOrAddComponent(arg0._tf, "EventTriggerListener")
	arg0.dragTrigger.enabled = true

	arg0.dragTrigger:AddDragFunc(function(arg0, arg1)
		local var0 = arg0._tf.anchoredPosition

		var0.x = math.clamp(var0.x + arg1.delta.x * var10.x, arg0.leftBound, arg0.rightBound)
		var0.y = math.clamp(var0.y + arg1.delta.y * var10.y / math.cos(var6), arg0.bottomBound, arg0.topBound)
		arg0._tf.anchoredPosition = var0
	end)
end

function var0.initPlane(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0.theme

	arg0.levelCam.fieldOfView = var1.fov

	local var2

	PoolMgr.GetInstance():GetPrefab("chapter/plane", "", false, function(arg0)
		var2 = arg0.transform
	end)

	arg0.plane = var2
	var2.name = ChapterConst.PlaneName

	var2:SetParent(arg0._tf, false)

	var2.anchoredPosition3D = Vector3(var1.offsetx, var1.offsety, var1.offsetz) + var0.MapDefaultPos
	arg0.cellRoot = var2:Find("cells")
	arg0.quadRoot = var2:Find("quads")
	arg0.bottomMarkRoot = var2:Find("buttomMarks")
	arg0.topMarkRoot = var2:Find("topMarks")
	arg0.restrictMap = var2:Find("restrictMap")
	arg0.UIFXList = var2:Find("UI_FX_list")

	for iter0 = 1, arg0.UIFXList.childCount do
		local var3 = arg0.UIFXList:GetChild(iter0 - 1)

		setActive(var3, false)
	end

	local var4 = arg0.UIFXList:Find(var0:getConfig("uifx"))

	if var4 then
		setActive(var4, true)
	end

	local var5 = var0:getConfig("chapter_fx")

	if type(var5) == "table" then
		for iter1, iter2 in pairs(var5) do
			if #iter1 <= 0 then
				return
			end

			arg0.loader:GetPrefab("effect/" .. iter1, iter1, function(arg0)
				setParent(arg0, arg0.UIFXList)

				if iter2.offset then
					tf(arg0).localPosition = Vector3(unpack(iter2.offset))
				end

				if iter2.rotation then
					tf(arg0).localRotation = Quaternion.Euler(unpack(iter2.rotation))
				end
			end)
		end
	end

	local var6 = var2:Find("display")
	local var7 = var6:Find("mask/sea")

	GetImageSpriteFromAtlasAsync("chapter/pic/" .. var1.assetSea, var1.assetSea, var7)

	arg0.indexMin, arg0.indexMax = var0.indexMin, var0.indexMax

	local var8 = Vector2(arg0.indexMin.y, ChapterConst.MaxRow * 0.5 - arg0.indexMax.x - 1)
	local var9 = Vector2(arg0.indexMax.y - arg0.indexMin.y + 1, arg0.indexMax.x - arg0.indexMin.x + 1)
	local var10 = var1.cellSize + var1.cellSpace
	local var11 = Vector2.Scale(var8, var10)
	local var12 = Vector2.Scale(var9, var10)

	var6.anchoredPosition = var11 + var12 * 0.5
	var6.sizeDelta = var12
	arg0.restrictMap.anchoredPosition = var11 + var12 * 0.5
	arg0.restrictMap.sizeDelta = var12

	local var13 = Vector2(math.floor(var6.sizeDelta.x / var10.x), math.floor(var6.sizeDelta.y / var10.y))
	local var14 = var6:Find("ABC")
	local var15 = var14:GetChild(0)
	local var16 = var14:GetComponent(typeof(GridLayoutGroup))

	var16.cellSize = Vector2(var1.cellSize.x, var1.cellSize.y)
	var16.spacing = Vector2(var1.cellSpace.x, var1.cellSpace.y)
	var16.padding.left = var1.cellSpace.x

	for iter3 = var14.childCount - 1, var13.x, -1 do
		Destroy(var14:GetChild(iter3))
	end

	for iter4 = var14.childCount, var13.x - 1 do
		Instantiate(var15).transform:SetParent(var14, false)
	end

	for iter5 = 0, var13.x - 1 do
		setText(var14:GetChild(iter5), string.char(string.byte("A") + iter5))
	end

	local var17 = var6:Find("123")
	local var18 = var17:GetChild(0)
	local var19 = var17:GetComponent(typeof(GridLayoutGroup))

	var19.cellSize = Vector2(var1.cellSize.x, var1.cellSize.y)
	var19.spacing = Vector2(var1.cellSpace.x, var1.cellSpace.y)
	var19.padding.top = var1.cellSpace.y

	for iter6 = var17.childCount - 1, var13.y, -1 do
		Destroy(var17:GetChild(iter6))
	end

	for iter7 = var17.childCount, var13.y - 1 do
		Instantiate(var18).transform:SetParent(var17, false)
	end

	for iter8 = 0, var13.y - 1 do
		setText(var17:GetChild(iter8), 1 + iter8)
	end

	local var20 = var6:Find("linev")
	local var21 = var20:GetChild(0)
	local var22 = var20:GetComponent(typeof(GridLayoutGroup))

	var22.cellSize = Vector2(ChapterConst.LineCross, var6.sizeDelta.y)
	var22.spacing = Vector2(var10.x - ChapterConst.LineCross, 0)
	var22.padding.left = math.floor(var22.spacing.x)

	for iter9 = var20.childCount - 1, math.max(var13.x - 1, 0), -1 do
		if iter9 > 0 then
			Destroy(var20:GetChild(iter9))
		end
	end

	for iter10 = var20.childCount, var13.x - 2 do
		Instantiate(var21).transform:SetParent(var20, false)
	end

	local var23 = var6:Find("lineh")
	local var24 = var23:GetChild(0)
	local var25 = var23:GetComponent(typeof(GridLayoutGroup))

	var25.cellSize = Vector2(var6.sizeDelta.x, ChapterConst.LineCross)
	var25.spacing = Vector2(0, var10.y - ChapterConst.LineCross)
	var25.padding.top = math.floor(var25.spacing.y)

	for iter11 = var23.childCount - 1, math.max(var13.y - 1, 0), -1 do
		if iter11 > 0 then
			Destroy(var23:GetChild(iter11))
		end
	end

	for iter12 = var23.childCount, var13.y - 2 do
		Instantiate(var24).transform:SetParent(var23, false)
	end

	local var26 = GetOrAddComponent(var6:Find("mask"), "RawImage")
	local var27 = var6:Find("seaBase/sea")

	if var1.seaBase and var1.seaBase ~= "" then
		setActive(var27, true)
		GetImageSpriteFromAtlasAsync("chapter/pic/" .. var1.seaBase, var1.seaBase, var27)

		var26.enabled = true
		var26.uvRect = UnityEngine.Rect.New(0, 0, 1, -1)
	else
		setActive(var27, false)

		var26.enabled = false
	end
end

function var0.updatePoisonArea(arg0)
	local var0 = arg0:findTF("plane/display/mask")
	local var1 = GetOrAddComponent(var0, "RawImage")

	if not var1.enabled then
		return
	end

	var1.texture = arg0:getPoisonTex()
end

function var0.getPoisonTex(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = arg0:findTF("plane/display")
	local var2 = var1.sizeDelta.x / var1.sizeDelta.y
	local var3 = 256
	local var4 = math.floor(var3 / var2)
	local var5

	if arg0.preChapterId ~= var0.id then
		var5 = UnityEngine.Texture2D.New(var3, var4)
		arg0.maskTexture = var5
		arg0.preChapterId = var0.id
	else
		var5 = arg0.maskTexture
	end

	local var6 = {}
	local var7 = var0:getPoisonArea(var3 / var1.sizeDelta.x)

	if arg0.poisonRectDir == nil then
		var6 = var7
	else
		for iter0, iter1 in pairs(var7) do
			if arg0.poisonRectDir[iter0] == nil then
				var6[iter0] = iter1
			end
		end
	end

	local function var8(arg0)
		for iter0 = arg0.x, arg0.w + arg0.x do
			for iter1 = arg0.y, arg0.h + arg0.y do
				var5:SetPixel(iter0, iter1, Color.New(1, 1, 1, 0))
			end
		end
	end

	for iter2, iter3 in pairs(var6) do
		var8(iter3)
	end

	var5:Apply()

	arg0.poisonRectDir = var7

	return var5
end

function var0.showFleetPoisonDamage(arg0, arg1, arg2)
	local var0 = arg0.contextData.chapterVO.fleets[arg1].id
	local var1 = arg0.cellFleets[var0]

	if var1 then
		var1:showPoisonDamage(arg2)
	end
end

function var0.clearPlane(arg0)
	arg0:killQuadTws()
	arg0:killPresentTws()
	arg0:ClearEdges()
	arg0:hideQuadMark()
	removeAllChildren(arg0.cellRoot)
	removeAllChildren(arg0.quadRoot)
	removeAllChildren(arg0.bottomMarkRoot)
	removeAllChildren(arg0.topMarkRoot)
	removeAllChildren(arg0.restrictMap)

	arg0.cellRoot = nil
	arg0.quadRoot = nil
	arg0.bottomMarkRoot = nil
	arg0.topMarkRoot = nil
	arg0.restrictMap = nil

	local var0 = arg0._tf:Find(ChapterConst.PlaneName)
	local var1 = var0:Find("display/seaBase/sea")

	clearImageSprite(var1)
	pg.PoolMgr.GetInstance():ReturnPrefab("chapter/plane", "", var0.gameObject)
end

function var0.initFleets(arg0, arg1)
	if arg0.cellFleets then
		existCall(arg1)

		return
	end

	local var0 = arg0.contextData.chapterVO

	arg0.cellFleets = {}

	table.ParallelIpairsAsync(var0.fleets, function(arg0, arg1, arg2)
		if arg1:getFleetType() == FleetType.Support then
			return arg2()
		end

		arg0:InitFleetCell(arg1.id, arg2)
	end, arg1)
end

function var0.InitFleetCell(arg0, arg1, arg2)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0:getFleetById(arg1)

	if not var1:isValid() then
		existCall(arg2)

		return
	end

	local var2
	local var3 = arg0:getFleetPool(var1:getFleetType()):Dequeue()

	var3.transform.localEulerAngles = Vector3(-var0.theme.angle, 0, 0)

	setParent(var3, arg0.cellRoot, false)
	setActive(var3, true)

	local var4 = var1:getFleetType()
	local var5

	if var4 == FleetType.Transport then
		var5 = TransportCellView
	elseif var4 == FleetType.Submarine then
		var5 = SubCellView
	else
		var5 = FleetCellView
	end

	local var6 = var5.New(var3)

	var6.fleetType = var4

	if var4 == FleetType.Normal or var4 == FleetType.Submarine then
		var6:SetAction(ChapterConst.ShipIdleAction)
	end

	var6.tf.localPosition = var0.theme:GetLinePosition(var1.line.row, var1.line.column)
	arg0.cellFleets[arg1] = var6

	arg0:RefreshFleetCell(arg1, arg2)
end

function var0.RefreshFleetCells(arg0, arg1)
	if not arg0.cellFleets then
		arg0:initFleets(arg1)

		return
	end

	local var0 = arg0.contextData.chapterVO
	local var1 = {}

	for iter0, iter1 in pairs(arg0.cellFleets) do
		if not var0:getFleetById(iter0) then
			table.insert(var1, iter0)
		end
	end

	for iter2, iter3 in pairs(var1) do
		arg0:ClearFleetCell(iter3)
	end

	table.ParallelIpairsAsync(var0.fleets, function(arg0, arg1, arg2)
		if arg1:getFleetType() == FleetType.Support then
			return arg2()
		end

		if not arg0.cellFleets[arg1.id] then
			arg0:InitFleetCell(arg1.id, arg2)
		else
			arg0:RefreshFleetCell(arg1.id, arg2)
		end
	end, arg1)
end

function var0.RefreshFleetCell(arg0, arg1, arg2)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0:getFleetById(arg1)
	local var2 = arg0.cellFleets[arg1]
	local var3
	local var4

	if var1:isValid() then
		if var1:getFleetType() == FleetType.Transport then
			var3 = var1:getPrefab()
		else
			local var5 = var0:getMapShip(var1)

			if var5 then
				var3 = var5:getPrefab()
				var4 = var5:getAttachmentPrefab()
			end
		end
	end

	if not var3 then
		arg0:ClearFleetCell(arg1)
		existCall(arg2)

		return
	end

	var2.go.name = "cell_fleet_" .. var3

	var2:SetLine(var1.line)

	if var2.fleetType == FleetType.Transport then
		var2:LoadIcon(var3, function()
			var2:GetRotatePivot().transform.localRotation = var1.rotation

			arg0:updateFleet(arg1, arg2)
		end)
	else
		var2:LoadSpine(var3, nil, var4, function()
			var2:GetRotatePivot().transform.localRotation = var1.rotation

			arg0:updateFleet(arg1, arg2)
		end)
	end
end

function var0.clearFleets(arg0)
	if arg0.cellFleets then
		for iter0, iter1 in pairs(arg0.cellFleets) do
			arg0:ClearFleetCell(iter0)
		end

		arg0.cellFleets = nil
	end
end

function var0.ClearFleetCell(arg0, arg1)
	local var0 = arg0.cellFleets[arg1]

	if not var0 then
		return
	end

	var0:Clear()
	LeanTween.cancel(var0.go)
	setActive(var0.go, false)
	setParent(var0.go, arg0.poolParent, false)
	arg0:getFleetPool(var0.fleetType):Enqueue(var0.go, false)

	if arg0.opBtns[arg1] then
		Destroy(arg0.opBtns[arg1].gameObject)

		arg0.opBtns[arg1] = nil
	end

	arg0.cellFleets[arg1] = nil
end

function var0.UpdateFleets(arg0, arg1)
	local var0 = arg0.contextData.chapterVO

	table.ParallelIpairsAsync(var0.fleets, function(arg0, arg1, arg2)
		if arg1:getFleetType() == FleetType.Support then
			return arg2()
		end

		arg0:updateFleet(arg1.id, arg2)
	end, arg1)
end

function var0.updateFleet(arg0, arg1, arg2)
	local var0 = arg0.contextData.chapterVO
	local var1 = arg0.cellFleets[arg1]
	local var2 = var0:getFleetById(arg1)

	if var1 then
		local var3 = var2.line
		local var4 = var2:isValid()

		setActive(var1.go, var4)
		var1:RefreshLinePosition(var0, var3)

		local var5 = var2:getFleetType()

		if var5 == FleetType.Normal then
			local var6 = var0:GetEnemy(var3.row, var3.column)
			local var7 = tobool(var6)
			local var8 = var6 and var6.attachment or nil
			local var9 = var0:existFleet(FleetType.Transport, var3.row, var3.column)

			var1:SetSpineVisible(not var7 and not var9)

			local var10 = table.indexof(var0.fleets, var2) == var0.findex

			setActive(var1.tfArrow, var10)
			setActive(var1.tfOp, false)

			local var11 = arg0.opBtns[arg1]

			if not var11 then
				var11 = tf(Instantiate(var1.tfOp))
				var11.name = "op" .. arg1

				var11:SetParent(arg0._tf, false)

				var11.localEulerAngles = Vector3(-var0.theme.angle, 0, 0)

				local var12 = GetOrAddComponent(var11, typeof(Canvas))

				GetOrAddComponent(go(var11), typeof(GraphicRaycaster))

				var12.overrideSorting = true
				var12.sortingOrder = ChapterConst.PriorityMax
				arg0.opBtns[arg1] = var11

				arg0:UpdateOpBtns()
			end

			var11.position = var1.tfOp.position

			local var13 = var6 and ChapterConst.IsBossCell(var6)
			local var14 = false

			if var7 and var8 == ChapterConst.AttachChampion then
				local var15 = var0:getChampion(var3.row, var3.column):GetLastID()
				local var16 = pg.expedition_data_template[var15]

				if var16 then
					var14 = var16.ai == ChapterConst.ExpeditionAILair
				end
			end

			var13 = var13 or var14

			local var17 = _.any(var0.fleets, function(arg0)
				return arg0.id ~= var2.id and arg0:getFleetType() == FleetType.Normal and arg0:isValid()
			end)
			local var18 = var10 and var4 and var7
			local var19 = var11:Find("retreat")

			setActive(var19:Find("retreat"), var18 and not var13 and var17)
			setActive(var19:Find("escape"), var18 and var13)
			setActive(var19, var19:Find("retreat").gameObject.activeSelf or var19:Find("escape").gameObject.activeSelf)

			if var19.gameObject.activeSelf then
				onButton(arg0, var19, function()
					if arg0.parent:isfrozen() then
						return
					end

					if var13 then
						(function()
							local var0 = {
								{
									1,
									0
								},
								{
									-1,
									0
								},
								{
									0,
									1
								},
								{
									0,
									-1
								}
							}

							for iter0, iter1 in ipairs(var0) do
								if var0:considerAsStayPoint(ChapterConst.SubjectPlayer, var3.row + iter1[1], var3.column + iter1[2]) and not var0:existEnemy(ChapterConst.SubjectPlayer, var3.row + iter1[1], var3.column + iter1[2]) then
									arg0:emit(LevelMediator2.ON_OP, {
										type = ChapterConst.OpMove,
										id = var2.id,
										arg1 = var3.row + iter1[1],
										arg2 = var3.column + iter1[2],
										ordLine = var2.line
									})

									return false
								end
							end

							pg.TipsMgr.GetInstance():ShowTips(i18n("no_way_to_escape"))

							return true
						end)()
					else
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = i18n("levelScene_who_to_retreat", var2.name),
							onYes = function()
								arg0:emit(LevelMediator2.ON_OP, {
									type = ChapterConst.OpRetreat,
									id = var2.id
								})
							end
						})
					end
				end, SFX_UI_WEIGHANCHOR_WITHDRAW)
			end

			local var20 = var11:Find("exchange")

			setActive(var20, false)
			setActive(var1.tfAmmo, not var9)

			local var21, var22 = var0:getFleetAmmo(var2)
			local var23 = var22 .. "/" .. var21

			if var22 == 0 then
				var23 = setColorStr(var23, COLOR_RED)
			end

			setText(var1.tfAmmoText, var23)

			if var7 or var9 then
				local var24 = var0:getChampion(var3.row, var3.column)

				if var7 and var8 == ChapterConst.AttachChampion and var24:getPoolType() == ChapterConst.TemplateChampion then
					var1.tfArrow.anchoredPosition = Vector2(0, 180)
					var1.tfAmmo.anchoredPosition = Vector2(60, 100)
				else
					var1.tfArrow.anchoredPosition = Vector2(0, 100)
					var1.tfAmmo.anchoredPosition = Vector2(22, 56)
				end

				var1.tfAmmo:SetAsLastSibling()
			else
				var1.tfArrow.anchoredPosition = Vector2(0, 175)
				var1.tfAmmo.anchoredPosition = Vector2(-60, 85)
			end

			if var1:GetSpineRole() and var10 and arg0.lastSelectedId ~= var2.id then
				if not var7 and not var9 and arg0.lastSelectedId ~= -1 then
					var1:TweenShining()
				end

				arg0.lastSelectedId = var2.id
			end

			local var25 = var0:existBarrier(var3.row, var3.column)

			var1:SetActiveNoPassIcon(var25)

			local var26 = table.contains(var2:GetStatusStrategy(), ChapterConst.StrategyIntelligenceRecorded)

			var1:UpdateIconRecordedFlag(var26)
		elseif var5 == FleetType.Submarine then
			local var27 = var0:existEnemy(ChapterConst.SubjectPlayer, var3.row, var3.column) or var0:existAlly(var2)
			local var28 = var0.subAutoAttack == 1

			var1:SetActiveModel(not var27 and var28)
			setActive(var1.tfAmmo, not var27)

			local var29, var30 = var0:getFleetAmmo(var2)
			local var31 = var30 .. "/" .. var29

			if var30 == 0 then
				var31 = setColorStr(var31, COLOR_RED)
			end

			setText(var1.tfAmmoText, var31)
		elseif var5 == FleetType.Transport then
			setText(var1.tfHpText, var2:getRestHp() .. "/" .. var2:getTotalHp())

			local var32 = var0:existEnemy(ChapterConst.SubjectPlayer, var3.row, var3.column)

			GetImageSpriteFromAtlasAsync("enemies/" .. var2:getPrefab(), "", var1.tfIcon, true)
			setActive(var1.tfFighting, var32)
		end
	end

	existCall(arg2)
end

function var0.UpdateOpBtns(arg0)
	table.Foreach(arg0.opBtns, function(arg0, arg1)
		setActive(arg1, arg0.quadState == ChapterConst.QuadStateNormal)
	end)
end

function var0.GetCellFleet(arg0, arg1)
	return arg0.cellFleets[arg1]
end

function var0.initTargetArrow(arg0)
	local var0 = arg0.contextData.chapterVO

	arg0.arrowTarget = cloneTplTo(arg0.arrowTpl, arg0._tf)

	local var1 = arg0.arrowTarget

	pg.ViewUtils.SetLayer(tf(var1), Layer.UI)

	GetOrAddComponent(var1, typeof(Canvas)).overrideSorting = true
	arg0.arrowTarget.localEulerAngles = Vector3(-var0.theme.angle, 0, 0)

	setActive(arg0.arrowTarget, false)
end

function var0.updateTargetArrow(arg0, arg1)
	local var0 = arg0.contextData.chapterVO
	local var1 = ChapterCell.Line2Name(arg1.row, arg1.column)
	local var2 = arg0.cellRoot:Find(var1)

	arg0.arrowTarget:SetParent(var2)

	local var3, var4 = (function()
		local var0, var1 = var0:existEnemy(ChapterConst.SubjectPlayer, arg1.row, arg1.column)

		if not var0 then
			return false
		end

		if var1 == ChapterConst.AttachChampion then
			local var2 = var0:getChampion(arg1.row, arg1.column)

			if not var2 then
				return false
			end

			return var2:getPoolType() == "common", var2:getScale() / 100
		elseif ChapterConst.IsEnemyAttach(var1) then
			local var3 = var0:getChapterCell(arg1.row, arg1.column)

			if not var3 or var3.flag ~= ChapterConst.CellFlagActive then
				return false
			end

			local var4 = pg.expedition_data_template[var3.attachmentId]

			return var4.icon_type == 2, var4.scale / 100
		end
	end)()

	if var3 then
		arg0.arrowTarget.localPosition = Vector3(0, 20 + 80 * var4, -80 * var4)
	else
		arg0.arrowTarget.localPosition = Vector3(0, 20, 0)
	end

	local var5 = arg0.arrowTarget:GetComponent(typeof(Canvas))

	if var5 then
		var5.sortingOrder = arg1.row * ChapterConst.PriorityPerRow + ChapterConst.CellPriorityTopMark
	end
end

function var0.clearTargetArrow(arg0)
	if not IsNil(arg0.arrowTarget) then
		Destroy(arg0.arrowTarget)

		arg0.arrowTarget = nil
	end
end

function var0.InitDestinationMark(arg0)
	local var0 = cloneTplTo(arg0.destinationMarkTpl, arg0._tf)

	pg.ViewUtils.SetLayer(tf(var0), Layer.UI)

	GetOrAddComponent(var0, typeof(Canvas)).overrideSorting = true

	setActive(var0, false)

	local var1 = arg0.contextData.chapterVO

	tf(var0).localEulerAngles = Vector3(-var1.theme.angle, 0, 0)
	arg0.destinationMark = tf(var0)
end

function var0.UpdateDestinationMark(arg0, arg1)
	if not arg1 then
		arg0.destinationMark:SetParent(arg0._tf)
		setActive(go(arg0.destinationMark), false)

		return
	end

	setActive(go(arg0.destinationMark), true)

	local var0 = ChapterCell.Line2Name(arg1.row, arg1.column)
	local var1 = arg0.cellRoot:Find(var0)

	arg0.destinationMark:SetParent(var1)

	arg0.destinationMark.localPosition = Vector3(0, 40, -40)

	local var2 = arg0.destinationMark:GetComponent(typeof(Canvas))

	if var2 then
		var2.sortingOrder = arg1.row * ChapterConst.PriorityPerRow + ChapterConst.CellPriorityTopMark
	end
end

function var0.ClearDestinationMark(arg0)
	if not IsNil(arg0.destinationMark) then
		Destroy(arg0.destinationMark)

		arg0.destinationMark = nil
	end
end

function var0.initChampions(arg0, arg1)
	if arg0.cellChampions then
		existCall(arg1)

		return
	end

	arg0.cellChampions = {}

	local var0 = arg0.contextData.chapterVO

	table.ParallelIpairsAsync(var0.champions, function(arg0, arg1, arg2)
		arg0.cellChampions[arg0] = false

		if arg1.flag ~= ChapterConst.CellFlagDisabled then
			arg0:InitChampion(arg0, arg2)
		else
			arg2()
		end
	end, arg1)
end

function var0.InitChampion(arg0, arg1, arg2)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0.champions[arg1]
	local var2 = var1:getPoolType()
	local var3 = arg0:getChampionPool(var2):Dequeue()

	var3.name = "cell_champion_" .. var1:getPrefab()
	var3.transform.localEulerAngles = Vector3(-var0.theme.angle, 0, 0)

	setParent(var3, arg0.cellRoot, false)
	setActive(var3, true)

	local var4

	if var2 == ChapterConst.TemplateChampion then
		var4 = DynamicChampionCellView
	elseif var2 == ChapterConst.TemplateEnemy then
		var4 = DynamicEggCellView
	elseif var2 == ChapterConst.TemplateOni then
		var4 = OniCellView
	end

	local var5 = var4.New(var3)

	arg0.cellChampions[arg1] = var5

	var5:SetLine({
		row = var1.row,
		column = var1.column
	})
	var5:SetPoolType(var2)

	if var5.GetRotatePivot then
		tf(var5:GetRotatePivot()).localRotation = var1.rotation
	end

	if var2 == ChapterConst.TemplateChampion then
		var5:SetAction(ChapterConst.ShipIdleAction)

		if var1.flag == ChapterConst.CellFlagDiving then
			var5:SetAction(ChapterConst.ShipSwimAction)
		end

		var5:LoadSpine(var1:getPrefab(), var1:getScale(), var1:getConfig("effect_prefab"), function()
			arg0:updateChampion(arg1, arg2)
		end)
	elseif var2 == ChapterConst.TemplateEnemy then
		var5:LoadIcon(var1:getPrefab(), var1:getConfigTable(), function()
			arg0:updateChampion(arg1, arg2)
		end)
	elseif var2 == ChapterConst.TemplateOni then
		arg0:updateChampion(arg1, arg2)
	end
end

function var0.updateChampions(arg0, arg1)
	table.ParallelIpairsAsync(arg0.cellChampions, function(arg0, arg1, arg2)
		arg0:updateChampion(arg0, arg2)
	end, arg1)
end

function var0.updateChampion(arg0, arg1, arg2)
	local var0 = arg0.contextData.chapterVO
	local var1 = arg0.cellChampions[arg1]
	local var2 = var0.champions[arg1]

	if var1 and var2 then
		var1:UpdateChampionCell(var0, var2, arg2)
	end
end

function var0.updateOni(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1

	for iter0, iter1 in ipairs(var0.champions) do
		if iter1.attachment == ChapterConst.AttachOni then
			var1 = iter0

			break
		end
	end

	if var1 then
		arg0:updateChampion(var1)
	end
end

function var0.clearChampions(arg0)
	if arg0.cellChampions then
		for iter0, iter1 in ipairs(arg0.cellChampions) do
			if iter1 then
				iter1:Clear()
				LeanTween.cancel(iter1.go)
				setActive(iter1.go, false)
				setParent(iter1.go, arg0.poolParent, false)
				arg0:getChampionPool(iter1:GetPoolType()):Enqueue(iter1.go, false)
			end
		end

		arg0.cellChampions = nil
	end
end

function var0.initCell(arg0, arg1, arg2)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0:getChapterCell(arg1, arg2)

	if var1 then
		local var2 = var0.theme.cellSize
		local var3 = ChapterCell.Line2QuadName(arg1, arg2)
		local var4

		if var1:IsWalkable() then
			PoolMgr.GetInstance():GetPrefab("chapter/cell_quad", "", false, function(arg0)
				var4 = arg0.transform
			end)

			var4.name = var3

			var4:SetParent(arg0.quadRoot, false)

			var4.sizeDelta = var2
			var4.anchoredPosition = var0.theme:GetLinePosition(arg1, arg2)

			var4:SetAsLastSibling()
			onButton(arg0, var4, function()
				if arg0:isfrozen() then
					return
				end

				arg0:ClickGridCell(var1)
			end, SFX_CONFIRM)
		end

		local var5 = ChapterCell.Line2Name(arg1, arg2)
		local var6

		PoolMgr.GetInstance():GetPrefab("chapter/cell", "", false, function(arg0)
			var6 = arg0.transform
		end)

		var6.name = var5

		var6:SetParent(arg0.cellRoot, false)

		var6.sizeDelta = var2
		var6.anchoredPosition = var0.theme:GetLinePosition(arg1, arg2)

		var6:SetAsLastSibling()

		local var7 = var6:Find(ChapterConst.ChildItem)

		var7.localEulerAngles = Vector3(-var0.theme.angle, 0, 0)

		setActive(var7, var1.item)

		local var8 = ItemCell.New(var7, arg1, arg2)

		arg0.itemCells[ChapterCell.Line2Name(arg1, arg2)] = var8
		var8.loader = arg0.loader

		var8:Init(var1)

		var6:Find(ChapterConst.ChildAttachment).localEulerAngles = Vector3(-var0.theme.angle, 0, 0)
	end
end

function var0.clearCell(arg0, arg1, arg2)
	local var0 = ChapterCell.Line2Name(arg1, arg2)
	local var1 = ChapterCell.Line2QuadName(arg1, arg2)
	local var2 = arg0.cellRoot:Find(var0)
	local var3 = arg0.quadRoot:Find(var1)

	if not IsNil(var2) then
		PoolMgr.GetInstance():ReturnPrefab("chapter/cell", "", var2.gameObject)
	end

	if not IsNil(var3) then
		if arg0.quadTws[var1] then
			LeanTween.cancel(arg0.quadTws[var1].uniqueId)

			arg0.quadTws[var1] = nil
		end

		local var4 = var3:Find("grid"):GetComponent(typeof(Image))

		var4.sprite = GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid")
		var4.material = nil

		PoolMgr.GetInstance():ReturnPrefab("chapter/cell_quad", "", var3.gameObject)
	end
end

function var0.UpdateItemCells(arg0)
	local var0 = arg0.contextData.chapterVO

	if not var0 then
		return
	end

	for iter0, iter1 in pairs(arg0.itemCells) do
		local var1 = iter1:GetOriginalInfo()
		local var2 = var1 and var1.item
		local var3 = ItemCell.TransformItemAsset(var0, var2)

		iter1:UpdateAsset(var3)
	end
end

function var0.updateAttachments(arg0)
	for iter0 = 0, ChapterConst.MaxRow - 1 do
		for iter1 = 0, ChapterConst.MaxColumn - 1 do
			arg0:updateAttachment(iter0, iter1)
		end
	end

	arg0:updateExtraAttachments()
	arg0:updateCoastalGunAttachArea()
	arg0:displayEscapeGrid()
end

function var0.UpdateFloor(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0.cells
	local var2 = {}

	for iter0, iter1 in pairs(var1) do
		local var3 = iter1:GetFlagList()

		for iter2, iter3 in pairs(var3) do
			var2[iter3] = var2[iter3] or {}

			table.insert(var2[iter3], iter1)
		end
	end

	if var2[ChapterConst.FlagBanaiAirStrike] and next(var2[ChapterConst.FlagBanaiAirStrike]) then
		arg0:hideQuadMark(ChapterConst.MarkBanaiAirStrike)
		arg0:showQuadMark(var2[ChapterConst.FlagBanaiAirStrike], ChapterConst.MarkBanaiAirStrike, "cell_coastal_gun", Vector2(110, 110), nil, true)
	end

	arg0:updatePoisonArea()

	if var2[ChapterConst.FlagLava] and next(var2[ChapterConst.FlagLava]) then
		arg0:hideQuadMark(ChapterConst.MarkLava)
		arg0:showQuadMark(var2[ChapterConst.FlagLava], ChapterConst.MarkLava, "cell_lava", Vector2(110, 110), nil, true)
	end

	if var2[ChapterConst.FlagNightmare] and next(var2[ChapterConst.FlagNightmare]) then
		arg0:hideQuadMark(ChapterConst.MarkNightMare)
		arg0:hideQuadMark(ChapterConst.MarkHideNight)

		local var4 = var0:getExtraFlags()[1]

		if var4 == ChapterConst.StatusDay then
			arg0:showQuadMark(var2[ChapterConst.FlagNightmare], ChapterConst.MarkHideNight, "cell_hidden_nightmare", Vector2(110, 110), nil, true)
		elseif var4 == ChapterConst.StatusNight then
			arg0:showQuadMark(var2[ChapterConst.FlagNightmare], ChapterConst.MarkNightMare, "cell_nightmare", Vector2(110, 110), nil, true)
		end
	end

	local var5 = {}

	for iter4, iter5 in pairs(var0:GetChapterCellAttachemnts()) do
		if iter5.data == ChapterConst.StoryTrigger then
			local var6 = pg.map_event_template[iter5.attachmentId]

			assert(var6, "map_event_template not exists " .. iter5.attachmentId)

			if var6 and var6.c_type == ChapterConst.EvtType_AdditionalFloor then
				var5[var6.icon] = var5[var6.icon] or {}

				table.insert(var5[var6.icon], iter5)
			end
		end
	end

	for iter6, iter7 in pairs(var5) do
		arg0:hideQuadMark(iter6)
		arg0:showQuadMark(iter7, iter6, iter6, Vector2(110, 110), nil, true)
	end

	local var7 = var0:getConfig("alarm_cell")

	if var7 and #var7 > 0 then
		local var8 = var7[3]

		arg0:ClearEdges(var8)
		arg0:ClearEdges(var8 .. "corner")
		arg0:AddEdgePool(var8, "chapter/celltexture/" .. var8, "")
		arg0:AddEdgePool(var8 .. "_corner", "chapter/celltexture/" .. var8 .. "_corner", "")

		local var9 = _.map(var7[1], function(arg0)
			return {
				row = arg0[1],
				column = arg0[2]
			}
		end)

		arg0:AddOutlines(var9, nil, var7[5], var7[4], var8)

		local var10 = var7[2]

		arg0:hideQuadMark(var10)
		arg0:showQuadMark(var9, var10, var10, Vector2(104, 104), nil, true)
	end

	arg0:HideMissileAimingMarks()

	if var2[ChapterConst.FlagMissleAiming] and next(var2[ChapterConst.FlagMissleAiming]) then
		arg0:ShowMissileAimingMarks(var2[ChapterConst.FlagMissleAiming])
	end

	arg0:UpdateWeatherCells()

	local var11 = var0.fleet

	if var0:isPlayingWithBombEnemy() then
		local var12 = _.map({
			{
				-1,
				0
			},
			{
				1,
				0
			},
			{
				0,
				-1
			},
			{
				0,
				1
			}
		}, function(arg0)
			return {
				row = arg0[1] + var11.line.row,
				column = arg0[2] + var11.line.column
			}
		end)

		arg0:showQuadMark(var12, ChapterConst.MarkBomb, "cell_bomb", Vector2(100, 100), nil, true)
	end
end

function var0.updateExtraAttachments(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0:GetChapterCellAttachemnts()

	for iter0, iter1 in pairs(var1) do
		local var2 = iter1.row
		local var3 = iter1.column
		local var4 = arg0.cellRoot:Find(iter0):Find(ChapterConst.ChildAttachment)
		local var5 = pg.map_event_template[iter1.attachmentId]
		local var6 = iter1.data
		local var7

		if var6 == ChapterConst.StoryTrigger and var5.c_type ~= ChapterConst.EvtType_AdditionalFloor then
			var7 = MapEventStoryTriggerCellView
		end

		local var8 = arg0.extraAttachmentCells[iter0]

		if var8 and var8.class ~= var7 then
			var8:Clear()

			var8 = nil
			arg0.extraAttachmentCells[iter0] = nil
		end

		if var7 then
			if not var8 then
				var8 = var7.New(var4)
				arg0.extraAttachmentCells[iter0] = var8
			end

			var8.info = iter1
			var8.chapter = var0

			var8:SetLine({
				row = var2,
				column = var3
			})
			var8:Update()
		end
	end
end

function var0.updateAttachment(arg0, arg1, arg2)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0:getChapterCell(arg1, arg2)

	if not var1 then
		return
	end

	local var2 = ChapterCell.Line2Name(arg1, arg2)
	local var3 = arg0.cellRoot:Find(var2):Find(ChapterConst.ChildAttachment)
	local var4
	local var5 = {}

	if ChapterConst.IsEnemyAttach(var1.attachment) then
		local var6 = pg.expedition_data_template[var1.attachmentId]

		assert(var6, "expedition_data_template not exist: " .. var1.attachmentId)

		if var1.flag == ChapterConst.CellFlagDisabled then
			if var1.attachment ~= ChapterConst.AttachAmbush then
				var4 = EnemyDeadCellView
				var5.chapter = var0
				var5.config = var6
			end
		elseif var1.flag == ChapterConst.CellFlagActive then
			var4 = var6.icon_type == 1 and StaticEggCellView or StaticChampionCellView
			var5.config = var6
			var5.chapter = var0
			var5.viewParent = arg0
		end
	elseif var1.attachment == ChapterConst.AttachBox then
		var4 = AttachmentBoxCell
	elseif var1.attachment == ChapterConst.AttachSupply then
		var4 = AttachmentSupplyCell
	elseif var1.attachment == ChapterConst.AttachTransport_Target then
		var4 = AttachmentTransportTargetCell
	elseif var1.attachment == ChapterConst.AttachStory then
		if var1.data == ChapterConst.Story then
			var4 = MapEventStoryCellView
		elseif var1.data == ChapterConst.StoryObstacle then
			var4 = MapEventStoryObstacleCellView
			var5.chapter = var0
		end
	elseif var1.attachment == ChapterConst.AttachBomb_Enemy then
		var4 = AttachmentBombEnemyCell
	elseif var1.attachment == ChapterConst.AttachLandbase then
		local var7 = pg.land_based_template[var1.attachmentId]

		assert(var7, "land_based_template not exist: " .. var1.attachmentId)

		if var7.type == ChapterConst.LBCoastalGun then
			var4 = AttachmentLBCoastalGunCell
		elseif var7.type == ChapterConst.LBHarbor then
			var4 = AttachmentLBHarborCell
		elseif var7.type == ChapterConst.LBDock then
			var4 = AttachmentLBDockCell
			var5.chapter = var0
		elseif var7.type == ChapterConst.LBAntiAir then
			var4 = AttachmentLBAntiAirCell
			var5.info = var1
			var5.chapter = var0
			var5.grid = arg0
		elseif var7.type == ChapterConst.LBIdle and var1.attachmentId == ChapterConst.LBIDAirport then
			var4 = AttachmentLBAirport
			var5.extraFlagList = var0:getExtraFlags()
		end
	elseif var1.attachment == ChapterConst.AttachBarrier then
		var4 = AttachmentBarrierCell
	elseif var1.attachment == ChapterConst.AttachNone then
		var5.fadeAnim = (function()
			local var0 = arg0.attachmentCells[var2]

			if not var0 then
				return
			end

			if var0.class ~= StaticEggCellView and var0.class ~= StaticChampionCellView then
				return
			end

			local var1 = var0.info

			if not var1 then
				return
			end

			return pg.expedition_data_template[var1.attachmentId].dungeon_id == 0
		end)()
	end

	if var5.fadeAnim then
		arg0:PlayAttachmentEffect(arg1, arg2, "miwuxiaosan")
	end

	local var8 = arg0.attachmentCells[var2]

	if var8 and var8.class ~= var4 then
		var8:Clear()

		var8 = nil
		arg0.attachmentCells[var2] = nil
	end

	if var4 then
		if not var8 then
			var8 = var4.New(var3)

			var8:SetLine({
				row = arg1,
				column = arg2
			})

			arg0.attachmentCells[var2] = var8
		end

		var8.info = var1

		for iter0, iter1 in pairs(var5) do
			var8[iter0] = iter1
		end

		var8:Update()
	end
end

function var0.InitWalls(arg0)
	local var0 = arg0.contextData.chapterVO

	for iter0 = arg0.indexMin.x, arg0.indexMax.x do
		for iter1 = arg0.indexMin.y, arg0.indexMax.y do
			local var1 = var0:GetRawChapterCell(iter0, iter1)

			if var1 then
				local var2 = ChapterConst.ForbiddenUp

				while var2 > 0 do
					arg0:InitWallDirection(var1, var2)

					var2 = var2 / 2
				end
			end
		end
	end

	for iter2, iter3 in pairs(arg0.walls) do
		if iter3.WallPrefabs then
			iter3:SetAsset(iter3.WallPrefabs[5 - iter3.BanCount])
		end
	end
end

local var3 = {
	[ChapterConst.ForbiddenUp] = {
		-1,
		0
	},
	[ChapterConst.ForbiddenDown] = {
		1,
		0
	},
	[ChapterConst.ForbiddenLeft] = {
		0,
		-1
	},
	[ChapterConst.ForbiddenRight] = {
		0,
		1
	}
}

function var0.InitWallDirection(arg0, arg1, arg2)
	local var0 = arg0.contextData.chapterVO

	if bit.band(arg1.forbiddenDirections, arg2) == 0 then
		return
	end

	if arg1.walkable == false then
		return
	end

	local var1 = var3[arg2]
	local var2 = 2 * arg1.row + var1[1]
	local var3 = 2 * arg1.column + var1[2]
	local var4 = var0:GetRawChapterCell(arg1.row + var1[1], arg1.column + var1[2])
	local var5 = not var4 or var4.walkable == false
	local var6 = var2 .. "_" .. var3
	local var7 = arg0.walls[var6]

	if not var7 then
		local var8 = var0.theme:GetLinePosition(arg1.row, arg1.column)

		var8.x = var8.x + var1[2] * (var0.theme.cellSize.x + var0.theme.cellSpace.x) * 0.5
		var8.y = var8.y - var1[1] * (var0.theme.cellSize.y + var0.theme.cellSpace.y) * 0.5

		local var9 = WallCell.New(var2, var3, bit.band(arg2, ChapterConst.ForbiddenRow) > 0, var8)

		var9.girdParent = arg0
		arg0.walls[var6] = var9
		var7 = var9

		local var10 = var0.wallAssets[arg1.row .. "_" .. arg1.column]

		if var10 then
			var7.WallPrefabs = var10
		end
	end

	var7.BanCount = var7.BanCount + (var5 and 2 or 1)
end

function var0.UpdateWeatherCells(arg0)
	local var0 = arg0.contextData.chapterVO

	for iter0, iter1 in pairs(var0.cells) do
		local var1
		local var2 = iter1:GetWeatherFlagList()

		if #var2 > 0 then
			var1 = MapWeatherCellView
		end

		local var3 = arg0.weatherCells[iter0]

		if var3 and var3.class ~= var1 then
			var3:Clear()

			var3 = nil
			arg0.weatherCells[iter0] = nil
		end

		if var1 then
			if not var3 then
				local var4 = arg0.cellRoot:Find(iter0):Find(ChapterConst.ChildAttachment)

				var3 = var1.New(var4)

				var3:SetLine({
					row = iter1.row,
					column = iter1.column
				})

				arg0.weatherCells[iter0] = var3
			end

			var3.info = iter1

			var3:Update(var2)
		end
	end
end

function var0.updateQuadCells(arg0, arg1)
	arg1 = arg1 or ChapterConst.QuadStateNormal
	arg0.quadState = arg1

	arg0:updateQuadBase()

	if arg1 == ChapterConst.QuadStateNormal then
		arg0:UpdateQuadStateNormal()
	elseif arg1 == ChapterConst.QuadStateBarrierSetting then
		arg0:UpdateQuadStateBarrierSetting()
	elseif arg1 == ChapterConst.QuadStateTeleportSub then
		arg0:UpdateQuadStateTeleportSub()
	elseif arg1 == ChapterConst.QuadStateMissileStrike or arg1 == ChapterConst.QuadStateAirSuport then
		arg0:UpdateQuadStateMissileStrike()
	elseif arg1 == ChapterConst.QuadStateExpel then
		arg0:UpdateQuadStateAirExpel()
	end

	arg0:UpdateOpBtns()
end

function var0.PlayQuadsParallelAnim(arg0, arg1)
	arg0:frozen()
	table.ParallelIpairsAsync(arg1, function(arg0, arg1, arg2)
		local var0 = ChapterCell.Line2QuadName(arg1.row, arg1.column)
		local var1 = arg0.quadRoot:Find(var0)

		arg0:cancelQuadTween(var0, var1)
		setImageAlpha(var1, 0.4)

		local var2 = LeanTween.scale(var1, Vector3.one, 0.2):setFrom(Vector3.zero):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(arg2))

		arg0.presentTws[var0] = {
			uniqueId = var2.uniqueId
		}
	end, function()
		arg0:unfrozen()
	end)
end

function var0.updateQuadBase(arg0)
	local var0 = arg0.contextData.chapterVO

	if var0.fleet == nil then
		return
	end

	arg0:killPresentTws()

	local function var1(arg0)
		if not arg0 or not arg0:IsWalkable() then
			return
		end

		local var0 = arg0.row
		local var1 = arg0.column
		local var2 = ChapterCell.Line2QuadName(var0, var1)
		local var3 = arg0.quadRoot:Find(var2)

		var3.localScale = Vector3.one

		local var4 = var3:Find("grid"):GetComponent(typeof(Image))
		local var5 = var0:getChampion(var0, var1)

		if var5 and var5.flag == ChapterConst.CellFlagActive and var5.trait ~= ChapterConst.TraitLurk and var0:getChampionVisibility(var5) and not var0:existFleet(FleetType.Transport, var0, var1) then
			arg0:startQuadTween(var2, var3)
			setImageSprite(var3, GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_enemy"))
			setImageSprite(var3:Find("grid"), GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_enemy_grid"))

			var4.material = arg0.material_Add

			return
		end

		local var6 = var0:GetRawChapterAttachemnt(var0, var1)

		if var6 then
			local var7 = var0:getQuadCellPic(var6)

			if var7 then
				arg0:startQuadTween(var2, var3)
				setImageSprite(var3, GetSpriteFromAtlas("chapter/pic/cellgrid", var7))

				return
			end
		end

		if var0:getChapterCell(var0, var1) then
			local var8 = var0:getQuadCellPic(arg0)

			if var8 then
				arg0:startQuadTween(var2, var3)

				if var8 == "cell_enemy" then
					setImageSprite(var3:Find("grid"), GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_enemy_grid"))

					var4.material = arg0.material_Add
				else
					setImageSprite(var3:Find("grid"), GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid"))

					var4.material = nil
				end

				setImageSprite(var3, GetSpriteFromAtlas("chapter/pic/cellgrid", var8))

				return
			end
		end

		arg0:cancelQuadTween(var2, var3)
		setImageAlpha(var3, ChapterConst.CellEaseOutAlpha)
		setImageSprite(var3, GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_normal"))
		setImageSprite(var3:Find("grid"), GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid"))

		var4.material = nil
	end

	for iter0, iter1 in pairs(var0.cells) do
		var1(iter1)
	end

	if var0:isPlayingWithBombEnemy() then
		arg0:hideQuadMark(ChapterConst.MarkBomb)
	end
end

function var0.UpdateQuadStateNormal(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0.fleet
	local var2

	if var0:existMoveLimit() and not var0:checkAnyInteractive() then
		var2 = var0:calcWalkableCells(ChapterConst.SubjectPlayer, var1.line.row, var1.line.column, var1:getSpeed())
	end

	if not var2 or #var2 == 0 then
		return
	end

	local var3 = _.min(var2, function(arg0)
		return ManhattonDist(arg0, var1.line)
	end)
	local var4 = ManhattonDist(var3, var1.line)

	_.each(var2, function(arg0)
		local var0 = ChapterCell.Line2QuadName(arg0.row, arg0.column)
		local var1 = arg0.quadRoot:Find(var0)

		arg0:cancelQuadTween(var0, var1)
		setImageSprite(var1, GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_normal"))

		local var2 = var1:Find("grid"):GetComponent(typeof(Image))

		var2.sprite = GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid")
		var2.material = nil

		local var3 = var0:getRound() == ChapterConst.RoundPlayer

		setImageAlpha(var1, var3 and 1 or ChapterConst.CellEaseOutAlpha)

		var1.localScale = Vector3.zero

		local var4 = LeanTween.scale(var1, Vector3.one, 0.2):setFrom(Vector3.zero):setEase(LeanTweenType.easeInOutSine):setDelay((ManhattonDist(arg0, var1.line) - var4) * 0.1)

		arg0.presentTws[var0] = {
			uniqueId = var4.uniqueId
		}
	end)
end

function var0.UpdateQuadStateBarrierSetting(arg0)
	local var0 = 1
	local var1 = arg0.contextData.chapterVO
	local var2 = var1.fleet
	local var3 = var2.line
	local var4 = var1:calcSquareBarrierCells(var3.row, var3.column, var0)

	if not var4 or #var4 == 0 then
		return
	end

	local var5 = _.min(var4, function(arg0)
		return ManhattonDist(arg0, var2.line)
	end)
	local var6 = ManhattonDist(var5, var2.line)

	_.each(var4, function(arg0)
		local var0 = ChapterCell.Line2QuadName(arg0.row, arg0.column)
		local var1 = arg0.quadRoot:Find(var0)

		arg0:cancelQuadTween(var0, var1)
		setImageSprite(var1, GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_barrier_select"))

		local var2 = var1:Find("grid"):GetComponent(typeof(Image))

		var2.sprite = GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid")
		var2.material = nil

		setImageAlpha(var1, 1)

		var1.localScale = Vector3.zero

		local var3 = LeanTween.scale(var1, Vector3.one, 0.2):setFrom(Vector3.zero):setEase(LeanTweenType.easeInOutSine):setDelay((ManhattonDist(arg0, var2.line) - var6) * 0.1)

		arg0.presentTws[var0] = {
			uniqueId = var3.uniqueId
		}
	end)
end

function var0.UpdateQuadStateTeleportSub(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = _.detect(var0.fleets, function(arg0)
		return arg0:getFleetType() == FleetType.Submarine
	end)

	if not var1 then
		return
	end

	local var2 = var0:calcWalkableCells(nil, var1.line.row, var1.line.column, ChapterConst.MaxStep)
	local var3 = _.filter(var2, function(arg0)
		return not var0:getQuadCellPic(var0:getChapterCell(arg0.row, arg0.column))
	end)

	arg0:PlayQuadsParallelAnim(var3)
end

function var0.UpdateQuadStateMissileStrike(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = _.filter(_.values(var0.cells), function(arg0)
		return arg0:IsWalkable() and not var0:getQuadCellPic(arg0)
	end)

	arg0:PlayQuadsParallelAnim(var1)
end

function var0.UpdateQuadStateAirExpel(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = arg0.airSupportTarget

	if not var1 or not var1.source then
		local var2 = _.filter(_.values(var0.cells), function(arg0)
			return arg0:IsWalkable() and not var0:getQuadCellPic(arg0)
		end)

		arg0:PlayQuadsParallelAnim(var2)

		return
	end

	local var3 = var1.source
	local var4 = var0:calcWalkableCells(ChapterConst.SubjectChampion, var3.row, var3.column, 1)

	arg0:PlayQuadsParallelAnim(var4)
end

function var0.ClickGridCell(arg0, arg1)
	if arg0.quadState == ChapterConst.QuadStateBarrierSetting then
		arg0:OnBarrierSetting(arg1)
	elseif arg0.quadState == ChapterConst.QuadStateTeleportSub then
		arg0:OnTeleportConfirm(arg1)
	elseif arg0.quadState == ChapterConst.QuadStateMissileStrike then
		arg0:OnMissileAiming(arg1)
	elseif arg0.quadState == ChapterConst.QuadStateAirSuport then
		arg0:OnAirSupportAiming(arg1)
	elseif arg0.quadState == ChapterConst.QuadStateExpel then
		arg0:OnAirExpelSelect(arg1)
	else
		arg0:emit(LevelUIConst.ON_CLICK_GRID_QUAD, arg1)
	end
end

function var0.OnBarrierSetting(arg0, arg1)
	local var0 = 1
	local var1 = arg0.contextData.chapterVO
	local var2 = var1.fleet.line
	local var3 = var1:calcSquareBarrierCells(var2.row, var2.column, var0)

	if not _.any(var3, function(arg0)
		return arg0.row == arg1.row and arg0.column == arg1.column
	end) then
		return
	end

	;(function(arg0, arg1)
		newChapterVO = arg0.contextData.chapterVO

		if not newChapterVO:existBarrier(arg0, arg1) and newChapterVO.modelCount <= 0 then
			return
		end

		arg0:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpBarrier,
			id = newChapterVO.fleet.id,
			arg1 = arg0,
			arg2 = arg1
		})
	end)(arg1.row, arg1.column)
end

function var0.PrepareSubTeleport(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0:GetSubmarineFleet()
	local var2 = arg0.cellFleets[var1.id]
	local var3 = var1.startPos

	for iter0, iter1 in pairs(var0.fleets) do
		if iter1:getFleetType() == FleetType.Normal then
			arg0:updateFleet(iter1.id)
		end
	end

	local var4 = var0:existEnemy(ChapterConst.SubjectPlayer, var3.row, var3.column) or var0:existFleet(FleetType.Normal, var3.row, var3.column)

	setActive(var2.tfAmmo, not var4)
	var2:SetActiveModel(true)

	if not (var0.subAutoAttack == 1) then
		arg0:PlaySubAnimation(var2, false, function()
			var2:SetActiveModel(not var4)
		end)
	else
		var2:SetActiveModel(not var4)
	end

	var2.tf.localPosition = var0.theme:GetLinePosition(var3.row, var3.column)

	var2:ResetCanvasOrder()
end

function var0.TurnOffSubTeleport(arg0)
	arg0.subTeleportTargetLine = nil

	local var0 = arg0.contextData.chapterVO

	arg0:hideQuadMark(ChapterConst.MarkMovePathArrow)
	arg0:hideQuadMark(ChapterConst.MarkHuntingRange)
	arg0:ClearEdges("SubmarineHunting")
	arg0:UpdateDestinationMark()

	local var1 = var0:GetSubmarineFleet()
	local var2 = arg0.cellFleets[var1.id]
	local var3 = var0.subAutoAttack == 1

	var2:SetActiveModel(var3)

	if not var3 then
		arg0:PlaySubAnimation(var2, true, function()
			arg0:updateFleet(var1.id)
		end)
	else
		arg0:updateFleet(var1.id)
	end

	arg0:ShowHuntingRange()
end

function var0.OnTeleportConfirm(arg0, arg1)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0:getChapterCell(arg1.row, arg1.column)

	if var1 and var1:IsWalkable() and not var0:existBarrier(arg1.row, arg1.column) then
		local var2 = var0:GetSubmarineFleet()

		if var2.startPos.row == arg1.row and var2.startPos.column == arg1.column then
			return
		end

		local var3, var4 = var0:findPath(nil, var2.startPos, arg1)

		if var3 >= PathFinding.PrioObstacle or arg1.row ~= var4[#var4].row or arg1.column ~= var4[#var4].column then
			return
		end

		arg0:ShowTargetHuntingRange(arg1)
		arg0:UpdateDestinationMark(arg1)

		if var3 > 0 then
			arg0:ShowPathInArrows(var4)

			arg0.subTeleportTargetLine = arg1
		end
	end
end

function var0.ShowPathInArrows(arg0, arg1)
	local var0 = arg0.contextData.chapterVO
	local var1 = Clone(arg1)

	table.remove(var1, #var1)

	for iter0 = #var1, 1, -1 do
		local var2 = var1[iter0]

		if var0:existEnemy(ChapterConst.SubjectPlayer, var2.row, var2.column) or var0:getFleet(FleetType.Normal, var2.row, var2.column) then
			table.remove(var1, iter0)
		end
	end

	arg0:hideQuadMark(ChapterConst.MarkMovePathArrow)
	arg0:showQuadMark(var1, ChapterConst.MarkMovePathArrow, "cell_path_arrow", Vector2(100, 100), nil, true)

	local var3 = arg0.markQuads[ChapterConst.MarkMovePathArrow]

	for iter1 = #arg1, 1, -1 do
		local var4 = arg1[iter1]
		local var5 = ChapterCell.Line2MarkName(var4.row, var4.column, ChapterConst.MarkMovePathArrow)
		local var6 = var3 and var3[var5]

		if var6 then
			local var7 = arg1[iter1 + 1]
			local var8 = Vector3.Normalize(Vector3(var7.column - var4.column, var4.row - var7.row, 0))
			local var9 = Vector3.Dot(var8, Vector3.up)
			local var10 = Mathf.Acos(var9) * Mathf.Rad2Deg
			local var11 = Vector3.Cross(Vector3.up, var8).z > 0 and 1 or -1

			var6.localEulerAngles = Vector3(0, 0, var10 * var11)
		end
	end
end

function var0.ShowMissileAimingMarks(arg0, arg1)
	_.each(arg1, function(arg0)
		arg0.loader:GetPrefabBYGroup("ui/miaozhun02", "miaozhun02", function(arg0)
			setParent(arg0, arg0.restrictMap)

			local var0 = arg0.contextData.chapterVO.theme:GetLinePosition(arg0.row, arg0.column)
			local var1 = arg0.restrictMap.anchoredPosition

			tf(arg0).anchoredPosition = Vector2(var0.x - var1.x, var0.y - var1.y)
		end, "MissileAimingMarks")
	end)
end

function var0.HideMissileAimingMarks(arg0)
	arg0.loader:ReturnGroup("MissileAimingMarks")
end

function var0.ShowMissileAimingMark(arg0, arg1)
	arg0.loader:GetPrefab("ui/miaozhun02", "miaozhun02", function(arg0)
		setParent(arg0, arg0.restrictMap)

		local var0 = arg0.contextData.chapterVO.theme:GetLinePosition(arg1.row, arg1.column)
		local var1 = arg0.restrictMap.anchoredPosition

		tf(arg0).anchoredPosition = Vector2(var0.x - var1.x, var0.y - var1.y)
	end, "MissileAimingMark")
end

function var0.HideMissileAimingMark(arg0)
	arg0.loader:ClearRequest("MissileAimingMark")
end

function var0.OnMissileAiming(arg0, arg1)
	arg0:HideMissileAimingMark()
	arg0:ShowMissileAimingMark(arg1)

	arg0.missileStrikeTargetLine = arg1
end

function var0.ShowAirSupportAimingMark(arg0, arg1)
	arg0.loader:GetPrefab("ui/miaozhun03", "miaozhun03", function(arg0)
		setParent(arg0, arg0.restrictMap)

		local var0 = arg0.contextData.chapterVO.theme:GetLinePosition(arg1.row - 0.5, arg1.column)
		local var1 = arg0.restrictMap.anchoredPosition

		tf(arg0).anchoredPosition = Vector2(var0.x - var1.x, var0.y - var1.y)
	end, "AirSupportAimingMark")
end

function var0.HideAirSupportAimingMark(arg0)
	arg0.loader:ClearRequest("AirSupportAimingMark")
end

function var0.OnAirSupportAiming(arg0, arg1)
	arg0:HideAirSupportAimingMark()
	arg0:ShowAirSupportAimingMark(arg1)

	arg0.missileStrikeTargetLine = arg1
end

function var0.ShowAirExpelAimingMark(arg0)
	local var0 = arg0.airSupportTarget

	if not var0 or not var0.source then
		return
	end

	local var1 = var0.source
	local var2 = ChapterCell.Line2Name(var1.row, var1.column)
	local var3 = arg0.cellRoot:Find(var2)

	local function var4(arg0, arg1)
		setParent(arg0, var3)

		GetOrAddComponent(arg0, typeof(Canvas)).overrideSorting = true

		if not arg1 then
			return
		end

		local var0 = arg0.contextData.chapterVO

		tf(arg0).localEulerAngles = Vector3(-var0.theme.angle, 0, 0)
	end

	arg0.loader:GetPrefabBYGroup("leveluiview/tpl_airsupportmark", "tpl_airsupportmark", function(arg0)
		var4(arg0, true)
	end, "AirExpelAimingMark")
	arg0.loader:GetPrefabBYGroup("leveluiview/tpl_airsupportdirection", "tpl_airsupportdirection", function(arg0)
		var4(arg0)

		local var0 = arg0.contextData.chapterVO
		local var1 = {
			{
				-1,
				0
			},
			{
				0,
				1
			},
			{
				1,
				0
			},
			{
				0,
				-1
			}
		}

		for iter0 = 1, 4 do
			local var2 = tf(arg0):Find(iter0)
			local var3 = var0 and var0:considerAsStayPoint(ChapterConst.SubjectChampion, var1.row + var1[iter0][1], var1.column + var1[iter0][2])

			setActive(var2, var3)
		end
	end, "AirExpelAimingMark")
end

function var0.HideAirExpelAimingMark(arg0)
	arg0.loader:ReturnGroup("AirExpelAimingMark")
end

function var0.OnAirExpelSelect(arg0, arg1)
	local var0 = arg0.contextData.chapterVO

	local function var1()
		arg0:HideAirExpelAimingMark()
		arg0:ShowAirExpelAimingMark()
		arg0:updateQuadBase()
		arg0:UpdateQuadStateAirExpel()
	end

	arg0.airSupportTarget = arg0.airSupportTarget or {}

	local var2 = arg0.airSupportTarget
	local var3 = var0:GetEnemy(arg1.row, arg1.column)

	if var3 then
		if ChapterConst.IsBossCell(var3) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_select_boss"))

			return
		end

		if var0:existFleet(FleetType.Normal, arg1.row, arg1.column) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_select_battle"))

			return
		end

		if var2.source and table.equal(var2.source:GetLine(), var3:GetLine()) then
			var3 = nil
		end

		var2.source = var3

		var1()
	elseif not var2.source then
		pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_select_enemy"))
	elseif ManhattonDist(var2.source, arg1) > 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_outrange"))
	elseif not var0:considerAsStayPoint(ChapterConst.SubjectChampion, arg1.row, arg1.column) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_outrange"))
	else
		local var4 = arg0.airSupportTarget.source
		local var5 = arg1

		if not var4 or not var5 then
			return
		end

		local var6 = {
			arg1.row - var4.row,
			arg1.column - var4.column
		}
		local var7 = {
			"up",
			"right",
			"down",
			"left"
		}
		local var8

		if var6[1] ~= 0 then
			var8 = var6[1] + 2
		else
			var8 = 3 - var6[2]
		end

		local var9 = var7[var8]
		local var10 = var0:getChapterSupportFleet()

		local function var11()
			arg0:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var10.id,
				arg1 = ChapterConst.StrategyExpel,
				arg2 = var4.row,
				arg3 = var4.column,
				arg4 = var5.row,
				arg5 = var5.column
			})
		end

		local var12 = var4.attachmentId
		local var13 = pg.expedition_data_template[var12].name

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("levelscene_airexpel_select_confirm_" .. var9, var13),
			onYes = var11
		})
	end
end

function var0.CleanAirSupport(arg0)
	arg0.airSupportTarget = nil
end

function var0.startQuadTween(arg0, arg1, arg2, arg3, arg4)
	if arg0.presentTws[arg1] then
		LeanTween.cancel(arg0.presentTws[arg1].uniqueId)

		arg0.presentTws[arg1] = nil
	end

	if not arg0.quadTws[arg1] then
		arg3 = arg3 or 1
		arg4 = arg4 or ChapterConst.CellEaseOutAlpha

		setImageAlpha(arg2, arg3)

		local var0 = LeanTween.alpha(arg2, arg4, 1):setLoopPingPong()

		arg0.quadTws[arg1] = {
			tw = var0,
			uniqueId = var0.uniqueId
		}
	end
end

function var0.cancelQuadTween(arg0, arg1, arg2)
	if arg0.quadTws[arg1] then
		LeanTween.cancel(arg0.quadTws[arg1].uniqueId)

		arg0.quadTws[arg1] = nil
	end

	setImageAlpha(arg2, ChapterConst.CellEaseOutAlpha)
end

function var0.killQuadTws(arg0)
	for iter0, iter1 in pairs(arg0.quadTws) do
		LeanTween.cancel(iter1.uniqueId)
	end

	arg0.quadTws = {}
end

function var0.killPresentTws(arg0)
	for iter0, iter1 in pairs(arg0.presentTws) do
		LeanTween.cancel(iter1.uniqueId)
	end

	arg0.presentTws = {}
end

function var0.startMarkTween(arg0, arg1, arg2, arg3, arg4)
	if not arg0.markTws[arg1] then
		arg3 = arg3 or 1
		arg4 = arg4 or 0.2

		setImageAlpha(arg2, arg3)

		local var0 = LeanTween.alpha(arg2, arg4, 0.7):setLoopPingPong():setEase(LeanTweenType.easeInOutSine):setDelay(1)

		arg0.markTws[arg1] = {
			tw = var0,
			uniqueId = var0.uniqueId
		}
	end
end

function var0.cancelMarkTween(arg0, arg1, arg2, arg3)
	if arg0.markTws[arg1] then
		LeanTween.cancel(arg0.markTws[arg1].uniqueId)

		arg0.markTws[arg1] = nil
	end

	setImageAlpha(arg2, arg3 or ChapterConst.CellEaseOutAlpha)
end

function var0.moveFleet(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0.fleet
	local var2 = var1.id
	local var3 = arg0.cellFleets[var2]

	var3:SetSpineVisible(true)
	setActive(var3.tfShadow, true)
	setActive(arg0.arrowTarget, true)
	arg0:updateTargetArrow(arg2[#arg2])

	if arg3 then
		arg0:updateAttachment(arg3.row, arg3.column)
	end

	local function var4(arg0)
		var1.step = var1.step + 1

		if arg0.onShipStepChange then
			arg0.onShipStepChange(arg0)
		end
	end

	local function var5(arg0)
		return
	end

	local function var6()
		setActive(arg0.arrowTarget, false)

		local var0 = var0.fleet.line
		local var1 = var0:getChapterCell(var0.row, var0.column)

		if ChapterConst.NeedClearStep(var1) then
			var1.step = 0
		end

		var1.rotation = var3:GetRotatePivot().transform.localRotation

		arg0:updateAttachment(var0.row, var0.column)
		arg0:updateFleet(var2)
		arg0:updateOni()

		local var2 = var0:getChampionIndex(var0.row, var0.column)

		if var2 then
			arg0:updateChampion(var2)
		end

		if arg0.onShipArrived then
			arg0.onShipArrived()
		end

		if arg4 then
			arg4()
		end
	end

	arg0:updateQuadCells(ChapterConst.QuadStateFrozen)
	arg0:moveCellView(var3, arg1, arg2, var4, var5, var6)
end

function var0.moveSub(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0.fleets[arg1]
	local var2 = arg0.cellFleets[var1.id]
	local var3 = arg2[#arg2]

	local function var4(arg0)
		return
	end

	local function var5(arg0)
		return
	end

	local function var6()
		local var0 = var0:existEnemy(ChapterConst.SubjectPlayer, var3.row, var3.column) or var0:existAlly(var1)
		local var1 = var0.subAutoAttack == 1

		var2:SetActiveModel(not var0 and var1)

		var1.rotation = var2:GetRotatePivot().transform.localRotation

		if arg4 then
			arg4()
		end
	end

	arg0:updateQuadCells(ChapterConst.QuadStateFrozen)
	arg0:teleportSubView(var2, var2:GetLine(), var3, var4, var5, var6)
end

function var0.moveChampion(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0.champions[arg1]
	local var2 = arg0.cellChampions[arg1]

	local function var3(arg0)
		return
	end

	local function var4(arg0)
		return
	end

	local function var5()
		if var2.GetRotatePivot then
			var1.rotation = var2:GetRotatePivot().transform.localRotation
		end

		if arg4 then
			arg4()
		end
	end

	if var0:getChampionVisibility(var1) then
		arg0:moveCellView(var2, arg2, arg3, var3, var4, var5)
	else
		local var6 = arg2[#arg2]

		var2:RefreshLinePosition(var0, var6)
		var5()
	end
end

function var0.moveTransport(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0.contextData.chapterVO.fleets[arg1]
	local var1 = arg0.cellFleets[var0.id]

	local function var2(arg0)
		return
	end

	local function var3(arg0)
		return
	end

	local function var4()
		var0.rotation = var1:GetRotatePivot().transform.localRotation

		arg0:updateFleet(var0.id)
		existCall(arg4)
	end

	arg0:updateQuadCells(ChapterConst.QuadStateFrozen)
	arg0:moveCellView(var1, arg2, arg3, var2, var3, var4)
end

function var0.moveCellView(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local var0 = arg0.contextData.chapterVO
	local var1

	local function var2()
		if var1 and coroutine.status(var1) == "suspended" then
			local var0, var1 = coroutine.resume(var1)

			assert(var0, debug.traceback(var1, var1))
		end
	end

	var1 = coroutine.create(function()
		arg0:frozen()

		local var0 = var0:GetQuickPlayFlag() and ChapterConst.ShipStepQuickPlayScale or 1
		local var1 = 0.3 * var0
		local var2 = ChapterConst.ShipStepDuration * ChapterConst.ShipMoveTailLength * var0
		local var3 = 0.1 * var0
		local var4 = 0

		table.insert(arg3, 1, arg1:GetLine())
		_.each(arg3, function(arg0)
			local var0 = var0:getChapterCell(arg0.row, arg0.column)

			if ChapterConst.NeedEasePathCell(var0) then
				local var1 = ChapterCell.Line2QuadName(var0.row, var0.column)
				local var2 = arg0.quadRoot:Find(var1)

				arg0:cancelQuadTween(var1, var2)
				LeanTween.alpha(var2, 1, var1):setDelay(var4)

				var4 = var4 + var3
			end
		end)
		_.each(arg2, function(arg0)
			arg0:moveStep(arg1, arg0, arg3[#arg3], function()
				local var0 = arg1:GetLine()
				local var1 = var0:getChapterCell(var0.row, var0.column)

				if ChapterConst.NeedEasePathCell(var1) then
					local var2 = ChapterCell.Line2QuadName(var1.row, var1.column)
					local var3 = arg0.quadRoot:Find(var2)

					LeanTween.scale(var3, Vector3.zero, var2)
				end

				arg4(arg0)
				arg1:SetLine(arg0)
				arg1:ResetCanvasOrder()
			end, function()
				arg5(arg0)
				var2()
			end)
			coroutine.yield()
		end)
		_.each(arg3, function(arg0)
			local var0 = var0:getChapterCell(arg0.row, arg0.column)

			if ChapterConst.NeedEasePathCell(var0) then
				local var1 = ChapterCell.Line2QuadName(var0.row, var0.column)
				local var2 = arg0.quadRoot:Find(var1)

				LeanTween.cancel(var2.gameObject)
				setImageAlpha(var2, ChapterConst.CellEaseOutAlpha)

				var2.localScale = Vector3.one
			end
		end)

		if arg0.exited then
			return
		end

		if arg1.GetAction then
			arg1:SetAction(ChapterConst.ShipIdleAction)
		end

		arg6()
		arg0:unfrozen()
	end)

	var2()
end

function var0.moveStep(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0:GetQuickPlayFlag() and ChapterConst.ShipStepQuickPlayScale or 1
	local var2

	if arg1.GetRotatePivot then
		var2 = arg1:GetRotatePivot()
	end

	local var3 = arg1:GetLine()

	if arg1.GetAction then
		arg1:SetAction(ChapterConst.ShipMoveAction)
	end

	if not IsNil(var2) and (arg2.column ~= var3.column or arg3.column ~= var3.column) then
		tf(var2).localRotation = Quaternion.identity

		if arg2.column < var3.column or arg2.column == var3.column and arg3.column < var3.column then
			tf(var2).localRotation = Quaternion.Euler(0, 180, 0)
		end
	end

	local var4 = arg1.tf.localPosition
	local var5 = var0.theme:GetLinePosition(arg2.row, arg2.column)
	local var6 = 0

	LeanTween.value(arg1.go, 0, 1, ChapterConst.ShipStepDuration * var1):setOnComplete(System.Action(arg5)):setOnUpdate(System.Action_float(function(arg0)
		arg1.tf.localPosition = Vector3.Lerp(var4, var5, arg0)

		if var6 <= 0.5 and arg0 > 0.5 then
			arg4()
		end

		var6 = arg0
	end))
end

function var0.teleportSubView(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	local var0 = arg0.contextData.chapterVO

	local function var1()
		arg4(arg3)
		arg1:RefreshLinePosition(var0, arg3)
		arg5(arg3)
		arg0:PlaySubAnimation(arg1, false, arg6)
	end

	arg0:PlaySubAnimation(arg1, true, var1)
end

function var0.CellToScreen(arg0, arg1, arg2)
	local var0 = arg0._tf:Find(ChapterConst.PlaneName .. "/cells")

	assert(var0, "plane not exist.")

	local var1 = arg0.contextData.chapterVO.theme
	local var2 = var1:GetLinePosition(arg1, arg2)
	local var3 = var2.y

	var2.y = var3 * math.cos(math.pi / 180 * var1.angle)
	var2.z = var3 * math.sin(math.pi / 180 * var1.angle)

	local var4 = arg0.levelCam.transform:GetChild(0)
	local var5 = var0.transform.lossyScale.x
	local var6 = var0.position + var2 * var5
	local var7 = arg0.levelCam:WorldToViewportPoint(var6)

	return Vector3(var4.rect.width * (var7.x - 0.5), var4.rect.height * (var7.y - 0.5))
end

local var4 = {
	{
		1,
		0
	},
	{
		0,
		-1
	},
	{
		-1,
		0
	},
	{
		0,
		1
	}
}
local var5 = {
	{
		1,
		1
	},
	{
		1,
		-1
	},
	{
		-1,
		-1
	},
	{
		-1,
		1
	}
}

function var0.AddCellEdge(arg0, arg1, arg2, ...)
	local var0 = 0
	local var1 = 1

	for iter0 = 1, 4 do
		if not _.any(arg1, function(arg0)
			return arg0.row == arg2.row + var4[iter0][1] and arg0.column == arg2.column + var4[iter0][2]
		end) then
			var0 = bit.bor(var0, var1)
		end

		var1 = var1 * 2
	end

	if var0 == 0 then
		return
	end

	arg0:CreateEdge(var0, arg2, ...)
end

function var0.AddOutlines(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(arg1) do
		for iter2 = 1, 4 do
			if not underscore.any(arg1, function(arg0)
				return arg0.row == iter1.row + var4[iter2][1] and arg0.column == iter1.column + var4[iter2][2]
			end) then
				local var2 = 2 * iter1.row + var4[iter2][1]
				local var3 = 2 * iter1.column + var4[iter2][2]

				assert(not var0[var2 .. "_" .. var3], "Multiple outline")

				var0[var2 .. "_" .. var3] = {
					row = var2,
					column = var3,
					normal = iter2
				}
			end

			if not underscore.any(arg1, function(arg0)
				return arg0.row == iter1.row + var5[iter2][1] and arg0.column == iter1.column + var5[iter2][2]
			end) and underscore.any(arg1, function(arg0)
				return arg0.row == iter1.row and arg0.column == iter1.column + var5[iter2][2]
			end) and underscore.any(arg1, function(arg0)
				return arg0.row == iter1.row + var5[iter2][1] and arg0.column == iter1.column
			end) then
				var1[iter1.row .. "_" .. iter1.column .. "_" .. iter2] = {
					row = iter1.row,
					column = iter1.column,
					corner = iter2
				}
			end
		end
	end

	arg0:CreateOutlines(var0, arg2, arg3, arg4, arg5)
	arg0:CreateOutlineCorners(var1, arg2, arg3, arg4, arg5 .. "_corner")
end

function var0.isHuntingRangeVisible(arg0)
	return arg0.contextData.huntingRangeVisibility % 2 == 0
end

function var0.toggleHuntingRange(arg0)
	arg0:hideQuadMark(ChapterConst.MarkHuntingRange)
	arg0:ClearEdges("SubmarineHunting")

	if not arg0:isHuntingRangeVisible() then
		arg0:ShowHuntingRange()
	end

	arg0.contextData.huntingRangeVisibility = 1 - arg0.contextData.huntingRangeVisibility

	arg0:updateAttachments()
	arg0:updateChampions()
end

function var0.ShowHuntingRange(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0:GetSubmarineFleet()

	if not var1 then
		return
	end

	local var2 = var1:getHuntingRange()
	local var3 = _.filter(var2, function(arg0)
		local var0 = var0:getChapterCell(arg0.row, arg0.column)

		return var0 and var0:IsWalkable()
	end)

	arg0:RefreshHuntingRange(var3, false)
end

function var0.RefreshHuntingRange(arg0, arg1, arg2)
	arg0:showQuadMark(arg1, ChapterConst.MarkHuntingRange, "cell_hunting_range", Vector2(100, 100), arg0.material_Add, arg2)
	_.each(arg1, function(arg0)
		arg0:AddCellEdge(arg1, arg0, not arg2, nil, nil, "SubmarineHunting")
	end)
end

function var0.ShowStaticHuntingRange(arg0)
	arg0:hideQuadMark(ChapterConst.MarkHuntingRange)
	arg0:ClearEdges("SubmarineHunting")

	local var0 = arg0.contextData.chapterVO
	local var1 = var0:GetSubmarineFleet()

	if not arg0:isHuntingRangeVisible() then
		arg0.contextData.huntingRangeVisibility = arg0.contextData.huntingRangeVisibility + 1
	end

	local var2 = var1:getHuntingRange()
	local var3 = _.filter(var2, function(arg0)
		local var0 = var0:getChapterCell(arg0.row, arg0.column)

		return var0 and var0:IsWalkable()
	end)

	arg0:RefreshHuntingRange(var3, true)
end

function var0.ShowTargetHuntingRange(arg0, arg1)
	arg0:hideQuadMark(ChapterConst.MarkHuntingRange)
	arg0:ClearEdges("SubmarineHunting")

	local var0 = arg0.contextData.chapterVO
	local var1 = var0:GetSubmarineFleet()
	local var2 = var1:getHuntingRange(arg1)
	local var3 = _.filter(var2, function(arg0)
		local var0 = var0:getChapterCell(arg0.row, arg0.column)

		return var0 and var0:IsWalkable()
	end)
	local var4 = var1:getHuntingRange()
	local var5 = _.filter(var4, function(arg0)
		local var0 = var0:getChapterCell(arg0.row, arg0.column)

		return var0 and var0:IsWalkable()
	end)
	local var6 = {}

	for iter0, iter1 in pairs(var5) do
		if not table.containsData(var3, iter1) then
			table.insert(var6, iter1)
		end
	end

	arg0:RefreshHuntingRange(var6, true)
	arg0:RefreshHuntingRange(var3, false)
	arg0:updateAttachments()
	arg0:updateChampions()
end

function var0.OnChangeSubAutoAttack(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0:GetSubmarineFleet()

	if not var1 then
		return
	end

	local var2 = arg0.cellFleets[var1.id]

	if not var2 then
		return
	end

	local var3 = var0.subAutoAttack == 1

	var2:SetActiveModel(not var3)
	arg0:PlaySubAnimation(var2, not var3, function()
		arg0:updateFleet(var1.id)
	end)
end

function var0.displayEscapeGrid(arg0)
	local var0 = arg0.contextData.chapterVO

	if not var0:existOni() then
		return
	end

	local var1 = var0:getOniChapterInfo()

	arg0:hideQuadMark(ChapterConst.MarkEscapeGrid)
	arg0:showQuadMark(_.map(var1.escape_grids, function(arg0)
		return {
			row = arg0[1],
			column = arg0[2]
		}
	end), ChapterConst.MarkEscapeGrid, "cell_escape_grid", Vector2(105, 105))
end

function var0.showQuadMark(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	arg0:ShowAnyQuadMark(arg1, arg2, arg3, arg4, arg5, false, arg6)
end

function var0.ShowTopQuadMark(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	arg0:ShowAnyQuadMark(arg1, arg2, arg3, arg4, arg5, true, arg6)
end

function var0.ShowAnyQuadMark(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	local var0 = arg0.contextData.chapterVO

	for iter0, iter1 in pairs(arg1) do
		local var1 = var0:getChapterCell(iter1.row, iter1.column)

		if var1 and var1:IsWalkable() then
			local var2 = ChapterCell.Line2MarkName(iter1.row, iter1.column, arg2)

			arg0.markQuads[arg2] = arg0.markQuads[arg2] or {}

			local var3 = arg0.markQuads[arg2][var2]

			if not var3 then
				PoolMgr.GetInstance():GetPrefab("chapter/cell_quad_mark", "", false, function(arg0)
					var3 = arg0.transform
					arg0.markQuads[arg2][var2] = var3
				end)
			else
				arg0:cancelMarkTween(var2, var3, 1)
			end

			var3.name = var2

			var3:SetParent(arg6 and arg0.topMarkRoot or arg0.bottomMarkRoot, false)

			var3.sizeDelta = var0.theme.cellSize
			var3.anchoredPosition = var0.theme:GetLinePosition(iter1.row, iter1.column)
			var3.localScale = Vector3.one

			var3:SetAsLastSibling()

			local var4 = var3:GetComponent(typeof(Image))

			var4.sprite = GetSpriteFromAtlas("chapter/pic/cellgrid", arg3)
			var4.material = arg5
			var3.sizeDelta = arg4

			if not arg7 then
				arg0:startMarkTween(var2, var3)
			else
				arg0:cancelMarkTween(var2, var3, 1)
			end
		end
	end
end

function var0.hideQuadMark(arg0, arg1)
	if arg1 and not arg0.markQuads[arg1] then
		return
	end

	for iter0, iter1 in pairs(arg0.markQuads) do
		if not arg1 or iter0 == arg1 then
			for iter2, iter3 in pairs(iter1) do
				arg0:cancelMarkTween(iter2, iter3)

				iter1[iter2]:GetComponent(typeof(Image)).material = nil
				iter1[iter2] = nil

				PoolMgr.GetInstance():ReturnPrefab("chapter/cell_quad_mark", "", iter3.gameObject)
			end

			table.clear(arg0.markQuads[iter0])
		end
	end
end

function var0.CreateEdgeIndex(arg0, arg1, arg2, arg3)
	return ChapterCell.Line2Name(arg0, arg1) .. (arg3 and "_" .. arg3 or "") .. "_" .. arg2
end

function var0.CreateEdge(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	if arg1 <= 0 or arg1 >= 16 then
		return
	end

	local var0 = arg0:GetEdgePool(arg6)
	local var1 = arg0.contextData.chapterVO
	local var2 = var1.theme:GetLinePosition(arg2.row, arg2.column)
	local var3 = var1.theme.cellSize

	assert(arg6, "Missing key, Please PM Programmer")

	local var4 = 1
	local var5 = 0

	while var5 < 4 do
		var5 = var5 + 1

		if bit.band(arg1, var4) > 0 then
			local var6 = arg0.CreateEdgeIndex(arg2.row, arg2.column, var5, arg6)

			arg0.cellEdges[arg6] = arg0.cellEdges[arg6] or {}
			arg0.cellEdges[arg6][var6] = arg0.cellEdges[arg6][var6] or tf(var0:Dequeue())

			local var7 = arg0.cellEdges[arg6][var6]

			var7.name = var6

			var7:SetParent(arg0.bottomMarkRoot, false)

			arg4 = arg4 or 0
			arg5 = arg5 or 3

			local var8 = bit.band(var5, 1) == 1 and var3.x - arg4 * 2 or var3.y - arg4 * 2
			local var9 = arg5

			var7.sizeDelta = Vector2.New(var8, var9)
			var7.pivot = Vector2.New(0.5, 0)

			local var10 = math.pi * 0.5 * -var5
			local var11 = math.cos(var10) * (var3.x * 0.5 - arg4)
			local var12 = math.sin(var10) * (var3.y * 0.5 - arg4)

			var7.anchoredPosition = Vector2.New(var11 + var2.x, var12 + var2.y)
			var7.localRotation = Quaternion.Euler(0, 0, (5 - var5) * 90)

			if arg3 then
				arg0:startMarkTween(var6, var7)
			else
				arg0:cancelMarkTween(var6, var7, 1)
			end
		end

		var4 = var4 * 2
	end
end

function var0.ClearEdge(arg0, arg1)
	for iter0, iter1 in pairs(arg0.cellEdges) do
		for iter2 = 1, 4 do
			local var0 = arg0.CreateEdgeIndex(arg1.row, arg1.column, iter2, iter0)

			if iter1[var0] then
				local var1 = arg0:GetEdgePool(iter0)
				local var2 = tf(iter1[var0])

				arg0:cancelMarkTween(var0, var2)
				var1:Enqueue(var2, false)

				iter1[var0] = nil
			end
		end
	end
end

function var0.ClearEdges(arg0, arg1)
	if not next(arg0.cellEdges) then
		return
	end

	for iter0, iter1 in pairs(arg0.cellEdges) do
		if not arg1 or arg1 == iter0 then
			local var0 = arg0:GetEdgePool(iter0)

			for iter2, iter3 in pairs(iter1) do
				arg0:cancelMarkTween(iter2, iter3)
				var0:Enqueue(go(iter3), false)
			end

			arg0.cellEdges[iter0] = nil
		end
	end
end

function var0.CreateOutlines(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg0.contextData.chapterVO
	local var1 = var0.theme.cellSize + var0.theme.cellSpace

	for iter0, iter1 in pairs(arg1) do
		local var2 = arg0:GetEdgePool(arg5)
		local var3 = var0.theme:GetLinePosition(iter1.row / 2, iter1.column / 2)

		assert(arg5, "Missing key, Please PM Programmer")

		local var4 = arg0.CreateEdgeIndex(iter1.row, iter1.column, 0, arg5)

		arg0.cellEdges[arg5] = arg0.cellEdges[arg5] or {}
		arg0.cellEdges[arg5][var4] = arg0.cellEdges[arg5][var4] or tf(var2:Dequeue())

		local var5 = arg0.cellEdges[arg5][var4]

		var5.name = var4

		var5:SetParent(arg0.bottomMarkRoot, false)

		arg3 = arg3 or 0
		arg4 = arg4 or 3

		local var6 = var4[iter1.normal][1] ~= 0 and var1.x or var1.y
		local var7 = arg4
		local var8 = var6 * 0.5
		local var9 = iter1.normal % 4 + 1
		local var10 = (iter1.normal + 2) % 4 + 1
		local var11 = {
			iter1.row + var4[var9][1],
			iter1.column + var4[var9][2]
		}
		local var12 = arg1[var11[1] + var4[iter1.normal][1] .. "_" .. var11[2] + var4[iter1.normal][2]] or arg1[var11[1] - var4[iter1.normal][1] .. "_" .. var11[2] - var4[iter1.normal][2]]
		local var13 = {
			iter1.row + var4[var10][1],
			iter1.column + var4[var10][2]
		}
		local var14 = arg1[var13[1] + var4[iter1.normal][1] .. "_" .. var13[2] + var4[iter1.normal][2]] or arg1[var13[1] - var4[iter1.normal][1] .. "_" .. var13[2] - var4[iter1.normal][2]]

		if var12 then
			local var15 = iter1.row + var4[iter1.normal][1] == var12.row + var4[var12.normal][1] or iter1.column + var4[iter1.normal][2] == var12.column + var4[var12.normal][2]

			var6 = var15 and var6 + arg3 or var6 - arg3
			var8 = var15 and var8 + arg3 or var8 - arg3
		end

		if var14 then
			var6 = (iter1.row + var4[iter1.normal][1] == var14.row + var4[var14.normal][1] or iter1.column + var4[iter1.normal][2] == var14.column + var4[var14.normal][2]) and var6 + arg3 or var6 - arg3
		end

		var5.sizeDelta = Vector2.New(var6, var7)
		var5.pivot = Vector2.New(var8 / var6, 0)

		local var16 = var4[iter1.normal][2] * -arg3
		local var17 = var4[iter1.normal][1] * arg3

		var5.anchoredPosition = Vector2.New(var16 + var3.x, var17 + var3.y)
		var5.localRotation = Quaternion.Euler(0, 0, (5 - iter1.normal) * 90)

		if arg2 then
			arg0:startMarkTween(var4, var5)
		else
			arg0:cancelMarkTween(var4, var5, 1)
		end
	end
end

function var0.CreateOutlineCorners(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg0.contextData.chapterVO

	for iter0, iter1 in pairs(arg1) do
		local var1 = arg0:GetEdgePool(arg5)
		local var2 = var0.theme:GetLinePosition(iter1.row + var5[iter1.corner][1] * 0.5, iter1.column + var5[iter1.corner][2] * 0.5)

		assert(arg5, "Missing key, Please PM Programmer")

		local var3 = arg0.CreateEdgeIndex(iter1.row, iter1.column, iter1.corner, arg5)

		arg0.cellEdges[arg5] = arg0.cellEdges[arg5] or {}
		arg0.cellEdges[arg5][var3] = arg0.cellEdges[arg5][var3] or tf(var1:Dequeue())

		local var4 = arg0.cellEdges[arg5][var3]

		var4.name = var3

		var4:SetParent(arg0.bottomMarkRoot, false)

		arg3 = arg3 or 0
		arg4 = arg4 or 3

		local var5 = arg4
		local var6 = arg4

		var4.sizeDelta = Vector2.New(var5, var6)
		var4.pivot = Vector2.New(1, 0)

		local var7 = var5[iter1.corner][2] * -arg3
		local var8 = var5[iter1.corner][1] * arg3

		var4.anchoredPosition = Vector2.New(var7 + var2.x, var8 + var2.y)
		var4.localRotation = Quaternion.Euler(0, 0, (5 - iter1.corner) * 90)

		if arg2 then
			arg0:startMarkTween(var3, var4)
		else
			arg0:cancelMarkTween(var3, var4, 1)
		end
	end
end

function var0.updateCoastalGunAttachArea(arg0)
	local var0 = arg0.contextData.chapterVO:getCoastalGunArea()

	arg0:hideQuadMark(ChapterConst.MarkCoastalGun)
	arg0:showQuadMark(var0, ChapterConst.MarkCoastalGun, "cell_coastal_gun", Vector2(110, 110), nil, false)
end

function var0.InitIdolsAnim(arg0)
	local var0 = arg0.contextData.chapterVO
	local var1 = pg.chapter_pop_template[var0.id]

	if not var1 then
		return
	end

	local var2 = var1.sd_location

	for iter0, iter1 in ipairs(var2) do
		arg0.idols = arg0.idols or {}

		local var3 = ChapterCell.Line2Name(iter1[1][1], iter1[1][2])
		local var4 = arg0.cellRoot:Find(var3 .. "/" .. ChapterConst.ChildAttachment)

		assert(var4, "cant find attachment")

		local var5 = AttachmentSpineAnimationCell.New(var4)

		var5:SetLine({
			row = iter1[1][1],
			column = iter1[1][2]
		})
		table.insert(arg0.idols, var5)
		var5:Set(iter1[2])
		var5:SetRoutine(var1.sd_act[iter0])
	end
end

function var0.ClearIdolsAnim(arg0)
	if arg0.idols then
		for iter0, iter1 in ipairs(arg0.idols) do
			iter1:Clear()
		end

		table.clear(arg0.idols)

		arg0.idols = nil
	end
end

function var0.GetEnemyCellView(arg0, arg1)
	local var0 = _.detect(arg0.cellChampions, function(arg0)
		local var0 = arg0:GetLine()

		return var0.row == arg1.row and var0.column == arg1.column
	end)

	if not var0 then
		local var1 = ChapterCell.Line2Name(arg1.row, arg1.column)

		var0 = arg0.attachmentCells[var1]
	end

	return var0
end

function var0.TransformLine2PlanePos(arg0, arg1)
	local var0 = string.char(string.byte("A") + arg1.column - arg0.indexMin.y)
	local var1 = string.char(string.byte("1") + arg1.row - arg0.indexMin.x)

	return var0 .. var1
end

function var0.AlignListContainer(arg0, arg1)
	local var0 = arg0.childCount

	for iter0 = arg1, var0 - 1 do
		local var1 = arg0:GetChild(iter0)

		setActive(var1, false)
	end

	for iter1 = var0, arg1 - 1 do
		cloneTplTo(arg0:GetChild(0), arg0)
	end

	for iter2 = 0, arg1 - 1 do
		local var2 = arg0:GetChild(iter2)

		setActive(var2, true)
	end
end

function var0.frozen(arg0)
	arg0.forzenCount = (arg0.forzenCount or 0) + 1

	arg0.parent:frozen()
end

function var0.unfrozen(arg0)
	if arg0.exited then
		return
	end

	arg0.forzenCount = (arg0.forzenCount or 0) - 1

	arg0.parent:unfrozen()
end

function var0.isfrozen(arg0)
	return arg0.parent.frozenCount > 0
end

function var0.clear(arg0)
	arg0:clearAll()

	if (arg0.forzenCount or 0) > 0 then
		arg0.parent:unfrozen(arg0.forzenCount)
	end
end

return var0
