local var0 = class("AnniversaryIslandHotSpringMediator", import("view.activity.BackHills.NewYearFestival.NewYearHotSpringMediator"))

function var0.register(arg0)
	arg0:bind(var0.OPEN_CHUANWU, function(arg0, arg1, arg2)
		arg0:OnSelShips(arg1, arg2)
	end)

	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING_2)

	arg0.activity = var0

	arg0.viewComponent:SetActivity(var0)
	arg0:bind(var0.OPEN_INFO, function()
		arg0:addSubLayers(Context.New({
			mediator = AnniversaryIslandSpringShipSelectMediator,
			viewComponent = AnniversaryIslandSpringShipSelectLayer,
			data = {
				actId = var0.id
			}
		}))
	end)
end

function var0.OnSelected(arg0, arg1, arg2, arg3)
	local var0 = Clone(arg0.activity:GetShipIds())

	_.each(_.range(arg0.activity:GetSlotCount()), function(arg0)
		var0[arg0] = var0[arg0] or 0
	end)

	if arg2 == nil or #arg2 == 0 then
		if var0[arg1] > 0 then
			arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
				activity_id = arg0.activity.id,
				cmd = Spring2Activity.OPERATION_SETSHIP,
				kvargs1 = {
					{
						value = 0,
						key = arg1
					}
				}
			})
		end

		existCall(arg3)

		return
	end

	local var1 = _.filter(arg2, function(arg0)
		return not table.contains(var0, arg0)
	end)

	table.Foreach(var0, function(arg0, arg1)
		if arg1 == 0 or table.contains(arg2, arg1) then
			return
		end

		var0[arg0] = 0
	end)

	if #var1 == 1 and var0[arg1] == 0 then
		var0[arg1] = var1[1]
	else
		local var2 = 0

		_.each(var1, function(arg0)
			while var2 <= #var0 do
				var2 = var2 + 1

				if var0[var2] == 0 then
					break
				end
			end

			var0[var2] = arg0
		end)
	end

	local var3 = {}
	local var4 = arg0.activity:GetShipIds()

	table.Foreach(var0, function(arg0, arg1)
		if (var4[arg0] or 0) ~= arg1 then
			table.insert(var3, {
				key = arg0,
				value = arg1
			})
		end
	end)

	if #var3 > 0 then
		arg0:sendNotification(GAME.ACTIVITY_OPERATION, {
			activity_id = arg0.activity.id,
			cmd = Spring2Activity.OPERATION_SETSHIP,
			kvargs1 = var3
		})
	end

	arg3()
end

function var0.listNotificationInterests(arg0)
	return {
		PlayerProxy.UPDATED,
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityProxy.ACTIVITY_SHOW_AWARDS,
		var0.OPEN_CHUANWU
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == nil then
		-- block empty
	elseif var0 == ActivityProxy.ACTIVITY_SHOW_AWARDS then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, var1.callback)
	elseif var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_HOTSPRING_2 then
			arg0.activity = var1

			arg0.viewComponent:SetActivity(var1)
			arg0.viewComponent:UpdateView()
		end
	elseif var0 == var0.OPEN_CHUANWU then
		arg0.viewComponent:emit(var0.OPEN_CHUANWU, unpack(var1))
	end
end

return var0
