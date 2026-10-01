local var0_0 = class("Dorm3dInstagramLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dInstagramUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/instagramui_atlas"
	}
	local var1_2 = arg1_2 or arg0_2.contextData or {}

	local function var2_2(arg0_3)
		if noEmptyStr(arg0_3) and not table.contains(var0_2, arg0_3) then
			table.insert(var0_2, arg0_3)
		end
	end

	local function var3_2(arg0_4, arg1_4)
		if noEmptyStr(arg1_4) then
			var2_2(arg0_4 .. arg1_4)
		end
	end

	local function var4_2(arg0_5)
		for iter0_5, iter1_5 in ipairs(arg0_5 or {}) do
			var3_2("qicon/", iter1_5:GetIcon())

			if iter1_5.GetReplyedList then
				var4_2(iter1_5:GetReplyedList())
			end
		end
	end

	local var5_2 = getProxy(Dorm3dInsProxy):GetInstagramList(var1_2.apartmentGroupId) or {}

	for iter0_2, iter1_2 in ipairs(var5_2) do
		var3_2("dorm3dins/", iter1_2:GetPicture())
		var3_2("dorm3dins/", iter1_2:GetBackground())
		var3_2("qicon/", iter1_2:GetIcon())
		var4_2(iter1_2:GetReplyedList())
	end

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.GetInstagramList(arg0_6)
	local var0_6 = arg0_6.contextData.apartmentGroupId

	assert(var0_6, "groupId can not be nil")

	return getProxy(Dorm3dInsProxy):GetInstagramList(var0_6)
end

function var0_0.init(arg0_7)
	arg0_7.listTF = arg0_7._tf:Find("list")
	arg0_7.mainTF = arg0_7._tf:Find("main")
	arg0_7.closeBtn = arg0_7._tf:Find("closeBtn")
	arg0_7.noMsgTF = arg0_7._tf:Find("list/bg/no_msg")
	arg0_7.scrollBarTF = arg0_7._tf:Find("list/bg/scroll_bar")
	arg0_7.list = arg0_7._tf:Find("list/bg/scrollrect"):GetComponent("LScrollRect")
	arg0_7.mainBg = arg0_7._tf:Find("main/left_panel/bg")
	arg0_7.imageTF = arg0_7._tf:Find("main/left_panel/mask/Image"):GetComponent(typeof(Image))
	arg0_7.likeBtn = arg0_7._tf:Find("main/left_panel/heart")
	arg0_7.bubbleTF = arg0_7._tf:Find("main/left_panel/bubble")
	arg0_7.planeTF = arg0_7._tf:Find("main/left_panel/plane")
	arg0_7.likeCntTxt = arg0_7._tf:Find("main/left_panel/zan"):GetComponent(typeof(Text))
	arg0_7.pushTimeTxt = arg0_7._tf:Find("main/left_panel/time"):GetComponent(typeof(Text))
	arg0_7.iconTF = arg0_7._tf:Find("main/right_panel/top/head/icon")
	arg0_7.nameTxt = arg0_7._tf:Find("main/right_panel/top/name"):GetComponent(typeof(Text))
	arg0_7.centerTF = arg0_7._tf:Find("main/right_panel/center")
	arg0_7.contentTxt = arg0_7._tf:Find("main/right_panel/center/Text/Text"):GetComponent(typeof(Text))
	arg0_7.commentList = UIItemList.New(arg0_7._tf:Find("main/right_panel/center/bottom/scroll/content"), arg0_7._tf:Find("main/right_panel/center/bottom/scroll/content/tpl"))
	arg0_7.commentPanel = arg0_7._tf:Find("main/right_panel/last/bg2")
	arg0_7.optionalPanel = arg0_7._tf:Find("main/right_panel/last/bg2/option")
	arg0_7.scroll = arg0_7._tf:Find("main/right_panel/center/bottom/scroll")

	setText(arg0_7._tf:Find("main_bg/Text"), i18n("dorm3d_privatechat_topics"))
	setText(arg0_7.noMsgTF:Find("Text"), i18n("dorm3d_ins_no_msg"))
	arg0_7:OverlayPanel(arg0_7._tf)
