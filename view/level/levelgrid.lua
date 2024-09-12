local var0_0 = class("LevelGrid", import("..base.BasePanel"))
local var1_0 = require("Mgr/Pool/PoolPlural")

var0_0.MapDefaultPos = Vector3(420, -1000, -1000)

function var0_0.init(arg0_1)
	var0_0.super.init(arg0_1)

	arg0_1.levelCam = GameObject.Find("LevelCamera"):GetComponent(typeof(Camera))
	GameObject.Find("LevelCamera/Canvas"):GetComponent(typeof(Canvas)).sortingOrder = ChapterConst.PriorityMin
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
			arg0_11:UpdateFloor()
			arg0_11:updateAttachments()
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
	local var0_26 = arg0_26:findTF("plane/display/mask")
	local var1_26 = GetOrAddComponent(var0_26, "RawImage")

	if not var1_26.enabled then
		return
	end

	var1_26.texture = arg0_26:getPoisonTex()
end

function var0_0.getPoisonTex(arg0_27)
	local var0_27 = arg0_27.contextData.chapterVO
	local var1_27 = arg0_27:findTF("plane/display")
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

		local var4_75 = var0_75:getExtraFlags()[1]

		if var4_75 == ChapterConst.StatusDay then
			arg0_75:showQuadMark(var2_75[ChapterConst.FlagNightmare], ChapterConst.MarkHideNight, "cell_hidden_nightmare", Vector2(110, 110), nil, true)
		elseif var4_75 == ChapterConst.StatusNight then
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

	arg0_75:UpdateWeatherCells()

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

function var0_0.UpdateWeatherCells(arg0_83)
	local var0_83 = arg0_83.contextData.chapterVO

	for iter0_83, iter1_83 in pairs(var0_83.cells) do
		local var1_83
		local var2_83 = iter1_83:GetWeatherFlagList()

		if #var2_83 > 0 then
			var1_83 = MapWeatherCellView
		end

		local var3_83 = arg0_83.weatherCells[iter0_83]

		if var3_83 and var3_83.class ~= var1_83 then
			var3_83:Clear()

			var3_83 = nil
			arg0_83.weatherCells[iter0_83] = nil
		end

		if var1_83 then
			if not var3_83 then
				local var4_83 = arg0_83.cellRoot:Find(iter0_83):Find(ChapterConst.ChildAttachment)

				var3_83 = var1_83.New(var4_83)

				var3_83:SetLine({
					row = iter1_83.row,
					column = iter1_83.column
				})

				arg0_83.weatherCells[iter0_83] = var3_83
			end

			var3_83.info = iter1_83

			var3_83:Update(var2_83)
		end
	end
end

function var0_0.updateQuadCells(arg0_84, arg1_84)
	arg1_84 = arg1_84 or ChapterConst.QuadStateNormal
	arg0_84.quadState = arg1_84

	arg0_84:updateQuadBase()

	if arg1_84 == ChapterConst.QuadStateNormal then
		arg0_84:UpdateQuadStateNormal()
	elseif arg1_84 == ChapterConst.QuadStateBarrierSetting then
		arg0_84:UpdateQuadStateBarrierSetting()
	elseif arg1_84 == ChapterConst.QuadStateTeleportSub then
		arg0_84:UpdateQuadStateTeleportSub()
	elseif arg1_84 == ChapterConst.QuadStateMissileStrike or arg1_84 == ChapterConst.QuadStateAirSuport then
		arg0_84:UpdateQuadStateMissileStrike()
	elseif arg1_84 == ChapterConst.QuadStateExpel then
		arg0_84:UpdateQuadStateAirExpel()
	end

	arg0_84:UpdateOpBtns()
end

function var0_0.PlayQuadsParallelAnim(arg0_85, arg1_85)
	arg0_85:frozen()
	table.ParallelIpairsAsync(arg1_85, function(arg0_86, arg1_86, arg2_86)
		local var0_86 = ChapterCell.Line2QuadName(arg1_86.row, arg1_86.column)
		local var1_86 = arg0_85.quadRoot:Find(var0_86)

		arg0_85:cancelQuadTween(var0_86, var1_86)
		setImageAlpha(var1_86, 0.4)

		local var2_86 = LeanTween.scale(var1_86, Vector3.one, 0.2):setFrom(Vector3.zero):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(arg2_86))

		arg0_85.presentTws[var0_86] = {
			uniqueId = var2_86.uniqueId
		}
	end, function()
		arg0_85:unfrozen()
	end)
end

