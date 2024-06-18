local var0_0 = class("AmusementParkShopMediator", import("view.base.ContextMediator"))

var0_0.ON_ACT_SHOPPING = "AmusementParkShopMediator:ON_ACT_SHOPPING"
var0_0.GO_SCENE = "GO_SCENE"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SHOP_PROGRESS_REWARD)

	assert(var0_1, "Activity Type ACTIVITY_TYPE_SHOP_PROGRESS_REWARD Not exist")
	arg0_1:TransActivity2ShopData(var0_1)
	arg0_1:AddSpecialList(var0_1)
	arg0_1:bind(var0_0.ON_ACT_SHOPPING, function(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
		arg0_1:sendNotification(GAME.ACTIVITY_SHOP_PROGRESS_REWARD, {
			activity_id = arg1_2,
			cmd = arg2_2,
			arg1 = arg3_2,
			arg2 = arg4_2
		})
	end)
	arg0_1:bind(var0_0.GO_SCENE, function(arg0_3, arg1_3, ...)
		arg0_1:sendNotification(GAME.GO_SCENE, arg1_3, ...)
	end)
	arg0_1:HandleSpecialReach(var0_1)
end

function var0_0.TransActivity2ShopData(arg0_4, arg1_4)
	if arg1_4 and not arg1_4:isEnd() then
		local var0_4 = ActivityShop.New(arg1_4)

		arg0_4.viewComponent:SetShop(var0_4)
	end
end

function var0_0.AddSpecialList(arg0_5, arg1_5)
	local var0_5 = {}

	if pg.gameset.activity_lottery_rewards then
		for iter0_5, iter1_5 in ipairs(pg.gameset.activity_lottery_rewards.description or {}) do
			local var1_5 = Drop.Create(iter1_5[2])

			var1_5.HasGot = table.contains(arg1_5.data3_list, iter1_5[1])

			table.insert(var0_5, var1_5)
		end
	end

	arg0_5.viewComponent:SetSpecial(var0_5)
end

function var0_0.HandleSpecialReach(arg0_6, arg1_6)
	if not pg.gameset.activity_lottery_rewards or not pg.gameset.activity_lottery_rewards.description then
		return
	end

	local var0_6 = _.reduce(arg1_6.data2_list, 0, function(arg0_7, arg1_7)
		return arg0_7 + arg1_7
	end)

	for iter0_6, iter1_6 in ipairs(pg.gameset.activity_lottery_rewards.description) do
		if var0_6 >= iter1_6[1] and not table.contains(arg1_6.data3_list, iter1_6[1]) then
			arg0_6:sendNotification(GAME.ACTIVITY_SHOP_PROGRESS_REWARD, {
				cmd = 2,
				arg2 = 0,
				activity_id = arg1_6.id,
				arg1 = iter1_6[1]
			})

			return true
		end
	end

	return false
end

function var0_0.listNotificationInterests(arg0_8)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityShopWithProgressRewardCommand.SHOW_SHOP_REWARD
	}
end

function var0_0.handleNotification(arg0_9, arg1_9)
	local var0_9 = arg1_9:getName()
	local var1_9 = arg1_9:getBody()

	if var0_9 == ActivityProxy.ACTIVITY_UPDATED then
		if var1_9:getConfig("type") == ActivityConst.ACTIVITY_TYPE_SHOP_PROGRESS_REWARD then
			local var2_9 = var1_9

			arg0_9:TransActivity2ShopData(var2_9)
			arg0_9:AddSpecialList(var2_9)
			arg0_9.viewComponent:UpdateView()
			arg0_9:HandleSpecialReach(var2_9)
		end
	elseif var0_9 == ActivityShopWithProgressRewardCommand.SHOW_SHOP_REWARD then
		arg0_9.viewComponent:emit(BaseUI.ON_ACHIEVE, var1_9.awards, function()
			if var1_9.shopType == 1 then
				arg0_9.viewComponent:ShowShipWord(i18n("amusementpark_shop_success"))
			elseif var1_9.shopType == 2 then
				arg0_9.viewComponent:ShowShipWord(i18n("amusementpark_shop_special"))
			end

			existCall(var1_9.callback)
		end)
	end
end

return var0_0
