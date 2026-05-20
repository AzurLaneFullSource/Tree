local var0_0 = class("MallMediator", import("view.base.ContextMediator"))

var0_0.CHANGE_SCENE = "MallMediator.CHANGE_SCENE"
var0_0.GO_SCENE = "MallMediator.GO_SCENE"
var0_0.GO_SUBLAYER = "MallMediator.GO_SUBLAYER"
var0_0.OPEN_SUMMARY_BOX = "MallMediator.OPEN_SUMMARY_BOX"
var0_0.SETTLE_ROUND = "MallMediator.SETTLE_ROUND"
var0_0.INPUT_GOLD = "MallMediator.INPUT_GOLD"
var0_0.GET_GOLD_AWARD = "MallMediator.GET_GOLD_AWARD"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.CHANGE_SCENE, function(arg0_2, arg1_2, ...)
		arg0_1:sendNotification(GAME.CHANGE_SCENE, arg1_2, ...)
	end)
	arg0_1:bind(var0_0.GO_SCENE, function(arg0_3, arg1_3, ...)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_3, ...)
	end)
	arg0_1:bind(var0_0.GO_SUBLAYER, function(arg0_4, arg1_4, arg2_4)
		arg0_1:addSubLayers(arg1_4, nil, arg2_4)
	end)
	arg0_1:bind(var0_0.OPEN_SUMMARY_BOX, function(arg0_5)
		arg0_1.viewComponent:ShowSummaryBox()
	end)
	arg0_1:bind(var0_0.SETTLE_ROUND, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.ACTIVITY_MALL_OP, {
			activity_id = arg1_6,
			cmd = ActivityMallOPCommand.CMD.SETTLE_ROUND
		})
	end)
	arg0_1:bind(var0_0.INPUT_GOLD, function(arg0_7, arg1_7, arg2_7)
		arg0_1:sendNotification(GAME.ACTIVITY_MALL_OP, {
			activity_id = arg1_7,
			cmd = ActivityMallOPCommand.CMD.INPUT_GOLD,
			arg1 = arg2_7
		})
	end)
	arg0_1:bind(var0_0.GET_GOLD_AWARD, function(arg0_8, arg1_8, arg2_8)
		arg0_1:sendNotification(GAME.ACTIVITY_MALL_OP, {
			activity_id = arg1_8,
			cmd = ActivityMallOPCommand.CMD.GET_GOLD_AWARD,
			arg_list = arg2_8
		})
	end)
end

function var0_0.listNotificationInterests(arg0_9)
	return {
		GAME.ACTIVITY_MALL_OP_DONE,
		GAME.ZERO_HOUR_OP_DONE
	}
end

function var0_0.handleNotification(arg0_10, arg1_10)
	local var0_10 = arg1_10:getName()
	local var1_10 = arg1_10:getBody()

	if var0_10 == GAME.ACTIVITY_MALL_OP_DONE then
		local var2_10 = var1_10.levels[1]
		local var3_10 = var1_10.levels[2]
		local var4_10 = {}

		if var1_10.cmd == ActivityMallOPCommand.CMD.SETTLE_ROUND then
			table.insert(var4_10, function(arg0_11)
				arg0_10.viewComponent:ShowSettleBox(var2_10, arg0_11)
			end)

			if #var1_10.awards >= 0 then
				table.insert(var4_10, function(arg0_12)
					arg0_10.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_10.awards, arg0_12)
				end)
			end

			if var3_10 ~= var2_10 then
				table.insert(var4_10, function(arg0_13)
					arg0_10.viewComponent:ShowUpgradeBox(var2_10, var3_10, arg0_13)
				end)
			end
		end

		seriesAsync(var4_10, function()
			arg0_10.viewComponent:UpdateData()
			arg0_10.viewComponent:UpdateView()
		end)
	elseif var0_10 == GAME.ZERO_HOUR_OP_DONE then
		arg0_10.viewComponent:UpdateData()
		arg0_10.viewComponent:UpdateView()
	end
end

return var0_0
