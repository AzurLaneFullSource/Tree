local var0_0 = class("LimitChallengeMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:bindEvent()
	arg0_1:tryGetAward()
end

function var0_0.listNotificationInterests(arg0_2)
	return {
		LimitChallengeConst.REQ_CHALLENGE_INFO_DONE,
		LimitChallengeConst.GET_CHALLENGE_AWARD_DONE,
		LimitChallengeConst.UPDATE_PASS_TIME
	}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()

	if var0_3 == LimitChallengeConst.REQ_CHALLENGE_INFO_DONE then
		arg0_3.viewComponent:onReqInfo()
	elseif var0_3 == LimitChallengeConst.GET_CHALLENGE_AWARD_DONE then
		arg0_3.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_3.awards)
		arg0_3.viewComponent:updateToggleList()
		arg0_3.viewComponent:trigeHigestUnlockLevel()
	elseif var0_3 == LimitChallengeConst.UPDATE_PASS_TIME then
		arg0_3.viewComponent:updatePassTime()
	end
end

function var0_0.bindEvent(arg0_4)
	arg0_4:bind(LimitChallengeConst.OPEN_PRE_COMBAT_LAYER, function(arg0_5, arg1_5)
		local var0_5 = arg1_5.stageID
		local var1_5 = Context.New({
			mediator = LimitChallengePreCombatMediator,
			viewComponent = LimitChallengePreCombatLayer,
			data = {
				stageId = var0_5,
				system = SYSTEM_LIMIT_CHALLENGE
			}
		})

		arg0_4:addSubLayers(var1_5)
	end)
end

function var0_0.tryGetAward(arg0_6)
	local var0_6 = getProxy(LimitChallengeProxy):getMissAwardChallengeIDLIst()

	if #var0_6 > 0 then
		arg0_6:sendNotification(LimitChallengeConst.GET_CHALLENGE_AWARD, {
			challengeIDList = var0_6
		})
	end
end

return var0_0
