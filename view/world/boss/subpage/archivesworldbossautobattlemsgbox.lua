local var0 = class("ArchivesWorldBossAutoBattleMsgbox", import("view.base.BaseSubView"))

function var0.getUIName(arg0)
	return "ArchivesWorldBossAutoBattleMsgUI"
end

function var0.OnLoaded(arg0)
	arg0.contentTxt = arg0:findTF("window/msg_panel/content/time"):GetComponent(typeof(Text))
	arg0.startBtn = arg0:findTF("window/btns/start")
	arg0.startTxt = arg0.startBtn:Find("pic"):GetComponent(typeof(Text))
	arg0.cancelBtn = arg0:findTF("window/btns/cancel")
	arg0.cancelTxt = arg0.cancelBtn:Find("pic"):GetComponent(typeof(Text))
	arg0.closeBtn = arg0:findTF("window/top/close")
	arg0.titleTxt = arg0:findTF("window/top/title"):GetComponent(typeof(Text))

	setText(arg0:findTF("window/msg_panel/content/label"), i18n("world_boss_archives_stop_auto_battle_tip"))
	setText(arg0:findTF("window/msg_panel/label1"), i18n("world_boss_archives_stop_auto_battle_tip1"))
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		if arg0.OnNo then
			arg0.OnNo()
		end

		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.startBtn, function()
		if arg0.OnYes then
			arg0.OnYes()
		end

		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	arg0:RemoveTimer()

	if arg1.onContent then
		arg0:AddTimer(arg1)
	else
		arg0.contentTxt.text = arg1.content
	end

	arg0.titleTxt.text = arg1.title
	arg0.OnYes = arg1.onYes
	arg0.OnNo = arg1.onNo

	setActive(arg0.cancelBtn, not arg1.noNo)

	local var0 = arg1.yesText or i18n("word_ok")

	arg0.startTxt.text = var0

	local var1 = arg1.noText or i18n("word_cancel")

	arg0.cancelTxt.text = var1
end

function var0.AddTimer(arg0, arg1)
	arg0.timer = Timer.New(function()
		local var0 = arg1.onContent()

		if var0 == nil then
			arg0:Hide()
		end

		arg0.contentTxt.text = var0
	end, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	arg0:RemoveTimer()

	arg0.OnYes = nil
	arg0.OnNo = nil
end

function var0.OnDestroy(arg0)
	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
