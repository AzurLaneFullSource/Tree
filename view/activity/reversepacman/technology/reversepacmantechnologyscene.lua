local var0_0 = class("ReversePacmanTechnologyScene", import("view.base.BaseUI"))

var0_0.TOGGLE_TYPE = {
	ROLE_SKILL = 2,
	PLAYER_SKILL = 3,
	HR = 1
}

function var0_0.getUIName(arg0_1)
	return "ReversePacmanTechnologyUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2.uiBgBtn, function()
		arg0_2:closeView()
	end, SFX_CANCEL)
	onButton(arg0_2, arg0_2.uiBackBtn, function()
		arg0_2:closeView()
	end, SFX_CANCEL)
	onToggle(arg0_2, arg0_2.uiHrBtn, function(arg0_5)
		if arg0_5 then
			arg0_2:ShowHrPanel()
		elseif arg0_2.hrView then
			local var0_5 = ReversePacmanTools.GetActivity()

			if var0_5:GetGiftTip() then
				var0_5:SetGiftTip()
				arg0_2:RefreshTips()
			end
		end

		arg0_2.hrToggleItem:OnSelected(arg0_5)
		setActive(arg0_2.uiHrPanel, arg0_5)
	end, SFX_PANEL)
	onToggle(arg0_2, arg0_2.uiRoleSkillBtn, function(arg0_6)
		if arg0_6 then
			arg0_2:ShowRoleSkillPanel()
		elseif arg0_2.rollSkillView then
			local var0_6 = ReversePacmanTools.GetActivity()

			if var0_6:GetRoleSkillTip() then
				var0_6:SetRoleSkillTip()
				arg0_2:RefreshTips()
			end
		end

		arg0_2.roleSkillToggleItem:OnSelected(arg0_6)
		setActive(arg0_2.uiRoleSkillPanel, arg0_6)
	end, SFX_PANEL)
	onToggle(arg0_2, arg0_2.uiPlayerSkillBtn, function(arg0_7)
		if arg0_7 then
			arg0_2:ShowPlayerSkillPanel()
		elseif arg0_2.playerSkillView then
			local var0_7 = ReversePacmanTools.GetActivity()

			if var0_7:GetPlayerSkillTip() then
				var0_7:SetPlayerSkillTip()
				arg0_2:RefreshTips()
			end
		end

		arg0_2.playerSkillToggleItem:OnSelected(arg0_7)
		setActive(arg0_2.uiPlayerSkillPanel, arg0_7)
	end, SFX_PANEL)
	setText(arg0_2.uiTitleText, i18n("reverse_pacman_select_logistics_sys"))
	setActive(arg0_2.uiHrPanel, false)
	setActive(arg0_2.uiRoleSkillPanel, false)
	setActive(arg0_2.uiPlayerSkillPanel, false)

	arg0_2.hrToggleItem = ReversePacmanTechnologyHrToggle.New(arg0_2.uiHrBtn, arg0_2)
	arg0_2.roleSkillToggleItem = ReversePacmanTechnologyRoleSkillToggle.New(arg0_2.uiRoleSkillBtn, arg0_2)
	arg0_2.playerSkillToggleItem = ReversePacmanTechnologyPlayerSkillToggle.New(arg0_2.uiPlayerSkillBtn, arg0_2)
end

function var0_0.didEnter(arg0_8)
	arg0_8:BlurPanel(arg0_8._tf)

	local var0_8 = ReversePacmanTools.GetActivity()
	local var1_8 = arg0_8.contextData.toggleType

	if var0_8:GetGiftTip() then
		var1_8 = var0_0.TOGGLE_TYPE.HR
	elseif var0_8:GetRoleSkillTip() then
		var1_8 = var0_0.TOGGLE_TYPE.ROLE_SKILL
	elseif var0_8:GetPlayerSkillTip() then
		var1_8 = var0_0.TOGGLE_TYPE.PLAYER_SKILL
	end

	if var1_8 == var0_0.TOGGLE_TYPE.ROLE_SKILL then
		triggerToggle(arg0_8.uiRoleSkillBtn, true)
	elseif var1_8 == var0_0.TOGGLE_TYPE.PLAYER_SKILL then
		triggerToggle(arg0_8.uiPlayerSkillBtn, true)
	else
		triggerToggle(arg0_8.uiHrBtn, true)
	end

	arg0_8:RefreshTips()
end

function var0_0.ShowHrPanel(arg0_9)
	arg0_9.hrView = arg0_9.hrView or ReversePacmanTechnologyHrView.New(arg0_9.uiHrPanel, arg0_9)

	arg0_9.hrView:Show()
end

function var0_0.ShowRoleSkillPanel(arg0_10)
	arg0_10.rollSkillView = arg0_10.rollSkillView or ReversePacmanTechnologyRoleSkillView.New(arg0_10.uiRoleSkillPanel, arg0_10)
end

function var0_0.ShowPlayerSkillPanel(arg0_11)
	arg0_11.playerSkillView = arg0_11.playerSkillView or ReversePacmanTechnologyPlayerSkillView.New(arg0_11.uiPlayerSkillPanel, arg0_11)
end

function var0_0.RefreshTips(arg0_12)
	arg0_12.hrToggleItem:RefreshTip()
	arg0_12.roleSkillToggleItem:RefreshTip()
	arg0_12.playerSkillToggleItem:RefreshTip()
end

function var0_0.willExit(arg0_13)
	arg0_13:UnOverlayPanel(arg0_13._tf)
	arg0_13.hrToggleItem:willExit()

	arg0_13.hrToggleItem = nil

	arg0_13.roleSkillToggleItem:willExit()

	arg0_13.roleSkillToggleItem = nil

	arg0_13.playerSkillToggleItem:willExit()

	arg0_13.playerSkillToggleItem = nil

	if arg0_13.hrView then
		local var0_13 = ReversePacmanTools.GetActivity()

		if var0_13:GetGiftTip() then
			var0_13:SetGiftTip()
		end

		arg0_13.hrView:willExit()

		arg0_13.hrView = nil
	end

	if arg0_13.rollSkillView then
		local var1_13 = ReversePacmanTools.GetActivity()

		if var1_13:GetRoleSkillTip() then
			var1_13:SetRoleSkillTip()
		end

		arg0_13.rollSkillView:willExit()

		arg0_13.rollSkillView = nil
	end

	if arg0_13.playerSkillView then
		local var2_13 = ReversePacmanTools.GetActivity()

		if var2_13:GetPlayerSkillTip() then
			var2_13:SetPlayerSkillTip()
		end

		arg0_13.playerSkillView:willExit()

		arg0_13.playerSkillView = nil
	end
end

return var0_0
