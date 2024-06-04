local var0 = class("WorldCollectionMediator", import("..base.ContextMediator"))

var0.ON_ACHIEVE_STAR = "WorldCollectionMediator.ON_ACHIEVE_STAR"
var0.ON_ACHIEVE_OVERVIEW = "WorldCollectionMediator.ON_ACHIEVE_OVERVIEW"
var0.ON_MAP = "WorldCollectionMediator.ON_MAP"

function var0.register(arg0)
	arg0:bind(var0.ON_ACHIEVE_STAR, function(arg0, arg1)
		arg0:sendNotification(GAME.WORLD_ACHIEVE, {
			list = arg1
		})
	end)
	arg0:bind(var0.ON_ACHIEVE_OVERVIEW, function(arg0)
		arg0:sendNotification(WorldMediator.OnOpenMarkMap, {
			mode = "Achievement"
		})
	end)
	arg0:bind(var0.ON_MAP, function(arg0, arg1)
		arg0:sendNotification(var0.ON_MAP, {
			entrance = arg1,
			mapTypes = {
				"complete_chapter",
				"base_chapter"
			}
		})
	end)
	arg0.viewComponent:SetAchievementList(nowWorld():GetAtlas():GetAchEntranceList())
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.WORLD_ACHIEVE_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.WORLD_ACHIEVE_DONE then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.drops, function()
			arg0.viewComponent:flushAchieveUpdate(var1.list)
		end)
	end
end

return var0
