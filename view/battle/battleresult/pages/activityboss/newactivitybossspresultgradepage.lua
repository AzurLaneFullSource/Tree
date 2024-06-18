local var0_0 = class("NewActivityBossSPResultGradePage", import(".NewActivityBossResultGradePage"))

function var0_0.LoadBGAndGrade(arg0_1, arg1_1)
	parallelAsync({
		function(arg0_2)
			arg0_1:LoadBG(arg0_2)
		end,
		function(arg0_3)
			arg0_1:LoadGrade(arg0_3)
		end,
		function(arg0_4)
			arg0_1:LoadActivityBossSPRes(arg0_4)
		end
	}, arg1_1)
end

function var0_0.LoadActivityBossSPRes(arg0_5, arg1_5)
	ResourceMgr.Inst:getAssetAsync("BattleResultItems/ActivitybossSP", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_6)
		if arg0_5.exited then
			return
		end

		local var0_6 = Object.Instantiate(arg0_6, arg0_5.bgTr)

		arg0_5:InitActivityPanel(var0_6.transform)
		arg1_5()
	end), true, true)
end

function var0_0.InitActivityPanel(arg0_7, arg1_7)
	arg1_7:SetSiblingIndex(1)

	arg0_7.playAgain = arg1_7:Find("playAgain")
	arg0_7.toggle = arg1_7:Find("playAgain/ticket/checkbox")

	local var0_7 = getProxy(ActivityProxy):GetActivityBossRuntime(arg0_7.contextData.actId)
	local var1_7 = var0_7.spScore

	var0_7.spScore = {
		score = 0
	}

	setText(arg1_7:Find("Score/Text"), var1_7.score)
	setActive(arg1_7:Find("Score/NewText"), var1_7.new)
	setActive(arg1_7:Find("Score/NotNewText"), not var1_7.new)

	local var2_7 = var0_7.buffIds

	arg0_7:UpdateActiveBuffs(arg1_7:Find("Active"), var2_7)
	setText(arg1_7:Find("Score/Title"), i18n("activityboss_sp_score"))
	setText(arg1_7:Find("Score/NewText"), i18n("activityboss_sp_score_update"))
	setText(arg1_7:Find("Score/NotNewText"), i18n("activityboss_sp_score_not_update"))
	setText(arg1_7:Find("Active/PTTitle"), i18n("activityboss_sp_score_bonus"))
	setText(arg1_7:Find("Active/BuffTitle"), i18n("activityboss_sp_active_buff"))
end

function var0_0.UpdateActiveBuffs(arg0_8, arg1_8, arg2_8)
	local var0_8 = _.map(arg2_8, function(arg0_9)
		return ActivityBossBuff.New({
			configId = arg0_9
		})
	end)
	local var1_8 = arg1_8:Find("ScrollView"):GetComponent("LScrollRect")

	function var1_8.onUpdateItem(arg0_10, arg1_10)
		arg0_10 = arg0_10 + 1

		local var0_10 = tf(arg1_10)
		local var1_10 = var0_8[arg0_10]

		setActive(var0_10:Find("Icon"), tobool(var1_10))

		if not var1_10 then
			return
		end

		GetImageSpriteFromAtlasAsync(var1_10:GetIconPath(), "", var0_10:Find("Icon"))
	end

	local var2_8 = 20

	var1_8:SetTotalCount(var2_8)

	local var3_8 = _.reduce(var0_8, 0, function(arg0_11, arg1_11)
		return arg0_11 + arg1_11:GetBonus()
	end)
	local var4_8 = Mathf.Round(var3_8 * 100)

	setText(arg1_8:Find("Text"), "+" .. var4_8 .. "%")
end

return var0_0
