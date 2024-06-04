local var0 = class("MainWordBtn", import(".MainBaseBtn"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)

	arg0.wordOpen = findTF(arg1, "open"):GetComponent(typeof(CanvasGroup))
	arg0.wordClose = findTF(arg1, "close"):GetComponent(typeof(CanvasGroup))
	arg0.wordFlag = getProxy(SettingsProxy):ShouldShipMainSceneWord()
end

function var0.OnClick(arg0)
	arg0.wordFlag = not arg0.wordFlag

	getProxy(SettingsProxy):SaveMainSceneWordFlag(arg0.wordFlag)

	local var0 = arg0.wordFlag and i18n("game_openwords") or i18n("game_stopwords")

	pg.TipsMgr.GetInstance():ShowTips(var0)
	arg0:emit(NewMainScene.CHAT_STATE_CHANGE, arg0.wordFlag)
	arg0:UpdateWordBtn(arg0.wordFlag)
end

function var0.Flush(arg0, arg1)
	arg0:UpdateWordBtn(arg0.wordFlag)
end

function var0.UpdateWordBtn(arg0, arg1)
	local var0 = arg1 and 1 or 0

	arg0.wordOpen.alpha = 1 - var0
	arg0.wordClose.alpha = var0
end

return var0
