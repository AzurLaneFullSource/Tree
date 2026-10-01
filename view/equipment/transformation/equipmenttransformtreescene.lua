local var0_0 = class("EquipmentTransformTreeScene", import("view.base.BaseUI"))
local var1_0 = require("Mgr/Pool/PoolPlural")
local var2_0 = "ui/EquipmentTransformTreeUI_atlas"

function var0_0.getUIName(arg0_1)
	return "EquipmentTransformTreeUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		var2_0,
		"weaponframes",
		"ui/iconcolorful"
	}

	table.insertto(var0_2, arg0_2:getEquipmentResList())

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.getEquipmentResList(arg0_3)
	local var0_3 = {}

	for iter0_3, iter1_3 in pairs(EquipmentProxy.EquipmentTransformTreeTemplate or {}) do
		for iter2_3, iter3_3 in pairs(iter1_3) do
			for iter4_3, iter5_3 in ipairs(iter3_3.equipments or {}) do
				local var1_3 = Equipment.getConfigData(iter5_3[3])

				if var1_3 and noEmptyStr(var1_3.icon) then
					table.insert(var0_3, ResPathSupport.CombinePath(ResPathSupport.ConstPath.Equipment.Equip, var1_3.icon))
				end
			end
		end
	end

	return var0_3
end

var0_0.optionsPath = {
	"blur_panel/adapt/top/option"
}
var0_0.MODE_NORMAL = 1
var0_0.MODE_HIDESIDE = 2

function var0_0.init(arg0_4)
	arg0_4.leftPanel = arg0_4._tf:Find("Adapt/Left")
	arg0_4.rightPanel = arg0_4._tf:Find("Adapt/Right")
	arg0_4.nationToggleGroup = arg0_4.leftPanel:Find("Nations"):Find("ViewPort/Content")

	setActive(arg0_4.nationToggleGroup:GetChild(0), false)
	arg0_4.nationToggleGroup:GetChild(0):Find("selectedCursor").gameObject:SetActive(false)

	arg0_4.equipmentTypeToggleGroup = arg0_4.leftPanel:Find("EquipmentTypes"):Find("ViewPort/Content")

	setActive(arg0_4.equipmentTypeToggleGroup:GetChild(0), false)
	arg0_4.equipmentTypeToggleGroup:GetChild(0):Find("selectedframe").gameObject:SetActive(false)

	arg0_4.TreeCanvas = arg0_4.rightPanel:Find("ViewPort/Content")

	setActive(arg0_4.rightPanel:Find("EquipNode"), false)
	setActive(arg0_4.rightPanel:Find("Link"), false)

	arg0_4.nodes = {}
	arg0_4.links = {}
	arg0_4.plurals = {
		EquipNode = var1_0.New(arg0_4.rightPanel:Find("EquipNode").gameObject, 5),
		Link = var1_0.New(arg0_4.rightPanel:Find("Link").gameObject, 8)
	}
	arg0_4.pluralRoot = pg.PoolMgr.GetInstance().root
	arg0_4.top = arg0_4._tf:Find("blur_panel")
	arg0_4.loader = AutoLoader.New()
end

function var0_0.GetEnv(arg0_5)
	arg0_5.env = arg0_5.env or {}

	return arg0_5.env
end

function var0_0.SetEnv(arg0_6, arg1_6)
	arg0_6.env = arg1_6
end

function var0_0.didEnter(arg0_7)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_7.top)
	onButton(arg0_7, arg0_7.top:Find("adapt/top/back"), function()
		arg0_7:closeView()
	end, SFX_CANCEL)

	if arg0_7.contextData.targetEquipId then
		local var0_7
		local var1_7
		local var2_7 = false

		for iter0_7, iter1_7 in pairs(arg0_7.env.nationsTree) do
			for iter2_7, iter3_7 in pairs(iter1_7) do
				for iter4_7, iter5_7 in ipairs(iter3_7.equipments) do
					if iter5_7[3] == arg0_7.contextData.targetEquipId then
						var0_7, var1_7 = iter0_7, iter2_7
						var2_7 = true

						break
					end
				end
			end

			if var2_7 then
				break
			end
		end

		if var2_7 then
			arg0_7.contextData.nation = var0_7
			arg0_7.contextData.equipmentTypeIndex = var1_7
		end

		arg0_7.contextData.targetEquipId = nil
	end

	arg0_7:InitPage()

	if arg0_7.contextData.mode == var0_0.MODE_HIDESIDE then
		setActive(arg0_7.leftPanel, false)

		local var3_7 = arg0_7.rightPanel.sizeDelta

		var3_7.x = 0
		arg0_7.rightPanel.sizeDelta = var3_7

		setAnchoredPosition(arg0_7.rightPanel, {
			x = 0
		})
	end
