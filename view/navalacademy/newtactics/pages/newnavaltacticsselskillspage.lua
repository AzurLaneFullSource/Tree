local var0_0 = class("NewNavalTacticsSelSkillsPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "NewNavalTacticsSkillsPage"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.confrimBtn = arg0_2:findTF("frame/confirm_btn")
	arg0_2.skillTpl = arg0_2:findTF("frame/skill_container/content/skill")
	arg0_2.emptyTpl = arg0_2:findTF("frame/skill_container/content/empty")
	arg0_2.toggleGroup = arg0_2:findTF("frame/skill_container/content"):GetComponent(typeof(ToggleGroup))
	arg0_2.skillCards = {
		NewNavalTacticsSkillCard.New(arg0_2.skillTpl)
	}
	arg0_2.emptyTpls = {
		arg0_2.emptyTpl
	}

	setText(arg0_2.confrimBtn:Find("Image"), i18n("tactics_class_start"))
	setText(arg0_2:findTF("frame/bg/title"), i18n("nav_tactics_sel_skill_title"))
end

function var0_0.SetCancelCallback(arg0_3, arg1_3)
	arg0_3.onCancelCallback = arg1_3
end

function var0_0.SetHideCallback(arg0_4, arg1_4)
	arg0_4.onHideCallback = arg1_4
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5._tf, function()
		arg0_5:Cancel()
		arg0_5:Hide()

		if arg0_5.onCancelCallback then
			arg0_5.onCancelCallback()

			arg0_5.onCancelCallback = nil
		end
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.confrimBtn, function()
		if not arg0_5.selSkill or not arg0_5.selIndex then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_should_exist_skill"))

			return
		end

		if arg0_5.selSkill:IsMaxLevel() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_max_level"))

			return
		end

		arg0_5.student:setSkillIndex(arg0_5.selIndex)
		arg0_5:emit(NewNavalTacticsLayer.ON_SKILL_SELECTED, arg0_5.student)
	end, SFX_PANEL)
end

function var0_0.Show(arg0_8, arg1_8, arg2_8)
	var0_0.super.Show(arg0_8)
	pg.UIMgr.GetInstance():BlurPanel(arg0_8._tf)

	if arg1_8 ~= arg0_8.student then
		arg0_8.skillIndex = arg2_8
		arg0_8.student = arg1_8
		arg0_8.selSkill = nil
		arg0_8.selIndex = nil

		arg0_8:UpdateSkillList(arg1_8)
	end
end

function var0_0.Cancel(arg0_9)
	arg0_9:emit(NewNavalTacticsMediator.ON_CANCEL_ADD_STUDENT)
end

function var0_0.Hide(arg0_10)
	var0_0.super.Hide(arg0_10)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_10._tf, pg.UIMgr.GetInstance().UIMain)

	if arg0_10.onHideCallback then
		arg0_10.onHideCallback()

		arg0_10.onHideCallback = nil
	end
end

function var0_0.UpdateSkillList(arg0_11, arg1_11)
	local var0_11 = getProxy(BayProxy):RawGetShipById(arg1_11.shipId)
	local var1_11 = var0_11:getSkillList()
	local var2_11 = #var1_11
	local var3_11 = var2_11 >= 3 and var2_11 or 3

	for iter0_11 = 1, var2_11 do
		local var4_11 = var1_11[iter0_11]

		arg0_11:UpdateSkill(iter0_11, ShipSkill.New(var0_11.skills[var4_11], var0_11.id))
	end

	local var5_11 = 0

	for iter1_11 = var2_11 + 1, var3_11 do
		var5_11 = var5_11 + 1

		arg0_11:UpdateEmptySkill(var5_11, iter1_11)
	end

	arg0_11:ClearShipCards(arg0_11.skillCards, var2_11)
	arg0_11:ClearEmtptyTpls(arg0_11.emptyTpls, var5_11)

	if var2_11 > 0 then
		arg0_11.toggleGroup:SetAllTogglesOff()
		triggerToggle(arg0_11.skillCards[1]._tf, true)
	end

	if arg0_11.skillIndex then
		arg0_11:TriggerDefault(var1_11)
	end
end

function var0_0.TriggerDefault(arg0_12, arg1_12)
	local var0_12 = arg0_12.skillIndex

	if var0_12 and var0_12 > 0 then
		triggerToggle(arg0_12.skillCards[var0_12]._tf, true)
		triggerButton(arg0_12.confrimBtn)
	end

	arg0_12.skillIndex = nil
end

function var0_0.UpdateSkill(arg0_13, arg1_13, arg2_13)
	local var0_13 = arg0_13.skillCards[arg1_13]

	if not var0_13 then
		var0_13 = NewNavalTacticsSkillCard.New(Object.Instantiate(arg0_13.skillTpl, arg0_13.skillTpl.parent))
		arg0_13.skillCards[arg1_13] = var0_13
	end

	var0_13._tf:SetSiblingIndex(arg1_13 - 1)
	var0_13:Enable()
	var0_13:Update(arg2_13)
	onToggle(arg0_13, var0_13._tf, function(arg0_14)
		if arg0_14 then
			arg0_13.selSkill = arg2_13
			arg0_13.selIndex = arg1_13
		end
	end, SFX_PANEL)
end

function var0_0.ClearShipCards(arg0_15, arg1_15, arg2_15)
	for iter0_15 = #arg1_15, arg2_15 + 1, -1 do
		arg1_15[iter0_15]:Disable()
	end
end

function var0_0.UpdateEmptySkill(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.emptyTpls[arg1_16]

	if not var0_16 then
		var0_16 = Object.Instantiate(arg0_16.emptyTpl, arg0_16.emptyTpl.parent)
		arg0_16.emptyTpls[arg1_16] = var0_16
	end

	var0_16:SetSiblingIndex(arg2_16 - 1)
	setActive(var0_16, true)
end

function var0_0.ClearEmtptyTpls(arg0_17, arg1_17, arg2_17)
	for iter0_17 = #arg1_17, arg2_17 + 1, -1 do
		setActive(arg1_17[iter0_17], false)
	end
end

function var0_0.OnDestroy(arg0_18)
	if arg0_18:isShowing() then
		arg0_18:Hide()
	end

	for iter0_18, iter1_18 in ipairs(arg0_18.skillCards) do
		iter1_18:Dispose()
	end

	arg0_18.skillCards = nil
end

return var0_0
