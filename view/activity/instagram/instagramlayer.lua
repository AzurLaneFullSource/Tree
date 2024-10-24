local var0_0 = class("InstagramLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "InstagramUI"
end

function var0_0.SetProxy(arg0_2, arg1_2)
	arg0_2.proxy = arg1_2
	arg0_2.instagramVOById = arg1_2:GetData()
	arg0_2.messages = arg1_2:GetMessages()
end

function var0_0.UpdateSelectedInstagram(arg0_3, arg1_3)
	if arg0_3.contextData.instagram and arg0_3.contextData.instagram.id == arg1_3 then
		arg0_3.contextData.instagram = arg0_3.instagramVOById[arg1_3]

		arg0_3:UpdateCommentList()
	end
end

function var0_0.init(arg0_4)
	local var0_4 = GameObject.Find("MainObject")

	arg0_4.downloadmgr = BulletinBoardMgr.Inst
	arg0_4.listTF = arg0_4:findTF("list")
	arg0_4.mainTF = arg0_4:findTF("main")
	arg0_4.closeBtn = arg0_4:findTF("closeBtn")
	arg0_4.noMsgTF = arg0_4:findTF("list/bg/no_msg")
	arg0_4.scrollBarTF = arg0_4:findTF("list/bg/scroll_bar")
	arg0_4.list = arg0_4:findTF("list/bg/scrollrect"):GetComponent("LScrollRect")
	arg0_4.imageTF = arg0_4:findTF("main/left_panel/mask/Image"):GetComponent(typeof(RawImage))
	arg0_4.likeBtn = arg0_4:findTF("main/left_panel/heart")
	arg0_4.bubbleTF = arg0_4:findTF("main/left_panel/bubble")
	arg0_4.planeTF = arg0_4:findTF("main/left_panel/plane")
	arg0_4.likeCntTxt = arg0_4:findTF("main/left_panel/zan"):GetComponent(typeof(Text))
	arg0_4.pushTimeTxt = arg0_4:findTF("main/left_panel/time"):GetComponent(typeof(Text))
	arg0_4.iconTF = arg0_4:findTF("main/right_panel/top/head/icon")
	arg0_4.nameTxt = arg0_4:findTF("main/right_panel/top/name"):GetComponent(typeof(Text))
	arg0_4.centerTF = arg0_4:findTF("main/right_panel/center")
	arg0_4.contentTxt = arg0_4:findTF("main/right_panel/center/Text/Text"):GetComponent(typeof(Text))
	arg0_4.commentList = UIItemList.New(arg0_4:findTF("main/right_panel/center/bottom/scroll/content"), arg0_4:findTF("main/right_panel/center/bottom/scroll/content/tpl"))
	arg0_4.commentPanel = arg0_4:findTF("main/right_panel/last/bg2")
	arg0_4.optionalPanel = arg0_4:findTF("main/right_panel/last/bg2/option")
	arg0_4.scroll = arg0_4:findTF("main/right_panel/center/bottom/scroll")

	setText(arg0_4:findTF("closeBtn/Text"), i18n("word_back"))

	arg0_4.sprites = {}
	arg0_4.timers = {}
	arg0_4.toDownloadList = {}

	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf, false, {
		groupName = "Instagram",
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0_0.SetImageByUrl(arg0_5, arg1_5, arg2_5, arg3_5)
	if not arg1_5 or arg1_5 == "" then
		setActive(arg2_5.gameObject, false)

		if arg3_5 then
			arg3_5()
		end
	else
		setActive(arg2_5.gameObject, true)

		local var0_5 = arg0_5.sprites[arg1_5]

		if var0_5 then
			arg2_5.texture = var0_5

			if arg3_5 then
				arg3_5()
			end
		else
			arg2_5.enabled = false

			arg0_5.downloadmgr:GetTexture("ins", "1", arg1_5, UnityEngine.Events.UnityAction_UnityEngine_Texture(function(arg0_6)
				if arg0_5.exited then
					return
				end

				if not arg0_5.sprites then
					return
				end

				arg0_5.sprites[arg1_5] = arg0_6
				arg2_5.texture = arg0_6
				arg2_5.enabled = true

				if arg3_5 then
					arg3_5()
				end
			end))
			table.insert(arg0_5.toDownloadList, arg1_5)
		end
	end
end

function var0_0.didEnter(arg0_7)
	arg0_7:SetUp()

	arg0_7.cards = {}

	function arg0_7.list.onInitItem(arg0_8)
		local var0_8 = InstagramCard.New(arg0_8, arg0_7)

		onButton(arg0_7, var0_8._go, function()
			arg0_7:EnterDetail(var0_8.instagram)
		end, SFX_PANEL)

		arg0_7.cards[arg0_8] = var0_8
	end

	function arg0_7.list.onUpdateItem(arg0_10, arg1_10)
		local var0_10 = arg0_7.cards[arg1_10]

		if not var0_10 then
			var0_10 = InstagramCard.New(arg1_10)
			arg0_7.cards[arg1_10] = var0_10
		end

		local var1_10 = arg0_7.display[arg0_10 + 1]
		local var2_10 = arg0_7.instagramVOById[var1_10.id]

		var0_10:Update(var2_10)
	end

	arg0_7:InitList()
end

function var0_0.SetUp(arg0_11)
	setActive(arg0_11.listTF, true)
	setActive(arg0_11.mainTF, false)
	setActive(arg0_11.closeBtn, false)
	onButton(arg0_11, arg0_11.closeBtn, function()
		if arg0_11.inDetail then
			arg0_11:ExitDetail()
		end
	end, SFX_PANEL)
end

function var0_0.InitList(arg0_13)
	arg0_13.display = _.map(arg0_13.messages, function(arg0_14)
		return {
			time = arg0_14:GetLasterUpdateTime(),
			id = arg0_14.id,
			order = arg0_14:GetSortIndex()
		}
	end)

	table.sort(arg0_13.display, function(arg0_15, arg1_15)
		if arg0_15.order == arg1_15.order then
			return arg0_15.id > arg1_15.id
		else
			return arg0_15.order > arg1_15.order
		end
	end)
	arg0_13.list:SetTotalCount(#arg0_13.display)
	setActive(arg0_13.noMsgTF, #arg0_13.display == 0)
	setActive(arg0_13.scrollBarTF, not #arg0_13.display == 0)
end

function var0_0.UpdateInstagram(arg0_16, arg1_16, arg2_16)
	for iter0_16, iter1_16 in pairs(arg0_16.cards) do
		if iter1_16.instagram and iter1_16.instagram.id == arg1_16 then
			iter1_16:Update(arg0_16.instagramVOById[arg1_16], arg2_16)
		end
	end
end

function var0_0.EnterDetail(arg0_17, arg1_17)
	arg0_17.contextData.instagram = arg1_17

	arg0_17:InitDetailPage()

	arg0_17.inDetail = true

	setActive(arg0_17.listTF, false)
	setActive(arg0_17.mainTF, true)
	setActive(arg0_17.closeBtn, true)
	pg.SystemGuideMgr.GetInstance():Play(arg0_17)
	arg0_17:RefreshInstagram()
	scrollTo(arg0_17.scroll, 0, 1)
end

function var0_0.ExitDetail(arg0_18)
	local var0_18 = arg0_18.contextData.instagram

	if var0_18 and not var0_18:IsReaded() then
		arg0_18:emit(InstagramMediator.ON_READED, var0_18.id)
	end

	arg0_18.contextData.instagram = nil
	arg0_18.inDetail = false

	setActive(arg0_18.listTF, true)
	setActive(arg0_18.mainTF, false)
	setActive(arg0_18.closeBtn, false)
	arg0_18:CloseCommentPanel()
end

function var0_0.RefreshInstagram(arg0_19)
	local var0_19 = arg0_19.contextData.instagram
	local var1_19 = var0_19:GetFastestRefreshTime()

	if var1_19 and var1_19 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
		arg0_19:emit(InstagramMediator.ON_REPLY_UPDATE, var0_19.id)
	end
end

function var0_0.InitDetailPage(arg0_20)
	local var0_20 = arg0_20.contextData.instagram

	arg0_20:SetImageByUrl(var0_20:GetImage(), arg0_20.imageTF)
	onButton(arg0_20, arg0_20.planeTF, function()
		arg0_20:emit(InstagramMediator.ON_SHARE, var0_20.id)
	end, SFX_PANEL)

	arg0_20.pushTimeTxt.text = var0_20:GetPushTime()

	setImageSprite(arg0_20.iconTF, LoadSprite("qicon/" .. var0_20:GetIcon()), false)

	arg0_20.nameTxt.text = var0_20:GetName()
	arg0_20.contentTxt.text = var0_20:GetContent()

	onToggle(arg0_20, arg0_20.commentPanel, function(arg0_22)
		if arg0_22 then
			arg0_20:OpenCommentPanel()
		else
			arg0_20:CloseCommentPanel()
		end
	end, SFX_PANEL)
	arg0_20:UpdateLikeBtn()
	arg0_20:UpdateCommentList()
end

function var0_0.UpdateLikeBtn(arg0_23)
	local var0_23 = arg0_23.contextData.instagram
	local var1_23 = var0_23:IsLiking()

	if not var1_23 then
		onButton(arg0_23, arg0_23.likeBtn, function()
			arg0_23:emit(InstagramMediator.ON_LIKE, var0_23.id)
		end, SFX_PANEL)
	else
		removeOnButton(arg0_23.likeBtn)
	end

	setActive(arg0_23.likeBtn:Find("heart"), var1_23)

	arg0_23.likeBtn:GetComponent(typeof(Image)).enabled = not var1_23
	arg0_23.likeCntTxt.text = i18n("ins_word_like", var0_23:GetLikeCnt())
end

function var0_0.UpdateCommentList(arg0_25)
	local var0_25 = arg0_25.contextData.instagram

	if not var0_25 then
		return
	end

	local var1_25, var2_25 = var0_25:GetCanDisplayComments()

	table.sort(var1_25, function(arg0_26, arg1_26)
		return arg0_26.time < arg1_26.time
	end)
	arg0_25.commentList:make(function(arg0_27, arg1_27, arg2_27)
		if arg0_27 == UIItemList.EventUpdate then
			local var0_27 = var1_25[arg1_27 + 1]
			local var1_27 = var0_27:HasReply()

			setText(arg2_27:Find("main/reply"), var0_27:GetReplyBtnTxt())

			local var2_27 = var0_27:GetContent()
			local var3_27 = SwitchSpecialChar(var2_27)

			setText(arg2_27:Find("main/content"), HXSet.hxLan(var3_27))
			setText(arg2_27:Find("main/bubble/Text"), var0_27:GetReplyCnt())
			setText(arg2_27:Find("main/time"), var0_27:GetTime())

			if var0_27:GetType() == Instagram.TYPE_PLAYER_COMMENT then
				local var4_27, var5_27 = var0_27:GetIcon()

				setImageSprite(arg2_27:Find("main/head/icon"), GetSpriteFromAtlas(var4_27, var5_27))
			else
				setImageSprite(arg2_27:Find("main/head/icon"), LoadSprite("qicon/" .. var0_27:GetIcon()), false)
			end

			if var1_27 then
				onToggle(arg0_25, arg2_27:Find("main/bubble"), function(arg0_28)
					setActive(arg2_27:Find("replys"), arg0_28)
				end, SFX_PANEL)
				arg0_25:UpdateReplys(arg2_27, var0_27)
				triggerToggle(arg2_27:Find("main/bubble"), true)
			else
				setActive(arg2_27:Find("replys"), false)
				triggerToggle(arg2_27:Find("main/bubble"), false)
			end

			arg2_27:Find("main/bubble"):GetComponent(typeof(Toggle)).enabled = var1_27
		end
	end)
	setActive(arg0_25.centerTF, false)
	setActive(arg0_25.centerTF, true)
	Canvas.ForceUpdateCanvases()
	arg0_25.commentList:align(#var1_25)
end

function var0_0.UpdateReplys(arg0_29, arg1_29, arg2_29)
	local var0_29, var1_29 = arg2_29:GetCanDisplayReply()
	local var2_29 = UIItemList.New(arg1_29:Find("replys"), arg1_29:Find("replys/sub"))

	table.sort(var0_29, function(arg0_30, arg1_30)
		if arg0_30.level == arg1_30.level then
			if arg0_30.time == arg1_30.time then
				return arg0_30.id < arg1_30.id
			else
				return arg0_30.time < arg1_30.time
			end
		else
			return arg0_30.level < arg1_30.level
		end
	end)
	var2_29:make(function(arg0_31, arg1_31, arg2_31)
		if arg0_31 == UIItemList.EventUpdate then
			local var0_31 = var0_29[arg1_31 + 1]

			setImageSprite(arg2_31:Find("head/icon"), LoadSprite("qicon/" .. var0_31:GetIcon()), false)

			local var1_31 = var0_31:GetContent()
			local var2_31 = SwitchSpecialChar(var1_31)

			setText(arg2_31:Find("content"), HXSet.hxLan(var2_31))
		end
	end)
	var2_29:align(#var0_29)
end

function var0_0.OpenCommentPanel(arg0_32)
	local var0_32 = arg0_32.contextData.instagram

	if not var0_32:CanOpenComment() then
		return
	end

	setActive(arg0_32.optionalPanel, true)

	local var1_32 = var0_32:GetOptionComment()

	arg0_32.commentPanel:GetComponent(typeof(Image)).enabled = true
	arg0_32.commentPanel.sizeDelta = Vector2(0, #var1_32 * 142 + 60)

	local var2_32 = UIItemList.New(arg0_32.optionalPanel, arg0_32.optionalPanel:Find("option1"))

	var2_32:make(function(arg0_33, arg1_33, arg2_33)
		if arg0_33 == UIItemList.EventUpdate then
			local var0_33 = arg1_33 + 1
			local var1_33 = var1_32[var0_33].text
			local var2_33 = var1_32[var0_33].id
			local var3_33 = var1_32[var0_33].index

			setText(arg2_33:Find("Text"), HXSet.hxLan(var1_33))
			onButton(arg0_32, arg2_33, function()
				arg0_32:emit(InstagramMediator.ON_COMMENT, var0_32.id, var3_33, var2_33)
				arg0_32:CloseCommentPanel()
			end, SFX_PANEL)
		end
	end)
	var2_32:align(#var1_32)
end

function var0_0.CloseCommentPanel(arg0_35)
	arg0_35.commentPanel:GetComponent(typeof(Image)).enabled = false
	arg0_35.commentPanel.sizeDelta = Vector2(0, 0)

	setActive(arg0_35.optionalPanel, false)
end

function var0_0.onBackPressed(arg0_36)
	if arg0_36.inDetail then
		arg0_36:ExitDetail()

		return
	end

	arg0_36:emit(InstagramMediator.CLOSE_ALL)
end

function var0_0.CloseDetail(arg0_37)
	if arg0_37.inDetail then
		arg0_37:ExitDetail()

		return
	end
end

function var0_0.willExit(arg0_38)
	for iter0_38, iter1_38 in ipairs(arg0_38.toDownloadList or {}) do
		arg0_38.downloadmgr:StopLoader(iter1_38)
	end

	arg0_38.toDownloadList = {}

	pg.UIMgr.GetInstance():UnblurPanel(arg0_38._tf, pg.UIMgr.GetInstance()._normalUIMain)
	arg0_38:ExitDetail()

	for iter2_38, iter3_38 in pairs(arg0_38.sprites) do
		if not IsNil(iter3_38) then
			Object.Destroy(iter3_38)
		end
	end

	arg0_38.sprites = nil

	for iter4_38, iter5_38 in pairs(arg0_38.cards) do
		iter5_38:Dispose()
	end

	arg0_38.cards = {}
end

return var0_0
