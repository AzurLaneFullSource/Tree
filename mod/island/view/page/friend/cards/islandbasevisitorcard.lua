local var0_0 = class("IslandBaseVisitorCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1.icon = arg1_1.transform:Find("frame/icon"):GetComponent(typeof(Image))
	arg0_1.nameTxt = arg1_1.transform:Find("name"):GetComponent(typeof(Text))
	arg0_1.levelTxt = arg1_1.transform:Find("level"):GetComponent(typeof(Text))
	arg0_1.btn = arg1_1.transform:Find("btn")
	arg0_1.btnTxt = arg1_1.transform:Find("btn/Text"):GetComponent(typeof(Text))
	arg0_1.cardBtn = arg1_1.transform:Find("frame/icon")
end

function var0_0.Update(arg0_2, arg1_2)
	arg0_2.player = arg1_2

	local var0_2 = arg0_2.icon
	local var1_2 = pg.ship_data_statistics[arg1_2.icon]
	local var2_2 = Ship.New({
		configId = arg1_2.icon
	})

	LoadSpriteAsync("qicon/" .. var2_2:getPrefab(), function(arg0_3)
		var0_2.sprite = arg0_3
	end)

	arg0_2.nameTxt.text = arg1_2.name
	arg0_2.levelTxt.text = "LV." .. arg1_2.level
end

function var0_0.Dispose(arg0_4)
	return
end

return var0_0
