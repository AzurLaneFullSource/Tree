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

	arg0_6.cards[arg1_6] = var0_6
end

function var0_0.OpenMorePanel(arg0_9, arg1_9, arg2_9)
	arg0_9.isOpenMore = true

	setActive(arg0_9.morePanel, true)
	arg0_9.morePanel:SetAsLastSibling()

	arg0_9.morePanel.localPosition = arg2_9 - Vector3(110, 0, 0)
	arg0_9.whiteBtn = arg0_9.morePanel:Find("white")
	arg0_9.blackBtn = arg0_9.morePanel:Find("black")
	arg0_9.delBtn = arg0_9.morePanel:Find("del")

	arg0_9:InitMoreBtns(arg1_9)
end

function var0_0.InitMoreBtns(arg0_10, arg1_10)
	onButton(arg0_10, arg0_10.whiteBtn, function()
		arg0_10:emit(IslandMediator.ADD_WHITE_LIST, arg1_10.id)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.blackBtn, function()
		arg0_10:emit(IslandMediator.ADD_BLACK_LIST, arg1_10.id)
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10.delBtn, function()
		arg0_10:emit(IslandMediator.REMOVE_FRIEND, arg1_10.id)
	end, SFX_PANEL)
end

function var0_0.CloseMorePanel(arg0_14)
	arg0_14.isOpenMore = false

	setActive(arg0_14.morePanel, false)
end

function var0_0.OnUpdateItem(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.cards[arg2_15]

	if not var0_15 then
		arg0_15:OnInitItem(arg2_15)

		var0_15 = arg0_15.cards[arg2_15]
	end

	local var1_15 = arg0_15.displays[arg1_15 + 1]

	var0_15:Update(var1_15)
end

function var0_0.Show(arg0_16)
	var0_0.super.Show(arg0_16)
	arg0_16:InitList()
end

function var0_0.Hide(arg0_17)
	var0_0.super.Hide(arg0_17)

	if arg0_17.isOpenMore then
		arg0_17:CloseMorePanel()
	end
end

function var0_0.Flush(arg0_18)
	arg0_18:InitList()
end

function var0_0.GetData(arg0_19, arg1_19)
	local var0_19 = getProxy(FriendProxy):getAllFriends()

	if #var0_19 <= 0 then
		return arg1_19({})
	end

	local var1_19 = {}

	for iter0_19, iter1_19 in pairs(var0_19) do
		table.insert(var1_19, iter1_19.id)
	end

	arg0_19:emit(IslandMediator.GET_GIFT_TAG, var1_19, function()
		arg1_19(var0_19)
	end)
end

function var0_0.InitList(arg0_21)
	pg.UIMgr.GetInstance():LoadingOn()
	arg0_21:GetData(function(arg0_22)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0_21.displays = arg0_22

		arg0_21._scrollrect:SetTotalCount(#arg0_21.displays)
	end)
end

function var0_0.OnDestroy(arg0_23)
	for iter0_23, iter1_23 in pairs(arg0_23.cards) do
		iter1_23:Dispose()
	end

	arg0_23.cards = nil
end

return var0_0
