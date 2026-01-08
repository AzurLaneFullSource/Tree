local var0_0 = class("LevelGrid", import("..base.BasePanel"))
local var1_0 = require("Mgr/Pool/PoolPlural")

var0_0.MapDefaultPos = Vector3(420, -1000, -1000)

function var0_0.init(arg0_1)
	var0_0.super.init(arg0_1)

	arg0_1.levelCam = GameObject.Find("LevelCamera"):GetComponent(typeof(Camera))
	GameObject.Find("LevelCamera/Canvas"):GetComponent(typeof(Canvas)).sortingOrder = ChapterConst.PriorityMin - 1
	arg0_1.quadTws = {}
	arg0_1.presentTws = {}
	arg0_1.markTws = {}
	arg0_1.tweens = {}
	arg0_1.markQuads = {}
	arg0_1.pools = {}
	arg0_1.edgePools = {}
	arg0_1.poolParent = GameObject.Find("__Pool__")
	arg0_1.opBtns = {}
	arg0_1.itemCells = {}
	arg0_1.attachmentCells = {}
	arg0_1.extraAttachmentCells = {}
	arg0_1.weatherCells = {}
	arg0_1.onShipStepChange = nil
	arg0_1.onShipArrived = nil
	arg0_1.lastSelectedId = -1
	arg0_1.quadState = -1
	arg0_1.subTeleportTargetLine = nil
	arg0_1.missileStrikeTargetLine = nil
	arg0_1.cellEdges = {}
	arg0_1.walls = {}
	arg0_1.material_Add = LoadAny("artresource/effect/common/material/add", "", typeof(Material))
	arg0_1.loader = AutoLoader.New()
end

function var0_0.ExtendItem(arg0_2, arg1_2, arg2_2)
	if IsNil(arg0_2[arg1_2]) then
		arg0_2[arg1_2] = arg2_2
	end
end

function var0_0.getFleetPool(arg0_3, arg1_3)
	local var0_3 = "fleet_" .. arg1_3
	local var1_3 = arg0_3.pools[var0_3]

	if not var1_3 then
		local var2_3 = arg0_3.shipTpl

		if arg1_3 == FleetType.Submarine then
			var2_3 = arg0_3.subTpl
		elseif arg1_3 == FleetType.Transport then
			var2_3 = arg0_3.transportTpl
		end

		var1_3 = var1_0.New(var2_3.gameObject, 2)
		arg0_3.pools[var0_3] = var1_3
	end

	return var1_3
end

function var0_0.getChampionPool(arg0_4, arg1_4)
	local var0_4 = "champion_" .. arg1_4
	local var1_4 = arg0_4.pools[var0_4]

	if not var1_4 then
		local var2_4 = arg0_4.championTpl

		if arg1_4 == ChapterConst.TemplateOni then
			var2_4 = arg0_4.oniTpl
		elseif arg1_4 == ChapterConst.TemplateEnemy then
			var2_4 = arg0_4.enemyTpl
		end

		var1_4 = var1_0.New(var2_4.gameObject, 3)
		arg0_4.pools[var0_4] = var1_4
	end

	return var1_4
end

function var0_0.AddEdgePool(arg0_5, arg1_5, arg2_5, arg3_5, arg4_5, arg5_5)
	if arg0_5.edgePools[arg1_5] then
		return
	end

	local var0_5 = GameObject.New(arg1_5)

	var0_5:AddComponent(typeof(Image)).enabled = false
	arg0_5.edgePools[arg1_5] = var1_0.New(var0_5, 32)

	local var1_5

	parallelAsync({
		function(arg0_6)
			if not arg3_5 then
				arg0_6()

				return
			end

			arg0_5.loader:LoadReference(arg2_5, arg3_5, typeof(Sprite), function(arg0_7)
				var1_5 = arg0_7

				arg0_6()
			end)
		end
	}, function()
		local function var0_8(arg0_9)
			local var0_9 = go(arg0_9):GetComponent(typeof(Image))

			var0_9.enabled = true
			var0_9.color = type(arg4_5) == "table" and Color.New(unpack(arg4_5)) or Color.white
			var0_9.sprite = arg3_5 and var1_5 or nil
			var0_9.material = arg5_5 or nil
		end

		local var1_8 = arg0_5.edgePools[arg1_5]

		if var1_8.prefab then
			var0_8(var1_8.prefab)
		end

		if var1_8.items then
			for iter0_8, iter1_8 in pairs(var1_8.items) do
				var0_8(iter1_8)
			end
		end

		if arg0_5.cellEdges[arg1_5] and next(arg0_5.cellEdges[arg1_5]) then
			for iter2_8, iter3_8 in pairs(arg0_5.cellEdges[arg1_5]) do
				var0_8(iter3_8)
			end
		end
	end)
end

function var0_0.GetEdgePool(arg0_10, arg1_10)
	assert(arg1_10, "Missing Key")

	local var0_10 = arg0_10.edgePools[arg1_10]

	assert(var0_10, "Must Create Pool before Using")

	return var0_10
end

function var0_0.initAll(arg0_11, arg1_11)
	seriesAsync({
		function(arg0_12)
			arg0_11:initPlane()
			arg0_11:initDrag()
			onNextTick(arg0_12)
		end,
		function(arg0_13)
			if arg0_11.exited then
				return
			end

			arg0_11:initTargetArrow()
			arg0_11:InitDestinationMark()
			onNextTick(arg0_13)
		end,
		function(arg0_14)
			if arg0_11.exited then
				return
			end

			for iter0_14 = 0, ChapterConst.MaxRow - 1 do
				for iter1_14 = 0, ChapterConst.MaxColumn - 1 do
					arg0_11:initCell(iter0_14, iter1_14)
				end
			end

			arg0_11:UpdateItemCells()
			arg0_11:updateQuadCells(ChapterConst.QuadStateFrozen)
			onNextTick(arg0_14)
		end,
		function(arg0_15)
			if arg0_11.exited then
				return
			end

			arg0_11:AddEdgePool("SubmarineHunting", "ui/commonUI_atlas", "white_dot", {
				1,
				0,
				0
			}, arg0_11.material_Add)
			arg0_11:updateAttachments()
			arg0_11:UpdateFloor()
			arg0_11:UpdateWeatherCells()
			arg0_11:InitWalls()
			arg0_11:InitIdolsAnim()
			onNextTick(arg0_15)
		end,
		function(arg0_16)
			if arg0_11.exited then
				return
			end

			parallelAsync({
				function(arg0_17)
					arg0_11:initFleets(arg0_17)
				end,
				function(arg0_18)
					arg0_11:initChampions(arg0_18)
				end
			}, arg0_16)
		end,
		function()
			arg0_11:OnChangeSubAutoAttack()
			arg0_11:updateQuadCells(ChapterConst.QuadStateNormal)
			existCall(arg1_11)
		end
	})
end

function var0_0.clearAll(arg0_20)
	for iter0_20, iter1_20 in pairs(arg0_20.tweens) do
		LeanTween.cancel(iter0_20)
	end

	table.clear(arg0_20.tweens)
	arg0_20.loader:Clear()

	if not IsNil(arg0_20.cellRoot) then
		arg0_20:clearFleets()
		arg0_20:clearChampions()
		arg0_20:clearTargetArrow()
		arg0_20:ClearDestinationMark()
		arg0_20:ClearIdolsAnim()

		for iter2_20, iter3_20 in pairs(arg0_20.itemCells) do
			iter3_20:Clear()
		end

		table.clear(arg0_20.itemCells)

		for iter4_20, iter5_20 in pairs(arg0_20.attachmentCells) do
			iter5_20:Clear()
		end

		table.clear(arg0_20.attachmentCells)

		for iter6_20, iter7_20 in pairs(arg0_20.extraAttachmentCells) do
			iter7_20:Clear()
		end

		table.clear(arg0_20.extraAttachmentCells)

		for iter8_20, iter9_20 in pairs(arg0_20.weatherCells) do
			iter9_20:Clear()
		end

		table.clear(arg0_20.weatherCells)

		for iter10_20 = 0, ChapterConst.MaxRow - 1 do
			for iter11_20 = 0, ChapterConst.MaxColumn - 1 do
				arg0_20:clearCell(iter10_20, iter11_20)
			end
		end

		for iter12_20, iter13_20 in pairs(arg0_20.walls) do
			iter13_20:Clear()
		end

		table.clear(arg0_20.walls)
		arg0_20:clearPlane()
	end

	arg0_20.material_Add = nil

	for iter14_20, iter15_20 in pairs(arg0_20.edgePools) do
		iter15_20:Clear()
	end

	arg0_20.edgePools = nil

	for iter16_20, iter17_20 in pairs(arg0_20.pools) do
		iter17_20:ClearItems()
	end

	arg0_20.pools = nil
	GetOrAddComponent(arg0_20._tf, "EventTriggerListener").enabled = false

	if arg0_20.dragTrigger then
		ClearEventTrigger(arg0_20.dragTrigger)

		arg0_20.dragTrigger = nil
	end

	LeanTween.cancel(arg0_20._tf)
end

local var2_0 = 640

function var0_0.initDrag(arg0_21)
	local var0_21, var1_21, var2_21 = getSizeRate()
	local var3_21 = arg0_21.contextData.chapterVO
	local var4_21 = var3_21.theme
	local var5_21 = var2_21 * 0.5 / math.tan(math.deg2Rad * var4_21.fov * 0.5)
	local var6_21 = math.deg2Rad * var4_21.angle
	local var7_21 = Vector3(0, -math.sin(var6_21), -math.cos(var6_21))
	local var8_21 = Vector3(var4_21.offsetx, var4_21.offsety, var4_21.offsetz) + var0_0.MapDefaultPos
	local var9_21 = Vector3.Dot(var7_21, var8_21)
	local var10_21 = var0_21 * math.clamp((var5_21 - var9_21) / var5_21, 0, 1)
	local var11_21 = arg0_21.plane:Find("display").anchoredPosition
	local var12_21 = var2_0 - var8_21.x - var11_21.x
	local var13_21 = var0_0.MapDefaultPos.y - var8_21.y - var11_21.y
	local var14_21, var15_21, var16_21, var17_21 = var3_21:getDragExtend()

	arg0_21.leftBound = var12_21 - var15_21
	arg0_21.rightBound = var12_21 + var14_21
	arg0_21.topBound = var13_21 + var17_21
	arg0_21.bottomBound = var13_21 - var16_21
	arg0_21._tf.sizeDelta = Vector2(var1_21 * 2, var2_21 * 2)
	arg0_21.dragTrigger = GetOrAddComponent(arg0_21._tf, "EventTriggerListener")
	arg0_21.dragTrigger.enabled = true

	arg0_21.dragTrigger:AddDragFunc(function(arg0_22, arg1_22)
		local var0_22 = arg0_21._tf.anchoredPosition

		var0_22.x = math.clamp(var0_22.x + arg1_22.delta.x * var10_21.x, arg0_21.leftBound, arg0_21.rightBound)
		var0_22.y = math.clamp(var0_22.y + arg1_22.delta.y * var10_21.y / math.cos(var6_21), arg0_21.bottomBound, arg0_21.topBound)
		arg0_21._tf.anchoredPosition = var0_22
	end)
end

function var0_0.initPlane(arg0_23)
	local var0_23 = arg0_23.contextData.chapterVO
	local var1_23 = var0_23.theme

	arg0_23.levelCam.fieldOfView = var1_23.fov

	local var2_23

	PoolMgr.GetInstance():GetPrefab("chapter/plane", "", false, function(arg0_24)
		var2_23 = arg0_24.transform
	end)

	arg0_23.plane = var2_23
	var2_23.name = ChapterConst.PlaneName

	var2_23:SetParent(arg0_23._tf, false)

	var2_23.anchoredPosition3D = Vector3(var1_23.offsetx, var1_23.offsety, var1_23.offsetz) + var0_0.MapDefaultPos
	arg0_23.cellRoot = var2_23:Find("cells")
	arg0_23.quadRoot = var2_23:Find("quads")
	arg0_23.bottomMarkRoot = var2_23:Find("buttomMarks")
	arg0_23.topMarkRoot = var2_23:Find("topMarks")
	arg0_23.restrictMap = var2_23:Find("restrictMap")
	arg0_23.UIFXList = var2_23:Find("UI_FX_list")

	for iter0_23 = 1, arg0_23.UIFXList.childCount do
		local var3_23 = arg0_23.UIFXList:GetChild(iter0_23 - 1)

		setActive(var3_23, false)
	end

	local var4_23 = arg0_23.UIFXList:Find(var0_23:getConfig("uifx"))

	if var4_23 then
		setActive(var4_23, true)
	end

	local var5_23 = var0_23:getConfig("chapter_fx")

	if type(var5_23) == "table" then
		for iter1_23, iter2_23 in pairs(var5_23) do
			if #iter1_23 <= 0 then
				return
			end

			arg0_23.loader:GetPrefab("effect/" .. iter1_23, iter1_23, function(arg0_25)
				setParent(arg0_25, arg0_23.UIFXList)

				if iter2_23.offset then
					tf(arg0_25).localPosition = Vector3(unpack(iter2_23.offset))
				end

				if iter2_23.rotation then
					tf(arg0_25).localRotation = Quaternion.Euler(unpack(iter2_23.rotation))
				end
			end)
		end
	end

	local var6_23 = var2_23:Find("display")
	local var7_23 = var6_23:Find("mask/sea")

	GetImageSpriteFromAtlasAsync("chapter/pic/" .. var1_23.assetSea, var1_23.assetSea, var7_23)

	arg0_23.indexMin, arg0_23.indexMax = var0_23.indexMin, var0_23.indexMax

	local var8_23 = Vector2(arg0_23.indexMin.y, ChapterConst.MaxRow * 0.5 - arg0_23.indexMax.x - 1)
	local var9_23 = Vector2(arg0_23.indexMax.y - arg0_23.indexMin.y + 1, arg0_23.indexMax.x - arg0_23.indexMin.x + 1)
	local var10_23 = var1_23.cellSize + var1_23.cellSpace
	local var11_23 = Vector2.Scale(var8_23, var10_23)
	local var12_23 = Vector2.Scale(var9_23, var10_23)

	var6_23.anchoredPosition = var11_23 + var12_23 * 0.5
	var6_23.sizeDelta = var12_23
	arg0_23.restrictMap.anchoredPosition = var11_23 + var12_23 * 0.5
	arg0_23.restrictMap.sizeDelta = var12_23

	local var13_23 = Vector2(math.floor(var6_23.sizeDelta.x / var10_23.x), math.floor(var6_23.sizeDelta.y / var10_23.y))
	local var14_23 = var6_23:Find("ABC")
	local var15_23 = var14_23:GetChild(0)
	local var16_23 = var14_23:GetComponent(typeof(GridLayoutGroup))

	var16_23.cellSize = Vector2(var1_23.cellSize.x, var1_23.cellSize.y)
	var16_23.spacing = Vector2(var1_23.cellSpace.x, var1_23.cellSpace.y)
	var16_23.padding.left = var1_23.cellSpace.x

	for iter3_23 = var14_23.childCount - 1, var13_23.x, -1 do
		Destroy(var14_23:GetChild(iter3_23))
	end

	for iter4_23 = var14_23.childCount, var13_23.x - 1 do
		Instantiate(var15_23).transform:SetParent(var14_23, false)
	end

	for iter5_23 = 0, var13_23.x - 1 do
		setText(var14_23:GetChild(iter5_23), string.char(string.byte("A") + iter5_23))
	end

	local var17_23 = var6_23:Find("123")
	local var18_23 = var17_23:GetChild(0)
	local var19_23 = var17_23:GetComponent(typeof(GridLayoutGroup))

	var19_23.cellSize = Vector2(var1_23.cellSize.x, var1_23.cellSize.y)
	var19_23.spacing = Vector2(var1_23.cellSpace.x, var1_23.cellSpace.y)
	var19_23.padding.top = var1_23.cellSpace.y

	for iter6_23 = var17_23.childCount - 1, var13_23.y, -1 do
		Destroy(var17_23:GetChild(iter6_23))
	end

	for iter7_23 = var17_23.childCount, var13_23.y - 1 do
		Instantiate(var18_23).transform:SetParent(var17_23, false)
	end

	for iter8_23 = 0, var13_23.y - 1 do
		setText(var17_23:GetChild(iter8_23), 1 + iter8_23)
	end

	local var20_23 = var6_23:Find("linev")
	local var21_23 = var20_23:GetChild(0)
	local var22_23 = var20_23:GetComponent(typeof(GridLayoutGroup))

	var22_23.cellSize = Vector2(ChapterConst.LineCross, var6_23.sizeDelta.y)
	var22_23.spacing = Vector2(var10_23.x - ChapterConst.LineCross, 0)
	var22_23.padding.left = math.floor(var22_23.spacing.x)

	for iter9_23 = var20_23.childCount - 1, math.max(var13_23.x - 1, 0), -1 do
		if iter9_23 > 0 then
			Destroy(var20_23:GetChild(iter9_23))
		end
	end

	for iter10_23 = var20_23.childCount, var13_23.x - 2 do
		Instantiate(var21_23).transform:SetParent(var20_23, false)
	end

	local var23_23 = var6_23:Find("lineh")
	local var24_23 = var23_23:GetChild(0)
	local var25_23 = var23_23:GetComponent(typeof(GridLayoutGroup))

	var25_23.cellSize = Vector2(var6_23.sizeDelta.x, ChapterConst.LineCross)
	var25_23.spacing = Vector2(0, var10_23.y - ChapterConst.LineCross)
	var25_23.padding.top = math.floor(var25_23.spacing.y)

	for iter11_23 = var23_23.childCount - 1, math.max(var13_23.y - 1, 0), -1 do
		if iter11_23 > 0 then
			Destroy(var23_23:GetChild(iter11_23))
		end
	end

	for iter12_23 = var23_23.childCount, var13_23.y - 2 do
		Instantiate(var24_23).transform:SetParent(var23_23, false)
	end

	local var26_23 = GetOrAddComponent(var6_23:Find("mask"), "RawImage")
	local var27_23 = var6_23:Find("seaBase/sea")

	if var1_23.seaBase and var1_23.seaBase ~= "" then
		setActive(var27_23, true)
		GetImageSpriteFromAtlasAsync("chapter/pic/" .. var1_23.seaBase, var1_23.seaBase, var27_23)

		var26_23.enabled = true
		var26_23.uvRect = UnityEngine.Rect.New(0, 0, 1, -1)
	else
		setActive(var27_23, false)

		var26_23.enabled = false
	end
