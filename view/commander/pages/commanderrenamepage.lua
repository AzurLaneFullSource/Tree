local var0_0 = class("CommanderRenamePage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "CommandeRenameUI"
end

function var0_0.OnInit(arg0_2)
	onButton(arg0_2, arg0_2._tf:Find("frame/close_btn"), function()
		arg0_2:Hide()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2._tf, function()
		arg0_2:Hide()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2._tf:Find("frame/cancel_btn"), function()
		arg0_2:Hide()
	end, SFX_PANEL)

	arg0_2.input = findTF(arg0_2._tf, "frame/bg/content/input")
	arg0_2.confirmBtn = arg0_2._tf:Find("frame/confirm_btn")

	setText(arg0_2:findTF("frame/bg/content/label"), i18n("commander_rename_tip"))
end

function var0_0.Show(arg0_6, arg1_6)
	arg0_6.isShowMsgBox = true

	setActive(arg0_6._tf, true)
	arg0_6._tf:SetAsLastSibling()
	setInputText(arg0_6.input, "")
	onButton(arg0_6, arg0_6.confirmBtn, function()
		local var0_7 = getInputText(arg0_6.input)

		if not var0_7 or var0_7 == "" then
			return
		end

		arg0_6:emit(CommanderCatMediator.RENAME, arg1_6.id, var0_7)
		arg0_6:Hide()
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():BlurPanel(arg0_6._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.Hide(arg0_8)
	arg0_8.isShowMsgBox = nil

	setActive(arg0_8._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_8._tf, arg0_8._parentTf)
end

function var0_0.OnDestroy(arg0_9)
	if arg0_9.isShowMsgBox then
		arg0_9:Hide()
	end
end

return var0_0
