local var0_0 = class("IslandAwardDisplayWindow", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandAwardDisplayUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.frameTr = arg0_2._tf:Find("frame")
	arg0_2.title = arg0_2._tf:Find("frame/Board/Top/text/text"):GetComponent("Text")
	arg0_2.uiitemList = UIItemList.New(arg0_2._tf:Find("frame/Board/Content/award/content"), arg0_2._tf:Find("frame/Board/Content/award/content/tpl"))

	setText(arg0_2._tf:Find("frame/tip"), i18n("island_click_close"))

	arg0_2.animator = arg0_2.frameTr:GetComponent(typeof(Animation))
	arg0_2.aniDft = arg0_2.frameTr:GetComponent(typeof(DftAniEvent))
	arg0_2.scrollRect = arg0_2._tf:Find("frame/Board/Content/award_scroll/content"):GetComponent("LScrollRect")

	function arg0_2.scrollRect.onInitItem(arg0_3)
		return
	end

	function arg0_2.scrollRect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end
end

function var0_0.Show(arg0_5, arg1_5)
	var0_0.super.Show(arg0_5)

	arg0_5.title.text = setColorStr(arg1_5.title or "", arg1_5.titleColor or "#393a3c")

	arg0_5:UpdateAwards(arg1_5.awards)
end

function var0_0.OnUpdateItem(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg2_6.transform
	local var1_6 = arg0_6.awards[arg1_6 + 1]

	updateCustomDrop(var0_6, var1_6, {
		style = "island"
	})
	setText(findTF(var0_6, "icon_bg/count_bg/count"), "x" .. var1_6.count)
end

function var0_0.UpdateAwards(arg0_7, arg1_7)
	local var0_7 = #arg1_7 > 10

	arg0_7.awards = arg1_7

	setActive(arg0_7._tf:Find("frame/Board/Content/award_scroll"), var0_7)
	setActive(arg0_7._tf:Find("frame/Board/Content/award"), not var0_7)

	if var0_7 then
		arg0_7.scrollRect:SetTotalCount(#arg0_7.awards, -1)
	else
		arg0_7.uiitemList:make(function(arg0_8, arg1_8, arg2_8)
			if arg0_8 == UIItemList.EventUpdate then
				local var0_8 = arg1_7[arg1_8 + 1]

				updateCustomDrop(arg2_8, var0_8, {
					style = "island"
				})
				setText(findTF(arg2_8, "icon_bg/count_bg/count"), "x" .. var0_8.count)
			end
		end)
		arg0_7.uiitemList:align(#arg1_7)
	end
end

function var0_0.PlayExitAniamtion(arg0_9, arg1_9)
	arg0_9.aniDft:SetEndEvent(function()
		arg0_9.aniDft:SetEndEvent(nil)
		arg1_9()
	end)
	arg0_9.animator:Play("anim_Island_commonget_single_out")
end

function var0_0.OnDestroy(arg0_11)
	arg0_11.aniDft:SetEndEvent(nil)
	ClearLScrollrect(arg0_11.scrollRect)
end

return var0_0
