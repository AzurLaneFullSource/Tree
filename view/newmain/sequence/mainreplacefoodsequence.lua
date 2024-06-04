local var0 = class("MainReplaceFoodSequence")

function var0.Execute(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActiveBannerByType(GAMEUI_BANNER_10)

	if var0 then
		arg0:Repalce(var0, arg1)
	else
		arg0:Revert()
		arg1()
	end
end

function var0.Repalce(arg0, arg1, arg2)
	if var0.backUp then
		arg2()

		return
	end

	local var0

	var0 = coroutine.wrap(function()
		onNextTick(var0)
		coroutine.yield()

		local var0 = pg.item_data_statistics[50004]

		var0.backUp = {
			icon = var0.icon,
			name = var0.name,
			display = var0.display
		}

		onNextTick(var0)
		coroutine.yield()

		var0.icon = "Props/" .. arg1.pic

		local var1 = string.split(arg1.param, "|")

		var0.name = var1[1]
		var0.display = var1[2]
		pg.benefit_buff_template[1].icon = "Props/" .. arg1.pic

		arg2()
	end)

	var0()
end

function var0.Revert(arg0)
	if var0.backUp then
		local var0 = pg.item_data_statistics[50004]

		var0.icon = var0.backUp.icon
		var0.name = var0.backUp.name
		var0.display = var0.backUp.display
		pg.benefit_buff_template[1].icon = var0.backUp.icon
		var0.backUp = nil
	end
end

return var0
