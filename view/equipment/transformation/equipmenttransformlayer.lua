local var0_0 = class("EquipmentTransformLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "EquipmentTransformUI"
end

function var0_0.init(arg0_2)
	arg0_2.layer = arg0_2:findTF("Adapt")
	arg0_2.formulaItems = {}
	arg0_2.formulaItems[1] = arg0_2.layer:Find("MaterialModule1")
	arg0_2.formulaItems[2] = arg0_2.layer:Find("MaterialModule2")
	arg0_2.formulaItems[3] = arg0_2.layer:Find("MaterialModule3")
	arg0_2.sourceEquipItem = arg0_2.layer:Find("SourceEquip")
	arg0_2.targetEquipItem = arg0_2.layer:Find("TargetEquip")
	arg0_2.consumePanel = arg0_2.layer:Find("ComposePanel")

	setText(arg0_2._tf:Find("Adapt/TitleText"), i18n("equipment_upgrade_title"))
	setText(arg0_2.consumePanel:Find("Consume"), i18n("equipment_upgrade_coin_consume"))
	setText(arg0_2._tf:Find("Adapt/InfoPanel/StoreCount/OnShip/NameText"), i18n("equipment_upgrade_equipped_tag"))
	setText(arg0_2._tf:Find("Adapt/InfoPanel/StoreCount/Free/NameText"), i18n("equipment_upgrade_spare_tag"))

	local var0_2 = arg0_2._tf:Find("Adapt/InfoPanel/Viewport/Content")
	local var1_2 = var0_2:Find("attr_tpl")

	setActive(var1_2, false)
	setActive(var1_2:Find("subs"), false)

	local var2_2 = Instantiate(var1_2).transform

	var2_2.name = "attr"

	setParent(var2_2, var0_2:Find("skill"))
	var2_2:SetAsFirstSibling()

	local var3_2 = Instantiate(var1_2).transform

	var3_2.name = "attr"

	setParent(var3_2, var0_2:Find("part"))
	var3_2:SetAsFirstSibling()

	arg0_2.loader = AutoLoader.New()
end

function var0_0.SetEnv(arg0_3, arg1_3)
	arg0_3.env = arg1_3
end

function var0_0.UpdatePlayer(arg0_4, arg1_4)
	arg0_4.player = arg1_4

	arg0_4:UpdateConsumeComparer()
end

function var0_0.UpdateConsumeComparer(arg0_5)
	local var0_5 = 0
	local var1_5 = 0
	local var2_5 = true

	if arg0_5.contextData.sourceEquipmentInstance then
		var2_5, var0_5, var1_5 = EquipmentTransformUtil.CheckTransformEnoughGold({
			arg0_5.contextData.formulaId
		}, arg0_5.contextData.sourceEquipmentInstance)
	end

	local var3_5 = setColorStr(var0_5, var2_5 and COLOR_WHITE or COLOR_RED)

	if var1_5 > 0 then
		var3_5 = var3_5 .. setColorStr(" + " .. var1_5, var2_5 and COLOR_GREEN or COLOR_RED)
	end

	arg0_5.consumePanel:Find("GoldText"):GetComponent(typeof(Text)).text = var3_5
end

function var0_0.UpdateFormula(arg0_6, arg1_6)
	if arg1_6 == arg0_6.contextData.formulaId then
		return
	end

	assert(arg1_6 and arg1_6 > 0, "target formulaId is invalid")

	arg0_6.contextData.formulaId = arg1_6

	local var0_6 = pg.equip_upgrade_data[arg1_6]

	arg0_6.contextData.formula = var0_6
	arg0_6.equipmentSourceId = var0_6.upgrade_from
	arg0_6.equipmentTarget = var0_6.target_id
	arg0_6.transformMaterials = var0_6.material_consume

	arg0_6:UpdateConsumeComparer()

	local var1_6 = arg0_6.env.tracebackHelper:GetEquipmentTransformCandicates(arg0_6.equipmentSourceId)
	local var2_6

	if arg0_6.contextData.sourceEquipmentInstance then
		var2_6 = _.detect(var1_6, function(arg0_7)
			return EquipmentTransformUtil.SameDrop(arg0_7, arg0_6.contextData.sourceEquipmentInstance)
		end)
	end

	arg0_6.contextData.sourceEquipmentInstance = var2_6

	PlayerPrefs.SetInt("ShowTransformTip_" .. arg0_6.equipmentTarget, 1)
	PlayerPrefs.Save()
	arg0_6:emit(EquipmentTransformMediator.UPDATE_NEW_FLAG, arg0_6.equipmentTarget)
	setActive(arg0_6.layer:Find("SwitchButton"), #EquipmentProxy.GetTransformSources(arg0_6.equipmentTarget) > 1)
	arg0_6:UpdatePage()
end

function var0_0.UpdatePage(arg0_8)
	arg0_8:UpdateSourceEquipmentPaths()
	arg0_8:UpdateFormulaItems()
	arg0_8:UpdateTargetInfo()
	arg0_8:UpdateSourceInfo()
end

function var0_0.UpdateSourceEquipmentPaths(arg0_9)
	local var0_9 = arg0_9.env.tracebackHelper:GetSortedEquipTraceBack(arg0_9.equipmentSourceId)

	arg0_9.hasRoot = _.any(var0_9, function(arg0_10)
		local var0_10 = arg0_10.candicates

		return var0_10 and #var0_10 > 0 and EquipmentTransformUtil.CheckTransformFormulasSucceed(arg0_10.formulas, var0_10[#var0_10])
	end)

	local var1_9 = arg0_9.env.tracebackHelper:GetEquipmentTransformCandicates(arg0_9.equipmentSourceId)

	arg0_9.childsCanUse = _.any(var1_9, function(arg0_11)
		if arg0_11.type == DROP_TYPE_ITEM then
			return arg0_11.template.count >= arg0_11.composeCfg.material_num
		elseif arg0_11.type == DROP_TYPE_EQUIP then
			return arg0_11.template.count > 0
		end
	end)
end

function var0_0.CheckEnoughMaterials(arg0_12)
	if not arg0_12.contextData.formula then
		return
	end

	if not arg0_12.contextData.sourceEquipmentInstance then
		return
	end

	local var0_12 = arg0_12.contextData.sourceEquipmentInstance
	local var1_12, var2_12 = EquipmentTransformUtil.CheckTransformFormulasSucceed({
		arg0_12.contextData.formulaId
	}, var0_12)

	if not var1_12 then
		return false, var2_12
	end

	return true
end

function var0_0.UpdateFormulaItems(arg0_13)
	for iter0_13, iter1_13 in ipairs(arg0_13.formulaItems) do
		local var0_13 = iter1_13:Find("Item")
		local var1_13 = arg0_13.transformMaterials[iter0_13]

		setActive(iter1_13, var1_13)

		if var1_13 then
			local var2_13 = {
				type = DROP_TYPE_ITEM,
				id = var1_13[1],
				count = var1_13[2]
			}

			updateDrop(var0_13, var2_13)
			onButton(arg0_13, var0_13, function()
				arg0_13:emit(var0_0.ON_DROP, var2_13)
			end, SFX_PANEL)

			local var3_13 = getProxy(BagProxy):getItemCountById(var1_13[1]) or 0

			setText(iter1_13:Find("NumText"), setColorStr(var3_13, var3_13 < var1_13[2] and COLOR_RED or "#000F") .. "/" .. var1_13[2])

			local var4_13 = arg0_13.equipmentSourceId == 0

			setActive(iter1_13:Find("Line"), not var4_13)
			setActive(iter1_13:Find("Line2"), var4_13)
		end
	end
end

function var0_0.UpdateTargetInfo(arg0_15)
	updateDrop(arg0_15.targetEquipItem:Find("Item"), {
		id = arg0_15.equipmentTarget,
		type = DROP_TYPE_EQUIP
	})
	arg0_15.targetEquipItem:Find("Mask/NameText"):GetComponent("ScrollText"):SetText(Equipment.getConfigData(arg0_15.equipmentTarget).name)

	local var0_15 = arg0_15.layer:Find("InfoPanel")
	local var1_15 = arg0_15.env.tracebackHelper:GetEquipmentTransformCandicates(arg0_15.equipmentTarget)
	local var2_15 = 0
	local var3_15 = 0

	for iter0_15, iter1_15 in ipairs(var1_15) do
		if iter1_15.type == DROP_TYPE_EQUIP then
			if iter1_15.template.shipId then
				var2_15 = var2_15 + iter1_15.template.count
			else
				var3_15 = var3_15 + iter1_15.template.count
			end
		end
	end

	setText(var0_15:Find("StoreCount/OnShip/ValueText"), var2_15)
	setText(var0_15:Find("StoreCount/Free/ValueText"), var3_15)

	local var4_15 = Equipment.New({
		id = arg0_15.equipmentTarget
	})
	local var5_15 = var0_15:Find("Viewport/Content")

	updateEquipInfo(var5_15, var4_15:GetPropertiesInfo(), var4_15:GetSkill())
	Canvas.ForceUpdateCanvases()
	var0_0.FitTextBGSize(var5_15:Find("attrs"))
	var0_0.FitTextBGSize(var5_15:Find("weapon"))
	var0_0.FitTextBGSize(var5_15:Find("equip_info"))
end

function var0_0.FitTextBGSize(arg0_16)
	for iter0_16 = 0, arg0_16.childCount - 1 do
		local var0_16 = arg0_16:GetChild(iter0_16)
		local var1_16 = var0_16:Find("base/NameBG").sizeDelta

		var1_16.x = var0_16:Find("base/name").rect.width + 18
		var0_16:Find("base/NameBG").sizeDelta = var1_16

		var0_0.FitTextBGSize(var0_16:Find("subs"))
	end
end

function var0_0.UpdateSourceInfo(arg0_17)
	local var0_17 = arg0_17.contextData.sourceEquipmentInstance
	local var1_17 = var0_17 or {
		id = arg0_17.equipmentSourceId,
		type = DROP_TYPE_EQUIP
	}
	local var2_17 = arg0_17.equipmentSourceId == 0

	setActive(arg0_17.sourceEquipItem, not var2_17)

	if var2_17 then
		return
	end

	updateDrop(arg0_17.sourceEquipItem:Find("Item"), var1_17)

	local var3_17 = arg0_17.sourceEquipItem:Find("Item/icon_bg/count")
	local var4_17 = ""

	if var0_17 and var0_17.type == DROP_TYPE_ITEM then
		local var5_17 = var0_17.template.count >= var0_17.composeCfg.material_num

		var4_17 = setColorStr(math.min(var0_17.template.count, var0_17.composeCfg.material_num), var5_17 and COLOR_WHITE or COLOR_RED)
	end

	setText(var3_17, var4_17)
	arg0_17.sourceEquipItem:Find("Mask/NameText"):GetComponent("ScrollText"):SetText(Equipment.getConfigData(arg0_17.equipmentSourceId).name)
	setActive(arg0_17.sourceEquipItem:Find("craftable"), arg0_17.hasRoot)
	onButton(arg0_17, arg0_17.sourceEquipItem:Find("craftable"), function()
		arg0_17:emit(EquipmentTransformMediator.OPEN_LAYER, Context.New({
			mediator = EquipmentTraceBackMediator,
			viewComponent = EquipmentTraceBackLayer,
			data = {
				TargetEquipmentId = arg0_17.equipmentSourceId
			}
		}))
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.sourceEquipItem:Find("Item"), function()
		if arg0_17.childsCanUse then
			arg0_17:emit(EquipmentTransformMediator.SELECT_TRANSFORM_FROM_STOREHOUSE, arg0_17.equipmentSourceId)
		end
	end, SFX_PANEL)

	local var6_17 = arg0_17.sourceEquipItem:Find("Status")

	if not arg0_17.childsCanUse then
		setImageSprite(var6_17, LoadSprite("ui/equipmenttransformui_atlas", "noown"))
		setActive(var6_17, true)
	elseif not var0_17 then
		setImageSprite(var6_17, LoadSprite("ui/equipmenttransformui_atlas", "unselect"))
		setActive(var6_17, true)
	else
		setActive(var6_17, false)
	end

	local var7_17 = var0_17 and var0_17.template.shipId

	setActive(arg0_17.sourceEquipItem:Find("EquipShip"), var7_17)

	if var7_17 then
		local var8_17 = getProxy(BayProxy):getShipById(var7_17)

		arg0_17.loader:GetSprite("qicon/" .. var8_17:getPainting(), "", arg0_17.sourceEquipItem:Find("EquipShip/Image"))
	end
end

function var0_0.didEnter(arg0_20)
	onButton(arg0_20, arg0_20._tf:Find("BG"), function()
		arg0_20:closeView()
	end)
	onButton(arg0_20, arg0_20.consumePanel:Find("ComposeBtn"), function()
		local var0_22 = arg0_20.contextData.sourceEquipmentInstance

		if arg0_20.equipmentSourceId ~= 0 and not var0_22 then
			if arg0_20.childsCanUse then
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_quick_interface_feedback_source_chosen"))

				return
			elseif arg0_20.hasRoot then
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_feedback_equipment_can_be_produced"))

				return
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_feedback_lack_of_equipment"))

				return
			end
		end

		if not arg0_20:CheckEnoughMaterials() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_feedback_lack_of_materials"))

			return
		end

		arg0_20:emit(EquipmentTransformMediator.TRANSFORM_EQUIP, var0_22, arg0_20.contextData.formulaId)
	end, SFX_PANEL)
	onButton(arg0_20, arg0_20.layer:Find("OverviewBtn"), function()
		arg0_20:emit(EquipmentTransformMediator.OPEN_TRANSFORM_TREE, arg0_20.equipmentTarget)
	end, SFX_CANCEL)
	onButton(arg0_20, arg0_20.layer:Find("SwitchButton"), function()
		local var0_24 = EquipmentProxy.GetTransformSources(arg0_20.equipmentTarget)
		local var1_24 = table.indexof(var0_24, arg0_20.contextData.formulaId)
		local var2_24

		var2_24 = var1_24 and var1_24 % #var0_24 + 1 or 1
		arg0_20.contextData.sourceEquipmentInstance = nil

		arg0_20:UpdateFormula(var0_24[var2_24])
	end, SFX_PANEL)
	onButton(arg0_20, arg0_20.layer:Find("HelpBtn"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.equipment_upgrade_help.tip
		})
	end, SFX_PANEL)
	assert(arg0_20.contextData.formulaId)

	local var0_20 = arg0_20.contextData.formulaId

	arg0_20.contextData.formulaId = nil

	arg0_20:UpdateFormula(var0_20)

	local var1_20, var2_20 = getProxy(ContextProxy):getContextByMediator(EquipmentTransformMediator)
	local var3_20 = var2_20 and pg.m02:retrieveMediator(var2_20.mediator.__cname)

	setActive(arg0_20.layer:Find("OverviewBtn"), var3_20.class ~= EquipmentTransformTreeMediator)
	pg.UIMgr.GetInstance():BlurPanel(arg0_20._tf)
end

function var0_0.willExit(arg0_26)
	arg0_26.loader:Clear()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_26._tf)
end

return var0_0
