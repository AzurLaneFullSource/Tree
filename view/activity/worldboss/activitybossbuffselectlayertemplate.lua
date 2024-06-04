local var0 = class("ActivityBossBuffSelectLayerTemplate", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	error("Need Complete")
end

function var0.init(arg0)
	arg0.buffList = arg0._tf:Find("BuffList")
	arg0.buffScrollComp = arg0.buffList:Find("ScrollView"):GetComponent("LScrollRect")
	arg0.activeBuffRect = arg0._tf:Find("Active")
	arg0.activeBuffScrollComp = arg0.activeBuffRect:Find("ScrollView"):GetComponent("LScrollRect")
	arg0.startBtn = arg0._tf:Find("Start")
	arg0.top = arg0._tf:Find("top")

	setText(arg0._tf:Find("BuffList/Title/Text"), i18n("activityboss_sp_all_buff"))
	setText(arg0._tf:Find("Rewards/Desc"), i18n("activityboss_sp_best_score"))
	setText(arg0._tf:Find("Rewards/Reward/Text"), i18n("activityboss_sp_display_reward"))
	setText(arg0._tf:Find("Active/Title/Text"), i18n("activityboss_sp_active_buff"))
	setText(arg0._tf:Find("Active/PT/Title"), i18n("activityboss_sp_score_bonus"))
end

function var0.didEnter(arg0)
	arg0.buffDatas = {}
	arg0.buffs = _.map(arg0.contextData.spEnemyInfo:GetSelectableBuffs(), function(arg0)
		local var0 = ActivityBossBuff.New({
			configId = arg0
		})

		arg0.buffDatas[var0] = {}

		return var0
	end)

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	_.each(var0:GetHistoryBuffs(), function(arg0)
		local var0 = _.detect(arg0.buffs, function(arg0)
			return arg0:GetConfigID() == arg0
		end)

		arg0.buffDatas[var0].selected = true
	end)

	arg0.rewards = arg0.contextData.spEnemyInfo:GetRewards()
	arg0.targets = arg0.contextData.spEnemyInfo:GetScoreTargets()
	arg0.score = arg0.contextData.score

	function arg0.buffScrollComp.onUpdateItem(arg0, arg1)
		arg0:UpdateBuffItem(arg0 + 1, arg1)
	end

	function arg0.activeBuffScrollComp.onUpdateItem(arg0, arg1)
		arg0:UpdateActiveBuffItem(arg0 + 1, arg1)
	end

	onButton(arg0, arg0.top:Find("back_btn"), function()
		arg0:closeView()
	end, SOUND_BACK)
	onButton(arg0, arg0.top:Find("option"), function()
		arg0:quickExitFunc()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("Rewards/Reward"), function()
		arg0:emit(ActivityBossBuffSelectMediator.SHOW_REWARDS, arg0.rewards, arg0.targets, var0:GetHighestScore())
	end, SFX_PANEL)
	onButton(arg0, arg0.startBtn, function()
		arg0:emit(ActivityBossBuffSelectMediator.ON_START, arg0.activeBuffs)
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	setText(arg0._tf:Find("Rewards/Score"), var0:GetHighestScore())
	arg0:UpdateView()
end

function var0.UpdateView(arg0)
	arg0.buffScrollComp:SetTotalCount(#arg0.buffs)
	arg0:UpdateActiveBuffs()
end

function var0.UpdateBuffItem(arg0, arg1, arg2)
	local var0 = tf(arg2)
	local var1 = arg0.buffs[arg1]
	local var2 = arg0.buffDatas[var1]

	setActive(var0:Find("Selected"), var2.selected)
	setText(var0:Find("Name/Text"), var1:GetDesc())
	setText(var0:Find("PT/Text"), "+" .. var1:GetBonusText())
	GetImageSpriteFromAtlasAsync(var1:GetIconPath(), "", var0:Find("Item/Icon"))
	onButton(arg0, var0, function()
		var2.selected = not var2.selected

		arg0:UpdateView()
	end, SFX_PANEL)
end

function var0.UpdateActiveBuffs(arg0)
	arg0.activeBuffs = _.select(arg0.buffs, function(arg0)
		return arg0.buffDatas[arg0].selected
	end)

	local var0 = math.max(math.floor((#arg0.activeBuffs - 1) / 5) + 1, 4) * 5

	arg0.activeBuffScrollComp:SetTotalCount(var0)

	local var1 = _.reduce(arg0.activeBuffs, 0, function(arg0, arg1)
		return arg0 + arg1:GetBonus()
	end)
	local var2 = Mathf.Round(var1 * 100)

	setText(arg0.activeBuffRect:Find("PT/Text"), "+" .. var2 .. "%")
end

function var0.UpdateActiveBuffItem(arg0, arg1, arg2)
	local var0 = tf(arg2)
	local var1 = arg0.activeBuffs[arg1]

	setActive(var0:Find("Icon"), tobool(var1))

	if not var1 then
		return
	end

	GetImageSpriteFromAtlasAsync(var1:GetIconPath(), "", var0:Find("Icon"))
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
