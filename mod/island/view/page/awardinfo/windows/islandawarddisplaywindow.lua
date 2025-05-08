local var0_0 = class("IslandAwardDisplayWindow", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandAwardDisplayUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.title = arg0_2:findTF("frame/title"):GetComponent("Text")
	arg0_2.uiitemList = UIItemList.New(arg0_2:findTF("frame/awards"), arg0_2:findTF("frame/awards/tpl_1"))

	setText(arg0_2:findTF("frame/tip"), i18n1("点击空白关闭"))
end

function var0_0.Show(arg0_3, arg1_3)
	arg0_3.super.Show(arg0_3)

	arg0_3.title.text = setColorStr(arg1_3.title or "", arg1_3.titleColor or "#393a3c")

	arg0_3:UpdateAwards(arg1_3.awards)
end

function var0_0.UpdateAwards(arg0_4, arg1_4)
	arg0_4.uiitemList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = arg1_4[arg1_5 + 1]

			updateDrop(arg2_5, var0_5)
			setText(findTF(arg2_5, "icon_bg/count_bg/count"), "x" .. var0_5.count)
		end
	end)
	arg0_4.uiitemList:align(#arg1_4)
end

function var0_0.OnDestroy(arg0_6)
	return
end

return var0_0
