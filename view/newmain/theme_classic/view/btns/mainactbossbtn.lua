local var0 = class("MainActBossBtn", import(".MainBaseActivityBtn"))

function var0.GetEventName(arg0)
	return "event_boss"
end

function var0.GetActivityID(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)

	return var0 and var0.id
end

function var0.OnInit(arg0)
	local var0 = arg0:IsShowTip()

	setActive(arg0.tipTr.gameObject, var0)
end

function var0.IsShowTip(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_BOSS_BATTLE_MARK_2)
	local var1 = false

	if var0:checkBattleTimeInBossAct() then
		var1 = var0:readyToAchieve()
	else
		local var2 = var0:GetBindPtActID()
		local var3 = getProxy(ActivityProxy):getActivityById(var2)

		if var3 then
			var1 = ActivityBossPtData.New(var3):CanGetAward()
		end
	end

	return var1
end

function var0.CustomOnClick(arg0)
	arg0:emit(NewMainMediator.GO_SCENE, SCENE.ACT_BOSS_BATTLE, {
		showAni = true
	})
end

return var0
