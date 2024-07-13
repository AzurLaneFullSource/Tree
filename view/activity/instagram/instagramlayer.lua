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
	arg0_4.listAnimationPlayer = arg0_4._tf:GetComponent(typeof(Animation))
	arg0_4.listDftAniEvent = arg0_4._tf:GetComponent(typeof(DftAniEvent))
	arg0_4.mainTF = arg0_4:findTF("main")
	arg0_4.closeBtn = arg0_4:findTF("close_btn")
	arg0_4.helpBtn = arg0_4:findTF("list/bg/help")
	arg0_4.noMsgTF = arg0_4:findTF("list/bg/no_msg")
	arg0_4.list = arg0_4:findTF("list/bg/scrollrect"):GetComponent("LScrollRect")
	arg0_4.imageTF = arg0_4:findTF("main/left_panel/Image"):GetComponent(typeof(RawImage))
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
	arg0_4.sprites = {}
	arg0_4.timers = {}
	arg0_4.toDownloadList = {}

	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf, false, {
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
	arg0_7.animTF:GetComponent(typeof(UIEventTrigger)).didEnter:AddListener(function()
		arg0_7:SetUp()
	end)

	arg0_7.cards = {}

	function arg0_7.list.onInitItem(arg0_9)
		local var0_9 = InstagramCard.New(arg0_9, arg0_7)

		onButton(arg0_7, var0_9._go, function()
			arg0_7:EnterDetail(var0_9.instagram)
		end, SFX_PANEL)

		arg0_7.cards[arg0_9] = var0_9
	end

	function arg0_7.list.onUpdateItem(arg0_11, arg1_11)
		local var0_11 = arg0_7.cards[arg1_11]

		if not var0_11 then
			var0_11 = InstagramCard.New(arg1_11)
			arg0_7.cards[arg1_11] = var0_11
		end

		local var1_11 = arg0_7.display[arg0_11 + 1]
		local var2_11 = arg0_7.instagramVOById[var1_11.id]

		var0_11:Update(var2_11)
	end

	arg0_7:InitList()
end

function var0_0.SetUp(arg0_12)
	onButton(arg0_12, arg0_12.closeBtn, function()
		arg0_12:OnClose()
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.music_juus.tip
		})
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12._tf, function()
		arg0_12:OnClose()
	end, SFX_PANEL)
end

function var0_0.OnClose(arg0_16)
	if arg0_16.inDetail then
		arg0_16:ExitDetail()
	else
		arg0_16:PlayExitAnimation(function()
			arg0_16:emit(var0_0.ON_CLOSE)
		end)
	end
end

