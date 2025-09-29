local var0_0 = class("IslandFriendListPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandFriendListUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.morePanel = arg0_2:findTF("scrollrect/content/more_panel")
	arg0_2.whiteBtn = arg0_2.morePanel:Find("white")
	arg0_2.blackBtn = arg0_2.morePanel:Find("black")
	arg0_2.delBtn = arg0_2.morePanel:Find("del")
	arg0_2.cards = {}
	arg0_2._scrollrect = arg0_2:findTF("scrollrect"):GetComponent("LScrollRect")

	function arg0_2._scrollrect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2._scrollrect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end

	setText(arg0_2.morePanel:Find("white/Text"), i18n("island_whiteList"))
	setText(arg0_2.morePanel:Find("black/Text"), i18n("island_blackList"))

	if arg0_2.delBtn then
		setText(arg0_2.morePanel:Find("del/Text"), i18n("island_btn_label_del"))
	end
end

function var0_0.CreateCard(arg0_5, arg1_5)
	return IslandFriendCard.New(arg1_5)
end

function var0_0.OnInitItem(arg0_6, arg1_6)
	local var0_6 = arg0_6:CreateCard(arg1_6)

	onButton(arg0_6, var0_6.visitBtn, function()
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandVisit(playerId))
		arg0_6:emit(IslandMediator.ENTER_ISLAND, var0_6.player.id)
	end, SFX_PANEL)
	onButton(arg0_6, var0_6.moreBtn, function()
		if arg0_6.isOpenMore then
			arg0_6:CloseMorePanel()
		else
			local var0_8 = var0_6.moreBtn.parent.parent:InverseTransformPoint(var0_6.moreBtn.position)

			arg0_6:OpenMorePanel(var0_6.player, var0_8)
		end
	end, SFX_PANEL)
	onButton(arg0_6, var0_6.cardBtn, function()
		arg0_6:emit(IslandMediator.OPEN_PAGE, "IslandOtherCardPage", {
			var0_6.player.id
		})
	end, SFX_PANEL)

	arg0_6.cards[arg1_6] = var0_6
end

function var0_0.OpenMorePanel(arg0_10, arg1_10, arg2_10)
	arg0_10.isOpenMore = true

	setActive(arg0_10.morePanel, true)
	arg0_10.morePanel:SetAsLastSibling()

	arg0_10.morePanel.localPosition = arg2_10 - Vector3(110, 0, 0)
	arg0_10.whiteBtn = arg0_10.morePanel:Find("white")
	arg0_10.blackBtn = arg0_10.morePanel:Find("black")
	arg0_10.delBtn = arg0_10.morePanel:Find("del")

	arg0_10:InitMoreBtns(arg1_10)
end

function var0_0.InitMoreBtns(arg0_11, arg1_11)
	onButton(arg0_11, arg0_11.whiteBtn, function()
		arg0_11:emit(IslandMediator.ADD_WHITE_LIST, arg1_11.id)
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.blackBtn, function()
		arg0_11:emit(IslandMediator.ADD_BLACK_LIST, arg1_11.id)
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.delBtn, function()
		pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_COMMON_MSGBOX, {
			contentText = i18n("remove_friend_tip"),
			onConfirm = function()
				arg0_11:emit(IslandMediator.REMOVE_FRIEND, arg1_11.id)
			end
		})
	end, SFX_PANEL)
end

function var0_0.CloseMorePanel(arg0_16)
	arg0_16.isOpenMore = false

	setActive(arg0_16.morePanel, false)
end

function var0_0.OnUpdateItem(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17.cards[arg2_17]

	if not var0_17 then
		arg0_17:OnInitItem(arg2_17)

		var0_17 = arg0_17.cards[arg2_17]
	end

	local var1_17 = arg0_17.displays[arg1_17 + 1]

	var0_17:Update(var1_17)
end

function var0_0.Show(arg0_18)
	var0_0.super.Show(arg0_18)
	arg0_18:InitList()
end

function var0_0.Hide(arg0_19)
	var0_0.super.Hide(arg0_19)

	if arg0_19.isOpenMore then
		arg0_19:CloseMorePanel()
	end
end

function var0_0.Flush(arg0_20)
	arg0_20:InitList()
end

function var0_0.GetData(arg0_21, arg1_21)
	local var0_21 = getProxy(FriendProxy):getAllFriends()

	if #var0_21 <= 0 then
		return arg1_21({})
	end

	local var1_21 = {}

	for iter0_21, iter1_21 in pairs(var0_21) do
		table.insert(var1_21, iter1_21.id)
	end

	arg0_21:emit(IslandMediator.GET_GIFT_TAG, var1_21, function()
		arg1_21(var0_21)
	end)
end

function var0_0.InitList(arg0_23)
	pg.UIMgr.GetInstance():LoadingOn()
	arg0_23:GetData(function(arg0_24)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0_23.displays = arg0_24

		arg0_23._scrollrect:SetTotalCount(#arg0_23.displays)
	end)
end

function var0_0.OnDestroy(arg0_25)
	ClearLScrollrect(arg0_25._scrollrect)

	for iter0_25, iter1_25 in pairs(arg0_25.cards) do
		iter1_25:Dispose()
	end

	arg0_25.cards = nil
end

return var0_0
