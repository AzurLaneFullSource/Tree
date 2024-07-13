local var0_0 = class("CourtYardRenamePage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CourtYardRenameUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.confirmBtn = arg0_2:findTF("frame/confirm")
	arg0_2.cancelBtn = arg0_2:findTF("frame/cancel")
	arg0_2.closeBtn = arg0_2:findTF("frame/close")
	arg0_2.input = arg0_2:findTF("frame/input")

	setText(arg0_2:findTF("frame/cancel/Text"), i18n("word_cancel"))
	setText(arg0_2:findTF("frame/confirm/Text"), i18n("word_ok"))
	setText(arg0_2:findTF("frame/title"), i18n("backyard_rename_title"))
	setText(arg0_2:findTF("frame/input/placehoder"), i18n("backyard_rename_tip"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		local var0_4 = getInputText(arg0_3.input)

		if not var0_4 or var0_4 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_should_input"))

			return
		end

		if not nameValidityCheck(var0_4, 0, 20, {
			"spece_illegal_tip",
			"login_newPlayerScene_name_tooShort",
			"login_newPlayerScene_name_tooLong",
			"playerinfo_mask_word"
		}) then
			return
		end

		arg0_3:emit(CourtYardMediator.RENAME, var0_4)
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Flush(arg0_8)
	arg0_8:Show()
end

function var0_0.OnDestroy(arg0_9)
	arg0_9:Hide()
end

return var0_0
