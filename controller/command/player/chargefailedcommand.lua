local var0_0 = class("ChargeFailedCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.payId
	local var2_1 = var0_1.code

	if not var1_1 then
		return
	end

	if not var2_1 or type(var2_1) ~= "number" then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11510, {
		pay_id = tostring(var1_1),
		code = math.abs(var2_1)
	})
end

return var0_0
