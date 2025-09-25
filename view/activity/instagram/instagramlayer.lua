local var0_0 = class("InstagramLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "InstagramUI"
end

function var0_0.getGroupName(arg0_2)
	return "InstagramMainUI"
end

function var0_0.preload(arg0_3, arg1_3)
	pg.m02:sendNotification(GAME.REQ_OLD_INSTAGRAM_DATA, {
		callback = function()
			arg0_3:SetProxy(getProxy(InstagramProxy))
			arg1_3()
		end
	})
end

function var0_0.SetProxy(arg0_5, arg1_5)
	arg0_5.proxy = arg1_5
	arg0_5.instagramVOById = arg1_5:GetData()
	arg0_5.messages = arg1_5:GetMessages()
end

function var0_0.UpdateSelectedInstagram(arg0_6, arg1_6)
	if arg0_6.contextData.instagram and arg0_6.contextData.instagram.id == arg1_6 then
		arg0_6.contextData.instagram = arg0_6.instagramVOById[arg1_6]

		arg0_6:UpdateCommentList()
	end
end

function var0_0.init(arg0_7)
	local var0_7 = GameObject.Find("MainObject")

	arg0_7.downloadmgr = BulletinBoardMgr.Inst
	arg0_7.listTF = arg0_7:findTF("list")
	arg0_7.mainTF = arg0_7:findTF("main")
	arg0_7.closeBtn = arg0_7:findTF("closeBtn")
	arg0_7.noMsgTF = arg0_7:findTF("list/bg/no_msg")
	arg0_7.scrollBarTF = arg0_7:findTF("list/bg/scroll_bar")
	arg0_7.list = arg0_7:findTF("list/bg/scrollrect"):GetComponent("LScrollRect")
	arg0_7.imageTF = arg0_7:findTF("main/left_panel/mask/Image"):GetComponent(typeof(RawImage))
	arg0_7.likeBtn = arg0_7:findTF("main/left_panel/heart")
	arg0_7.bubbleTF = arg0_7:findTF("main/left_panel/bubble")
	arg0_7.planeTF = arg0_7:findTF("main/left_panel/plane")
	arg0_7.likeCntTxt = arg0_7:findTF("main/left_panel/zan"):GetComponent(typeof(Text))
	arg0_7.pushTimeTxt = arg0_7:findTF("main/left_panel/time"):GetComponent(typeof(Text))
	arg0_7.iconTF = arg0_7:findTF("main/right_panel/top/head/icon")
	arg0_7.nameTxt = arg0_7:findTF("main/right_panel/top/name"):GetComponent(typeof(Text))
	arg0_7.centerTF = arg0_7:findTF("main/right_panel/center")
	arg0_7.contentTxt = arg0_7:findTF("main/right_panel/center/Text/Text"):GetComponent(typeof(Text))
	arg0_7.commentList = UIItemList.New(arg0_7:findTF("main/right_panel/center/bottom/scroll/content"), arg0_7:findTF("main/right_panel/center/bottom/scroll/content/tpl"))
	arg0_7.commentPanel = arg0_7:findTF("main/right_panel/last/bg2")
	arg0_7.optionalPanel = arg0_7:findTF("main/right_panel/last/bg2/option")
	arg0_7.scroll = arg0_7:findTF("main/right_panel/center/bottom/scroll")

	setText(arg0_7:findTF("closeBtn/Text"), i18n("word_back"))

	arg0_7.sprites = {}
	arg0_7.timers = {}
	arg0_7.toDownloadList = {}

	arg0_7:OverlayPanel(arg0_7._tf)
end

function var0_0.SetImageByUrl(arg0_8, arg1_8, arg2_8, arg3_8)
	if not arg1_8 or arg1_8 == "" then
		setActive(arg2_8.gameObject, false)

		if arg3_8 then
			arg3_8()
		end
	else
		setActive(arg2_8.gameObject, true)

		local var0_8 = arg0_8.sprites[arg1_8]

		if var0_8 then
			arg2_8.texture = var0_8

			if arg3_8 then
				arg3_8()
			end
		else
			arg2_8.enabled = false

			arg0_8.downloadmgr:GetTexture("ins", "1", arg1_8, UnityEngine.Events.UnityAction_UnityEngine_Texture(function(arg0_9)
				if arg0_8.exited then
					return
				end

				if not arg0_8.sprites then
					return
				end

				arg0_8.sprites[arg1_8] = arg0_9
				arg2_8.texture = arg0_9
				arg2_8.enabled = true

				if arg3_8 then
					arg3_8()
				end
			end))
			table.insert(arg0_8.toDownloadList, arg1_8)
		end
	end
end

function var0_0.didEnter(arg0_10)
	arg0_10:SetUp()

	arg0_10.cards = {}

	function arg0_10.list.onInitItem(arg0_11)
		local var0_11 = InstagramCard.New(arg0_11, arg0_10)

		onButton(arg0_10, var0_11._go, function()
			arg0_10:EnterDetail(var0_11.instagram)
		end, SFX_PANEL)

		arg0_10.cards[arg0_11] = var0_11
	end

	function arg0_10.list.onUpdateItem(arg0_13, arg1_13)
		local var0_13 = arg0_10.cards[arg1_13]

		if not var0_13 then
			var0_13 = InstagramCard.New(arg1_13)
			arg0_10.cards[arg1_13] = var0_13
		end

		local var1_13 = arg0_10.display[arg0_13 + 1]
		local var2_13 = arg0_10.instagramVOById[var1_13.id]

		var0_13:Update(var2_13)
	end

	arg0_10:InitList()
end

function var0_0.SetUp(arg0_14)
	setActive(arg0_14.listTF, true)
	setActive(arg0_14.mainTF, false)
	setActive(arg0_14.closeBtn, false)
	onButton(arg0_14, arg0_14.closeBtn, function()
		if arg0_14.inDetail then
			arg0_14:ExitDetail()
		end
	end, SFX_PANEL)
end

function var0_0.InitList(arg0_16)
	arg0_16.display = _.map(arg0_16.messages, function(arg0_17)
		return {
			time = arg0_17:GetLasterUpdateTime(),
			id = arg0_17.id,
			order = arg0_17:GetSortIndex()
		}
	end)

	table.sort(arg0_16.display, function(arg0_18, arg1_18)
		if arg0_18.order == arg1_18.order then
			return arg0_18.id > arg1_18.id
		else
			return arg0_18.order > arg1_18.order
		end
	end)

	if isActive(arg0_16.listTF) then
		arg0_16.list:SetTotalCount(#arg0_16.display)
	end

	setActive(arg0_16.noMsgTF, #arg0_16.display == 0)
	setActive(arg0_16.scrollBarTF, not #arg0_16.display == 0)
end

function var0_0.UpdateInstagram(arg0_19, arg1_19, arg2_19)
	for iter0_19, iter1_19 in pairs(arg0_19.cards) do
		if iter1_19.instagram and iter1_19.instagram.id == arg1_19 then
			iter1_19:Update(arg0_19.instagramVOById[arg1_19], arg2_19)
		end
	end
end

function var0_0.EnterDetail(arg0_20, arg1_20)
	arg0_20.contextData.instagram = arg1_20

	arg0_20:InitDetailPage()

	arg0_20.inDetail = true

	setActive(arg0_20.listTF, false)
	setActive(arg0_20.mainTF, true)
	setActive(arg0_20.closeBtn, true)
	pg.SystemGuideMgr.GetInstance():Play(arg0_20)
	arg0_20:RefreshInstagram()
	scrollTo(arg0_20.scroll, 0, 1)
end

function var0_0.ExitDetail(arg0_21)
	local var0_21 = arg0_21.contextData.instagram

	if var0_21 and not var0_21:IsReaded() then
		arg0_21:emit(InstagramMediator.ON_READED, var0_21.id)
	end

	arg0_21.contextData.instagram = nil
	arg0_21.inDetail = false

	setActive(arg0_21.listTF, true)
	setActive(arg0_21.mainTF, false)
	setActive(arg0_21.closeBtn, false)
	arg0_21:CloseCommentPanel()
end

function var0_0.RefreshInstagram(arg0_22)
	local var0_22 = arg0_22.contextData.instagram
	local var1_22 = var0_22:GetFastestRefreshTime()

	if var1_22 and var1_22 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
		arg0_22:emit(InstagramMediator.ON_REPLY_UPDATE, var0_22.id)
	end
end

function var0_0.InitDetailPage(arg0_23)
	local var0_23 = arg0_23.contextData.instagram

	arg0_23:SetImageByUrl(var0_23:GetImage(), arg0_23.imageTF)
	onButton(arg0_23, arg0_23.planeTF, function()
		arg0_23:emit(InstagramMediator.ON_SHARE, var0_23.id)
	end, SFX_PANEL)

	arg0_23.pushTimeTxt.text = var0_23:GetPushTime()

	setImageSprite(arg0_23.iconTF, LoadSprite("qicon/" .. var0_23:GetIcon()), false)

	arg0_23.nameTxt.text = var0_23:GetName()
	arg0_23.contentTxt.text = var0_23:GetContent()

	onToggle(arg0_23, arg0_23.commentPanel, function(arg0_25)
		if arg0_25 then
			arg0_23:OpenCommentPanel()
		else
			arg0_23:CloseCommentPanel()
		end
	end, SFX_PANEL)
	arg0_23:UpdateLikeBtn()
	arg0_23:UpdateCommentList()
end

function var0_0.UpdateLikeBtn(arg0_26)
	local var0_26 = arg0_26.contextData.instagram
	local var1_26 = var0_26:IsLiking()

	if not var1_26 then
		onButton(arg0_26, arg0_26.likeBtn, function()
			arg0_26:emit(InstagramMediator.ON_LIKE, var0_26.id)
		end, SFX_PANEL)
	else
		removeOnButton(arg0_26.likeBtn)
	end

	setActive(arg0_26.likeBtn:Find("heart"), var1_26)

	arg0_26.likeBtn:GetComponent(typeof(Image)).enabled = not var1_26
	arg0_26.likeCntTxt.text = i18n("ins_word_like", var0_26:GetLikeCnt())
end

function var0_0.UpdateCommentList(arg0_28)
	local var0_28 = arg0_28.contextData.instagram

	if not var0_28 then
		return
	end

	local var1_28, var2_28 = var0_28:GetCanDisplayComments()

	table.sort(var1_28, function(arg0_29, arg1_29)
		return arg0_29.time < arg1_29.time
	end)
	arg0_28.commentList:make(function(arg0_30, arg1_30, arg2_30)
		if arg0_30 == UIItemList.EventUpdate then
			local var0_30 = var1_28[arg1_30 + 1]
			local var1_30 = var0_30:HasReply()

			setText(arg2_30:Find("main/reply"), var0_30:GetReplyBtnTxt())

			local var2_30 = var0_30:GetContent()
			local var3_30 = SwitchSpecialChar(var2_30)

			setText(arg2_30:Find("main/content"), HXSet.hxLan(var3_30))
			setText(arg2_30:Find("main/bubble/Text"), var0_30:GetReplyCnt())
			setText(arg2_30:Find("main/time"), var0_30:GetTime())

			if var0_30:GetType() == Instagram.TYPE_PLAYER_COMMENT then
				local var4_30, var5_30 = var0_30:GetIcon()

				setImageSprite(arg2_30:Find("main/head/icon"), GetSpriteFromAtlas(var4_30, var5_30))
			else
				setImageSprite(arg2_30:Find("main/head/icon"), LoadSprite("qicon/" .. var0_30:GetIcon()), false)
			end

			if var1_30 then
				onToggle(arg0_28, arg2_30:Find("main/bubble"), function(arg0_31)
					setActive(arg2_30:Find("replys"), arg0_31)
				end, SFX_PANEL)
				arg0_28:UpdateReplys(arg2_30, var0_30)
				triggerToggle(arg2_30:Find("main/bubble"), true)
			else
				setActive(arg2_30:Find("replys"), false)
				triggerToggle(arg2_30:Find("main/bubble"), false)
			end

			arg2_30:Find("main/bubble"):GetComponent(typeof(Toggle)).enabled = var1_30
		end
	end)
	setActive(arg0_28.centerTF, false)
	setActive(arg0_28.centerTF, true)
	Canvas.ForceUpdateCanvases()
	arg0_28.commentList:align(#var1_28)
end

function var0_0.UpdateReplys(arg0_32, arg1_32, arg2_32)
	local var0_32, var1_32 = arg2_32:GetCanDisplayReply()
	local var2_32 = UIItemList.New(arg1_32:Find("replys"), arg1_32:Find("replys/sub"))

	table.sort(var0_32, function(arg0_33, arg1_33)
		if arg0_33.level == arg1_33.level then
			if arg0_33.time == arg1_33.time then
				return arg0_33.id < arg1_33.id
			else
				return arg0_33.time < arg1_33.time
			end
		else
			return arg0_33.level < arg1_33.level
		end
	end)
	var2_32:make(function(arg0_34, arg1_34, arg2_34)
		if arg0_34 == UIItemList.EventUpdate then
			local var0_34 = var0_32[arg1_34 + 1]

			setImageSprite(arg2_34:Find("head/icon"), LoadSprite("qicon/" .. var0_34:GetIcon()), false)

			local var1_34 = var0_34:GetContent()
			local var2_34 = SwitchSpecialChar(var1_34)

			setText(arg2_34:Find("content"), HXSet.hxLan(var2_34))
		end
	end)
	var2_32:align(#var0_32)
end

function var0_0.OpenCommentPanel(arg0_35)
	local var0_35 = arg0_35.contextData.instagram

	if not var0_35:CanOpenComment() then
		return
	end

	setActive(arg0_35.optionalPanel, true)

	local var1_35 = var0_35:GetOptionComment()

	arg0_35.commentPanel:GetComponent(typeof(Image)).enabled = true
	arg0_35.commentPanel.sizeDelta = Vector2(0, #var1_35 * 142 + 60)

	local var2_35 = UIItemList.New(arg0_35.optionalPanel, arg0_35.optionalPanel:Find("option1"))

	var2_35:make(function(arg0_36, arg1_36, arg2_36)
		if arg0_36 == UIItemList.EventUpdate then
			local var0_36 = arg1_36 + 1
			local var1_36 = var1_35[var0_36].text
			local var2_36 = var1_35[var0_36].id
			local var3_36 = var1_35[var0_36].index

			setText(arg2_36:Find("Text"), HXSet.hxLan(var1_36))
			onButton(arg0_35, arg2_36, function()
				arg0_35:emit(InstagramMediator.ON_COMMENT, var0_35.id, var3_36, var2_36)
				arg0_35:CloseCommentPanel()
			end, SFX_PANEL)
		end
	end)
	var2_35:align(#var1_35)
end

function var0_0.CloseCommentPanel(arg0_38)
	arg0_38.commentPanel:GetComponent(typeof(Image)).enabled = false
	arg0_38.commentPanel.sizeDelta = Vector2(0, 0)

	setActive(arg0_38.optionalPanel, false)
end

function var0_0.onBackPressed(arg0_39)
	if arg0_39.inDetail then
		arg0_39:ExitDetail()

		return
	end

	arg0_39:emit(InstagramMediator.CLOSE_ALL)
end

function var0_0.CloseDetail(arg0_40)
	if arg0_40.inDetail then
		arg0_40:ExitDetail()

		return
	end
end

function var0_0.willExit(arg0_41)
	for iter0_41, iter1_41 in ipairs(arg0_41.toDownloadList or {}) do
		arg0_41.downloadmgr:StopLoader(iter1_41)
	end

	arg0_41.toDownloadList = {}

	arg0_41:UnOverlayPanel(arg0_41._tf)
	arg0_41:ExitDetail()

	for iter2_41, iter3_41 in pairs(arg0_41.sprites) do
		if not IsNil(iter3_41) then
			Object.Destroy(iter3_41)
		end
	end

	arg0_41.sprites = nil

	for iter4_41, iter5_41 in pairs(arg0_41.cards) do
		iter5_41:Dispose()
	end

	arg0_41.cards = {}
end

return var0_0
