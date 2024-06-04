local var0 = class("CommanderRenamePage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "CommandeRenameUI"
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf:Find("frame/close_btn"), function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("frame/cancel_btn"), function()
		arg0:Hide()
	end, SFX_PANEL)

	arg0.input = findTF(arg0._tf, "frame/bg/content/input")
	arg0.confirmBtn = arg0._tf:Find("frame/confirm_btn")

	setText(arg0:findTF("frame/bg/content/label"), i18n("commander_rename_tip"))
end

function var0.Show(arg0, arg1)
	arg0.isShowMsgBox = true

	setActive(arg0._tf, true)
	arg0._tf:SetAsLastSibling()
	setInputText(arg0.input, "")
	onButton(arg0, arg0.confirmBtn, function()
		local var0 = getInputText(arg0.input)

		if not var0 or var0 == "" then
			return
		end

		arg0:emit(CommanderCatMediator.RENAME, arg1.id, var0)
		arg0:Hide()
	end, SFX_PANEL)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0.Hide(arg0)
	arg0.isShowMsgBox = nil

	setActive(arg0._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
end

function var0.OnDestroy(arg0)
	if arg0.isShowMsgBox then
		arg0:Hide()
	end
end

return var0
