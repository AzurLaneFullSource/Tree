local var0_0 = class("WorldDetailMediator", import("..base.ContextMediator"))

var0_0.OnShipInfo = "WorldDetailMediator:OnShipInfo"
var0_0.OnCmdSkill = "WorldDetailMediator.OnCmdSkill"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OnShipInfo, function(arg0_2, arg1_2, arg2_2)
		local var0_2 = WorldConst.FetchWorldShip(arg1_2)

		arg0_1.contextData.fleetId = var0_2.fleetId
		arg0_1.contextData.toggle = arg2_2

		local var1_2 = nowWorld():GetFleet(var0_2.fleetId):GetShipVOs(true)

		arg0_1:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = var0_2.id,
			shipVOs = var1_2
		})
	end)
	arg0_1:bind(var0_0.OnCmdSkill, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				isWorld = true,
				skill = arg1_3
			}
		}))
	end)
	arg0_1.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getRawData())
	arg0_1.viewComponent:setFleets(nowWorld():GetFleets())
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		PlayerProxy.UPDATED
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == PlayerProxy.UPDATED then
		arg0_5.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getRawData())
	end
end

return var0_0