end

function var0_0.didEnter(arg0_8)
	setActive(arg0_8.listTF, true)
	setActive(arg0_8.mainTF, false)
	onButton(arg0_8, arg0_8.closeBtn, function()
		if arg0_8.inDetail then
			arg0_8:ExitDetail()

			return
		end

		arg0_8:emit(var0_0.ON_CLOSE)
	end, SFX_PANEL)

	arg0_8.cards = {}

	function arg0_8.list.onInitItem(arg0_10)
		arg0_8:OnInitItem(arg0_10)
	end

	function arg0_8.list.onUpdateItem(arg0_11, arg1_11)
		arg0_8:OnUpdateItem(arg0_11, arg1_11)
	end

	arg0_8:InitCards()
end

function var0_0.OnInitItem(arg0_12, arg1_12)
	local var0_12 = Dorm3dInstagramCard.New(arg1_12)

	onButton(arg0_12, var0_12._go, function()
		if var0_12.instagram:IsLock() then
			return
		end

		arg0_12:EnterDetail(var0_12.instagram)
	end, SFX_PANEL)

	arg0_12.cards[arg1_12] = var0_12
end

function var0_0.OnUpdateItem(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.cards[arg2_14]

	if not var0_14 then
		var0_14 = Dorm3dInstagramCard.New(arg2_14)
		arg0_14.cards[arg2_14] = var0_14
	end

	local var1_14 = arg0_14.display[arg1_14 + 1]

	var0_14:Update(var1_14)
end

function var0_0.InitCards(arg0_15)
	local var0_15 = arg0_15:GetInstagramList()

	arg0_15.display = {}

	for iter0_15, iter1_15 in ipairs(var0_15) do
		if not iter1_15:IsLock() and iter1_15:CanShow() then
			table.insert(arg0_15.display, iter1_15)
		end
	end

	table.sort(arg0_15.display, function(arg0_16, arg1_16)
		local var0_16 = arg0_16:LockState()
		local var1_16 = arg1_16:LockState()

		if var0_16 == var1_16 then
			return var1_16 < var0_16
		else
			return arg0_16.id > arg1_16.id
		end
	end)

	if isActive(arg0_15.listTF) then
		arg0_15.list:SetTotalCount(#arg0_15.display)
	end

	setActive(arg0_15.noMsgTF, #arg0_15.display == 0)
	setActive(arg0_15.scrollBarTF, not #arg0_15.display == 0)
end

function var0_0.EnterDetail(arg0_17, arg1_17)
	arg0_17.contextData.instagram = arg1_17

	arg0_17:InitDetailPage()

	arg0_17.inDetail = true

	setActive(arg0_17.listTF, false)
	setActive(arg0_17.mainTF, true)
	scrollTo(arg0_17.scroll, 0, 1)
end

function var0_0.ExitDetail(arg0_18)
	arg0_18:emit(Dorm3dInstagramMediator.ON_EXIT, arg0_18.contextData.instagram.id)

	arg0_18.contextData.instagram = nil
	arg0_18.inDetail = false

	setActive(arg0_18.listTF, true)
	setActive(arg0_18.mainTF, false)
	arg0_18:ClosePlayerCommentPanel()
end

function var0_0.MarkRead(arg0_19, arg1_19)
	if arg1_19 and not arg1_19:IsRead() then
		arg0_19:emit(Dorm3dInstagramMediator.ON_READ, arg1_19.id)
	end
end

function var0_0.InitDetailPage(arg0_20)
	local var0_20 = arg0_20.contextData.instagram

	arg0_20:MarkRead(var0_20)

	arg0_20.pushTimeTxt.text = var0_20:GetPushTime()

	LoadSpriteAsync("Dorm3dIns/" .. var0_20:GetPicture(), function(arg0_21)
		setImageSprite(arg0_20.imageTF, arg0_21, false)
	end)

	local var1_20 = var0_20:GetBackground()

	if var1_20 and var1_20 ~= "" then
		LoadSpriteAsync("Dorm3dIns/" .. var1_20, function(arg0_22)
			setImageSprite(arg0_20.mainBg, arg0_22, false)
		end)
	end

	setImageSprite(arg0_20.iconTF, LoadSprite("qicon/" .. var0_20:GetIcon()), false)

	arg0_20.nameTxt.text = var0_20:GetName()
	arg0_20.contentTxt.text = var0_20:GetText()

	onToggle(arg0_20, arg0_20.commentPanel, function(arg0_23)
		if arg0_23 then
			arg0_20:OpenPlayerCommentPanel()
		else
			arg0_20:ClosePlayerCommentPanel()
		end
	end, SFX_PANEL)
	arg0_20:UpdateLikeBtn()
	arg0_20:UpdateShareBtn()
	arg0_20:UpdateCommentList()
end

function var0_0.UpdateShareBtn(arg0_24)
	local var0_24 = arg0_24.contextData.instagram

	onButton(arg0_24, arg0_24.planeTF, function()
		arg0_24:emit(Dorm3dInstagramMediator.ON_SHARE, var0_24.id)
	end, SFX_PANEL)
end

function var0_0.UpdateLikeBtn(arg0_26)
	local var0_26 = arg0_26.contextData.instagram

	if not var0_26 then
		return
	end

	local var1_26 = var0_26:IsGood()

	if not var1_26 then
		onButton(arg0_26, arg0_26.likeBtn, function()
			arg0_26:emit(Dorm3dInstagramMediator.ON_LIKE, var0_26.id)
		end, SFX_PANEL)
	else
		removeOnButton(arg0_26.likeBtn)
	end

	setActive(arg0_26.likeBtn:Find("heart"), var1_26)

	arg0_26.likeBtn:GetComponent(typeof(Image)).enabled = not var1_26
end

function var0_0.OnLikeInstagram(arg0_28)
	local var0_28 = arg0_28.contextData.instagram

	if not var0_28 then
		return
	end

	arg0_28:UpdateLikeBtn()

	for iter0_28, iter1_28 in pairs(arg0_28.cards) do
		if iter1_28.instagram.id == var0_28.id then
			iter1_28:Update(var0_28)

			break
		end
	end
end

local function var1_0(arg0_29, arg1_29, arg2_29)
	setText(arg1_29:Find("main/reply"), "reply")

	local var0_29 = SwitchSpecialChar(arg2_29:GetText())

	setText(arg1_29:Find("main/content"), HXSet.hxLan(var0_29))
	setText(arg1_29:Find("main/time"), arg2_29:GetPushTime())

	if isa(arg2_29, InstagramPlayerComment3Dorm) then
		setImageSprite(arg1_29:Find("main/head/icon"), GetSpriteFromAtlas("ui/InstagramUI_atlas", "txdi_3"))
	else
		setImageSprite(arg1_29:Find("main/head/icon"), LoadSprite("qicon/" .. arg2_29:GetIcon()), false)
	end
end

local function var2_0(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg2_30:GetReplyedList()
	local var1_30 = _.select(var0_30, function(arg0_31)
		return arg0_31:CanShow()
	end)
	local var2_30 = UIItemList.New(arg1_30:Find("replys"), arg1_30:Find("replys/sub"))

	table.sort(var1_30, function(arg0_32, arg1_32)
		if arg0_32.time == arg1_32.time then
			return arg0_32.id < arg1_32.id
		else
			return arg0_32.time < arg1_32.time
		end
	end)
	var2_30:make(function(arg0_33, arg1_33, arg2_33)
		if arg0_33 == UIItemList.EventUpdate then
			local var0_33 = var1_30[arg1_33 + 1]

			setImageSprite(arg2_33:Find("head/icon"), LoadSprite("qicon/" .. var0_33:GetIcon()), false)

			local var1_33 = SwitchSpecialChar(var0_33:GetText())

			setText(arg2_33:Find("content"), HXSet.hxLan(var1_33))
		end
	end)
	var2_30:align(#var1_30)
end

local function var3_0(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg2_34:ExistAnyReplay()

	if var0_34 then
		onToggle(arg0_34, arg1_34:Find("main/bubble"), function(arg0_35)
			setActive(arg1_34:Find("replys"), arg0_35)
		end, SFX_PANEL)
		var2_0(arg0_34, arg1_34, arg2_34)
	else
		setActive(arg1_34:Find("replys"), false)
	end

	triggerToggle(arg1_34:Find("main/bubble"), var0_34)

	arg1_34:Find("main/bubble"):GetComponent(typeof(Toggle)).enabled = var0_34
end

function var0_0.UpdateCommentList(arg0_36)
	local var0_36 = arg0_36.contextData.instagram

	if not var0_36 then
		return
	end

	local var1_36 = var0_36:GetReplyedList()
	local var2_36 = _.select(var1_36, function(arg0_37)
		return arg0_37:CanShow()
	end)

	table.sort(var2_36, function(arg0_38, arg1_38)
		return arg0_38.time < arg1_38.time
	end)
	arg0_36.commentList:make(function(arg0_39, arg1_39, arg2_39)
		if arg0_39 == UIItemList.EventUpdate then
			local var0_39 = var2_36[arg1_39 + 1]

			var1_0(arg0_36, arg2_39, var0_39)
			var3_0(arg0_36, arg2_39, var0_39)
		end
	end)
	setActive(arg0_36.centerTF, false)
	setActive(arg0_36.centerTF, true)
	Canvas.ForceUpdateCanvases()
	arg0_36.commentList:align(#var2_36)
end

function var0_0.OpenPlayerCommentPanel(arg0_40)
	local var0_40 = arg0_40.contextData.instagram

	if not var0_40:ExistAnyReplyable() then
		return
	end

	setActive(arg0_40.optionalPanel, true)

	local var1_40 = var0_40:GetReplyableList()

	arg0_40.commentPanel:GetComponent(typeof(Image)).enabled = true
	arg0_40.commentPanel.sizeDelta = Vector2(0, #var1_40 * 142 + 60)

	local var2_40 = UIItemList.New(arg0_40.optionalPanel, arg0_40.optionalPanel:Find("option1"))

	var2_40:make(function(arg0_41, arg1_41, arg2_41)
		if arg0_41 == UIItemList.EventUpdate then
			local var0_41 = var1_40[arg1_41 + 1]
			local var1_41 = var0_41:GetText()
			local var2_41 = var0_41.id
			local var3_41 = var0_41.index

			setText(arg2_41:Find("Text"), HXSet.hxLan(var1_41))
			onButton(arg0_40, arg2_41, function()
				arg0_40:emit(Dorm3dInstagramMediator.ON_DISCUSS, var0_40.id, var2_41, var3_41)
				arg0_40:ClosePlayerCommentPanel()
			end, SFX_PANEL)
		end
	end)
	var2_40:align(#var1_40)
end

function var0_0.ClosePlayerCommentPanel(arg0_43)
	arg0_43.commentPanel:GetComponent(typeof(Image)).enabled = false
	arg0_43.commentPanel.sizeDelta = Vector2(0, 0)

	setActive(arg0_43.optionalPanel, false)
end

function var0_0.onBackPressed(arg0_44)
	if arg0_44.inDetail then
		arg0_44:ExitDetail()

		return
	end

	var0_0.super.onBackPressed(arg0_44)
end

function var0_0.willExit(arg0_45)
	if arg0_45.inDetail then
		arg0_45:ExitDetail()
	end

	for iter0_45, iter1_45 in pairs(arg0_45.cards) do
		iter1_45:Dispose()
	end

	arg0_45.cards = {}
end

return var0_0
