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
	arg0_1.material_Add = LoadAny("ui/commonUI_atlas", "add", typeof(Material))
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
	local var2_5

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
		end,
		function(arg0_8)
			if not arg5_5 then
				arg0_8()

				return
			end

			arg0_5.loader:LoadReference(arg2_5, arg5_5, typeof(Material), function(arg0_9)
				var2_5 = arg0_9

				arg0_8()
			end)
		end
	}, function()
		local function var0_10(arg0_11)
			local var0_11 = go(arg0_11):GetComponent(typeof(Image))

			var0_11.enabled = true
			var0_11.color = type(arg4_5) == "table" and Color.New(unpack(arg4_5)) or Color.white
			var0_11.sprite = arg3_5 and var1_5 or nil
			var0_11.material = arg5_5 and var2_5 or nil
		end

		local var1_10 = arg0_5.edgePools[arg1_5]

		if var1_10.prefab then
			var0_10(var1_10.prefab)
		end

		if var1_10.items then
			for iter0_10, iter1_10 in pairs(var1_10.items) do
				var0_10(iter1_10)
			end
		end

		if arg0_5.cellEdges[arg1_5] and next(arg0_5.cellEdges[arg1_5]) then
			for iter2_10, iter3_10 in pairs(arg0_5.cellEdges[arg1_5]) do
				var0_10(iter3_10)
			end
		end
	end)
end

function var0_0.GetEdgePool(arg0_12, arg1_12)
	assert(arg1_12, "Missing Key")

	local var0_12 = arg0_12.edgePools[arg1_12]

	assert(var0_12, "Must Create Pool before Using")

	return var0_12
end

function var0_0.initAll(arg0_13, arg1_13)
	seriesAsync({
		function(arg0_14)
			arg0_13:initPlane()
			arg0_13:initDrag()
			onNextTick(arg0_14)
		end,
		function(arg0_15)
			if arg0_13.exited then
				return
			end

			arg0_13:initTargetArrow()
			arg0_13:InitDestinationMark()
			onNextTick(arg0_15)
		end,
		function(arg0_16)
			if arg0_13.exited then
				return
			end

			for iter0_16 = 0, ChapterConst.MaxRow - 1 do
				for iter1_16 = 0, ChapterConst.MaxColumn - 1 do
					arg0_13:initCell(iter0_16, iter1_16)
				end
			end

			arg0_13:UpdateItemCells()
			arg0_13:updateQuadCells(ChapterConst.QuadStateFrozen)
			onNextTick(arg0_16)
		end,
		function(arg0_17)
			if arg0_13.exited then
				return
			end

			arg0_13:AddEdgePool("SubmarineHunting", "ui/commonUI_atlas", "white_dot", {
				1,
				0,
				0
			}, "add")
			arg0_13:UpdateFloor()
			arg0_13:updateAttachments()
			arg0_13:InitWalls()
			arg0_13:InitIdolsAnim()
			onNextTick(arg0_17)
		end,
		function(arg0_18)
			if arg0_13.exited then
				return
			end

			parallelAsync({
				function(arg0_19)
					arg0_13:initFleets(arg0_19)
				end,
				function(arg0_20)
					arg0_13:initChampions(arg0_20)
				end
			}, arg0_18)
		end,
		function()
			arg0_13:OnChangeSubAutoAttack()
			arg0_13:updateQuadCells(ChapterConst.QuadStateNormal)
			existCall(arg1_13)
		end
	})
end

function var0_0.clearAll(arg0_22)
	for iter0_22, iter1_22 in pairs(arg0_22.tweens) do
		LeanTween.cancel(iter0_22)
	end

	table.clear(arg0_22.tweens)
	arg0_22.loader:Clear()

	if not IsNil(arg0_22.cellRoot) then
		arg0_22:clearFleets()
		arg0_22:clearChampions()
		arg0_22:clearTargetArrow()
		arg0_22:ClearDestinationMark()
		arg0_22:ClearIdolsAnim()

		for iter2_22, iter3_22 in pairs(arg0_22.itemCells) do
			iter3_22:Clear()
		end

		table.clear(arg0_22.itemCells)

		for iter4_22, iter5_22 in pairs(arg0_22.attachmentCells) do
			iter5_22:Clear()
		end

		table.clear(arg0_22.attachmentCells)

		for iter6_22, iter7_22 in pairs(arg0_22.extraAttachmentCells) do
			iter7_22:Clear()
		end

		table.clear(arg0_22.extraAttachmentCells)

		for iter8_22, iter9_22 in pairs(arg0_22.weatherCells) do
			iter9_22:Clear()
		end

		table.clear(arg0_22.weatherCells)

		for iter10_22 = 0, ChapterConst.MaxRow - 1 do
			for iter11_22 = 0, ChapterConst.MaxColumn - 1 do
				arg0_22:clearCell(iter10_22, iter11_22)
			end
		end

		for iter12_22, iter13_22 in pairs(arg0_22.walls) do
			iter13_22:Clear()
		end

		table.clear(arg0_22.walls)
		arg0_22:clearPlane()
	end

	arg0_22.material_Add = nil

	for iter14_22, iter15_22 in pairs(arg0_22.edgePools) do
		iter15_22:Clear()
	end

	arg0_22.edgePools = nil

	for iter16_22, iter17_22 in pairs(arg0_22.pools) do
		iter17_22:ClearItems()
	end

	arg0_22.pools = nil
	GetOrAddComponent(arg0_22._tf, "EventTriggerListener").enabled = false

	if arg0_22.dragTrigger then
		ClearEventTrigger(arg0_22.dragTrigger)

		arg0_22.dragTrigger = nil
	end

	LeanTween.cancel(arg0_22._tf)
end

local var2_0 = 640

function var0_0.initDrag(arg0_23)
	local var0_23, var1_23, var2_23 = getSizeRate()
	local var3_23 = arg0_23.contextData.chapterVO
	local var4_23 = var3_23.theme
	local var5_23 = var2_23 * 0.5 / math.tan(math.deg2Rad * var4_23.fov * 0.5)
	local var6_23 = math.deg2Rad * var4_23.angle
	local var7_23 = Vector3(0, -math.sin(var6_23), -math.cos(var6_23))
	local var8_23 = Vector3(var4_23.offsetx, var4_23.offsety, var4_23.offsetz) + var0_0.MapDefaultPos
	local var9_23 = Vector3.Dot(var7_23, var8_23)
	local var10_23 = var0_23 * math.clamp((var5_23 - var9_23) / var5_23, 0, 1)
	local var11_23 = arg0_23.plane:Find("display").anchoredPosition
	local var12_23 = var2_0 - var8_23.x - var11_23.x
	local var13_23 = var0_0.MapDefaultPos.y - var8_23.y - var11_23.y
	local var14_23, var15_23, var16_23, var17_23 = var3_23:getDragExtend()

	arg0_23.leftBound = var12_23 - var15_23
	arg0_23.rightBound = var12_23 + var14_23
	arg0_23.topBound = var13_23 + var17_23
	arg0_23.bottomBound = var13_23 - var16_23
	arg0_23._tf.sizeDelta = Vector2(var1_23 * 2, var2_23 * 2)
	arg0_23.dragTrigger = GetOrAddComponent(arg0_23._tf, "EventTriggerListener")
	arg0_23.dragTrigger.enabled = true

	arg0_23.dragTrigger:AddDragFunc(function(arg0_24, arg1_24)
		local var0_24 = arg0_23._tf.anchoredPosition

		var0_24.x = math.clamp(var0_24.x + arg1_24.delta.x * var10_23.x, arg0_23.leftBound, arg0_23.rightBound)
		var0_24.y = math.clamp(var0_24.y + arg1_24.delta.y * var10_23.y / math.cos(var6_23), arg0_23.bottomBound, arg0_23.topBound)
		arg0_23._tf.anchoredPosition = var0_24
	end)
end

