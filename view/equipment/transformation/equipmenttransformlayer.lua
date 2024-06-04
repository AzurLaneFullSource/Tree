local var0 = class("EquipmentTransformLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "EquipmentTransformUI"
end

function var0.init(arg0)
	arg0.layer = arg0:findTF("Adapt")
	arg0.formulaItems = {}
	arg0.formulaItems[1] = arg0.layer:Find("MaterialModule1")
	arg0.formulaItems[2] = arg0.layer:Find("MaterialModule2")
	arg0.formulaItems[3] = arg0.layer:Find("MaterialModule3")
	arg0.sourceEquipItem = arg0.layer:Find("SourceEquip")
	arg0.targetEquipItem = arg0.layer:Find("TargetEquip")
	arg0.consumePanel = arg0.layer:Find("ComposePanel")

	setText(arg0._tf:Find("Adapt/TitleText"), i18n("equipment_upgrade_title"))
	setText(arg0.consumePanel:Find("Consume"), i18n("equipment_upgrade_coin_consume"))
	setText(arg0._tf:Find("Adapt/InfoPanel/StoreCount/OnShip/NameText"), i18n("equipment_upgrade_equipped_tag"))
	setText(arg0._tf:Find("Adapt/InfoPanel/StoreCount/Free/NameText"), i18n("equipment_upgrade_spare_tag"))

	local var0 = arg0._tf:Find("Adapt/InfoPanel/Viewport/Content")
	local var1 = var0:Find("attr_tpl")

	setActive(var1, false)
	setActive(var1:Find("subs"), false)

	local var2 = Instantiate(var1).transform

	var2.name = "attr"

	setParent(var2, var0:Find("skill"))
	var2:SetAsFirstSibling()

	local var3 = Instantiate(var1).transform

	var3.name = "attr"

	setParent(var3, var0:Find("part"))
	var3:SetAsFirstSibling()

	arg0.loader = AutoLoader.New()
end

function var0.SetEnv(arg0, arg1)
	arg0.env = arg1
end

function var0.UpdatePlayer(arg0, arg1)
	arg0.player = arg1

	arg0:UpdateConsumeComparer()
end

function var0.UpdateConsumeComparer(arg0)
	local var0 = 0
	local var1 = 0
	local var2 = true

	if arg0.contextData.sourceEquipmentInstance then
		var2, var0, var1 = EquipmentTransformUtil.CheckTransformEnoughGold({
			arg0.contextData.formulaId
		}, arg0.contextData.sourceEquipmentInstance)
	end

	local var3 = setColorStr(var0, var2 and COLOR_WHITE or COLOR_RED)

	if var1 > 0 then
		var3 = var3 .. setColorStr(" + " .. var1, var2 and COLOR_GREEN or COLOR_RED)
	end

	arg0.consumePanel:Find("GoldText"):GetComponent(typeof(Text)).text = var3
end

function var0.UpdateFormula(arg0, arg1)
	if arg1 == arg0.contextData.formulaId then
		return
	end

	assert(arg1 and arg1 > 0, "target formulaId is invalid")

	arg0.contextData.formulaId = arg1

	local var0 = pg.equip_upgrade_data[arg1]

	arg0.contextData.formula = var0
	arg0.equipmentSourceId = var0.upgrade_from
	arg0.equipmentTarget = var0.target_id
	arg0.transformMaterials = var0.material_consume

	arg0:UpdateConsumeComparer()

	local var1 = arg0.env.tracebackHelper:GetEquipmentTransformCandicates(arg0.equipmentSourceId)
	local var2

	if arg0.contextData.sourceEquipmentInstance then
		var2 = _.detect(var1, function(arg0)
			return EquipmentTransformUtil.SameDrop(arg0, arg0.contextData.sourceEquipmentInstance)
		end)
	end

	arg0.contextData.sourceEquipmentInstance = var2

	PlayerPrefs.SetInt("ShowTransformTip_" .. arg0.equipmentTarget, 1)
	PlayerPrefs.Save()
	arg0:emit(EquipmentTransformMediator.UPDATE_NEW_FLAG, arg0.equipmentTarget)
	setActive(arg0.layer:Find("SwitchButton"), #EquipmentProxy.GetTransformSources(arg0.equipmentTarget) > 1)
	arg0:UpdatePage()
end

function var0.UpdatePage(arg0)
	arg0:UpdateSourceEquipmentPaths()
	arg0:UpdateFormulaItems()
	arg0:UpdateTargetInfo()
	arg0:UpdateSourceInfo()
end

function var0.UpdateSourceEquipmentPaths(arg0)
	local var0 = arg0.env.tracebackHelper:GetSortedEquipTraceBack(arg0.equipmentSourceId)

	arg0.hasRoot = _.any(var0, function(arg0)
		local var0 = arg0.candicates

		return var0 and #var0 > 0 and EquipmentTransformUtil.CheckTransformFormulasSucceed(arg0.formulas, var0[#var0])
	end)

	local var1 = arg0.env.tracebackHelper:GetEquipmentTransformCandicates(arg0.equipmentSourceId)

	arg0.childsCanUse = _.any(var1, function(arg0)
		if arg0.type == DROP_TYPE_ITEM then
			return arg0.template.count >= arg0.composeCfg.material_num
		elseif arg0.type == DROP_TYPE_EQUIP then
			return arg0.template.count > 0
		end
	end)
end

function var0.CheckEnoughMaterials(arg0)
	if not arg0.contextData.formula then
		return
	end

	if not arg0.contextData.sourceEquipmentInstance then
		return
	end

	local var0 = arg0.contextData.sourceEquipmentInstance
	local var1, var2 = EquipmentTransformUtil.CheckTransformFormulasSucceed({
		arg0.contextData.formulaId
	}, var0)

	if not var1 then
		return false, var2
	end

	return true
end

function var0.UpdateFormulaItems(arg0)
	for iter0, iter1 in ipairs(arg0.formulaItems) do
		local var0 = iter1:Find("Item")
		local var1 = arg0.transformMaterials[iter0]

		setActive(iter1, var1)

		if var1 then
			local var2 = {
				type = DROP_TYPE_ITEM,
				id = var1[1],
				count = var1[2]
			}

			updateDrop(var0, var2)
			onButton(arg0, var0, function()
				arg0:emit(var0.ON_DROP, var2)
			end, SFX_PANEL)

			local var3 = getProxy(BagProxy):getItemCountById(var1[1]) or 0

			setText(iter1:Find("NumText"), setColorStr(var3, var3 < var1[2] and COLOR_RED or "#000F") .. "/" .. var1[2])

			local var4 = arg0.equipmentSourceId == 0

			setActive(iter1:Find("Line"), not var4)
			setActive(iter1:Find("Line2"), var4)
		end
	end
end

function var0.UpdateTargetInfo(arg0)
	updateDrop(arg0.targetEquipItem:Find("Item"), {
		id = arg0.equipmentTarget,
		type = DROP_TYPE_EQUIP
	})
	arg0.targetEquipItem:Find("Mask/NameText"):GetComponent("ScrollText"):SetText(Equipment.getConfigData(arg0.equipmentTarget).name)

	local var0 = arg0.layer:Find("InfoPanel")
	local var1 = arg0.env.tracebackHelper:GetEquipmentTransformCandicates(arg0.equipmentTarget)
	local var2 = 0
	local var3 = 0

	for iter0, iter1 in ipairs(var1) do
		if iter1.type == DROP_TYPE_EQUIP then
			if iter1.template.shipId then
				var2 = var2 + iter1.template.count
			else
				var3 = var3 + iter1.template.count
			end
		end
	end

	setText(var0:Find("StoreCount/OnShip/ValueText"), var2)
	setText(var0:Find("StoreCount/Free/ValueText"), var3)

	local var4 = Equipment.New({
		id = arg0.equipmentTarget
	})
	local var5 = var0:Find("Viewport/Content")

	updateEquipInfo(var5, var4:GetPropertiesInfo(), var4:GetSkill())
	Canvas.ForceUpdateCanvases()
	var0.FitTextBGSize(var5:Find("attrs"))
	var0.FitTextBGSize(var5:Find("weapon"))
	var0.FitTextBGSize(var5:Find("equip_info"))
end

function var0.FitTextBGSize(arg0)
	for iter0 = 0, arg0.childCount - 1 do
		local var0 = arg0:GetChild(iter0)
		local var1 = var0:Find("base/NameBG").sizeDelta

		var1.x = var0:Find("base/name").rect.width + 18
		var0:Find("base/NameBG").sizeDelta = var1

		var0.FitTextBGSize(var0:Find("subs"))
	end
end

function var0.UpdateSourceInfo(arg0)
	local var0 = arg0.contextData.sourceEquipmentInstance
	local var1 = var0 or {
		id = arg0.equipmentSourceId,
		type = DROP_TYPE_EQUIP
	}
	local var2 = arg0.equipmentSourceId == 0

	setActive(arg0.sourceEquipItem, not var2)

	if var2 then
		return
	end

	updateDrop(arg0.sourceEquipItem:Find("Item"), var1)

	local var3 = arg0.sourceEquipItem:Find("Item/icon_bg/count")
	local var4 = ""

	if var0 and var0.type == DROP_TYPE_ITEM then
		local var5 = var0.template.count >= var0.composeCfg.material_num

		var4 = setColorStr(math.min(var0.template.count, var0.composeCfg.material_num), var5 and COLOR_WHITE or COLOR_RED)
	end

	setText(var3, var4)
	arg0.sourceEquipItem:Find("Mask/NameText"):GetComponent("ScrollText"):SetText(Equipment.getConfigData(arg0.equipmentSourceId).name)
	setActive(arg0.sourceEquipItem:Find("craftable"), arg0.hasRoot)
	onButton(arg0, arg0.sourceEquipItem:Find("craftable"), function()
		arg0:emit(EquipmentTransformMediator.OPEN_LAYER, Context.New({
			mediator = EquipmentTraceBackMediator,
			viewComponent = EquipmentTraceBackLayer,
			data = {
				TargetEquipmentId = arg0.equipmentSourceId
			}
		}))
	end, SFX_PANEL)
	onButton(arg0, arg0.sourceEquipItem:Find("Item"), function()
		if arg0.childsCanUse then
			arg0:emit(EquipmentTransformMediator.SELECT_TRANSFORM_FROM_STOREHOUSE, arg0.equipmentSourceId)
		end
	end, SFX_PANEL)

	local var6 = arg0.sourceEquipItem:Find("Status")

	if not arg0.childsCanUse then
		setImageSprite(var6, LoadSprite("ui/equipmenttransformui_atlas", "noown"))
		setActive(var6, true)
	elseif not var0 then
		setImageSprite(var6, LoadSprite("ui/equipmenttransformui_atlas", "unselect"))
		setActive(var6, true)
	else
		setActive(var6, false)
	end

	local var7 = var0 and var0.template.shipId

	setActive(arg0.sourceEquipItem:Find("EquipShip"), var7)

	if var7 then
		local var8 = getProxy(BayProxy):getShipById(var7)

		arg0.loader:GetSprite("qicon/" .. var8:getPainting(), "", arg0.sourceEquipItem:Find("EquipShip/Image"))
	end
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf:Find("BG"), function()
		arg0:closeView()
	end)
	onButton(arg0, arg0.consumePanel:Find("ComposeBtn"), function()
		local var0 = arg0.contextData.sourceEquipmentInstance

		if arg0.equipmentSourceId ~= 0 and not var0 then
			if arg0.childsCanUse then
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_quick_interface_feedback_source_chosen"))

				return
			elseif arg0.hasRoot then
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_feedback_equipment_can_be_produced"))

				return
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_feedback_lack_of_equipment"))

				return
			end
		end

		if not arg0:CheckEnoughMaterials() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_feedback_lack_of_materials"))

			return
		end

		arg0:emit(EquipmentTransformMediator.TRANSFORM_EQUIP, var0, arg0.contextData.formulaId)
	end, SFX_PANEL)
	onButton(arg0, arg0.layer:Find("OverviewBtn"), function()
		arg0:emit(EquipmentTransformMediator.OPEN_TRANSFORM_TREE, arg0.equipmentTarget)
	end, SFX_CANCEL)
	onButton(arg0, arg0.layer:Find("SwitchButton"), function()
		local var0 = EquipmentProxy.GetTransformSources(arg0.equipmentTarget)
		local var1 = table.indexof(var0, arg0.contextData.formulaId)
		local var2

		var2 = var1 and var1 % #var0 + 1 or 1
		arg0.contextData.sourceEquipmentInstance = nil

		arg0:UpdateFormula(var0[var2])
	end, SFX_PANEL)
	onButton(arg0, arg0.layer:Find("HelpBtn"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.equipment_upgrade_help.tip
		})
	end, SFX_PANEL)
	assert(arg0.contextData.formulaId)

	local var0 = arg0.contextData.formulaId

	arg0.contextData.formulaId = nil

	arg0:UpdateFormula(var0)

	local var1, var2 = getProxy(ContextProxy):getContextByMediator(EquipmentTransformMediator)
	local var3 = var2 and pg.m02:retrieveMediator(var2.mediator.__cname)

	setActive(arg0.layer:Find("OverviewBtn"), var3.class ~= EquipmentTransformTreeMediator)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.willExit(arg0)
	arg0.loader:Clear()
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
