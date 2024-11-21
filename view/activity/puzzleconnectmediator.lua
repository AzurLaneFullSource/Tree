local var0_0 = class("PuzzleConnectMediator", import("..base.ContextMediator"))

var0_0.CMD_ACTIVITY = "PuzzleConnectMediator:cmd_activity"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.CMD_ACTIVITY, function(arg0_2, arg1_2)
		local var0_2 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLE_CONNECT)

		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = var0_2.id,
			cmd = arg1_2.index,
			arg1 = arg1_2.config_id
		})
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		ActivityProxy.ACTIVITY_OPERATION_DONE,
		ActivityProxy.ACTIVITY_SHOW_AWARDS
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == ActivityProxy.ACTIVITY_OPERATION_DONE then
		arg0_4.viewComponent:updateActivity()
	elseif var0_4 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0_4.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_4.awards, var1_4.callback)
	end
end

var0_0.state_collection = 1
var0_0.state_puzzle = 2
var0_0.state_connection = 3
var0_0.state_complete = 4

function var0_0.GetPuzzleActivityState(arg0_5, arg1_5)
	if not arg1_5 then
		return var0_0.state_puzzle
	end

	local var0_5 = arg1_5.data1_list
	local var1_5 = arg1_5.data2_list
	local var2_5 = arg1_5.data3_list

	if not table.contains(var0_5, arg0_5) then
		return var0_0.state_collection
	elseif not table.contains(var1_5, arg0_5) then
		return var0_0.state_puzzle
	elseif not table.contains(var2_5, arg0_5) then
		return var0_0.state_connection
	else
		return var0_0.state_complete
	end
end

function var0_0.GetRedTip()
	local var0_6 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_PUZZLE_CONNECT)

	if var0_6 then
		local var1_6 = var0_6:getConfig("config_data")
		local var2_6 = getProxy(PlayerProxy)
		local var3_6 = var0_6.data1_list
		local var4_6 = var0_6.data2_list
		local var5_6 = var0_6.data3_list
		local var6_6 = var0_6:getDayIndex()
		local var7_6 = 0

		for iter0_6 = 1, #var1_6 do
			local var8_6 = var1_6[iter0_6]

			if iter0_6 <= var6_6 then
				if not table.contains(var5_6, var8_6) then
					if not table.contains(var3_6, var8_6) and iter0_6 == var7_6 + 1 then
						local var9_6 = pg.activity_tolove_jigsaw[var8_6].need[3]
						local var10_6 = pg.activity_tolove_jigsaw[var8_6].need[2]

						if var9_6 <= var2_6:getData():getResource(var10_6) then
							return true
						end
					end
				else
					var7_6 = var7_6 < iter0_6 and iter0_6 or var7_6
				end
			end
		end

		if #var3_6 > #var4_6 or #var3_6 > #var5_6 then
			return true
		end
	end

	return false
end

return var0_0
