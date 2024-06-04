local var0 = class("WorldPreCombatMediator", import("..base.ContextMediator"))

var0.OnSwitchShip = "WorldPreCombatMediator.OnSwitchShip"
var0.OnMapOp = "WorldPreCombatMediator.OnMapOp"
var0.OnAuto = "WorldPreCombatMediator.OnAuto"
var0.OnSubAuto = "WorldPreCombatMediator.OnSubAuto"
var0.OnStartBattle = "WorldPreCombatMediator.OnStartBattle"
var0.OnOpenSublayer = "OpenSublayer"

function var0.register(arg0)
	arg0:bind(var0.OnSwitchShip, function(arg0, arg1, arg2, arg3)
		nowWorld():GetFleet(arg1):SwitchShip(arg2, arg3)
	end)
	arg0:bind(var0.OnAuto, function(arg0, arg1)
		arg0:onAutoBtn(arg1)
	end)
	arg0:bind(var0.OnSubAuto, function(arg0, arg1)
		arg0:onSubAuto(arg1)
	end)
	arg0:bind(var0.OnMapOp, function(arg0, arg1)
		arg0:sendNotification(GAME.WORLD_MAP_OP, arg1)
	end)
	arg0:bind(var0.OnStartBattle, function(arg0, arg1, arg2, arg3)
		if arg2.damageLevel > arg3:GetLimitDamageLevel() then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideYes = true,
				content = i18n("world_low_morale")
			})
		else
			arg0:sendNotification(GAME.BEGIN_STAGE, {
				system = SYSTEM_WORLD,
				stageId = arg1
			})
		end
	end)
	arg0:bind(var0.OnOpenSublayer, function(arg0, arg1, arg2, arg3)
		arg0:addSubLayers(arg1, arg2, arg3)
	end)
	arg0.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getRawData())
end

function var0.onAutoBtn(arg0, arg1)
	local var0 = arg1.isOn
	local var1 = arg1.toggle

	arg0:sendNotification(GAME.AUTO_BOT, {
		isActiveBot = var0,
		toggle = var1,
		system = SYSTEM_WORLD
	})
end

function var0.onSubAuto(arg0, arg1)
	local var0 = arg1.isOn
	local var1 = arg1.toggle
	local var2 = arg1.system

	arg0:sendNotification(GAME.AUTO_SUB, {
		isActiveSub = var0,
		toggle = var1,
		system = SYSTEM_WORLD
	})
end

function var0.listNotificationInterests(arg0)
	return {
		PlayerProxy.UPDATED,
		GAME.WORLD_MAP_OP_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getRawData())
	elseif var0 == GAME.WORLD_MAP_OP_DONE then
		-- block empty
	end
end

return var0
