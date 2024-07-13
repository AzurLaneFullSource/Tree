local var0_0 = class("ArchivesWorldBossAutoBattleMsgbox", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "ArchivesWorldBossAutoBattleMsgUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.contentTxt = arg0_2:findTF("window/msg_panel/content/time"):GetComponent(typeof(Text))
	arg0_2.startBtn = arg0_2:findTF("window/btns/start")
	arg0_2.startTxt = arg0_2.startBtn:Find("pic"):GetComponent(typeof(Text))
	arg0_2.cancelBtn = arg0_2:findTF("window/btns/cancel")
	arg0_2.cancelTxt = arg0_2.cancelBtn:Find("pic"):GetComponent(typeof(Text))
	arg0_2.closeBtn = arg0_2:findTF("window/top/close")
	arg0_2.titleTxt = arg0_2:findTF("window/top/title"):GetComponent(typeof(Text))

	setText(arg0_2:findTF("window/msg_panel/content/label"), i18n("world_boss_archives_stop_auto_battle_tip"))
	setText(arg0_2:findTF("window/msg_panel/label1"), i18n("world_boss_archives_stop_auto_battle_tip1"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.cancelBtn, function()
		if arg0_3.OnNo then
			arg0_3.OnNo()
		end

		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.startBtn, function()
		if arg0_3.OnYes then
			arg0_3.OnYes()
		end

		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_8, arg1_8)
	var0_0.super.Show(arg0_8)
	arg0_8:RemoveTimer()

	if arg1_8.onContent then
		arg0_8:AddTimer(arg1_8)
	else
		arg0_8.contentTxt.text = arg1_8.content
	end

	arg0_8.titleTxt.text = arg1_8.title
	arg0_8.OnYes = arg1_8.onYes
	arg0_8.OnNo = arg1_8.onNo

	setActive(arg0_8.cancelBtn, not arg1_8.noNo)

	local var0_8 = arg1_8.yesText or i18n("word_ok")

	arg0_8.startTxt.text = var0_8

	local var1_8 = arg1_8.noText or i18n("word_cancel")

	arg0_8.cancelTxt.text = var1_8
end

function var0_0.AddTimer(arg0_9, arg1_9)
	arg0_9.timer = Timer.New(function()
		local var0_10 = arg1_9.onContent()

		if var0_10 == nil then
			arg0_9:Hide()
		end

		arg0_9.contentTxt.text = var0_10
	end, 1, -1)

	arg0_9.timer:Start()
	arg0_9.timer.func()
end

function var0_0.RemoveTimer(arg0_11)
	if arg0_11.timer then
		arg0_11.timer:Stop()

		arg0_11.timer = nil
	end
end

function var0_0.Hide(arg0_12)
	var0_0.super.Hide(arg0_12)
	arg0_12:RemoveTimer()

	arg0_12.OnYes = nil
	arg0_12.OnNo = nil
end

function var0_0.OnDestroy(arg0_13)
	if arg0_13:isShowing() then
		arg0_13:Hide()
	end
end

return var0_0
