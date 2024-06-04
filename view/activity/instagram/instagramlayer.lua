local var0 = class("InstagramLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "InstagramUI"
end

function var0.SetProxy(arg0, arg1)
	arg0.proxy = arg1
	arg0.instagramVOById = arg1:GetData()
	arg0.messages = arg1:GetMessages()
end

function var0.UpdateSelectedInstagram(arg0, arg1)
	if arg0.contextData.instagram and arg0.contextData.instagram.id == arg1 then
		arg0.contextData.instagram = arg0.instagramVOById[arg1]

		arg0:UpdateCommentList()
	end
end

function var0.init(arg0)
	local var0 = GameObject.Find("MainObject")

	arg0.downloadmgr = BulletinBoardMgr.Inst
	arg0.listTF = arg0:findTF("list")
	arg0.listAnimationPlayer = arg0._tf:GetComponent(typeof(Animation))
	arg0.listDftAniEvent = arg0._tf:GetComponent(typeof(DftAniEvent))
	arg0.mainTF = arg0:findTF("main")
	arg0.closeBtn = arg0:findTF("close_btn")
	arg0.helpBtn = arg0:findTF("list/bg/help")
	arg0.noMsgTF = arg0:findTF("list/bg/no_msg")
	arg0.list = arg0:findTF("list/bg/scrollrect"):GetComponent("LScrollRect")
	arg0.imageTF = arg0:findTF("main/left_panel/Image"):GetComponent(typeof(RawImage))
	arg0.likeBtn = arg0:findTF("main/left_panel/heart")
	arg0.bubbleTF = arg0:findTF("main/left_panel/bubble")
	arg0.planeTF = arg0:findTF("main/left_panel/plane")
	arg0.likeCntTxt = arg0:findTF("main/left_panel/zan"):GetComponent(typeof(Text))
	arg0.pushTimeTxt = arg0:findTF("main/left_panel/time"):GetComponent(typeof(Text))
	arg0.iconTF = arg0:findTF("main/right_panel/top/head/icon")
	arg0.nameTxt = arg0:findTF("main/right_panel/top/name"):GetComponent(typeof(Text))
	arg0.centerTF = arg0:findTF("main/right_panel/center")
	arg0.contentTxt = arg0:findTF("main/right_panel/center/Text/Text"):GetComponent(typeof(Text))
	arg0.commentList = UIItemList.New(arg0:findTF("main/right_panel/center/bottom/scroll/content"), arg0:findTF("main/right_panel/center/bottom/scroll/content/tpl"))
	arg0.commentPanel = arg0:findTF("main/right_panel/last/bg2")
	arg0.optionalPanel = arg0:findTF("main/right_panel/last/bg2/option")
	arg0.scroll = arg0:findTF("main/right_panel/center/bottom/scroll")
	arg0.sprites = {}
	arg0.timers = {}
	arg0.toDownloadList = {}

	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.SECOND_LAYER
	})
end

function var0.SetImageByUrl(arg0, arg1, arg2, arg3)
	if not arg1 or arg1 == "" then
		setActive(arg2.gameObject, false)

		if arg3 then
			arg3()
		end
	else
		setActive(arg2.gameObject, true)

		local var0 = arg0.sprites[arg1]

		if var0 then
			arg2.texture = var0

			if arg3 then
				arg3()
			end
		else
			arg2.enabled = false

			arg0.downloadmgr:GetTexture("ins", "1", arg1, UnityEngine.Events.UnityAction_UnityEngine_Texture(function(arg0)
				if arg0.exited then
					return
				end

				if not arg0.sprites then
					return
				end

				arg0.sprites[arg1] = arg0
				arg2.texture = arg0
				arg2.enabled = true

				if arg3 then
					arg3()
				end
			end))
			table.insert(arg0.toDownloadList, arg1)
		end
	end
end

function var0.didEnter(arg0)
	arg0.animTF:GetComponent(typeof(UIEventTrigger)).didEnter:AddListener(function()
		arg0:SetUp()
	end)

	arg0.cards = {}

	function arg0.list.onInitItem(arg0)
		local var0 = InstagramCard.New(arg0, arg0)

		onButton(arg0, var0._go, function()
			arg0:EnterDetail(var0.instagram)
		end, SFX_PANEL)

		arg0.cards[arg0] = var0
	end

	function arg0.list.onUpdateItem(arg0, arg1)
		local var0 = arg0.cards[arg1]

		if not var0 then
			var0 = InstagramCard.New(arg1)
			arg0.cards[arg1] = var0
		end

		local var1 = arg0.display[arg0 + 1]
		local var2 = arg0.instagramVOById[var1.id]

		var0:Update(var2)
	end

	arg0:InitList()
