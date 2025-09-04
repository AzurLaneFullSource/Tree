local var0_0 = class("MainPlayerTestSequence")

function var0_0.Execute(arg0_1, arg1_1)
	if ISLAND_PLAYER_TESTING then
		local var0_1 = getProxy(PlayerProxy):getRawData().id

		pg.m02:sendNotification(GAME.ISLAND_ENTER, {
			id = var0_1
		})
	else
		arg1_1()
	end
end

return var0_0