end

function var0_0.updatePoisonArea(arg0_26)
	local var0_26 = arg0_26._tf:Find("plane/display/mask")
	local var1_26 = GetOrAddComponent(var0_26, "RawImage")

	if not var1_26.enabled then
		return
	end

	var1_26.texture = arg0_26:getPoisonTex()
end

function var0_0.getPoisonTex(arg0_27)
	local var0_27 = arg0_27.contextData.chapterVO
	local var1_27 = arg0_27._tf:Find("plane/display")
	local var2_27 = var1_27.sizeDelta.x / var1_27.sizeDelta.y
	local var3_27 = 256
	local var4_27 = math.floor(var3_27 / var2_27)
	local var5_27

	if arg0_27.preChapterId ~= var0_27.id then
		var5_27 = UnityEngine.Texture2D.New(var3_27, var4_27)
		arg0_27.maskTexture = var5_27
		arg0_27.preChapterId = var0_27.id
	else
		var5_27 = arg0_27.maskTexture
	end

	local var6_27 = {}
	local var7_27 = var0_27:getPoisonArea(var3_27 / var1_27.sizeDelta.x)

	if arg0_27.poisonRectDir == nil then
		var6_27 = var7_27
	else
		for iter0_27, iter1_27 in pairs(var7_27) do
			if arg0_27.poisonRectDir[iter0_27] == nil then
				var6_27[iter0_27] = iter1_27
			end
		end
	end

	local function var8_27(arg0_28)
		for iter0_28 = arg0_28.x, arg0_28.w + arg0_28.x do
			for iter1_28 = arg0_28.y, arg0_28.h + arg0_28.y do
				var5_27:SetPixel(iter0_28, iter1_28, Color.New(1, 1, 1, 0))
			end
		end
	end

	for iter2_27, iter3_27 in pairs(var6_27) do
		var8_27(iter3_27)
	end

	var5_27:Apply()

	arg0_27.poisonRectDir = var7_27

	return var5_27
end

