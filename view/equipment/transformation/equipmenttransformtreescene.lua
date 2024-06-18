local var0_0 = class("EquipmentTransformTreeScene", import("view.base.BaseUI"))
local var1_0 = require("Mgr/Pool/PoolPlural")
local var2_0 = "ui/EquipmentTransformTreeUI_atlas"

function var0_0.getUIName(arg0_1)
	return "EquipmentTransformTreeUI"
end

var0_0.optionsPath = {
	"blur_panel/adapt/top/option"
}
var0_0.MODE_NORMAL = 1
var0_0.MODE_HIDESIDE = 2

function var0_0.init(arg0_2)
	arg0_2.leftPanel = arg0_2._tf:Find("Adapt/Left")
	arg0_2.rightPanel = arg0_2._tf:Find("Adapt/Right")
	arg0_2.nationToggleGroup = arg0_2.leftPanel:Find("Nations"):Find("ViewPort/Content")

	setActive(arg0_2.nationToggleGroup:GetChild(0), false)
	arg0_2.nationToggleGroup:GetChild(0):Find("selectedCursor").gameObject:SetActive(false)

	arg0_2.equipmentTypeToggleGroup = arg0_2.leftPanel:Find("EquipmentTypes"):Find("ViewPort/Content")

	setActive(arg0_2.equipmentTypeToggleGroup:GetChild(0), false)
	arg0_2.equipmentTypeToggleGroup:GetChild(0):Find("selectedframe").gameObject:SetActive(false)

	arg0_2.TreeCanvas = arg0_2.rightPanel:Find("ViewPort/Content")

	setActive(arg0_2.rightPanel:Find("EquipNode"), false)
	setActive(arg0_2.rightPanel:Find("Link"), false)

	arg0_2.nodes = {}
	arg0_2.links = {}
	arg0_2.plurals = {
		EquipNode = var1_0.New(arg0_2.rightPanel:Find("EquipNode").gameObject, 5),
		Link = var1_0.New(arg0_2.rightPanel:Find("Link").gameObject, 8)
	}
	arg0_2.pluralRoot = pg.PoolMgr.GetInstance().root
	arg0_2.top = arg0_2._tf:Find("blur_panel")
	arg0_2.loader = AutoLoader.New()
end

function var0_0.GetEnv(arg0_3)
	arg0_3.env = arg0_3.env or {}

	return arg0_3.env
end

function var0_0.SetEnv(arg0_4, arg1_4)
	arg0_4.env = arg1_4
end

function var0_0.didEnter(arg0_5)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_5.top)
	onButton(arg0_5, arg0_5.top:Find("adapt/top/back"), function()
		arg0_5:closeView()
	end, SFX_CANCEL)

	if arg0_5.contextData.targetEquipId then
		local var0_5
		local var1_5
		local var2_5 = false

		for iter0_5, iter1_5 in pairs(arg0_5.env.nationsTree) do
			for iter2_5, iter3_5 in pairs(iter1_5) do
				for iter4_5, iter5_5 in ipairs(iter3_5.equipments) do
					if iter5_5[3] == arg0_5.contextData.targetEquipId then
						var0_5, var1_5 = iter0_5, iter2_5
						var2_5 = true

						break
					end
				end
			end

			if var2_5 then
				break
			end
		end

		if var2_5 then
			arg0_5.contextData.nation = var0_5
			arg0_5.contextData.equipmentTypeIndex = var1_5
		end

		arg0_5.contextData.targetEquipId = nil
	end

	arg0_5:InitPage()

	if arg0_5.contextData.mode == var0_0.MODE_HIDESIDE then
		setActive(arg0_5.leftPanel, false)

		local var3_5 = arg0_5.rightPanel.sizeDelta

		var3_5.x = 0
		arg0_5.rightPanel.sizeDelta = var3_5

		setAnchoredPosition(arg0_5.rightPanel, {
			x = 0
		})
	end
end

