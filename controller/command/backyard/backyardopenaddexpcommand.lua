local var0_0 = class("BackYardOpenAddExpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	if var0_1 == 1 then
		getProxy(DormProxy):OnEnterBackyard()
	elseif var0_1 == 0 then
		getProxy(DormProxy):OnExitBackyard()
	end
end

return var0_0
