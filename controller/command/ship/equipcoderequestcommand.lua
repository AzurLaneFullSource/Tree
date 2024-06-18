local var0_0 = class("EquipCodeRequestCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipGroupId

	pg.ConnectionMgr.GetInstance():Send(17601, {
		shipgroup = var1_1
	}, 17602, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(CollectionProxy)
			local var1_2 = var0_2:getShipGroup(var1_1)
			local var2_2 = {}

			for iter0_2, iter1_2 in ipairs({
				arg0_2.infos,
				arg0_2.recent_infos
			}) do
				for iter2_2, iter3_2 in ipairs(iter1_2) do
					local var3_2 = EquipCode.New(setmetatable({
						new = iter0_2 - 1,
						shipGroupId = var1_1
					}, {
						__index = iter3_2
					}))

					if var3_2:IsValid() then
						table.insert(var2_2, var3_2)
					end
				end
			end

			var1_2:setEquipCodes(var2_2)
			var0_2:updateShipGroup(var1_2)
			existCall(var0_1.callback)
			pg.m02:sendNotification(GAME.EQUIP_CODE_REQUEST_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips("Request equip code data failed:" .. arg0_2.result)
		end
	end)
end

return var0_0