end

function var0.SetUp(arg0)
	onButton(arg0, arg0.closeBtn, function()
		arg0:OnClose()
	end, SFX_PANEL)
	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.music_juus.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:OnClose()
	end, SFX_PANEL)
end

function var0.OnClose(arg0)
	if arg0.inDetail then
		arg0:ExitDetail()
	else
		arg0:PlayExitAnimation(function()
			arg0:emit(var0.ON_CLOSE)
		end)
	end
end

function var0.InitList(arg0)
	arg0.display = _.map(arg0.messages, function(arg0)
		return {
			time = arg0:GetLasterUpdateTime(),
			id = arg0.id,
			order = arg0:GetSortIndex()
		}
	end)

	table.sort(arg0.display, function(arg0, arg1)
		if arg0.order == arg1.order then
			return arg0.id > arg1.id
		else
			return arg0.order > arg1.order
		end
	end)
	arg0.list:SetTotalCount(#arg0.display)
	setActive(arg0.noMsgTF, #arg0.display == 0)
end

function var0.UpdateInstagram(arg0, arg1, arg2)
	for iter0, iter1 in pairs(arg0.cards) do
		if iter1.instagram and iter1.instagram.id == arg1 then
			iter1:Update(arg0.instagramVOById[arg1], arg2)
		end
	end
end

function var0.EnterDetail(arg0, arg1)
	arg0.contextData.instagram = arg1

	arg0:InitDetailPage()

	arg0.inDetail = true

	pg.SystemGuideMgr.GetInstance():Play(arg0)
	arg0:RefreshInstagram()
	arg0.listAnimationPlayer:Play("anim_snsLoad_list_out")
	scrollTo(arg0.scroll, 0, 1)
end

function var0.ExitDetail(arg0)
	local var0 = arg0.contextData.instagram

	if var0 and not var0:IsReaded() then
		arg0:emit(InstagramMediator.ON_READED, var0.id)
	end

	arg0.contextData.instagram = nil
	arg0.inDetail = false

	arg0:CloseCommentPanel()
	arg0.listAnimationPlayer:Play("anim_snsLoad_list_in")
end

function var0.RefreshInstagram(arg0)
	local var0 = arg0.contextData.instagram
	local var1 = var0:GetFastestRefreshTime()

	if var1 and var1 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
		arg0:emit(InstagramMediator.ON_REPLY_UPDATE, var0.id)
	end
end

function var0.InitDetailPage(arg0)
	local var0 = arg0.contextData.instagram

	arg0:SetImageByUrl(var0:GetImage(), arg0.imageTF)
	onButton(arg0, arg0.planeTF, function()
		arg0:emit(InstagramMediator.ON_SHARE, var0.id)
	end, SFX_PANEL)

	arg0.pushTimeTxt.text = var0:GetPushTime()

	setImageSprite(arg0.iconTF, LoadSprite("qicon/" .. var0:GetIcon()), false)

	arg0.nameTxt.text = var0:GetName()
	arg0.contentTxt.text = var0:GetContent()

	onToggle(arg0, arg0.commentPanel, function(arg0)
		if arg0 then
			arg0:OpenCommentPanel()
		else
			arg0:CloseCommentPanel()
		end
	end, SFX_PANEL)
	arg0:UpdateLikeBtn()
	arg0:UpdateCommentList()
end

function var0.UpdateLikeBtn(arg0)
	local var0 = arg0.contextData.instagram
	local var1 = var0:IsLiking()

	if not var1 then
		onButton(arg0, arg0.likeBtn, function()
			arg0:emit(InstagramMediator.ON_LIKE, var0.id)
		end, SFX_PANEL)
	else
		removeOnButton(arg0.likeBtn)
	end

	setActive(arg0.likeBtn:Find("heart"), var1)

	arg0.likeBtn:GetComponent(typeof(Image)).enabled = not var1
	arg0.likeCntTxt.text = i18n("ins_word_like", var0:GetLikeCnt())
end

function var0.UpdateCommentList(arg0)
	local var0 = arg0.contextData.instagram

	if not var0 then
		return
	end

	local var1, var2 = var0:GetCanDisplayComments()

	table.sort(var1, function(arg0, arg1)
		return arg0.time < arg1.time
	end)
	arg0.commentList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var1[arg1 + 1]
			local var1 = var0:HasReply()

			setText(arg2:Find("main/reply"), var0:GetReplyBtnTxt())

			local var2 = var0:GetContent()
			local var3 = SwitchSpecialChar(var2)

			setText(arg2:Find("main/content"), HXSet.hxLan(var3))
			setText(arg2:Find("main/bubble/Text"), var0:GetReplyCnt())
			setText(arg2:Find("main/time"), var0:GetTime())

			if var0:GetType() == Instagram.TYPE_PLAYER_COMMENT then
				local var4, var5 = var0:GetIcon()

				setImageSprite(arg2:Find("main/head/icon"), GetSpriteFromAtlas(var4, var5))
			else
				setImageSprite(arg2:Find("main/head/icon"), LoadSprite("qicon/" .. var0:GetIcon()), false)
			end

			if var1 then
				onToggle(arg0, arg2:Find("main/bubble"), function(arg0)
					setActive(arg2:Find("replys"), arg0)
				end, SFX_PANEL)
				arg0:UpdateReplys(arg2, var0)
				triggerToggle(arg2:Find("main/bubble"), true)
			else
				setActive(arg2:Find("replys"), false)
				triggerToggle(arg2:Find("main/bubble"), false)
			end

			arg2:Find("main/bubble"):GetComponent(typeof(Toggle)).enabled = var1
		end
	end)
	setActive(arg0.centerTF, false)
	setActive(arg0.centerTF, true)
	Canvas.ForceUpdateCanvases()
	arg0.commentList:align(#var1)
end

function var0.UpdateReplys(arg0, arg1, arg2)
	local var0, var1 = arg2:GetCanDisplayReply()
	local var2 = UIItemList.New(arg1:Find("replys"), arg1:Find("replys/sub"))

	table.sort(var0, function(arg0, arg1)
		if arg0.level == arg1.level then
			if arg0.time == arg1.time then
				return arg0.id < arg1.id
			else
				return arg0.time < arg1.time
			end
		else
			return arg0.level < arg1.level
		end
	end)
	var2:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			setImageSprite(arg2:Find("head/icon"), LoadSprite("qicon/" .. var0:GetIcon()), false)

			local var1 = var0:GetContent()
			local var2 = SwitchSpecialChar(var1)

			setText(arg2:Find("content"), HXSet.hxLan(var2))
		end
	end)
	var2:align(#var0)
end

function var0.OpenCommentPanel(arg0)
	local var0 = arg0.contextData.instagram

	if not var0:CanOpenComment() then
		return
	end

	setActive(arg0.optionalPanel, true)

	local var1 = var0:GetOptionComment()

	arg0.commentPanel.sizeDelta = Vector2(642.6, (#var1 + 1) * 150)

	local var2 = UIItemList.New(arg0.optionalPanel, arg0.optionalPanel:Find("option1"))

	var2:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1 + 1
			local var1 = var1[var0].text
			local var2 = var1[var0].id
			local var3 = var1[var0].index

			setText(arg2:Find("Text"), HXSet.hxLan(var1))
			onButton(arg0, arg2, function()
				arg0:emit(InstagramMediator.ON_COMMENT, var0.id, var3, var2)
				arg0:CloseCommentPanel()
			end, SFX_PANEL)
		end
	end)
	var2:align(#var1)
end

function var0.CloseCommentPanel(arg0)
	arg0.commentPanel.sizeDelta = Vector2(642.6, 150)

	setActive(arg0.optionalPanel, false)
end

function var0.onBackPressed(arg0)
	if arg0.inDetail then
		arg0:ExitDetail()

		return
	end

	var0.super.onBackPressed(arg0)
end

function var0.willExit(arg0)
	for iter0, iter1 in ipairs(arg0.toDownloadList or {}) do
		arg0.downloadmgr:StopLoader(iter1)
	end

	arg0.toDownloadList = {}

	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, pg.UIMgr.GetInstance()._normalUIMain)
	arg0:ExitDetail()

	for iter2, iter3 in pairs(arg0.sprites) do
		if not IsNil(iter3) then
			Object.Destroy(iter3)
		end
	end

	arg0.sprites = nil

	for iter4, iter5 in pairs(arg0.cards) do
		iter5:Dispose()
	end

	arg0.cards = {}
end

return var0
