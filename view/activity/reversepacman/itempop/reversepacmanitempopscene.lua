local var0_0 = class("ReversePacmanItemPopScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ReversePacmanItemPopUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2.uiBgBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)
	setText(arg0_2.uiOwnerTitleText, i18n("collect_page_got"))

	arg0_2.goItemList = {}
end

function var0_0.didEnter(arg0_5)
	arg0_5:BlurPanel(arg0_5._tf)

	local var0_5 = arg0_5.contextData
	local var1_5 = Drop.New({
		type = var0_5.dropType,
		id = var0_5.dropID
	})

	updateDrop(arg0_5.uiItem, var1_5)

	local var2_5 = var1_5.cfg

	setText(arg0_5.uiNameText, var2_5.name)
	setText(arg0_5.uiDescText, var1_5.desc)

	local var3_5 = pg.activity_limit_item_guide[var0_5.limitItemGuideID]

	setText(arg0_5.uiCntText, string.format("%s/%s", var0_5.count, var3_5.count))

	for iter0_5, iter1_5 in ipairs(var3_5.link_params) do
		arg0_5.goItemList[iter0_5] = arg0_5.goItemList[iter0_5] or ReversePacmanItemPopItem.New(Object.Instantiate(arg0_5.uiGoItem, arg0_5.uiGoParent), arg0_5)

		arg0_5.goItemList[iter0_5]:didEnter(iter1_5)
	end

	for iter2_5 = #var3_5.link_params + 1, #arg0_5.goItemList do
		arg0_5.goItemList[iter2_5]:Show(false)
	end
end

function var0_0.willExit(arg0_6)
	arg0_6:UnOverlayPanel(arg0_6._tf)

	for iter0_6, iter1_6 in ipairs(arg0_6.goItemList) do
		iter1_6:willExit()
	end

	arg0_6.goItemList = nil
end

return var0_0
