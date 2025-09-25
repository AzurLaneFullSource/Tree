local var0_0 = class("IslandAniamtionOpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.targetId
	local var2_1 = var0_1.actionId
	local var3_1 = var0_1.islandId

	pg.ConnectionMgr.GetInstance():Send(21700, {
		island_id = var3_1,
		target_id = var1_1,
		action_id = var2_1
	})
end

return var0_0