end

function var0_0.GetSortKeys(arg0_9)
	local var0_9 = _.keys(arg0_9)

	table.sort(var0_9, function(arg0_10, arg1_10)
		return arg0_10 < arg1_10
	end)

	return var0_9
end

function var0_0.GetSortTypes(arg0_11)
	local var0_11 = _.values(arg0_11)

	table.sort(var0_11, function(arg0_12, arg1_12)
		return arg0_12.id < arg1_12.id
	end)

	return _.map(var0_11, function(arg0_13)
		return arg0_13.category2
	end)
end

function var0_0.InitPage(arg0_14)
	arg0_14.firstInit = true

	local var0_14 = arg0_14.contextData
	local var1_14 = arg0_14.env

	var0_14.mode = var0_14.mode or var0_0.MODE_NORMAL

	local var2_14 = var0_14.nation
	local var3_14 = var0_0.GetSortKeys(var1_14.nationsTree)

	if not var2_14 or not table.contains(var3_14, var2_14) then
		var2_14 = var3_14[1]
	end

	if next(var1_14.nationsTree[var2_14]) == nil then
		for iter0_14 = 2, #var3_14 do
			if next(var1_14.nationsTree[var3_14[iter0_14]]) ~= nil then
				var2_14 = var3_14[iter0_14]

				break
			end
		end
	end

	var0_14.nation = nil

	arg0_14:UpdateNations()

	local var4_14 = table.indexof(var3_14, var2_14) or 1

	triggerButton(arg0_14.nationToggles[var4_14])

	arg0_14.firstInit = nil
end

