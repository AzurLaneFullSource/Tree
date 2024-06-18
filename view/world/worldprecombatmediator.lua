local var0_0 = class("WorldPreCombatMediator", import("..base.ContextMediator"))

var0_0.OnSwitchShip = "WorldPreCombatMediator.OnSwitchShip"
var0_0.OnMapOp = "WorldPreCombatMediator.OnMapOp"
var0_0.OnAuto = "WorldPreCombatMediator.OnAuto"
var0_0.OnSubAuto = "WorldPreCombatMediator.OnSubAuto"
var0_0.OnStartBattle = "WorldPreCombatMediator.OnStartBattle"
var0_0.OnOpenSublayer = "OpenSublayer"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OnSwitchShip, function(arg0_2, arg1_2, arg2_2, arg3_2)
		nowWorld():GetFleet(arg1_2):SwitchShip(arg2_2, arg3_2)
	end)
	arg0_1:bind(var0_0.OnAuto, function(arg0_3, arg1_3)
		arg0_1:onAutoBtn(arg1_3)
	end)
	arg0_1:bind(var0_0.OnSubAuto, function(arg0_4, arg1_4)
		arg0_1:onSubAuto(arg1_4)
	end)
	arg0_1:bind(var0_0.OnMapOp, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.WORLD_MAP_OP, arg1_5)
	end)
	arg0_1:bind(var0_0.OnStartBattle, function(arg0_6, arg1_6, arg2_6, arg3_6)
		if arg2_6.damageLevel > arg3_6:GetLimitDamageLevel() then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideYes = true,
				content = i18n("world_low_morale")
			})
		else
			arg0_1:sendNotification(GAME.BEGIN_STAGE, {
				system = SYSTEM_WORLD,
				stageId = arg1_6
			})
		end
	end)
	arg0_1:bind(var0_0.OnOpenSublayer, function(arg0_7, arg1_7, arg2_7, arg3_7)
		arg0_1:addSubLayers(arg1_7, arg2_7, arg3_7)
	end)
	arg0_1.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getRawData())
end

function var0_0.onAutoBtn(arg0_8, arg1_8)
	local var0_8 = arg1_8.isOn
	local var1_8 = arg1_8.toggle

	arg0_8:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0_8,
		toggle = var1_8,
		system = SYSTEM_WORLD
	})
end

function var0_0.onSubAuto(arg0_9, arg1_9)
	local var0_9 = arg1_9.isOn
	local var1_9 = arg1_9.toggle
	local var2_9 = arg1_9.system

	arg0_9:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = var0_9,
		toggle = var1_9,
		system = SYSTEM_WORLD
	})
end

function var0_0.listNotificationInterests(arg0_10)
	return {
		PlayerProxy.UPDATED,
		GAME.WORLD_MAP_OP_DONE
	}
end

function var0_0.handleNotification(arg0_11, arg1_11)
	local var0_11 = arg1_11:getName()
	local var1_11 = arg1_11:getBody()

	if var0_11 == PlayerProxy.UPDATED then
		arg0_11.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getRawData())
	elseif var0_11 == GAME.WORLD_MAP_OP_DONE then
		-- block empty
	end
end

return var0_0
