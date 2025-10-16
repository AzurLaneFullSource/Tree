local var0_0 = class("InstagramMainUI", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "InstagramMainUI"
end

function var0_0.init(arg0_2)
	arg0_2.bg = arg0_2._tf:Find("bg")
	arg0_2.helpBtn = arg0_2._tf:Find("mainPanel/helpBtn")
	arg0_2.chatBtn = arg0_2._tf:Find("mainPanel/left/chatBtn")
	arg0_2.juusBtn = arg0_2._tf:Find("mainPanel/left/juusBtn")
	arg0_2.musicPlayerView = MainMusicPlayerView.New(arg0_2._tf, arg0_2.event)

	arg0_2.musicPlayerView:Load(arg0_2._tf:Find("MusicPlayer").gameObject)
	arg0_2.musicPlayerView:ActionInvoke("Hide")
	arg0_2:ChangeChatTip()
	arg0_2:ChangeJuusTip()
	arg0_2:BlurPanel(arg0_2._tf)
end

function var0_0.didEnter(arg0_3)
	arg0_3:SetUp()
	arg0_3:FlushMusicPlayer()

	if arg0_3.contextData.current then
		SetActive(arg0_3.chatBtn:Find("choose"), arg0_3.contextData.current == "chat")
		SetActive(arg0_3.juusBtn:Find("choose"), arg0_3.contextData.current == "juus")
	else
		triggerButton(arg0_3.chatBtn)
	end
end

function var0_0.FlushMusicPlayer(arg0_4)
	local var0_4 = pg.BgmMgr.GetInstance():GetNow() == "MainMusicPlayer"

	if tobool(arg0_4.musicPlayerView:isShowing()) ~= var0_4 then
		if var0_4 then
			arg0_4.musicPlayerView:ExecuteAction("Show", false)
		else
			arg0_4.musicPlayerView:ExecuteAction("Hide")
		end
	end
end

function var0_0.SetUp(arg0_5)
	onButton(arg0_5, arg0_5.bg, function()
		arg0_5:OnClose()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.music_juus.tip
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.chatBtn, function()
		arg0_5.contextData.current = "chat"

		if isActive(arg0_5.juusBtn:Find("choose")) then
			arg0_5:emit(InstagramMainMediator.CLOSE_JUUS_DETAIL)
		end

		SetActive(arg0_5.chatBtn:Find("choose"), arg0_5.contextData.current == "chat")
		SetActive(arg0_5.juusBtn:Find("choose"), arg0_5.contextData.current == "juus")
		arg0_5:emit(InstagramMainMediator.OPEN_CHAT)
		arg0_5:emit(InstagramMainMediator.CLOSE_JUUS)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.juusBtn, function()
		arg0_5.contextData.current = "juus"

		SetActive(arg0_5.chatBtn:Find("choose"), arg0_5.contextData.current == "chat")
		SetActive(arg0_5.juusBtn:Find("choose"), arg0_5.contextData.current == "juus")
		arg0_5:emit(InstagramMainMediator.OPEN_JUUS)
		arg0_5:emit(InstagramMainMediator.CLOSE_CHAT)
	end, SFX_PANEL)
end

function var0_0.OnClose(arg0_10)
	if isActive(arg0_10.juusBtn:Find("choose")) then
		arg0_10:emit(InstagramMainMediator.JUUS_BACK_PRESSED)
	else
		arg0_10:closeView()
	end
end

function var0_0.ChangeJuusTip(arg0_11)
	local var0_11 = getProxy(InstagramProxy)

	SetActive(arg0_11.juusBtn:Find("tip"), var0_11:ShouldShowTip())
end

function var0_0.ChangeChatTip(arg0_12)
	local var0_12 = getProxy(InstagramChatProxy)

	SetActive(arg0_12.chatBtn:Find("tip"), var0_12:ShouldShowTip())
end

function var0_0.willExit(arg0_13)
	arg0_13.musicPlayerView:Destroy()
end

return var0_0
