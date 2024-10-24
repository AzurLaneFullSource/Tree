local var0_0 = class("InstagramMainUI", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "InstagramMainUI"
end

function var0_0.init(arg0_2)
	arg0_2.bg = arg0_2:findTF("bg")
	arg0_2.helpBtn = arg0_2:findTF("mainPanel/helpBtn")
	arg0_2.chatBtn = arg0_2:findTF("mainPanel/left/chatBtn")
	arg0_2.juusBtn = arg0_2:findTF("mainPanel/left/juusBtn")

	arg0_2:ChangeChatTip()
	arg0_2:ChangeJuusTip()
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, false, {
		groupName = "Instagram",
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.didEnter(arg0_3)
	arg0_3:SetUp()
	triggerButton(arg0_3.chatBtn)
end

function var0_0.SetUp(arg0_4)
	onButton(arg0_4, arg0_4.bg, function()
		arg0_4:OnClose()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.music_juus.tip
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.chatBtn, function()
		if isActive(arg0_4:findTF("choose", arg0_4.juusBtn)) then
			arg0_4:emit(InstagramMainMediator.CLOSE_JUUS_DETAIL)
		end

		SetActive(arg0_4:findTF("choose", arg0_4.chatBtn), true)
		SetActive(arg0_4:findTF("choose", arg0_4.juusBtn), false)
		arg0_4:emit(InstagramMainMediator.OPEN_CHAT)
		arg0_4:emit(InstagramMainMediator.CLOSE_JUUS)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.juusBtn, function()
		SetActive(arg0_4:findTF("choose", arg0_4.chatBtn), false)
		SetActive(arg0_4:findTF("choose", arg0_4.juusBtn), true)
		arg0_4:emit(InstagramMainMediator.OPEN_JUUS)
		arg0_4:emit(InstagramMainMediator.CLOSE_CHAT)
	end, SFX_PANEL)
end

function var0_0.OnClose(arg0_9)
	if isActive(arg0_9:findTF("choose", arg0_9.juusBtn)) then
		arg0_9:emit(InstagramMainMediator.JUUS_BACK_PRESSED)
	else
		arg0_9:closeView()
	end
end

function var0_0.ChangeJuusTip(arg0_10)
	local var0_10 = getProxy(InstagramProxy)

	SetActive(arg0_10:findTF("tip", arg0_10.juusBtn), var0_10:ShouldShowTip())
end

function var0_0.ChangeChatTip(arg0_11)
	local var0_11 = getProxy(InstagramChatProxy)

	SetActive(arg0_11:findTF("tip", arg0_11.chatBtn), var0_11:ShouldShowTip())
end

return var0_0