function var0_0.updateQuadBase(arg0_88)
	local var0_88 = arg0_88.contextData.chapterVO

	if var0_88.fleet == nil then
		return
	end

	arg0_88:killPresentTws()

	local function var1_88(arg0_89)
		if not arg0_89 or not arg0_89:IsWalkable() then
			return
		end

		local var0_89 = arg0_89.row
		local var1_89 = arg0_89.column
		local var2_89 = ChapterCell.Line2QuadName(var0_89, var1_89)
		local var3_89 = arg0_88.quadRoot:Find(var2_89)

		var3_89.localScale = Vector3.one

		local var4_89 = var3_89:Find("grid"):GetComponent(typeof(Image))
		local var5_89 = var0_88:getChampion(var0_89, var1_89)

		if var5_89 and var5_89.flag == ChapterConst.CellFlagActive and var5_89.trait ~= ChapterConst.TraitLurk and var0_88:getChampionVisibility(var5_89) and not var0_88:existFleet(FleetType.Transport, var0_89, var1_89) then
			arg0_88:startQuadTween(var2_89, var3_89)
			setImageSprite(var3_89, GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_enemy"))
			setImageSprite(var3_89:Find("grid"), GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_enemy_grid"))

			var4_89.material = arg0_88.material_Add

			return
		end

		local var6_89 = var0_88:GetRawChapterAttachemnt(var0_89, var1_89)

		if var6_89 then
			local var7_89 = var0_88:getQuadCellPic(var6_89)

			if var7_89 then
				arg0_88:startQuadTween(var2_89, var3_89)
				setImageSprite(var3_89, GetSpriteFromAtlas("chapter/pic/cellgrid", var7_89))

				return
			end
		end

		if var0_88:getChapterCell(var0_89, var1_89) then
			local var8_89 = var0_88:getQuadCellPic(arg0_89)

			if var8_89 then
				arg0_88:startQuadTween(var2_89, var3_89)

				if var8_89 == "cell_enemy" then
					setImageSprite(var3_89:Find("grid"), GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_enemy_grid"))

					var4_89.material = arg0_88.material_Add
				else
					setImageSprite(var3_89:Find("grid"), GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid"))

					var4_89.material = nil
				end

				setImageSprite(var3_89, GetSpriteFromAtlas("chapter/pic/cellgrid", var8_89))

				return
			end
		end

		arg0_88:cancelQuadTween(var2_89, var3_89)
		setImageAlpha(var3_89, ChapterConst.CellEaseOutAlpha)
		setImageSprite(var3_89, GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_normal"))
		setImageSprite(var3_89:Find("grid"), GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid"))

		var4_89.material = nil
	end

	for iter0_88, iter1_88 in pairs(var0_88.cells) do
		var1_88(iter1_88)
	end

	if var0_88:isPlayingWithBombEnemy() then
		arg0_88:hideQuadMark(ChapterConst.MarkBomb)
	end
end

function var0_0.UpdateQuadStateNormal(arg0_90)
	local var0_90 = arg0_90.contextData.chapterVO
	local var1_90 = var0_90.fleet
	local var2_90

	if var0_90:existMoveLimit() and not var0_90:checkAnyInteractive() then
		var2_90 = var0_90:calcWalkableCells(ChapterConst.SubjectPlayer, var1_90.line.row, var1_90.line.column, var1_90:getSpeed())
	end

	if not var2_90 or #var2_90 == 0 then
		return
	end

	local var3_90 = _.min(var2_90, function(arg0_91)
		return ManhattonDist(arg0_91, var1_90.line)
	end)
	local var4_90 = ManhattonDist(var3_90, var1_90.line)

	_.each(var2_90, function(arg0_92)
		local var0_92 = ChapterCell.Line2QuadName(arg0_92.row, arg0_92.column)
		local var1_92 = arg0_90.quadRoot:Find(var0_92)

		arg0_90:cancelQuadTween(var0_92, var1_92)
		setImageSprite(var1_92, GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_normal"))

		local var2_92 = var1_92:Find("grid"):GetComponent(typeof(Image))

		var2_92.sprite = GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid")
		var2_92.material = nil

		local var3_92 = var0_90:getRound() == ChapterConst.RoundPlayer

		setImageAlpha(var1_92, var3_92 and 1 or ChapterConst.CellEaseOutAlpha)

		var1_92.localScale = Vector3.zero

		local var4_92 = LeanTween.scale(var1_92, Vector3.one, 0.2):setFrom(Vector3.zero):setEase(LeanTweenType.easeInOutSine):setDelay((ManhattonDist(arg0_92, var1_90.line) - var4_90) * 0.1)

		arg0_90.presentTws[var0_92] = {
			uniqueId = var4_92.uniqueId
		}
	end)
end

function var0_0.UpdateQuadStateBarrierSetting(arg0_93)
	local var0_93 = 1
	local var1_93 = arg0_93.contextData.chapterVO
	local var2_93 = var1_93.fleet
	local var3_93 = var2_93.line
	local var4_93 = var1_93:calcSquareBarrierCells(var3_93.row, var3_93.column, var0_93)

	if not var4_93 or #var4_93 == 0 then
		return
	end

	local var5_93 = _.min(var4_93, function(arg0_94)
		return ManhattonDist(arg0_94, var2_93.line)
	end)
	local var6_93 = ManhattonDist(var5_93, var2_93.line)

	_.each(var4_93, function(arg0_95)
		local var0_95 = ChapterCell.Line2QuadName(arg0_95.row, arg0_95.column)
		local var1_95 = arg0_93.quadRoot:Find(var0_95)

		arg0_93:cancelQuadTween(var0_95, var1_95)
		setImageSprite(var1_95, GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_barrier_select"))

		local var2_95 = var1_95:Find("grid"):GetComponent(typeof(Image))

		var2_95.sprite = GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid")
		var2_95.material = nil

		setImageAlpha(var1_95, 1)

		var1_95.localScale = Vector3.zero

		local var3_95 = LeanTween.scale(var1_95, Vector3.one, 0.2):setFrom(Vector3.zero):setEase(LeanTweenType.easeInOutSine):setDelay((ManhattonDist(arg0_95, var2_93.line) - var6_93) * 0.1)

		arg0_93.presentTws[var0_95] = {
			uniqueId = var3_95.uniqueId
		}
	end)
end

function var0_0.UpdateQuadStateTeleportSub(arg0_96)
	local var0_96 = arg0_96.contextData.chapterVO
	local var1_96 = _.detect(var0_96.fleets, function(arg0_97)
		return arg0_97:getFleetType() == FleetType.Submarine
	end)

	if not var1_96 then
		return
	end

	local var2_96 = var0_96:calcWalkableCells(nil, var1_96.line.row, var1_96.line.column, ChapterConst.MaxStep)
	local var3_96 = _.filter(var2_96, function(arg0_98)
		return not var0_96:getQuadCellPic(var0_96:getChapterCell(arg0_98.row, arg0_98.column))
	end)

	arg0_96:PlayQuadsParallelAnim(var3_96)
end

function var0_0.UpdateQuadStateMissileStrike(arg0_99)
	local var0_99 = arg0_99.contextData.chapterVO
	local var1_99 = _.filter(_.values(var0_99.cells), function(arg0_100)
		return arg0_100:IsWalkable() and not var0_99:getQuadCellPic(arg0_100)
	end)

	arg0_99:PlayQuadsParallelAnim(var1_99)
end

function var0_0.UpdateQuadStateAirExpel(arg0_101)
	local var0_101 = arg0_101.contextData.chapterVO
	local var1_101 = arg0_101.airSupportTarget

	if not var1_101 or not var1_101.source then
		local var2_101 = _.filter(_.values(var0_101.cells), function(arg0_102)
			return arg0_102:IsWalkable() and not var0_101:getQuadCellPic(arg0_102)
		end)

		arg0_101:PlayQuadsParallelAnim(var2_101)

		return
	end

	local var3_101 = var1_101.source
	local var4_101 = var0_101:calcWalkableCells(ChapterConst.SubjectChampion, var3_101.row, var3_101.column, 1)

	arg0_101:PlayQuadsParallelAnim(var4_101)
end

function var0_0.ClickGridCell(arg0_103, arg1_103)
	if arg0_103.quadState == ChapterConst.QuadStateBarrierSetting then
		arg0_103:OnBarrierSetting(arg1_103)
	elseif arg0_103.quadState == ChapterConst.QuadStateTeleportSub then
		arg0_103:OnTeleportConfirm(arg1_103)
	elseif arg0_103.quadState == ChapterConst.QuadStateMissileStrike then
		arg0_103:OnMissileAiming(arg1_103)
	elseif arg0_103.quadState == ChapterConst.QuadStateAirSuport then
		arg0_103:OnAirSupportAiming(arg1_103)
	elseif arg0_103.quadState == ChapterConst.QuadStateExpel then
		arg0_103:OnAirExpelSelect(arg1_103)
	else
		arg0_103:emit(LevelUIConst.ON_CLICK_GRID_QUAD, arg1_103)
	end
end

function var0_0.OnBarrierSetting(arg0_104, arg1_104)
	local var0_104 = 1
	local var1_104 = arg0_104.contextData.chapterVO
	local var2_104 = var1_104.fleet.line
	local var3_104 = var1_104:calcSquareBarrierCells(var2_104.row, var2_104.column, var0_104)

	if not _.any(var3_104, function(arg0_105)
		return arg0_105.row == arg1_104.row and arg0_105.column == arg1_104.column
	end) then
		return
	end

	;(function(arg0_106, arg1_106)
		newChapterVO = arg0_104.contextData.chapterVO

		if not newChapterVO:existBarrier(arg0_106, arg1_106) and newChapterVO.modelCount <= 0 then
			return
		end

		arg0_104:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpBarrier,
			id = newChapterVO.fleet.id,
			arg1 = arg0_106,
			arg2 = arg1_106
		})
	end)(arg1_104.row, arg1_104.column)
end

function var0_0.PrepareSubTeleport(arg0_107)
	local var0_107 = arg0_107.contextData.chapterVO
	local var1_107 = var0_107:GetSubmarineFleet()
	local var2_107 = arg0_107.cellFleets[var1_107.id]
	local var3_107 = var1_107.startPos

	for iter0_107, iter1_107 in pairs(var0_107.fleets) do
		if iter1_107:getFleetType() == FleetType.Normal then
			arg0_107:updateFleet(iter1_107.id)
		end
	end

	local var4_107 = var0_107:existEnemy(ChapterConst.SubjectPlayer, var3_107.row, var3_107.column) or var0_107:existFleet(FleetType.Normal, var3_107.row, var3_107.column)

	setActive(var2_107.tfAmmo, not var4_107)
	var2_107:SetActiveModel(true)

	if not (var0_107.subAutoAttack == 1) then
		arg0_107:PlaySubAnimation(var2_107, false, function()
			var2_107:SetActiveModel(not var4_107)
		end)
	else
		var2_107:SetActiveModel(not var4_107)
	end

	var2_107.tf.localPosition = var0_107.theme:GetLinePosition(var3_107.row, var3_107.column)

	var2_107:ResetCanvasOrder()
end

function var0_0.TurnOffSubTeleport(arg0_109)
	arg0_109.subTeleportTargetLine = nil

	local var0_109 = arg0_109.contextData.chapterVO

	arg0_109:hideQuadMark(ChapterConst.MarkMovePathArrow)
	arg0_109:hideQuadMark(ChapterConst.MarkHuntingRange)
	arg0_109:ClearEdges("SubmarineHunting")
	arg0_109:UpdateDestinationMark()

	local var1_109 = var0_109:GetSubmarineFleet()
	local var2_109 = arg0_109.cellFleets[var1_109.id]
	local var3_109 = var0_109.subAutoAttack == 1

	var2_109:SetActiveModel(var3_109)

	if not var3_109 then
		arg0_109:PlaySubAnimation(var2_109, true, function()
			arg0_109:updateFleet(var1_109.id)
		end)
	else
		arg0_109:updateFleet(var1_109.id)
	end

	arg0_109:ShowHuntingRange()
end

function var0_0.OnTeleportConfirm(arg0_111, arg1_111)
	local var0_111 = arg0_111.contextData.chapterVO
	local var1_111 = var0_111:getChapterCell(arg1_111.row, arg1_111.column)

	if var1_111 and var1_111:IsWalkable() and not var0_111:existBarrier(arg1_111.row, arg1_111.column) then
		local var2_111 = var0_111:GetSubmarineFleet()

		if var2_111.startPos.row == arg1_111.row and var2_111.startPos.column == arg1_111.column then
			return
		end

		local var3_111, var4_111 = var0_111:findPath(nil, var2_111.startPos, arg1_111)

		if var3_111 >= PathFinding.PrioObstacle or arg1_111.row ~= var4_111[#var4_111].row or arg1_111.column ~= var4_111[#var4_111].column then
			return
		end

		arg0_111:ShowTargetHuntingRange(arg1_111)
		arg0_111:UpdateDestinationMark(arg1_111)

		if var3_111 > 0 then
			arg0_111:ShowPathInArrows(var4_111)

			arg0_111.subTeleportTargetLine = arg1_111
		end
	end
end

function var0_0.ShowPathInArrows(arg0_112, arg1_112)
	local var0_112 = arg0_112.contextData.chapterVO
	local var1_112 = Clone(arg1_112)

	table.remove(var1_112, #var1_112)

	for iter0_112 = #var1_112, 1, -1 do
		local var2_112 = var1_112[iter0_112]

		if var0_112:existEnemy(ChapterConst.SubjectPlayer, var2_112.row, var2_112.column) or var0_112:getFleet(FleetType.Normal, var2_112.row, var2_112.column) then
			table.remove(var1_112, iter0_112)
		end
	end

	arg0_112:hideQuadMark(ChapterConst.MarkMovePathArrow)
	arg0_112:showQuadMark(var1_112, ChapterConst.MarkMovePathArrow, "cell_path_arrow", Vector2(100, 100), nil, true)

	local var3_112 = arg0_112.markQuads[ChapterConst.MarkMovePathArrow]

	for iter1_112 = #arg1_112, 1, -1 do
		local var4_112 = arg1_112[iter1_112]
		local var5_112 = ChapterCell.Line2MarkName(var4_112.row, var4_112.column, ChapterConst.MarkMovePathArrow)
		local var6_112 = var3_112 and var3_112[var5_112]

		if var6_112 then
			local var7_112 = arg1_112[iter1_112 + 1]
			local var8_112 = Vector3.Normalize(Vector3(var7_112.column - var4_112.column, var4_112.row - var7_112.row, 0))
			local var9_112 = Vector3.Dot(var8_112, Vector3.up)
			local var10_112 = Mathf.Acos(var9_112) * Mathf.Rad2Deg
			local var11_112 = Vector3.Cross(Vector3.up, var8_112).z > 0 and 1 or -1

			var6_112.localEulerAngles = Vector3(0, 0, var10_112 * var11_112)
		end
	end
end

function var0_0.ShowMissileAimingMarks(arg0_113, arg1_113)
	_.each(arg1_113, function(arg0_114)
		arg0_113.loader:GetPrefabBYGroup("ui/miaozhun02", "miaozhun02", function(arg0_115)
			setParent(arg0_115, arg0_113.restrictMap)

			local var0_115 = arg0_113.contextData.chapterVO.theme:GetLinePosition(arg0_114.row, arg0_114.column)
			local var1_115 = arg0_113.restrictMap.anchoredPosition

			tf(arg0_115).anchoredPosition = Vector2(var0_115.x - var1_115.x, var0_115.y - var1_115.y)
		end, "MissileAimingMarks")
	end)
end

function var0_0.HideMissileAimingMarks(arg0_116)
	arg0_116.loader:ReturnGroup("MissileAimingMarks")
end

function var0_0.ShowMissileAimingMark(arg0_117, arg1_117)
	arg0_117.loader:GetPrefab("ui/miaozhun02", "miaozhun02", function(arg0_118)
		setParent(arg0_118, arg0_117.restrictMap)

		local var0_118 = arg0_117.contextData.chapterVO.theme:GetLinePosition(arg1_117.row, arg1_117.column)
		local var1_118 = arg0_117.restrictMap.anchoredPosition

		tf(arg0_118).anchoredPosition = Vector2(var0_118.x - var1_118.x, var0_118.y - var1_118.y)
	end, "MissileAimingMark")
end

function var0_0.HideMissileAimingMark(arg0_119)
	arg0_119.loader:ClearRequest("MissileAimingMark")
end

function var0_0.OnMissileAiming(arg0_120, arg1_120)
	arg0_120:HideMissileAimingMark()
	arg0_120:ShowMissileAimingMark(arg1_120)

	arg0_120.missileStrikeTargetLine = arg1_120
end

function var0_0.ShowAirSupportAimingMark(arg0_121, arg1_121)
	arg0_121.loader:GetPrefab("ui/miaozhun03", "miaozhun03", function(arg0_122)
		setParent(arg0_122, arg0_121.restrictMap)

		local var0_122 = arg0_121.contextData.chapterVO.theme:GetLinePosition(arg1_121.row - 0.5, arg1_121.column)
		local var1_122 = arg0_121.restrictMap.anchoredPosition

		tf(arg0_122).anchoredPosition = Vector2(var0_122.x - var1_122.x, var0_122.y - var1_122.y)
	end, "AirSupportAimingMark")
end

function var0_0.HideAirSupportAimingMark(arg0_123)
	arg0_123.loader:ClearRequest("AirSupportAimingMark")
end

function var0_0.OnAirSupportAiming(arg0_124, arg1_124)
	arg0_124:HideAirSupportAimingMark()
	arg0_124:ShowAirSupportAimingMark(arg1_124)

	arg0_124.missileStrikeTargetLine = arg1_124
end

function var0_0.ShowAirExpelAimingMark(arg0_125)
	local var0_125 = arg0_125.airSupportTarget

	if not var0_125 or not var0_125.source then
		return
	end

	local var1_125 = var0_125.source
	local var2_125 = ChapterCell.Line2Name(var1_125.row, var1_125.column)
	local var3_125 = arg0_125.cellRoot:Find(var2_125)

	local function var4_125(arg0_126, arg1_126)
		setParent(arg0_126, var3_125)

		GetOrAddComponent(arg0_126, typeof(Canvas)).overrideSorting = true

		if not arg1_126 then
			return
		end

		local var0_126 = arg0_125.contextData.chapterVO

		tf(arg0_126).localEulerAngles = Vector3(-var0_126.theme.angle, 0, 0)
	end

	arg0_125.loader:GetPrefabBYGroup("leveluiview/tpl_airsupportmark", "tpl_airsupportmark", function(arg0_127)
		var4_125(arg0_127, true)
	end, "AirExpelAimingMark")
	arg0_125.loader:GetPrefabBYGroup("leveluiview/tpl_airsupportdirection", "tpl_airsupportdirection", function(arg0_128)
		var4_125(arg0_128)

		local var0_128 = arg0_125.contextData.chapterVO
		local var1_128 = {
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

		for iter0_128 = 1, 4 do
			local var2_128 = tf(arg0_128):Find(iter0_128)
			local var3_128 = var0_125 and var0_128:considerAsStayPoint(ChapterConst.SubjectChampion, var1_125.row + var1_128[iter0_128][1], var1_125.column + var1_128[iter0_128][2])

			setActive(var2_128, var3_128)
		end
	end, "AirExpelAimingMark")
end

function var0_0.HideAirExpelAimingMark(arg0_129)
	arg0_129.loader:ReturnGroup("AirExpelAimingMark")
end

function var0_0.OnAirExpelSelect(arg0_130, arg1_130)
	local var0_130 = arg0_130.contextData.chapterVO

	local function var1_130()
		arg0_130:HideAirExpelAimingMark()
		arg0_130:ShowAirExpelAimingMark()
		arg0_130:updateQuadBase()
		arg0_130:UpdateQuadStateAirExpel()
	end

	arg0_130.airSupportTarget = arg0_130.airSupportTarget or {}

	local var2_130 = arg0_130.airSupportTarget
	local var3_130 = var0_130:GetEnemy(arg1_130.row, arg1_130.column)

	if var3_130 then
		if ChapterConst.IsBossCell(var3_130) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_select_boss"))

			return
		end

		if var0_130:existFleet(FleetType.Normal, arg1_130.row, arg1_130.column) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_select_battle"))

			return
		end

		if var2_130.source and table.equal(var2_130.source:GetLine(), var3_130:GetLine()) then
			var3_130 = nil
		end

		var2_130.source = var3_130

		var1_130()
	elseif not var2_130.source then
		pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_select_enemy"))
	elseif ManhattonDist(var2_130.source, arg1_130) > 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_outrange"))
	elseif not var0_130:considerAsStayPoint(ChapterConst.SubjectChampion, arg1_130.row, arg1_130.column) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_outrange"))
	else
		local var4_130 = arg0_130.airSupportTarget.source
		local var5_130 = arg1_130

		if not var4_130 or not var5_130 then
			return
		end

		local var6_130 = {
			arg1_130.row - var4_130.row,
			arg1_130.column - var4_130.column
		}
		local var7_130 = {
			"up",
			"right",
			"down",
			"left"
		}
		local var8_130

		if var6_130[1] ~= 0 then
			var8_130 = var6_130[1] + 2
		else
			var8_130 = 3 - var6_130[2]
		end

		local var9_130 = var7_130[var8_130]
		local var10_130 = var0_130:getChapterSupportFleet()

		local function var11_130()
			arg0_130:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var10_130.id,
				arg1 = ChapterConst.StrategyExpel,
				arg2 = var4_130.row,
				arg3 = var4_130.column,
				arg4 = var5_130.row,
				arg5 = var5_130.column
			})
		end

		local var12_130 = var4_130.attachmentId
		local var13_130 = pg.expedition_data_template[var12_130].name

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("levelscene_airexpel_select_confirm_" .. var9_130, var13_130),
			onYes = var11_130
		})
	end
end

function var0_0.CleanAirSupport(arg0_133)
	arg0_133.airSupportTarget = nil
end

function var0_0.startQuadTween(arg0_134, arg1_134, arg2_134, arg3_134, arg4_134)
	if arg0_134.presentTws[arg1_134] then
		LeanTween.cancel(arg0_134.presentTws[arg1_134].uniqueId)

		arg0_134.presentTws[arg1_134] = nil
	end

	if not arg0_134.quadTws[arg1_134] then
		arg3_134 = arg3_134 or 1
		arg4_134 = arg4_134 or ChapterConst.CellEaseOutAlpha

		setImageAlpha(arg2_134, arg3_134)

		local var0_134 = LeanTween.alpha(arg2_134, arg4_134, 1):setLoopPingPong()

		arg0_134.quadTws[arg1_134] = {
			tw = var0_134,
			uniqueId = var0_134.uniqueId
		}
	end
end

function var0_0.cancelQuadTween(arg0_135, arg1_135, arg2_135)
	if arg0_135.quadTws[arg1_135] then
		LeanTween.cancel(arg0_135.quadTws[arg1_135].uniqueId)

		arg0_135.quadTws[arg1_135] = nil
	end

	setImageAlpha(arg2_135, ChapterConst.CellEaseOutAlpha)
end

function var0_0.killQuadTws(arg0_136)
	for iter0_136, iter1_136 in pairs(arg0_136.quadTws) do
		LeanTween.cancel(iter1_136.uniqueId)
	end

	arg0_136.quadTws = {}
end

function var0_0.killPresentTws(arg0_137)
	for iter0_137, iter1_137 in pairs(arg0_137.presentTws) do
		LeanTween.cancel(iter1_137.uniqueId)
	end

	arg0_137.presentTws = {}
end

function var0_0.startMarkTween(arg0_138, arg1_138, arg2_138, arg3_138, arg4_138)
	if not arg0_138.markTws[arg1_138] then
		arg3_138 = arg3_138 or 1
		arg4_138 = arg4_138 or 0.2

		setImageAlpha(arg2_138, arg3_138)

		local var0_138 = LeanTween.alpha(arg2_138, arg4_138, 0.7):setLoopPingPong():setEase(LeanTweenType.easeInOutSine):setDelay(1)

		arg0_138.markTws[arg1_138] = {
			tw = var0_138,
			uniqueId = var0_138.uniqueId
		}
	end
end

function var0_0.cancelMarkTween(arg0_139, arg1_139, arg2_139, arg3_139)
	if arg0_139.markTws[arg1_139] then
		LeanTween.cancel(arg0_139.markTws[arg1_139].uniqueId)

		arg0_139.markTws[arg1_139] = nil
	end

	setImageAlpha(arg2_139, arg3_139 or ChapterConst.CellEaseOutAlpha)
end

function var0_0.moveFleet(arg0_140, arg1_140, arg2_140, arg3_140, arg4_140)
	local var0_140 = arg0_140.contextData.chapterVO
	local var1_140 = var0_140.fleet
	local var2_140 = var1_140.id
	local var3_140 = arg0_140.cellFleets[var2_140]

	var3_140:SetSpineVisible(true)
	setActive(var3_140.tfShadow, true)
	setActive(arg0_140.arrowTarget, true)
	arg0_140:updateTargetArrow(arg2_140[#arg2_140])

	if arg3_140 then
		arg0_140:updateAttachment(arg3_140.row, arg3_140.column)
	end

	local function var4_140(arg0_141)
		var1_140.step = var1_140.step + 1

		if arg0_140.onShipStepChange then
			arg0_140.onShipStepChange(arg0_141)
		end
	end

	local function var5_140(arg0_142)
		return
	end

	local function var6_140()
		setActive(arg0_140.arrowTarget, false)

		local var0_143 = var0_140.fleet.line
		local var1_143 = var0_140:getChapterCell(var0_143.row, var0_143.column)

		if ChapterConst.NeedClearStep(var1_143) then
			var1_140.step = 0
		end

		var1_140.rotation = var3_140:GetRotatePivot().transform.localRotation

		arg0_140:updateAttachment(var0_143.row, var0_143.column)
		arg0_140:updateFleet(var2_140)
		arg0_140:updateOni()

		local var2_143 = var0_140:getChampionIndex(var0_143.row, var0_143.column)

		if var2_143 then
			arg0_140:updateChampion(var2_143)
		end

		if arg0_140.onShipArrived then
			arg0_140.onShipArrived()
		end

		if arg4_140 then
			arg4_140()
		end
	end

	arg0_140:updateQuadCells(ChapterConst.QuadStateFrozen)
	arg0_140:moveCellView(var3_140, arg1_140, arg2_140, var4_140, var5_140, var6_140)
end

function var0_0.moveSub(arg0_144, arg1_144, arg2_144, arg3_144, arg4_144)
	local var0_144 = arg0_144.contextData.chapterVO
	local var1_144 = var0_144.fleets[arg1_144]
	local var2_144 = arg0_144.cellFleets[var1_144.id]
	local var3_144 = arg2_144[#arg2_144]

	local function var4_144(arg0_145)
		return
	end

	local function var5_144(arg0_146)
		return
	end

	local function var6_144()
		local var0_147 = var0_144:existEnemy(ChapterConst.SubjectPlayer, var3_144.row, var3_144.column) or var0_144:existAlly(var1_144)
		local var1_147 = var0_144.subAutoAttack == 1

		var2_144:SetActiveModel(not var0_147 and var1_147)

		var1_144.rotation = var2_144:GetRotatePivot().transform.localRotation

		if arg4_144 then
			arg4_144()
		end
	end

	arg0_144:updateQuadCells(ChapterConst.QuadStateFrozen)
	arg0_144:teleportSubView(var2_144, var2_144:GetLine(), var3_144, var4_144, var5_144, var6_144)
end

function var0_0.moveChampion(arg0_148, arg1_148, arg2_148, arg3_148, arg4_148)
	local var0_148 = arg0_148.contextData.chapterVO
	local var1_148 = var0_148.champions[arg1_148]
	local var2_148 = arg0_148.cellChampions[arg1_148]

	local function var3_148(arg0_149)
		return
	end

	local function var4_148(arg0_150)
		return
	end

	local function var5_148()
		if var2_148.GetRotatePivot then
			var1_148.rotation = var2_148:GetRotatePivot().transform.localRotation
		end

		if arg4_148 then
			arg4_148()
		end
	end

	if var0_148:getChampionVisibility(var1_148) then
		arg0_148:moveCellView(var2_148, arg2_148, arg3_148, var3_148, var4_148, var5_148)
	else
		local var6_148 = arg2_148[#arg2_148]

		var2_148:RefreshLinePosition(var0_148, var6_148)
		var5_148()
	end
end

function var0_0.moveTransport(arg0_152, arg1_152, arg2_152, arg3_152, arg4_152)
	local var0_152 = arg0_152.contextData.chapterVO.fleets[arg1_152]
	local var1_152 = arg0_152.cellFleets[var0_152.id]

	local function var2_152(arg0_153)
		return
	end

	local function var3_152(arg0_154)
		return
	end

	local function var4_152()
		var0_152.rotation = var1_152:GetRotatePivot().transform.localRotation

		arg0_152:updateFleet(var0_152.id)
		existCall(arg4_152)
	end

	arg0_152:updateQuadCells(ChapterConst.QuadStateFrozen)
	arg0_152:moveCellView(var1_152, arg2_152, arg3_152, var2_152, var3_152, var4_152)
end

function var0_0.moveCellView(arg0_156, arg1_156, arg2_156, arg3_156, arg4_156, arg5_156, arg6_156)
	local var0_156 = arg0_156.contextData.chapterVO
	local var1_156

	local function var2_156()
		if var1_156 and coroutine.status(var1_156) == "suspended" then
			local var0_157, var1_157 = coroutine.resume(var1_156)

			assert(var0_157, debug.traceback(var1_156, var1_157))
		end
	end

	var1_156 = coroutine.create(function()
		arg0_156:frozen()

		local var0_158 = var0_156:GetQuickPlayFlag() and ChapterConst.ShipStepQuickPlayScale or 1
		local var1_158 = 0.3 * var0_158
		local var2_158 = ChapterConst.ShipStepDuration * ChapterConst.ShipMoveTailLength * var0_158
		local var3_158 = 0.1 * var0_158
		local var4_158 = 0

		table.insert(arg3_156, 1, arg1_156:GetLine())
		_.each(arg3_156, function(arg0_159)
			local var0_159 = var0_156:getChapterCell(arg0_159.row, arg0_159.column)

			if ChapterConst.NeedEasePathCell(var0_159) then
				local var1_159 = ChapterCell.Line2QuadName(var0_159.row, var0_159.column)
				local var2_159 = arg0_156.quadRoot:Find(var1_159)

				arg0_156:cancelQuadTween(var1_159, var2_159)
				LeanTween.alpha(var2_159, 1, var1_158):setDelay(var4_158)

				var4_158 = var4_158 + var3_158
			end
		end)
		_.each(arg2_156, function(arg0_160)
			arg0_156:moveStep(arg1_156, arg0_160, arg3_156[#arg3_156], function()
				local var0_161 = arg1_156:GetLine()
				local var1_161 = var0_156:getChapterCell(var0_161.row, var0_161.column)

				if ChapterConst.NeedEasePathCell(var1_161) then
					local var2_161 = ChapterCell.Line2QuadName(var1_161.row, var1_161.column)
					local var3_161 = arg0_156.quadRoot:Find(var2_161)

					LeanTween.scale(var3_161, Vector3.zero, var2_158)
				end

				arg4_156(arg0_160)
				arg1_156:SetLine(arg0_160)
				arg1_156:ResetCanvasOrder()
			end, function()
				arg5_156(arg0_160)
				var2_156()
			end)
			coroutine.yield()
		end)
		_.each(arg3_156, function(arg0_163)
			local var0_163 = var0_156:getChapterCell(arg0_163.row, arg0_163.column)

			if ChapterConst.NeedEasePathCell(var0_163) then
				local var1_163 = ChapterCell.Line2QuadName(var0_163.row, var0_163.column)
				local var2_163 = arg0_156.quadRoot:Find(var1_163)

				LeanTween.cancel(var2_163.gameObject)
				setImageAlpha(var2_163, ChapterConst.CellEaseOutAlpha)

				var2_163.localScale = Vector3.one
			end
		end)

		if arg0_156.exited then
			return
		end

		if arg1_156.GetAction then
			arg1_156:SetAction(ChapterConst.ShipIdleAction)
		end

		arg6_156()
		arg0_156:unfrozen()
	end)

	var2_156()
end

function var0_0.moveStep(arg0_164, arg1_164, arg2_164, arg3_164, arg4_164, arg5_164)
	local var0_164 = arg0_164.contextData.chapterVO
	local var1_164 = var0_164:GetQuickPlayFlag() and ChapterConst.ShipStepQuickPlayScale or 1
	local var2_164

	if arg1_164.GetRotatePivot then
		var2_164 = arg1_164:GetRotatePivot()
	end

	local var3_164 = arg1_164:GetLine()

	if arg1_164.GetAction then
		arg1_164:SetAction(ChapterConst.ShipMoveAction)
	end

	if not IsNil(var2_164) and (arg2_164.column ~= var3_164.column or arg3_164.column ~= var3_164.column) then
		tf(var2_164).localRotation = Quaternion.identity

		if arg2_164.column < var3_164.column or arg2_164.column == var3_164.column and arg3_164.column < var3_164.column then
			tf(var2_164).localRotation = Quaternion.Euler(0, 180, 0)
		end
	end

	local var4_164 = arg1_164.tf.localPosition
	local var5_164 = var0_164.theme:GetLinePosition(arg2_164.row, arg2_164.column)
	local var6_164 = 0

	LeanTween.value(arg1_164.go, 0, 1, ChapterConst.ShipStepDuration * var1_164):setOnComplete(System.Action(arg5_164)):setOnUpdate(System.Action_float(function(arg0_165)
		arg1_164.tf.localPosition = Vector3.Lerp(var4_164, var5_164, arg0_165)

		if var6_164 <= 0.5 and arg0_165 > 0.5 then
			arg4_164()
		end

		var6_164 = arg0_165
	end))
end

function var0_0.teleportSubView(arg0_166, arg1_166, arg2_166, arg3_166, arg4_166, arg5_166, arg6_166)
	local var0_166 = arg0_166.contextData.chapterVO

	local function var1_166()
		arg4_166(arg3_166)
		arg1_166:RefreshLinePosition(var0_166, arg3_166)
		arg5_166(arg3_166)
		arg0_166:PlaySubAnimation(arg1_166, false, arg6_166)
	end

	arg0_166:PlaySubAnimation(arg1_166, true, var1_166)
end

function var0_0.CellToScreen(arg0_168, arg1_168, arg2_168)
	local var0_168 = arg0_168._tf:Find(ChapterConst.PlaneName .. "/cells")

	assert(var0_168, "plane not exist.")

	local var1_168 = arg0_168.contextData.chapterVO.theme
	local var2_168 = var1_168:GetLinePosition(arg1_168, arg2_168)
	local var3_168 = var2_168.y

	var2_168.y = var3_168 * math.cos(math.pi / 180 * var1_168.angle)
	var2_168.z = var3_168 * math.sin(math.pi / 180 * var1_168.angle)

	local var4_168 = arg0_168.levelCam.transform:GetChild(0)
	local var5_168 = var0_168.transform.lossyScale.x
	local var6_168 = var0_168.position + var2_168 * var5_168
	local var7_168 = arg0_168.levelCam:WorldToViewportPoint(var6_168)

	return Vector3(var4_168.rect.width * (var7_168.x - 0.5), var4_168.rect.height * (var7_168.y - 0.5))
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

function var0_0.AddCellEdge(arg0_169, arg1_169, arg2_169, ...)
	local var0_169 = 0
	local var1_169 = 1

	for iter0_169 = 1, 4 do
		if not _.any(arg1_169, function(arg0_170)
			return arg0_170.row == arg2_169.row + var4_0[iter0_169][1] and arg0_170.column == arg2_169.column + var4_0[iter0_169][2]
		end) then
			var0_169 = bit.bor(var0_169, var1_169)
		end

		var1_169 = var1_169 * 2
	end

	if var0_169 == 0 then
		return
	end

	arg0_169:CreateEdge(var0_169, arg2_169, ...)
end

function var0_0.AddOutlines(arg0_171, arg1_171, arg2_171, arg3_171, arg4_171, arg5_171)
	local var0_171 = {}
	local var1_171 = {}

	for iter0_171, iter1_171 in ipairs(arg1_171) do
		for iter2_171 = 1, 4 do
			if not underscore.any(arg1_171, function(arg0_172)
				return arg0_172.row == iter1_171.row + var4_0[iter2_171][1] and arg0_172.column == iter1_171.column + var4_0[iter2_171][2]
			end) then
				local var2_171 = 2 * iter1_171.row + var4_0[iter2_171][1]
				local var3_171 = 2 * iter1_171.column + var4_0[iter2_171][2]

				assert(not var0_171[var2_171 .. "_" .. var3_171], "Multiple outline")

				var0_171[var2_171 .. "_" .. var3_171] = {
					row = var2_171,
					column = var3_171,
					normal = iter2_171
				}
			end

			if not underscore.any(arg1_171, function(arg0_173)
				return arg0_173.row == iter1_171.row + var5_0[iter2_171][1] and arg0_173.column == iter1_171.column + var5_0[iter2_171][2]
			end) and underscore.any(arg1_171, function(arg0_174)
				return arg0_174.row == iter1_171.row and arg0_174.column == iter1_171.column + var5_0[iter2_171][2]
			end) and underscore.any(arg1_171, function(arg0_175)
				return arg0_175.row == iter1_171.row + var5_0[iter2_171][1] and arg0_175.column == iter1_171.column
			end) then
				var1_171[iter1_171.row .. "_" .. iter1_171.column .. "_" .. iter2_171] = {
					row = iter1_171.row,
					column = iter1_171.column,
					corner = iter2_171
				}
			end
		end
	end

	arg0_171:CreateOutlines(var0_171, arg2_171, arg3_171, arg4_171, arg5_171)
	arg0_171:CreateOutlineCorners(var1_171, arg2_171, arg3_171, arg4_171, arg5_171 .. "_corner")
end

function var0_0.isHuntingRangeVisible(arg0_176)
	return arg0_176.contextData.huntingRangeVisibility % 2 == 0
end

function var0_0.toggleHuntingRange(arg0_177)
	arg0_177:hideQuadMark(ChapterConst.MarkHuntingRange)
	arg0_177:ClearEdges("SubmarineHunting")

	if not arg0_177:isHuntingRangeVisible() then
		arg0_177:ShowHuntingRange()
	end

	arg0_177.contextData.huntingRangeVisibility = 1 - arg0_177.contextData.huntingRangeVisibility

	arg0_177:updateAttachments()
	arg0_177:updateChampions()
end

function var0_0.ShowHuntingRange(arg0_178)
	local var0_178 = arg0_178.contextData.chapterVO
	local var1_178 = var0_178:GetSubmarineFleet()

	if not var1_178 then
		return
	end

	local var2_178 = var1_178:getHuntingRange()
	local var3_178 = _.filter(var2_178, function(arg0_179)
		local var0_179 = var0_178:getChapterCell(arg0_179.row, arg0_179.column)

		return var0_179 and var0_179:IsWalkable()
	end)

	arg0_178:RefreshHuntingRange(var3_178, false)
end

function var0_0.RefreshHuntingRange(arg0_180, arg1_180, arg2_180)
	arg0_180:showQuadMark(arg1_180, ChapterConst.MarkHuntingRange, "cell_hunting_range", Vector2(100, 100), arg0_180.material_Add, arg2_180)
	_.each(arg1_180, function(arg0_181)
		arg0_180:AddCellEdge(arg1_180, arg0_181, not arg2_180, nil, nil, "SubmarineHunting")
	end)
end

function var0_0.ShowStaticHuntingRange(arg0_182)
	arg0_182:hideQuadMark(ChapterConst.MarkHuntingRange)
	arg0_182:ClearEdges("SubmarineHunting")

	local var0_182 = arg0_182.contextData.chapterVO
	local var1_182 = var0_182:GetSubmarineFleet()

	if not arg0_182:isHuntingRangeVisible() then
		arg0_182.contextData.huntingRangeVisibility = arg0_182.contextData.huntingRangeVisibility + 1
	end

	local var2_182 = var1_182:getHuntingRange()
	local var3_182 = _.filter(var2_182, function(arg0_183)
		local var0_183 = var0_182:getChapterCell(arg0_183.row, arg0_183.column)

		return var0_183 and var0_183:IsWalkable()
	end)

	arg0_182:RefreshHuntingRange(var3_182, true)
end

function var0_0.ShowTargetHuntingRange(arg0_184, arg1_184)
	arg0_184:hideQuadMark(ChapterConst.MarkHuntingRange)
	arg0_184:ClearEdges("SubmarineHunting")

	local var0_184 = arg0_184.contextData.chapterVO
	local var1_184 = var0_184:GetSubmarineFleet()
	local var2_184 = var1_184:getHuntingRange(arg1_184)
	local var3_184 = _.filter(var2_184, function(arg0_185)
		local var0_185 = var0_184:getChapterCell(arg0_185.row, arg0_185.column)

		return var0_185 and var0_185:IsWalkable()
	end)
	local var4_184 = var1_184:getHuntingRange()
	local var5_184 = _.filter(var4_184, function(arg0_186)
		local var0_186 = var0_184:getChapterCell(arg0_186.row, arg0_186.column)

		return var0_186 and var0_186:IsWalkable()
	end)
	local var6_184 = {}

	for iter0_184, iter1_184 in pairs(var5_184) do
		if not table.containsData(var3_184, iter1_184) then
			table.insert(var6_184, iter1_184)
		end
	end

	arg0_184:RefreshHuntingRange(var6_184, true)
	arg0_184:RefreshHuntingRange(var3_184, false)
	arg0_184:updateAttachments()
	arg0_184:updateChampions()
end

function var0_0.OnChangeSubAutoAttack(arg0_187)
	local var0_187 = arg0_187.contextData.chapterVO
	local var1_187 = var0_187:GetSubmarineFleet()

	if not var1_187 then
		return
	end

	local var2_187 = arg0_187.cellFleets[var1_187.id]

	if not var2_187 then
		return
	end

	local var3_187 = var0_187.subAutoAttack == 1

	var2_187:SetActiveModel(not var3_187)
	arg0_187:PlaySubAnimation(var2_187, not var3_187, function()
		arg0_187:updateFleet(var1_187.id)
	end)
end

function var0_0.displayEscapeGrid(arg0_189)
	local var0_189 = arg0_189.contextData.chapterVO

	if not var0_189:existOni() then
		return
	end

	local var1_189 = var0_189:getOniChapterInfo()

	arg0_189:hideQuadMark(ChapterConst.MarkEscapeGrid)
	arg0_189:showQuadMark(_.map(var1_189.escape_grids, function(arg0_190)
		return {
			row = arg0_190[1],
			column = arg0_190[2]
		}
	end), ChapterConst.MarkEscapeGrid, "cell_escape_grid", Vector2(105, 105))
end

function var0_0.showQuadMark(arg0_191, arg1_191, arg2_191, arg3_191, arg4_191, arg5_191, arg6_191)
	arg0_191:ShowAnyQuadMark(arg1_191, arg2_191, arg3_191, arg4_191, arg5_191, false, arg6_191)
end

function var0_0.ShowTopQuadMark(arg0_192, arg1_192, arg2_192, arg3_192, arg4_192, arg5_192, arg6_192)
	arg0_192:ShowAnyQuadMark(arg1_192, arg2_192, arg3_192, arg4_192, arg5_192, true, arg6_192)
end

function var0_0.ShowAnyQuadMark(arg0_193, arg1_193, arg2_193, arg3_193, arg4_193, arg5_193, arg6_193, arg7_193)
	local var0_193 = arg0_193.contextData.chapterVO

	for iter0_193, iter1_193 in pairs(arg1_193) do
		local var1_193 = var0_193:getChapterCell(iter1_193.row, iter1_193.column)

		if var1_193 and var1_193:IsWalkable() then
			local var2_193 = ChapterCell.Line2MarkName(iter1_193.row, iter1_193.column, arg2_193)

			arg0_193.markQuads[arg2_193] = arg0_193.markQuads[arg2_193] or {}

			local var3_193 = arg0_193.markQuads[arg2_193][var2_193]

			if not var3_193 then
				PoolMgr.GetInstance():GetPrefab("chapter/cell_quad_mark", "", false, function(arg0_194)
					var3_193 = arg0_194.transform
					arg0_193.markQuads[arg2_193][var2_193] = var3_193
				end)
			else
				arg0_193:cancelMarkTween(var2_193, var3_193, 1)
			end

			var3_193.name = var2_193

			var3_193:SetParent(arg6_193 and arg0_193.topMarkRoot or arg0_193.bottomMarkRoot, false)

			var3_193.sizeDelta = var0_193.theme.cellSize
			var3_193.anchoredPosition = var0_193.theme:GetLinePosition(iter1_193.row, iter1_193.column)
			var3_193.localScale = Vector3.one

			var3_193:SetAsLastSibling()

			local var4_193 = var3_193:GetComponent(typeof(Image))

			var4_193.sprite = GetSpriteFromAtlas("chapter/pic/cellgrid", arg3_193)
			var4_193.material = arg5_193
			var3_193.sizeDelta = arg4_193

			if not arg7_193 then
				arg0_193:startMarkTween(var2_193, var3_193)
			else
				arg0_193:cancelMarkTween(var2_193, var3_193, 1)
			end
		end
	end
end

function var0_0.hideQuadMark(arg0_195, arg1_195)
	if arg1_195 and not arg0_195.markQuads[arg1_195] then
		return
	end

	for iter0_195, iter1_195 in pairs(arg0_195.markQuads) do
		if not arg1_195 or iter0_195 == arg1_195 then
			for iter2_195, iter3_195 in pairs(iter1_195) do
				arg0_195:cancelMarkTween(iter2_195, iter3_195)

				iter1_195[iter2_195]:GetComponent(typeof(Image)).material = nil
				iter1_195[iter2_195] = nil

				PoolMgr.GetInstance():ReturnPrefab("chapter/cell_quad_mark", "", iter3_195.gameObject)
			end

			table.clear(arg0_195.markQuads[iter0_195])
		end
	end
end

function var0_0.CreateEdgeIndex(arg0_196, arg1_196, arg2_196, arg3_196)
	return ChapterCell.Line2Name(arg0_196, arg1_196) .. (arg3_196 and "_" .. arg3_196 or "") .. "_" .. arg2_196
end

function var0_0.CreateEdge(arg0_197, arg1_197, arg2_197, arg3_197, arg4_197, arg5_197, arg6_197)
	if arg1_197 <= 0 or arg1_197 >= 16 then
		return
	end

	local var0_197 = arg0_197:GetEdgePool(arg6_197)
	local var1_197 = arg0_197.contextData.chapterVO
	local var2_197 = var1_197.theme:GetLinePosition(arg2_197.row, arg2_197.column)
	local var3_197 = var1_197.theme.cellSize

	assert(arg6_197, "Missing key, Please PM Programmer")

	local var4_197 = 1
	local var5_197 = 0

	while var5_197 < 4 do
		var5_197 = var5_197 + 1

		if bit.band(arg1_197, var4_197) > 0 then
			local var6_197 = arg0_197.CreateEdgeIndex(arg2_197.row, arg2_197.column, var5_197, arg6_197)

			arg0_197.cellEdges[arg6_197] = arg0_197.cellEdges[arg6_197] or {}
			arg0_197.cellEdges[arg6_197][var6_197] = arg0_197.cellEdges[arg6_197][var6_197] or tf(var0_197:Dequeue())

			local var7_197 = arg0_197.cellEdges[arg6_197][var6_197]

			var7_197.name = var6_197

			var7_197:SetParent(arg0_197.bottomMarkRoot, false)

			arg4_197 = arg4_197 or 0
			arg5_197 = arg5_197 or 3

			local var8_197 = bit.band(var5_197, 1) == 1 and var3_197.x - arg4_197 * 2 or var3_197.y - arg4_197 * 2
			local var9_197 = arg5_197

			var7_197.sizeDelta = Vector2.New(var8_197, var9_197)
			var7_197.pivot = Vector2.New(0.5, 0)

			local var10_197 = math.pi * 0.5 * -var5_197
			local var11_197 = math.cos(var10_197) * (var3_197.x * 0.5 - arg4_197)
			local var12_197 = math.sin(var10_197) * (var3_197.y * 0.5 - arg4_197)

			var7_197.anchoredPosition = Vector2.New(var11_197 + var2_197.x, var12_197 + var2_197.y)
			var7_197.localRotation = Quaternion.Euler(0, 0, (5 - var5_197) * 90)

			if arg3_197 then
				arg0_197:startMarkTween(var6_197, var7_197)
			else
				arg0_197:cancelMarkTween(var6_197, var7_197, 1)
			end
		end

		var4_197 = var4_197 * 2
	end
end

function var0_0.ClearEdge(arg0_198, arg1_198)
	for iter0_198, iter1_198 in pairs(arg0_198.cellEdges) do
		for iter2_198 = 1, 4 do
			local var0_198 = arg0_198.CreateEdgeIndex(arg1_198.row, arg1_198.column, iter2_198, iter0_198)

			if iter1_198[var0_198] then
				local var1_198 = arg0_198:GetEdgePool(iter0_198)
				local var2_198 = tf(iter1_198[var0_198])

				arg0_198:cancelMarkTween(var0_198, var2_198)
				var1_198:Enqueue(var2_198, false)

				iter1_198[var0_198] = nil
			end
		end
	end
end

function var0_0.ClearEdges(arg0_199, arg1_199)
	if not next(arg0_199.cellEdges) then
		return
	end

	for iter0_199, iter1_199 in pairs(arg0_199.cellEdges) do
		if not arg1_199 or arg1_199 == iter0_199 then
			local var0_199 = arg0_199:GetEdgePool(iter0_199)

			for iter2_199, iter3_199 in pairs(iter1_199) do
				arg0_199:cancelMarkTween(iter2_199, iter3_199)
				var0_199:Enqueue(go(iter3_199), false)
			end

			arg0_199.cellEdges[iter0_199] = nil
		end
	end
end

function var0_0.CreateOutlines(arg0_200, arg1_200, arg2_200, arg3_200, arg4_200, arg5_200)
	local var0_200 = arg0_200.contextData.chapterVO
	local var1_200 = var0_200.theme.cellSize + var0_200.theme.cellSpace

	for iter0_200, iter1_200 in pairs(arg1_200) do
		local var2_200 = arg0_200:GetEdgePool(arg5_200)
		local var3_200 = var0_200.theme:GetLinePosition(iter1_200.row / 2, iter1_200.column / 2)

		assert(arg5_200, "Missing key, Please PM Programmer")

		local var4_200 = arg0_200.CreateEdgeIndex(iter1_200.row, iter1_200.column, 0, arg5_200)

		arg0_200.cellEdges[arg5_200] = arg0_200.cellEdges[arg5_200] or {}
		arg0_200.cellEdges[arg5_200][var4_200] = arg0_200.cellEdges[arg5_200][var4_200] or tf(var2_200:Dequeue())

		local var5_200 = arg0_200.cellEdges[arg5_200][var4_200]

		var5_200.name = var4_200

		var5_200:SetParent(arg0_200.bottomMarkRoot, false)

		arg3_200 = arg3_200 or 0
		arg4_200 = arg4_200 or 3

		local var6_200 = var4_0[iter1_200.normal][1] ~= 0 and var1_200.x or var1_200.y
		local var7_200 = arg4_200
		local var8_200 = var6_200 * 0.5
		local var9_200 = iter1_200.normal % 4 + 1
		local var10_200 = (iter1_200.normal + 2) % 4 + 1
		local var11_200 = {
			iter1_200.row + var4_0[var9_200][1],
			iter1_200.column + var4_0[var9_200][2]
		}
		local var12_200 = arg1_200[var11_200[1] + var4_0[iter1_200.normal][1] .. "_" .. var11_200[2] + var4_0[iter1_200.normal][2]] or arg1_200[var11_200[1] - var4_0[iter1_200.normal][1] .. "_" .. var11_200[2] - var4_0[iter1_200.normal][2]]
		local var13_200 = {
			iter1_200.row + var4_0[var10_200][1],
			iter1_200.column + var4_0[var10_200][2]
		}
		local var14_200 = arg1_200[var13_200[1] + var4_0[iter1_200.normal][1] .. "_" .. var13_200[2] + var4_0[iter1_200.normal][2]] or arg1_200[var13_200[1] - var4_0[iter1_200.normal][1] .. "_" .. var13_200[2] - var4_0[iter1_200.normal][2]]

		if var12_200 then
			local var15_200 = iter1_200.row + var4_0[iter1_200.normal][1] == var12_200.row + var4_0[var12_200.normal][1] or iter1_200.column + var4_0[iter1_200.normal][2] == var12_200.column + var4_0[var12_200.normal][2]

			var6_200 = var15_200 and var6_200 + arg3_200 or var6_200 - arg3_200
			var8_200 = var15_200 and var8_200 + arg3_200 or var8_200 - arg3_200
		end

		if var14_200 then
			var6_200 = (iter1_200.row + var4_0[iter1_200.normal][1] == var14_200.row + var4_0[var14_200.normal][1] or iter1_200.column + var4_0[iter1_200.normal][2] == var14_200.column + var4_0[var14_200.normal][2]) and var6_200 + arg3_200 or var6_200 - arg3_200
		end

		var5_200.sizeDelta = Vector2.New(var6_200, var7_200)
		var5_200.pivot = Vector2.New(var8_200 / var6_200, 0)

		local var16_200 = var4_0[iter1_200.normal][2] * -arg3_200
		local var17_200 = var4_0[iter1_200.normal][1] * arg3_200

		var5_200.anchoredPosition = Vector2.New(var16_200 + var3_200.x, var17_200 + var3_200.y)
		var5_200.localRotation = Quaternion.Euler(0, 0, (5 - iter1_200.normal) * 90)

		if arg2_200 then
			arg0_200:startMarkTween(var4_200, var5_200)
		else
			arg0_200:cancelMarkTween(var4_200, var5_200, 1)
		end
	end
end

function var0_0.CreateOutlineCorners(arg0_201, arg1_201, arg2_201, arg3_201, arg4_201, arg5_201)
	local var0_201 = arg0_201.contextData.chapterVO

	for iter0_201, iter1_201 in pairs(arg1_201) do
		local var1_201 = arg0_201:GetEdgePool(arg5_201)
		local var2_201 = var0_201.theme:GetLinePosition(iter1_201.row + var5_0[iter1_201.corner][1] * 0.5, iter1_201.column + var5_0[iter1_201.corner][2] * 0.5)

		assert(arg5_201, "Missing key, Please PM Programmer")

		local var3_201 = arg0_201.CreateEdgeIndex(iter1_201.row, iter1_201.column, iter1_201.corner, arg5_201)

		arg0_201.cellEdges[arg5_201] = arg0_201.cellEdges[arg5_201] or {}
		arg0_201.cellEdges[arg5_201][var3_201] = arg0_201.cellEdges[arg5_201][var3_201] or tf(var1_201:Dequeue())

		local var4_201 = arg0_201.cellEdges[arg5_201][var3_201]

		var4_201.name = var3_201

		var4_201:SetParent(arg0_201.bottomMarkRoot, false)

		arg3_201 = arg3_201 or 0
		arg4_201 = arg4_201 or 3

		local var5_201 = arg4_201
		local var6_201 = arg4_201

		var4_201.sizeDelta = Vector2.New(var5_201, var6_201)
		var4_201.pivot = Vector2.New(1, 0)

		local var7_201 = var5_0[iter1_201.corner][2] * -arg3_201
		local var8_201 = var5_0[iter1_201.corner][1] * arg3_201

		var4_201.anchoredPosition = Vector2.New(var7_201 + var2_201.x, var8_201 + var2_201.y)
		var4_201.localRotation = Quaternion.Euler(0, 0, (5 - iter1_201.corner) * 90)

		if arg2_201 then
			arg0_201:startMarkTween(var3_201, var4_201)
		else
			arg0_201:cancelMarkTween(var3_201, var4_201, 1)
		end
	end
end

function var0_0.updateCoastalGunAttachArea(arg0_202)
	local var0_202 = arg0_202.contextData.chapterVO:getCoastalGunArea()

	arg0_202:hideQuadMark(ChapterConst.MarkCoastalGun)
	arg0_202:showQuadMark(var0_202, ChapterConst.MarkCoastalGun, "cell_coastal_gun", Vector2(110, 110), nil, false)
end

function var0_0.InitIdolsAnim(arg0_203)
	local var0_203 = arg0_203.contextData.chapterVO
	local var1_203 = pg.chapter_pop_template[var0_203.id]

	if not var1_203 then
		return
	end

	local var2_203 = var1_203.sd_location

	for iter0_203, iter1_203 in ipairs(var2_203) do
		arg0_203.idols = arg0_203.idols or {}

		local var3_203 = ChapterCell.Line2Name(iter1_203[1][1], iter1_203[1][2])
		local var4_203 = arg0_203.cellRoot:Find(var3_203 .. "/" .. ChapterConst.ChildAttachment)

		assert(var4_203, "cant find attachment")

		local var5_203 = AttachmentSpineAnimationCell.New(var4_203)

		var5_203:SetLine({
			row = iter1_203[1][1],
			column = iter1_203[1][2]
		})
		table.insert(arg0_203.idols, var5_203)
		var5_203:Set(iter1_203[2])
		var5_203:SetRoutine(var1_203.sd_act[iter0_203])
	end
end

function var0_0.ClearIdolsAnim(arg0_204)
	if arg0_204.idols then
		for iter0_204, iter1_204 in ipairs(arg0_204.idols) do
			iter1_204:Clear()
		end

		table.clear(arg0_204.idols)

		arg0_204.idols = nil
	end
end

function var0_0.GetEnemyCellView(arg0_205, arg1_205)
	local var0_205 = _.detect(arg0_205.cellChampions, function(arg0_206)
		local var0_206 = arg0_206:GetLine()

		return var0_206.row == arg1_205.row and var0_206.column == arg1_205.column
	end)

	if not var0_205 then
		local var1_205 = ChapterCell.Line2Name(arg1_205.row, arg1_205.column)

		var0_205 = arg0_205.attachmentCells[var1_205]
	end

	return var0_205
end

function var0_0.TransformLine2PlanePos(arg0_207, arg1_207)
	local var0_207 = string.char(string.byte("A") + arg1_207.column - arg0_207.indexMin.y)
	local var1_207 = string.char(string.byte("1") + arg1_207.row - arg0_207.indexMin.x)

	return var0_207 .. var1_207
end

function var0_0.AlignListContainer(arg0_208, arg1_208)
	local var0_208 = arg0_208.childCount

	for iter0_208 = arg1_208, var0_208 - 1 do
		local var1_208 = arg0_208:GetChild(iter0_208)

		setActive(var1_208, false)
	end

	for iter1_208 = var0_208, arg1_208 - 1 do
		cloneTplTo(arg0_208:GetChild(0), arg0_208)
	end

	for iter2_208 = 0, arg1_208 - 1 do
		local var2_208 = arg0_208:GetChild(iter2_208)

		setActive(var2_208, true)
	end
end

function var0_0.frozen(arg0_209)
	arg0_209.forzenCount = (arg0_209.forzenCount or 0) + 1

	arg0_209.parent:frozen()
end

function var0_0.unfrozen(arg0_210)
	if arg0_210.exited then
		return
	end

	arg0_210.forzenCount = (arg0_210.forzenCount or 0) - 1

	arg0_210.parent:unfrozen()
end

function var0_0.isfrozen(arg0_211)
	return arg0_211.parent.frozenCount > 0
end

function var0_0.clear(arg0_212)
	arg0_212:clearAll()

	if (arg0_212.forzenCount or 0) > 0 then
		arg0_212.parent:unfrozen(arg0_212.forzenCount)
	end
end

return var0_0