function var0_0.initPlane(arg0_25)
	local var0_25 = arg0_25.contextData.chapterVO
	local var1_25 = var0_25.theme

	arg0_25.levelCam.fieldOfView = var1_25.fov

	local var2_25

	PoolMgr.GetInstance():GetPrefab("chapter/plane", "", false, function(arg0_26)
		var2_25 = arg0_26.transform
	end)

	arg0_25.plane = var2_25
	var2_25.name = ChapterConst.PlaneName

	var2_25:SetParent(arg0_25._tf, false)

	var2_25.anchoredPosition3D = Vector3(var1_25.offsetx, var1_25.offsety, var1_25.offsetz) + var0_0.MapDefaultPos
	arg0_25.cellRoot = var2_25:Find("cells")
	arg0_25.quadRoot = var2_25:Find("quads")
	arg0_25.bottomMarkRoot = var2_25:Find("buttomMarks")
	arg0_25.topMarkRoot = var2_25:Find("topMarks")
	arg0_25.restrictMap = var2_25:Find("restrictMap")
	arg0_25.UIFXList = var2_25:Find("UI_FX_list")

	for iter0_25 = 1, arg0_25.UIFXList.childCount do
		local var3_25 = arg0_25.UIFXList:GetChild(iter0_25 - 1)

		setActive(var3_25, false)
	end

	local var4_25 = arg0_25.UIFXList:Find(var0_25:getConfig("uifx"))

	if var4_25 then
		setActive(var4_25, true)
	end

	local var5_25 = var0_25:getConfig("chapter_fx")

	if type(var5_25) == "table" then
		for iter1_25, iter2_25 in pairs(var5_25) do
			if #iter1_25 <= 0 then
				return
			end

			arg0_25.loader:GetPrefab("effect/" .. iter1_25, iter1_25, function(arg0_27)
				setParent(arg0_27, arg0_25.UIFXList)

				if iter2_25.offset then
					tf(arg0_27).localPosition = Vector3(unpack(iter2_25.offset))
				end

				if iter2_25.rotation then
					tf(arg0_27).localRotation = Quaternion.Euler(unpack(iter2_25.rotation))
				end
			end)
		end
	end

	local var6_25 = var2_25:Find("display")
	local var7_25 = var6_25:Find("mask/sea")

	GetImageSpriteFromAtlasAsync("chapter/pic/" .. var1_25.assetSea, var1_25.assetSea, var7_25)

	arg0_25.indexMin, arg0_25.indexMax = var0_25.indexMin, var0_25.indexMax

	local var8_25 = Vector2(arg0_25.indexMin.y, ChapterConst.MaxRow * 0.5 - arg0_25.indexMax.x - 1)
	local var9_25 = Vector2(arg0_25.indexMax.y - arg0_25.indexMin.y + 1, arg0_25.indexMax.x - arg0_25.indexMin.x + 1)
	local var10_25 = var1_25.cellSize + var1_25.cellSpace
	local var11_25 = Vector2.Scale(var8_25, var10_25)
	local var12_25 = Vector2.Scale(var9_25, var10_25)

	var6_25.anchoredPosition = var11_25 + var12_25 * 0.5
	var6_25.sizeDelta = var12_25
	arg0_25.restrictMap.anchoredPosition = var11_25 + var12_25 * 0.5
	arg0_25.restrictMap.sizeDelta = var12_25

	local var13_25 = Vector2(math.floor(var6_25.sizeDelta.x / var10_25.x), math.floor(var6_25.sizeDelta.y / var10_25.y))
	local var14_25 = var6_25:Find("ABC")
	local var15_25 = var14_25:GetChild(0)
	local var16_25 = var14_25:GetComponent(typeof(GridLayoutGroup))

	var16_25.cellSize = Vector2(var1_25.cellSize.x, var1_25.cellSize.y)
	var16_25.spacing = Vector2(var1_25.cellSpace.x, var1_25.cellSpace.y)
	var16_25.padding.left = var1_25.cellSpace.x

	for iter3_25 = var14_25.childCount - 1, var13_25.x, -1 do
		Destroy(var14_25:GetChild(iter3_25))
	end

	for iter4_25 = var14_25.childCount, var13_25.x - 1 do
		Instantiate(var15_25).transform:SetParent(var14_25, false)
	end

	for iter5_25 = 0, var13_25.x - 1 do
		setText(var14_25:GetChild(iter5_25), string.char(string.byte("A") + iter5_25))
	end

	local var17_25 = var6_25:Find("123")
	local var18_25 = var17_25:GetChild(0)
	local var19_25 = var17_25:GetComponent(typeof(GridLayoutGroup))

	var19_25.cellSize = Vector2(var1_25.cellSize.x, var1_25.cellSize.y)
	var19_25.spacing = Vector2(var1_25.cellSpace.x, var1_25.cellSpace.y)
	var19_25.padding.top = var1_25.cellSpace.y

	for iter6_25 = var17_25.childCount - 1, var13_25.y, -1 do
		Destroy(var17_25:GetChild(iter6_25))
	end

	for iter7_25 = var17_25.childCount, var13_25.y - 1 do
		Instantiate(var18_25).transform:SetParent(var17_25, false)
	end

	for iter8_25 = 0, var13_25.y - 1 do
		setText(var17_25:GetChild(iter8_25), 1 + iter8_25)
	end

	local var20_25 = var6_25:Find("linev")
	local var21_25 = var20_25:GetChild(0)
	local var22_25 = var20_25:GetComponent(typeof(GridLayoutGroup))

	var22_25.cellSize = Vector2(ChapterConst.LineCross, var6_25.sizeDelta.y)
	var22_25.spacing = Vector2(var10_25.x - ChapterConst.LineCross, 0)
	var22_25.padding.left = math.floor(var22_25.spacing.x)

	for iter9_25 = var20_25.childCount - 1, math.max(var13_25.x - 1, 0), -1 do
		if iter9_25 > 0 then
			Destroy(var20_25:GetChild(iter9_25))
		end
	end

	for iter10_25 = var20_25.childCount, var13_25.x - 2 do
		Instantiate(var21_25).transform:SetParent(var20_25, false)
	end

	local var23_25 = var6_25:Find("lineh")
	local var24_25 = var23_25:GetChild(0)
	local var25_25 = var23_25:GetComponent(typeof(GridLayoutGroup))

	var25_25.cellSize = Vector2(var6_25.sizeDelta.x, ChapterConst.LineCross)
	var25_25.spacing = Vector2(0, var10_25.y - ChapterConst.LineCross)
	var25_25.padding.top = math.floor(var25_25.spacing.y)

	for iter11_25 = var23_25.childCount - 1, math.max(var13_25.y - 1, 0), -1 do
		if iter11_25 > 0 then
			Destroy(var23_25:GetChild(iter11_25))
		end
	end

	for iter12_25 = var23_25.childCount, var13_25.y - 2 do
		Instantiate(var24_25).transform:SetParent(var23_25, false)
	end

	local var26_25 = GetOrAddComponent(var6_25:Find("mask"), "RawImage")
	local var27_25 = var6_25:Find("seaBase/sea")

	if var1_25.seaBase and var1_25.seaBase ~= "" then
		setActive(var27_25, true)
		GetImageSpriteFromAtlasAsync("chapter/pic/" .. var1_25.seaBase, var1_25.seaBase, var27_25)

		var26_25.enabled = true
		var26_25.uvRect = UnityEngine.Rect.New(0, 0, 1, -1)
	else
		setActive(var27_25, false)

		var26_25.enabled = false
	end
end

function var0_0.updatePoisonArea(arg0_28)
	local var0_28 = arg0_28:findTF("plane/display/mask")
	local var1_28 = GetOrAddComponent(var0_28, "RawImage")

	if not var1_28.enabled then
		return
	end

	var1_28.texture = arg0_28:getPoisonTex()
end

function var0_0.getPoisonTex(arg0_29)
	local var0_29 = arg0_29.contextData.chapterVO
	local var1_29 = arg0_29:findTF("plane/display")
	local var2_29 = var1_29.sizeDelta.x / var1_29.sizeDelta.y
	local var3_29 = 256
	local var4_29 = math.floor(var3_29 / var2_29)
	local var5_29

	if arg0_29.preChapterId ~= var0_29.id then
		var5_29 = UnityEngine.Texture2D.New(var3_29, var4_29)
		arg0_29.maskTexture = var5_29
		arg0_29.preChapterId = var0_29.id
	else
		var5_29 = arg0_29.maskTexture
	end

	local var6_29 = {}
	local var7_29 = var0_29:getPoisonArea(var3_29 / var1_29.sizeDelta.x)

	if arg0_29.poisonRectDir == nil then
		var6_29 = var7_29
	else
		for iter0_29, iter1_29 in pairs(var7_29) do
			if arg0_29.poisonRectDir[iter0_29] == nil then
				var6_29[iter0_29] = iter1_29
			end
		end
	end

	local function var8_29(arg0_30)
		for iter0_30 = arg0_30.x, arg0_30.w + arg0_30.x do
			for iter1_30 = arg0_30.y, arg0_30.h + arg0_30.y do
				var5_29:SetPixel(iter0_30, iter1_30, Color.New(1, 1, 1, 0))
			end
		end
	end

	for iter2_29, iter3_29 in pairs(var6_29) do
		var8_29(iter3_29)
	end

	var5_29:Apply()

	arg0_29.poisonRectDir = var7_29

	return var5_29
end

