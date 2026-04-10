local var0_0 = class("ChangeToIslandCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = arg1_1:getType()

	getProxy(ContextProxy):getCurrentContext().skipBack = true

	pg.m02:sendNotification(GAME.ISLAND_ENTER, var0_1)
end

return var0_0