function var0_0.UpdateNations(arg0_15)
	local var0_15 = var0_0.GetSortKeys(arg0_15.env.nationsTree)

	arg0_15.nationToggles = CustomIndexLayer.Clone2Full(arg0_15.nationToggleGroup, #var0_15)

	for iter0_15 = 1, #arg0_15.nationToggles do
		local var1_15 = arg0_15.nationToggles[iter0_15]
		local var2_15 = var0_15[iter0_15]

		arg0_15.loader:GetSprite(var2_0, "nation" .. var2_15 .. "_disable", var1_15:Find("selectedIcon"))
		setActive(var1_15:Find("selectedCursor"), false)
		onButton(arg0_15, var1_15, function()
			if arg0_15.contextData.nation ~= var2_15 then
				if next(arg0_15.env.nationsTree[var2_15]) == nil then
					pg.TipsMgr.GetInstance():ShowTips(i18n("word_comingSoon"))

					return
				end

				arg0_15.loader:GetSprite(var2_0, "nation" .. var2_15, var1_15:Find("selectedIcon"))

				if arg0_15.contextData.nation then
					local var0_16 = table.indexof(var0_15, arg0_15.contextData.nation)

					setActive(arg0_15.nationToggles[var0_16]:Find("selectedCursor"), false)
					arg0_15.loader:GetSprite(var2_0, "nation" .. arg0_15.contextData.nation .. "_disable", arg0_15.nationToggles[var0_16]:Find("selectedIcon"))
				end

				arg0_15.contextData.nation = var2_15

				arg0_15:UpdateEquipmentTypes()

				local var1_16 = var0_0.GetSortTypes(arg0_15.env.nationsTree[var2_15])
				local var2_16 = var1_16[1]

				if arg0_15.firstInit then
					local var3_16 = arg0_15.contextData.equipmentTypeIndex

					if var3_16 and table.contains(var1_16, var3_16) then
						var2_16 = var3_16
					end
				end

				arg0_15.contextData.equipmentTypeIndex = nil

				local var4_16 = table.indexof(var1_16, var2_16) or 1

				triggerToggle(arg0_15.equipmentTypeToggles[var4_16], true)
			end
		end, SFX_UI_TAG)
	end
end

function var0_0.UpdateEquipmentTypes(arg0_17)
	local var0_17 = var0_0.GetSortTypes(arg0_17.env.nationsTree[arg0_17.contextData.nation])

	arg0_17.equipmentTypeToggles = CustomIndexLayer.Clone2Full(arg0_17.equipmentTypeToggleGroup, #var0_17)

	for iter0_17 = 1, #arg0_17.equipmentTypeToggles do
		local var1_17 = arg0_17.equipmentTypeToggles[iter0_17]

		var1_17:GetComponent(typeof(Toggle)).isOn = false

		local var2_17 = var0_17[iter0_17]

		arg0_17.loader:GetSprite(var2_0, "equipmentType" .. var2_17, var1_17:Find("itemName"), true)
		setActive(var1_17:Find("selectedframe"), false)
		onToggle(arg0_17, var1_17, function(arg0_18)
			if arg0_18 and arg0_17.contextData.equipmentTypeIndex ~= var2_17 then
				arg0_17.contextData.equipmentTypeIndex = var2_17

				arg0_17:ResetCanvas()
			end

			setActive(var1_17:Find("selectedframe"), arg0_18)
		end, SFX_UI_TAG)
	end

	arg0_17.equipmentTypeToggleGroup.anchoredPosition = Vector2.zero
	arg0_17.leftPanel:Find("EquipmentTypes"):GetComponent(typeof(ScrollRect)).velocity = Vector2.zero
end

local var3_0 = {
	15,
	-4,
	15,
	6
}

function var0_0.ResetCanvas(arg0_19)
	local var0_19 = EquipmentProxy.EquipmentTransformTreeTemplate[arg0_19.contextData.nation][arg0_19.contextData.equipmentTypeIndex]

	assert(var0_19, "can't find Equip_upgrade_template Nation: " .. arg0_19.contextData.nation .. " Type: " .. arg0_19.contextData.equipmentTypeIndex)

	arg0_19.TreeCanvas.sizeDelta = Vector2(unpack(var0_19.canvasSize))
	arg0_19.TreeCanvas.anchoredPosition = Vector2.zero
	arg0_19.rightPanel:GetComponent(typeof(ScrollRect)).velocity = Vector2.zero

	arg0_19:ReturnCanvasItems()

	for iter0_19, iter1_19 in ipairs(var0_19.equipments) do
		local var1_19 = arg0_19.plurals.EquipNode:Dequeue()

		setActive(var1_19, true)
		setParent(var1_19, arg0_19.TreeCanvas)
		table.insert(arg0_19.nodes, {
			id = iter1_19[3],
			cfg = iter1_19,
			go = var1_19
		})

		var1_19.name = iter1_19[3]

		arg0_19:UpdateItemNode(tf(var1_19), iter1_19)
	end

	for iter2_19, iter3_19 in ipairs(var0_19.links) do
		for iter4_19 = 1, #iter3_19 - 1 do
			local var2_19 = iter3_19[iter4_19]
			local var3_19 = iter3_19[iter4_19 + 1]
			local var4_19 = {
				var3_19[1] - var2_19[1],
				var2_19[2] - var3_19[2]
			}
			local var5_19 = math.abs(var4_19[1]) > math.abs(var4_19[2])
			local var6_19 = var5_19 and math.abs(var4_19[1]) or math.abs(var4_19[2])

			if var5_19 then
				var4_19[2] = 0
			else
				var4_19[1] = 0
			end

			local var7_19 = 1 - math.sign(var4_19[1])

			var7_19 = var7_19 ~= 1 and var7_19 or 2 - math.sign(var4_19[2])

			local var8_19 = math.deg2Rad * 90 * var7_19

			if #iter3_19 == 2 then
				local var9_19 = arg0_19.plurals.Link:Dequeue()

				table.insert(arg0_19.links, go(var9_19))
				setActive(var9_19, true)
				setParent(var9_19, arg0_19.TreeCanvas)
				arg0_19.loader:GetSprite(var2_0, var4_19[2] == 0 and "wirehead" or "wireline", var9_19)

				tf(var9_19).sizeDelta = Vector2(28, 26)
				tf(var9_19).pivot = Vector2(0.5, 0.5)
				tf(var9_19).localRotation = Quaternion.Euler(0, 0, var7_19 * 90)

				local var10_19 = Vector2(math.cos(var8_19), math.sin(var8_19)) * var3_0[(var7_19 - 1) % 4 + 1]

				tf(var9_19).anchoredPosition = Vector2(var2_19[1] + var10_19.x, -var2_19[2] + var10_19.y)

				local var11_19 = arg0_19.plurals.Link:Dequeue()

				table.insert(arg0_19.links, go(var11_19))
				setActive(var11_19, true)
				setParent(var11_19, arg0_19.TreeCanvas)
				arg0_19.loader:GetSprite(var2_0, "wiretail", var11_19)

				tf(var11_19).sizeDelta = Vector2(28, 26)
				tf(var11_19).pivot = Vector2(0.5, 0.5)
				tf(var11_19).localRotation = Quaternion.Euler(0, 0, var7_19 * 90)

				local var12_19 = Vector2(math.cos(var8_19), math.sin(var8_19)) * -var3_0[(var7_19 + 1) % 4 + 1]

				tf(var11_19).anchoredPosition = Vector2(var3_19[1] + var12_19.x, -var3_19[2] + var12_19.y)

				local var13_19 = arg0_19.plurals.Link:Dequeue()

				table.insert(arg0_19.links, go(var13_19))
				setActive(var13_19, true)
				setParent(var13_19, arg0_19.TreeCanvas)
				arg0_19.loader:GetSprite(var2_0, "wireline", var13_19)

				tf(var13_19).sizeDelta = Vector2(math.max(0, var6_19 - var3_0[(var7_19 - 1) % 4 + 1] - var3_0[(var7_19 + 1) % 4 + 1] - 28), 16)
				tf(var13_19).pivot = Vector2(0, 0.5)
				tf(var13_19).localRotation = Quaternion.Euler(0, 0, var7_19 * 90)

				local var14_19 = Vector2(math.cos(var8_19), math.sin(var8_19)) * 14

				tf(var13_19).anchoredPosition = Vector2(var2_19[1] + var10_19.x, -var2_19[2] + var10_19.y) + var14_19

				break
			end

			local var15_19 = arg0_19.plurals.Link:Dequeue()

			table.insert(arg0_19.links, go(var15_19))
			setActive(var15_19, true)
			setParent(var15_19, arg0_19.TreeCanvas)

			local var16_19 = 1

			if iter4_19 == 1 then
				arg0_19.loader:GetSprite(var2_0, var4_19[2] == 0 and "wirehead" or "wireline", var15_19)

				local var17_19 = var6_19 + 14 + var16_19 - var3_0[(var7_19 - 1) % 4 + 1]

				tf(var15_19).sizeDelta = Vector2(var17_19, 26)
				tf(var15_19).pivot = Vector2((var17_19 - var16_19) / var17_19, 0.5)
				tf(var15_19).localRotation = Quaternion.Euler(0, 0, var7_19 * 90)
				tf(var15_19).anchoredPosition = Vector2(var3_19[1], -var3_19[2])
			elseif iter4_19 + 1 == #iter3_19 then
				arg0_19.loader:GetSprite(var2_0, "wiretail", var15_19)

				tf(var15_19).sizeDelta = Vector2(var6_19 + 14 + var16_19 - var3_0[(var7_19 + 1) % 4 + 1], 26)
				tf(var15_19).pivot = Vector2(var16_19 / (var6_19 + 14 + var16_19 - var3_0[(var7_19 + 1) % 4 + 1]), 0.5)
				tf(var15_19).localRotation = Quaternion.Euler(0, 0, var7_19 * 90)
				tf(var15_19).anchoredPosition = Vector2(var2_19[1], -var2_19[2])
			else
				arg0_19.loader:GetSprite(var2_0, "wireline", var15_19)

				tf(var15_19).sizeDelta = Vector2(var6_19 + var16_19 * 2, 16)
				tf(var15_19).pivot = Vector2(var16_19 / (var6_19 + var16_19 * 2), 0.5)
				tf(var15_19).localRotation = Quaternion.Euler(0, 0, var7_19 * 90)
				tf(var15_19).anchoredPosition = Vector2(var2_19[1], -var2_19[2])
			end
		end
	end
end

function var0_0.UpdateItemNode(arg0_20, arg1_20, arg2_20)
	arg1_20 = tf(arg1_20)
	arg1_20.anchoredPosition = Vector2(arg2_20[1], -arg2_20[2])

	updateDrop(arg1_20:Find("Item"), {
		id = arg2_20[3],
		type = DROP_TYPE_EQUIP
	})
	onButton(arg0_20, arg1_20:Find("Item"), function()
		local var0_21 = EquipmentProxy.GetTransformSources(arg2_20[3])[1]

		if not var0_21 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_initial_node"))

			return
		end

		arg0_20:emit(EquipmentTransformTreeMediator.OPEN_LAYER, Context.New({
			mediator = EquipmentTransformMediator,
			viewComponent = EquipmentTransformLayer,
			data = {
				formulaId = var0_21
			}
		}))
	end, SFX_PANEL)
	arg1_20:Find("Mask/NameText"):GetComponent("ScrollText"):SetText(Equipment.getConfigData(arg2_20[3]).name)

	local var0_20 = arg0_20.env.tracebackHelper:GetSortedEquipTraceBack(arg2_20[3])
	local var1_20 = _.any(var0_20, function(arg0_22)
		local var0_22 = arg0_22.candicates

		return var0_22 and #var0_22 > 0 and EquipmentTransformUtil.CheckTransformFormulasSucceed(arg0_22.formulas, var0_22[#var0_22])
	end)

	setActive(arg1_20:Find("cratfable"), var1_20)
	onButton(arg0_20, arg1_20:Find("cratfable"), function()
		arg0_20:emit(EquipmentTransformTreeMediator.OPEN_LAYER, Context.New({
			mediator = EquipmentTraceBackMediator,
			viewComponent = EquipmentTraceBackLayer,
			data = {
				TargetEquipmentId = arg2_20[3]
			}
		}))
	end)

	local var2_20 = arg2_20[4] and PlayerPrefs.GetInt("ShowTransformTip_" .. arg2_20[3], 0) == 0

	setActive(arg1_20:Find("Item/new"), var2_20)
end

function var0_0.UpdateItemNodes(arg0_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.nodes) do
		arg0_24:UpdateItemNode(iter1_24.go, iter1_24.cfg)
	end
end

function var0_0.UpdateItemNodeByID(arg0_25, arg1_25)
	for iter0_25, iter1_25 in ipairs(arg0_25.nodes) do
		if arg1_25 == iter1_25.id then
			arg0_25:UpdateItemNode(iter1_25.go, iter1_25.cfg)

			break
		end
	end
end

function var0_0.ReturnCanvasItems(arg0_26, arg1_26)
	for iter0_26, iter1_26 in ipairs(arg0_26.nodes) do
		if not arg0_26.plurals.EquipNode:Enqueue(iter1_26.go, arg1_26) then
			setParent(iter1_26.go, arg0_26.pluralRoot)
		end
	end

	table.clean(arg0_26.nodes)

	for iter2_26, iter3_26 in ipairs(arg0_26.links) do
		if not arg0_26.plurals.Link:Enqueue(iter3_26, arg1_26) then
			setParent(iter3_26, arg0_26.pluralRoot)
		end
	end

	table.clean(arg0_26.links)
end

function var0_0.willExit(arg0_27)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_27.top, arg0_27._tf)
	arg0_27:ReturnCanvasItems(true)

	for iter0_27, iter1_27 in pairs(arg0_27.plurals) do
		iter1_27:Clear()
	end

	arg0_27.loader:Clear()
end

return var0_0
