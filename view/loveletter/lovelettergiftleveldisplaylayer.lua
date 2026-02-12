local var0_0 = class("LoveLetterGiftLevelDisplayLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "LoveLetterLevelDisplayUI"
end

var0_0.optionsPath = {}

function var0_0.init(arg0_2)
	setText(arg0_2.textBg, i18n("word_click_to_close"))
	setText(arg0_2.rtLevelUpPanel:Find("adapt/range/content/Text"), i18n("loveactivity_ui_13"))
	onButton(arg0_2, arg0_2.rtBg, function()
		arg0_2:closeView()
	end, SFX_CANCEL)
	arg0_2:BlurPanel(arg0_2._tf)
end

function var0_0.SetLoveLetter(arg0_4, arg1_4)
	arg0_4.ll = getProxy(LoveLetterProxy):GetGroupData(arg1_4)
end

function var0_0.didEnter(arg0_5)
	arg0_5:UpdateDisplay()
end

function var0_0.UpdateDisplay(arg0_6)
	arg0_6:UpdatePainting()
	arg0_6:UpdateMedalSlider()
	arg0_6:UpdateLoveLetterMedal()

	if arg0_6.contextData.isLevelUp and arg0_6.ll:GetDisplayLevel() <= #pg.lover_letter_content.get_id_list_by_ship_group[arg0_6.ll.groupId] then
		arg0_6:UpdateLevelUpPanel()
		setActive(arg0_6.rtLevelUpPanel, true)
	else
		setActive(arg0_6.rtLevelUpPanel, false)
	end

	arg0_6.contextData.isLevelUp = nil
end

function var0_0.UpdatePainting(arg0_7)
	local var0_7 = arg0_7.ll:GetPainting()

	if arg0_7.paint == var0_7 then
		return
	end

	if arg0_7.paint then
		retPaintingPrefab(arg0_7.rtPainting, arg0_7.paint)

		arg0_7.paint = nil
	end

	arg0_7.paint = var0_7

	setPaintingPrefabAsync(arg0_7.rtPainting, arg0_7.paint, "biandui")
end

function var0_0.UpdateLoveLetterMedal(arg0_8)
	local var0_8 = arg0_8.ll:GetPrefabName()

	if arg0_8.medalPath == var0_8 then
		return
	end

	local var1_8 = arg0_8.rtNow:Find("medal")

	arg0_8.medalPath = var0_8

	setLoveLetterMedal(var1_8, arg0_8.ll)
end

function var0_0.UpdateMedalSlider(arg0_9)
	local var0_9, var1_9 = arg0_9.ll:GetDisplayExp()

	if var1_9 == 0 then
		setSlider(arg0_9.rtNow:Find("Slider"), 0, 1, 1)
	else
		setSlider(arg0_9.rtNow:Find("Slider"), 0, var1_9, var0_9)
	end

	setText(arg0_9.rtNow:Find("Text"), string.format(setColorStr("%d", "#CF90A8") .. "/%d", var0_9, var1_9))
end

function var0_0.UpdateLevelUpPanel(arg0_10)
	local var0_10 = pg.lover_nation[arg0_10.ll:GetNation()].letter_icon

	updateDrop(arg0_10.rtIconTpl, Drop.Create(var0_10))
	onButton(arg0_10, arg0_10.rtIconTpl, function()
		arg0_10:emit(LoveLetterGiftLevelDisplayMediator.ON_GO_COLLECTION)
	end, SFX_PANEL)
end

function var0_0.willExit(arg0_12)
	arg0_12:UnOverlayPanel(arg0_12._tf)

	if arg0_12.paint then
		retPaintingPrefab(arg0_12.rtPainting, arg0_12.paint)

		arg0_12.paint = nil
	end

	if arg0_12.medalPath then
		returnLoveLetterMedal(arg0_12.rtNow:Find("medal"):GetChild(0))

		arg0_12.medalPath = nil
	end
end

return var0_0
