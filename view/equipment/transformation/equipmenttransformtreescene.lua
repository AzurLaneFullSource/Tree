local var0 = class("EquipmentTransformTreeScene", import("view.base.BaseUI"))
local var1 = require("Mgr/Pool/PoolPlural")
local var2 = "ui/EquipmentTransformTreeUI_atlas"

function var0.getUIName(arg0)
	return "EquipmentTransformTreeUI"
end

var0.optionsPath = {
	"blur_panel/adapt/top/option"
}
var0.MODE_NORMAL = 1
var0.MODE_HIDESIDE = 2

function var0.init(arg0)
	arg0.leftPanel = arg0._tf:Find("Adapt/Left")
	arg0.rightPanel = arg0._tf:Find("Adapt/Right")
	arg0.nationToggleGroup = arg0.leftPanel:Find("Nations"):Find("ViewPort/Content")

	setActive(arg0.nationToggleGroup:GetChild(0), false)
	arg0.nationToggleGroup:GetChild(0):Find("selectedCursor").gameObject:SetActive(false)

	arg0.equipmentTypeToggleGroup = arg0.leftPanel:Find("EquipmentTypes"):Find("ViewPort/Content")

	setActive(arg0.equipmentTypeToggleGroup:GetChild(0), false)
	arg0.equipmentTypeToggleGroup:GetChild(0):Find("selectedframe").gameObject:SetActive(false)

	arg0.TreeCanvas = arg0.rightPanel:Find("ViewPort/Content")

	setActive(arg0.rightPanel:Find("EquipNode"), false)
	setActive(arg0.rightPanel:Find("Link"), false)

	arg0.nodes = {}
	arg0.links = {}
	arg0.plurals = {
		EquipNode = var1.New(arg0.rightPanel:Find("EquipNode").gameObject, 5),
		Link = var1.New(arg0.rightPanel:Find("Link").gameObject, 8)
	}
	arg0.pluralRoot = pg.PoolMgr.GetInstance().root
	arg0.top = arg0._tf:Find("blur_panel")
	arg0.loader = AutoLoader.New()
end

function var0.GetEnv(arg0)
	arg0.env = arg0.env or {}

	return arg0.env
end

function var0.SetEnv(arg0, arg1)
	arg0.env = arg1
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.top)
	onButton(arg0, arg0.top:Find("adapt/top/back"), function()
		arg0:closeView()
	end, SFX_CANCEL)

	if arg0.contextData.targetEquipId then
		local var0
		local var1
		local var2 = false

		for iter0, iter1 in pairs(arg0.env.nationsTree) do
			for iter2, iter3 in pairs(iter1) do
				for iter4, iter5 in ipairs(iter3.equipments) do
					if iter5[3] == arg0.contextData.targetEquipId then
						var0, var1 = iter0, iter2
						var2 = true

						break
					end
				end
			end

			if var2 then
				break
			end
		end

		if var2 then
			arg0.contextData.nation = var0
			arg0.contextData.equipmentTypeIndex = var1
		end

		arg0.contextData.targetEquipId = nil
	end

	arg0:InitPage()

	if arg0.contextData.mode == var0.MODE_HIDESIDE then
		setActive(arg0.leftPanel, false)

		local var3 = arg0.rightPanel.sizeDelta

		var3.x = 0
		arg0.rightPanel.sizeDelta = var3

		setAnchoredPosition(arg0.rightPanel, {
			x = 0
		})
	end
end

function var0.GetSortKeys(arg0)
	local var0 = _.keys(arg0)

	table.sort(var0, function(arg0, arg1)
		return arg0 < arg1
	end)

	return var0
end

function var0.GetSortTypes(arg0)
	local var0 = _.values(arg0)

	table.sort(var0, function(arg0, arg1)
		return arg0.id < arg1.id
	end)

	return _.map(var0, function(arg0)
		return arg0.category2
	end)
end