function var0_0.showFleetPoisonDamage(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg0_31.contextData.chapterVO.fleets[arg1_31].id
	local var1_31 = arg0_31.cellFleets[var0_31]

	if var1_31 then
		var1_31:showPoisonDamage(arg2_31)
	end
end

function var0_0.clearPlane(arg0_32)
	arg0_32:killQuadTws()
	arg0_32:killPresentTws()
	arg0_32:ClearEdges()
	arg0_32:hideQuadMark()
	removeAllChildren(arg0_32.cellRoot)
	removeAllChildren(arg0_32.quadRoot)
	removeAllChildren(arg0_32.bottomMarkRoot)
	removeAllChildren(arg0_32.topMarkRoot)
	removeAllChildren(arg0_32.restrictMap)

	arg0_32.cellRoot = nil
	arg0_32.quadRoot = nil
	arg0_32.bottomMarkRoot = nil
	arg0_32.topMarkRoot = nil
	arg0_32.restrictMap = nil

	local var0_32 = arg0_32._tf:Find(ChapterConst.PlaneName)
	local var1_32 = var0_32:Find("display/seaBase/sea")

	clearImageSprite(var1_32)
	pg.PoolMgr.GetInstance():ReturnPrefab("chapter/plane", "", var0_32.gameObject)
end

function var0_0.initFleets(arg0_33, arg1_33)
	if arg0_33.cellFleets then
		existCall(arg1_33)

		return
	end

	local var0_33 = arg0_33.contextData.chapterVO

	arg0_33.cellFleets = {}

	table.ParallelIpairsAsync(var0_33.fleets, function(arg0_34, arg1_34, arg2_34)
		if arg1_34:getFleetType() == FleetType.Support then
			return arg2_34()
		end

		arg0_33:InitFleetCell(arg1_34.id, arg2_34)
	end, arg1_33)
end

function var0_0.InitFleetCell(arg0_35, arg1_35, arg2_35)
	local var0_35 = arg0_35.contextData.chapterVO
	local var1_35 = var0_35:getFleetById(arg1_35)

	if not var1_35:isValid() then
		existCall(arg2_35)

		return
	end

	local var2_35
	local var3_35 = arg0_35:getFleetPool(var1_35:getFleetType()):Dequeue()

	var3_35.transform.localEulerAngles = Vector3(-var0_35.theme.angle, 0, 0)

	setParent(var3_35, arg0_35.cellRoot, false)
	setActive(var3_35, true)

	local var4_35 = var1_35:getFleetType()
	local var5_35

	if var4_35 == FleetType.Transport then
		var5_35 = TransportCellView
	elseif var4_35 == FleetType.Submarine then
		var5_35 = SubCellView
	else
		var5_35 = FleetCellView
	end

	local var6_35 = var5_35.New(var3_35)

	var6_35.fleetType = var4_35

	if var4_35 == FleetType.Normal or var4_35 == FleetType.Submarine then
		var6_35:SetAction(ChapterConst.ShipIdleAction)
	end

	var6_35.tf.localPosition = var0_35.theme:GetLinePosition(var1_35.line.row, var1_35.line.column)
	arg0_35.cellFleets[arg1_35] = var6_35

	arg0_35:RefreshFleetCell(arg1_35, arg2_35)
end

function var0_0.RefreshFleetCells(arg0_36, arg1_36)
	if not arg0_36.cellFleets then
		arg0_36:initFleets(arg1_36)

		return
	end

	local var0_36 = arg0_36.contextData.chapterVO
	local var1_36 = {}

	for iter0_36, iter1_36 in pairs(arg0_36.cellFleets) do
		if not var0_36:getFleetById(iter0_36) then
			table.insert(var1_36, iter0_36)
		end
	end

	for iter2_36, iter3_36 in pairs(var1_36) do
		arg0_36:ClearFleetCell(iter3_36)
	end

	table.ParallelIpairsAsync(var0_36.fleets, function(arg0_37, arg1_37, arg2_37)
		if arg1_37:getFleetType() == FleetType.Support then
			return arg2_37()
		end

		if not arg0_36.cellFleets[arg1_37.id] then
			arg0_36:InitFleetCell(arg1_37.id, arg2_37)
		else
			arg0_36:RefreshFleetCell(arg1_37.id, arg2_37)
		end
	end, arg1_36)
end

function var0_0.RefreshFleetCell(arg0_38, arg1_38, arg2_38)
	local var0_38 = arg0_38.contextData.chapterVO
	local var1_38 = var0_38:getFleetById(arg1_38)
	local var2_38 = arg0_38.cellFleets[arg1_38]
	local var3_38
	local var4_38

	if var1_38:isValid() then
		if var1_38:getFleetType() == FleetType.Transport then
			var3_38 = var1_38:getPrefab()
		else
			local var5_38 = var0_38:getMapShip(var1_38)

			if var5_38 then
				var3_38 = var5_38:getPrefab()
				var4_38 = var5_38:getAttachmentPrefab()
			end
		end
	end

	if not var3_38 then
		arg0_38:ClearFleetCell(arg1_38)
		existCall(arg2_38)

		return
	end

	var2_38.go.name = "cell_fleet_" .. var3_38

	var2_38:SetLine(var1_38.line)

	if var2_38.fleetType == FleetType.Transport then
		var2_38:LoadIcon(var3_38, function()
			var2_38:GetRotatePivot().transform.localRotation = var1_38.rotation

			arg0_38:updateFleet(arg1_38, arg2_38)
		end)
	else
		var2_38:LoadSpine(var3_38, nil, var4_38, function()
			var2_38:GetRotatePivot().transform.localRotation = var1_38.rotation

			arg0_38:updateFleet(arg1_38, arg2_38)
		end)
	end
end

function var0_0.clearFleets(arg0_41)
	if arg0_41.cellFleets then
		for iter0_41, iter1_41 in pairs(arg0_41.cellFleets) do
			arg0_41:ClearFleetCell(iter0_41)
		end

		arg0_41.cellFleets = nil
	end
end

function var0_0.ClearFleetCell(arg0_42, arg1_42)
	local var0_42 = arg0_42.cellFleets[arg1_42]

	if not var0_42 then
		return
	end

	var0_42:Clear()
	LeanTween.cancel(var0_42.go)
	setActive(var0_42.go, false)
	setParent(var0_42.go, arg0_42.poolParent, false)
	arg0_42:getFleetPool(var0_42.fleetType):Enqueue(var0_42.go, false)

	if arg0_42.opBtns[arg1_42] then
		Destroy(arg0_42.opBtns[arg1_42].gameObject)

		arg0_42.opBtns[arg1_42] = nil
	end

	arg0_42.cellFleets[arg1_42] = nil
end

function var0_0.UpdateFleets(arg0_43, arg1_43)
	local var0_43 = arg0_43.contextData.chapterVO

	table.ParallelIpairsAsync(var0_43.fleets, function(arg0_44, arg1_44, arg2_44)
		if arg1_44:getFleetType() == FleetType.Support then
			return arg2_44()
		end

		arg0_43:updateFleet(arg1_44.id, arg2_44)
	end, arg1_43)
end

function var0_0.updateFleet(arg0_45, arg1_45, arg2_45)
	local var0_45 = arg0_45.contextData.chapterVO
	local var1_45 = arg0_45.cellFleets[arg1_45]
	local var2_45 = var0_45:getFleetById(arg1_45)

	if var1_45 then
		local var3_45 = var2_45.line
		local var4_45 = var2_45:isValid()

		setActive(var1_45.go, var4_45)
		var1_45:RefreshLinePosition(var0_45, var3_45)

		local var5_45 = var2_45:getFleetType()

		if var5_45 == FleetType.Normal then
			local var6_45 = var0_45:GetEnemy(var3_45.row, var3_45.column)
			local var7_45 = tobool(var6_45)
			local var8_45 = var6_45 and var6_45.attachment or nil
			local var9_45 = var0_45:existFleet(FleetType.Transport, var3_45.row, var3_45.column)

			var1_45:SetSpineVisible(not var7_45 and not var9_45)

			local var10_45 = table.indexof(var0_45.fleets, var2_45) == var0_45.findex

			setActive(var1_45.tfArrow, var10_45)
			setActive(var1_45.tfOp, false)

			local var11_45 = arg0_45.opBtns[arg1_45]

			if not var11_45 then
				var11_45 = tf(Instantiate(var1_45.tfOp))
				var11_45.name = "op" .. arg1_45

				var11_45:SetParent(arg0_45._tf, false)

				var11_45.localEulerAngles = Vector3(-var0_45.theme.angle, 0, 0)

				local var12_45 = GetOrAddComponent(var11_45, typeof(Canvas))

				GetOrAddComponent(go(var11_45), typeof(GraphicRaycaster))

				var12_45.overrideSorting = true
				var12_45.sortingOrder = ChapterConst.PriorityMax
				arg0_45.opBtns[arg1_45] = var11_45

				arg0_45:UpdateOpBtns()
			end

			var11_45.position = var1_45.tfOp.position

			local var13_45 = var6_45 and ChapterConst.IsBossCell(var6_45)
			local var14_45 = false

			if var7_45 and var8_45 == ChapterConst.AttachChampion then
				local var15_45 = var0_45:getChampion(var3_45.row, var3_45.column):GetLastID()
				local var16_45 = pg.expedition_data_template[var15_45]

				if var16_45 then
					var14_45 = var16_45.ai == ChapterConst.ExpeditionAILair
				end
			end

			var13_45 = var13_45 or var14_45

			local var17_45 = _.any(var0_45.fleets, function(arg0_46)
				return arg0_46.id ~= var2_45.id and arg0_46:getFleetType() == FleetType.Normal and arg0_46:isValid()
			end)
			local var18_45 = var10_45 and var4_45 and var7_45
			local var19_45 = var11_45:Find("retreat")

			setActive(var19_45:Find("retreat"), var18_45 and not var13_45 and var17_45)
			setActive(var19_45:Find("escape"), var18_45 and var13_45)
			setActive(var19_45, var19_45:Find("retreat").gameObject.activeSelf or var19_45:Find("escape").gameObject.activeSelf)

			if var19_45.gameObject.activeSelf then
				onButton(arg0_45, var19_45, function()
					if arg0_45.parent:isfrozen() then
						return
					end

					if var13_45 then
						(function()
							local var0_48 = {
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

							for iter0_48, iter1_48 in ipairs(var0_48) do
								if var0_45:considerAsStayPoint(ChapterConst.SubjectPlayer, var3_45.row + iter1_48[1], var3_45.column + iter1_48[2]) and not var0_45:existEnemy(ChapterConst.SubjectPlayer, var3_45.row + iter1_48[1], var3_45.column + iter1_48[2]) then
									arg0_45:emit(LevelMediator2.ON_OP, {
										type = ChapterConst.OpMove,
										id = var2_45.id,
										arg1 = var3_45.row + iter1_48[1],
										arg2 = var3_45.column + iter1_48[2],
										ordLine = var2_45.line
									})

									return false
								end
							end

							pg.TipsMgr.GetInstance():ShowTips(i18n("no_way_to_escape"))

							return true
						end)()
					else
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = i18n("levelScene_who_to_retreat", var2_45.name),
							onYes = function()
								arg0_45:emit(LevelMediator2.ON_OP, {
									type = ChapterConst.OpRetreat,
									id = var2_45.id
								})
							end
						})
					end
				end, SFX_UI_WEIGHANCHOR_WITHDRAW)
			end

			local var20_45 = var11_45:Find("exchange")

			setActive(var20_45, false)
			setActive(var1_45.tfAmmo, not var9_45)

			local var21_45, var22_45 = var0_45:getFleetAmmo(var2_45)
			local var23_45 = var22_45 .. "/" .. var21_45

			if var22_45 == 0 then
				var23_45 = setColorStr(var23_45, COLOR_RED)
			end

			setText(var1_45.tfAmmoText, var23_45)

			if var7_45 or var9_45 then
				local var24_45 = var0_45:getChampion(var3_45.row, var3_45.column)

				if var7_45 and var8_45 == ChapterConst.AttachChampion and var24_45:getPoolType() == ChapterConst.TemplateChampion then
					var1_45.tfArrow.anchoredPosition = Vector2(0, 180)
					var1_45.tfAmmo.anchoredPosition = Vector2(60, 100)
				else
					var1_45.tfArrow.anchoredPosition = Vector2(0, 100)
					var1_45.tfAmmo.anchoredPosition = Vector2(22, 56)
				end

				var1_45.tfAmmo:SetAsLastSibling()
			else
				var1_45.tfArrow.anchoredPosition = Vector2(0, 175)
				var1_45.tfAmmo.anchoredPosition = Vector2(-60, 85)
			end

			if var1_45:GetSpineRole() and var10_45 and arg0_45.lastSelectedId ~= var2_45.id then
				if not var7_45 and not var9_45 and arg0_45.lastSelectedId ~= -1 then
					var1_45:TweenShining()
				end

				arg0_45.lastSelectedId = var2_45.id
			end

			local var25_45 = var0_45:existBarrier(var3_45.row, var3_45.column)

			var1_45:SetActiveNoPassIcon(var25_45)

			local var26_45 = table.contains(var2_45:GetStatusStrategy(), ChapterConst.StrategyIntelligenceRecorded)

			var1_45:UpdateIconRecordedFlag(var26_45)
		elseif var5_45 == FleetType.Submarine then
			local var27_45 = var0_45:existEnemy(ChapterConst.SubjectPlayer, var3_45.row, var3_45.column) or var0_45:existAlly(var2_45)
			local var28_45 = var0_45.subAutoAttack == 1

			var1_45:SetActiveModel(not var27_45 and var28_45)
			setActive(var1_45.tfAmmo, not var27_45)

			local var29_45, var30_45 = var0_45:getFleetAmmo(var2_45)
			local var31_45 = var30_45 .. "/" .. var29_45

			if var30_45 == 0 then
				var31_45 = setColorStr(var31_45, COLOR_RED)
			end

			setText(var1_45.tfAmmoText, var31_45)
		elseif var5_45 == FleetType.Transport then
			setText(var1_45.tfHpText, var2_45:getRestHp() .. "/" .. var2_45:getTotalHp())

			local var32_45 = var0_45:existEnemy(ChapterConst.SubjectPlayer, var3_45.row, var3_45.column)

			GetImageSpriteFromAtlasAsync("enemies/" .. var2_45:getPrefab(), "", var1_45.tfIcon, true)
			setActive(var1_45.tfFighting, var32_45)
		end
	end

	existCall(arg2_45)
end

function var0_0.UpdateOpBtns(arg0_50)
	table.Foreach(arg0_50.opBtns, function(arg0_51, arg1_51)
		setActive(arg1_51, arg0_50.quadState == ChapterConst.QuadStateNormal)
	end)
end

function var0_0.GetCellFleet(arg0_52, arg1_52)
	return arg0_52.cellFleets[arg1_52]
end

function var0_0.initTargetArrow(arg0_53)
	local var0_53 = arg0_53.contextData.chapterVO

	arg0_53.arrowTarget = cloneTplTo(arg0_53.arrowTpl, arg0_53._tf)

	local var1_53 = arg0_53.arrowTarget

	pg.ViewUtils.SetLayer(tf(var1_53), Layer.UI)

	GetOrAddComponent(var1_53, typeof(Canvas)).overrideSorting = true
	arg0_53.arrowTarget.localEulerAngles = Vector3(-var0_53.theme.angle, 0, 0)

	setActive(arg0_53.arrowTarget, false)
end

