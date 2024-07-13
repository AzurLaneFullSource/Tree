local var0_0 = class("ChallengePreCombatMediator", import("..base.ContextMediator"))

var0_0.ON_START = "ChallengePreCombatMediator:ON_START"
var0_0.ON_SWITCH_SHIP = "ChallengePreCombatMediator:ON_SWITCH_SHIP"
var0_0.ON_AUTO = "ChallengePreCombatMediator:ON_AUTO"
var0_0.ON_SUB_AUTO = "ChallengePreCombatMediator:ON_SUB_AUTO"

function var0_0.register(arg0_1)
	local var0_1 = arg0_1.contextData.mode
	local var1_1 = getProxy(ChallengeProxy):getUserChallengeInfo(var0_1)

	arg0_1:bind(var0_0.ON_AUTO, function(arg0_2, arg1_2)
		arg0_1:onAutoBtn(arg1_2)
	end)
	arg0_1:bind(var0_0.ON_SUB_AUTO, function(arg0_3, arg1_3)
		arg0_1:onAutoSubBtn(arg1_3)
	end)
	arg0_1:bind(var0_0.ON_START, function(arg0_4)
		arg0_1:sendNotification(GAME.BEGIN_STAGE, {
			system = SYSTEM_CHALLENGE,
			mode = var0_1
		})
	end)
	arg0_1.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getData())

	local var2_1 = var1_1:getSubmarineFleet():getShipsByTeam(TeamType.Submarine, false)

	arg0_1.viewComponent:setSubFlag(#var2_1 > 0)
	arg0_1.viewComponent:updateChallenge(var1_1)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		PlayerProxy.UPDATED,
		GAME.BEGIN_STAGE_ERRO,
		GAME.BEGIN_STAGE_DONE,
		ChallengeProxy.CHALLENGE_UPDATED
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == PlayerProxy.UPDATED then
		arg0_6.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getData())
	elseif var0_6 == GAME.BEGIN_STAGE_ERRO then
		if var1_6 == 3 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("battle_preCombatMediator_timeout"),
				onYes = function()
					arg0_6.viewComponent:emit(BaseUI.ON_CLOSE)
				end
			})
		end
	elseif var0_6 == GAME.BEGIN_STAGE_DONE then
		arg0_6:sendNotification(GAME.GO_SCENE, SCENE.COMBATLOAD, var1_6)
	end
end

function var0_0.onAutoBtn(arg0_8, arg1_8)
	local var0_8 = arg1_8.isOn
	local var1_8 = arg1_8.toggle

	arg0_8:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0_8,
		toggle = var1_8
	})
end

function var0_0.onAutoSubBtn(arg0_9, arg1_9)
	local var0_9 = arg1_9.isOn
	local var1_9 = arg1_9.toggle

	arg0_9:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = var0_9,
		toggle = var1_9
	})
end

return var0_0
