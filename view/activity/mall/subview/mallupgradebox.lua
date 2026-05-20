local var0_0 = class("MallUpgradeBox", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MallUpgradeBox"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2.uiTitleText, i18n("mall_upgrade_title"))
	setText(arg0_2.uiSureText, i18n("text_confirm"))
	setText(arg0_2.uiLevelHeaderText, i18n("mall_level_header"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.uiSureBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)

	arg0_3.unlockUIList = UIItemList.New(arg0_3.uiContentTF, arg0_3.uiContentTF:Find("tpl"))

	arg0_3.unlockUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			setText(arg2_6:Find("header"), i18n("word_unlock"))
			setText(arg2_6:Find("Text"), arg0_3.unlockNameList[arg1_6 + 1])
		end
	end)

	arg0_3.lv2FloorIds = {}

	for iter0_3, iter1_3 in ipairs(pg.activity_mall_template.all) do
		local var0_3 = pg.activity_mall_template[iter1_3].need_mall_level

		if not arg0_3.lv2FloorIds[var0_3] then
			arg0_3.lv2FloorIds[var0_3] = {}
		end

		table.insert(arg0_3.lv2FloorIds[var0_3], iter1_3)
	end
end

function var0_0.Show(arg0_7, arg1_7, arg2_7, arg3_7)
	var0_0.super.Show(arg0_7)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf)

	arg0_7.onHide = arg3_7

	setText(arg0_7.uiOldLevelText, arg1_7)
	setText(arg0_7.uiNewLevelText, arg2_7)

	arg0_7.unlockNameList = {}

	for iter0_7 = arg1_7 + 1, arg2_7 do
		if arg0_7.lv2FloorIds[iter0_7] then
			for iter1_7, iter2_7 in ipairs(arg0_7.lv2FloorIds[iter0_7]) do
				local var0_7 = pg.activity_mall_template[iter2_7].name

				table.insert(arg0_7.unlockNameList, var0_7)
			end
		end
	end

	arg0_7.unlockUIList:align(#arg0_7.unlockNameList)
end

function var0_0.Hide(arg0_8)
	var0_0.super.Hide(arg0_8)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_8._tf)
	existCall(arg0_8.onHide)

	arg0_8.onHide = nil
end

function var0_0.OnDestroy(arg0_9)
	return
end

return var0_0
