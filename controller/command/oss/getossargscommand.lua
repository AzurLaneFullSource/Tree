local var0_0 = class("GetOSSArgsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.mode
	local var2_1 = var0_1.callback

	if var1_1 == 1 then
		var2_1({
			OSS_ENDPOINT,
			OSS_STS_URL
		}, 0)
	elseif var1_1 == 2 then
		pg.ConnectionMgr.GetInstance():Send(19103, {
			typ = 0
		}, 19104, function(arg0_2)
			if arg0_2.result == 0 then
				var2_1({
					OSS_ENDPOINT,
					arg0_2.access_id,
					arg0_2.access_secret,
					arg0_2.security_token
				}, arg0_2.expire_time)
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
			end
		end)
	end
end

return var0_0