function var0_0.updateTargetArrow(arg0_54, arg1_54)
	local var0_54 = arg0_54.contextData.chapterVO
	local var1_54 = ChapterCell.Line2Name(arg1_54.row, arg1_54.column)
	local var2_54 = arg0_54.cellRoot:Find(var1_54)

	arg0_54.arrowTarget:SetParent(var2_54)

	local var3_54, var4_54 = (function()
		local var0_55, var1_55 = var0_54:existEnemy(ChapterConst.SubjectPlayer, arg1_54.row, arg1_54.column)

		if not var0_55 then
			return false
		end

		if var1_55 == ChapterConst.AttachChampion then
			local var2_55 = var0_54:getChampion(arg1_54.row, arg1_54.column)

			if not var2_55 then
				return false
			end

			return var2_55:getPoolType() == "common", var2_55:getScale() / 100
		elseif ChapterConst.IsEnemyAttach(var1_55) then
			local var3_55 = var0_54:getChapterCell(arg1_54.row, arg1_54.column)

			if not var3_55 or var3_55.flag ~= ChapterConst.CellFlagActive then
				return false
			end

			local var4_55 = pg.expedition_data_template[var3_55.attachmentId]

			return var4_55.icon_type == 2, var4_55.scale / 100
		end
	end)()

	if var3_54 then
		arg0_54.arrowTarget.localPosition = Vector3(0, 20 + 80 * var4_54, -80 * var4_54)
	else
		arg0_54.arrowTarget.localPosition = Vector3(0, 20, 0)
	end

	local var5_54 = arg0_54.arrowTarget:GetComponent(typeof(Canvas))

	if var5_54 then
		var5_54.sortingOrder = arg1_54.row * ChapterConst.PriorityPerRow + ChapterConst.CellPriorityTopMark
	end
end

function var0_0.clearTargetArrow(arg0_56)
	if not IsNil(arg0_56.arrowTarget) then
		Destroy(arg0_56.arrowTarget)

		arg0_56.arrowTarget = nil
	end
end

function var0_0.InitDestinationMark(arg0_57)
	local var0_57 = cloneTplTo(arg0_57.destinationMarkTpl, arg0_57._tf)

	pg.ViewUtils.SetLayer(tf(var0_57), Layer.UI)

	GetOrAddComponent(var0_57, typeof(Canvas)).overrideSorting = true

	setActive(var0_57, false)

	local var1_57 = arg0_57.contextData.chapterVO

	tf(var0_57).localEulerAngles = Vector3(-var1_57.theme.angle, 0, 0)
	arg0_57.destinationMark = tf(var0_57)
end

function var0_0.UpdateDestinationMark(arg0_58, arg1_58)
	if not arg1_58 then
		arg0_58.destinationMark:SetParent(arg0_58._tf)
		setActive(go(arg0_58.destinationMark), false)

		return
	end

	setActive(go(arg0_58.destinationMark), true)

	local var0_58 = ChapterCell.Line2Name(arg1_58.row, arg1_58.column)
	local var1_58 = arg0_58.cellRoot:Find(var0_58)

	arg0_58.destinationMark:SetParent(var1_58)

	arg0_58.destinationMark.localPosition = Vector3(0, 40, -40)

	local var2_58 = arg0_58.destinationMark:GetComponent(typeof(Canvas))

	if var2_58 then
		var2_58.sortingOrder = arg1_58.row * ChapterConst.PriorityPerRow + ChapterConst.CellPriorityTopMark
	end
end

function var0_0.ClearDestinationMark(arg0_59)
	if not IsNil(arg0_59.destinationMark) then
		Destroy(arg0_59.destinationMark)

		arg0_59.destinationMark = nil
	end
end

function var0_0.initChampions(arg0_60, arg1_60)
	if arg0_60.cellChampions then
		existCall(arg1_60)

		return
	end

	arg0_60.cellChampions = {}

	local var0_60 = arg0_60.contextData.chapterVO

	table.ParallelIpairsAsync(var0_60.champions, function(arg0_61, arg1_61, arg2_61)
		arg0_60.cellChampions[arg0_61] = false

		if arg1_61.flag ~= ChapterConst.CellFlagDisabled then
			arg0_60:InitChampion(arg0_61, arg2_61)
		else
			arg2_61()
		end
	end, arg1_60)
end

function var0_0.InitChampion(arg0_62, arg1_62, arg2_62)
	local var0_62 = arg0_62.contextData.chapterVO
	local var1_62 = var0_62.champions[arg1_62]
	local var2_62 = var1_62:getPoolType()
	local var3_62 = arg0_62:getChampionPool(var2_62):Dequeue()

	var3_62.name = "cell_champion_" .. var1_62:getPrefab()
	var3_62.transform.localEulerAngles = Vector3(-var0_62.theme.angle, 0, 0)

	setParent(var3_62, arg0_62.cellRoot, false)
	setActive(var3_62, true)

	local var4_62

	if var2_62 == ChapterConst.TemplateChampion then
		var4_62 = DynamicChampionCellView
	elseif var2_62 == ChapterConst.TemplateEnemy then
		var4_62 = DynamicEggCellView
	elseif var2_62 == ChapterConst.TemplateOni then
		var4_62 = OniCellView
	end

	local var5_62 = var4_62.New(var3_62)

	arg0_62.cellChampions[arg1_62] = var5_62

	var5_62:SetLine({
		row = var1_62.row,
		column = var1_62.column
	})
	var5_62:SetPoolType(var2_62)

	if var5_62.GetRotatePivot then
		tf(var5_62:GetRotatePivot()).localRotation = var1_62.rotation
	end

	if var2_62 == ChapterConst.TemplateChampion then
		var5_62:SetAction(ChapterConst.ShipIdleAction)

		if var1_62.flag == ChapterConst.CellFlagDiving then
			var5_62:SetAction(ChapterConst.ShipSwimAction)
		end

		var5_62:LoadSpine(var1_62:getPrefab(), var1_62:getScale(), var1_62:getConfig("effect_prefab"), function()
			arg0_62:updateChampion(arg1_62, arg2_62)
		end)
	elseif var2_62 == ChapterConst.TemplateEnemy then
		var5_62:LoadIcon(var1_62:getPrefab(), var1_62:getConfigTable(), function()
			arg0_62:updateChampion(arg1_62, arg2_62)
		end)
	elseif var2_62 == ChapterConst.TemplateOni then
		arg0_62:updateChampion(arg1_62, arg2_62)
	end
end

function var0_0.updateChampions(arg0_65, arg1_65)
	table.ParallelIpairsAsync(arg0_65.cellChampions, function(arg0_66, arg1_66, arg2_66)
		arg0_65:updateChampion(arg0_66, arg2_66)
	end, arg1_65)
end

function var0_0.updateChampion(arg0_67, arg1_67, arg2_67)
	local var0_67 = arg0_67.contextData.chapterVO
	local var1_67 = arg0_67.cellChampions[arg1_67]
	local var2_67 = var0_67.champions[arg1_67]

	if var1_67 and var2_67 then
		var1_67:UpdateChampionCell(var0_67, var2_67, arg2_67)
	end
end

function var0_0.updateOni(arg0_68)
	local var0_68 = arg0_68.contextData.chapterVO
	local var1_68

	for iter0_68, iter1_68 in ipairs(var0_68.champions) do
		if iter1_68.attachment == ChapterConst.AttachOni then
			var1_68 = iter0_68

			break
		end
	end

	if var1_68 then
		arg0_68:updateChampion(var1_68)
	end
end

function var0_0.clearChampions(arg0_69)
	if arg0_69.cellChampions then
		for iter0_69, iter1_69 in ipairs(arg0_69.cellChampions) do
			if iter1_69 then
				iter1_69:Clear()
				LeanTween.cancel(iter1_69.go)
				setActive(iter1_69.go, false)
				setParent(iter1_69.go, arg0_69.poolParent, false)
				arg0_69:getChampionPool(iter1_69:GetPoolType()):Enqueue(iter1_69.go, false)
			end
		end

		arg0_69.cellChampions = nil
	end
end

function var0_0.initCell(arg0_70, arg1_70, arg2_70)
	local var0_70 = arg0_70.contextData.chapterVO
	local var1_70 = var0_70:getChapterCell(arg1_70, arg2_70)

	if var1_70 then
		local var2_70 = var0_70.theme.cellSize
		local var3_70 = ChapterCell.Line2QuadName(arg1_70, arg2_70)
		local var4_70

		if var1_70:IsWalkable() then
			PoolMgr.GetInstance():GetPrefab("chapter/cell_quad", "", false, function(arg0_71)
				var4_70 = arg0_71.transform
			end)

			var4_70.name = var3_70

			var4_70:SetParent(arg0_70.quadRoot, false)

			var4_70.sizeDelta = var2_70
			var4_70.anchoredPosition = var0_70.theme:GetLinePosition(arg1_70, arg2_70)

			var4_70:SetAsLastSibling()
			onButton(arg0_70, var4_70, function()
				if arg0_70:isfrozen() then
					return
				end

				arg0_70:ClickGridCell(var1_70)
			end, SFX_CONFIRM)
		end

		local var5_70 = ChapterCell.Line2Name(arg1_70, arg2_70)
		local var6_70

		PoolMgr.GetInstance():GetPrefab("chapter/cell", "", false, function(arg0_73)
			var6_70 = arg0_73.transform
		end)

		var6_70.name = var5_70

		var6_70:SetParent(arg0_70.cellRoot, false)

		var6_70.sizeDelta = var2_70
		var6_70.anchoredPosition = var0_70.theme:GetLinePosition(arg1_70, arg2_70)

		var6_70:SetAsLastSibling()

		local var7_70 = var6_70:Find(ChapterConst.ChildItem)

		var7_70.localEulerAngles = Vector3(-var0_70.theme.angle, 0, 0)

		setActive(var7_70, var1_70.item)

		local var8_70 = ItemCell.New(var7_70, arg1_70, arg2_70)

		arg0_70.itemCells[ChapterCell.Line2Name(arg1_70, arg2_70)] = var8_70
		var8_70.loader = arg0_70.loader

		var8_70:Init(var1_70)

		var6_70:Find(ChapterConst.ChildAttachment).localEulerAngles = Vector3(-var0_70.theme.angle, 0, 0)
	end
end

function var0_0.clearCell(arg0_74, arg1_74, arg2_74)
	local var0_74 = ChapterCell.Line2Name(arg1_74, arg2_74)
	local var1_74 = ChapterCell.Line2QuadName(arg1_74, arg2_74)
	local var2_74 = arg0_74.cellRoot:Find(var0_74)
	local var3_74 = arg0_74.quadRoot:Find(var1_74)

	if not IsNil(var2_74) then
		PoolMgr.GetInstance():ReturnPrefab("chapter/cell", "", var2_74.gameObject)
	end

	if not IsNil(var3_74) then
		if arg0_74.quadTws[var1_74] then
			LeanTween.cancel(arg0_74.quadTws[var1_74].uniqueId)

			arg0_74.quadTws[var1_74] = nil
		end

		local var4_74 = var3_74:Find("grid"):GetComponent(typeof(Image))

		var4_74.sprite = GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid")
		var4_74.material = nil

		PoolMgr.GetInstance():ReturnPrefab("chapter/cell_quad", "", var3_74.gameObject)
	end
end

