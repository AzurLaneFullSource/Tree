local var0_0 = class("WorldCollectionMediator", import("..base.ContextMediator"))

var0_0.ON_ACHIEVE_STAR = "WorldCollectionMediator.ON_ACHIEVE_STAR"
var0_0.ON_ACHIEVE_OVERVIEW = "WorldCollectionMediator.ON_ACHIEVE_OVERVIEW"
var0_0.ON_MAP = "WorldCollectionMediator.ON_MAP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.ON_ACHIEVE_STAR, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.WORLD_ACHIEVE, {
			list = arg1_2
		})
	end)
	arg0_1:bind(var0_0.ON_ACHIEVE_OVERVIEW, function(arg0_3)
		arg0_1:sendNotification(WorldMediator.OnOpenMarkMap, {
			mode = "Achievement"
		})
	end)
	arg0_1:bind(var0_0.ON_MAP, function(arg0_4, arg1_4)
		arg0_1:sendNotification(var0_0.ON_MAP, {
			entrance = arg1_4,
			mapTypes = {
				"complete_chapter",
				"base_chapter"
			}
		})
	end)
	arg0_1.viewComponent:SetAchievementList(nowWorld():GetAtlas():GetAchEntranceList())
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.WORLD_ACHIEVE_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()

	if var0_6 == GAME.WORLD_ACHIEVE_DONE then
		arg0_6.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_6.drops, function()
			arg0_6.viewComponent:flushAchieveUpdate(var1_6.list)
		end)
	end
end

return var0_0
