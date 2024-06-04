local var0 = class("AmusementParkShopMediator", import("view.base.ContextMediator"))

var0.ON_ACT_SHOPPING = "AmusementParkShopMediator:ON_ACT_SHOPPING"
var0.GO_SCENE = "GO_SCENE"

function var0.register(arg0)
	local var0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_SHOP_PROGRESS_REWARD)

	assert(var0, "Activity Type ACTIVITY_TYPE_SHOP_PROGRESS_REWARD Not exist")
	arg0:TransActivity2ShopData(var0)
	arg0:AddSpecialList(var0)
	arg0:bind(var0.ON_ACT_SHOPPING, function(arg0, arg1, arg2, arg3, arg4)
		arg0:sendNotification(GAME.ACTIVITY_SHOP_PROGRESS_REWARD, {
			activity_id = arg1,
			cmd = arg2,
			arg1 = arg3,
			arg2 = arg4
		})
	end)
	arg0:bind(var0.GO_SCENE, function(arg0, arg1, ...)
		arg0:sendNotification(GAME.GO_SCENE, arg1, ...)
	end)
	arg0:HandleSpecialReach(var0)
end

function var0.TransActivity2ShopData(arg0, arg1)
	if arg1 and not arg1:isEnd() then
		local var0 = ActivityShop.New(arg1)

		arg0.viewComponent:SetShop(var0)
	end
end

function var0.AddSpecialList(arg0, arg1)
	local var0 = {}

	if pg.gameset.activity_lottery_rewards then
		for iter0, iter1 in ipairs(pg.gameset.activity_lottery_rewards.description or {}) do
			local var1 = Drop.Create(iter1[2])

			var1.HasGot = table.contains(arg1.data3_list, iter1[1])

			table.insert(var0, var1)
		end
	end

	arg0.viewComponent:SetSpecial(var0)
end

function var0.HandleSpecialReach(arg0, arg1)
	if not pg.gameset.activity_lottery_rewards or not pg.gameset.activity_lottery_rewards.description then
		return
	end

	local var0 = _.reduce(arg1.data2_list, 0, function(arg0, arg1)
		return arg0 + arg1
	end)

	for iter0, iter1 in ipairs(pg.gameset.activity_lottery_rewards.description) do
		if var0 >= iter1[1] and not table.contains(arg1.data3_list, iter1[1]) then
			arg0:sendNotification(GAME.ACTIVITY_SHOP_PROGRESS_REWARD, {
				cmd = 2,
				arg2 = 0,
				activity_id = arg1.id,
				arg1 = iter1[1]
			})

			return true
		end
	end

	return false
end

function var0.listNotificationInterests(arg0)
	return {
		ActivityProxy.ACTIVITY_UPDATED,
		ActivityShopWithProgressRewardCommand.SHOW_SHOP_REWARD
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == ActivityProxy.ACTIVITY_UPDATED then
		if var1:getConfig("type") == ActivityConst.ACTIVITY_TYPE_SHOP_PROGRESS_REWARD then
			local var2 = var1

			arg0:TransActivity2ShopData(var2)
			arg0:AddSpecialList(var2)
			arg0.viewComponent:UpdateView()
			arg0:HandleSpecialReach(var2)
		end
	elseif var0 == ActivityShopWithProgressRewardCommand.SHOW_SHOP_REWARD then
		arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, var1.awards, function()
			if var1.shopType == 1 then
				arg0.viewComponent:ShowShipWord(i18n("amusementpark_shop_success"))
			elseif var1.shopType == 2 then
				arg0.viewComponent:ShowShipWord(i18n("amusementpark_shop_special"))
			end

			existCall(var1.callback)
		end)
	end
end

return var0
