local var0_0 = class("GetMilitaryShopCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(18100, {
		type = 0
	}, 18101, function(arg0_2)
		local var0_2 = MeritorousShop.New({
			id = 1,
			good_list = arg0_2.arena_shop_list,
			refreshCount = arg0_2.flash_count,
			nextTime = arg0_2.next_flash_time
		})

		getProxy(ShopsProxy):addMeritorousShop(var0_2)

		if var1_1 then
			var1_1(var0_2)
		end

		arg0_1:sendNotification(GAME.GET_MILITARY_SHOP_DONE, Clone(var0_2))
	end)
end

return var0_0
