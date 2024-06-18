local var0_0 = class("MainActBossBtn", import(".MainBaseActivityBtn"))

function var0_0.GetEventName(arg0_1)
	return "event_boss"
end

function var0_0.GetActivityID(arg0_2)
	local var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	return var0_2 and var0_2.id
end

function var0_0.OnInit(arg0_3)
	local var0_3 = arg0_3:IsShowTip()

	setActive(arg0_3.tipTr.gameObject, var0_3)
end

function var0_0.IsShowTip(arg0_4)
	local var0_4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)
	local var1_4 = false

	if var0_4:checkBattleTimeInBossAct() then
		var1_4 = var0_4:readyToAchieve()
	else
		local var2_4 = var0_4:GetBindPtActID()
		local var3_4 = getProxy(ActivityProxy):getActivityById(var2_4)

		if var3_4 then
			var1_4 = ActivityBossPtData.New(var3_4):CanGetAward()
		end
	end

	return var1_4
end

function var0_0.CustomOnClick(arg0_5)
	arg0_5:emit(NewMainMediator.GO_SCENE, SCENE.ACT_BOSS_BATTLE, {
		showAni = true
	})
end

return var0_0