function var0_0.UpdateItemCells(arg0_75)
	local var0_75 = arg0_75.contextData.chapterVO

	if not var0_75 then
		return
	end

	for iter0_75, iter1_75 in pairs(arg0_75.itemCells) do
		local var1_75 = iter1_75:GetOriginalInfo()
		local var2_75 = var1_75 and var1_75.item
		local var3_75 = ItemCell.TransformItemAsset(var0_75, var2_75)

		iter1_75:UpdateAsset(var3_75)
	end
end

function var0_0.updateAttachments(arg0_76)
	for iter0_76 = 0, ChapterConst.MaxRow - 1 do
		for iter1_76 = 0, ChapterConst.MaxColumn - 1 do
			arg0_76:updateAttachment(iter0_76, iter1_76)
		end
	end

	arg0_76:updateExtraAttachments()
	arg0_76:updateCoastalGunAttachArea()
	arg0_76:displayEscapeGrid()
end

function var0_0.UpdateFloor(arg0_77)
	local var0_77 = arg0_77.contextData.chapterVO
	local var1_77 = var0_77.cells
	local var2_77 = {}

	for iter0_77, iter1_77 in pairs(var1_77) do
		local var3_77 = iter1_77:GetFlagList()

		for iter2_77, iter3_77 in pairs(var3_77) do
			var2_77[iter3_77] = var2_77[iter3_77] or {}

			table.insert(var2_77[iter3_77], iter1_77)
		end
	end

	if var2_77[ChapterConst.FlagBanaiAirStrike] and next(var2_77[ChapterConst.FlagBanaiAirStrike]) then
		arg0_77:hideQuadMark(ChapterConst.MarkBanaiAirStrike)
		arg0_77:showQuadMark(var2_77[ChapterConst.FlagBanaiAirStrike], ChapterConst.MarkBanaiAirStrike, "cell_coastal_gun", Vector2(110, 110), nil, true)
	end

	arg0_77:updatePoisonArea()

	if var2_77[ChapterConst.FlagLava] and next(var2_77[ChapterConst.FlagLava]) then
		arg0_77:hideQuadMark(ChapterConst.MarkLava)
		arg0_77:showQuadMark(var2_77[ChapterConst.FlagLava], ChapterConst.MarkLava, "cell_lava", Vector2(110, 110), nil, true)
	end

	if var2_77[ChapterConst.FlagNightmare] and next(var2_77[ChapterConst.FlagNightmare]) then
		arg0_77:hideQuadMark(ChapterConst.MarkNightMare)
		arg0_77:hideQuadMark(ChapterConst.MarkHideNight)

		local var4_77 = var0_77:getExtraFlags()[1]

		if var4_77 == ChapterConst.StatusDay then
			arg0_77:showQuadMark(var2_77[ChapterConst.FlagNightmare], ChapterConst.MarkHideNight, "cell_hidden_nightmare", Vector2(110, 110), nil, true)
		elseif var4_77 == ChapterConst.StatusNight then
			arg0_77:showQuadMark(var2_77[ChapterConst.FlagNightmare], ChapterConst.MarkNightMare, "cell_nightmare", Vector2(110, 110), nil, true)
		end
	end

	local var5_77 = {}

	for iter4_77, iter5_77 in pairs(var0_77:GetChapterCellAttachemnts()) do
		if iter5_77.data == ChapterConst.StoryTrigger then
			local var6_77 = pg.map_event_template[iter5_77.attachmentId]

			assert(var6_77, "map_event_template not exists " .. iter5_77.attachmentId)

			if var6_77 and var6_77.c_type == ChapterConst.EvtType_AdditionalFloor then
				var5_77[var6_77.icon] = var5_77[var6_77.icon] or {}

				table.insert(var5_77[var6_77.icon], iter5_77)
			end
		end
	end

	for iter6_77, iter7_77 in pairs(var5_77) do
		arg0_77:hideQuadMark(iter6_77)
		arg0_77:showQuadMark(iter7_77, iter6_77, iter6_77, Vector2(110, 110), nil, true)
	end

	local var7_77 = var0_77:getConfig("alarm_cell")

	if var7_77 and #var7_77 > 0 then
		local var8_77 = var7_77[3]

		arg0_77:ClearEdges(var8_77)
		arg0_77:ClearEdges(var8_77 .. "corner")
		arg0_77:AddEdgePool(var8_77, "chapter/celltexture/" .. var8_77, "")
		arg0_77:AddEdgePool(var8_77 .. "_corner", "chapter/celltexture/" .. var8_77 .. "_corner", "")

		local var9_77 = _.map(var7_77[1], function(arg0_78)
			return {
				row = arg0_78[1],
				column = arg0_78[2]
			}
		end)

		arg0_77:AddOutlines(var9_77, nil, var7_77[5], var7_77[4], var8_77)

		local var10_77 = var7_77[2]

		arg0_77:hideQuadMark(var10_77)
		arg0_77:showQuadMark(var9_77, var10_77, var10_77, Vector2(104, 104), nil, true)
	end

	arg0_77:HideMissileAimingMarks()

	if var2_77[ChapterConst.FlagMissleAiming] and next(var2_77[ChapterConst.FlagMissleAiming]) then
		arg0_77:ShowMissileAimingMarks(var2_77[ChapterConst.FlagMissleAiming])
	end

	arg0_77:UpdateWeatherCells()

	local var11_77 = var0_77.fleet

	if var0_77:isPlayingWithBombEnemy() then
		local var12_77 = _.map({
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
		}, function(arg0_79)
			return {
				row = arg0_79[1] + var11_77.line.row,
				column = arg0_79[2] + var11_77.line.column
			}
		end)

		arg0_77:showQuadMark(var12_77, ChapterConst.MarkBomb, "cell_bomb", Vector2(100, 100), nil, true)
	end
end

function var0_0.updateExtraAttachments(arg0_80)
	local var0_80 = arg0_80.contextData.chapterVO
	local var1_80 = var0_80:GetChapterCellAttachemnts()

	for iter0_80, iter1_80 in pairs(var1_80) do
		local var2_80 = iter1_80.row
		local var3_80 = iter1_80.column
		local var4_80 = arg0_80.cellRoot:Find(iter0_80):Find(ChapterConst.ChildAttachment)
		local var5_80 = pg.map_event_template[iter1_80.attachmentId]
		local var6_80 = iter1_80.data
		local var7_80

		if var6_80 == ChapterConst.StoryTrigger and var5_80.c_type ~= ChapterConst.EvtType_AdditionalFloor then
			var7_80 = MapEventStoryTriggerCellView
		end

		local var8_80 = arg0_80.extraAttachmentCells[iter0_80]

		if var8_80 and var8_80.class ~= var7_80 then
			var8_80:Clear()

			var8_80 = nil
			arg0_80.extraAttachmentCells[iter0_80] = nil
		end

		if var7_80 then
			if not var8_80 then
				var8_80 = var7_80.New(var4_80)
				arg0_80.extraAttachmentCells[iter0_80] = var8_80
			end

			var8_80.info = iter1_80
			var8_80.chapter = var0_80

			var8_80:SetLine({
				row = var2_80,
				column = var3_80
			})
			var8_80:Update()
		end
	end
end

function var0_0.updateAttachment(arg0_81, arg1_81, arg2_81)
	local var0_81 = arg0_81.contextData.chapterVO
	local var1_81 = var0_81:getChapterCell(arg1_81, arg2_81)

	if not var1_81 then
		return
	end

	local var2_81 = ChapterCell.Line2Name(arg1_81, arg2_81)
	local var3_81 = arg0_81.cellRoot:Find(var2_81):Find(ChapterConst.ChildAttachment)
	local var4_81
	local var5_81 = {}

	if ChapterConst.IsEnemyAttach(var1_81.attachment) then
		local var6_81 = pg.expedition_data_template[var1_81.attachmentId]

		assert(var6_81, "expedition_data_template not exist: " .. var1_81.attachmentId)

		if var1_81.flag == ChapterConst.CellFlagDisabled then
			if var1_81.attachment ~= ChapterConst.AttachAmbush then
				var4_81 = EnemyDeadCellView
				var5_81.chapter = var0_81
				var5_81.config = var6_81
			end
		elseif var1_81.flag == ChapterConst.CellFlagActive then
			var4_81 = var6_81.icon_type == 1 and StaticEggCellView or StaticChampionCellView
			var5_81.config = var6_81
			var5_81.chapter = var0_81
			var5_81.viewParent = arg0_81
		end
	elseif var1_81.attachment == ChapterConst.AttachBox then
		var4_81 = AttachmentBoxCell
	elseif var1_81.attachment == ChapterConst.AttachSupply then
		var4_81 = AttachmentSupplyCell
	elseif var1_81.attachment == ChapterConst.AttachTransport_Target then
		var4_81 = AttachmentTransportTargetCell
	elseif var1_81.attachment == ChapterConst.AttachStory then
		if var1_81.data == ChapterConst.Story then
			var4_81 = MapEventStoryCellView
		elseif var1_81.data == ChapterConst.StoryObstacle then
			var4_81 = MapEventStoryObstacleCellView
			var5_81.chapter = var0_81
		end
	elseif var1_81.attachment == ChapterConst.AttachBomb_Enemy then
		var4_81 = AttachmentBombEnemyCell
	elseif var1_81.attachment == ChapterConst.AttachLandbase then
		local var7_81 = pg.land_based_template[var1_81.attachmentId]

		assert(var7_81, "land_based_template not exist: " .. var1_81.attachmentId)

		if var7_81.type == ChapterConst.LBCoastalGun then
			var4_81 = AttachmentLBCoastalGunCell
		elseif var7_81.type == ChapterConst.LBHarbor then
			var4_81 = AttachmentLBHarborCell
		elseif var7_81.type == ChapterConst.LBDock then
			var4_81 = AttachmentLBDockCell
			var5_81.chapter = var0_81
		elseif var7_81.type == ChapterConst.LBAntiAir then
			var4_81 = AttachmentLBAntiAirCell
			var5_81.info = var1_81
			var5_81.chapter = var0_81
			var5_81.grid = arg0_81
		elseif var7_81.type == ChapterConst.LBIdle and var1_81.attachmentId == ChapterConst.LBIDAirport then
			var4_81 = AttachmentLBAirport
			var5_81.extraFlagList = var0_81:getExtraFlags()
		end
	elseif var1_81.attachment == ChapterConst.AttachBarrier then
		var4_81 = AttachmentBarrierCell
	elseif var1_81.attachment == ChapterConst.AttachNone then
		var5_81.fadeAnim = (function()
			local var0_82 = arg0_81.attachmentCells[var2_81]

			if not var0_82 then
				return
			end

			if var0_82.class ~= StaticEggCellView and var0_82.class ~= StaticChampionCellView then
				return
			end

			local var1_82 = var0_82.info

			if not var1_82 then
				return
			end

			return pg.expedition_data_template[var1_82.attachmentId].dungeon_id == 0
		end)()
	end

	if var5_81.fadeAnim then
		arg0_81:PlayAttachmentEffect(arg1_81, arg2_81, "miwuxiaosan")
	end

	local var8_81 = arg0_81.attachmentCells[var2_81]

	if var8_81 and var8_81.class ~= var4_81 then
		var8_81:Clear()

		var8_81 = nil
		arg0_81.attachmentCells[var2_81] = nil
	end

	if var4_81 then
		if not var8_81 then
			var8_81 = var4_81.New(var3_81)

			var8_81:SetLine({
				row = arg1_81,
				column = arg2_81
			})

			arg0_81.attachmentCells[var2_81] = var8_81
		end

		var8_81.info = var1_81

		for iter0_81, iter1_81 in pairs(var5_81) do
			var8_81[iter0_81] = iter1_81
		end

		var8_81:Update()
	end
