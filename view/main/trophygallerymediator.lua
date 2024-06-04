local var0 = class("TrophyGalleryMediator", import("..base.ContextMediator"))

var0.ON_TROPHY_CLAIM = "TrophyGalleryMediator:ON_TROPHY_CLAIM"

function var0.register(arg0)
	local var0 = getProxy(CollectionProxy)

	arg0:bind(var0.ON_TROPHY_CLAIM, function(arg0, arg1)
		arg0:sendNotification(GAME.TROPHY_CLAIM, {
			trophyID = arg1
		})
	end)

	local var1 = var0:getTrophyGroup()
	local var2 = var0:getTrophys()

	arg0.viewComponent:setTrophyGroups(var1)
	arg0.viewComponent:setTrophyList(var2)
end

function var0.listNotificationInterests(arg0)
	return {
		CollectionProxy.TROPHY_UPDATE,
		GAME.TROPHY_CLAIM_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == CollectionProxy.TROPHY_UPDATE then
		-- block empty
	elseif var0 == GAME.TROPHY_CLAIM_DONE then
		local var2 = var1.trophyID

		if pg.medal_template[var2].hide == Trophy.ALWAYS_HIDE then
			return
		end

		local var3 = math.floor(var2 / 10)
		local var4 = getProxy(CollectionProxy)
		local var5 = var4:getTrophyGroup()
		local var6 = var4:getTrophys()

		arg0.viewComponent:setTrophyGroups(var5)
		arg0.viewComponent:setTrophyList(var6)
		arg0.viewComponent:PlayTrophyClaim(var3)
	end
end

return var0
