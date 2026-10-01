local var0_0 = class("InstagramMainUI", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "InstagramMainUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/InstagramChatBackgrounds_atlas"
	}

	for iter0_2, iter1_2 in ipairs(getProxy(InstagramChatProxy):GetChatList()) do
		if iter1_2.type == 1 then
			local var1_2 = "unknown"

			if iter1_2.skinId == 0 then
				var1_2 = iter1_2:GetPainting()
			else
				for iter2_2, iter3_2 in ipairs(iter1_2.skins) do
					if iter3_2.id == iter1_2.skinId then
						var1_2 = iter3_2.painting
					end
				end
			end

			table.insert(var0_2, "painting/" .. var1_2)
			table.insert(var0_2, "paintingface/" .. var1_2)
		end
	end

	table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))

	return var0_2
end

function var0_0.preload(arg0_3, arg1_3)
	pg.m02:sendNotification(GAME.REQ_OLD_INSTAGRAM_DATA, {
		callback = function()
			arg1_3()
		end
	})
end

function var0_0.init(arg0_5)
	arg0_5.bg = arg0_5._tf:Find("bg")
	arg0_5.helpBtn = arg0_5._tf:Find("mainPanel/helpBtn")
	arg0_5.chatBtn = arg0_5._tf:Find("mainPanel/left/chatBtn")
	arg0_5.juusBtn = arg0_5._tf:Find("mainPanel/left/juusBtn")
	arg0_5.musicPlayerView = MainMusicPlayerView.New(arg0_5._tf, arg0_5.event)

	arg0_5.musicPlayerView:Load(arg0_5._tf:Find("MusicPlayer").gameObject)
	arg0_5.musicPlayerView:ActionInvoke("Hide")
	arg0_5:ChangeChatTip()
	arg0_5:ChangeJuusTip()
	arg0_5:BlurPanel(arg0_5._tf)
end

function var0_0.didEnter(arg0_6)
	arg0_6:SetUp()
	arg0_6:FlushMusicPlayer()

	if arg0_6.contextData.current then
		SetActive(arg0_6.chatBtn:Find("choose"), arg0_6.contextData.current == "chat")
		SetActive(arg0_6.juusBtn:Find("choose"), arg0_6.contextData.current == "juus")
	else
		triggerButton(arg0_6.chatBtn)
	end
end

function var0_0.FlushMusicPlayer(arg0_7)
	local var0_7 = pg.BgmMgr.GetInstance():GetNow() == "MainMusicPlayer"

	if tobool(arg0_7.musicPlayerView:isShowing()) ~= var0_7 then
		if var0_7 then
			arg0_7.musicPlayerView:ExecuteAction("Show", false)
		else
			arg0_7.musicPlayerView:ExecuteAction("Hide")
		end
	end
end

function var0_0.SetUp(arg0_8)
	onButton(arg0_8, arg0_8.bg, function()
		arg0_8:OnClose()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.music_juus.tip
		})
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.chatBtn, function()
		arg0_8.contextData.current = "chat"

		if isActive(arg0_8.juusBtn:Find("choose")) then
			arg0_8:emit(InstagramMainMediator.CLOSE_JUUS_DETAIL)
		end

		SetActive(arg0_8.chatBtn:Find("choose"), arg0_8.contextData.current == "chat")
		SetActive(arg0_8.juusBtn:Find("choose"), arg0_8.contextData.current == "juus")
		arg0_8:emit(InstagramMainMediator.OPEN_CHAT)
		arg0_8:emit(InstagramMainMediator.CLOSE_JUUS)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.juusBtn, function()
		arg0_8.contextData.current = "juus"

		SetActive(arg0_8.chatBtn:Find("choose"), arg0_8.contextData.current == "chat")
		SetActive(arg0_8.juusBtn:Find("choose"), arg0_8.contextData.current == "juus")
		arg0_8:emit(InstagramMainMediator.OPEN_JUUS)
		arg0_8:emit(InstagramMainMediator.CLOSE_CHAT)
	end, SFX_PANEL)
end

function var0_0.OnClose(arg0_13)
	if isActive(arg0_13.juusBtn:Find("choose")) then
		arg0_13:emit(InstagramMainMediator.INS_BACK_PRESSED)
	else
		arg0_13:emit(InstagramMainMediator.JUUS_BACK_PRESSED)
	end
end

function var0_0.ChangeJuusTip(arg0_14)
	local var0_14 = getProxy(InstagramProxy)

	SetActive(arg0_14.juusBtn:Find("tip"), var0_14:ShouldShowTip())
end

function var0_0.ChangeChatTip(arg0_15)
	local var0_15 = getProxy(InstagramChatProxy)

	SetActive(arg0_15.chatBtn:Find("tip"), var0_15:ShouldShowTip() and getProxy(InstagramProxy):ShouldShowOfficialAccountsTip())
end

function var0_0.willExit(arg0_16)
	arg0_16.musicPlayerView:Destroy()
end

return var0_0
