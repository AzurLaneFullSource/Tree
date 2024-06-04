local var0 = class("EquipCodeRequestCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipGroupId

	pg.ConnectionMgr.GetInstance():Send(17601, {
		shipgroup = var1
	}, 17602, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(CollectionProxy)
			local var1 = var0:getShipGroup(var1)
			local var2 = {}

			for iter0, iter1 in ipairs({
				arg0.infos,
				arg0.recent_infos
			}) do
				for iter2, iter3 in ipairs(iter1) do
					local var3 = EquipCode.New(setmetatable({
						new = iter0 - 1,
						shipGroupId = var1
					}, {
						__index = iter3
					}))

					if var3:IsValid() then
						table.insert(var2, var3)
					end
				end
			end

			var1:setEquipCodes(var2)
			var0:updateShipGroup(var1)
			existCall(var0.callback)
			pg.m02:sendNotification(GAME.EQUIP_CODE_REQUEST_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips("Request equip code data failed:" .. arg0.result)
		end
	end)
end

return var0
