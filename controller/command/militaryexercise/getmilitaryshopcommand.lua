local var0 = class("GetMilitaryShopCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(18100, {
		type = 0
	}, 18101, function(arg0)
		local var0 = MeritorousShop.New({
			id = 1,
			good_list = arg0.arena_shop_list,
			refreshCount = arg0.flash_count,
			nextTime = arg0.next_flash_time
		})

		getProxy(ShopsProxy):addMeritorousShop(var0)

		if var1 then
			var1(var0)
		end

		arg0:sendNotification(GAME.GET_MILITARY_SHOP_DONE, Clone(var0))
	end)
end

return var0
