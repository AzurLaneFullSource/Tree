local var0_0 = class("MainReplaceFoodSequence")

function var0_0.Execute(arg0_1, arg1_1)
	local var0_1 = getProxy(ActivityProxy):getActiveBannerByType(GAMEUI_BANNER_10)

	if var0_1 then
		arg0_1:Repalce(var0_1, arg1_1)
	else
		arg0_1:Revert()
		arg1_1()
	end
end

function var0_0.Repalce(arg0_2, arg1_2, arg2_2)
	if var0_0.backUp then
		arg2_2()

		return
	end

	local var0_2

	var0_2 = coroutine.wrap(function()
		onNextTick(var0_2)
		coroutine.yield()

		local var0_3 = pg.item_data_statistics[50004]

		var0_0.backUp = {
			icon = var0_3.icon,
			name = var0_3.name,
			display = var0_3.display
		}

		onNextTick(var0_2)
		coroutine.yield()

		var0_3.icon = "Props/" .. arg1_2.pic

		local var1_3 = string.split(arg1_2.param, "|")

		var0_3.name = var1_3[1]
		var0_3.display = var1_3[2]
		pg.benefit_buff_template[1].icon = "Props/" .. arg1_2.pic

		arg2_2()
	end)

	var0_2()
end

function var0_0.Revert(arg0_4)
	if var0_0.backUp then
		local var0_4 = pg.item_data_statistics[50004]

		var0_4.icon = var0_0.backUp.icon
		var0_4.name = var0_0.backUp.name
		var0_4.display = var0_0.backUp.display
		pg.benefit_buff_template[1].icon = var0_0.backUp.icon
		var0_0.backUp = nil
	end
end

return var0_0
