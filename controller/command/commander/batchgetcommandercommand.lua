local var0_0 = class("BatchGetCommanderCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().boxIds
	local var1_1 = {}
	local var2_1 = {}
	local var3_1 = {}

	for iter0_1, iter1_1 in ipairs(var0_1) do
		table.insert(var3_1, function(arg0_2)
			if arg0_1:CheckFullCapacity() then
				arg0_2()

				return
			end

			arg0_1:sendNotification(GAME.COMMANDER_ON_OPEN_BOX, {
				notify = false,
				id = iter1_1,
				callback = function(arg0_3)
					if arg0_3 then
						table.insert(var1_1, arg0_3)
						table.insert(var2_1, iter1_1)
					end

					arg0_2()
				end
			})
		end)
	end

	seriesAsync(var3_1, function()
		arg0_1:sendNotification(GAME.COMMANDER_ON_BATCH_DONE, {
			boxIds = var2_1,
			commanders = var1_1
		})
	end)
end

function var0_0.CheckFullCapacity(arg0_5)
	if getProxy(PlayerProxy):getRawData().commanderBagMax <= getProxy(CommanderProxy):getCommanderCnt() then
		return true
	end

	return false
end

return var0_0
