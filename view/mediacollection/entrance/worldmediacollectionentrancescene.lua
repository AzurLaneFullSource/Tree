local var0_0 = class("WorldMediaCollectionEntranceScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "WorldMediaCollectionEntranceUI"
end

function var0_0.init(arg0_2)
	arg0_2.recallBtn = arg0_2:findTF("Main/recall")
	arg0_2.cryptolaliaBtn = arg0_2:findTF("Main/cryptolalia")
	arg0_2.archiveBtn = arg0_2:findTF("Main/archive")
	arg0_2.recordBtn = arg0_2:findTF("Main/record")
	arg0_2.albumBtn = arg0_2:findTF("Main/album")

	setActive(arg0_2.albumBtn, not LOCK_ALBUM)

	local var0_2 = arg0_2._tf:Find("Main/empty")

	SetCompomentEnabled(var0_2, "Image", LOCK_ALBUM)
	setActive(var0_2:Find("Image"), not LOCK_ALBUM)
	setActive(var0_2:Find("Image1"), LOCK_ALBUM)

	arg0_2.optionBtn = arg0_2:findTF("Top/blur_panel/adapt/top/option")
	arg0_2.backBtn = arg0_2:findTF("Top/blur_panel/adapt/top/back_btn")

	setText(arg0_2:findTF("Main/empty/label"), i18n("cryptolalia_unopen"))
	setText(arg0_2:findTF("Main/empty1/label"), i18n("cryptolalia_unopen"))
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3.optionBtn, function()
		arg0_3:emit(var0_0.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.backBtn, function()
		arg0_3:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.recallBtn, function()
		arg0_3:emit(WorldMediaCollectionEntranceMediator.OPEN_RECALL)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cryptolaliaBtn, function()
		if LOCK_CRYPTOLALIA then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_comingSoon"))
		else
			arg0_3:emit(WorldMediaCollectionEntranceMediator.OPEN_CRYPTOLALIA)
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.archiveBtn, function()
		arg0_3:emit(WorldMediaCollectionEntranceMediator.OPEN_ARCHIVE)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.recordBtn, function()
		arg0_3:emit(WorldMediaCollectionEntranceMediator.OPEN_RECORD)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.albumBtn, function()
		arg0_3:emit(WorldMediaCollectionEntranceMediator.OPEN_ALBUM)
	end, SFX_PANEL)
end

function var0_0.willExit(arg0_11)
	return
end

return var0_0
