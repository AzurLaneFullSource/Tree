local var0_0 = class("ArchivesWorldBossMsgboxPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ArchivesWorldBossMsgboxUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.yesBtn = arg0_2:findTF("Box/ConfirmBtn")
	arg0_2.cancelBtn = arg0_2:findTF("Box/CancelBtn")
	arg0_2.contentTxt = arg0_2:findTF("Box/Text"):GetComponent(typeof(Text))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.yesBtn, function()
		if arg0_3.onYes then
			arg0_3.onYes()
		end

		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7, arg1_7)
	var0_0.super.Show(arg0_7)

	arg0_7.contentTxt.text = arg1_7.content
	arg0_7.onYes = arg1_7.onYes
end

function var0_0.Hide(arg0_8)
	var0_0.super.Hide(arg0_8)

	if arg0_8.onYes then
		arg0_8.onYes = nil
	end
end

function var0_0.OnDestroy(arg0_9)
	if arg0_9:isShowing() then
		arg0_9:Hide()
	end
end

return var0_0
