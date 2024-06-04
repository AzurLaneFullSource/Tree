local var0 = class("NewActivityBossSPResultGradePage", import(".NewActivityBossResultGradePage"))

function var0.LoadBGAndGrade(arg0, arg1)
	parallelAsync({
		function(arg0)
			arg0:LoadBG(arg0)
		end,
		function(arg0)
			arg0:LoadGrade(arg0)
		end,
		function(arg0)
			arg0:LoadActivityBossSPRes(arg0)
		end
	}, arg1)
end

function var0.LoadActivityBossSPRes(arg0, arg1)
	ResourceMgr.Inst:getAssetAsync("BattleResultItems/ActivitybossSP", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		if arg0.exited then
			return
		end

		local var0 = Object.Instantiate(arg0, arg0.bgTr)

		arg0:InitActivityPanel(var0.transform)
		arg1()
	end), true, true)
end

function var0.InitActivityPanel(arg0, arg1)
	arg1:SetSiblingIndex(1)

	arg0.playAgain = arg1:Find("playAgain")
	arg0.toggle = arg1:Find("playAgain/ticket/checkbox")

	local var0 = getProxy(ActivityProxy):GetActivityBossRuntime(arg0.contextData.actId)
	local var1 = var0.spScore

	var0.spScore = {
		score = 0
	}

	setText(arg1:Find("Score/Text"), var1.score)
	setActive(arg1:Find("Score/NewText"), var1.new)
	setActive(arg1:Find("Score/NotNewText"), not var1.new)

	local var2 = var0.buffIds

	arg0:UpdateActiveBuffs(arg1:Find("Active"), var2)
	setText(arg1:Find("Score/Title"), i18n("activityboss_sp_score"))
	setText(arg1:Find("Score/NewText"), i18n("activityboss_sp_score_update"))
	setText(arg1:Find("Score/NotNewText"), i18n("activityboss_sp_score_not_update"))
	setText(arg1:Find("Active/PTTitle"), i18n("activityboss_sp_score_bonus"))
	setText(arg1:Find("Active/BuffTitle"), i18n("activityboss_sp_active_buff"))
end

function var0.UpdateActiveBuffs(arg0, arg1, arg2)
	local var0 = _.map(arg2, function(arg0)
		return ActivityBossBuff.New({
			configId = arg0
		})
	end)
	local var1 = arg1:Find("ScrollView"):GetComponent("LScrollRect")

	function var1.onUpdateItem(arg0, arg1)
		arg0 = arg0 + 1

		local var0 = tf(arg1)
		local var1 = var0[arg0]

		setActive(var0:Find("Icon"), tobool(var1))

		if not var1 then
			return
		end

		GetImageSpriteFromAtlasAsync(var1:GetIconPath(), "", var0:Find("Icon"))
	end

	local var2 = 20

	var1:SetTotalCount(var2)

	local var3 = _.reduce(var0, 0, function(arg0, arg1)
		return arg0 + arg1:GetBonus()
	end)
	local var4 = Mathf.Round(var3 * 100)

	setText(arg1:Find("Text"), "+" .. var4 .. "%")
end

return var0
