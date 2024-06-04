local var0 = class("SetTecAttrAdditionCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.sendList
	local var2 = var0.onSuccess
	local var3 = {
		techset_list = var1
	}

	print("64009 Set Attr Addition")

	if Application.isEditor then
		print_r(var1)
	end

	pg.ConnectionMgr.GetInstance():Send(64009, var3, 64010, function(arg0)
		if arg0.result == 0 then
			getProxy(TechnologyNationProxy):initSetableAttrAddition(var1)
			arg0:sendNotification(TechnologyConst.SET_TEC_ATTR_ADDITION_FINISH, {
				onSuccess = var2
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("attrset_save_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips("64009 Error Code:" .. arg0.result)
		end
	end)
end

return var0
