local var0_0 = class("IslandMsgBoxForStatusWindow", import(".IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBoxForStatus"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.uiItemList = UIItemList.New(arg0_2:findTF("list"), arg0_2:findTF("list/tpl"))
end

function var0_0.OnShow(arg0_3)
	var0_0.super.OnShow(arg0_3)
	arg0_3:FlushItems(arg0_3.settings)
end

function var0_0.FlushBtn(arg0_4, arg1_4)
	setActive(arg0_4.cancelBtn, false)
end

function var0_0.FlushItems(arg0_5, arg1_5)
	local var0_5 = arg1_5.statusList

	assert(var0_5)
	arg0_5.uiItemList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = var0_5[arg1_6 + 1]
			local var1_6 = var0_6:IsDebuff() and "#ff7e7e" or "#5dcbff"

			setText(arg2_6:Find("label/Text"), setColorStr(var0_6:GetName(), var1_6))
			setText(arg2_6:Find("Text"), var0_6:GetDesc())
		end
	end)
	arg0_5.uiItemList:align(#var0_5)
end

return var0_0
