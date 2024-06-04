local var0 = class("GetOSSArgsCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.mode
	local var2 = var0.callback

	if var1 == 1 then
		var2({
			OSS_ENDPOINT,
			OSS_STS_URL
		}, 0)
	elseif var1 == 2 then
		pg.ConnectionMgr.GetInstance():Send(19103, {
			typ = 0
		}, 19104, function(arg0)
			if arg0.result == 0 then
				var2({
					OSS_ENDPOINT,
					arg0.access_id,
					arg0.access_secret,
					arg0.security_token
				}, arg0.expire_time)
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
			end
		end)
	end
end

return var0