function var0_0.InitList(arg0_18)
	arg0_18.display = _.map(arg0_18.messages, function(arg0_19)
		return {
			time = arg0_19:GetLasterUpdateTime(),
			id = arg0_19.id,
			order = arg0_19:GetSortIndex()
		}
	end)

	table.sort(arg0_18.display, function(arg0_20, arg1_20)
		if arg0_20.order == arg1_20.order then
			return arg0_20.id > arg1_20.id
		else
			return arg0_20.order > arg1_20.order
		end
	end)
	arg0_18.list:SetTotalCount(#arg0_18.display)
	setActive(arg0_18.noMsgTF, #arg0_18.display == 0)
end

function var0_0.UpdateInstagram(arg0_21, arg1_21, arg2_21)
	for iter0_21, iter1_21 in pairs(arg0_21.cards) do
		if iter1_21.instagram and iter1_21.instagram.id == arg1_21 then
			iter1_21:Update(arg0_21.instagramVOById[arg1_21], arg2_21)
		end
	end
end

function var0_0.EnterDetail(arg0_22, arg1_22)
	arg0_22.contextData.instagram = arg1_22

	arg0_22:InitDetailPage()

	arg0_22.inDetail = true

	pg.SystemGuideMgr.GetInstance():Play(arg0_22)
	arg0_22:RefreshInstagram()
	arg0_22.listAnimationPlayer:Play("anim_snsLoad_list_out")
	scrollTo(arg0_22.scroll, 0, 1)
end

function var0_0.ExitDetail(arg0_23)
	local var0_23 = arg0_23.contextData.instagram

	if var0_23 and not var0_23:IsReaded() then
		arg0_23:emit(InstagramMediator.ON_READED, var0_23.id)
	end

	arg0_23.contextData.instagram = nil
	arg0_23.inDetail = false

	arg0_23:CloseCommentPanel()
	arg0_23.listAnimationPlayer:Play("anim_snsLoad_list_in")
end

function var0_0.RefreshInstagram(arg0_24)
	local var0_24 = arg0_24.contextData.instagram
	local var1_24 = var0_24:GetFastestRefreshTime()

	if var1_24 and var1_24 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
		arg0_24:emit(InstagramMediator.ON_REPLY_UPDATE, var0_24.id)
	end
end

function var0_0.InitDetailPage(arg0_25)
	local var0_25 = arg0_25.contextData.instagram

	arg0_25:SetImageByUrl(var0_25:GetImage(), arg0_25.imageTF)
	onButton(arg0_25, arg0_25.planeTF, function()
		arg0_25:emit(InstagramMediator.ON_SHARE, var0_25.id)
	end, SFX_PANEL)

	arg0_25.pushTimeTxt.text = var0_25:GetPushTime()

	setImageSprite(arg0_25.iconTF, LoadSprite("qicon/" .. var0_25:GetIcon()), false)

	arg0_25.nameTxt.text = var0_25:GetName()
	arg0_25.contentTxt.text = var0_25:GetContent()

	onToggle(arg0_25, arg0_25.commentPanel, function(arg0_27)
		if arg0_27 then
			arg0_25:OpenCommentPanel()
		else
			arg0_25:CloseCommentPanel()
		end
	end, SFX_PANEL)
	arg0_25:UpdateLikeBtn()
	arg0_25:UpdateCommentList()
end

function var0_0.UpdateLikeBtn(arg0_28)
	local var0_28 = arg0_28.contextData.instagram
	local var1_28 = var0_28:IsLiking()

	if not var1_28 then
		onButton(arg0_28, arg0_28.likeBtn, function()
			arg0_28:emit(InstagramMediator.ON_LIKE, var0_28.id)
		end, SFX_PANEL)
	else
		removeOnButton(arg0_28.likeBtn)
	end

	setActive(arg0_28.likeBtn:Find("heart"), var1_28)

	arg0_28.likeBtn:GetComponent(typeof(Image)).enabled = not var1_28
	arg0_28.likeCntTxt.text = i18n("ins_word_like", var0_28:GetLikeCnt())
end

function var0_0.UpdateCommentList(arg0_30)
	local var0_30 = arg0_30.contextData.instagram

	if not var0_30 then
		return
	end

	local var1_30, var2_30 = var0_30:GetCanDisplayComments()

	table.sort(var1_30, function(arg0_31, arg1_31)
		return arg0_31.time < arg1_31.time
	end)
	arg0_30.commentList:make(function(arg0_32, arg1_32, arg2_32)
		if arg0_32 == UIItemList.EventUpdate then
			local var0_32 = var1_30[arg1_32 + 1]
			local var1_32 = var0_32:HasReply()

			setText(arg2_32:Find("main/reply"), var0_32:GetReplyBtnTxt())

			local var2_32 = var0_32:GetContent()
			local var3_32 = SwitchSpecialChar(var2_32)

			setText(arg2_32:Find("main/content"), HXSet.hxLan(var3_32))
			setText(arg2_32:Find("main/bubble/Text"), var0_32:GetReplyCnt())
			setText(arg2_32:Find("main/time"), var0_32:GetTime())

			if var0_32:GetType() == Instagram.TYPE_PLAYER_COMMENT then
				local var4_32, var5_32 = var0_32:GetIcon()

				setImageSprite(arg2_32:Find("main/head/icon"), GetSpriteFromAtlas(var4_32, var5_32))
			else
				setImageSprite(arg2_32:Find("main/head/icon"), LoadSprite("qicon/" .. var0_32:GetIcon()), false)
			end

			if var1_32 then
				onToggle(arg0_30, arg2_32:Find("main/bubble"), function(arg0_33)
					setActive(arg2_32:Find("replys"), arg0_33)
				end, SFX_PANEL)
				arg0_30:UpdateReplys(arg2_32, var0_32)
				triggerToggle(arg2_32:Find("main/bubble"), true)
			else
				setActive(arg2_32:Find("replys"), false)
				triggerToggle(arg2_32:Find("main/bubble"), false)
			end

			arg2_32:Find("main/bubble"):GetComponent(typeof(Toggle)).enabled = var1_32
		end
	end)
	setActive(arg0_30.centerTF, false)
	setActive(arg0_30.centerTF, true)
	Canvas.ForceUpdateCanvases()
	arg0_30.commentList:align(#var1_30)
end

function var0_0.UpdateReplys(arg0_34, arg1_34, arg2_34)
	local var0_34, var1_34 = arg2_34:GetCanDisplayReply()
	local var2_34 = UIItemList.New(arg1_34:Find("replys"), arg1_34:Find("replys/sub"))

	table.sort(var0_34, function(arg0_35, arg1_35)
		if arg0_35.level == arg1_35.level then
			if arg0_35.time == arg1_35.time then
				return arg0_35.id < arg1_35.id
			else
				return arg0_35.time < arg1_35.time
			end
		else
			return arg0_35.level < arg1_35.level
		end
	end)
	var2_34:make(function(arg0_36, arg1_36, arg2_36)
		if arg0_36 == UIItemList.EventUpdate then
			local var0_36 = var0_34[arg1_36 + 1]

			setImageSprite(arg2_36:Find("head/icon"), LoadSprite("qicon/" .. var0_36:GetIcon()), false)

			local var1_36 = var0_36:GetContent()
			local var2_36 = SwitchSpecialChar(var1_36)

			setText(arg2_36:Find("content"), HXSet.hxLan(var2_36))
		end
	end)
	var2_34:align(#var0_34)
end

function var0_0.OpenCommentPanel(arg0_37)
	local var0_37 = arg0_37.contextData.instagram

	if not var0_37:CanOpenComment() then
		return
	end

	setActive(arg0_37.optionalPanel, true)

	local var1_37 = var0_37:GetOptionComment()

	arg0_37.commentPanel.sizeDelta = Vector2(642.6, (#var1_37 + 1) * 150)

	local var2_37 = UIItemList.New(arg0_37.optionalPanel, arg0_37.optionalPanel:Find("option1"))

	var2_37:make(function(arg0_38, arg1_38, arg2_38)
		if arg0_38 == UIItemList.EventUpdate then
			local var0_38 = arg1_38 + 1
			local var1_38 = var1_37[var0_38].text
			local var2_38 = var1_37[var0_38].id
			local var3_38 = var1_37[var0_38].index

			setText(arg2_38:Find("Text"), HXSet.hxLan(var1_38))
			onButton(arg0_37, arg2_38, function()
				arg0_37:emit(InstagramMediator.ON_COMMENT, var0_37.id, var3_38, var2_38)
				arg0_37:CloseCommentPanel()
			end, SFX_PANEL)
		end
	end)
	var2_37:align(#var1_37)
end

function var0_0.CloseCommentPanel(arg0_40)
	arg0_40.commentPanel.sizeDelta = Vector2(642.6, 150)

	setActive(arg0_40.optionalPanel, false)
end

function var0_0.onBackPressed(arg0_41)
	if arg0_41.inDetail then
		arg0_41:ExitDetail()

		return
	end

	var0_0.super.onBackPressed(arg0_41)
end

function var0_0.willExit(arg0_42)
	for iter0_42, iter1_42 in ipairs(arg0_42.toDownloadList or {}) do
		arg0_42.downloadmgr:StopLoader(iter1_42)
	end

	arg0_42.toDownloadList = {}

	pg.UIMgr.GetInstance():UnblurPanel(arg0_42._tf, pg.UIMgr.GetInstance()._normalUIMain)
	arg0_42:ExitDetail()

	for iter2_42, iter3_42 in pairs(arg0_42.sprites) do
		if not IsNil(iter3_42) then
			Object.Destroy(iter3_42)
		end
	end

	arg0_42.sprites = nil

	for iter4_42, iter5_42 in pairs(arg0_42.cards) do
		iter5_42:Dispose()
	end

	arg0_42.cards = {}
end

return var0_0
