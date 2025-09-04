local var0_0 = class("IslandUpdateAchvCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().records

	pg.ConnectionMgr.GetInstance():Send(21052, {
		event_list = var0_1
	})
end

return var0_0