function var0_0.showFleetPoisonDamage(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg0_29.contextData.chapterVO.fleets[arg1_29].id
	local var1_29 = arg0_29.cellFleets[var0_29]

	if var1_29 then
		var1_29:showPoisonDamage(arg2_29)
	end
end

function var0_0.clearPlane(arg0_30)
	arg0_30:killQuadTws()
	arg0_30:killPresentTws()
	arg0_30:ClearEdges()
	arg0_30:hideQuadMark()
	removeAllChildren(arg0_30.cellRoot)
	removeAllChildren(arg0_30.quadRoot)
	removeAllChildren(arg0_30.bottomMarkRoot)
	removeAllChildren(arg0_30.topMarkRoot)
	removeAllChildren(arg0_30.restrictMap)

	arg0_30.cellRoot = nil
	arg0_30.quadRoot = nil
	arg0_30.bottomMarkRoot = nil
	arg0_30.topMarkRoot = nil
	arg0_30.restrictMap = nil

	local var0_30 = arg0_30._tf:Find(ChapterConst.PlaneName)
	local var1_30 = var0_30:Find("display/seaBase/sea")

	clearImageSprite(var1_30)
	pg.PoolMgr.GetInstance():ReturnPrefab("chapter/plane", "", var0_30.gameObject)
end

function var0_0.initFleets(arg0_31, arg1_31)
	if arg0_31.cellFleets then
		existCall(arg1_31)

		return
	end

	local var0_31 = arg0_31.contextData.chapterVO

	arg0_31.cellFleets = {}

	table.ParallelIpairsAsync(var0_31.fleets, function(arg0_32, arg1_32, arg2_32)
		if arg1_32:getFleetType() == FleetType.Support then
			return arg2_32()
		end

		arg0_31:InitFleetCell(arg1_32.id, arg2_32)
	end, arg1_31)
end

function var0_0.InitFleetCell(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg0_33.contextData.chapterVO
	local var1_33 = var0_33:getFleetById(arg1_33)

	if not var1_33:isValid() then
		existCall(arg2_33)

		return
	end

	local var2_33
	local var3_33 = arg0_33:getFleetPool(var1_33:getFleetType()):Dequeue()

	var3_33.transform.localEulerAngles = Vector3(-var0_33.theme.angle, 0, 0)

	setParent(var3_33, arg0_33.cellRoot, false)
	setActive(var3_33, true)

	local var4_33 = var1_33:getFleetType()
	local var5_33

	if var4_33 == FleetType.Transport then
		var5_33 = TransportCellView
	elseif var4_33 == FleetType.Submarine then
		var5_33 = SubCellView
	else
		var5_33 = FleetCellView
	end

	local var6_33 = var5_33.New(var3_33)

	var6_33.fleetType = var4_33

	if var4_33 == FleetType.Normal or var4_33 == FleetType.Submarine then
		var6_33:SetAction(ChapterConst.ShipIdleAction)
	end

	var6_33.tf.localPosition = var0_33.theme:GetLinePosition(var1_33.line.row, var1_33.line.column)
	arg0_33.cellFleets[arg1_33] = var6_33

	arg0_33:RefreshFleetCell(arg1_33, arg2_33)
end

function var0_0.RefreshFleetCells(arg0_34, arg1_34)
	if not arg0_34.cellFleets then
		arg0_34:initFleets(arg1_34)

		return
	end

	local var0_34 = arg0_34.contextData.chapterVO
	local var1_34 = {}

	for iter0_34, iter1_34 in pairs(arg0_34.cellFleets) do
		if not var0_34:getFleetById(iter0_34) then
			table.insert(var1_34, iter0_34)
		end
	end

	for iter2_34, iter3_34 in pairs(var1_34) do
		arg0_34:ClearFleetCell(iter3_34)
	end

	table.ParallelIpairsAsync(var0_34.fleets, function(arg0_35, arg1_35, arg2_35)
		if arg1_35:getFleetType() == FleetType.Support then
			return arg2_35()
		end

		if not arg0_34.cellFleets[arg1_35.id] then
			arg0_34:InitFleetCell(arg1_35.id, arg2_35)
		else
			arg0_34:RefreshFleetCell(arg1_35.id, arg2_35)
		end
	end, arg1_34)
end

function var0_0.RefreshFleetCell(arg0_36, arg1_36, arg2_36)
	local var0_36 = arg0_36.contextData.chapterVO
	local var1_36 = var0_36:getFleetById(arg1_36)
	local var2_36 = arg0_36.cellFleets[arg1_36]
	local var3_36
	local var4_36

	if var1_36:isValid() then
		if var1_36:getFleetType() == FleetType.Transport then
			var3_36 = var1_36:getPrefab()
		else
			local var5_36 = var0_36:getMapShip(var1_36)

			if var5_36 then
				var3_36 = var5_36:getPrefab()
				var4_36 = var5_36:getAttachmentPrefab()
			end
		end
	end

	if not var3_36 then
		arg0_36:ClearFleetCell(arg1_36)
		existCall(arg2_36)

		return
	end

	var2_36.go.name = "cell_fleet_" .. var3_36

	var2_36:SetLine(var1_36.line)

	if var2_36.fleetType == FleetType.Transport then
		var2_36:LoadIcon(var3_36, function()
			var2_36:GetRotatePivot().transform.localRotation = var1_36.rotation

			arg0_36:updateFleet(arg1_36, arg2_36)
		end)
	else
		var2_36:LoadSpine(var3_36, nil, var4_36, function()
			var2_36:GetRotatePivot().transform.localRotation = var1_36.rotation

			arg0_36:updateFleet(arg1_36, arg2_36)
		end)
	end
end

function var0_0.clearFleets(arg0_39)
	if arg0_39.cellFleets then
		for iter0_39, iter1_39 in pairs(arg0_39.cellFleets) do
			arg0_39:ClearFleetCell(iter0_39)
		end

		arg0_39.cellFleets = nil
	end
end

function var0_0.ClearFleetCell(arg0_40, arg1_40)
	local var0_40 = arg0_40.cellFleets[arg1_40]

	if not var0_40 then
		return
	end

	var0_40:Clear()
	LeanTween.cancel(var0_40.go)
	setActive(var0_40.go, false)
	setParent(var0_40.go, arg0_40.poolParent, false)
	arg0_40:getFleetPool(var0_40.fleetType):Enqueue(var0_40.go, false)

	if arg0_40.opBtns[arg1_40] then
		Destroy(arg0_40.opBtns[arg1_40].gameObject)

		arg0_40.opBtns[arg1_40] = nil
	end

	arg0_40.cellFleets[arg1_40] = nil
end

function var0_0.UpdateFleets(arg0_41, arg1_41)
	local var0_41 = arg0_41.contextData.chapterVO

	table.ParallelIpairsAsync(var0_41.fleets, function(arg0_42, arg1_42, arg2_42)
		if arg1_42:getFleetType() == FleetType.Support then
			return arg2_42()
		end

		arg0_41:updateFleet(arg1_42.id, arg2_42)
	end, arg1_41)
end

function var0_0.updateFleet(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg0_43.contextData.chapterVO
	local var1_43 = arg0_43.cellFleets[arg1_43]
	local var2_43 = var0_43:getFleetById(arg1_43)

	if var1_43 then
		local var3_43 = var2_43.line
		local var4_43 = var2_43:isValid()

		setActive(var1_43.go, var4_43)
		var1_43:RefreshLinePosition(var0_43, var3_43)

		local var5_43 = var2_43:getFleetType()

		if var5_43 == FleetType.Normal then
			local var6_43 = var0_43:GetEnemy(var3_43.row, var3_43.column)
			local var7_43 = tobool(var6_43)
			local var8_43 = var6_43 and var6_43.attachment or nil
			local var9_43 = var0_43:existFleet(FleetType.Transport, var3_43.row, var3_43.column)

			var1_43:SetSpineVisible(not var7_43 and not var9_43)

			local var10_43 = table.indexof(var0_43.fleets, var2_43) == var0_43.findex

			setActive(var1_43.tfArrow, var10_43)
			setActive(var1_43.tfOp, false)

			local var11_43 = arg0_43.opBtns[arg1_43]

			if not var11_43 then
				var11_43 = tf(Instantiate(var1_43.tfOp))
				var11_43.name = "op" .. arg1_43

				var11_43:SetParent(arg0_43._tf, false)

				var11_43.localEulerAngles = Vector3(-var0_43.theme.angle, 0, 0)

				local var12_43 = GetOrAddComponent(var11_43, typeof(Canvas))

				GetOrAddComponent(go(var11_43), typeof(GraphicRaycaster))

				var12_43.overrideSorting = true
				var12_43.sortingOrder = ChapterConst.PriorityMax
				arg0_43.opBtns[arg1_43] = var11_43

				arg0_43:UpdateOpBtns()
			end

			var11_43.position = var1_43.tfOp.position

			local var13_43 = var6_43 and ChapterConst.IsBossCell(var6_43)
			local var14_43 = false

			if var7_43 and var8_43 == ChapterConst.AttachChampion then
				local var15_43 = var0_43:getChampion(var3_43.row, var3_43.column):GetLastID()
				local var16_43 = pg.expedition_data_template[var15_43]

				if var16_43 then
					var14_43 = var16_43.ai == ChapterConst.ExpeditionAILair
				end
			end

			var13_43 = var13_43 or var14_43

			local var17_43 = _.any(var0_43.fleets, function(arg0_44)
				return arg0_44.id ~= var2_43.id and arg0_44:getFleetType() == FleetType.Normal and arg0_44:isValid()
			end)
			local var18_43 = var10_43 and var4_43 and var7_43
			local var19_43 = var11_43:Find("retreat")

			setActive(var19_43:Find("retreat"), var18_43 and not var13_43 and var17_43)
			setActive(var19_43:Find("escape"), var18_43 and var13_43)
			setActive(var19_43, var19_43:Find("retreat").gameObject.activeSelf or var19_43:Find("escape").gameObject.activeSelf)

			if var19_43.gameObject.activeSelf then
				onButton(arg0_43, var19_43, function()
					if arg0_43.parent:isfrozen() then
						return
					end

					if var13_43 then
						(function()
							local var0_46 = {
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

							for iter0_46, iter1_46 in ipairs(var0_46) do
								if var0_43:considerAsStayPoint(ChapterConst.SubjectPlayer, var3_43.row + iter1_46[1], var3_43.column + iter1_46[2]) and not var0_43:existEnemy(ChapterConst.SubjectPlayer, var3_43.row + iter1_46[1], var3_43.column + iter1_46[2]) then
									arg0_43:emit(LevelMediator2.ON_OP, {
										type = ChapterConst.OpMove,
										id = var2_43.id,
										arg1 = var3_43.row + iter1_46[1],
										arg2 = var3_43.column + iter1_46[2],
										ordLine = var2_43.line
									})

									return false
								end
							end

							pg.TipsMgr.GetInstance():ShowTips(i18n("no_way_to_escape"))

							return true
						end)()
					else
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = i18n("levelScene_who_to_retreat", var2_43.name),
							onYes = function()
								arg0_43:emit(LevelMediator2.ON_OP, {
									type = ChapterConst.OpRetreat,
									id = var2_43.id
								})
							end
						})
					end
				end, SFX_UI_WEIGHANCHOR_WITHDRAW)
			end

			local var20_43 = var11_43:Find("exchange")

			setActive(var20_43, false)
			setActive(var1_43.tfAmmo, not var9_43)

			local var21_43, var22_43 = var0_43:getFleetAmmo(var2_43)
			local var23_43 = var22_43 .. "/" .. var21_43

			if var22_43 == 0 then
				var23_43 = setColorStr(var23_43, COLOR_RED)
			end

			setText(var1_43.tfAmmoText, var23_43)

			if var7_43 or var9_43 then
				local var24_43 = var0_43:getChampion(var3_43.row, var3_43.column)

				if var7_43 and var8_43 == ChapterConst.AttachChampion and var24_43:getPoolType() == ChapterConst.TemplateChampion then
					var1_43.tfArrow.anchoredPosition = Vector2(0, 180)
					var1_43.tfAmmo.anchoredPosition = Vector2(60, 100)
				else
					var1_43.tfArrow.anchoredPosition = Vector2(0, 100)
					var1_43.tfAmmo.anchoredPosition = Vector2(22, 56)
				end

				var1_43.tfAmmo:SetAsLastSibling()
			else
				var1_43.tfArrow.anchoredPosition = Vector2(0, 175)
				var1_43.tfAmmo.anchoredPosition = Vector2(-60, 85)
			end

			if var1_43:GetSpineRole() and var10_43 and arg0_43.lastSelectedId ~= var2_43.id then
				if not var7_43 and not var9_43 and arg0_43.lastSelectedId ~= -1 then
					var1_43:TweenShining()
				end

				arg0_43.lastSelectedId = var2_43.id
			end

			local var25_43 = var0_43:existBarrier(var3_43.row, var3_43.column)

			var1_43:SetActiveNoPassIcon(var25_43)

			local var26_43 = table.contains(var2_43:GetStatusStrategy(), ChapterConst.StrategyIntelligenceRecorded)

			var1_43:UpdateIconRecordedFlag(var26_43)
		elseif var5_43 == FleetType.Submarine then
			local var27_43 = var0_43:existEnemy(ChapterConst.SubjectPlayer, var3_43.row, var3_43.column) or var0_43:existAlly(var2_43)
			local var28_43 = var0_43.subAutoAttack == 1

			var1_43:SetActiveModel(not var27_43 and var28_43)
			setActive(var1_43.tfAmmo, not var27_43)

			local var29_43, var30_43 = var0_43:getFleetAmmo(var2_43)
			local var31_43 = var30_43 .. "/" .. var29_43

			if var30_43 == 0 then
				var31_43 = setColorStr(var31_43, COLOR_RED)
			end

			setText(var1_43.tfAmmoText, var31_43)
		elseif var5_43 == FleetType.Transport then
			setText(var1_43.tfHpText, var2_43:getRestHp() .. "/" .. var2_43:getTotalHp())

			local var32_43 = var0_43:existEnemy(ChapterConst.SubjectPlayer, var3_43.row, var3_43.column)

			GetImageSpriteFromAtlasAsync("enemies/" .. var2_43:getPrefab(), "", var1_43.tfIcon, true)
			setActive(var1_43.tfFighting, var32_43)
		end
	end

	existCall(arg2_43)
end

function var0_0.UpdateOpBtns(arg0_48)
	table.Foreach(arg0_48.opBtns, function(arg0_49, arg1_49)
		setActive(arg1_49, arg0_48.quadState == ChapterConst.QuadStateNormal)
	end)
end

function var0_0.GetCellFleet(arg0_50, arg1_50)
	return arg0_50.cellFleets[arg1_50]
end

function var0_0.initTargetArrow(arg0_51)
	local var0_51 = arg0_51.contextData.chapterVO

	arg0_51.arrowTarget = cloneTplTo(arg0_51.arrowTpl, arg0_51._tf)

	local var1_51 = arg0_51.arrowTarget

	pg.ViewUtils.SetLayer(tf(var1_51), Layer.UI)

	GetOrAddComponent(var1_51, typeof(Canvas)).overrideSorting = true
	arg0_51.arrowTarget.localEulerAngles = Vector3(-var0_51.theme.angle, 0, 0)

	setActive(arg0_51.arrowTarget, false)
end

function var0_0.updateTargetArrow(arg0_52, arg1_52)
	local var0_52 = arg0_52.contextData.chapterVO
	local var1_52 = ChapterCell.Line2Name(arg1_52.row, arg1_52.column)
	local var2_52 = arg0_52.cellRoot:Find(var1_52)

	arg0_52.arrowTarget:SetParent(var2_52)

	local var3_52, var4_52 = (function()
		local var0_53, var1_53 = var0_52:existEnemy(ChapterConst.SubjectPlayer, arg1_52.row, arg1_52.column)

		if not var0_53 then
			return false
		end

		if var1_53 == ChapterConst.AttachChampion then
			local var2_53 = var0_52:getChampion(arg1_52.row, arg1_52.column)

			if not var2_53 then
				return false
			end

			return var2_53:getPoolType() == "common", var2_53:getScale() / 100
		elseif ChapterConst.IsEnemyAttach(var1_53) then
			local var3_53 = var0_52:getChapterCell(arg1_52.row, arg1_52.column)

			if not var3_53 or var3_53.flag ~= ChapterConst.CellFlagActive then
				return false
			end

			local var4_53 = pg.expedition_data_template[var3_53.attachmentId]

			return var4_53.icon_type == 2, var4_53.scale / 100
		end
	end)()

	if var3_52 then
		arg0_52.arrowTarget.localPosition = Vector3(0, 20 + 80 * var4_52, -80 * var4_52)
	else
		arg0_52.arrowTarget.localPosition = Vector3(0, 20, 0)
	end

	local var5_52 = arg0_52.arrowTarget:GetComponent(typeof(Canvas))

	if var5_52 then
		var5_52.sortingOrder = arg1_52.row * ChapterConst.PriorityPerRow + ChapterConst.CellPriorityTopMark
	end
end

function var0_0.clearTargetArrow(arg0_54)
	if not IsNil(arg0_54.arrowTarget) then
		Destroy(arg0_54.arrowTarget)

		arg0_54.arrowTarget = nil
	end
end

function var0_0.InitDestinationMark(arg0_55)
	local var0_55 = cloneTplTo(arg0_55.destinationMarkTpl, arg0_55._tf)

	pg.ViewUtils.SetLayer(tf(var0_55), Layer.UI)

	GetOrAddComponent(var0_55, typeof(Canvas)).overrideSorting = true

	setActive(var0_55, false)

	local var1_55 = arg0_55.contextData.chapterVO

	tf(var0_55).localEulerAngles = Vector3(-var1_55.theme.angle, 0, 0)
	arg0_55.destinationMark = tf(var0_55)
end

function var0_0.UpdateDestinationMark(arg0_56, arg1_56)
	if not arg1_56 then
		arg0_56.destinationMark:SetParent(arg0_56._tf)
		setActive(go(arg0_56.destinationMark), false)

		return
	end

	setActive(go(arg0_56.destinationMark), true)

	local var0_56 = ChapterCell.Line2Name(arg1_56.row, arg1_56.column)
	local var1_56 = arg0_56.cellRoot:Find(var0_56)

	arg0_56.destinationMark:SetParent(var1_56)

	arg0_56.destinationMark.localPosition = Vector3(0, 40, -40)

	local var2_56 = arg0_56.destinationMark:GetComponent(typeof(Canvas))

	if var2_56 then
		var2_56.sortingOrder = arg1_56.row * ChapterConst.PriorityPerRow + ChapterConst.CellPriorityTopMark
	end
end

function var0_0.ClearDestinationMark(arg0_57)
	if not IsNil(arg0_57.destinationMark) then
		Destroy(arg0_57.destinationMark)

		arg0_57.destinationMark = nil
	end
end

function var0_0.initChampions(arg0_58, arg1_58)
	if arg0_58.cellChampions then
		existCall(arg1_58)

		return
	end

	arg0_58.cellChampions = {}

	local var0_58 = arg0_58.contextData.chapterVO

	table.ParallelIpairsAsync(var0_58.champions, function(arg0_59, arg1_59, arg2_59)
		arg0_58.cellChampions[arg0_59] = false

		if arg1_59.flag ~= ChapterConst.CellFlagDisabled then
			arg0_58:InitChampion(arg0_59, arg2_59)
		else
			arg2_59()
		end
	end, arg1_58)
end

function var0_0.InitChampion(arg0_60, arg1_60, arg2_60)
	local var0_60 = arg0_60.contextData.chapterVO
	local var1_60 = var0_60.champions[arg1_60]
	local var2_60 = var1_60:getPoolType()
	local var3_60 = arg0_60:getChampionPool(var2_60):Dequeue()

	var3_60.name = "cell_champion_" .. var1_60:getPrefab()
	var3_60.transform.localEulerAngles = Vector3(-var0_60.theme.angle, 0, 0)

	setParent(var3_60, arg0_60.cellRoot, false)
	setActive(var3_60, true)

	local var4_60

	if var2_60 == ChapterConst.TemplateChampion then
		var4_60 = DynamicChampionCellView
	elseif var2_60 == ChapterConst.TemplateEnemy then
		var4_60 = DynamicEggCellView
	elseif var2_60 == ChapterConst.TemplateOni then
		var4_60 = OniCellView
	end

	local var5_60 = var4_60.New(var3_60)

	arg0_60.cellChampions[arg1_60] = var5_60

	var5_60:SetLine({
		row = var1_60.row,
		column = var1_60.column
	})
	var5_60:SetPoolType(var2_60)

	if var5_60.GetRotatePivot then
		tf(var5_60:GetRotatePivot()).localRotation = var1_60.rotation
	end

	if var2_60 == ChapterConst.TemplateChampion then
		var5_60:SetAction(ChapterConst.ShipIdleAction)

		if var1_60.flag == ChapterConst.CellFlagDiving then
			var5_60:SetAction(ChapterConst.ShipSwimAction)
		end

		var5_60:LoadSpine(var1_60:getPrefab(), var1_60:getScale(), var1_60:getConfig("effect_prefab"), function()
			arg0_60:updateChampion(arg1_60, arg2_60)
		end)
	elseif var2_60 == ChapterConst.TemplateEnemy then
		var5_60:LoadIcon(var1_60:getPrefab(), var1_60:getConfigTable(), function()
			arg0_60:updateChampion(arg1_60, arg2_60)
		end)
	elseif var2_60 == ChapterConst.TemplateOni then
		arg0_60:updateChampion(arg1_60, arg2_60)
	end
end

function var0_0.updateChampions(arg0_63, arg1_63)
	table.ParallelIpairsAsync(arg0_63.cellChampions, function(arg0_64, arg1_64, arg2_64)
		arg0_63:updateChampion(arg0_64, arg2_64)
	end, arg1_63)
end

function var0_0.updateChampion(arg0_65, arg1_65, arg2_65)
	local var0_65 = arg0_65.contextData.chapterVO
	local var1_65 = arg0_65.cellChampions[arg1_65]
	local var2_65 = var0_65.champions[arg1_65]

	if var1_65 and var2_65 then
		var1_65:UpdateChampionCell(var0_65, var2_65, arg2_65)
	end
end

function var0_0.updateOni(arg0_66)
	local var0_66 = arg0_66.contextData.chapterVO
	local var1_66

	for iter0_66, iter1_66 in ipairs(var0_66.champions) do
		if iter1_66.attachment == ChapterConst.AttachOni then
			var1_66 = iter0_66

			break
		end
	end

	if var1_66 then
		arg0_66:updateChampion(var1_66)
	end
end

function var0_0.clearChampions(arg0_67)
	if arg0_67.cellChampions then
		for iter0_67, iter1_67 in ipairs(arg0_67.cellChampions) do
			if iter1_67 then
				iter1_67:Clear()
				LeanTween.cancel(iter1_67.go)
				setActive(iter1_67.go, false)
				setParent(iter1_67.go, arg0_67.poolParent, false)
				arg0_67:getChampionPool(iter1_67:GetPoolType()):Enqueue(iter1_67.go, false)
			end
		end

		arg0_67.cellChampions = nil
	end
end

function var0_0.initCell(arg0_68, arg1_68, arg2_68)
	local var0_68 = arg0_68.contextData.chapterVO
	local var1_68 = var0_68:getChapterCell(arg1_68, arg2_68)

	if var1_68 then
		local var2_68 = var0_68.theme.cellSize
		local var3_68 = ChapterCell.Line2QuadName(arg1_68, arg2_68)
		local var4_68

		if var1_68:IsWalkable() then
			PoolMgr.GetInstance():GetPrefab("chapter/cell_quad", "", false, function(arg0_69)
				var4_68 = arg0_69.transform
			end)

			var4_68.name = var3_68

			var4_68:SetParent(arg0_68.quadRoot, false)

			var4_68.sizeDelta = var2_68
			var4_68.anchoredPosition = var0_68.theme:GetLinePosition(arg1_68, arg2_68)

			var4_68:SetAsLastSibling()
			onButton(arg0_68, var4_68, function()
				if arg0_68:isfrozen() then
					return
				end

				arg0_68:ClickGridCell(var1_68)
			end, SFX_CONFIRM)
		end

		local var5_68 = ChapterCell.Line2Name(arg1_68, arg2_68)
		local var6_68

		PoolMgr.GetInstance():GetPrefab("chapter/cell", "", false, function(arg0_71)
			var6_68 = arg0_71.transform
		end)

		var6_68.name = var5_68

		var6_68:SetParent(arg0_68.cellRoot, false)

		var6_68.sizeDelta = var2_68
		var6_68.anchoredPosition = var0_68.theme:GetLinePosition(arg1_68, arg2_68)

		var6_68:SetAsLastSibling()

		local var7_68 = var6_68:Find(ChapterConst.ChildItem)

		var7_68.localEulerAngles = Vector3(-var0_68.theme.angle, 0, 0)

		setActive(var7_68, var1_68.item)

		local var8_68 = ItemCell.New(var7_68, arg1_68, arg2_68)

		arg0_68.itemCells[ChapterCell.Line2Name(arg1_68, arg2_68)] = var8_68
		var8_68.loader = arg0_68.loader

		var8_68:Init(var1_68)

		var6_68:Find(ChapterConst.ChildAttachment).localEulerAngles = Vector3(-var0_68.theme.angle, 0, 0)
	end
end

function var0_0.clearCell(arg0_72, arg1_72, arg2_72)
	local var0_72 = ChapterCell.Line2Name(arg1_72, arg2_72)
	local var1_72 = ChapterCell.Line2QuadName(arg1_72, arg2_72)
	local var2_72 = arg0_72.cellRoot:Find(var0_72)
	local var3_72 = arg0_72.quadRoot:Find(var1_72)

	if not IsNil(var2_72) then
		PoolMgr.GetInstance():ReturnPrefab("chapter/cell", "", var2_72.gameObject)
	end

	if not IsNil(var3_72) then
		if arg0_72.quadTws[var1_72] then
			LeanTween.cancel(arg0_72.quadTws[var1_72].uniqueId)

			arg0_72.quadTws[var1_72] = nil
		end

		local var4_72 = var3_72:Find("grid"):GetComponent(typeof(Image))

		var4_72.sprite = GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid")
		var4_72.material = nil

		PoolMgr.GetInstance():ReturnPrefab("chapter/cell_quad", "", var3_72.gameObject)
	end
end

function var0_0.UpdateItemCells(arg0_73)
	local var0_73 = arg0_73.contextData.chapterVO

	if not var0_73 then
		return
	end

	for iter0_73, iter1_73 in pairs(arg0_73.itemCells) do
		local var1_73 = iter1_73:GetOriginalInfo()
		local var2_73 = var1_73 and var1_73.item
		local var3_73 = ItemCell.TransformItemAsset(var0_73, var2_73)

		iter1_73:UpdateAsset(var3_73)
	end
end

function var0_0.updateAttachments(arg0_74)
	for iter0_74 = 0, ChapterConst.MaxRow - 1 do
		for iter1_74 = 0, ChapterConst.MaxColumn - 1 do
			arg0_74:updateAttachment(iter0_74, iter1_74)
		end
	end

	arg0_74:updateExtraAttachments()
	arg0_74:updateCoastalGunAttachArea()
	arg0_74:displayEscapeGrid()
end

function var0_0.UpdateFloor(arg0_75)
	local var0_75 = arg0_75.contextData.chapterVO
	local var1_75 = var0_75.cells
	local var2_75 = {}

	for iter0_75, iter1_75 in pairs(var1_75) do
		local var3_75 = iter1_75:GetFlagList()

		for iter2_75, iter3_75 in pairs(var3_75) do
			var2_75[iter3_75] = var2_75[iter3_75] or {}

			table.insert(var2_75[iter3_75], iter1_75)
		end
	end

	if var2_75[ChapterConst.FlagBanaiAirStrike] and next(var2_75[ChapterConst.FlagBanaiAirStrike]) then
		arg0_75:hideQuadMark(ChapterConst.MarkBanaiAirStrike)
		arg0_75:showQuadMark(var2_75[ChapterConst.FlagBanaiAirStrike], ChapterConst.MarkBanaiAirStrike, "cell_coastal_gun", Vector2(110, 110), nil, true)
	end

	arg0_75:updatePoisonArea()

	if var2_75[ChapterConst.FlagLava] and next(var2_75[ChapterConst.FlagLava]) then
		arg0_75:hideQuadMark(ChapterConst.MarkLava)
		arg0_75:showQuadMark(var2_75[ChapterConst.FlagLava], ChapterConst.MarkLava, "cell_lava", Vector2(110, 110), nil, true)
	end

	if var2_75[ChapterConst.FlagNightmare] and next(var2_75[ChapterConst.FlagNightmare]) then
		arg0_75:hideQuadMark(ChapterConst.MarkNightMare)
		arg0_75:hideQuadMark(ChapterConst.MarkHideNight)

		local var4_75 = var0_75:getExtraFlags()

		if table.contains(var4_75, ChapterConst.StatusDay) then
			arg0_75:showQuadMark(var2_75[ChapterConst.FlagNightmare], ChapterConst.MarkHideNight, "cell_hidden_nightmare", Vector2(110, 110), nil, true)
		elseif table.contains(var4_75, ChapterConst.StatusNight) then
			arg0_75:showQuadMark(var2_75[ChapterConst.FlagNightmare], ChapterConst.MarkNightMare, "cell_nightmare", Vector2(110, 110), nil, true)
		end
	end

	local var5_75 = {}

	for iter4_75, iter5_75 in pairs(var0_75:GetChapterCellAttachemnts()) do
		if iter5_75.data == ChapterConst.StoryTrigger then
			local var6_75 = pg.map_event_template[iter5_75.attachmentId]

			assert(var6_75, "map_event_template not exists " .. iter5_75.attachmentId)

			if var6_75 and var6_75.c_type == ChapterConst.EvtType_AdditionalFloor then
				var5_75[var6_75.icon] = var5_75[var6_75.icon] or {}

				table.insert(var5_75[var6_75.icon], iter5_75)
			end
		end
	end

	for iter6_75, iter7_75 in pairs(var5_75) do
		arg0_75:hideQuadMark(iter6_75)
		arg0_75:showQuadMark(iter7_75, iter6_75, iter6_75, Vector2(110, 110), nil, true)
	end

	local var7_75 = var0_75:getConfig("alarm_cell")

	if var7_75 and #var7_75 > 0 then
		local var8_75 = var7_75[3]

		arg0_75:ClearEdges(var8_75)
		arg0_75:ClearEdges(var8_75 .. "corner")
		arg0_75:AddEdgePool(var8_75, "chapter/celltexture/" .. var8_75, "")
		arg0_75:AddEdgePool(var8_75 .. "_corner", "chapter/celltexture/" .. var8_75 .. "_corner", "")

		local var9_75 = _.map(var7_75[1], function(arg0_76)
			return {
				row = arg0_76[1],
				column = arg0_76[2]
			}
		end)

		arg0_75:AddOutlines(var9_75, nil, var7_75[5], var7_75[4], var8_75)

		local var10_75 = var7_75[2]

		arg0_75:hideQuadMark(var10_75)
		arg0_75:showQuadMark(var9_75, var10_75, var10_75, Vector2(104, 104), nil, true)
	end

	arg0_75:HideMissileAimingMarks()

	if var2_75[ChapterConst.FlagMissleAiming] and next(var2_75[ChapterConst.FlagMissleAiming]) then
		arg0_75:ShowMissileAimingMarks(var2_75[ChapterConst.FlagMissleAiming])
	end

	local var11_75 = var0_75.fleet

	if var0_75:isPlayingWithBombEnemy() then
		local var12_75 = _.map({
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
		}, function(arg0_77)
			return {
				row = arg0_77[1] + var11_75.line.row,
				column = arg0_77[2] + var11_75.line.column
			}
		end)

		arg0_75:showQuadMark(var12_75, ChapterConst.MarkBomb, "cell_bomb", Vector2(100, 100), nil, true)
	end
end

function var0_0.updateExtraAttachments(arg0_78)
	local var0_78 = arg0_78.contextData.chapterVO
	local var1_78 = var0_78:GetChapterCellAttachemnts()

	for iter0_78, iter1_78 in pairs(var1_78) do
		local var2_78 = iter1_78.row
		local var3_78 = iter1_78.column
		local var4_78 = arg0_78.cellRoot:Find(iter0_78):Find(ChapterConst.ChildAttachment)
		local var5_78 = pg.map_event_template[iter1_78.attachmentId]
		local var6_78 = iter1_78.data
		local var7_78

		if var6_78 == ChapterConst.StoryTrigger and var5_78.c_type ~= ChapterConst.EvtType_AdditionalFloor then
			var7_78 = MapEventStoryTriggerCellView
		end

		local var8_78 = arg0_78.extraAttachmentCells[iter0_78]

		if var8_78 and var8_78.class ~= var7_78 then
			var8_78:Clear()

			var8_78 = nil
			arg0_78.extraAttachmentCells[iter0_78] = nil
		end

		if var7_78 then
			if not var8_78 then
				var8_78 = var7_78.New(var4_78)
				arg0_78.extraAttachmentCells[iter0_78] = var8_78
			end

			var8_78.info = iter1_78
			var8_78.chapter = var0_78

			var8_78:SetLine({
				row = var2_78,
				column = var3_78
			})
			var8_78:Update()
		end
	end
end

function var0_0.updateAttachment(arg0_79, arg1_79, arg2_79)
	local var0_79 = arg0_79.contextData.chapterVO
	local var1_79 = var0_79:getChapterCell(arg1_79, arg2_79)

	if not var1_79 then
		return
	end

	local var2_79 = ChapterCell.Line2Name(arg1_79, arg2_79)
	local var3_79 = arg0_79.cellRoot:Find(var2_79):Find(ChapterConst.ChildAttachment)
	local var4_79
	local var5_79 = {}

	if ChapterConst.IsEnemyAttach(var1_79.attachment) then
		local var6_79 = pg.expedition_data_template[var1_79.attachmentId]

		assert(var6_79, "expedition_data_template not exist: " .. var1_79.attachmentId)

		if var1_79.flag == ChapterConst.CellFlagDisabled then
			if var1_79.attachment ~= ChapterConst.AttachAmbush then
				var4_79 = EnemyDeadCellView
				var5_79.chapter = var0_79
				var5_79.config = var6_79
			end
		elseif var1_79.flag == ChapterConst.CellFlagActive then
			var4_79 = var6_79.icon_type == 1 and StaticEggCellView or StaticChampionCellView
			var5_79.config = var6_79
			var5_79.chapter = var0_79
			var5_79.viewParent = arg0_79
		end
	elseif var1_79.attachment == ChapterConst.AttachBox then
		var4_79 = AttachmentBoxCell
	elseif var1_79.attachment == ChapterConst.AttachSupply then
		var4_79 = AttachmentSupplyCell
	elseif var1_79.attachment == ChapterConst.AttachTransport_Target then
		var4_79 = AttachmentTransportTargetCell
	elseif var1_79.attachment == ChapterConst.AttachStory then
		if var1_79.data == ChapterConst.Story then
			var4_79 = MapEventStoryCellView
		elseif var1_79.data == ChapterConst.StoryObstacle then
			var4_79 = MapEventStoryObstacleCellView
			var5_79.chapter = var0_79
		end
	elseif var1_79.attachment == ChapterConst.AttachBomb_Enemy then
		var4_79 = AttachmentBombEnemyCell
	elseif var1_79.attachment == ChapterConst.AttachLandbase then
		local var7_79 = pg.land_based_template[var1_79.attachmentId]

		assert(var7_79, "land_based_template not exist: " .. var1_79.attachmentId)

		if var7_79.type == ChapterConst.LBCoastalGun then
			var4_79 = AttachmentLBCoastalGunCell
		elseif var7_79.type == ChapterConst.LBHarbor then
			var4_79 = AttachmentLBHarborCell
		elseif var7_79.type == ChapterConst.LBDock then
			var4_79 = AttachmentLBDockCell
			var5_79.chapter = var0_79
		elseif var7_79.type == ChapterConst.LBAntiAir then
			var4_79 = AttachmentLBAntiAirCell
			var5_79.info = var1_79
			var5_79.chapter = var0_79
			var5_79.grid = arg0_79
		elseif var7_79.type == ChapterConst.LBFogLightBase then
			var4_79 = AttachmentLBFogLightBase
		elseif var7_79.type == ChapterConst.LBIdle and var1_79.attachmentId == ChapterConst.LBIDAirport then
			var4_79 = AttachmentLBAirport
			var5_79.extraFlagList = var0_79:getExtraFlags()
		end
	elseif var1_79.attachment == ChapterConst.AttachBarrier then
		var4_79 = AttachmentBarrierCell
	elseif var1_79.attachment == ChapterConst.AttachNone then
		var5_79.fadeAnim = (function()
			local var0_80 = arg0_79.attachmentCells[var2_79]

			if not var0_80 then
				return
			end

			if var0_80.class ~= StaticEggCellView and var0_80.class ~= StaticChampionCellView then
				return
			end

			local var1_80 = var0_80.info

			if not var1_80 then
				return
			end

			return pg.expedition_data_template[var1_80.attachmentId].dungeon_id == 0
		end)()
	end

	if var5_79.fadeAnim then
		arg0_79:PlayAttachmentEffect(arg1_79, arg2_79, "miwuxiaosan")
	end

	local var8_79 = arg0_79.attachmentCells[var2_79]

	if var8_79 and var8_79.class ~= var4_79 then
		var8_79:Clear()

		var8_79 = nil
		arg0_79.attachmentCells[var2_79] = nil
	end

	if var4_79 then
		if not var8_79 then
			var8_79 = var4_79.New(var3_79)

			var8_79:SetLine({
				row = arg1_79,
				column = arg2_79
			})

			arg0_79.attachmentCells[var2_79] = var8_79
		end

		var8_79.info = var1_79

		for iter0_79, iter1_79 in pairs(var5_79) do
			var8_79[iter0_79] = iter1_79
		end

		var8_79:Update()
	end
end

function var0_0.InitWalls(arg0_81)
	local var0_81 = arg0_81.contextData.chapterVO

	for iter0_81 = arg0_81.indexMin.x, arg0_81.indexMax.x do
		for iter1_81 = arg0_81.indexMin.y, arg0_81.indexMax.y do
			local var1_81 = var0_81:GetRawChapterCell(iter0_81, iter1_81)

			if var1_81 then
				local var2_81 = ChapterConst.ForbiddenUp

				while var2_81 > 0 do
					arg0_81:InitWallDirection(var1_81, var2_81)

					var2_81 = var2_81 / 2
				end
			end
		end
	end

	for iter2_81, iter3_81 in pairs(arg0_81.walls) do
		if iter3_81.WallPrefabs then
			iter3_81:SetAsset(iter3_81.WallPrefabs[5 - iter3_81.BanCount])
		end
	end
end

local var3_0 = {
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

function var0_0.InitWallDirection(arg0_82, arg1_82, arg2_82)
	local var0_82 = arg0_82.contextData.chapterVO

	if bit.band(arg1_82.forbiddenDirections, arg2_82) == 0 then
		return
	end

	if arg1_82.walkable == false then
		return
	end

	local var1_82 = var3_0[arg2_82]
	local var2_82 = 2 * arg1_82.row + var1_82[1]
	local var3_82 = 2 * arg1_82.column + var1_82[2]
	local var4_82 = var0_82:GetRawChapterCell(arg1_82.row + var1_82[1], arg1_82.column + var1_82[2])
	local var5_82 = not var4_82 or var4_82.walkable == false
	local var6_82 = var2_82 .. "_" .. var3_82
	local var7_82 = arg0_82.walls[var6_82]

	if not var7_82 then
		local var8_82 = var0_82.theme:GetLinePosition(arg1_82.row, arg1_82.column)

		var8_82.x = var8_82.x + var1_82[2] * (var0_82.theme.cellSize.x + var0_82.theme.cellSpace.x) * 0.5
		var8_82.y = var8_82.y - var1_82[1] * (var0_82.theme.cellSize.y + var0_82.theme.cellSpace.y) * 0.5

		local var9_82 = WallCell.New(var2_82, var3_82, bit.band(arg2_82, ChapterConst.ForbiddenRow) > 0, var8_82)

		var9_82.girdParent = arg0_82
		arg0_82.walls[var6_82] = var9_82
		var7_82 = var9_82

		local var10_82 = var0_82.wallAssets[arg1_82.row .. "_" .. arg1_82.column]

		if var10_82 then
			var7_82.WallPrefabs = var10_82
		end
	end

	var7_82.BanCount = var7_82.BanCount + (var5_82 and 2 or 1)
end

function var0_0.UpdateWeatherCells(arg0_83, arg1_83)
	local var0_83 = arg0_83.contextData.chapterVO

	arg1_83 = arg1_83 or underscore.keys(var0_83.cells)

	local var1_83 = var0_83:IsFogStage()

	for iter0_83, iter1_83 in ipairs(arg1_83) do
		local var2_83 = var0_83.cells[iter1_83]
		local var3_83
		local var4_83 = var2_83:GetWeatherFlagList()

		if #var4_83 > 0 then
			var3_83 = MapWeatherCellView
		end

		local var5_83 = arg0_83.weatherCells[iter1_83]

		if var5_83 and var5_83.class ~= var3_83 then
			var5_83:Clear()

			var5_83 = nil
			arg0_83.weatherCells[iter1_83] = nil
		end

		if var3_83 then
			if not var5_83 then
				local var6_83 = arg0_83.cellRoot:Find(iter1_83):Find(ChapterConst.ChildAttachment)

				var5_83 = var3_83.New(var6_83)

				var5_83:SetLine({
					row = var2_83.row,
					column = var2_83.column
				})

				arg0_83.weatherCells[iter1_83] = var5_83
			end

			var5_83.info = var2_83

			var5_83:Update(var4_83)
		end

		if var1_83 then
			local var7_83 = var0_83:GetEnemy(var2_83.row, var2_83.column)

			if tobool(var7_83) then
				arg0_83:updateAttachment(var2_83.row, var2_83.column)
			end
		end
	end
end

function var0_0.updateFogCells(arg0_84)
	local var0_84 = arg0_84.contextData.chapterVO

	for iter0_84, iter1_84 in pairs(var0_84.cells) do
		local var1_84 = ChapterCell.Line2Name(iter1_84.row, iter1_84.column)
		local var2_84 = arg0_84.cellRoot:Find(var1_84)

		setImageAlpha(var2_84:Find(ChapterConst.ChildVisible .. "/mask"), iter1_84:IsVisible() and 0 or 0.4)
	end
end

function var0_0.updateQuadCells(arg0_85, arg1_85)
	arg1_85 = arg1_85 or ChapterConst.QuadStateNormal
	arg0_85.quadState = arg1_85

	arg0_85:updateQuadBase()

	if arg1_85 == ChapterConst.QuadStateNormal then
		arg0_85:UpdateQuadStateNormal()
	elseif arg1_85 == ChapterConst.QuadStateBarrierSetting then
		arg0_85:UpdateQuadStateBarrierSetting()
	elseif arg1_85 == ChapterConst.QuadStateTeleportSub then
		arg0_85:UpdateQuadStateTeleportSub()
	elseif arg1_85 == ChapterConst.QuadStateMissileStrike or arg1_85 == ChapterConst.QuadStateAirSuport then
		arg0_85:UpdateQuadStateMissileStrike()
	elseif arg1_85 == ChapterConst.QuadStateExpel then
		arg0_85:UpdateQuadStateAirExpel()
	end

	arg0_85:UpdateOpBtns()
end

function var0_0.PlayQuadsParallelAnim(arg0_86, arg1_86)
	arg0_86:frozen()
	table.ParallelIpairsAsync(arg1_86, function(arg0_87, arg1_87, arg2_87)
		local var0_87 = ChapterCell.Line2QuadName(arg1_87.row, arg1_87.column)
		local var1_87 = arg0_86.quadRoot:Find(var0_87)

		arg0_86:cancelQuadTween(var0_87, var1_87)
		setImageAlpha(var1_87, 0.4)

		local var2_87 = LeanTween.scale(var1_87, Vector3.one, 0.2):setFrom(Vector3.zero):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(arg2_87))

		arg0_86.presentTws[var0_87] = {
			uniqueId = var2_87.uniqueId
		}
	end, function()
		arg0_86:unfrozen()
	end)
end

function var0_0.updateQuadBase(arg0_89)
	local var0_89 = arg0_89.contextData.chapterVO

	if var0_89.fleet == nil then
		return
	end

	arg0_89:killPresentTws()

	local function var1_89(arg0_90)
		if not arg0_90 or not arg0_90:IsWalkable() then
			return
		end

		local var0_90 = arg0_90.row
		local var1_90 = arg0_90.column
		local var2_90 = ChapterCell.Line2QuadName(var0_90, var1_90)
		local var3_90 = arg0_89.quadRoot:Find(var2_90)

		var3_90.localScale = Vector3.one

		local var4_90 = var3_90:Find("grid"):GetComponent(typeof(Image))
		local var5_90 = var0_89:getChampion(var0_90, var1_90)

		if var5_90 and var5_90.flag == ChapterConst.CellFlagActive and var5_90.trait ~= ChapterConst.TraitLurk and var0_89:getChampionVisibility(var5_90) and not var0_89:existFleet(FleetType.Transport, var0_90, var1_90) then
			arg0_89:startQuadTween(var2_90, var3_90)
			setImageSprite(var3_90, GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_enemy"))
			setImageSprite(var3_90:Find("grid"), GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_enemy_grid"))

			var4_90.material = arg0_89.material_Add

			return
		end

		local var6_90 = var0_89:GetRawChapterAttachemnt(var0_90, var1_90)

		if var6_90 then
			local var7_90 = var0_89:getQuadCellPic(var6_90)

			if var7_90 then
				arg0_89:startQuadTween(var2_90, var3_90)
				setImageSprite(var3_90, GetSpriteFromAtlas("chapter/pic/cellgrid", var7_90))

				return
			end
		end

		if var0_89:getChapterCell(var0_90, var1_90) then
			local var8_90 = var0_89:getQuadCellPic(arg0_90)

			if var8_90 then
				arg0_89:startQuadTween(var2_90, var3_90)

				if var8_90 == "cell_enemy" then
					setImageSprite(var3_90:Find("grid"), GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_enemy_grid"))

					var4_90.material = arg0_89.material_Add
				else
					setImageSprite(var3_90:Find("grid"), GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid"))

					var4_90.material = nil
				end

				setImageSprite(var3_90, GetSpriteFromAtlas("chapter/pic/cellgrid", var8_90))

				return
			end
		end

		arg0_89:cancelQuadTween(var2_90, var3_90)
		setImageAlpha(var3_90, ChapterConst.CellEaseOutAlpha)
		setImageSprite(var3_90, GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_normal"))
		setImageSprite(var3_90:Find("grid"), GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid"))

		var4_90.material = nil
	end

	for iter0_89, iter1_89 in pairs(var0_89.cells) do
		var1_89(iter1_89)
	end

	if var0_89:isPlayingWithBombEnemy() then
		arg0_89:hideQuadMark(ChapterConst.MarkBomb)
	end
end

function var0_0.UpdateQuadStateNormal(arg0_91)
	local var0_91 = arg0_91.contextData.chapterVO
	local var1_91 = var0_91.fleet
	local var2_91

	if var0_91:existMoveLimit() and not var0_91:checkAnyInteractive() then
		var2_91 = var0_91:calcWalkableCells(ChapterConst.SubjectPlayer, var1_91.line.row, var1_91.line.column, var1_91:getSpeed())
	end

	if not var2_91 or #var2_91 == 0 then
		return
	end

	local var3_91 = _.min(var2_91, function(arg0_92)
		return ManhattonDist(arg0_92, var1_91.line)
	end)
	local var4_91 = ManhattonDist(var3_91, var1_91.line)

	_.each(var2_91, function(arg0_93)
		local var0_93 = ChapterCell.Line2QuadName(arg0_93.row, arg0_93.column)
		local var1_93 = arg0_91.quadRoot:Find(var0_93)

		arg0_91:cancelQuadTween(var0_93, var1_93)
		setImageSprite(var1_93, GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_normal"))

		local var2_93 = var1_93:Find("grid"):GetComponent(typeof(Image))

		var2_93.sprite = GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid")
		var2_93.material = nil

		local var3_93 = var0_91:getRound() == ChapterConst.RoundPlayer

		setImageAlpha(var1_93, var3_93 and 1 or ChapterConst.CellEaseOutAlpha)

		var1_93.localScale = Vector3.zero

		local var4_93 = LeanTween.scale(var1_93, Vector3.one, 0.2):setFrom(Vector3.zero):setEase(LeanTweenType.easeInOutSine):setDelay((ManhattonDist(arg0_93, var1_91.line) - var4_91) * 0.1)

		arg0_91.presentTws[var0_93] = {
			uniqueId = var4_93.uniqueId
		}
	end)
end

function var0_0.UpdateQuadStateBarrierSetting(arg0_94)
	local var0_94 = 1
	local var1_94 = arg0_94.contextData.chapterVO
	local var2_94 = var1_94.fleet
	local var3_94 = var2_94.line
	local var4_94 = var1_94:calcSquareBarrierCells(var3_94.row, var3_94.column, var0_94)

	if not var4_94 or #var4_94 == 0 then
		return
	end

	local var5_94 = _.min(var4_94, function(arg0_95)
		return ManhattonDist(arg0_95, var2_94.line)
	end)
	local var6_94 = ManhattonDist(var5_94, var2_94.line)

	_.each(var4_94, function(arg0_96)
		local var0_96 = ChapterCell.Line2QuadName(arg0_96.row, arg0_96.column)
		local var1_96 = arg0_94.quadRoot:Find(var0_96)

		arg0_94:cancelQuadTween(var0_96, var1_96)
		setImageSprite(var1_96, GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_barrier_select"))

		local var2_96 = var1_96:Find("grid"):GetComponent(typeof(Image))

		var2_96.sprite = GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid")
		var2_96.material = nil

		setImageAlpha(var1_96, 1)

		var1_96.localScale = Vector3.zero

		local var3_96 = LeanTween.scale(var1_96, Vector3.one, 0.2):setFrom(Vector3.zero):setEase(LeanTweenType.easeInOutSine):setDelay((ManhattonDist(arg0_96, var2_94.line) - var6_94) * 0.1)

		arg0_94.presentTws[var0_96] = {
			uniqueId = var3_96.uniqueId
		}
	end)
end

function var0_0.UpdateQuadStateTeleportSub(arg0_97)
	local var0_97 = arg0_97.contextData.chapterVO
	local var1_97 = _.detect(var0_97.fleets, function(arg0_98)
		return arg0_98:getFleetType() == FleetType.Submarine
	end)

	if not var1_97 then
		return
	end

	local var2_97 = var0_97:calcWalkableCells(nil, var1_97.line.row, var1_97.line.column, ChapterConst.MaxStep)
	local var3_97 = _.filter(var2_97, function(arg0_99)
		return not var0_97:getQuadCellPic(var0_97:getChapterCell(arg0_99.row, arg0_99.column))
	end)

	arg0_97:PlayQuadsParallelAnim(var3_97)
end

function var0_0.UpdateQuadStateMissileStrike(arg0_100)
	local var0_100 = arg0_100.contextData.chapterVO
	local var1_100 = _.filter(_.values(var0_100.cells), function(arg0_101)
		return arg0_101:IsWalkable() and not var0_100:getQuadCellPic(arg0_101)
	end)

	arg0_100:PlayQuadsParallelAnim(var1_100)
end

function var0_0.UpdateQuadStateAirExpel(arg0_102)
	local var0_102 = arg0_102.contextData.chapterVO
	local var1_102 = arg0_102.airSupportTarget

	if not var1_102 or not var1_102.source then
		local var2_102 = _.filter(_.values(var0_102.cells), function(arg0_103)
			return arg0_103:IsWalkable() and not var0_102:getQuadCellPic(arg0_103)
		end)

		arg0_102:PlayQuadsParallelAnim(var2_102)

		return
	end

	local var3_102 = var1_102.source
	local var4_102 = var0_102:calcWalkableCells(ChapterConst.SubjectChampion, var3_102.row, var3_102.column, 1)

	arg0_102:PlayQuadsParallelAnim(var4_102)
end

function var0_0.ClickGridCell(arg0_104, arg1_104)
	if arg0_104.quadState == ChapterConst.QuadStateBarrierSetting then
		arg0_104:OnBarrierSetting(arg1_104)
	elseif arg0_104.quadState == ChapterConst.QuadStateTeleportSub then
		arg0_104:OnTeleportConfirm(arg1_104)
	elseif arg0_104.quadState == ChapterConst.QuadStateMissileStrike then
		arg0_104:OnMissileAiming(arg1_104)
	elseif arg0_104.quadState == ChapterConst.QuadStateAirSuport then
		arg0_104:OnAirSupportAiming(arg1_104)
	elseif arg0_104.quadState == ChapterConst.QuadStateExpel then
		arg0_104:OnAirExpelSelect(arg1_104)
	else
		arg0_104:emit(LevelUIConst.ON_CLICK_GRID_QUAD, arg1_104)
	end
end

function var0_0.OnBarrierSetting(arg0_105, arg1_105)
	local var0_105 = 1
	local var1_105 = arg0_105.contextData.chapterVO
	local var2_105 = var1_105.fleet.line
	local var3_105 = var1_105:calcSquareBarrierCells(var2_105.row, var2_105.column, var0_105)

	if not _.any(var3_105, function(arg0_106)
		return arg0_106.row == arg1_105.row and arg0_106.column == arg1_105.column
	end) then
		return
	end

	;(function(arg0_107, arg1_107)
		newChapterVO = arg0_105.contextData.chapterVO

		if not newChapterVO:existBarrier(arg0_107, arg1_107) and newChapterVO.modelCount <= 0 then
			return
		end

		arg0_105:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpBarrier,
			id = newChapterVO.fleet.id,
			arg1 = arg0_107,
			arg2 = arg1_107
		})
	end)(arg1_105.row, arg1_105.column)
end

function var0_0.PrepareSubTeleport(arg0_108)
	local var0_108 = arg0_108.contextData.chapterVO
	local var1_108 = var0_108:GetSubmarineFleet()
	local var2_108 = arg0_108.cellFleets[var1_108.id]
	local var3_108 = var1_108.startPos

	for iter0_108, iter1_108 in pairs(var0_108.fleets) do
		if iter1_108:getFleetType() == FleetType.Normal then
			arg0_108:updateFleet(iter1_108.id)
		end
	end

	local var4_108 = var0_108:existEnemy(ChapterConst.SubjectPlayer, var3_108.row, var3_108.column) or var0_108:existFleet(FleetType.Normal, var3_108.row, var3_108.column)

	setActive(var2_108.tfAmmo, not var4_108)
	var2_108:SetActiveModel(true)

	if not (var0_108.subAutoAttack == 1) then
		arg0_108:PlaySubAnimation(var2_108, false, function()
			var2_108:SetActiveModel(not var4_108)
		end)
	else
		var2_108:SetActiveModel(not var4_108)
	end

	var2_108.tf.localPosition = var0_108.theme:GetLinePosition(var3_108.row, var3_108.column)

	var2_108:ResetCanvasOrder()
end

function var0_0.TurnOffSubTeleport(arg0_110)
	arg0_110.subTeleportTargetLine = nil

	local var0_110 = arg0_110.contextData.chapterVO

	arg0_110:hideQuadMark(ChapterConst.MarkMovePathArrow)
	arg0_110:hideQuadMark(ChapterConst.MarkHuntingRange)
	arg0_110:ClearEdges("SubmarineHunting")
	arg0_110:UpdateDestinationMark()

	local var1_110 = var0_110:GetSubmarineFleet()
	local var2_110 = arg0_110.cellFleets[var1_110.id]
	local var3_110 = var0_110.subAutoAttack == 1

	var2_110:SetActiveModel(var3_110)

	if not var3_110 then
		arg0_110:PlaySubAnimation(var2_110, true, function()
			arg0_110:updateFleet(var1_110.id)
		end)
	else
		arg0_110:updateFleet(var1_110.id)
	end

	arg0_110:ShowHuntingRange()
end

function var0_0.OnTeleportConfirm(arg0_112, arg1_112)
	local var0_112 = arg0_112.contextData.chapterVO
	local var1_112 = var0_112:getChapterCell(arg1_112.row, arg1_112.column)

	if var1_112 and var1_112:IsWalkable() and not var0_112:existBarrier(arg1_112.row, arg1_112.column) then
		local var2_112 = var0_112:GetSubmarineFleet()

		if var2_112.startPos.row == arg1_112.row and var2_112.startPos.column == arg1_112.column then
			return
		end

		local var3_112, var4_112 = var0_112:findPath(nil, var2_112.startPos, arg1_112)

		if var3_112 >= PathFinding.PrioObstacle or arg1_112.row ~= var4_112[#var4_112].row or arg1_112.column ~= var4_112[#var4_112].column then
			return
		end

		arg0_112:ShowTargetHuntingRange(arg1_112)
		arg0_112:UpdateDestinationMark(arg1_112)

		if var3_112 > 0 then
			arg0_112:ShowPathInArrows(var4_112)

			arg0_112.subTeleportTargetLine = arg1_112
		end
	end
end

function var0_0.ShowPathInArrows(arg0_113, arg1_113)
	local var0_113 = arg0_113.contextData.chapterVO
	local var1_113 = Clone(arg1_113)

	table.remove(var1_113, #var1_113)

	for iter0_113 = #var1_113, 1, -1 do
		local var2_113 = var1_113[iter0_113]

		if var0_113:existEnemy(ChapterConst.SubjectPlayer, var2_113.row, var2_113.column) or var0_113:getFleet(FleetType.Normal, var2_113.row, var2_113.column) then
			table.remove(var1_113, iter0_113)
		end
	end

	arg0_113:hideQuadMark(ChapterConst.MarkMovePathArrow)
	arg0_113:showQuadMark(var1_113, ChapterConst.MarkMovePathArrow, "cell_path_arrow", Vector2(100, 100), nil, true)

	local var3_113 = arg0_113.markQuads[ChapterConst.MarkMovePathArrow]

	for iter1_113 = #arg1_113, 1, -1 do
		local var4_113 = arg1_113[iter1_113]
		local var5_113 = ChapterCell.Line2MarkName(var4_113.row, var4_113.column, ChapterConst.MarkMovePathArrow)
		local var6_113 = var3_113 and var3_113[var5_113]

		if var6_113 then
			local var7_113 = arg1_113[iter1_113 + 1]
			local var8_113 = Vector3.Normalize(Vector3(var7_113.column - var4_113.column, var4_113.row - var7_113.row, 0))
			local var9_113 = Vector3.Dot(var8_113, Vector3.up)
			local var10_113 = Mathf.Acos(var9_113) * Mathf.Rad2Deg
			local var11_113 = Vector3.Cross(Vector3.up, var8_113).z > 0 and 1 or -1

			var6_113.localEulerAngles = Vector3(0, 0, var10_113 * var11_113)
		end
	end
end

function var0_0.ShowMissileAimingMarks(arg0_114, arg1_114)
	_.each(arg1_114, function(arg0_115)
		arg0_114.loader:GetPrefabBYGroup("ui/miaozhun02", "miaozhun02", function(arg0_116)
			setParent(arg0_116, arg0_114.restrictMap)

			local var0_116 = arg0_114.contextData.chapterVO.theme:GetLinePosition(arg0_115.row, arg0_115.column)
			local var1_116 = arg0_114.restrictMap.anchoredPosition

			tf(arg0_116).anchoredPosition = Vector2(var0_116.x - var1_116.x, var0_116.y - var1_116.y)
		end, "MissileAimingMarks")
	end)
end

function var0_0.HideMissileAimingMarks(arg0_117)
	arg0_117.loader:ReturnGroup("MissileAimingMarks")
end

function var0_0.ShowMissileAimingMark(arg0_118, arg1_118)
	arg0_118.loader:GetPrefab("ui/miaozhun02", "miaozhun02", function(arg0_119)
		setParent(arg0_119, arg0_118.restrictMap)

		local var0_119 = arg0_118.contextData.chapterVO.theme:GetLinePosition(arg1_118.row, arg1_118.column)
		local var1_119 = arg0_118.restrictMap.anchoredPosition

		tf(arg0_119).anchoredPosition = Vector2(var0_119.x - var1_119.x, var0_119.y - var1_119.y)
	end, "MissileAimingMark")
end

function var0_0.HideMissileAimingMark(arg0_120)
	arg0_120.loader:ClearRequest("MissileAimingMark")
end

function var0_0.OnMissileAiming(arg0_121, arg1_121)
	arg0_121:HideMissileAimingMark()
	arg0_121:ShowMissileAimingMark(arg1_121)

	arg0_121.missileStrikeTargetLine = arg1_121
end

function var0_0.ShowAirSupportAimingMark(arg0_122, arg1_122)
	arg0_122.loader:GetPrefab("ui/miaozhun03", "miaozhun03", function(arg0_123)
		setParent(arg0_123, arg0_122.restrictMap)

		local var0_123 = arg0_122.contextData.chapterVO.theme:GetLinePosition(arg1_122.row - 0.5, arg1_122.column)
		local var1_123 = arg0_122.restrictMap.anchoredPosition

		tf(arg0_123).anchoredPosition = Vector2(var0_123.x - var1_123.x, var0_123.y - var1_123.y)
	end, "AirSupportAimingMark")
end

function var0_0.HideAirSupportAimingMark(arg0_124)
	arg0_124.loader:ClearRequest("AirSupportAimingMark")
end

function var0_0.OnAirSupportAiming(arg0_125, arg1_125)
	arg0_125:HideAirSupportAimingMark()
	arg0_125:ShowAirSupportAimingMark(arg1_125)

	arg0_125.missileStrikeTargetLine = arg1_125
end

function var0_0.ShowAirExpelAimingMark(arg0_126)
	local var0_126 = arg0_126.airSupportTarget

	if not var0_126 or not var0_126.source then
		return
	end

	local var1_126 = var0_126.source
	local var2_126 = ChapterCell.Line2Name(var1_126.row, var1_126.column)
	local var3_126 = arg0_126.cellRoot:Find(var2_126)

	local function var4_126(arg0_127, arg1_127)
		setParent(arg0_127, var3_126)

		GetOrAddComponent(arg0_127, typeof(Canvas)).overrideSorting = true

		if not arg1_127 then
			return
		end

		local var0_127 = arg0_126.contextData.chapterVO

		tf(arg0_127).localEulerAngles = Vector3(-var0_127.theme.angle, 0, 0)
	end

	arg0_126.loader:GetPrefabBYGroup("leveluiview/tpl_airsupportmark", "tpl_airsupportmark", function(arg0_128)
		var4_126(arg0_128, true)
	end, "AirExpelAimingMark")
	arg0_126.loader:GetPrefabBYGroup("leveluiview/tpl_airsupportdirection", "tpl_airsupportdirection", function(arg0_129)
		var4_126(arg0_129)

		local var0_129 = arg0_126.contextData.chapterVO
		local var1_129 = {
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

		for iter0_129 = 1, 4 do
			local var2_129 = tf(arg0_129):Find(iter0_129)
			local var3_129 = var0_126 and var0_129:considerAsStayPoint(ChapterConst.SubjectChampion, var1_126.row + var1_129[iter0_129][1], var1_126.column + var1_129[iter0_129][2])

			setActive(var2_129, var3_129)
		end
	end, "AirExpelAimingMark")
end

function var0_0.HideAirExpelAimingMark(arg0_130)
	arg0_130.loader:ReturnGroup("AirExpelAimingMark")
end

function var0_0.OnAirExpelSelect(arg0_131, arg1_131)
	local var0_131 = arg0_131.contextData.chapterVO

	local function var1_131()
		arg0_131:HideAirExpelAimingMark()
		arg0_131:ShowAirExpelAimingMark()
		arg0_131:updateQuadBase()
		arg0_131:UpdateQuadStateAirExpel()
	end

	arg0_131.airSupportTarget = arg0_131.airSupportTarget or {}

	local var2_131 = arg0_131.airSupportTarget
	local var3_131 = var0_131:GetEnemy(arg1_131.row, arg1_131.column)

	if var3_131 then
		if ChapterConst.IsBossCell(var3_131) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_select_boss"))

			return
		end

		if var0_131:existFleet(FleetType.Normal, arg1_131.row, arg1_131.column) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_select_battle"))

			return
		end

		if var2_131.source and table.equal(var2_131.source:GetLine(), var3_131:GetLine()) then
			var3_131 = nil
		end

		var2_131.source = var3_131

		var1_131()
	elseif not var2_131.source then
		pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_select_enemy"))
	elseif ManhattonDist(var2_131.source, arg1_131) > 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_outrange"))
	elseif not var0_131:considerAsStayPoint(ChapterConst.SubjectChampion, arg1_131.row, arg1_131.column) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_outrange"))
	else
		local var4_131 = arg0_131.airSupportTarget.source
		local var5_131 = arg1_131

		if not var4_131 or not var5_131 then
			return
		end

		local var6_131 = {
			arg1_131.row - var4_131.row,
			arg1_131.column - var4_131.column
		}
		local var7_131 = {
			"up",
			"right",
			"down",
			"left"
		}
		local var8_131

		if var6_131[1] ~= 0 then
			var8_131 = var6_131[1] + 2
		else
			var8_131 = 3 - var6_131[2]
		end

		local var9_131 = var7_131[var8_131]
		local var10_131 = var0_131:getChapterSupportFleet()

		local function var11_131()
			arg0_131:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var10_131.id,
				arg1 = ChapterConst.StrategyExpel,
				arg2 = var4_131.row,
				arg3 = var4_131.column,
				arg4 = var5_131.row,
				arg5 = var5_131.column
			})
		end

		local var12_131 = var4_131.attachmentId
		local var13_131 = pg.expedition_data_template[var12_131].name

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("levelscene_airexpel_select_confirm_" .. var9_131, var13_131),
			onYes = var11_131
		})
	end
end

function var0_0.CleanAirSupport(arg0_134)
	arg0_134.airSupportTarget = nil
end

function var0_0.startQuadTween(arg0_135, arg1_135, arg2_135, arg3_135, arg4_135)
	if arg0_135.presentTws[arg1_135] then
		LeanTween.cancel(arg0_135.presentTws[arg1_135].uniqueId)

		arg0_135.presentTws[arg1_135] = nil
	end

	if not arg0_135.quadTws[arg1_135] then
		arg3_135 = arg3_135 or 1
		arg4_135 = arg4_135 or ChapterConst.CellEaseOutAlpha

		setImageAlpha(arg2_135, arg3_135)

		local var0_135 = LeanTween.alpha(arg2_135, arg4_135, 1):setLoopPingPong()

		arg0_135.quadTws[arg1_135] = {
			tw = var0_135,
			uniqueId = var0_135.uniqueId
		}
	end
end

function var0_0.cancelQuadTween(arg0_136, arg1_136, arg2_136)
	if arg0_136.quadTws[arg1_136] then
		LeanTween.cancel(arg0_136.quadTws[arg1_136].uniqueId)

		arg0_136.quadTws[arg1_136] = nil
	end

	setImageAlpha(arg2_136, ChapterConst.CellEaseOutAlpha)
end

function var0_0.killQuadTws(arg0_137)
	for iter0_137, iter1_137 in pairs(arg0_137.quadTws) do
		LeanTween.cancel(iter1_137.uniqueId)
	end

	arg0_137.quadTws = {}
end

function var0_0.killPresentTws(arg0_138)
	for iter0_138, iter1_138 in pairs(arg0_138.presentTws) do
		LeanTween.cancel(iter1_138.uniqueId)
	end

	arg0_138.presentTws = {}
end

function var0_0.startMarkTween(arg0_139, arg1_139, arg2_139, arg3_139, arg4_139)
	if not arg0_139.markTws[arg1_139] then
		arg3_139 = arg3_139 or 1
		arg4_139 = arg4_139 or 0.2

		setImageAlpha(arg2_139, arg3_139)

		local var0_139 = LeanTween.alpha(arg2_139, arg4_139, 0.7):setLoopPingPong():setEase(LeanTweenType.easeInOutSine):setDelay(1)

		arg0_139.markTws[arg1_139] = {
			tw = var0_139,
			uniqueId = var0_139.uniqueId
		}
	end
end

function var0_0.cancelMarkTween(arg0_140, arg1_140, arg2_140, arg3_140)
	if arg0_140.markTws[arg1_140] then
		LeanTween.cancel(arg0_140.markTws[arg1_140].uniqueId)

		arg0_140.markTws[arg1_140] = nil
	end

	setImageAlpha(arg2_140, arg3_140 or ChapterConst.CellEaseOutAlpha)
end

function var0_0.moveFleet(arg0_141, arg1_141, arg2_141, arg3_141, arg4_141)
	local var0_141 = arg0_141.contextData.chapterVO
	local var1_141 = var0_141:IsFogStage()
	local var2_141 = var0_141.fleet
	local var3_141 = var2_141.id
	local var4_141 = arg0_141.cellFleets[var3_141]

	var4_141:SetSpineVisible(true)
	setActive(var4_141.tfShadow, true)
	setActive(arg0_141.arrowTarget, true)
	arg0_141:updateTargetArrow(arg2_141[#arg2_141])

	if arg3_141 then
		arg0_141:updateAttachment(arg3_141.row, arg3_141.column)
	end

	local function var5_141(arg0_142)
		if var1_141 then
			local var0_142 = var0_141:UpdateCellsVisible(var2_141, arg0_142)

			arg0_141:UpdateWeatherCells(var0_142)
		end
	end

	local function var6_141(arg0_143)
		var2_141.step = var2_141.step + 1

		var5_141(arg0_143)
		existCall(arg0_141.onShipStepChange, arg0_143)
	end

	local function var7_141(arg0_144)
		return
	end

	local function var8_141()
		setActive(arg0_141.arrowTarget, false)

		local var0_145 = var0_141.fleet.line
		local var1_145 = var0_141:getChapterCell(var0_145.row, var0_145.column)

		if ChapterConst.NeedClearStep(var1_145) then
			var2_141.step = 0
		end

		var2_141.rotation = var4_141:GetRotatePivot().transform.localRotation

		arg0_141:updateAttachment(var0_145.row, var0_145.column)
		arg0_141:updateFleet(var3_141)
		arg0_141:updateOni()

		local var2_145 = var0_141:getChampionIndex(var0_145.row, var0_145.column)

		if var2_145 then
			arg0_141:updateChampion(var2_145)
		end

		if arg0_141.onShipArrived then
			arg0_141.onShipArrived()
		end

		if arg4_141 then
			arg4_141()
		end
	end

	arg0_141:updateQuadCells(ChapterConst.QuadStateFrozen)
	var5_141(var4_141:GetLine())
	arg0_141:moveCellView(var4_141, arg1_141, arg2_141, var6_141, var7_141, var8_141)
end

function var0_0.moveSub(arg0_146, arg1_146, arg2_146, arg3_146, arg4_146)
	local var0_146 = arg0_146.contextData.chapterVO
	local var1_146 = var0_146.fleets[arg1_146]
	local var2_146 = arg0_146.cellFleets[var1_146.id]
	local var3_146 = arg2_146[#arg2_146]

	local function var4_146(arg0_147)
		return
	end

	local function var5_146(arg0_148)
		return
	end

	local function var6_146()
		local var0_149 = var0_146:existEnemy(ChapterConst.SubjectPlayer, var3_146.row, var3_146.column) or var0_146:existAlly(var1_146)
		local var1_149 = var0_146.subAutoAttack == 1

		var2_146:SetActiveModel(not var0_149 and var1_149)

		var1_146.rotation = var2_146:GetRotatePivot().transform.localRotation

		if arg4_146 then
			arg4_146()
		end
	end

	arg0_146:updateQuadCells(ChapterConst.QuadStateFrozen)
	arg0_146:teleportSubView(var2_146, var2_146:GetLine(), var3_146, var4_146, var5_146, var6_146)
end

function var0_0.moveChampion(arg0_150, arg1_150, arg2_150, arg3_150, arg4_150)
	local var0_150 = arg0_150.contextData.chapterVO
	local var1_150 = var0_150.champions[arg1_150]
	local var2_150 = arg0_150.cellChampions[arg1_150]

	local function var3_150(arg0_151)
		return
	end

	local function var4_150(arg0_152)
		return
	end

	local function var5_150()
		if var2_150.GetRotatePivot then
			var1_150.rotation = var2_150:GetRotatePivot().transform.localRotation
		end

		if arg4_150 then
			arg4_150()
		end
	end

	if var0_150:getChampionVisibility(var1_150) then
		arg0_150:moveCellView(var2_150, arg2_150, arg3_150, var3_150, var4_150, var5_150)
	else
		local var6_150 = arg2_150[#arg2_150]

		var2_150:RefreshLinePosition(var0_150, var6_150)
		var5_150()
	end
end

function var0_0.moveTransport(arg0_154, arg1_154, arg2_154, arg3_154, arg4_154)
	local var0_154 = arg0_154.contextData.chapterVO.fleets[arg1_154]
	local var1_154 = arg0_154.cellFleets[var0_154.id]

	local function var2_154(arg0_155)
		return
	end

	local function var3_154(arg0_156)
		return
	end

	local function var4_154()
		var0_154.rotation = var1_154:GetRotatePivot().transform.localRotation

		arg0_154:updateFleet(var0_154.id)
		existCall(arg4_154)
	end

	arg0_154:updateQuadCells(ChapterConst.QuadStateFrozen)
	arg0_154:moveCellView(var1_154, arg2_154, arg3_154, var2_154, var3_154, var4_154)
end

function var0_0.moveCellView(arg0_158, arg1_158, arg2_158, arg3_158, arg4_158, arg5_158, arg6_158)
	local var0_158 = arg0_158.contextData.chapterVO
	local var1_158

	local function var2_158()
		if var1_158 and coroutine.status(var1_158) == "suspended" then
			local var0_159, var1_159 = coroutine.resume(var1_158)

			assert(var0_159, debug.traceback(var1_158, var1_159))
		end
	end

	var1_158 = coroutine.create(function()
		arg0_158:frozen()

		local var0_160 = var0_158:GetQuickPlayFlag() and ChapterConst.ShipStepQuickPlayScale or 1
		local var1_160 = 0.3 * var0_160
		local var2_160 = ChapterConst.ShipStepDuration * ChapterConst.ShipMoveTailLength * var0_160
		local var3_160 = 0.1 * var0_160
		local var4_160 = 0

		table.insert(arg3_158, 1, arg1_158:GetLine())
		_.each(arg3_158, function(arg0_161)
			local var0_161 = var0_158:getChapterCell(arg0_161.row, arg0_161.column)

			if ChapterConst.NeedEasePathCell(var0_161) then
				local var1_161 = ChapterCell.Line2QuadName(var0_161.row, var0_161.column)
				local var2_161 = arg0_158.quadRoot:Find(var1_161)

				arg0_158:cancelQuadTween(var1_161, var2_161)
				LeanTween.alpha(var2_161, 1, var1_160):setDelay(var4_160)

				var4_160 = var4_160 + var3_160
			end
		end)
		_.each(arg2_158, function(arg0_162)
			arg0_158:moveStep(arg1_158, arg0_162, arg3_158[#arg3_158], function()
				local var0_163 = arg1_158:GetLine()
				local var1_163 = var0_158:getChapterCell(var0_163.row, var0_163.column)

				if ChapterConst.NeedEasePathCell(var1_163) then
					local var2_163 = ChapterCell.Line2QuadName(var1_163.row, var1_163.column)
					local var3_163 = arg0_158.quadRoot:Find(var2_163)

					LeanTween.scale(var3_163, Vector3.zero, var2_160)
				end

				arg4_158(arg0_162)
				arg1_158:SetLine(arg0_162)
				arg1_158:ResetCanvasOrder()
			end, function()
				arg5_158(arg0_162)
				var2_158()
			end)
			coroutine.yield()
		end)
		_.each(arg3_158, function(arg0_165)
			local var0_165 = var0_158:getChapterCell(arg0_165.row, arg0_165.column)

			if ChapterConst.NeedEasePathCell(var0_165) then
				local var1_165 = ChapterCell.Line2QuadName(var0_165.row, var0_165.column)
				local var2_165 = arg0_158.quadRoot:Find(var1_165)

				LeanTween.cancel(var2_165.gameObject)
				setImageAlpha(var2_165, ChapterConst.CellEaseOutAlpha)

				var2_165.localScale = Vector3.one
			end
		end)

		if arg0_158.exited then
			return
		end

		if arg1_158.GetAction then
			arg1_158:SetAction(ChapterConst.ShipIdleAction)
		end

		arg6_158()
		arg0_158:unfrozen()
	end)

	var2_158()
end

function var0_0.moveStep(arg0_166, arg1_166, arg2_166, arg3_166, arg4_166, arg5_166)
	local var0_166 = arg0_166.contextData.chapterVO
	local var1_166 = var0_166:GetQuickPlayFlag() and ChapterConst.ShipStepQuickPlayScale or 1
	local var2_166

	if arg1_166.GetRotatePivot then
		var2_166 = arg1_166:GetRotatePivot()
	end

	local var3_166 = arg1_166:GetLine()

	if arg1_166.GetAction then
		arg1_166:SetAction(ChapterConst.ShipMoveAction)
	end

	if not IsNil(var2_166) and (arg2_166.column ~= var3_166.column or arg3_166.column ~= var3_166.column) then
		tf(var2_166).localRotation = Quaternion.identity

		if arg2_166.column < var3_166.column or arg2_166.column == var3_166.column and arg3_166.column < var3_166.column then
			tf(var2_166).localRotation = Quaternion.Euler(0, 180, 0)
		end
	end

	local var4_166 = arg1_166.tf.localPosition
	local var5_166 = var0_166.theme:GetLinePosition(arg2_166.row, arg2_166.column)
	local var6_166 = 0

	LeanTween.value(arg1_166.go, 0, 1, ChapterConst.ShipStepDuration * var1_166):setOnComplete(System.Action(arg5_166)):setOnUpdate(System.Action_float(function(arg0_167)
		arg1_166.tf.localPosition = Vector3.Lerp(var4_166, var5_166, arg0_167)

		if var6_166 <= 0.5 and arg0_167 > 0.5 then
			arg4_166()
		end

		var6_166 = arg0_167
	end))
end

function var0_0.teleportSubView(arg0_168, arg1_168, arg2_168, arg3_168, arg4_168, arg5_168, arg6_168)
	local var0_168 = arg0_168.contextData.chapterVO

	local function var1_168()
		arg4_168(arg3_168)
		arg1_168:RefreshLinePosition(var0_168, arg3_168)
		arg5_168(arg3_168)
		arg0_168:PlaySubAnimation(arg1_168, false, arg6_168)
	end

	arg0_168:PlaySubAnimation(arg1_168, true, var1_168)
end

function var0_0.CellToScreen(arg0_170, arg1_170, arg2_170)
	local var0_170 = arg0_170._tf:Find(ChapterConst.PlaneName .. "/cells")

	assert(var0_170, "plane not exist.")

	local var1_170 = arg0_170.contextData.chapterVO.theme
	local var2_170 = var1_170:GetLinePosition(arg1_170, arg2_170)
	local var3_170 = var2_170.y

	var2_170.y = var3_170 * math.cos(math.pi / 180 * var1_170.angle)
	var2_170.z = var3_170 * math.sin(math.pi / 180 * var1_170.angle)

	local var4_170 = arg0_170.levelCam.transform:GetChild(0)
	local var5_170 = var0_170.transform.lossyScale.x
	local var6_170 = var0_170.position + var2_170 * var5_170
	local var7_170 = arg0_170.levelCam:WorldToViewportPoint(var6_170)

	return Vector3(var4_170.rect.width * (var7_170.x - 0.5), var4_170.rect.height * (var7_170.y - 0.5))
end

local var4_0 = {
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
local var5_0 = {
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

function var0_0.AddCellEdge(arg0_171, arg1_171, arg2_171, ...)
	local var0_171 = 0
	local var1_171 = 1

	for iter0_171 = 1, 4 do
		if not _.any(arg1_171, function(arg0_172)
			return arg0_172.row == arg2_171.row + var4_0[iter0_171][1] and arg0_172.column == arg2_171.column + var4_0[iter0_171][2]
		end) then
			var0_171 = bit.bor(var0_171, var1_171)
		end

		var1_171 = var1_171 * 2
	end

	if var0_171 == 0 then
		return
	end

	arg0_171:CreateEdge(var0_171, arg2_171, ...)
end

function var0_0.AddOutlines(arg0_173, arg1_173, arg2_173, arg3_173, arg4_173, arg5_173)
	local var0_173 = {}
	local var1_173 = {}

	for iter0_173, iter1_173 in ipairs(arg1_173) do
		for iter2_173 = 1, 4 do
			if not underscore.any(arg1_173, function(arg0_174)
				return arg0_174.row == iter1_173.row + var4_0[iter2_173][1] and arg0_174.column == iter1_173.column + var4_0[iter2_173][2]
			end) then
				local var2_173 = 2 * iter1_173.row + var4_0[iter2_173][1]
				local var3_173 = 2 * iter1_173.column + var4_0[iter2_173][2]

				assert(not var0_173[var2_173 .. "_" .. var3_173], "Multiple outline")

				var0_173[var2_173 .. "_" .. var3_173] = {
					row = var2_173,
					column = var3_173,
					normal = iter2_173
				}
			end

			if not underscore.any(arg1_173, function(arg0_175)
				return arg0_175.row == iter1_173.row + var5_0[iter2_173][1] and arg0_175.column == iter1_173.column + var5_0[iter2_173][2]
			end) and underscore.any(arg1_173, function(arg0_176)
				return arg0_176.row == iter1_173.row and arg0_176.column == iter1_173.column + var5_0[iter2_173][2]
			end) and underscore.any(arg1_173, function(arg0_177)
				return arg0_177.row == iter1_173.row + var5_0[iter2_173][1] and arg0_177.column == iter1_173.column
			end) then
				var1_173[iter1_173.row .. "_" .. iter1_173.column .. "_" .. iter2_173] = {
					row = iter1_173.row,
					column = iter1_173.column,
					corner = iter2_173
				}
			end
		end
	end

	arg0_173:CreateOutlines(var0_173, arg2_173, arg3_173, arg4_173, arg5_173)
	arg0_173:CreateOutlineCorners(var1_173, arg2_173, arg3_173, arg4_173, arg5_173 .. "_corner")
end

function var0_0.isHuntingRangeVisible(arg0_178)
	return arg0_178.contextData.huntingRangeVisibility % 2 == 0
end

function var0_0.toggleHuntingRange(arg0_179)
	arg0_179:hideQuadMark(ChapterConst.MarkHuntingRange)
	arg0_179:ClearEdges("SubmarineHunting")

	if not arg0_179:isHuntingRangeVisible() then
		arg0_179:ShowHuntingRange()
	end

	arg0_179.contextData.huntingRangeVisibility = 1 - arg0_179.contextData.huntingRangeVisibility

	arg0_179:updateAttachments()
	arg0_179:updateChampions()
end

function var0_0.ShowHuntingRange(arg0_180)
	local var0_180 = arg0_180.contextData.chapterVO
	local var1_180 = var0_180:GetSubmarineFleet()

	if not var1_180 then
		return
	end

	local var2_180 = var1_180:getHuntingRange()
	local var3_180 = _.filter(var2_180, function(arg0_181)
		local var0_181 = var0_180:getChapterCell(arg0_181.row, arg0_181.column)

		return var0_181 and var0_181:IsWalkable()
	end)

	arg0_180:RefreshHuntingRange(var3_180, false)
end

function var0_0.RefreshHuntingRange(arg0_182, arg1_182, arg2_182)
	arg0_182:showQuadMark(arg1_182, ChapterConst.MarkHuntingRange, "cell_hunting_range", Vector2(100, 100), arg0_182.material_Add, arg2_182)
	_.each(arg1_182, function(arg0_183)
		arg0_182:AddCellEdge(arg1_182, arg0_183, not arg2_182, nil, nil, "SubmarineHunting")
	end)
end

function var0_0.ShowStaticHuntingRange(arg0_184)
	arg0_184:hideQuadMark(ChapterConst.MarkHuntingRange)
	arg0_184:ClearEdges("SubmarineHunting")

	local var0_184 = arg0_184.contextData.chapterVO
	local var1_184 = var0_184:GetSubmarineFleet()

	if not arg0_184:isHuntingRangeVisible() then
		arg0_184.contextData.huntingRangeVisibility = arg0_184.contextData.huntingRangeVisibility + 1
	end

	local var2_184 = var1_184:getHuntingRange()
	local var3_184 = _.filter(var2_184, function(arg0_185)
		local var0_185 = var0_184:getChapterCell(arg0_185.row, arg0_185.column)

		return var0_185 and var0_185:IsWalkable()
	end)

	arg0_184:RefreshHuntingRange(var3_184, true)
end

function var0_0.ShowTargetHuntingRange(arg0_186, arg1_186)
	arg0_186:hideQuadMark(ChapterConst.MarkHuntingRange)
	arg0_186:ClearEdges("SubmarineHunting")

	local var0_186 = arg0_186.contextData.chapterVO
	local var1_186 = var0_186:GetSubmarineFleet()
	local var2_186 = var1_186:getHuntingRange(arg1_186)
	local var3_186 = _.filter(var2_186, function(arg0_187)
		local var0_187 = var0_186:getChapterCell(arg0_187.row, arg0_187.column)

		return var0_187 and var0_187:IsWalkable()
	end)
	local var4_186 = var1_186:getHuntingRange()
	local var5_186 = _.filter(var4_186, function(arg0_188)
		local var0_188 = var0_186:getChapterCell(arg0_188.row, arg0_188.column)

		return var0_188 and var0_188:IsWalkable()
	end)
	local var6_186 = {}

	for iter0_186, iter1_186 in pairs(var5_186) do
		if not table.containsData(var3_186, iter1_186) then
			table.insert(var6_186, iter1_186)
		end
	end

	arg0_186:RefreshHuntingRange(var6_186, true)
	arg0_186:RefreshHuntingRange(var3_186, false)
	arg0_186:updateAttachments()
	arg0_186:updateChampions()
end

function var0_0.OnChangeSubAutoAttack(arg0_189)
	local var0_189 = arg0_189.contextData.chapterVO
	local var1_189 = var0_189:GetSubmarineFleet()

	if not var1_189 then
		return
	end

	local var2_189 = arg0_189.cellFleets[var1_189.id]

	if not var2_189 then
		return
	end

	local var3_189 = var0_189.subAutoAttack == 1

	var2_189:SetActiveModel(not var3_189)
	arg0_189:PlaySubAnimation(var2_189, not var3_189, function()
		arg0_189:updateFleet(var1_189.id)
	end)
end

function var0_0.displayEscapeGrid(arg0_191)
	local var0_191 = arg0_191.contextData.chapterVO

	if not var0_191:existOni() then
		return
	end

	local var1_191 = var0_191:getOniChapterInfo()

	arg0_191:hideQuadMark(ChapterConst.MarkEscapeGrid)
	arg0_191:showQuadMark(_.map(var1_191.escape_grids, function(arg0_192)
		return {
			row = arg0_192[1],
			column = arg0_192[2]
		}
	end), ChapterConst.MarkEscapeGrid, "cell_escape_grid", Vector2(105, 105))
end

function var0_0.showQuadMark(arg0_193, arg1_193, arg2_193, arg3_193, arg4_193, arg5_193, arg6_193)
	arg0_193:ShowAnyQuadMark(arg1_193, arg2_193, arg3_193, arg4_193, arg5_193, false, arg6_193)
end

function var0_0.ShowTopQuadMark(arg0_194, arg1_194, arg2_194, arg3_194, arg4_194, arg5_194, arg6_194)
	arg0_194:ShowAnyQuadMark(arg1_194, arg2_194, arg3_194, arg4_194, arg5_194, true, arg6_194)
end

function var0_0.ShowAnyQuadMark(arg0_195, arg1_195, arg2_195, arg3_195, arg4_195, arg5_195, arg6_195, arg7_195)
	local var0_195 = arg0_195.contextData.chapterVO

	for iter0_195, iter1_195 in pairs(arg1_195) do
		local var1_195 = var0_195:getChapterCell(iter1_195.row, iter1_195.column)

		if var1_195 and var1_195:IsWalkable() then
			local var2_195 = ChapterCell.Line2MarkName(iter1_195.row, iter1_195.column, arg2_195)

			arg0_195.markQuads[arg2_195] = arg0_195.markQuads[arg2_195] or {}

			local var3_195 = arg0_195.markQuads[arg2_195][var2_195]

			if not var3_195 then
				PoolMgr.GetInstance():GetPrefab("chapter/cell_quad_mark", "", false, function(arg0_196)
					var3_195 = arg0_196.transform
					arg0_195.markQuads[arg2_195][var2_195] = var3_195
				end)
			else
				arg0_195:cancelMarkTween(var2_195, var3_195, 1)
			end

			var3_195.name = var2_195

			var3_195:SetParent(arg6_195 and arg0_195.topMarkRoot or arg0_195.bottomMarkRoot, false)

			var3_195.sizeDelta = var0_195.theme.cellSize
			var3_195.anchoredPosition = var0_195.theme:GetLinePosition(iter1_195.row, iter1_195.column)
			var3_195.localScale = Vector3.one

			var3_195:SetAsLastSibling()

			local var4_195 = var3_195:GetComponent(typeof(Image))

			var4_195.sprite = GetSpriteFromAtlas("chapter/pic/cellgrid", arg3_195)
			var4_195.material = arg5_195
			var3_195.sizeDelta = arg4_195

			if not arg7_195 then
				arg0_195:startMarkTween(var2_195, var3_195)
			else
				arg0_195:cancelMarkTween(var2_195, var3_195, 1)
			end
		end
	end
end

function var0_0.hideQuadMark(arg0_197, arg1_197)
	if arg1_197 and not arg0_197.markQuads[arg1_197] then
		return
	end

	for iter0_197, iter1_197 in pairs(arg0_197.markQuads) do
		if not arg1_197 or iter0_197 == arg1_197 then
			for iter2_197, iter3_197 in pairs(iter1_197) do
				arg0_197:cancelMarkTween(iter2_197, iter3_197)

				iter1_197[iter2_197]:GetComponent(typeof(Image)).material = nil
				iter1_197[iter2_197] = nil

				PoolMgr.GetInstance():ReturnPrefab("chapter/cell_quad_mark", "", iter3_197.gameObject)
			end

			table.clear(arg0_197.markQuads[iter0_197])
		end
	end
end

function var0_0.CreateEdgeIndex(arg0_198, arg1_198, arg2_198, arg3_198)
	return ChapterCell.Line2Name(arg0_198, arg1_198) .. (arg3_198 and "_" .. arg3_198 or "") .. "_" .. arg2_198
end

function var0_0.CreateEdge(arg0_199, arg1_199, arg2_199, arg3_199, arg4_199, arg5_199, arg6_199)
	if arg1_199 <= 0 or arg1_199 >= 16 then
		return
	end

	local var0_199 = arg0_199:GetEdgePool(arg6_199)
	local var1_199 = arg0_199.contextData.chapterVO
	local var2_199 = var1_199.theme:GetLinePosition(arg2_199.row, arg2_199.column)
	local var3_199 = var1_199.theme.cellSize

	assert(arg6_199, "Missing key, Please PM Programmer")

	local var4_199 = 1
	local var5_199 = 0

	while var5_199 < 4 do
		var5_199 = var5_199 + 1

		if bit.band(arg1_199, var4_199) > 0 then
			local var6_199 = arg0_199.CreateEdgeIndex(arg2_199.row, arg2_199.column, var5_199, arg6_199)

			arg0_199.cellEdges[arg6_199] = arg0_199.cellEdges[arg6_199] or {}
			arg0_199.cellEdges[arg6_199][var6_199] = arg0_199.cellEdges[arg6_199][var6_199] or tf(var0_199:Dequeue())

			local var7_199 = arg0_199.cellEdges[arg6_199][var6_199]

			var7_199.name = var6_199

			var7_199:SetParent(arg0_199.bottomMarkRoot, false)

			arg4_199 = arg4_199 or 0
			arg5_199 = arg5_199 or 3

			local var8_199 = bit.band(var5_199, 1) == 1 and var3_199.x - arg4_199 * 2 or var3_199.y - arg4_199 * 2
			local var9_199 = arg5_199

			var7_199.sizeDelta = Vector2.New(var8_199, var9_199)
			var7_199.pivot = Vector2.New(0.5, 0)

			local var10_199 = math.pi * 0.5 * -var5_199
			local var11_199 = math.cos(var10_199) * (var3_199.x * 0.5 - arg4_199)
			local var12_199 = math.sin(var10_199) * (var3_199.y * 0.5 - arg4_199)

			var7_199.anchoredPosition = Vector2.New(var11_199 + var2_199.x, var12_199 + var2_199.y)
			var7_199.localRotation = Quaternion.Euler(0, 0, (5 - var5_199) * 90)

			if arg3_199 then
				arg0_199:startMarkTween(var6_199, var7_199)
			else
				arg0_199:cancelMarkTween(var6_199, var7_199, 1)
			end
		end

		var4_199 = var4_199 * 2
	end
end

function var0_0.ClearEdge(arg0_200, arg1_200)
	for iter0_200, iter1_200 in pairs(arg0_200.cellEdges) do
		for iter2_200 = 1, 4 do
			local var0_200 = arg0_200.CreateEdgeIndex(arg1_200.row, arg1_200.column, iter2_200, iter0_200)

			if iter1_200[var0_200] then
				local var1_200 = arg0_200:GetEdgePool(iter0_200)
				local var2_200 = tf(iter1_200[var0_200])

				arg0_200:cancelMarkTween(var0_200, var2_200)
				var1_200:Enqueue(var2_200, false)

				iter1_200[var0_200] = nil
			end
		end
	end
end

function var0_0.ClearEdges(arg0_201, arg1_201)
	if not next(arg0_201.cellEdges) then
		return
	end

	for iter0_201, iter1_201 in pairs(arg0_201.cellEdges) do
		if not arg1_201 or arg1_201 == iter0_201 then
			local var0_201 = arg0_201:GetEdgePool(iter0_201)

			for iter2_201, iter3_201 in pairs(iter1_201) do
				arg0_201:cancelMarkTween(iter2_201, iter3_201)
				var0_201:Enqueue(go(iter3_201), false)
			end

			arg0_201.cellEdges[iter0_201] = nil
		end
	end
end

function var0_0.CreateOutlines(arg0_202, arg1_202, arg2_202, arg3_202, arg4_202, arg5_202)
	local var0_202 = arg0_202.contextData.chapterVO
	local var1_202 = var0_202.theme.cellSize + var0_202.theme.cellSpace

	for iter0_202, iter1_202 in pairs(arg1_202) do
		local var2_202 = arg0_202:GetEdgePool(arg5_202)
		local var3_202 = var0_202.theme:GetLinePosition(iter1_202.row / 2, iter1_202.column / 2)

		assert(arg5_202, "Missing key, Please PM Programmer")

		local var4_202 = arg0_202.CreateEdgeIndex(iter1_202.row, iter1_202.column, 0, arg5_202)

		arg0_202.cellEdges[arg5_202] = arg0_202.cellEdges[arg5_202] or {}
		arg0_202.cellEdges[arg5_202][var4_202] = arg0_202.cellEdges[arg5_202][var4_202] or tf(var2_202:Dequeue())

		local var5_202 = arg0_202.cellEdges[arg5_202][var4_202]

		var5_202.name = var4_202

		var5_202:SetParent(arg0_202.bottomMarkRoot, false)

		arg3_202 = arg3_202 or 0
		arg4_202 = arg4_202 or 3

		local var6_202 = var4_0[iter1_202.normal][1] ~= 0 and var1_202.x or var1_202.y
		local var7_202 = arg4_202
		local var8_202 = var6_202 * 0.5
		local var9_202 = iter1_202.normal % 4 + 1
		local var10_202 = (iter1_202.normal + 2) % 4 + 1
		local var11_202 = {
			iter1_202.row + var4_0[var9_202][1],
			iter1_202.column + var4_0[var9_202][2]
		}
		local var12_202 = arg1_202[var11_202[1] + var4_0[iter1_202.normal][1] .. "_" .. var11_202[2] + var4_0[iter1_202.normal][2]] or arg1_202[var11_202[1] - var4_0[iter1_202.normal][1] .. "_" .. var11_202[2] - var4_0[iter1_202.normal][2]]
		local var13_202 = {
			iter1_202.row + var4_0[var10_202][1],
			iter1_202.column + var4_0[var10_202][2]
		}
		local var14_202 = arg1_202[var13_202[1] + var4_0[iter1_202.normal][1] .. "_" .. var13_202[2] + var4_0[iter1_202.normal][2]] or arg1_202[var13_202[1] - var4_0[iter1_202.normal][1] .. "_" .. var13_202[2] - var4_0[iter1_202.normal][2]]

		if var12_202 then
			local var15_202 = iter1_202.row + var4_0[iter1_202.normal][1] == var12_202.row + var4_0[var12_202.normal][1] or iter1_202.column + var4_0[iter1_202.normal][2] == var12_202.column + var4_0[var12_202.normal][2]

			var6_202 = var15_202 and var6_202 + arg3_202 or var6_202 - arg3_202
			var8_202 = var15_202 and var8_202 + arg3_202 or var8_202 - arg3_202
		end

		if var14_202 then
			var6_202 = (iter1_202.row + var4_0[iter1_202.normal][1] == var14_202.row + var4_0[var14_202.normal][1] or iter1_202.column + var4_0[iter1_202.normal][2] == var14_202.column + var4_0[var14_202.normal][2]) and var6_202 + arg3_202 or var6_202 - arg3_202
		end

		var5_202.sizeDelta = Vector2.New(var6_202, var7_202)
		var5_202.pivot = Vector2.New(var8_202 / var6_202, 0)

		local var16_202 = var4_0[iter1_202.normal][2] * -arg3_202
		local var17_202 = var4_0[iter1_202.normal][1] * arg3_202

		var5_202.anchoredPosition = Vector2.New(var16_202 + var3_202.x, var17_202 + var3_202.y)
		var5_202.localRotation = Quaternion.Euler(0, 0, (5 - iter1_202.normal) * 90)

		if arg2_202 then
			arg0_202:startMarkTween(var4_202, var5_202)
		else
			arg0_202:cancelMarkTween(var4_202, var5_202, 1)
		end
	end
end

function var0_0.CreateOutlineCorners(arg0_203, arg1_203, arg2_203, arg3_203, arg4_203, arg5_203)
	local var0_203 = arg0_203.contextData.chapterVO

	for iter0_203, iter1_203 in pairs(arg1_203) do
		local var1_203 = arg0_203:GetEdgePool(arg5_203)
		local var2_203 = var0_203.theme:GetLinePosition(iter1_203.row + var5_0[iter1_203.corner][1] * 0.5, iter1_203.column + var5_0[iter1_203.corner][2] * 0.5)

		assert(arg5_203, "Missing key, Please PM Programmer")

		local var3_203 = arg0_203.CreateEdgeIndex(iter1_203.row, iter1_203.column, iter1_203.corner, arg5_203)

		arg0_203.cellEdges[arg5_203] = arg0_203.cellEdges[arg5_203] or {}
		arg0_203.cellEdges[arg5_203][var3_203] = arg0_203.cellEdges[arg5_203][var3_203] or tf(var1_203:Dequeue())

		local var4_203 = arg0_203.cellEdges[arg5_203][var3_203]

		var4_203.name = var3_203

		var4_203:SetParent(arg0_203.bottomMarkRoot, false)

		arg3_203 = arg3_203 or 0
		arg4_203 = arg4_203 or 3

		local var5_203 = arg4_203
		local var6_203 = arg4_203

		var4_203.sizeDelta = Vector2.New(var5_203, var6_203)
		var4_203.pivot = Vector2.New(1, 0)

		local var7_203 = var5_0[iter1_203.corner][2] * -arg3_203
		local var8_203 = var5_0[iter1_203.corner][1] * arg3_203

		var4_203.anchoredPosition = Vector2.New(var7_203 + var2_203.x, var8_203 + var2_203.y)
		var4_203.localRotation = Quaternion.Euler(0, 0, (5 - iter1_203.corner) * 90)

		if arg2_203 then
			arg0_203:startMarkTween(var3_203, var4_203)
		else
			arg0_203:cancelMarkTween(var3_203, var4_203, 1)
		end
	end
end

function var0_0.updateCoastalGunAttachArea(arg0_204)
	local var0_204 = arg0_204.contextData.chapterVO:getCoastalGunArea()

	arg0_204:hideQuadMark(ChapterConst.MarkCoastalGun)
	arg0_204:showQuadMark(var0_204, ChapterConst.MarkCoastalGun, "cell_coastal_gun", Vector2(110, 110), nil, false)
end

function var0_0.InitIdolsAnim(arg0_205)
	local var0_205 = arg0_205.contextData.chapterVO
	local var1_205 = pg.chapter_pop_template[var0_205.id]

	if not var1_205 then
		return
	end

	local var2_205 = var1_205.sd_location

	for iter0_205, iter1_205 in ipairs(var2_205) do
		arg0_205.idols = arg0_205.idols or {}

		local var3_205 = ChapterCell.Line2Name(iter1_205[1][1], iter1_205[1][2])
		local var4_205 = arg0_205.cellRoot:Find(var3_205 .. "/" .. ChapterConst.ChildAttachment)

		assert(var4_205, "cant find attachment")

		local var5_205 = AttachmentSpineAnimationCell.New(var4_205)

		var5_205:SetLine({
			row = iter1_205[1][1],
			column = iter1_205[1][2]
		})
		table.insert(arg0_205.idols, var5_205)
		var5_205:Set(iter1_205[2])
		var5_205:SetRoutine(var1_205.sd_act[iter0_205])
	end
end

function var0_0.ClearIdolsAnim(arg0_206)
	if arg0_206.idols then
		for iter0_206, iter1_206 in ipairs(arg0_206.idols) do
			iter1_206:Clear()
		end

		table.clear(arg0_206.idols)

		arg0_206.idols = nil
	end
end

function var0_0.GetEnemyCellView(arg0_207, arg1_207)
	local var0_207 = _.detect(arg0_207.cellChampions, function(arg0_208)
		local var0_208 = arg0_208:GetLine()

		return var0_208.row == arg1_207.row and var0_208.column == arg1_207.column
	end)

	if not var0_207 then
		local var1_207 = ChapterCell.Line2Name(arg1_207.row, arg1_207.column)

		var0_207 = arg0_207.attachmentCells[var1_207]
	end

	return var0_207
end

function var0_0.TransformLine2PlanePos(arg0_209, arg1_209)
	local var0_209 = string.char(string.byte("A") + arg1_209.column - arg0_209.indexMin.y)
	local var1_209 = string.char(string.byte("1") + arg1_209.row - arg0_209.indexMin.x)

	return var0_209 .. var1_209
end

function var0_0.AlignListContainer(arg0_210, arg1_210)
	local var0_210 = arg0_210.childCount

	for iter0_210 = arg1_210, var0_210 - 1 do
		local var1_210 = arg0_210:GetChild(iter0_210)

		setActive(var1_210, false)
	end

	for iter1_210 = var0_210, arg1_210 - 1 do
		cloneTplTo(arg0_210:GetChild(0), arg0_210)
	end

	for iter2_210 = 0, arg1_210 - 1 do
		local var2_210 = arg0_210:GetChild(iter2_210)

		setActive(var2_210, true)
	end
end

function var0_0.frozen(arg0_211)
	arg0_211.forzenCount = (arg0_211.forzenCount or 0) + 1

	arg0_211.parent:frozen()
end

function var0_0.unfrozen(arg0_212)
	if arg0_212.exited then
		return
	end

	arg0_212.forzenCount = (arg0_212.forzenCount or 0) - 1

	arg0_212.parent:unfrozen()
end

function var0_0.isfrozen(arg0_213)
	return arg0_213.parent.frozenCount > 0
end

function var0_0.clear(arg0_214)
	arg0_214:clearAll()

	if (arg0_214.forzenCount or 0) > 0 then
		arg0_214.parent:unfrozen(arg0_214.forzenCount)
	end
end

return var0_0
