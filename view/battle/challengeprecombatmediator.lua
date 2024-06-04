local var0 = class("ChallengePreCombatMediator", import("..base.ContextMediator"))

var0.ON_START = "ChallengePreCombatMediator:ON_START"
var0.ON_SWITCH_SHIP = "ChallengePreCombatMediator:ON_SWITCH_SHIP"
var0.ON_AUTO = "ChallengePreCombatMediator:ON_AUTO"
var0.ON_SUB_AUTO = "ChallengePreCombatMediator:ON_SUB_AUTO"

function var0.register(arg0)
	local var0 = arg0.contextData.mode
	local var1 = getProxy(ChallengeProxy):getUserChallengeInfo(var0)

	arg0:bind(var0.ON_AUTO, function(arg0, arg1)
		arg0:onAutoBtn(arg1)
	end)
	arg0:bind(var0.ON_SUB_AUTO, function(arg0, arg1)
		arg0:onAutoSubBtn(arg1)
	end)
	arg0:bind(var0.ON_START, function(arg0)
		arg0:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_CHALLENGE,
			mode = var0
		})
	end)
	arg0.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getData())

	local var2 = var1:getSubmarineFleet():getShipsByTeam(TeamType.Submarine, false)

	arg0.viewComponent:setSubFlag(#var2 > 0)
	arg0.viewComponent:updateChallenge(var1)
end

function var0.listNotificationInterests(arg0)
	return {
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_ERRO,
		GAME.BEGIN_STAGE_DONE,
		ChallengeProxy.CHALLENGE_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getData())
	elseif var0 == GAME.BEGIN_STAGE_ERRO then
		if var1 == 3 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("battle_preCombatMediator_timeout"),
				onYes = function()
					arg0.viewComponent:emit(BaseUI.ON_CLOSE)
				end
			})
		end
	elseif var0 == GAME.BEGIN_STAGE_DONE then
		arg0:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1)
	end
end

function var0.onAutoBtn(arg0, arg1)
	local var0 = arg1.isOn
	local var1 = arg1.toggle

	arg0:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0,
		toggle = var1
	})
end

function var0.onAutoSubBtn(arg0, arg1)
	local var0 = arg1.isOn
	local var1 = arg1.toggle

	arg0:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = var0,
		toggle = var1
	})
end

return var0
