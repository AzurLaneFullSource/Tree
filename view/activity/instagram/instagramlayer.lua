local var0_0 = class("InstagramLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "InstagramUI"
end

function var0_0.preload(arg0_2, arg1_2)
	arg0_2:SetProxy(getProxy(InstagramProxy))
	arg1_2()
end

function var0_0.SetProxy(arg0_3, arg1_3)
	arg0_3.proxy = arg1_3
	arg0_3.instagramVOById = arg1_3:GetData()
	arg0_3.messages = arg1_3:GetMessages()
end

function var0_0.UpdateSelectedInstagram(arg0_4, arg1_4)
	if arg0_4.contextData.instagram and arg0_4.contextData.instagram.id == arg1_4 then
		arg0_4.contextData.instagram = arg0_4.instagramVOById[arg1_4]

		arg0_4:UpdateCommentList()
	end
end

function var0_0.init(arg0_5)
	local var0_5 = GameObject.Find("MainObject")

	arg0_5.downloadmgr = BulletinBoardMgr.Inst
	arg0_5.listTF = arg0_5._tf:Find("list")
	arg0_5.mainTF = arg0_5._tf:Find("main")
	arg0_5.closeBtn = arg0_5._tf:Find("closeBtn")
	arg0_5.noMsgTF = arg0_5._tf:Find("list/bg/no_msg")
	arg0_5.scrollBarTF = arg0_5._tf:Find("list/bg/scroll_bar")
	arg0_5.list = arg0_5._tf:Find("list/bg/scrollrect"):GetComponent("LScrollRect")
	arg0_5.imageTF = arg0_5._tf:Find("main/left_panel/mask/Image"):GetComponent(typeof(RawImage))
	arg0_5.likeBtn = arg0_5._tf:Find("main/left_panel/heart")
	arg0_5.bubbleTF = arg0_5._tf:Find("main/left_panel/bubble")
	arg0_5.planeTF = arg0_5._tf:Find("main/left_panel/plane")
	arg0_5.likeCntTxt = arg0_5._tf:Find("main/left_panel/zan"):GetComponent(typeof(Text))
	arg0_5.pushTimeTxt = arg0_5._tf:Find("main/left_panel/time"):GetComponent(typeof(Text))
	arg0_5.iconTF = arg0_5._tf:Find("main/right_panel/top/head/icon")
	arg0_5.nameTxt = arg0_5._tf:Find("main/right_panel/top/name"):GetComponent(typeof(Text))
	arg0_5.centerTF = arg0_5._tf:Find("main/right_panel/center")
	arg0_5.contentTxt = arg0_5._tf:Find("main/right_panel/center/Text/Text"):GetComponent(typeof(Text))
	arg0_5.commentList = UIItemList.New(arg0_5._tf:Find("main/right_panel/center/bottom/scroll/content"), arg0_5._tf:Find("main/right_panel/center/bottom/scroll/content/tpl"))
	arg0_5.commentPanel = arg0_5._tf:Find("main/right_panel/last/bg2")
	arg0_5.optionalPanel = arg0_5._tf:Find("main/right_panel/last/bg2/option")
	arg0_5.scroll = arg0_5._tf:Find("main/right_panel/center/bottom/scroll")

	setText(arg0_5._tf:Find("closeBtn/Text"), i18n("word_back"))

	arg0_5.sprites = {}
	arg0_5.timers = {}
	arg0_5.toDownloadList = {}

	arg0_5:OverlayPanel(arg0_5._tf)
end

function var0_0.SetImageByUrl(arg0_6, arg1_6, arg2_6, arg3_6)
	if not arg1_6 or arg1_6 == "" then
		setActive(arg2_6.gameObject, false)

		if arg3_6 then
			arg3_6()
		end
	else
		setActive(arg2_6.gameObject, true)

		local var0_6 = arg0_6.sprites[arg1_6]

		if var0_6 then
			arg2_6.texture = var0_6

			if arg3_6 then
				arg3_6()
			end
		else
			arg2_6.enabled = false

			arg0_6.downloadmgr:GetTexture("ins", "1", arg1_6, UnityEngine.Events.UnityAction_UnityEngine_Texture(function(arg0_7)
				if arg0_6.exited then
					return
				end

				if not arg0_6.sprites then
					return
				end

				arg0_6.sprites[arg1_6] = arg0_7
				arg2_6.texture = arg0_7
				arg2_6.enabled = true

				if arg3_6 then
					arg3_6()
				end
			end))
			table.insert(arg0_6.toDownloadList, arg1_6)
		end
	end
end

function var0_0.didEnter(arg0_8)
	arg0_8:SetUp()

	arg0_8.cards = {}

	function arg0_8.list.onInitItem(arg0_9)
		local var0_9 = InstagramCard.New(arg0_9, arg0_8)

		onButton(arg0_8, var0_9._go, function()
			arg0_8:EnterDetail(var0_9.instagram)
		end, SFX_PANEL)

		arg0_8.cards[arg0_9] = var0_9
	end

	function arg0_8.list.onUpdateItem(arg0_11, arg1_11)
		local var0_11 = arg0_8.cards[arg1_11]

		if not var0_11 then
			var0_11 = InstagramCard.New(arg1_11)
			arg0_8.cards[arg1_11] = var0_11
		end

		local var1_11 = arg0_8.display[arg0_11 + 1]
		local var2_11 = arg0_8.instagramVOById[var1_11.id]

		var0_11:Update(var2_11)
	end

	arg0_8:InitList()
end

function var0_0.SetUp(arg0_12)
	setActive(arg0_12.listTF, true)
	setActive(arg0_12.mainTF, false)
	setActive(arg0_12.closeBtn, false)
	onButton(arg0_12, arg0_12.closeBtn, function()
		if arg0_12.inDetail then
			arg0_12:ExitDetail()
		end
	end, SFX_PANEL)
end

function var0_0.InitList(arg0_14)
	arg0_14.display = _.map(arg0_14.messages, function(arg0_15)
		return {
			time = arg0_15:GetLasterUpdateTime(),
			id = arg0_15.id,
			order = arg0_15:GetSortIndex()
		}
	end)

	table.sort(arg0_14.display, function(arg0_16, arg1_16)
		if arg0_16.order == arg1_16.order then
			return arg0_16.id > arg1_16.id
		else
			return arg0_16.order > arg1_16.order
		end
	end)

	if isActive(arg0_14.listTF) then
		arg0_14.list:SetTotalCount(#arg0_14.display)
	end

	setActive(arg0_14.noMsgTF, #arg0_14.display == 0)
	setActive(arg0_14.scrollBarTF, not #arg0_14.display == 0)
end

function var0_0.UpdateInstagram(arg0_17, arg1_17, arg2_17)
	for iter0_17, iter1_17 in pairs(arg0_17.cards) do
		if iter1_17.instagram and iter1_17.instagram.id == arg1_17 then
			iter1_17:Update(arg0_17.instagramVOById[arg1_17], arg2_17)
		end
	end
end

function var0_0.EnterDetail(arg0_18, arg1_18)
	arg0_18.contextData.instagram = arg1_18

	arg0_18:InitDetailPage()

	arg0_18.inDetail = true

	setActive(arg0_18.listTF, false)
	setActive(arg0_18.mainTF, true)
	setActive(arg0_18.closeBtn, true)
	pg.SystemGuideMgr.GetInstance():Play(arg0_18)
	arg0_18:RefreshInstagram()
	scrollTo(arg0_18.scroll, 0, 1)
end

function var0_0.ExitDetail(arg0_19)
	local var0_19 = arg0_19.contextData.instagram

	if var0_19 and not var0_19:IsReaded() then
		arg0_19:emit(InstagramMediator.ON_READED, var0_19.id)
	end

	arg0_19.contextData.instagram = nil
	arg0_19.inDetail = false

	setActive(arg0_19.listTF, true)
	setActive(arg0_19.mainTF, false)
	setActive(arg0_19.closeBtn, false)
	arg0_19:CloseCommentPanel()
end

function var0_0.RefreshInstagram(arg0_20)
	local var0_20 = arg0_20.contextData.instagram
	local var1_20 = var0_20:GetFastestRefreshTime()

	if var1_20 and var1_20 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
		arg0_20:emit(InstagramMediator.ON_REPLY_UPDATE, var0_20.id)
	end
end

function var0_0.InitDetailPage(arg0_21)
	local var0_21 = arg0_21.contextData.instagram

	arg0_21:SetImageByUrl(var0_21:GetImage(), arg0_21.imageTF)
	onButton(arg0_21, arg0_21.planeTF, function()
		arg0_21:emit(InstagramMediator.ON_SHARE, var0_21.id)
	end, SFX_PANEL)

	arg0_21.pushTimeTxt.text = var0_21:GetPushTime()

	setImageSprite(arg0_21.iconTF, LoadSprite("qicon/" .. var0_21:GetIcon()), false)

	arg0_21.nameTxt.text = var0_21:GetName()
	arg0_21.contentTxt.text = var0_21:GetContent()

	onToggle(arg0_21, arg0_21.commentPanel, function(arg0_23)
		if arg0_23 then
			arg0_21:OpenCommentPanel()
		else
			arg0_21:CloseCommentPanel()
		end
	end, SFX_PANEL)
	arg0_21:UpdateLikeBtn()
	arg0_21:UpdateCommentList()
end

function var0_0.UpdateLikeBtn(arg0_24)
	local var0_24 = arg0_24.contextData.instagram
	local var1_24 = var0_24:IsLiking()

	if not var1_24 then
		onButton(arg0_24, arg0_24.likeBtn, function()
			arg0_24:emit(InstagramMediator.ON_LIKE, var0_24.id)
		end, SFX_PANEL)
	else
		removeOnButton(arg0_24.likeBtn)
	end

	setActive(arg0_24.likeBtn:Find("heart"), var1_24)

	arg0_24.likeBtn:GetComponent(typeof(Image)).enabled = not var1_24
	arg0_24.likeCntTxt.text = i18n("ins_word_like", var0_24:GetLikeCnt())
end

function var0_0.UpdateCommentList(arg0_26)
	local var0_26 = arg0_26.contextData.instagram

	if not var0_26 then
		return
	end

	local var1_26, var2_26 = var0_26:GetCanDisplayComments()

	table.sort(var1_26, function(arg0_27, arg1_27)
		return arg0_27.time < arg1_27.time
	end)
	arg0_26.commentList:make(function(arg0_28, arg1_28, arg2_28)
		if arg0_28 == UIItemList.EventUpdate then
			local var0_28 = var1_26[arg1_28 + 1]
			local var1_28 = var0_28:HasReply()

			setText(arg2_28:Find("main/reply"), var0_28:GetReplyBtnTxt())

			local var2_28 = var0_28:GetContent()
			local var3_28 = SwitchSpecialChar(var2_28)

			setText(arg2_28:Find("main/content"), HXSet.hxLan(var3_28))
			setText(arg2_28:Find("main/bubble/Text"), var0_28:GetReplyCnt())
			setText(arg2_28:Find("main/time"), var0_28:GetTime())

			if var0_28:GetType() == Instagram.TYPE_PLAYER_COMMENT then
				local var4_28, var5_28 = var0_28:GetIcon()

				setImageSprite(arg2_28:Find("main/head/icon"), GetSpriteFromAtlas(var4_28, var5_28))
			else
				setImageSprite(arg2_28:Find("main/head/icon"), LoadSprite("qicon/" .. var0_28:GetIcon()), false)
			end

			if var1_28 then
				onToggle(arg0_26, arg2_28:Find("main/bubble"), function(arg0_29)
					setActive(arg2_28:Find("replys"), arg0_29)
				end, SFX_PANEL)
				arg0_26:UpdateReplys(arg2_28, var0_28)
				triggerToggle(arg2_28:Find("main/bubble"), true)
			else
				setActive(arg2_28:Find("replys"), false)
				triggerToggle(arg2_28:Find("main/bubble"), false)
			end

			arg2_28:Find("main/bubble"):GetComponent(typeof(Toggle)).enabled = var1_28
		end
	end)
	setActive(arg0_26.centerTF, false)
	setActive(arg0_26.centerTF, true)
	Canvas.ForceUpdateCanvases()
	arg0_26.commentList:align(#var1_26)
end

function var0_0.UpdateReplys(arg0_30, arg1_30, arg2_30)
	local var0_30, var1_30 = arg2_30:GetCanDisplayReply()
	local var2_30 = UIItemList.New(arg1_30:Find("replys"), arg1_30:Find("replys/sub"))

	table.sort(var0_30, function(arg0_31, arg1_31)
		if arg0_31.level == arg1_31.level then
			if arg0_31.time == arg1_31.time then
				return arg0_31.id < arg1_31.id
			else
				return arg0_31.time < arg1_31.time
			end
		else
			return arg0_31.level < arg1_31.level
		end
	end)
	var2_30:make(function(arg0_32, arg1_32, arg2_32)
		if arg0_32 == UIItemList.EventUpdate then
			local var0_32 = var0_30[arg1_32 + 1]

			setImageSprite(arg2_32:Find("head/icon"), LoadSprite("qicon/" .. var0_32:GetIcon()), false)

			local var1_32 = var0_32:GetContent()
			local var2_32 = SwitchSpecialChar(var1_32)

			setText(arg2_32:Find("content"), HXSet.hxLan(var2_32))
		end
	end)
	var2_30:align(#var0_30)
end

function var0_0.OpenCommentPanel(arg0_33)
	local var0_33 = arg0_33.contextData.instagram

	if not var0_33:CanOpenComment() then
		return
	end

	setActive(arg0_33.optionalPanel, true)

	local var1_33 = var0_33:GetOptionComment()

	arg0_33.commentPanel:GetComponent(typeof(Image)).enabled = true
	arg0_33.commentPanel.sizeDelta = Vector2(0, #var1_33 * 142 + 60)

	local var2_33 = UIItemList.New(arg0_33.optionalPanel, arg0_33.optionalPanel:Find("option1"))

	var2_33:make(function(arg0_34, arg1_34, arg2_34)
		if arg0_34 == UIItemList.EventUpdate then
			local var0_34 = arg1_34 + 1
			local var1_34 = var1_33[var0_34].text
			local var2_34 = var1_33[var0_34].id
			local var3_34 = var1_33[var0_34].index

			setText(arg2_34:Find("Text"), HXSet.hxLan(var1_34))
			onButton(arg0_33, arg2_34, function()
				arg0_33:emit(InstagramMediator.ON_COMMENT, var0_33.id, var3_34, var2_34)
				arg0_33:CloseCommentPanel()
			end, SFX_PANEL)
		end
	end)
	var2_33:align(#var1_33)
end

function var0_0.CloseCommentPanel(arg0_36)
	arg0_36.commentPanel:GetComponent(typeof(Image)).enabled = false
	arg0_36.commentPanel.sizeDelta = Vector2(0, 0)

	setActive(arg0_36.optionalPanel, false)
end

function var0_0.onBackPressed(arg0_37)
	if arg0_37.inDetail then
		arg0_37:ExitDetail()

		return
	end

	arg0_37:emit(InstagramMediator.CLOSE_ALL)
end

function var0_0.CloseDetail(arg0_38)
	if arg0_38.inDetail then
		arg0_38:ExitDetail()

		return
	end
end

function var0_0.willExit(arg0_39)
	for iter0_39, iter1_39 in ipairs(arg0_39.toDownloadList or {}) do
		arg0_39.downloadmgr:StopLoader(iter1_39)
	end

	arg0_39.toDownloadList = {}

	arg0_39:UnOverlayPanel(arg0_39._tf)
	arg0_39:ExitDetail()

	for iter2_39, iter3_39 in pairs(arg0_39.sprites) do
		if not IsNil(iter3_39) then
			Object.Destroy(iter3_39)
		end
	end

	arg0_39.sprites = nil

	for iter4_39, iter5_39 in pairs(arg0_39.cards) do
		iter5_39:Dispose()
	end

	arg0_39.cards = {}
end

return var0_0