function var0_0.GetSortKeys(arg0_7)
	local var0_7 = _.keys(arg0_7)

	table.sort(var0_7, function(arg0_8, arg1_8)
		return arg0_8 < arg1_8
	end)

	return var0_7
end

function var0_0.GetSortTypes(arg0_9)
	local var0_9 = _.values(arg0_9)

	table.sort(var0_9, function(arg0_10, arg1_10)
		return arg0_10.id < arg1_10.id
	end)

	return _.map(var0_9, function(arg0_11)
		return arg0_11.category2
	end)
end

function var0_0.InitPage(arg0_12)
	arg0_12.firstInit = true

	local var0_12 = arg0_12.contextData
	local var1_12 = arg0_12.env

	var0_12.mode = var0_12.mode or var0_0.MODE_NORMAL

	local var2_12 = var0_12.nation
	local var3_12 = var0_0.GetSortKeys(var1_12.nationsTree)

	if not var2_12 or not table.contains(var3_12, var2_12) then
		var2_12 = var3_12[1]
	end

	if next(var1_12.nationsTree[var2_12]) == nil then
		for iter0_12 = 2, #var3_12 do
			if next(var1_12.nationsTree[var3_12[iter0_12]]) ~= nil then
				var2_12 = var3_12[iter0_12]

				break
			end
		end
	end

	var0_12.nation = nil

	arg0_12:UpdateNations()

	local var4_12 = table.indexof(var3_12, var2_12) or 1

	triggerButton(arg0_12.nationToggles[var4_12])

	arg0_12.firstInit = nil
end

