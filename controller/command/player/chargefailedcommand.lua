local var0 = class("ChargeFailedCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.payId
	local var2 = var0.code

	if not var1 then
		return
	end

	if not var2 or type(var2) ~= "number" then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11510, {
		pay_id = tostring(var1),
		code = math.abs(var2)
	})
end

return var0
