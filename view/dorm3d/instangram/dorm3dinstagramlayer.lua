local var0_0 = class("Dorm3dInstagramLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dInstagramUI"
end

function var0_0.GetInstagramList(arg0_2)
	local var0_2 = arg0_2.contextData.apartmentGroupId

	assert(var0_2, "groupId can not be nil")

	return getProxy(Dorm3dInsProxy):GetInstagramList(var0_2)
end

function var0_0.init(arg0_3)
	arg0_3.listTF = arg0_3._tf:Find("list")
	arg0_3.mainTF = arg0_3._tf:Find("main")
	arg0_3.closeBtn = arg0_3._tf:Find("closeBtn")
	arg0_3.noMsgTF = arg0_3._tf:Find("list/bg/no_msg")
	arg0_3.scrollBarTF = arg0_3._tf:Find("list/bg/scroll_bar")
	arg0_3.list = arg0_3._tf:Find("list/bg/scrollrect"):GetComponent("LScrollRect")
	arg0_3.mainBg = arg0_3._tf:Find("main/left_panel/bg")
	arg0_3.imageTF = arg0_3._tf:Find("main/left_panel/mask/Image"):GetComponent(typeof(Image))
	arg0_3.likeBtn = arg0_3._tf:Find("main/left_panel/heart")
	arg0_3.bubbleTF = arg0_3._tf:Find("main/left_panel/bubble")
	arg0_3.planeTF = arg0_3._tf:Find("main/left_panel/plane")
	arg0_3.likeCntTxt = arg0_3._tf:Find("main/left_panel/zan"):GetComponent(typeof(Text))
	arg0_3.pushTimeTxt = arg0_3._tf:Find("main/left_panel/time"):GetComponent(typeof(Text))
	arg0_3.iconTF = arg0_3._tf:Find("main/right_panel/top/head/icon")
	arg0_3.nameTxt = arg0_3._tf:Find("main/right_panel/top/name"):GetComponent(typeof(Text))
	arg0_3.centerTF = arg0_3._tf:Find("main/right_panel/center")
	arg0_3.contentTxt = arg0_3._tf:Find("main/right_panel/center/Text/Text"):GetComponent(typeof(Text))
	arg0_3.commentList = UIItemList.New(arg0_3._tf:Find("main/right_panel/center/bottom/scroll/content"), arg0_3._tf:Find("main/right_panel/center/bottom/scroll/content/tpl"))
	arg0_3.commentPanel = arg0_3._tf:Find("main/right_panel/last/bg2")
	arg0_3.optionalPanel = arg0_3._tf:Find("main/right_panel/last/bg2/option")
	arg0_3.scroll = arg0_3._tf:Find("main/right_panel/center/bottom/scroll")

	setText(arg0_3._tf:Find("main_bg/Text"), i18n("dorm3d_privatechat_topics"))
	setText(arg0_3.noMsgTF:Find("Text"), i18n("dorm3d_ins_no_msg"))
	arg0_3:OverlayPanel(arg0_3._tf)
end

function var0_0.didEnter(arg0_4)
	setActive(arg0_4.listTF, true)
	setActive(arg0_4.mainTF, false)
	onButton(arg0_4, arg0_4.closeBtn, function()
		if arg0_4.inDetail then
			arg0_4:ExitDetail()

			return
		end

		arg0_4:emit(var0_0.ON_CLOSE)
	end, SFX_PANEL)

	arg0_4.cards = {}

	function arg0_4.list.onInitItem(arg0_6)
		arg0_4:OnInitItem(arg0_6)
	end

	function arg0_4.list.onUpdateItem(arg0_7, arg1_7)
		arg0_4:OnUpdateItem(arg0_7, arg1_7)
	end

	arg0_4:InitCards()
end

function var0_0.OnInitItem(arg0_8, arg1_8)
	local var0_8 = Dorm3dInstagramCard.New(arg1_8)

	onButton(arg0_8, var0_8._go, function()
		if var0_8.instagram:IsLock() then
			return
		end

		arg0_8:EnterDetail(var0_8.instagram)
	end, SFX_PANEL)

	arg0_8.cards[arg1_8] = var0_8
end

function var0_0.OnUpdateItem(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.cards[arg2_10]

	if not var0_10 then
		var0_10 = Dorm3dInstagramCard.New(arg2_10)
		arg0_10.cards[arg2_10] = var0_10
	end

	local var1_10 = arg0_10.display[arg1_10 + 1]

	var0_10:Update(var1_10)
end

function var0_0.InitCards(arg0_11)
	local var0_11 = arg0_11:GetInstagramList()

	arg0_11.display = {}

	for iter0_11, iter1_11 in ipairs(var0_11) do
		if not iter1_11:IsLock() and iter1_11:CanShow() then
			table.insert(arg0_11.display, iter1_11)
		end
	end

	table.sort(arg0_11.display, function(arg0_12, arg1_12)
		local var0_12 = arg0_12:LockState()
		local var1_12 = arg1_12:LockState()

		if var0_12 == var1_12 then
			return var1_12 < var0_12
		else
			return arg0_12.id > arg1_12.id
		end
	end)

	if isActive(arg0_11.listTF) then
		arg0_11.list:SetTotalCount(#arg0_11.display)
	end

	setActive(arg0_11.noMsgTF, #arg0_11.display == 0)
	setActive(arg0_11.scrollBarTF, not #arg0_11.display == 0)
end

function var0_0.EnterDetail(arg0_13, arg1_13)
	arg0_13.contextData.instagram = arg1_13

	arg0_13:InitDetailPage()

	arg0_13.inDetail = true

	setActive(arg0_13.listTF, false)
	setActive(arg0_13.mainTF, true)
	scrollTo(arg0_13.scroll, 0, 1)
end

function var0_0.ExitDetail(arg0_14)
	arg0_14:emit(Dorm3dInstagramMediator.ON_EXIT, arg0_14.contextData.instagram.id)

	arg0_14.contextData.instagram = nil
	arg0_14.inDetail = false

	setActive(arg0_14.listTF, true)
	setActive(arg0_14.mainTF, false)
	arg0_14:ClosePlayerCommentPanel()
end

function var0_0.MarkRead(arg0_15, arg1_15)
	if arg1_15 and not arg1_15:IsRead() then
		arg0_15:emit(Dorm3dInstagramMediator.ON_READ, arg1_15.id)
	end
end

function var0_0.InitDetailPage(arg0_16)
	local var0_16 = arg0_16.contextData.instagram

	arg0_16:MarkRead(var0_16)

	arg0_16.pushTimeTxt.text = var0_16:GetPushTime()

	LoadSpriteAsync("Dorm3dIns/" .. var0_16:GetPicture(), function(arg0_17)
		setImageSprite(arg0_16.imageTF, arg0_17, false)
	end)

	local var1_16 = var0_16:GetBackground()

	if var1_16 and var1_16 ~= "" then
		LoadSpriteAsync("Dorm3dIns/" .. var1_16, function(arg0_18)
			setImageSprite(arg0_16.mainBg, arg0_18, false)
		end)
	end

	setImageSprite(arg0_16.iconTF, LoadSprite("qicon/" .. var0_16:GetIcon()), false)

	arg0_16.nameTxt.text = var0_16:GetName()
	arg0_16.contentTxt.text = var0_16:GetText()

	onToggle(arg0_16, arg0_16.commentPanel, function(arg0_19)
		if arg0_19 then
			arg0_16:OpenPlayerCommentPanel()
		else
			arg0_16:ClosePlayerCommentPanel()
		end
	end, SFX_PANEL)
	arg0_16:UpdateLikeBtn()
	arg0_16:UpdateShareBtn()
	arg0_16:UpdateCommentList()
end

function var0_0.UpdateShareBtn(arg0_20)
	local var0_20 = arg0_20.contextData.instagram

	onButton(arg0_20, arg0_20.planeTF, function()
		arg0_20:emit(Dorm3dInstagramMediator.ON_SHARE, var0_20.id)
	end, SFX_PANEL)
end

function var0_0.UpdateLikeBtn(arg0_22)
	local var0_22 = arg0_22.contextData.instagram

	if not var0_22 then
		return
	end

	local var1_22 = var0_22:IsGood()

	if not var1_22 then
		onButton(arg0_22, arg0_22.likeBtn, function()
			arg0_22:emit(Dorm3dInstagramMediator.ON_LIKE, var0_22.id)
		end, SFX_PANEL)
	else
		removeOnButton(arg0_22.likeBtn)
	end

	setActive(arg0_22.likeBtn:Find("heart"), var1_22)

	arg0_22.likeBtn:GetComponent(typeof(Image)).enabled = not var1_22
end

function var0_0.OnLikeInstagram(arg0_24)
	local var0_24 = arg0_24.contextData.instagram

	if not var0_24 then
		return
	end

	arg0_24:UpdateLikeBtn()

	for iter0_24, iter1_24 in pairs(arg0_24.cards) do
		if iter1_24.instagram.id == var0_24.id then
			iter1_24:Update(var0_24)

			break
		end
	end
end

local function var1_0(arg0_25, arg1_25, arg2_25)
	setText(arg1_25:Find("main/reply"), "reply")

	local var0_25 = SwitchSpecialChar(arg2_25:GetText())

	setText(arg1_25:Find("main/content"), HXSet.hxLan(var0_25))
	setText(arg1_25:Find("main/time"), arg2_25:GetPushTime())

	if isa(arg2_25, InstagramPlayerComment3Dorm) then
		setImageSprite(arg1_25:Find("main/head/icon"), GetSpriteFromAtlas("ui/InstagramUI_atlas", "txdi_3"))
	else
		setImageSprite(arg1_25:Find("main/head/icon"), LoadSprite("qicon/" .. arg2_25:GetIcon()), false)
	end
end

local function var2_0(arg0_26, arg1_26, arg2_26)
	local var0_26 = arg2_26:GetReplyedList()
	local var1_26 = _.select(var0_26, function(arg0_27)
		return arg0_27:CanShow()
	end)
	local var2_26 = UIItemList.New(arg1_26:Find("replys"), arg1_26:Find("replys/sub"))

	table.sort(var1_26, function(arg0_28, arg1_28)
		if arg0_28.time == arg1_28.time then
			return arg0_28.id < arg1_28.id
		else
			return arg0_28.time < arg1_28.time
		end
	end)
	var2_26:make(function(arg0_29, arg1_29, arg2_29)
		if arg0_29 == UIItemList.EventUpdate then
			local var0_29 = var1_26[arg1_29 + 1]

			setImageSprite(arg2_29:Find("head/icon"), LoadSprite("qicon/" .. var0_29:GetIcon()), false)

			local var1_29 = SwitchSpecialChar(var0_29:GetText())

			setText(arg2_29:Find("content"), HXSet.hxLan(var1_29))
		end
	end)
	var2_26:align(#var1_26)
end

local function var3_0(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg2_30:ExistAnyReplay()

	if var0_30 then
		onToggle(arg0_30, arg1_30:Find("main/bubble"), function(arg0_31)
			setActive(arg1_30:Find("replys"), arg0_31)
		end, SFX_PANEL)
		var2_0(arg0_30, arg1_30, arg2_30)
	else
		setActive(arg1_30:Find("replys"), false)
	end

	triggerToggle(arg1_30:Find("main/bubble"), var0_30)

	arg1_30:Find("main/bubble"):GetComponent(typeof(Toggle)).enabled = var0_30
end

function var0_0.UpdateCommentList(arg0_32)
	local var0_32 = arg0_32.contextData.instagram

	if not var0_32 then
		return
	end

	local var1_32 = var0_32:GetReplyedList()
	local var2_32 = _.select(var1_32, function(arg0_33)
		return arg0_33:CanShow()
	end)

	table.sort(var2_32, function(arg0_34, arg1_34)
		return arg0_34.time < arg1_34.time
	end)
	arg0_32.commentList:make(function(arg0_35, arg1_35, arg2_35)
		if arg0_35 == UIItemList.EventUpdate then
			local var0_35 = var2_32[arg1_35 + 1]

			var1_0(arg0_32, arg2_35, var0_35)
			var3_0(arg0_32, arg2_35, var0_35)
		end
	end)
	setActive(arg0_32.centerTF, false)
	setActive(arg0_32.centerTF, true)
	Canvas.ForceUpdateCanvases()
	arg0_32.commentList:align(#var2_32)
end

function var0_0.OpenPlayerCommentPanel(arg0_36)
	local var0_36 = arg0_36.contextData.instagram

	if not var0_36:ExistAnyReplyable() then
		return
	end

	setActive(arg0_36.optionalPanel, true)

	local var1_36 = var0_36:GetReplyableList()

	arg0_36.commentPanel:GetComponent(typeof(Image)).enabled = true
	arg0_36.commentPanel.sizeDelta = Vector2(0, #var1_36 * 142 + 60)

	local var2_36 = UIItemList.New(arg0_36.optionalPanel, arg0_36.optionalPanel:Find("option1"))

	var2_36:make(function(arg0_37, arg1_37, arg2_37)
		if arg0_37 == UIItemList.EventUpdate then
			local var0_37 = var1_36[arg1_37 + 1]
			local var1_37 = var0_37:GetText()
			local var2_37 = var0_37.id
			local var3_37 = var0_37.index

			setText(arg2_37:Find("Text"), HXSet.hxLan(var1_37))
			onButton(arg0_36, arg2_37, function()
				arg0_36:emit(Dorm3dInstagramMediator.ON_DISCUSS, var0_36.id, var2_37, var3_37)
				arg0_36:ClosePlayerCommentPanel()
			end, SFX_PANEL)
		end
	end)
	var2_36:align(#var1_36)
end

function var0_0.ClosePlayerCommentPanel(arg0_39)
	arg0_39.commentPanel:GetComponent(typeof(Image)).enabled = false
	arg0_39.commentPanel.sizeDelta = Vector2(0, 0)

	setActive(arg0_39.optionalPanel, false)
end

function var0_0.onBackPressed(arg0_40)
	if arg0_40.inDetail then
		arg0_40:ExitDetail()

		return
	end

	var0_0.super.onBackPressed(arg0_40)
end

function var0_0.willExit(arg0_41)
	if arg0_41.inDetail then
		arg0_41:ExitDetail()
	end

	for iter0_41, iter1_41 in pairs(arg0_41.cards) do
		iter1_41:Dispose()
	end

	arg0_41.cards = {}
end

return var0_0
