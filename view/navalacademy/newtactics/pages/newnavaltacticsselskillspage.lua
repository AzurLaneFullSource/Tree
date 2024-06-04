local var0 = class("NewNavalTacticsSelSkillsPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "NewNavalTacticsSkillsPage"
end

function var0.OnLoaded(arg0)
	arg0.confrimBtn = arg0:findTF("frame/confirm_btn")
	arg0.skillTpl = arg0:findTF("frame/skill_container/content/skill")
	arg0.emptyTpl = arg0:findTF("frame/skill_container/content/empty")
	arg0.toggleGroup = arg0:findTF("frame/skill_container/content"):GetComponent(typeof(ToggleGroup))
	arg0.skillCards = {
		NewNavalTacticsSkillCard.New(arg0.skillTpl)
	}
	arg0.emptyTpls = {
		arg0.emptyTpl
	}

	setText(arg0.confrimBtn:Find("Image"), i18n("tactics_class_start"))
	setText(arg0:findTF("frame/bg/title"), i18n("nav_tactics_sel_skill_title"))
end

function var0.SetCancelCallback(arg0, arg1)
	arg0.onCancelCallback = arg1
end

function var0.SetHideCallback(arg0, arg1)
	arg0.onHideCallback = arg1
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Cancel()
		arg0:Hide()

		if arg0.onCancelCallback then
			arg0.onCancelCallback()

			arg0.onCancelCallback = nil
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.confrimBtn, function()
		if not arg0.selSkill or not arg0.selIndex then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_should_exist_skill"))

			return
		end

		if arg0.selSkill:IsMaxLevel() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_max_level"))

			return
		end

		arg0.student:setSkillIndex(arg0.selIndex)
		arg0:emit(NewNavalTacticsLayer.ON_SKILL_SELECTED, arg0.student)
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1, arg2)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	if arg1 ~= arg0.student then
		arg0.skillIndex = arg2
		arg0.student = arg1
		arg0.selSkill = nil
		arg0.selIndex = nil

		arg0:UpdateSkillList(arg1)
	end
end

function var0.Cancel(arg0)
	arg0:emit(NewNavalTacticsMediator.ON_CANCEL_ADD_STUDENT)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, pg.UIMgr.GetInstance().UIMain)

	if arg0.onHideCallback then
		arg0.onHideCallback()

		arg0.onHideCallback = nil
	end
end

function var0.UpdateSkillList(arg0, arg1)
	local var0 = getProxy(BayProxy):RawGetShipById(arg1.shipId)
	local var1 = var0:getSkillList()
	local var2 = #var1
	local var3 = var2 >= 3 and var2 or 3

	for iter0 = 1, var2 do
		local var4 = var1[iter0]

		arg0:UpdateSkill(iter0, ShipSkill.New(var0.skills[var4], var0.id))
	end

	local var5 = 0

	for iter1 = var2 + 1, var3 do
		var5 = var5 + 1

		arg0:UpdateEmptySkill(var5, iter1)
	end

	arg0:ClearShipCards(arg0.skillCards, var2)
	arg0:ClearEmtptyTpls(arg0.emptyTpls, var5)

	if var2 > 0 then
		arg0.toggleGroup:SetAllTogglesOff()
		triggerToggle(arg0.skillCards[1]._tf, true)
	end

	if arg0.skillIndex then
		arg0:TriggerDefault(var1)
	end
end

function var0.TriggerDefault(arg0, arg1)
	local var0 = arg0.skillIndex

	if var0 and var0 > 0 then
		triggerToggle(arg0.skillCards[var0]._tf, true)
		triggerButton(arg0.confrimBtn)
	end

	arg0.skillIndex = nil
end

function var0.UpdateSkill(arg0, arg1, arg2)
	local var0 = arg0.skillCards[arg1]

	if not var0 then
		var0 = NewNavalTacticsSkillCard.New(Object.Instantiate(arg0.skillTpl, arg0.skillTpl.parent))
		arg0.skillCards[arg1] = var0
	end

	var0._tf:SetSiblingIndex(arg1 - 1)
	var0:Enable()
	var0:Update(arg2)
	onToggle(arg0, var0._tf, function(arg0)
		if arg0 then
			arg0.selSkill = arg2
			arg0.selIndex = arg1
		end
	end, SFX_PANEL)
end

function var0.ClearShipCards(arg0, arg1, arg2)
	for iter0 = #arg1, arg2 + 1, -1 do
		arg1[iter0]:Disable()
	end
end

function var0.UpdateEmptySkill(arg0, arg1, arg2)
	local var0 = arg0.emptyTpls[arg1]

	if not var0 then
		var0 = Object.Instantiate(arg0.emptyTpl, arg0.emptyTpl.parent)
		arg0.emptyTpls[arg1] = var0
	end

	var0:SetSiblingIndex(arg2 - 1)
	setActive(var0, true)
end

function var0.ClearEmtptyTpls(arg0, arg1, arg2)
	for iter0 = #arg1, arg2 + 1, -1 do
		setActive(arg1[iter0], false)
	end
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end

	for iter0, iter1 in ipairs(arg0.skillCards) do
		iter1:Dispose()
	end

	arg0.skillCards = nil
end

return var0
