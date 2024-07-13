local var0_0 = class("TrophyGalleryMediator", import("..base.ContextMediator"))

var0_0.ON_TROPHY_CLAIM = "TrophyGalleryMediator:ON_TROPHY_CLAIM"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(CollectionProxy)

	arg0_1:bind(var0_0.ON_TROPHY_CLAIM, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.TROPHY_CLAIM, {
			trophyID = arg1_2
		})
	end)

	local var1_1 = var0_1:getTrophyGroup()
	local var2_1 = var0_1:getTrophys()

	arg0_1.viewComponent:setTrophyGroups(var1_1)
	arg0_1.viewComponent:setTrophyList(var2_1)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		CollectionProxy.TROPHY_UPDATE,
		GAME.TROPHY_CLAIM_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == CollectionProxy.TROPHY_UPDATE then
		-- block empty
	elseif var0_4 == GAME.TROPHY_CLAIM_DONE then
		local var2_4 = var1_4.trophyID

		if pg.medal_template[var2_4].hide == Trophy.ALWAYS_HIDE then
			return
		end

		local var3_4 = math.floor(var2_4 / 10)
		local var4_4 = getProxy(CollectionProxy)
		local var5_4 = var4_4:getTrophyGroup()
		local var6_4 = var4_4:getTrophys()

		arg0_4.viewComponent:setTrophyGroups(var5_4)
		arg0_4.viewComponent:setTrophyList(var6_4)
		arg0_4.viewComponent:PlayTrophyClaim(var3_4)
	end
end

return var0_0
