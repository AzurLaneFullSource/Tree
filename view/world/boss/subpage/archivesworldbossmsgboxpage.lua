local var0 = class("ArchivesWorldBossMsgboxPage", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "ArchivesWorldBossMsgboxUI"
end

function var0.OnLoaded(arg0)
	arg0.yesBtn = arg0:findTF("Box/ConfirmBtn")
	arg0.cancelBtn = arg0:findTF("Box/CancelBtn")
	arg0.contentTxt = arg0:findTF("Box/Text"):GetComponent(typeof(Text))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.yesBtn, function()
		if arg0.onYes then
			arg0.onYes()
		end

		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)

	arg0.contentTxt.text = arg1.content
	arg0.onYes = arg1.onYes
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)

	if arg0.onYes then
		arg0.onYes = nil
	end
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
