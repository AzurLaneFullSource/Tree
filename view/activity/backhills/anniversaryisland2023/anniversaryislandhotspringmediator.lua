local var0_0 = class("AnniversaryIslandHotSpringMediator", import("view.activity.BackHills.NewYearFestival.NewYearHotSpringMediator"))

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.OPEN_CHUANWU, function(arg0_2, arg1_2, arg2_2)
		arg0_1:OnSelShips(arg1_2, arg2_2)
	end)

	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING_2)

	arg0_1.activity = var0_1

	arg0_1.viewComponent:SetActivity(var0_1)
	arg0_1:bind(var0_0.OPEN_INFO, function()
		arg0_1:addSubLayers(Context.New({
			mediator = AnniversaryIslandSpringShipSelectMediator,
			viewComponent = AnniversaryIslandSpringShipSelectLayer,
			data = {
				actId = var0_1.id
			}
		}))
	end)
end

function var0_0.OnSelected(arg0_4, arg1_4, arg2_4, arg3_4)
	local var0_4 = Clone(arg0_4.activity:GetShipIds())

	_.each(_.range(arg0_4.activity:GetSlotCount()), function(arg0_5)
		var0_4[arg0_5] = var0_4[arg0_5] or 0
	end)

	if arg2_4 == nil or #arg2_4 == 0 then
		if var0_4[arg1_4] > 0 then
			arg0_4:sendNotification(GAME.ACTIVITY_OPERATION, {
				activity_id = arg0_4.activity.id,
				cmd = Spring2Activity.OPERATION_SETSHIP,
				kvargs1 = {
					{
						value = 0,
						key = arg1_4
					}
				}
			})
		end

		existCall(arg3_4)

		return
	end

	local var1_4 = _.filter(arg2_4, function(arg0_6)
		return not table.contains(var0_4, arg0_6)
	end)

	table.Foreach(var0_4, function(arg0_7, arg1_7)
		if arg1_7 == 0 or table.contains(arg2_4, arg1_7) then
			return
		end

		var0_4[arg0_7] = 0
	end)

	if #var1_4 == 1 and var0_4[arg1_4] == 0 then
		var0_4[arg1_4] = var1_4[1]
	else
		local var2_4 = 0

		_.each(var1_4, function(arg0_8)
			while var2_4 <= #var0_4 do
				var2_4 = var2_4 + 1

				if var0_4[var2_4] == 0 then
					break
				end
			end

			var0_4[var2_4] = arg0_8
		end)
	end

	local var3_4 = {}
	local var4_4 = arg0_4.activity:GetShipIds()

	table.Foreach(var0_4, function(arg0_9, arg1_9)
		if (var4_4[arg0_9] or 0) ~= arg1_9 then
			table.insert(var3_4, {
				key = arg0_9,
				value = arg1_9
			})
		end
	end)

	if #var3_4 > 0 then
		arg0_4:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = arg0_4.activity.id,
			cmd = Spring2Activity.OPERATION_SETSHIP,
			kvargs1 = var3_4
		})
	end

	arg3_4()
end

function var0_0.listNotificationInterests(arg0_10)
	return {
		PlayerProxy.UPDATED,
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		var0_0.OPEN_CHUANWU
	}
end

function var0_0.handleNotification(arg0_11, arg1_11)
	local var0_11 = arg1_11:getName()
	local var1_11 = arg1_11:getBody()

	if var0_11 == nil then
		-- block empty
	elseif var0_11 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0_11.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_11.awards, var1_11.callback)
	elseif var0_11 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_11:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING_2 then
			arg0_11.activity = var1_11

			arg0_11.viewComponent:SetActivity(var1_11)
			arg0_11.viewComponent:UpdateView()
		end
	elseif var0_11 == var0_0.OPEN_CHUANWU then
		arg0_11.viewComponent:emit(var0_0.OPEN_CHUANWU, unpack(var1_11))
	end
end

return var0_0
