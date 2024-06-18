local var0_0 = class("ActivityBossBuffSelectLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ActivityBossBuffSelectUI"
end

function var0_0.init(arg0_2)
	arg0_2.buffList = arg0_2._tf:Find("BuffList")
	arg0_2.buffScrollComp = arg0_2.buffList:Find("ScrollView"):GetComponent("LScrollRect")
	arg0_2.activeBuffRect = arg0_2._tf:Find("Active")
	arg0_2.activeBuffScrollComp = arg0_2.activeBuffRect:Find("ScrollView"):GetComponent("LScrollRect")
	arg0_2.startBtn = arg0_2._tf:Find("Start")
	arg0_2.top = arg0_2._tf:Find("top")

	setText(arg0_2._tf:Find("BuffList/Title/Text"), i18n("activityboss_sp_all_buff"))
	setText(arg0_2._tf:Find("Rewards/Desc"), i18n("activityboss_sp_best_score"))
	setText(arg0_2._tf:Find("Rewards/Reward/Text"), i18n("activityboss_sp_display_reward"))
	setText(arg0_2._tf:Find("Active/Title/Text"), i18n("activityboss_sp_active_buff"))
	setText(arg0_2._tf:Find("Active/PT/Title"), i18n("activityboss_sp_score_bonus"))
end

function var0_0.didEnter(arg0_3)
	arg0_3.buffDatas = {}
	arg0_3.buffs = _.map(arg0_3.contextData.spEnemyInfo:GetSelectableBuffs(), function(arg0_4)
		local var0_4 = ActivityBossBuff.New({
			configId = arg0_4
		})

		arg0_3.buffDatas[var0_4] = {}

		return var0_4
	end)

	local var0_3 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	_.each(var0_3:GetHistoryBuffs(), function(arg0_5)
		local var0_5 = _.detect(arg0_3.buffs, function(arg0_6)
			return arg0_6:GetConfigID() == arg0_5
		end)

		arg0_3.buffDatas[var0_5].selected = true
	end)

	arg0_3.rewards = arg0_3.contextData.spEnemyInfo:GetRewards()
	arg0_3.targets = arg0_3.contextData.spEnemyInfo:GetScoreTargets()
	arg0_3.score = arg0_3.contextData.score

	function arg0_3.buffScrollComp.onUpdateItem(arg0_7, arg1_7)
		arg0_3:UpdateBuffItem(arg0_7 + 1, arg1_7)
	end

	function arg0_3.activeBuffScrollComp.onUpdateItem(arg0_8, arg1_8)
		arg0_3:UpdateActiveBuffItem(arg0_8 + 1, arg1_8)
	end

	onButton(arg0_3, arg0_3.top:Find("back_btn"), function()
		arg0_3:closeView()
	end, SOUND_BACK)
	onButton(arg0_3, arg0_3.top:Find("option"), function()
		arg0_3:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("Rewards/Reward"), function()
		arg0_3:emit(ActivityBossBuffSelectMediator.SHOW_REWARDS, arg0_3.rewards, arg0_3.targets, var0_3:GetHighestScore())
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.startBtn, function()
		arg0_3:emit(ActivityBossBuffSelectMediator.ON_START, arg0_3.activeBuffs)
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
	setText(arg0_3._tf:Find("Rewards/Score"), var0_3:GetHighestScore())
	arg0_3:UpdateView()
end

function var0_0.UpdateView(arg0_13)
	arg0_13.buffScrollComp:SetTotalCount(#arg0_13.buffs)
	arg0_13:UpdateActiveBuffs()
end

function var0_0.UpdateBuffItem(arg0_14, arg1_14, arg2_14)
	local var0_14 = tf(arg2_14)
	local var1_14 = arg0_14.buffs[arg1_14]
	local var2_14 = arg0_14.buffDatas[var1_14]

	setActive(var0_14:Find("Selected"), var2_14.selected)
	setText(var0_14:Find("Name/Text"), var1_14:GetDesc())
	setText(var0_14:Find("PT/Text"), "+" .. var1_14:GetBonusText())
	GetImageSpriteFromAtlasAsync(var1_14:GetIconPath(), "", var0_14:Find("Item/Icon"))
	onButton(arg0_14, var0_14, function()
		var2_14.selected = not var2_14.selected

		arg0_14:UpdateView()
	end, SFX_PANEL)
end

function var0_0.UpdateActiveBuffs(arg0_16)
	arg0_16.activeBuffs = _.select(arg0_16.buffs, function(arg0_17)
		return arg0_16.buffDatas[arg0_17].selected
	end)

	local var0_16 = math.max(math.floor((#arg0_16.activeBuffs - 1) / 5) + 1, 4) * 5

	arg0_16.activeBuffScrollComp:SetTotalCount(var0_16)

	local var1_16 = _.reduce(arg0_16.activeBuffs, 0, function(arg0_18, arg1_18)
		return arg0_18 + arg1_18:GetBonus()
	end)
	local var2_16 = Mathf.Round(var1_16 * 100)

	setText(arg0_16.activeBuffRect:Find("PT/Text"), "+" .. var2_16 .. "%")
end

function var0_0.UpdateActiveBuffItem(arg0_19, arg1_19, arg2_19)
	local var0_19 = tf(arg2_19)
	local var1_19 = arg0_19.activeBuffs[arg1_19]

	setActive(var0_19:Find("Icon"), tobool(var1_19))

	if not var1_19 then
		return
	end

	GetImageSpriteFromAtlasAsync(var1_19:GetIconPath(), "", var0_19:Find("Icon"))
end

function var0_0.willExit(arg0_20)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_20._tf)
end

return var0_0
