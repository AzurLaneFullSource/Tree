local var0_0 = class("MainWordBtn", import(".MainBaseBtn"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.wordOpen = findTF(arg1_1, "open"):GetComponent(typeof(CanvasGroup))
	arg0_1.wordClose = findTF(arg1_1, "close"):GetComponent(typeof(CanvasGroup))
	arg0_1.wordFlag = getProxy(SettingsProxy):ShouldShipMainSceneWord()
end

function var0_0.OnClick(arg0_2)
	arg0_2.wordFlag = not arg0_2.wordFlag

	getProxy(SettingsProxy):SaveMainSceneWordFlag(arg0_2.wordFlag)

	local var0_2 = arg0_2.wordFlag and i18n("game_openwords") or i18n("game_stopwords")

	pg.TipsMgr.GetInstance():ShowTips(var0_2)
	arg0_2:emit(NewMainScene.CHAT_STATE_CHANGE, arg0_2.wordFlag)
	arg0_2:UpdateWordBtn(arg0_2.wordFlag)
end

function var0_0.Flush(arg0_3, arg1_3)
	arg0_3:UpdateWordBtn(arg0_3.wordFlag)
end

function var0_0.UpdateWordBtn(arg0_4, arg1_4)
	local var0_4 = arg1_4 and 1 or 0

	arg0_4.wordOpen.alpha = 1 - var0_4
	arg0_4.wordClose.alpha = var0_4
end

return var0_0
