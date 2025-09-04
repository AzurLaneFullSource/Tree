local var0_0 = class("IslandAwardDisplayWindow", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandAwardDisplayUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.frameTr = arg0_2:findTF("frame")
	arg0_2.title = arg0_2:findTF("frame/Board/Top/text/text"):GetComponent("Text")
	arg0_2.uiitemList = UIItemList.New(arg0_2:findTF("frame/Board/Content/award/content"), arg0_2:findTF("frame/Board/Content/award/content/tpl"))

	setText(arg0_2:findTF("frame/tip"), i18n("island_click_close"))

	arg0_2.animator = arg0_2.frameTr:GetComponent(typeof(Animation))
	arg0_2.aniDft = arg0_2.frameTr:GetComponent(typeof(DftAniEvent))
end

function var0_0.Show(arg0_3, arg1_3)
	var0_0.super.Show(arg0_3)

	arg0_3.title.text = setColorStr(arg1_3.title or "", arg1_3.titleColor or "#393a3c")

	arg0_3:UpdateAwards(arg1_3.awards)
end

function var0_0.UpdateAwards(arg0_4, arg1_4)
	arg0_4.uiitemList:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = arg1_4[arg1_5 + 1]

			updateCustomDrop(arg2_5, var0_5)
			setText(findTF(arg2_5, "icon_bg/count_bg/count"), "x" .. var0_5.count)
		end
	end)
	arg0_4.uiitemList:align(#arg1_4)
end

function var0_0.PlayExitAniamtion(arg0_6, arg1_6)
	arg0_6.aniDft:SetEndEvent(function()
		arg0_6.aniDft:SetEndEvent(nil)
		arg1_6()
	end)
	arg0_6.animator:Play("anim_Island_commonget_single_out")
end

function var0_0.OnDestroy(arg0_8)
	arg0_8.aniDft:SetEndEvent(nil)
end

return var0_0
