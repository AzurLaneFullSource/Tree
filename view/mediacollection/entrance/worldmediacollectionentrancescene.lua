local var0 = class("WorldMediaCollectionEntranceScene", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "WorldMediaCollectionEntranceUI"
end

function var0.init(arg0)
	arg0.recallBtn = arg0:findTF("Main/recall")
	arg0.cryptolaliaBtn = arg0:findTF("Main/cryptolalia")
	arg0.archiveBtn = arg0:findTF("Main/archive")
	arg0.recordBtn = arg0:findTF("Main/record")
	arg0.optionBtn = arg0:findTF("Top/blur_panel/adapt/top/option")
	arg0.backBtn = arg0:findTF("Top/blur_panel/adapt/top/back_btn")

	setText(arg0:findTF("Main/empty/label"), i18n("cryptolalia_unopen"))
	setText(arg0:findTF("Main/empty1/label"), i18n("cryptolalia_unopen"))
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.optionBtn, function()
		arg0:emit(var0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0, arg0.backBtn, function()
		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0, arg0.recallBtn, function()
		arg0:emit(WorldMediaCollectionEntranceMediator.OPEN_RECALL)
	end, SFX_PANEL)
	onButton(arg0, arg0.cryptolaliaBtn, function()
		if LOCK_CRYPTOLALIA then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_comingSoon"))
		else
			arg0:emit(WorldMediaCollectionEntranceMediator.OPEN_CRYPTOLALIA)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.archiveBtn, function()
		arg0:emit(WorldMediaCollectionEntranceMediator.OPEN_ARCHIVE)
	end, SFX_PANEL)
	onButton(arg0, arg0.recordBtn, function()
		arg0:emit(WorldMediaCollectionEntranceMediator.OPEN_RECORD)
	end, SFX_PANEL)
end

function var0.willExit(arg0)
	return
end

return var0
