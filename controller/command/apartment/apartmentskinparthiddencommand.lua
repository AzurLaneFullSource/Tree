local var0_0 = class("ApartmentSkinPartHiddenCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.groupId
	local var2_1 = var0_1.skinId
	local var3_1 = var0_1.partList
	local var4_1 = getProxy(ApartmentProxy)

	pg.ConnectionMgr.GetInstance():Send(28038, {
		ship_group = var1_1,
		skin_id = var2_1,
		hidden_parts = var3_1
	}, 28039, function(arg0_2)
		if arg0_2.result == 0 then
			var4_1:ModifyApartment(var1_1, function(arg0_3)
				arg0_3:SetHiddenParts(var2_1, var3_1)
			end)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
