local var0_0 = class("IslandVisitorCard", import(".IslandBaseVisitorCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.localtionTxt = arg1_1.transform:Find("localtion/Text"):GetComponent(typeof(Text))
	arg0_1.btnTxt.text = i18n("island_btn_label_kick")
end

function var0_0.Update(arg0_2, arg1_2)
	var0_0.super.Update(arg0_2, arg1_2)

	arg0_2.localtionTxt.text = i18n("island_btn_label_location", arg1_2:GetLoaction())
end

return var0_0
