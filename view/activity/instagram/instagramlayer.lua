local var0_0 = class("InstagramLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "InstagramUI"
end

function var0_0.preload(arg0_2, arg1_2)
	pg.m02:sendNotification(GAME.REQ_OLD_INSTAGRAM_DATA, {
		callback = function()
			arg0_2:SetProxy(getProxy(InstagramProxy))
			arg1_2()
		end
	})
end

function var0_0.SetProxy(arg0_4, arg1_4)
	arg0_4.proxy = arg1_4
	arg0_4.instagramVOById = arg1_4:GetData()
	arg0_4.messages = arg1_4:GetMessages()
end

function var0_0.UpdateSelectedInstagram(arg0_5, arg1_5)
	if arg0_5.contextData.instagram and arg0_5.contextData.instagram.id == arg1_5 then
		arg0_5.contextData.instagram = arg0_5.instagramVOById[arg1_5]

		arg0_5:UpdateCommentList()
	end
end

function var0_0.init(arg0_6)
	local var0_6 = GameObject.Find("MainObject")

	arg0_6.downloadmgr = BulletinBoardMgr.Inst
	arg0_6.listTF = arg0_6:findTF("list")
	arg0_6.mainTF = arg0_6:findTF("main")
	arg0_6.closeBtn = arg0_6:findTF("closeBtn")
	arg0_6.noMsgTF = arg0_6:findTF("list/bg/no_msg")
	arg0_6.scrollBarTF = arg0_6:findTF("list/bg/scroll_bar")
	arg0_6.list = arg0_6:findTF("list/bg/scrollrect"):GetComponent("LScrollRect")
	arg0_6.imageTF = arg0_6:findTF("main/left_panel/mask/Image"):GetComponent(typeof(RawImage))
	arg0_6.likeBtn = arg0_6:findTF("main/left_panel/heart")
	arg0_6.bubbleTF = arg0_6:findTF("main/left_panel/bubble")
	arg0_6.planeTF = arg0_6:findTF("main/left_panel/plane")
	arg0_6.likeCntTxt = arg0_6:findTF("main/left_panel/zan"):GetComponent(typeof(Text))
	arg0_6.pushTimeTxt = arg0_6:findTF("main/left_panel/time"):GetComponent(typeof(Text))
	arg0_6.iconTF = arg0_6:findTF("main/right_panel/top/head/icon")
	arg0_6.nameTxt = arg0_6:findTF("main/right_panel/top/name"):GetComponent(typeof(Text))
	arg0_6.centerTF = arg0_6:findTF("main/right_panel/center")
	arg0_6.contentTxt = arg0_6:findTF("main/right_panel/center/Text/Text"):GetComponent(typeof(Text))
	arg0_6.commentList = UIItemList.New(arg0_6:findTF("main/right_panel/center/bottom/scroll/content"), arg0_6:findTF("main/right_panel/center/bottom/scroll/content/tpl"))
	arg0_6.commentPanel = arg0_6:findTF("main/right_panel/last/bg2")
	arg0_6.optionalPanel = arg0_6:findTF("main/right_panel/last/bg2/option")
	arg0_6.scroll = arg0_6:findTF("main/right_panel/center/bottom/scroll")

	setText(arg0_6:findTF("closeBtn/Text"), i18n("word_back"))

	arg0_6.sprites = {}
	arg0_6.timers = {}
	arg0_6.toDownloadList = {}

	arg0_6:OverlayPanel(arg0_6._tf)
end

function var0_0.SetImageByUrl(arg0_7, arg1_7, arg2_7, arg3_7)
	if not arg1_7 or arg1_7 == "" then
		setActive(arg2_7.gameObject, false)

		if arg3_7 then
			arg3_7()
		end
	else
		setActive(arg2_7.gameObject, true)

		local var0_7 = arg0_7.sprites[arg1_7]

		if var0_7 then
			arg2_7.texture = var0_7

			if arg3_7 then
				arg3_7()
			end
		else
			arg2_7.enabled = false

			arg0_7.downloadmgr:GetTexture("ins", "1", arg1_7, UnityEngine.Events.UnityAction_UnityEngine_Texture(function(arg0_8)
				if arg0_7.exited then
					return
				end

				if not arg0_7.sprites then
					return
				end

				arg0_7.sprites[arg1_7] = arg0_8
				arg2_7.texture = arg0_8
				arg2_7.enabled = true

				if arg3_7 then
					arg3_7()
				end
			end))
			table.insert(arg0_7.toDownloadList, arg1_7)
		end
	end
end

function var0_0.didEnter(arg0_9)
	arg0_9:SetUp()

	arg0_9.cards = {}

	function arg0_9.list.onInitItem(arg0_10)
		local var0_10 = InstagramCard.New(arg0_10, arg0_9)

		onButton(arg0_9, var0_10._go, function()
			arg0_9:EnterDetail(var0_10.instagram)
		end, SFX_PANEL)

		arg0_9.cards[arg0_10] = var0_10
	end

	function arg0_9.list.onUpdateItem(arg0_12, arg1_12)
		local var0_12 = arg0_9.cards[arg1_12]

		if not var0_12 then
			var0_12 = InstagramCard.New(arg1_12)
			arg0_9.cards[arg1_12] = var0_12
		end

		local var1_12 = arg0_9.display[arg0_12 + 1]
		local var2_12 = arg0_9.instagramVOById[var1_12.id]

		var0_12:Update(var2_12)
	end

	arg0_9:InitList()
end

function var0_0.SetUp(arg0_13)
	setActive(arg0_13.listTF, true)
	setActive(arg0_13.mainTF, false)
	setActive(arg0_13.closeBtn, false)
	onButton(arg0_13, arg0_13.closeBtn, function()
		if arg0_13.inDetail then
			arg0_13:ExitDetail()
		end
	end, SFX_PANEL)
end

function var0_0.InitList(arg0_15)
	arg0_15.display = _.map(arg0_15.messages, function(arg0_16)
		return {
			time = arg0_16:GetLasterUpdateTime(),
			id = arg0_16.id,
			order = arg0_16:GetSortIndex()
		}
	end)

	table.sort(arg0_15.display, function(arg0_17, arg1_17)
		if arg0_17.order == arg1_17.order then
			return arg0_17.id > arg1_17.id
		else
			return arg0_17.order > arg1_17.order
		end
	end)

	if isActive(arg0_15.listTF) then
		arg0_15.list:SetTotalCount(#arg0_15.display)
	end

	setActive(arg0_15.noMsgTF, #arg0_15.display == 0)
	setActive(arg0_15.scrollBarTF, not #arg0_15.display == 0)
end

function var0_0.UpdateInstagram(arg0_18, arg1_18, arg2_18)
	for iter0_18, iter1_18 in pairs(arg0_18.cards) do
		if iter1_18.instagram and iter1_18.instagram.id == arg1_18 then
			iter1_18:Update(arg0_18.instagramVOById[arg1_18], arg2_18)
		end
	end
end

function var0_0.EnterDetail(arg0_19, arg1_19)
	arg0_19.contextData.instagram = arg1_19

	arg0_19:InitDetailPage()

	arg0_19.inDetail = true

	setActive(arg0_19.listTF, false)
	setActive(arg0_19.mainTF, true)
	setActive(arg0_19.closeBtn, true)
	pg.SystemGuideMgr.GetInstance():Play(arg0_19)
	arg0_19:RefreshInstagram()
	scrollTo(arg0_19.scroll, 0, 1)
end

function var0_0.ExitDetail(arg0_20)
	local var0_20 = arg0_20.contextData.instagram

	if var0_20 and not var0_20:IsReaded() then
		arg0_20:emit(InstagramMediator.ON_READED, var0_20.id)
	end

	arg0_20.contextData.instagram = nil
	arg0_20.inDetail = false

	setActive(arg0_20.listTF, true)
	setActive(arg0_20.mainTF, false)
	setActive(arg0_20.closeBtn, false)
	arg0_20:CloseCommentPanel()
end

function var0_0.RefreshInstagram(arg0_21)
	local var0_21 = arg0_21.contextData.instagram
	local var1_21 = var0_21:GetFastestRefreshTime()

	if var1_21 and var1_21 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
		arg0_21:emit(InstagramMediator.ON_REPLY_UPDATE, var0_21.id)
	end
end

function var0_0.InitDetailPage(arg0_22)
	local var0_22 = arg0_22.contextData.instagram

	arg0_22:SetImageByUrl(var0_22:GetImage(), arg0_22.imageTF)
	onButton(arg0_22, arg0_22.planeTF, function()
		arg0_22:emit(InstagramMediator.ON_SHARE, var0_22.id)
	end, SFX_PANEL)

	arg0_22.pushTimeTxt.text = var0_22:GetPushTime()

	setImageSprite(arg0_22.iconTF, LoadSprite("qicon/" .. var0_22:GetIcon()), false)

	arg0_22.nameTxt.text = var0_22:GetName()
	arg0_22.contentTxt.text = var0_22:GetContent()

	onToggle(arg0_22, arg0_22.commentPanel, function(arg0_24)
		if arg0_24 then
			arg0_22:OpenCommentPanel()
		else
			arg0_22:CloseCommentPanel()
		end
	end, SFX_PANEL)
	arg0_22:UpdateLikeBtn()
	arg0_22:UpdateCommentList()
end

function var0_0.UpdateLikeBtn(arg0_25)
	local var0_25 = arg0_25.contextData.instagram
	local var1_25 = var0_25:IsLiking()

	if not var1_25 then
		onButton(arg0_25, arg0_25.likeBtn, function()
			arg0_25:emit(InstagramMediator.ON_LIKE, var0_25.id)
		end, SFX_PANEL)
	else
		removeOnButton(arg0_25.likeBtn)
	end

	setActive(arg0_25.likeBtn:Find("heart"), var1_25)

	arg0_25.likeBtn:GetComponent(typeof(Image)).enabled = not var1_25
	arg0_25.likeCntTxt.text = i18n("ins_word_like", var0_25:GetLikeCnt())
end

function var0_0.UpdateCommentList(arg0_27)
	local var0_27 = arg0_27.contextData.instagram

	if not var0_27 then
		return
	end

	local var1_27, var2_27 = var0_27:GetCanDisplayComments()

	table.sort(var1_27, function(arg0_28, arg1_28)
		return arg0_28.time < arg1_28.time
	end)
	arg0_27.commentList:make(function(arg0_29, arg1_29, arg2_29)
		if arg0_29 == UIItemList.EventUpdate then
			local var0_29 = var1_27[arg1_29 + 1]
			local var1_29 = var0_29:HasReply()

			setText(arg2_29:Find("main/reply"), var0_29:GetReplyBtnTxt())

			local var2_29 = var0_29:GetContent()
			local var3_29 = SwitchSpecialChar(var2_29)

			setText(arg2_29:Find("main/content"), HXSet.hxLan(var3_29))
			setText(arg2_29:Find("main/bubble/Text"), var0_29:GetReplyCnt())
			setText(arg2_29:Find("main/time"), var0_29:GetTime())

			if var0_29:GetType() == Instagram.TYPE_PLAYER_COMMENT then
				local var4_29, var5_29 = var0_29:GetIcon()

				setImageSprite(arg2_29:Find("main/head/icon"), GetSpriteFromAtlas(var4_29, var5_29))
			else
				setImageSprite(arg2_29:Find("main/head/icon"), LoadSprite("qicon/" .. var0_29:GetIcon()), false)
			end

			if var1_29 then
				onToggle(arg0_27, arg2_29:Find("main/bubble"), function(arg0_30)
					setActive(arg2_29:Find("replys"), arg0_30)
				end, SFX_PANEL)
				arg0_27:UpdateReplys(arg2_29, var0_29)
				triggerToggle(arg2_29:Find("main/bubble"), true)
			else
				setActive(arg2_29:Find("replys"), false)
				triggerToggle(arg2_29:Find("main/bubble"), false)
			end

			arg2_29:Find("main/bubble"):GetComponent(typeof(Toggle)).enabled = var1_29
		end
	end)
	setActive(arg0_27.centerTF, false)
	setActive(arg0_27.centerTF, true)
	Canvas.ForceUpdateCanvases()
	arg0_27.commentList:align(#var1_27)
end

function var0_0.UpdateReplys(arg0_31, arg1_31, arg2_31)
	local var0_31, var1_31 = arg2_31:GetCanDisplayReply()
	local var2_31 = UIItemList.New(arg1_31:Find("replys"), arg1_31:Find("replys/sub"))

	table.sort(var0_31, function(arg0_32, arg1_32)
		if arg0_32.level == arg1_32.level then
			if arg0_32.time == arg1_32.time then
				return arg0_32.id < arg1_32.id
			else
				return arg0_32.time < arg1_32.time
			end
		else
			return arg0_32.level < arg1_32.level
		end
	end)
	var2_31:make(function(arg0_33, arg1_33, arg2_33)
		if arg0_33 == UIItemList.EventUpdate then
			local var0_33 = var0_31[arg1_33 + 1]

			setImageSprite(arg2_33:Find("head/icon"), LoadSprite("qicon/" .. var0_33:GetIcon()), false)

			local var1_33 = var0_33:GetContent()
			local var2_33 = SwitchSpecialChar(var1_33)

			setText(arg2_33:Find("content"), HXSet.hxLan(var2_33))
		end
	end)
	var2_31:align(#var0_31)
end

function var0_0.OpenCommentPanel(arg0_34)
	local var0_34 = arg0_34.contextData.instagram

	if not var0_34:CanOpenComment() then
		return
	end

	setActive(arg0_34.optionalPanel, true)

	local var1_34 = var0_34:GetOptionComment()

	arg0_34.commentPanel:GetComponent(typeof(Image)).enabled = true
	arg0_34.commentPanel.sizeDelta = Vector2(0, #var1_34 * 142 + 60)

	local var2_34 = UIItemList.New(arg0_34.optionalPanel, arg0_34.optionalPanel:Find("option1"))

	var2_34:make(function(arg0_35, arg1_35, arg2_35)
		if arg0_35 == UIItemList.EventUpdate then
			local var0_35 = arg1_35 + 1
			local var1_35 = var1_34[var0_35].text
			local var2_35 = var1_34[var0_35].id
			local var3_35 = var1_34[var0_35].index

			setText(arg2_35:Find("Text"), HXSet.hxLan(var1_35))
			onButton(arg0_34, arg2_35, function()
				arg0_34:emit(InstagramMediator.ON_COMMENT, var0_34.id, var3_35, var2_35)
				arg0_34:CloseCommentPanel()
			end, SFX_PANEL)
		end
	end)
	var2_34:align(#var1_34)
end

function var0_0.CloseCommentPanel(arg0_37)
	arg0_37.commentPanel:GetComponent(typeof(Image)).enabled = false
	arg0_37.commentPanel.sizeDelta = Vector2(0, 0)

	setActive(arg0_37.optionalPanel, false)
end

function var0_0.onBackPressed(arg0_38)
	if arg0_38.inDetail then
		arg0_38:ExitDetail()

		return
	end

	arg0_38:emit(InstagramMediator.CLOSE_ALL)
end

function var0_0.CloseDetail(arg0_39)
	if arg0_39.inDetail then
		arg0_39:ExitDetail()

		return
	end
end

function var0_0.willExit(arg0_40)
	for iter0_40, iter1_40 in ipairs(arg0_40.toDownloadList or {}) do
		arg0_40.downloadmgr:StopLoader(iter1_40)
	end

	arg0_40.toDownloadList = {}

	arg0_40:UnOverlayPanel(arg0_40._tf)
	arg0_40:ExitDetail()

	for iter2_40, iter3_40 in pairs(arg0_40.sprites) do
		if not IsNil(iter3_40) then
			Object.Destroy(iter3_40)
		end
	end

	arg0_40.sprites = nil

	for iter4_40, iter5_40 in pairs(arg0_40.cards) do
		iter5_40:Dispose()
	end

	arg0_40.cards = {}
end

return var0_0
