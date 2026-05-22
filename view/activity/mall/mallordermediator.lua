local var0_0 = class("MallOrderMediator", import("view.base.ContextMediator"))

var0_0.START_ORDER = "MallOrderMediator.START_ORDER"
var0_0.COMPLETE_ORDER = "MallOrderMediator.COMPLETE_ORDER"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.START_ORDER, function(arg0_2, arg1_2, arg2_2, arg3_2)
		arg0_1:sendNotification(GAME.ACTIVITY_MALL_OP, {
			activity_id = arg1_2,
			cmd = ActivityMallOPCommand.CMD.START_ORDER,
			arg1 = arg2_2,
			arg_list = arg3_2
		})
	end)
	arg0_1:bind(var0_0.COMPLETE_ORDER, function(arg0_3, arg1_3, arg2_3)
		arg0_1:sendNotification(GAME.ACTIVITY_MALL_OP, {
			activity_id = arg1_3,
			cmd = ActivityMallOPCommand.CMD.COMPLETE_ORDER,
			arg1 = arg2_3
		})
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.ACTIVITY_MALL_OP_DONE,
		GAME.ZERO_HOUR_OP_DONE
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.ACTIVITY_MALL_OP_DONE then
		local var2_5 = var1_5.levels[1]
		local var3_5 = var1_5.levels[2]
		local var4_5 = {}

		if var1_5.cmd == ActivityMallOPCommand.CMD.COMPLETE_ORDER then
			arg0_5.viewComponent:ClearSelectedIds()
			table.insert(var4_5, function(arg0_6)
				arg0_5.viewComponent:ShowCompleteDialogue(arg0_6)
			end)

			local var5_5 = pg.activity_mall_custom_order[var1_5.completeOrderId].story_unlock

			if var5_5 ~= "" then
				table.insert(var4_5, function(arg0_7)
					pg.NewStoryMgr.GetInstance():Play(var5_5, arg0_7)
				end)
			end

			if #var1_5.awards >= 0 then
				table.insert(var4_5, function(arg0_8)
					arg0_5.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_5.awards, arg0_8)
				end)
			end

			if var3_5 ~= var2_5 then
				table.insert(var4_5, function(arg0_9)
					arg0_5.viewComponent:ShowUpgradeBox(var2_5, var3_5, arg0_9)
				end)
			end
		end

		seriesAsync(var4_5, function()
			arg0_5.viewComponent:UpdateData()
			arg0_5.viewComponent:UpdateView()
		end)
	elseif var0_5 == GAME.ZERO_HOUR_OP_DONE then
		arg0_5.viewComponent:UpdateData()
		arg0_5.viewComponent:UpdateView()
	end
end

return var0_0