end

function var0_0.InitWalls(arg0_83)
	local var0_83 = arg0_83.contextData.chapterVO

	for iter0_83 = arg0_83.indexMin.x, arg0_83.indexMax.x do
		for iter1_83 = arg0_83.indexMin.y, arg0_83.indexMax.y do
			local var1_83 = var0_83:GetRawChapterCell(iter0_83, iter1_83)

			if var1_83 then
				local var2_83 = ChapterConst.ForbiddenUp

				while var2_83 > 0 do
					arg0_83:InitWallDirection(var1_83, var2_83)

					var2_83 = var2_83 / 2
				end
			end
		end
	end

	for iter2_83, iter3_83 in pairs(arg0_83.walls) do
		if iter3_83.WallPrefabs then
			iter3_83:SetAsset(iter3_83.WallPrefabs[5 - iter3_83.BanCount])
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

function var0_0.InitWallDirection(arg0_84, arg1_84, arg2_84)
	local var0_84 = arg0_84.contextData.chapterVO

	if bit.band(arg1_84.forbiddenDirections, arg2_84) == 0 then
		return
	end

	if arg1_84.walkable == false then
		return
	end

	local var1_84 = var3_0[arg2_84]
	local var2_84 = 2 * arg1_84.row + var1_84[1]
	local var3_84 = 2 * arg1_84.column + var1_84[2]
	local var4_84 = var0_84:GetRawChapterCell(arg1_84.row + var1_84[1], arg1_84.column + var1_84[2])
	local var5_84 = not var4_84 or var4_84.walkable == false
	local var6_84 = var2_84 .. "_" .. var3_84
	local var7_84 = arg0_84.walls[var6_84]

	if not var7_84 then
		local var8_84 = var0_84.theme:GetLinePosition(arg1_84.row, arg1_84.column)

		var8_84.x = var8_84.x + var1_84[2] * (var0_84.theme.cellSize.x + var0_84.theme.cellSpace.x) * 0.5
		var8_84.y = var8_84.y - var1_84[1] * (var0_84.theme.cellSize.y + var0_84.theme.cellSpace.y) * 0.5

		local var9_84 = WallCell.New(var2_84, var3_84, bit.band(arg2_84, ChapterConst.ForbiddenRow) > 0, var8_84)

		var9_84.girdParent = arg0_84
		arg0_84.walls[var6_84] = var9_84
		var7_84 = var9_84

		local var10_84 = var0_84.wallAssets[arg1_84.row .. "_" .. arg1_84.column]

		if var10_84 then
			var7_84.WallPrefabs = var10_84
		end
	end

	var7_84.BanCount = var7_84.BanCount + (var5_84 and 2 or 1)
end

function var0_0.UpdateWeatherCells(arg0_85)
	local var0_85 = arg0_85.contextData.chapterVO

	for iter0_85, iter1_85 in pairs(var0_85.cells) do
		local var1_85
		local var2_85 = iter1_85:GetWeatherFlagList()

		if #var2_85 > 0 then
			var1_85 = MapWeatherCellView
		end

		local var3_85 = arg0_85.weatherCells[iter0_85]

		if var3_85 and var3_85.class ~= var1_85 then
			var3_85:Clear()

			var3_85 = nil
			arg0_85.weatherCells[iter0_85] = nil
		end

		if var1_85 then
			if not var3_85 then
				local var4_85 = arg0_85.cellRoot:Find(iter0_85):Find(ChapterConst.ChildAttachment)

				var3_85 = var1_85.New(var4_85)

				var3_85:SetLine({
					row = iter1_85.row,
					column = iter1_85.column
				})

				arg0_85.weatherCells[iter0_85] = var3_85
			end

			var3_85.info = iter1_85

			var3_85:Update(var2_85)
		end
	end
end

function var0_0.updateQuadCells(arg0_86, arg1_86)
	arg1_86 = arg1_86 or ChapterConst.QuadStateNormal
	arg0_86.quadState = arg1_86

	arg0_86:updateQuadBase()

	if arg1_86 == ChapterConst.QuadStateNormal then
		arg0_86:UpdateQuadStateNormal()
	elseif arg1_86 == ChapterConst.QuadStateBarrierSetting then
		arg0_86:UpdateQuadStateBarrierSetting()
	elseif arg1_86 == ChapterConst.QuadStateTeleportSub then
		arg0_86:UpdateQuadStateTeleportSub()
	elseif arg1_86 == ChapterConst.QuadStateMissileStrike or arg1_86 == ChapterConst.QuadStateAirSuport then
		arg0_86:UpdateQuadStateMissileStrike()
	elseif arg1_86 == ChapterConst.QuadStateExpel then
		arg0_86:UpdateQuadStateAirExpel()
	end

	arg0_86:UpdateOpBtns()
end

function var0_0.PlayQuadsParallelAnim(arg0_87, arg1_87)
	arg0_87:frozen()
	table.ParallelIpairsAsync(arg1_87, function(arg0_88, arg1_88, arg2_88)
		local var0_88 = ChapterCell.Line2QuadName(arg1_88.row, arg1_88.column)
		local var1_88 = arg0_87.quadRoot:Find(var0_88)

		arg0_87:cancelQuadTween(var0_88, var1_88)
		setImageAlpha(var1_88, 0.4)

		local var2_88 = LeanTween.scale(var1_88, Vector3.one, 0.2):setFrom(Vector3.zero):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(arg2_88))

		arg0_87.presentTws[var0_88] = {
			uniqueId = var2_88.uniqueId
		}
	end, function()
		arg0_87:unfrozen()
	end)
end

