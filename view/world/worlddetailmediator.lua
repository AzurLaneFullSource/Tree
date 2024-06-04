local var0 = class("WorldDetailMediator", import("..base.ContextMediator"))

var0.OnShipInfo = "WorldDetailMediator:OnShipInfo"
var0.OnCmdSkill = "WorldDetailMediator.OnCmdSkill"

function var0.register(arg0)
	arg0:bind(var0.OnShipInfo, function(arg0, arg1, arg2)
		local var0 = WorldConst.FetchWorldShip(arg1)

		arg0.contextData.fleetId = var0.fleetId
		arg0.contextData.toggle = arg2

		local var1 = nowWorld():GetFleet(var0.fleetId):GetShipVOs(true)

		arg0:sendNotification(GAME.GO_SCENE, SCENE.SHIPINFO, {
			shipId = var0.id,
			shipVOs = var1
		})
	end)
	arg0:bind(var0.OnCmdSkill, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			mediator = CommanderSkillMediator,
			viewComponent = CommanderSkillLayer,
			data = {
				isWorld = true,
				skill = arg1
			}
		}))
	end)
	arg0.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getRawData())
	arg0.viewComponent:setFleets(nowWorld():GetFleets())
end

function var0.listNotificationInterests(arg0)
	return {
		PlayerProxy.UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayerInfo(getProxy(PlayerProxy):getRawData())
	end
end

return var0
