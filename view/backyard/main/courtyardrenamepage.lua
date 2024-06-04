local var0 = class("CourtYardRenamePage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "CourtYardRenameUI"
end

function var0.OnLoaded(arg0)
	arg0.confirmBtn = arg0:findTF("frame/confirm")
	arg0.cancelBtn = arg0:findTF("frame/cancel")
	arg0.closeBtn = arg0:findTF("frame/close")
	arg0.input = arg0:findTF("frame/input")

	setText(arg0:findTF("frame/cancel/Text"), i18n("word_cancel"))
	setText(arg0:findTF("frame/confirm/Text"), i18n("word_ok"))
	setText(arg0:findTF("frame/title"), i18n("backyard_rename_title"))
	setText(arg0:findTF("frame/input/placehoder"), i18n("backyard_rename_tip"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.confirmBtn, function()
		local var0 = getInputText(arg0.input)

		if not var0 or var0 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_should_input"))

			return
		end

		if not nameValidityCheck(var0, 0, 20, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"playerinfo_mask_word"
		}) then
			return
		end

		arg0:emit(CourtYardMediator.RENAME, var0)
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Flush(arg0)
	arg0:Show()
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0