function var0_0.updateQuadBase(arg0_90)
	local var0_90 = arg0_90.contextData.chapterVO

	if var0_90.fleet == nil then
		return
	end

	arg0_90:killPresentTws()

	local function var1_90(arg0_91)
		if not arg0_91 or not arg0_91:IsWalkable() then
			return
		end

		local var0_91 = arg0_91.row
		local var1_91 = arg0_91.column
		local var2_91 = ChapterCell.Line2QuadName(var0_91, var1_91)
		local var3_91 = arg0_90.quadRoot:Find(var2_91)

		var3_91.localScale = Vector3.one

		local var4_91 = var3_91:Find("grid"):GetComponent(typeof(Image))
		local var5_91 = var0_90:getChampion(var0_91, var1_91)

		if var5_91 and var5_91.flag == ChapterConst.CellFlagActive and var5_91.trait ~= ChapterConst.TraitLurk and var0_90:getChampionVisibility(var5_91) and not var0_90:existFleet(FleetType.Transport, var0_91, var1_91) then
			arg0_90:startQuadTween(var2_91, var3_91)
			setImageSprite(var3_91, GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_enemy"))
			setImageSprite(var3_91:Find("grid"), GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_enemy_grid"))

			var4_91.material = arg0_90.material_Add

			return
		end

		local var6_91 = var0_90:GetRawChapterAttachemnt(var0_91, var1_91)

		if var6_91 then
			local var7_91 = var0_90:getQuadCellPic(var6_91)

			if var7_91 then
				arg0_90:startQuadTween(var2_91, var3_91)
				setImageSprite(var3_91, GetSpriteFromAtlas("chapter/pic/cellgrid", var7_91))

				return
			end
		end

		if var0_90:getChapterCell(var0_91, var1_91) then
			local var8_91 = var0_90:getQuadCellPic(arg0_91)

			if var8_91 then
				arg0_90:startQuadTween(var2_91, var3_91)

				if var8_91 == "cell_enemy" then
					setImageSprite(var3_91:Find("grid"), GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_enemy_grid"))

					var4_91.material = arg0_90.material_Add
				else
					setImageSprite(var3_91:Find("grid"), GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid"))

					var4_91.material = nil
				end

				setImageSprite(var3_91, GetSpriteFromAtlas("chapter/pic/cellgrid", var8_91))

				return
			end
		end

		arg0_90:cancelQuadTween(var2_91, var3_91)
		setImageAlpha(var3_91, ChapterConst.CellEaseOutAlpha)
		setImageSprite(var3_91, GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_normal"))
		setImageSprite(var3_91:Find("grid"), GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid"))

		var4_91.material = nil
	end

	for iter0_90, iter1_90 in pairs(var0_90.cells) do
		var1_90(iter1_90)
	end

	if var0_90:isPlayingWithBombEnemy() then
		arg0_90:hideQuadMark(ChapterConst.MarkBomb)
	end
end

function var0_0.UpdateQuadStateNormal(arg0_92)
	local var0_92 = arg0_92.contextData.chapterVO
	local var1_92 = var0_92.fleet
	local var2_92

	if var0_92:existMoveLimit() and not var0_92:checkAnyInteractive() then
		var2_92 = var0_92:calcWalkableCells(ChapterConst.SubjectPlayer, var1_92.line.row, var1_92.line.column, var1_92:getSpeed())
	end

	if not var2_92 or #var2_92 == 0 then
		return
	end

	local var3_92 = _.min(var2_92, function(arg0_93)
		return ManhattonDist(arg0_93, var1_92.line)
	end)
	local var4_92 = ManhattonDist(var3_92, var1_92.line)

	_.each(var2_92, function(arg0_94)
		local var0_94 = ChapterCell.Line2QuadName(arg0_94.row, arg0_94.column)
		local var1_94 = arg0_92.quadRoot:Find(var0_94)

		arg0_92:cancelQuadTween(var0_94, var1_94)
		setImageSprite(var1_94, GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_normal"))

		local var2_94 = var1_94:Find("grid"):GetComponent(typeof(Image))

		var2_94.sprite = GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid")
		var2_94.material = nil

		local var3_94 = var0_92:getRound() == ChapterConst.RoundPlayer

		setImageAlpha(var1_94, var3_94 and 1 or ChapterConst.CellEaseOutAlpha)

		var1_94.localScale = Vector3.zero

		local var4_94 = LeanTween.scale(var1_94, Vector3.one, 0.2):setFrom(Vector3.zero):setEase(LeanTweenType.easeInOutSine):setDelay((ManhattonDist(arg0_94, var1_92.line) - var4_92) * 0.1)

		arg0_92.presentTws[var0_94] = {
			uniqueId = var4_94.uniqueId
		}
	end)
end

function var0_0.UpdateQuadStateBarrierSetting(arg0_95)
	local var0_95 = 1
	local var1_95 = arg0_95.contextData.chapterVO
	local var2_95 = var1_95.fleet
	local var3_95 = var2_95.line
	local var4_95 = var1_95:calcSquareBarrierCells(var3_95.row, var3_95.column, var0_95)

	if not var4_95 or #var4_95 == 0 then
		return
	end

	local var5_95 = _.min(var4_95, function(arg0_96)
		return ManhattonDist(arg0_96, var2_95.line)
	end)
	local var6_95 = ManhattonDist(var5_95, var2_95.line)

	_.each(var4_95, function(arg0_97)
		local var0_97 = ChapterCell.Line2QuadName(arg0_97.row, arg0_97.column)
		local var1_97 = arg0_95.quadRoot:Find(var0_97)

		arg0_95:cancelQuadTween(var0_97, var1_97)
		setImageSprite(var1_97, GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_barrier_select"))

		local var2_97 = var1_97:Find("grid"):GetComponent(typeof(Image))

		var2_97.sprite = GetSpriteFromAtlas("chapter/pic/cellgrid", "cell_grid")
		var2_97.material = nil

		setImageAlpha(var1_97, 1)

		var1_97.localScale = Vector3.zero

		local var3_97 = LeanTween.scale(var1_97, Vector3.one, 0.2):setFrom(Vector3.zero):setEase(LeanTweenType.easeInOutSine):setDelay((ManhattonDist(arg0_97, var2_95.line) - var6_95) * 0.1)

		arg0_95.presentTws[var0_97] = {
			uniqueId = var3_97.uniqueId
		}
	end)
end

function var0_0.UpdateQuadStateTeleportSub(arg0_98)
	local var0_98 = arg0_98.contextData.chapterVO
	local var1_98 = _.detect(var0_98.fleets, function(arg0_99)
		return arg0_99:getFleetType() == FleetType.Submarine
	end)

	if not var1_98 then
		return
	end

	local var2_98 = var0_98:calcWalkableCells(nil, var1_98.line.row, var1_98.line.column, ChapterConst.MaxStep)
	local var3_98 = _.filter(var2_98, function(arg0_100)
		return not var0_98:getQuadCellPic(var0_98:getChapterCell(arg0_100.row, arg0_100.column))
	end)

	arg0_98:PlayQuadsParallelAnim(var3_98)
end

function var0_0.UpdateQuadStateMissileStrike(arg0_101)
	local var0_101 = arg0_101.contextData.chapterVO
	local var1_101 = _.filter(_.values(var0_101.cells), function(arg0_102)
		return arg0_102:IsWalkable() and not var0_101:getQuadCellPic(arg0_102)
	end)

	arg0_101:PlayQuadsParallelAnim(var1_101)
end

function var0_0.UpdateQuadStateAirExpel(arg0_103)
	local var0_103 = arg0_103.contextData.chapterVO
	local var1_103 = arg0_103.airSupportTarget

	if not var1_103 or not var1_103.source then
		local var2_103 = _.filter(_.values(var0_103.cells), function(arg0_104)
			return arg0_104:IsWalkable() and not var0_103:getQuadCellPic(arg0_104)
		end)

		arg0_103:PlayQuadsParallelAnim(var2_103)

		return
	end

	local var3_103 = var1_103.source
	local var4_103 = var0_103:calcWalkableCells(ChapterConst.SubjectChampion, var3_103.row, var3_103.column, 1)

	arg0_103:PlayQuadsParallelAnim(var4_103)
end

function var0_0.ClickGridCell(arg0_105, arg1_105)
	if arg0_105.quadState == ChapterConst.QuadStateBarrierSetting then
		arg0_105:OnBarrierSetting(arg1_105)
	elseif arg0_105.quadState == ChapterConst.QuadStateTeleportSub then
		arg0_105:OnTeleportConfirm(arg1_105)
	elseif arg0_105.quadState == ChapterConst.QuadStateMissileStrike then
		arg0_105:OnMissileAiming(arg1_105)
	elseif arg0_105.quadState == ChapterConst.QuadStateAirSuport then
		arg0_105:OnAirSupportAiming(arg1_105)
	elseif arg0_105.quadState == ChapterConst.QuadStateExpel then
		arg0_105:OnAirExpelSelect(arg1_105)
	else
		arg0_105:emit(LevelUIConst.ON_CLICK_GRID_QUAD, arg1_105)
	end
end

function var0_0.OnBarrierSetting(arg0_106, arg1_106)
	local var0_106 = 1
	local var1_106 = arg0_106.contextData.chapterVO
	local var2_106 = var1_106.fleet.line
	local var3_106 = var1_106:calcSquareBarrierCells(var2_106.row, var2_106.column, var0_106)

	if not _.any(var3_106, function(arg0_107)
		return arg0_107.row == arg1_106.row and arg0_107.column == arg1_106.column
	end) then
		return
	end

	;(function(arg0_108, arg1_108)
		newChapterVO = arg0_106.contextData.chapterVO

		if not newChapterVO:existBarrier(arg0_108, arg1_108) and newChapterVO.modelCount <= 0 then
			return
		end

		arg0_106:emit(LevelMediator2.ON_OP, {
			type = ChapterConst.OpBarrier,
			id = newChapterVO.fleet.id,
			arg1 = arg0_108,
			arg2 = arg1_108
		})
	end)(arg1_106.row, arg1_106.column)
end

function var0_0.PrepareSubTeleport(arg0_109)
	local var0_109 = arg0_109.contextData.chapterVO
	local var1_109 = var0_109:GetSubmarineFleet()
	local var2_109 = arg0_109.cellFleets[var1_109.id]
	local var3_109 = var1_109.startPos

	for iter0_109, iter1_109 in pairs(var0_109.fleets) do
		if iter1_109:getFleetType() == FleetType.Normal then
			arg0_109:updateFleet(iter1_109.id)
		end
	end

	local var4_109 = var0_109:existEnemy(ChapterConst.SubjectPlayer, var3_109.row, var3_109.column) or var0_109:existFleet(FleetType.Normal, var3_109.row, var3_109.column)

	setActive(var2_109.tfAmmo, not var4_109)
	var2_109:SetActiveModel(true)

	if not (var0_109.subAutoAttack == 1) then
		arg0_109:PlaySubAnimation(var2_109, false, function()
			var2_109:SetActiveModel(not var4_109)
		end)
	else
		var2_109:SetActiveModel(not var4_109)
	end

	var2_109.tf.localPosition = var0_109.theme:GetLinePosition(var3_109.row, var3_109.column)

	var2_109:ResetCanvasOrder()
end

function var0_0.TurnOffSubTeleport(arg0_111)
	arg0_111.subTeleportTargetLine = nil

	local var0_111 = arg0_111.contextData.chapterVO

	arg0_111:hideQuadMark(ChapterConst.MarkMovePathArrow)
	arg0_111:hideQuadMark(ChapterConst.MarkHuntingRange)
	arg0_111:ClearEdges("SubmarineHunting")
	arg0_111:UpdateDestinationMark()

	local var1_111 = var0_111:GetSubmarineFleet()
	local var2_111 = arg0_111.cellFleets[var1_111.id]
	local var3_111 = var0_111.subAutoAttack == 1

	var2_111:SetActiveModel(var3_111)

	if not var3_111 then
		arg0_111:PlaySubAnimation(var2_111, true, function()
			arg0_111:updateFleet(var1_111.id)
		end)
	else
		arg0_111:updateFleet(var1_111.id)
	end

	arg0_111:ShowHuntingRange()
end

function var0_0.OnTeleportConfirm(arg0_113, arg1_113)
	local var0_113 = arg0_113.contextData.chapterVO
	local var1_113 = var0_113:getChapterCell(arg1_113.row, arg1_113.column)

	if var1_113 and var1_113:IsWalkable() and not var0_113:existBarrier(arg1_113.row, arg1_113.column) then
		local var2_113 = var0_113:GetSubmarineFleet()

		if var2_113.startPos.row == arg1_113.row and var2_113.startPos.column == arg1_113.column then
			return
		end

		local var3_113, var4_113 = var0_113:findPath(nil, var2_113.startPos, arg1_113)

		if var3_113 >= PathFinding.PrioObstacle or arg1_113.row ~= var4_113[#var4_113].row or arg1_113.column ~= var4_113[#var4_113].column then
			return
		end

		arg0_113:ShowTargetHuntingRange(arg1_113)
		arg0_113:UpdateDestinationMark(arg1_113)

		if var3_113 > 0 then
			arg0_113:ShowPathInArrows(var4_113)

			arg0_113.subTeleportTargetLine = arg1_113
		end
	end
end

function var0_0.ShowPathInArrows(arg0_114, arg1_114)
	local var0_114 = arg0_114.contextData.chapterVO
	local var1_114 = Clone(arg1_114)

	table.remove(var1_114, #var1_114)

	for iter0_114 = #var1_114, 1, -1 do
		local var2_114 = var1_114[iter0_114]

		if var0_114:existEnemy(ChapterConst.SubjectPlayer, var2_114.row, var2_114.column) or var0_114:getFleet(FleetType.Normal, var2_114.row, var2_114.column) then
			table.remove(var1_114, iter0_114)
		end
	end

	arg0_114:hideQuadMark(ChapterConst.MarkMovePathArrow)
	arg0_114:showQuadMark(var1_114, ChapterConst.MarkMovePathArrow, "cell_path_arrow", Vector2(100, 100), nil, true)

	local var3_114 = arg0_114.markQuads[ChapterConst.MarkMovePathArrow]

	for iter1_114 = #arg1_114, 1, -1 do
		local var4_114 = arg1_114[iter1_114]
		local var5_114 = ChapterCell.Line2MarkName(var4_114.row, var4_114.column, ChapterConst.MarkMovePathArrow)
		local var6_114 = var3_114 and var3_114[var5_114]

		if var6_114 then
			local var7_114 = arg1_114[iter1_114 + 1]
			local var8_114 = Vector3.Normalize(Vector3(var7_114.column - var4_114.column, var4_114.row - var7_114.row, 0))
			local var9_114 = Vector3.Dot(var8_114, Vector3.up)
			local var10_114 = Mathf.Acos(var9_114) * Mathf.Rad2Deg
			local var11_114 = Vector3.Cross(Vector3.up, var8_114).z > 0 and 1 or -1

			var6_114.localEulerAngles = Vector3(0, 0, var10_114 * var11_114)
		end
	end
end

function var0_0.ShowMissileAimingMarks(arg0_115, arg1_115)
	_.each(arg1_115, function(arg0_116)
		arg0_115.loader:GetPrefabBYGroup("ui/miaozhun02", "miaozhun02", function(arg0_117)
			setParent(arg0_117, arg0_115.restrictMap)

			local var0_117 = arg0_115.contextData.chapterVO.theme:GetLinePosition(arg0_116.row, arg0_116.column)
			local var1_117 = arg0_115.restrictMap.anchoredPosition

			tf(arg0_117).anchoredPosition = Vector2(var0_117.x - var1_117.x, var0_117.y - var1_117.y)
		end, "MissileAimingMarks")
	end)
end

function var0_0.HideMissileAimingMarks(arg0_118)
	arg0_118.loader:ReturnGroup("MissileAimingMarks")
end

function var0_0.ShowMissileAimingMark(arg0_119, arg1_119)
	arg0_119.loader:GetPrefab("ui/miaozhun02", "miaozhun02", function(arg0_120)
		setParent(arg0_120, arg0_119.restrictMap)

		local var0_120 = arg0_119.contextData.chapterVO.theme:GetLinePosition(arg1_119.row, arg1_119.column)
		local var1_120 = arg0_119.restrictMap.anchoredPosition

		tf(arg0_120).anchoredPosition = Vector2(var0_120.x - var1_120.x, var0_120.y - var1_120.y)
	end, "MissileAimingMark")
end

function var0_0.HideMissileAimingMark(arg0_121)
	arg0_121.loader:ClearRequest("MissileAimingMark")
end

function var0_0.OnMissileAiming(arg0_122, arg1_122)
	arg0_122:HideMissileAimingMark()
	arg0_122:ShowMissileAimingMark(arg1_122)

	arg0_122.missileStrikeTargetLine = arg1_122
end

function var0_0.ShowAirSupportAimingMark(arg0_123, arg1_123)
	arg0_123.loader:GetPrefab("ui/miaozhun03", "miaozhun03", function(arg0_124)
		setParent(arg0_124, arg0_123.restrictMap)

		local var0_124 = arg0_123.contextData.chapterVO.theme:GetLinePosition(arg1_123.row - 0.5, arg1_123.column)
		local var1_124 = arg0_123.restrictMap.anchoredPosition

		tf(arg0_124).anchoredPosition = Vector2(var0_124.x - var1_124.x, var0_124.y - var1_124.y)
	end, "AirSupportAimingMark")
end

function var0_0.HideAirSupportAimingMark(arg0_125)
	arg0_125.loader:ClearRequest("AirSupportAimingMark")
end

function var0_0.OnAirSupportAiming(arg0_126, arg1_126)
	arg0_126:HideAirSupportAimingMark()
	arg0_126:ShowAirSupportAimingMark(arg1_126)

	arg0_126.missileStrikeTargetLine = arg1_126
end

function var0_0.ShowAirExpelAimingMark(arg0_127)
	local var0_127 = arg0_127.airSupportTarget

	if not var0_127 or not var0_127.source then
		return
	end

	local var1_127 = var0_127.source
	local var2_127 = ChapterCell.Line2Name(var1_127.row, var1_127.column)
	local var3_127 = arg0_127.cellRoot:Find(var2_127)

	local function var4_127(arg0_128, arg1_128)
		setParent(arg0_128, var3_127)

		GetOrAddComponent(arg0_128, typeof(Canvas)).overrideSorting = true

		if not arg1_128 then
			return
		end

		local var0_128 = arg0_127.contextData.chapterVO

		tf(arg0_128).localEulerAngles = Vector3(-var0_128.theme.angle, 0, 0)
	end

	arg0_127.loader:GetPrefabBYGroup("leveluiview/tpl_airsupportmark", "tpl_airsupportmark", function(arg0_129)
		var4_127(arg0_129, true)
	end, "AirExpelAimingMark")
	arg0_127.loader:GetPrefabBYGroup("leveluiview/tpl_airsupportdirection", "tpl_airsupportdirection", function(arg0_130)
		var4_127(arg0_130)

		local var0_130 = arg0_127.contextData.chapterVO
		local var1_130 = {
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

		for iter0_130 = 1, 4 do
			local var2_130 = tf(arg0_130):Find(iter0_130)
			local var3_130 = var0_127 and var0_130:considerAsStayPoint(ChapterConst.SubjectChampion, var1_127.row + var1_130[iter0_130][1], var1_127.column + var1_130[iter0_130][2])

			setActive(var2_130, var3_130)
		end
	end, "AirExpelAimingMark")
end

function var0_0.HideAirExpelAimingMark(arg0_131)
	arg0_131.loader:ReturnGroup("AirExpelAimingMark")
end

function var0_0.OnAirExpelSelect(arg0_132, arg1_132)
	local var0_132 = arg0_132.contextData.chapterVO

	local function var1_132()
		arg0_132:HideAirExpelAimingMark()
		arg0_132:ShowAirExpelAimingMark()
		arg0_132:updateQuadBase()
		arg0_132:UpdateQuadStateAirExpel()
	end

	arg0_132.airSupportTarget = arg0_132.airSupportTarget or {}

	local var2_132 = arg0_132.airSupportTarget
	local var3_132 = var0_132:GetEnemy(arg1_132.row, arg1_132.column)

	if var3_132 then
		if ChapterConst.IsBossCell(var3_132) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_select_boss"))

			return
		end

		if var0_132:existFleet(FleetType.Normal, arg1_132.row, arg1_132.column) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_select_battle"))

			return
		end

		if var2_132.source and table.equal(var2_132.source:GetLine(), var3_132:GetLine()) then
			var3_132 = nil
		end

		var2_132.source = var3_132

		var1_132()
	elseif not var2_132.source then
		pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_select_enemy"))
	elseif ManhattonDist(var2_132.source, arg1_132) > 1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_outrange"))
	elseif not var0_132:considerAsStayPoint(ChapterConst.SubjectChampion, arg1_132.row, arg1_132.column) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("levelscene_airexpel_outrange"))
	else
		local var4_132 = arg0_132.airSupportTarget.source
		local var5_132 = arg1_132

		if not var4_132 or not var5_132 then
			return
		end

		local var6_132 = {
			arg1_132.row - var4_132.row,
			arg1_132.column - var4_132.column
		}
		local var7_132 = {
			"up",
			"right",
			"down",
			"left"
		}
		local var8_132

		if var6_132[1] ~= 0 then
			var8_132 = var6_132[1] + 2
		else
			var8_132 = 3 - var6_132[2]
		end

		local var9_132 = var7_132[var8_132]
		local var10_132 = var0_132:getChapterSupportFleet()

		local function var11_132()
			arg0_132:emit(LevelMediator2.ON_OP, {
				type = ChapterConst.OpStrategy,
				id = var10_132.id,
				arg1 = ChapterConst.StrategyExpel,
				arg2 = var4_132.row,
				arg3 = var4_132.column,
				arg4 = var5_132.row,
				arg5 = var5_132.column
			})
		end

		local var12_132 = var4_132.attachmentId
		local var13_132 = pg.expedition_data_template[var12_132].name

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("levelscene_airexpel_select_confirm_" .. var9_132, var13_132),
			onYes = var11_132
		})
	end
end

function var0_0.CleanAirSupport(arg0_135)
	arg0_135.airSupportTarget = nil
end

function var0_0.startQuadTween(arg0_136, arg1_136, arg2_136, arg3_136, arg4_136)
	if arg0_136.presentTws[arg1_136] then
		LeanTween.cancel(arg0_136.presentTws[arg1_136].uniqueId)

		arg0_136.presentTws[arg1_136] = nil
	end

	if not arg0_136.quadTws[arg1_136] then
		arg3_136 = arg3_136 or 1
		arg4_136 = arg4_136 or ChapterConst.CellEaseOutAlpha

		setImageAlpha(arg2_136, arg3_136)

		local var0_136 = LeanTween.alpha(arg2_136, arg4_136, 1):setLoopPingPong()

		arg0_136.quadTws[arg1_136] = {
			tw = var0_136,
			uniqueId = var0_136.uniqueId
		}
	end
end

function var0_0.cancelQuadTween(arg0_137, arg1_137, arg2_137)
	if arg0_137.quadTws[arg1_137] then
		LeanTween.cancel(arg0_137.quadTws[arg1_137].uniqueId)

		arg0_137.quadTws[arg1_137] = nil
	end

	setImageAlpha(arg2_137, ChapterConst.CellEaseOutAlpha)
end

function var0_0.killQuadTws(arg0_138)
	for iter0_138, iter1_138 in pairs(arg0_138.quadTws) do
		LeanTween.cancel(iter1_138.uniqueId)
	end

	arg0_138.quadTws = {}
end

function var0_0.killPresentTws(arg0_139)
	for iter0_139, iter1_139 in pairs(arg0_139.presentTws) do
		LeanTween.cancel(iter1_139.uniqueId)
	end

	arg0_139.presentTws = {}
end

function var0_0.startMarkTween(arg0_140, arg1_140, arg2_140, arg3_140, arg4_140)
	if not arg0_140.markTws[arg1_140] then
		arg3_140 = arg3_140 or 1
		arg4_140 = arg4_140 or 0.2

		setImageAlpha(arg2_140, arg3_140)

		local var0_140 = LeanTween.alpha(arg2_140, arg4_140, 0.7):setLoopPingPong():setEase(LeanTweenType.easeInOutSine):setDelay(1)

		arg0_140.markTws[arg1_140] = {
			tw = var0_140,
			uniqueId = var0_140.uniqueId
		}
	end
end

function var0_0.cancelMarkTween(arg0_141, arg1_141, arg2_141, arg3_141)
	if arg0_141.markTws[arg1_141] then
		LeanTween.cancel(arg0_141.markTws[arg1_141].uniqueId)

		arg0_141.markTws[arg1_141] = nil
	end

	setImageAlpha(arg2_141, arg3_141 or ChapterConst.CellEaseOutAlpha)
end

function var0_0.moveFleet(arg0_142, arg1_142, arg2_142, arg3_142, arg4_142)
	local var0_142 = arg0_142.contextData.chapterVO
	local var1_142 = var0_142.fleet
	local var2_142 = var1_142.id
	local var3_142 = arg0_142.cellFleets[var2_142]

	var3_142:SetSpineVisible(true)
	setActive(var3_142.tfShadow, true)
	setActive(arg0_142.arrowTarget, true)
	arg0_142:updateTargetArrow(arg2_142[#arg2_142])

	if arg3_142 then
		arg0_142:updateAttachment(arg3_142.row, arg3_142.column)
	end

	local function var4_142(arg0_143)
		var1_142.step = var1_142.step + 1

		if arg0_142.onShipStepChange then
			arg0_142.onShipStepChange(arg0_143)
		end
	end

	local function var5_142(arg0_144)
		return
	end

	local function var6_142()
		setActive(arg0_142.arrowTarget, false)

		local var0_145 = var0_142.fleet.line
		local var1_145 = var0_142:getChapterCell(var0_145.row, var0_145.column)

		if ChapterConst.NeedClearStep(var1_145) then
			var1_142.step = 0
		end

		var1_142.rotation = var3_142:GetRotatePivot().transform.localRotation

		arg0_142:updateAttachment(var0_145.row, var0_145.column)
		arg0_142:updateFleet(var2_142)
		arg0_142:updateOni()

		local var2_145 = var0_142:getChampionIndex(var0_145.row, var0_145.column)

		if var2_145 then
			arg0_142:updateChampion(var2_145)
		end

		if arg0_142.onShipArrived then
			arg0_142.onShipArrived()
		end

		if arg4_142 then
			arg4_142()
		end
	end

	arg0_142:updateQuadCells(ChapterConst.QuadStateFrozen)
	arg0_142:moveCellView(var3_142, arg1_142, arg2_142, var4_142, var5_142, var6_142)
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
