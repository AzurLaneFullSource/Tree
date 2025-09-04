local var0_0 = class("IslandDeviceBaseBtn", import(".IslandMainBaseBtn"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._tf = arg1_1
	arg0_1.event = arg2_1
	arg0_1.configId = arg3_1
	arg0_1.config = pg.island_main_btns[arg0_1.configId]
	arg0_1.tipTF = arg0_1._tf:Find("tip")
	arg0_1.iconTF = arg0_1._tf:Find("icon")
	arg0_1.nameTF = arg0_1._tf:Find("name")

	setText(arg0_1.nameTF, arg0_1.config.name)
	arg0_1:Init()
end

return var0_0
