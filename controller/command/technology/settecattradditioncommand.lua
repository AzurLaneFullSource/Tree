local var0_0 = class("SetTecAttrAdditionCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.sendList
	local var2_1 = var0_1.onSuccess
	local var3_1 = {
		techset_list = var1_1
	}

	print("64009 Set Attr Addition")

	if Application.isEditor then
		print_r(var1_1)
	end

	pg.ConnectionMgr.GetInstance():Send(64009, var3_1, 64010, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(TechnologyNationProxy):initSetableAttrAddition(var1_1)
			arg0_1:sendNotification(TechnologyConst.SET_TEC_ATTR_ADDITION_FINISH, {
				onSuccess = var2_1
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("attrset_save_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips("64009 Error Code:" .. arg0_2.result)
		end
	end)
end

return var0_0
