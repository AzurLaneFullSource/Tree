local var0 = class("BatchGetCommanderCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().boxIds
	local var1 = {}
	local var2 = {}
	local var3 = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(var3, function(arg0)
			if arg0:CheckFullCapacity() then
				arg0()

				return
			end

			arg0:sendNotification(GAME.COMMANDER_ON_OPEN_BOX, {
				notify = false,
				id = iter1,
				callback = function(arg0)
					if arg0 then
						table.insert(var1, arg0)
						table.insert(var2, iter1)
					end

					arg0()
				end
			})
		end)
	end

	seriesAsync(var3, function()
		arg0:sendNotification(GAME.COMMANDER_ON_BATCH_DONE, {
			boxIds = var2,
			commanders = var1
		})
	end)
end

function var0.CheckFullCapacity(arg0)
	if getProxy(PlayerProxy):getRawData().commanderBagMax <= getProxy(CommanderProxy):getCommanderCnt() then
		return true
	end

	return false
end

return var0