function var0_0.UpdateNations(arg0_13)
	local var0_13 = var0_0.GetSortKeys(arg0_13.env.nationsTree)

	arg0_13.nationToggles = CustomIndexLayer.Clone2Full(arg0_13.nationToggleGroup, #var0_13)

	for iter0_13 = 1, #arg0_13.nationToggles do
		local var1_13 = arg0_13.nationToggles[iter0_13]
		local var2_13 = var0_13[iter0_13]

		arg0_13.loader:GetSprite(var2_0, "nation" .. var2_13 .. "_disable", var1_13:Find("selectedIcon"))
		setActive(var1_13:Find("selectedCursor"), false)
		onButton(arg0_13, var1_13, function()
			if arg0_13.contextData.nation ~= var2_13 then
				if next(arg0_13.env.nationsTree[var2_13]) == nil then
					pg.TipsMgr.GetInstance():ShowTips(i18n("word_comingSoon"))

					return
				end

				arg0_13.loader:GetSprite(var2_0, "nation" .. var2_13, var1_13:Find("selectedIcon"))

				if arg0_13.contextData.nation then
					local var0_14 = table.indexof(var0_13, arg0_13.contextData.nation)

					setActive(arg0_13.nationToggles[var0_14]:Find("selectedCursor"), false)
					arg0_13.loader:GetSprite(var2_0, "nation" .. arg0_13.contextData.nation .. "_disable", arg0_13.nationToggles[var0_14]:Find("selectedIcon"))
				end

				arg0_13.contextData.nation = var2_13

				arg0_13:UpdateEquipmentTypes()

				local var1_14 = var0_0.GetSortTypes(arg0_13.env.nationsTree[var2_13])
				local var2_14 = var1_14[1]

				if arg0_13.firstInit then
					local var3_14 = arg0_13.contextData.equipmentTypeIndex

					if var3_14 and table.contains(var1_14, var3_14) then
						var2_14 = var3_14
					end
				end

				arg0_13.contextData.equipmentTypeIndex = nil

				local var4_14 = table.indexof(var1_14, var2_14) or 1

				triggerToggle(arg0_13.equipmentTypeToggles[var4_14], true)
			end
		end, SFX_UI_TAG)
	end
end

function var0_0.UpdateEquipmentTypes(arg0_15)
	local var0_15 = var0_0.GetSortTypes(arg0_15.env.nationsTree[arg0_15.contextData.nation])

	arg0_15.equipmentTypeToggles = CustomIndexLayer.Clone2Full(arg0_15.equipmentTypeToggleGroup, #var0_15)

	for iter0_15 = 1, #arg0_15.equipmentTypeToggles do
		local var1_15 = arg0_15.equipmentTypeToggles[iter0_15]

		var1_15:GetComponent(typeof(Toggle)).isOn = false

		local var2_15 = var0_15[iter0_15]

		arg0_15.loader:GetSprite(var2_0, "equipmentType" .. var2_15, var1_15:Find("itemName"), true)
		setActive(var1_15:Find("selectedframe"), false)
		onToggle(arg0_15, var1_15, function(arg0_16)
			if arg0_16 and arg0_15.contextData.equipmentTypeIndex ~= var2_15 then
				arg0_15.contextData.equipmentTypeIndex = var2_15

				arg0_15:ResetCanvas()
			end

			setActive(var1_15:Find("selectedframe"), arg0_16)
		end, SFX_UI_TAG)
	end

	arg0_15.equipmentTypeToggleGroup.anchoredPosition = Vector2.zero
	arg0_15.leftPanel:Find("EquipmentTypes"):GetComponent(typeof(ScrollRect)).velocity = Vector2.zero
end

local var3_0 = {
	15,
	-4,
	15,
	6
}

function var0_0.ResetCanvas(arg0_17)
	local var0_17 = EquipmentProxy.EquipmentTransformTreeTemplate[arg0_17.contextData.nation][arg0_17.contextData.equipmentTypeIndex]

	assert(var0_17, "can't find Equip_upgrade_template Nation: " .. arg0_17.contextData.nation .. " Type: " .. arg0_17.contextData.equipmentTypeIndex)

	arg0_17.TreeCanvas.sizeDelta = Vector2(unpack(var0_17.canvasSize))
	arg0_17.TreeCanvas.anchoredPosition = Vector2.zero
	arg0_17.rightPanel:GetComponent(typeof(ScrollRect)).velocity = Vector2.zero

	arg0_17:ReturnCanvasItems()

	for iter0_17, iter1_17 in ipairs(var0_17.equipments) do
		local var1_17 = arg0_17.plurals.EquipNode:Dequeue()

		setActive(var1_17, true)
		setParent(var1_17, arg0_17.TreeCanvas)
		table.insert(arg0_17.nodes, {
			id = iter1_17[3],
			cfg = iter1_17,
			go = var1_17
		})

		var1_17.name = iter1_17[3]

		arg0_17:UpdateItemNode(tf(var1_17), iter1_17)
	end

	for iter2_17, iter3_17 in ipairs(var0_17.links) do
		for iter4_17 = 1, #iter3_17 - 1 do
			local var2_17 = iter3_17[iter4_17]
			local var3_17 = iter3_17[iter4_17 + 1]
			local var4_17 = {
				var3_17[1] - var2_17[1],
				var2_17[2] - var3_17[2]
			}
			local var5_17 = math.abs(var4_17[1]) > math.abs(var4_17[2])
			local var6_17 = var5_17 and math.abs(var4_17[1]) or math.abs(var4_17[2])

			if var5_17 then
				var4_17[2] = 0
			else
				var4_17[1] = 0
			end

			local var7_17 = 1 - math.sign(var4_17[1])

			var7_17 = var7_17 ~= 1 and var7_17 or 2 - math.sign(var4_17[2])

			local var8_17 = math.deg2Rad * 90 * var7_17

			if #iter3_17 == 2 then
				local var9_17 = arg0_17.plurals.Link:Dequeue()

				table.insert(arg0_17.links, go(var9_17))
				setActive(var9_17, true)
				setParent(var9_17, arg0_17.TreeCanvas)
				arg0_17.loader:GetSprite(var2_0, var4_17[2] == 0 and "wirehead" or "wireline", var9_17)

				tf(var9_17).sizeDelta = Vector2(28, 26)
				tf(var9_17).pivot = Vector2(0.5, 0.5)
				tf(var9_17).localRotation = Quaternion.Euler(0, 0, var7_17 * 90)

				local var10_17 = Vector2(math.cos(var8_17), math.sin(var8_17)) * var3_0[(var7_17 - 1) % 4 + 1]

				tf(var9_17).anchoredPosition = Vector2(var2_17[1] + var10_17.x, -var2_17[2] + var10_17.y)

				local var11_17 = arg0_17.plurals.Link:Dequeue()

				table.insert(arg0_17.links, go(var11_17))
				setActive(var11_17, true)
				setParent(var11_17, arg0_17.TreeCanvas)
				arg0_17.loader:GetSprite(var2_0, "wiretail", var11_17)

				tf(var11_17).sizeDelta = Vector2(28, 26)
				tf(var11_17).pivot = Vector2(0.5, 0.5)
				tf(var11_17).localRotation = Quaternion.Euler(0, 0, var7_17 * 90)

				local var12_17 = Vector2(math.cos(var8_17), math.sin(var8_17)) * -var3_0[(var7_17 + 1) % 4 + 1]

				tf(var11_17).anchoredPosition = Vector2(var3_17[1] + var12_17.x, -var3_17[2] + var12_17.y)

				local var13_17 = arg0_17.plurals.Link:Dequeue()

				table.insert(arg0_17.links, go(var13_17))
				setActive(var13_17, true)
				setParent(var13_17, arg0_17.TreeCanvas)
				arg0_17.loader:GetSprite(var2_0, "wireline", var13_17)

				tf(var13_17).sizeDelta = Vector2(math.max(0, var6_17 - var3_0[(var7_17 - 1) % 4 + 1] - var3_0[(var7_17 + 1) % 4 + 1] - 28), 16)
				tf(var13_17).pivot = Vector2(0, 0.5)
				tf(var13_17).localRotation = Quaternion.Euler(0, 0, var7_17 * 90)

				local var14_17 = Vector2(math.cos(var8_17), math.sin(var8_17)) * 14

				tf(var13_17).anchoredPosition = Vector2(var2_17[1] + var10_17.x, -var2_17[2] + var10_17.y) + var14_17

				break
			end

			local var15_17 = arg0_17.plurals.Link:Dequeue()

			table.insert(arg0_17.links, go(var15_17))
			setActive(var15_17, true)
			setParent(var15_17, arg0_17.TreeCanvas)

			local var16_17 = 1

			if iter4_17 == 1 then
				arg0_17.loader:GetSprite(var2_0, var4_17[2] == 0 and "wirehead" or "wireline", var15_17)

				local var17_17 = var6_17 + 14 + var16_17 - var3_0[(var7_17 - 1) % 4 + 1]

				tf(var15_17).sizeDelta = Vector2(var17_17, 26)
				tf(var15_17).pivot = Vector2((var17_17 - var16_17) / var17_17, 0.5)
				tf(var15_17).localRotation = Quaternion.Euler(0, 0, var7_17 * 90)
				tf(var15_17).anchoredPosition = Vector2(var3_17[1], -var3_17[2])
			elseif iter4_17 + 1 == #iter3_17 then
				arg0_17.loader:GetSprite(var2_0, "wiretail", var15_17)

				tf(var15_17).sizeDelta = Vector2(var6_17 + 14 + var16_17 - var3_0[(var7_17 + 1) % 4 + 1], 26)
				tf(var15_17).pivot = Vector2(var16_17 / (var6_17 + 14 + var16_17 - var3_0[(var7_17 + 1) % 4 + 1]), 0.5)
				tf(var15_17).localRotation = Quaternion.Euler(0, 0, var7_17 * 90)
				tf(var15_17).anchoredPosition = Vector2(var2_17[1], -var2_17[2])
			else
				arg0_17.loader:GetSprite(var2_0, "wireline", var15_17)

				tf(var15_17).sizeDelta = Vector2(var6_17 + var16_17 * 2, 16)
				tf(var15_17).pivot = Vector2(var16_17 / (var6_17 + var16_17 * 2), 0.5)
				tf(var15_17).localRotation = Quaternion.Euler(0, 0, var7_17 * 90)
				tf(var15_17).anchoredPosition = Vector2(var2_17[1], -var2_17[2])
			end
		end
	end
end

function var0_0.UpdateItemNode(arg0_18, arg1_18, arg2_18)
	arg1_18 = tf(arg1_18)
	arg1_18.anchoredPosition = Vector2(arg2_18[1], -arg2_18[2])

	updateDrop(arg1_18:Find("Item"), {
		id = arg2_18[3],
		type = DROP_TYPE_EQUIP
	})
	onButton(arg0_18, arg1_18:Find("Item"), function()
		local var0_19 = EquipmentProxy.GetTransformSources(arg2_18[3])[1]

		if not var0_19 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_initial_node"))

			return
		end

		arg0_18:emit(EquipmentTransformTreeMediator.OPEN_LAYER, Context.New({
			mediator = EquipmentTransformMediator,
			viewComponent = EquipmentTransformLayer,
			data = {
				formulaId = var0_19
			}
		}))
	end, SFX_PANEL)
	arg1_18:Find("Mask/NameText"):GetComponent("ScrollText"):SetText(Equipment.getConfigData(arg2_18[3]).name)

	local var0_18 = arg0_18.env.tracebackHelper:GetSortedEquipTraceBack(arg2_18[3])
	local var1_18 = _.any(var0_18, function(arg0_20)
		local var0_20 = arg0_20.candicates

		return var0_20 and #var0_20 > 0 and EquipmentTransformUtil.CheckTransformFormulasSucceed(arg0_20.formulas, var0_20[#var0_20])
	end)

	setActive(arg1_18:Find("cratfable"), var1_18)
	onButton(arg0_18, arg1_18:Find("cratfable"), function()
		arg0_18:emit(EquipmentTransformTreeMediator.OPEN_LAYER, Context.New({
			mediator = EquipmentTraceBackMediator,
			viewComponent = EquipmentTraceBackLayer,
			data = {
				TargetEquipmentId = arg2_18[3]
			}
		}))
	end)

	local var2_18 = arg2_18[4] and PlayerPrefs.GetInt("ShowTransformTip_" .. arg2_18[3], 0) == 0

	setActive(arg1_18:Find("Item/new"), var2_18)
end

function var0_0.UpdateItemNodes(arg0_22)
	for iter0_22, iter1_22 in ipairs(arg0_22.nodes) do
		arg0_22:UpdateItemNode(iter1_22.go, iter1_22.cfg)
	end
end

function var0_0.UpdateItemNodeByID(arg0_23, arg1_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.nodes) do
		if arg1_23 == iter1_23.id then
			arg0_23:UpdateItemNode(iter1_23.go, iter1_23.cfg)

			break
		end
	end
end

function var0_0.ReturnCanvasItems(arg0_24, arg1_24)
	for iter0_24, iter1_24 in ipairs(arg0_24.nodes) do
		if not arg0_24.plurals.EquipNode:Enqueue(iter1_24.go, arg1_24) then
			setParent(iter1_24.go, arg0_24.pluralRoot)
		end
	end

	table.clean(arg0_24.nodes)

	for iter2_24, iter3_24 in ipairs(arg0_24.links) do
		if not arg0_24.plurals.Link:Enqueue(iter3_24, arg1_24) then
			setParent(iter3_24, arg0_24.pluralRoot)
		end
	end

	table.clean(arg0_24.links)
end

function var0_0.willExit(arg0_25)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_25.top, arg0_25._tf)
	arg0_25:ReturnCanvasItems(true)

	for iter0_25, iter1_25 in pairs(arg0_25.plurals) do
		iter1_25:Clear()
	end

	arg0_25.loader:Clear()
end

return var0_0
