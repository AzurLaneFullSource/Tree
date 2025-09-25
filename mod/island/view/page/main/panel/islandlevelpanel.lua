local var0_0 = class("IslandLevelPanel", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandLevelPanel"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.levelPanel = arg0_2._tf:Find("level_panel")
	arg0_2.levelTxt = arg0_2.levelPanel:Find("level"):GetComponent(typeof(Text))
	arg0_2.nameTxt = arg0_2.levelPanel:Find("name"):GetComponent(typeof(Text))
	arg0_2.expTr = arg0_2.levelPanel:Find("exp")
	arg0_2.prosperityTxt = arg0_2.levelPanel:Find("prosperity/Text"):GetComponent(typeof(Text))
	arg0_2.prosperityLabel = arg0_2.levelPanel:Find("prosperity"):GetComponent(typeof(Text))
	arg0_2.levelTip = arg0_2.levelPanel:Find("red_dot")

	setActive(arg0_2.levelPanel:Find("edit"), false)

	arg0_2.expBtn = arg0_2.levelPanel:Find("level")
	arg0_2.expPanel = arg0_2._tf:Find("exp")

	setActive(arg0_2.expPanel, false)

	arg0_2.expPanelTxt = arg0_2.expPanel:Find("Text"):GetComponent(typeof(Text))
	arg0_2.expPanelAddTF = arg0_2.expPanel:Find("add")
	arg0_2.expAnimation = arg0_2.expPanel:GetComponent(typeof(Animation))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.nameTxt.gameObject, function()
		arg0_3:emit(IslandMediator.OPEN_PAGE, "IslandSelfCardPage")
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.expBtn, function()
		arg0_3:ShowExp()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_6)
	var0_0.super.Show(arg0_6)
	arg0_6:UpdateIslandInfo()
	arg0_6:UpdateTip()
end

function var0_0.UpdateIslandInfo(arg0_7)
	local var0_7 = getProxy(IslandProxy):GetIsland()

	arg0_7.levelTxt.text = var0_7:GetLevel()
	arg0_7.nameTxt.text = var0_7:GetName()

	if var0_7:IsMaxLevel() then
		setFillAmount(arg0_7.expTr, 1)
	else
		setFillAmount(arg0_7.expTr, var0_7:GetExp() / var0_7:GetTargeExp())
	end

	if var0_7:CanAddProsperity() then
		arg0_7.prosperityTxt.text = var0_7:GetProsperity() .. "/" .. var0_7:GetTargetProsperity()
	else
		arg0_7.prosperityTxt.text = "MAX"
	end

	arg0_7.prosperityLabel.text = i18n("island_prosperity_level")
end

function var0_0.UpdateTip(arg0_8)
	setActive(arg0_8.levelTip, getProxy(IslandProxy):ShouldTip())
end

function var0_0.ShowExp(arg0_9)
	if arg0_9.timer then
		arg0_9.timer:Stop()

		arg0_9.timer = nil
	end

	local var0_9 = getProxy(IslandProxy):GetIsland()

	arg0_9.expPanelTxt.text = "<color=#39bfff>" .. var0_9:GetExp() .. "</color><color=#ffffff>/" .. var0_9:GetTargeExp() .. "</color>"

	setActive(arg0_9.expPanel:Find("effect"), false)
	setActive(arg0_9.expPanelAddTF, false)
	setActive(arg0_9.expPanel, true)
	arg0_9.expAnimation:Play("anim_IslandUI_Exp_In")

	arg0_9.timer = Timer.New(function()
		arg0_9.expAnimation:Play("anim_IslandUI_Exp_Out")
	end, 5, 1)

	arg0_9.timer:Start()
end

function var0_0.ShowExpAdd(arg0_11, arg1_11, arg2_11)
	onDelayTick(function()
		existCall(arg2_11)
	end, 0.5)

	if arg0_11.timer then
		arg0_11.timer:Stop()

		arg0_11.timer = nil
	end

	local var0_11 = getProxy(IslandProxy):GetIsland()

	arg0_11.expPanelTxt.text = "<color=#39bfff>" .. var0_11:GetExp() .. "</color><color=#ffffff>/" .. var0_11:GetTargeExp() .. "</color>"

	setActive(arg0_11.expPanel:Find("effect"), true)
	setActive(arg0_11.expPanelAddTF, true)
	setText(arg0_11.expPanelAddTF, "+" .. arg1_11)
	setActive(arg0_11.expPanel, true)
	arg0_11.expAnimation:Play("anim_IslandUI_Exp_In")

	arg0_11.timer = Timer.New(function()
		arg0_11.expAnimation:Play("anim_IslandUI_Exp_Out")
	end, 3, 1)

	arg0_11.timer:Start()
end

function var0_0.OnDestroy(arg0_14)
	if arg0_14.timer then
		arg0_14.timer:Stop()

		arg0_14.timer = nil
	end
end

return var0_0
