local var0 = class("LimitChallengeMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	arg0:bindEvent()
	arg0:tryGetAward()
end

function var0.listNotificationInterests(arg0)
	return {
		LimitChallengeConst.REQ_CHALLENGE_INFO_DONE,
		LimitChallengeConst.GET_CHALLENGE_AWARD_DONE,
		LimitChallengeConst.UPDATE_PASS_TIME
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == LimitChallengeConst.REQ_CHALLENGE_INFO_DONE then
		arg0.viewComponent:onReqInfo()
	elseif var0 == LimitChallengeConst.GET_CHALLENGE_AWARD_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards)
		arg0.viewComponent:updateToggleList()
		arg0.viewComponent:trigeHigestUnlockLevel()
	elseif var0 == LimitChallengeConst.UPDATE_PASS_TIME then
		arg0.viewComponent:updatePassTime()
	end
end

function var0.bindEvent(arg0)
	arg0:bind(LimitChallengeConst.OPEN_PRE_COMBAT_LAYER, function(arg0, arg1)
		local var0 = arg1.stageID
		local var1 = Context.New({
			mediator = LimitChallengePreCombatMediator,
			viewComponent = LimitChallengePreCombatLayer,
			data = {
				stageId = var0,
				system = SYSTEM_LIMIT_CHALLENGE
			}
		})

		arg0:addSubLayers(var1)
	end)
end

function var0.tryGetAward(arg0)
	local var0 = getProxy(LimitChallengeProxy):getMissAwardChallengeIDLIst()

	if #var0 > 0 then
		arg0:sendNotification(LimitChallengeConst.GET_CHALLENGE_AWARD, {
			challengeIDList = var0
		})
	end
end

return var0
