local var0_0 = class("InstagramMainUI", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "InstagramMainUI"
end

function var0_0.preload(arg0_2, arg1_2)
	pg.m02:sendNotification(GAME.REQ_OLD_INSTAGRAM_DATA, {
		callback = function()
			arg1_2()
		end
	})
end

function var0_0.init(arg0_4)
	arg0_4.bg = arg0_4._tf:Find("bg")
	arg0_4.helpBtn = arg0_4._tf:Find("mainPanel/helpBtn")
	arg0_4.chatBtn = arg0_4._tf:Find("mainPanel/left/chatBtn")
	arg0_4.juusBtn = arg0_4._tf:Find("mainPanel/left/juusBtn")
	arg0_4.musicPlayerView = MainMusicPlayerView.New(arg0_4._tf, arg0_4.event)

	arg0_4.musicPlayerView:Load(arg0_4._tf:Find("MusicPlayer").gameObject)
	arg0_4.musicPlayerView:ActionInvoke("Hide")
	arg0_4:ChangeChatTip()
	arg0_4:ChangeJuusTip()
	arg0_4:BlurPanel(arg0_4._tf)
end

function var0_0.didEnter(arg0_5)
	arg0_5:SetUp()
	arg0_5:FlushMusicPlayer()

	if arg0_5.contextData.current then
		SetActive(arg0_5.chatBtn:Find("choose"), arg0_5.contextData.current == "chat")
		SetActive(arg0_5.juusBtn:Find("choose"), arg0_5.contextData.current == "juus")
	else
		triggerButton(arg0_5.chatBtn)
	end
end

function var0_0.FlushMusicPlayer(arg0_6)
	local var0_6 = pg.BgmMgr.GetInstance():GetNow() == "MainMusicPlayer"

	if tobool(arg0_6.musicPlayerView:isShowing()) ~= var0_6 then
		if var0_6 then
			arg0_6.musicPlayerView:ExecuteAction("Show", false)
		else
			arg0_6.musicPlayerView:ExecuteAction("Hide")
		end
	end
end

function var0_0.SetUp(arg0_7)
	onButton(arg0_7, arg0_7.bg, function()
		arg0_7:OnClose()
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.music_juus.tip
		})
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.chatBtn, function()
		arg0_7.contextData.current = "chat"

		if isActive(arg0_7.juusBtn:Find("choose")) then
			arg0_7:emit(InstagramMainMediator.CLOSE_JUUS_DETAIL)
		end

		SetActive(arg0_7.chatBtn:Find("choose"), arg0_7.contextData.current == "chat")
		SetActive(arg0_7.juusBtn:Find("choose"), arg0_7.contextData.current == "juus")
		arg0_7:emit(InstagramMainMediator.OPEN_CHAT)
		arg0_7:emit(InstagramMainMediator.CLOSE_JUUS)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.juusBtn, function()
		arg0_7.contextData.current = "juus"

		SetActive(arg0_7.chatBtn:Find("choose"), arg0_7.contextData.current == "chat")
		SetActive(arg0_7.juusBtn:Find("choose"), arg0_7.contextData.current == "juus")
		arg0_7:emit(InstagramMainMediator.OPEN_JUUS)
		arg0_7:emit(InstagramMainMediator.CLOSE_CHAT)
	end, SFX_PANEL)
end

function var0_0.OnClose(arg0_12)
	if isActive(arg0_12.juusBtn:Find("choose")) then
		arg0_12:emit(InstagramMainMediator.INS_BACK_PRESSED)
	else
		arg0_12:emit(InstagramMainMediator.JUUS_BACK_PRESSED)
	end
end

function var0_0.ChangeJuusTip(arg0_13)
	local var0_13 = getProxy(InstagramProxy)

	SetActive(arg0_13.juusBtn:Find("tip"), var0_13:ShouldShowTip())
end

function var0_0.ChangeChatTip(arg0_14)
	local var0_14 = getProxy(InstagramChatProxy)

	SetActive(arg0_14.chatBtn:Find("tip"), var0_14:ShouldShowTip() and getProxy(InstagramProxy):ShouldShowOfficialAccountsTip())
end

function var0_0.willExit(arg0_15)
	arg0_15.musicPlayerView:Destroy()
end

return var0_0