function var0.InitPage(arg0)
	arg0.firstInit = true

	local var0 = arg0.contextData
	local var1 = arg0.env

	var0.mode = var0.mode or var0.MODE_NORMAL

	local var2 = var0.nation
	local var3 = var0.GetSortKeys(var1.nationsTree)

	if not var2 or not table.contains(var3, var2) then
		var2 = var3[1]
	end

	if next(var1.nationsTree[var2]) == nil then
		for iter0 = 2, #var3 do
			if next(var1.nationsTree[var3[iter0]]) ~= nil then
				var2 = var3[iter0]

				break
			end
		end
	end

	var0.nation = nil

	arg0:UpdateNations()

	local var4 = table.indexof(var3, var2) or 1

	triggerButton(arg0.nationToggles[var4])

	arg0.firstInit = nil
end

function var0.UpdateNations(arg0)
	local var0 = var0.GetSortKeys(arg0.env.nationsTree)

	arg0.nationToggles = CustomIndexLayer.Clone2Full(arg0.nationToggleGroup, #var0)

	for iter0 = 1, #arg0.nationToggles do
		local var1 = arg0.nationToggles[iter0]
		local var2 = var0[iter0]

		arg0.loader:GetSprite(var2, "nation" .. var2 .. "_disable", var1:Find("selectedIcon"))
		setActive(var1:Find("selectedCursor"), false)
		onButton(arg0, var1, function()
			if arg0.contextData.nation ~= var2 then
				if next(arg0.env.nationsTree[var2]) == nil then
					pg.TipsMgr.GetInstance():ShowTips(i18n("word_comingSoon"))

					return
				end

				arg0.loader:GetSprite(var2, "nation" .. var2, var1:Find("selectedIcon"))

				if arg0.contextData.nation then
					local var0 = table.indexof(var0, arg0.contextData.nation)

					setActive(arg0.nationToggles[var0]:Find("selectedCursor"), false)
					arg0.loader:GetSprite(var2, "nation" .. arg0.contextData.nation .. "_disable", arg0.nationToggles[var0]:Find("selectedIcon"))
				end

				arg0.contextData.nation = var2

				arg0:UpdateEquipmentTypes()

				local var1 = var0.GetSortTypes(arg0.env.nationsTree[var2])
				local var2 = var1[1]

				if arg0.firstInit then
					local var3 = arg0.contextData.equipmentTypeIndex

					if var3 and table.contains(var1, var3) then
						var2 = var3
					end
				end

				arg0.contextData.equipmentTypeIndex = nil

				local var4 = table.indexof(var1, var2) or 1

				triggerToggle(arg0.equipmentTypeToggles[var4], true)
			end
		end, SFX_UI_TAG)
	end
end

function var0.UpdateEquipmentTypes(arg0)
	local var0 = var0.GetSortTypes(arg0.env.nationsTree[arg0.contextData.nation])

	arg0.equipmentTypeToggles = CustomIndexLayer.Clone2Full(arg0.equipmentTypeToggleGroup, #var0)

	for iter0 = 1, #arg0.equipmentTypeToggles do
		local var1 = arg0.equipmentTypeToggles[iter0]

		var1:GetComponent(typeof(Toggle)).isOn = false

		local var2 = var0[iter0]

		arg0.loader:GetSprite(var2, "equipmentType" .. var2, var1:Find("itemName"), true)
		setActive(var1:Find("selectedframe"), false)
		onToggle(arg0, var1, function(arg0)
			if arg0 and arg0.contextData.equipmentTypeIndex ~= var2 then
				arg0.contextData.equipmentTypeIndex = var2

				arg0:ResetCanvas()
			end

			setActive(var1:Find("selectedframe"), arg0)
		end, SFX_UI_TAG)
	end

	arg0.equipmentTypeToggleGroup.anchoredPosition = Vector2.zero
	arg0.leftPanel:Find("EquipmentTypes"):GetComponent(typeof(ScrollRect)).velocity = Vector2.zero
end

local var3 = {
	15,
	-4,
	15,
	6
}

function var0.ResetCanvas(arg0)
	local var0 = EquipmentProxy.EquipmentTransformTreeTemplate[arg0.contextData.nation][arg0.contextData.equipmentTypeIndex]

	assert(var0, "can't find Equip_upgrade_template Nation: " .. arg0.contextData.nation .. " Type: " .. arg0.contextData.equipmentTypeIndex)

	arg0.TreeCanvas.sizeDelta = Vector2(unpack(var0.canvasSize))
	arg0.TreeCanvas.anchoredPosition = Vector2.zero
	arg0.rightPanel:GetComponent(typeof(ScrollRect)).velocity = Vector2.zero

	arg0:ReturnCanvasItems()

	for iter0, iter1 in ipairs(var0.equipments) do
		local var1 = arg0.plurals.EquipNode:Dequeue()

		setActive(var1, true)
		setParent(var1, arg0.TreeCanvas)
		table.insert(arg0.nodes, {
			id = iter1[3],
			cfg = iter1,
			go = var1
		})

		var1.name = iter1[3]

		arg0:UpdateItemNode(tf(var1), iter1)
	end

	for iter2, iter3 in ipairs(var0.links) do
		for iter4 = 1, #iter3 - 1 do
			local var2 = iter3[iter4]
			local var3 = iter3[iter4 + 1]
			local var4 = {
				var3[1] - var2[1],
				var2[2] - var3[2]
			}
			local var5 = math.abs(var4[1]) > math.abs(var4[2])
			local var6 = var5 and math.abs(var4[1]) or math.abs(var4[2])

			if var5 then
				var4[2] = 0
			else
				var4[1] = 0
			end

			local var7 = 1 - math.sign(var4[1])

			var7 = var7 ~= 1 and var7 or 2 - math.sign(var4[2])

			local var8 = math.deg2Rad * 90 * var7

			if #iter3 == 2 then
				local var9 = arg0.plurals.Link:Dequeue()

				table.insert(arg0.links, go(var9))
				setActive(var9, true)
				setParent(var9, arg0.TreeCanvas)
				arg0.loader:GetSprite(var2, var4[2] == 0 and "wirehead" or "wireline", var9)

				tf(var9).sizeDelta = Vector2(28, 26)
				tf(var9).pivot = Vector2(0.5, 0.5)
				tf(var9).localRotation = Quaternion.Euler(0, 0, var7 * 90)

				local var10 = Vector2(math.cos(var8), math.sin(var8)) * var3[(var7 - 1) % 4 + 1]

				tf(var9).anchoredPosition = Vector2(var2[1] + var10.x, -var2[2] + var10.y)

				local var11 = arg0.plurals.Link:Dequeue()

				table.insert(arg0.links, go(var11))
				setActive(var11, true)
				setParent(var11, arg0.TreeCanvas)
				arg0.loader:GetSprite(var2, "wiretail", var11)

				tf(var11).sizeDelta = Vector2(28, 26)
				tf(var11).pivot = Vector2(0.5, 0.5)
				tf(var11).localRotation = Quaternion.Euler(0, 0, var7 * 90)

				local var12 = Vector2(math.cos(var8), math.sin(var8)) * -var3[(var7 + 1) % 4 + 1]

				tf(var11).anchoredPosition = Vector2(var3[1] + var12.x, -var3[2] + var12.y)

				local var13 = arg0.plurals.Link:Dequeue()

				table.insert(arg0.links, go(var13))
				setActive(var13, true)
				setParent(var13, arg0.TreeCanvas)
				arg0.loader:GetSprite(var2, "wireline", var13)

				tf(var13).sizeDelta = Vector2(math.max(0, var6 - var3[(var7 - 1) % 4 + 1] - var3[(var7 + 1) % 4 + 1] - 28), 16)
				tf(var13).pivot = Vector2(0, 0.5)
				tf(var13).localRotation = Quaternion.Euler(0, 0, var7 * 90)

				local var14 = Vector2(math.cos(var8), math.sin(var8)) * 14

				tf(var13).anchoredPosition = Vector2(var2[1] + var10.x, -var2[2] + var10.y) + var14

				break
			end

			local var15 = arg0.plurals.Link:Dequeue()

			table.insert(arg0.links, go(var15))
			setActive(var15, true)
			setParent(var15, arg0.TreeCanvas)

			local var16 = 1

			if iter4 == 1 then
				arg0.loader:GetSprite(var2, var4[2] == 0 and "wirehead" or "wireline", var15)

				local var17 = var6 + 14 + var16 - var3[(var7 - 1) % 4 + 1]

				tf(var15).sizeDelta = Vector2(var17, 26)
				tf(var15).pivot = Vector2((var17 - var16) / var17, 0.5)
				tf(var15).localRotation = Quaternion.Euler(0, 0, var7 * 90)
				tf(var15).anchoredPosition = Vector2(var3[1], -var3[2])
			elseif iter4 + 1 == #iter3 then
				arg0.loader:GetSprite(var2, "wiretail", var15)

				tf(var15).sizeDelta = Vector2(var6 + 14 + var16 - var3[(var7 + 1) % 4 + 1], 26)
				tf(var15).pivot = Vector2(var16 / (var6 + 14 + var16 - var3[(var7 + 1) % 4 + 1]), 0.5)
				tf(var15).localRotation = Quaternion.Euler(0, 0, var7 * 90)
				tf(var15).anchoredPosition = Vector2(var2[1], -var2[2])
			else
				arg0.loader:GetSprite(var2, "wireline", var15)

				tf(var15).sizeDelta = Vector2(var6 + var16 * 2, 16)
				tf(var15).pivot = Vector2(var16 / (var6 + var16 * 2), 0.5)
				tf(var15).localRotation = Quaternion.Euler(0, 0, var7 * 90)
				tf(var15).anchoredPosition = Vector2(var2[1], -var2[2])
			end
		end
	end
end

function var0.UpdateItemNode(arg0, arg1, arg2)
	arg1 = tf(arg1)
	arg1.anchoredPosition = Vector2(arg2[1], -arg2[2])

	updateDrop(arg1:Find("Item"), {
		id = arg2[3],
		type = DROP_TYPE_EQUIP
	})
	onButton(arg0, arg1:Find("Item"), function()
		local var0 = EquipmentProxy.GetTransformSources(arg2[3])[1]

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_initial_node"))

			return
		end

		arg0:emit(EquipmentTransformTreeMediator.OPEN_LAYER, Context.New({
			mediator = EquipmentTransformMediator,
			viewComponent = EquipmentTransformLayer,
			data = {
				formulaId = var0
			}
		}))
	end, SFX_PANEL)
	arg1:Find("Mask/NameText"):GetComponent("ScrollText"):SetText(Equipment.getConfigData(arg2[3]).name)

	local var0 = arg0.env.tracebackHelper:GetSortedEquipTraceBack(arg2[3])
	local var1 = _.any(var0, function(arg0)
		local var0 = arg0.candicates

		return var0 and #var0 > 0 and EquipmentTransformUtil.CheckTransformFormulasSucceed(arg0.formulas, var0[#var0])
	end)

	setActive(arg1:Find("cratfable"), var1)
	onButton(arg0, arg1:Find("cratfable"), function()
		arg0:emit(EquipmentTransformTreeMediator.OPEN_LAYER, Context.New({
			mediator = EquipmentTraceBackMediator,
			viewComponent = EquipmentTraceBackLayer,
			data = {
				TargetEquipmentId = arg2[3]
			}
		}))
	end)

	local var2 = arg2[4] and PlayerPrefs.GetInt("ShowTransformTip_" .. arg2[3], 0) == 0

	setActive(arg1:Find("Item/new"), var2)
end

function var0.UpdateItemNodes(arg0)
	for iter0, iter1 in ipairs(arg0.nodes) do
		arg0:UpdateItemNode(iter1.go, iter1.cfg)
	end
end

function var0.UpdateItemNodeByID(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.nodes) do
		if arg1 == iter1.id then
			arg0:UpdateItemNode(iter1.go, iter1.cfg)

			break
		end
	end
end

function var0.ReturnCanvasItems(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.nodes) do
		if not arg0.plurals.EquipNode:Enqueue(iter1.go, arg1) then
			setParent(iter1.go, arg0.pluralRoot)
		end
	end

	table.clean(arg0.nodes)

	for iter2, iter3 in ipairs(arg0.links) do
		if not arg0.plurals.Link:Enqueue(iter3, arg1) then
			setParent(iter3, arg0.pluralRoot)
		end
	end

	table.clean(arg0.links)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.top, arg0._tf)
	arg0:ReturnCanvasItems(true)

	for iter0, iter1 in pairs(arg0.plurals) do
		iter1:Clear()
	end

	arg0.loader:Clear()
end

return var0
