local var0_0 = class("ChapterAutoAddTimePanel", import("view.base.BaseSubView"))

var0_0.GET_SHOW_ID = {
	[ChapterAutoTicket.TYPE.MAIN] = 68710,
	[ChapterAutoTicket.TYPE.TIME] = 68711
}

function var0_0.getUIName(arg0_1)
	return "ChapterAutoAddTimePanel"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2.uiTitleText, i18n("auto_battle_time_add_headline"))
	setText(arg0_2.uiTitleEnText, i18n("auto_battle_time_add_headline_en"))
	setText(arg0_2.uiSureBtn:Find("Text"), i18n("auto_battle_time_add_confirm"))
	setText(arg0_2.uiCancelBtn:Find("Text"), i18n("auto_battle_time_add_cancel"))

	arg0_2.uiList = UIItemList.New(arg0_2.uiContent, arg0_2.uiContent:Find("tpl"))
	arg0_2.type2Second = {}
	arg0_2.type2Second[ChapterAutoTicket.TYPE.TIME] = pg.gameset.auto_battle_tickect_to_second_type3.key_value
	arg0_2.type2Second[ChapterAutoTicket.TYPE.MAIN] = pg.gameset.auto_battle_tickect_to_second_type1.key_value
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.uiCancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.uiCloseBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.uiSureBtn, function()
		local var0_7 = arg0_3.selectedCntByType[ChapterAutoTicket.TYPE.MAIN] or 0
		local var1_7 = arg0_3.selectedCntByType[ChapterAutoTicket.TYPE.TIME] or 0

		if var0_7 == 0 and var1_7 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_time_add_zero_item"))

			return
		end

		pg.m02:sendNotification(GAME.ADD_CHAPTER_AUTO_TIME, {
			type1Num = var0_7,
			type3Num = var1_7,
			callback = function()
				arg0_3:UpdateData()
			end
		})
	end, SFX_PANEL)
	arg0_3.uiList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventInit then
			arg0_3:InitTpl(arg1_9, arg2_9)
		elseif arg0_9 == UIItemList.EventUpdate then
			arg0_3:UpdateTpl(arg1_9, arg2_9)
		end
	end)
end

function var0_0.Show(arg0_10)
	pg.UIMgr.GetInstance():BlurPanel(arg0_10._tf)
	var0_0.super.Show(arg0_10)
	arg0_10:UpdateData()
end

function var0_0.UpdateData(arg0_11)
	local var0_11 = getProxy(ChapterAutoProxy)

	arg0_11.remainTime = var0_11:GetRemainTime()
	arg0_11.allCntByType = {}

	local var1_11 = var0_11:GetTicketListByType(ChapterAutoTicket.TYPE.TIME)

	arg0_11.allCntByType[ChapterAutoTicket.TYPE.TIME] = underscore.reduce(var1_11, 0, function(arg0_12, arg1_12)
		return arg0_12 + arg1_12:GetCount()
	end)

	local var2_11 = var0_11:GetTicketListByType(ChapterAutoTicket.TYPE.MAIN)

	arg0_11.allCntByType[ChapterAutoTicket.TYPE.MAIN] = underscore.reduce(var2_11, 0, function(arg0_13, arg1_13)
		return arg0_13 + arg1_13:GetCount()
	end)
	arg0_11.showTypes = {
		ChapterAutoTicket.TYPE.MAIN
	}

	if pg.gameset.auto_battle_time_add_item_show_type3.key_value == 1 then
		table.insert(arg0_11.showTypes, ChapterAutoTicket.TYPE.TIME)
	end

	arg0_11.selectedCntByType = {}

	for iter0_11, iter1_11 in pairs(arg0_11.showTypes) do
		arg0_11.selectedCntByType[iter1_11] = 0
	end

	arg0_11.uiList:align(#arg0_11.showTypes)
	arg0_11:OnSelCntUpdate()
end

function var0_0.OnSelCntUpdate(arg0_14)
	local var0_14 = 0

	for iter0_14, iter1_14 in pairs(arg0_14.showTypes) do
		var0_14 = var0_14 + arg0_14.type2Second[iter1_14] * arg0_14.selectedCntByType[iter1_14]
	end

	local var1_14 = pg.TimeMgr.GetInstance()
	local var2_14 = i18n("auto_battle_time_add_info", var1_14:DescCDTime(arg0_14.remainTime), var1_14:DescCDTime(var0_14))

	if arg0_14.remainTime < 0 then
		var2_14 = string.gsub(var2_14, "#ffffff", COLOR_RED)
	end

	setText(arg0_14.uiTimeText, var2_14)
	arg0_14.uiList:align(#arg0_14.showTypes)
end

function var0_0.InitTpl(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.showTypes[arg1_15 + 1]
	local var1_15 = Drop.New({
		type = DROP_TYPE_VITEM,
		id = var0_0.GET_SHOW_ID[var0_15],
		count = arg0_15.allCntByType[var0_15]
	})

	updateDrop(arg2_15:Find("IconTpl"), var1_15, {
		count = arg0_15.allCntByType[var0_15]
	})
	setScrollText(arg2_15:Find("name/Text"), var1_15:getName())
	onButton(arg0_15, arg2_15, function()
		local var0_16 = arg0_15.allCntByType[var0_15]

		if var0_16 <= 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_time_add_item_lack"))

			return
		end

		if arg0_15.selectedCntByType[var0_15] == var0_16 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_time_add_item_lack"))

			return
		end

		arg0_15.selectedCntByType[var0_15] = arg0_15.selectedCntByType[var0_15] + 1

		arg0_15:OnSelCntUpdate()
	end, SFX_PANEL)
	onButton(arg0_15, arg2_15:Find("cnt/reduce"), function()
		if arg0_15.selectedCntByType[var0_15] == 0 then
			return
		end

		arg0_15.selectedCntByType[var0_15] = arg0_15.selectedCntByType[var0_15] - 1

		arg0_15:OnSelCntUpdate()
	end, SFX_PANEL)
end

function var0_0.UpdateTpl(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18.showTypes[arg1_18 + 1]
	local var1_18 = arg0_18.selectedCntByType[var0_18]
	local var2_18 = arg0_18.allCntByType[var0_18]
	local var3_18 = var1_18 > 0

	setActive(arg2_18:Find("select"), var3_18)
	setActive(arg2_18:Find("cnt"), var1_18 > 0)
	setText(arg2_18:Find("cnt/Text"), var1_18)
	setText(arg2_18:Find("IconTpl/icon_bg/count"), var2_18)
end

function var0_0.Hide(arg0_19)
	var0_0.super.Hide(arg0_19)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_19._tf, arg0_19._parentTf)
end

function var0_0.OnDestroy(arg0_20)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_20._tf, arg0_20._parentTf)
end

return var0_0
