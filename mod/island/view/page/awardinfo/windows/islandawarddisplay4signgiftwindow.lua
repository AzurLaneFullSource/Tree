local var0_0 = class("IslandAwardDisplay4SignGiftWindow", import(".IslandAwardDisplayWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandAwardDisplay4SignGiftUI"
end

function var0_0.Show(arg0_2, arg1_2)
	var0_0.super.Show(arg0_2, arg1_2)

	arg0_2.title.text = ""
end

return var0_0
