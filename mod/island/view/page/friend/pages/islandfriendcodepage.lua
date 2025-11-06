local var0_0 = class("IslandFriendCodePage", import("view.base.BaseSubView"))
local var1_0 = 4

function var0_0.getUIName(arg0_1)
	return "IslandFirendCodeUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.enterBtn = arg0_2._tf:Find("frame/visit")
	arg0_2.saveBtn = arg0_2._tf:Find("frame/like")
	arg0_2.inputTr = arg0_2._tf:Find("frame/input")
	arg0_2.uiItemlist = UIItemList.New(arg0_2._tf:Find("frame/list"), arg0_2._tf:Find("frame/list/tpl"))
	arg0_2.tipTxt = arg0_2._tf:Find("frame/sub_title/Text"):GetComponent(typeof(Text))
	arg0_2.frequentlyUsedList = arg0_2:GetSaveCodeList()

	setText(arg0_2._tf:Find("frame/title/Text"), i18n("island_input_code_tip"))
	setText(arg0_2._tf:Find("frame/input/Text"), i18n("island_input_code_tip_1"))
	setText(arg0_2._tf:Find("frame/like/Text"), i18n("island_set_like"))
	setText(arg0_2._tf:Find("frame/visit/Text"), i18n("island_btn_label_visit"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.enterBtn, function()
		local var0_4 = getInputText(arg0_3.inputTr)

		if not var0_4 or var0_4 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_input_code_erro"))

			return
		end

		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandVisitByCode())
		arg0_3:emit(IslandMediator.ENTER_ISLAND_BY_CODE, var0_4)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.saveBtn, function()
		arg0_3:AddCode()
	end, SFX_PANEL)
	arg0_3:InitFrequentlyUsedList()
end

function var0_0.GetSaveCodeList(arg0_6)
	local var0_6 = getProxy(PlayerProxy):getRawData().id
	local var1_6 = PlayerPrefs.GetString("_ISLAND_CODE_" .. var0_6, "")

	if var1_6 == "" then
		return {}
	end

	return (string.split(var1_6, "#"))
end

function var0_0.AddCode(arg0_7)
	if #arg0_7.frequentlyUsedList >= var1_0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_visit_tip7"))

		return
	end

	local var0_7 = getInputText(arg0_7.inputTr)

	if not var0_7 or var0_7 == "" then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_input_code_erro"))

		return
	end

	if table.contains(arg0_7.frequentlyUsedList, var0_7) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_code_exist"))

		return
	end

	table.insert(arg0_7.frequentlyUsedList, var0_7)
	arg0_7:InitFrequentlyUsedList()
end

function var0_0.RemoveCode(arg0_8, arg1_8)
	table.removebyvalue(arg0_8.frequentlyUsedList, arg1_8)
	arg0_8:InitFrequentlyUsedList()
end

function var0_0.SaveCodeList(arg0_9)
	local var0_9 = table.concat(arg0_9.frequentlyUsedList, "#")
	local var1_9 = getProxy(PlayerProxy):getRawData().id
	local var2_9 = PlayerPrefs.SetString("_ISLAND_CODE_" .. var1_9, var0_9)

	PlayerPrefs.Save()
end

function var0_0.InitFrequentlyUsedList(arg0_10)
	arg0_10.uiItemlist:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = arg0_10.frequentlyUsedList[arg1_11 + 1]

			setActive(arg2_11:Find("btns"), var0_11)
			setActive(arg2_11:Find("empty"), not var0_11)

			if var0_11 then
				arg0_10:UpdateCodeTpl(arg2_11:Find("btns"), var0_11)
			end
		end
	end)
	arg0_10.uiItemlist:align(var1_0)

	arg0_10.tipTxt.text = i18n("island_like_title") .. #arg0_10.frequentlyUsedList .. "/" .. var1_0
end

function var0_0.UpdateCodeTpl(arg0_12, arg1_12, arg2_12)
	setText(arg1_12:Find("id/Text"), arg2_12)
	onButton(arg0_12, arg1_12:Find("copy"), function()
		UniPasteBoard.SetClipBoardString(arg2_12)
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_id_copy_ok"))
	end, SFX_PANEL)
	onButton(arg0_12, arg1_12:Find("remove"), function()
		arg0_12:RemoveCode(arg2_12)
	end, SFX_PANEL)
	setText(arg1_12:Find("remove/Text"), i18n("island_btn_label_remove"))
	setText(arg1_12:Find("copy/Text"), i18n("island_btn_label_copy"))
end

function var0_0.Hide(arg0_15)
	var0_0.super.Hide(arg0_15)
	arg0_15:SaveCodeList()
end

function var0_0.OnDestroy(arg0_16)
	if arg0_16:isShowing() then
		arg0_16:Hide()
	end
end

return var0_0
