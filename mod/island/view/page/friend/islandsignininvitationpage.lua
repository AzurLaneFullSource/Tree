local var0_0 = class("IslandSignInInvitationPage", import("...base.IslandBasePage"))
local var1_0 = 1
local var2_0 = 2

function var0_0.getUIName(arg0_1)
	return "IslandSignInInvitationUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.shareBtn = arg0_2:findTF("frame/public")
	arg0_2.onkeyBtn = arg0_2:findTF("frame/onkey")
	arg0_2.closeBtn = arg0_2:findTF("frame/close")
	arg0_2.toggles = {
		[var1_0] = arg0_2:findTF("frame/toggles/1"),
		[var2_0] = arg0_2:findTF("frame/toggles/2")
	}
	arg0_2.texts = {
		[var1_0] = arg0_2:findTF("frame/toggles/1/Text"):GetComponent(typeof(Text)),
		[var2_0] = arg0_2:findTF("frame/toggles/2/Text"):GetComponent(typeof(Text))
	}
	arg0_2.names = {
		i18n("island_friend"),
		i18n("island_guild")
	}
	arg0_2._scrollrect = arg0_2:findTF("frame/scrollrect"):GetComponent("LScrollRect")

	function arg0_2._scrollrect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2._scrollrect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end

	setText(arg0_2:findTF("frame/public/Text"), i18n("island_public_invitation"))
	setText(arg0_2:findTF("frame/onkey/Text"), i18n("island_onekey_invitation"))
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5._tf, function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.closeBtn, function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.shareBtn, function()
		if arg0_5:GetIsland():GetAccessAgency():HasOpenFlag(IslandConst.OPEN_SIGNIN) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_public_invitation_1"))

			return
		end

		arg0_5:emit(IslandMediator.SHARE_SIGNIN)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.onkeyBtn, function()
		local var0_9 = {}

		for iter0_9, iter1_9 in ipairs(arg0_5.displays) do
			table.insert(var0_9, iter1_9.id)
		end

		arg0_5:emit(IslandMediator.SIGN_IN_INVITATION, var0_9)
	end, SFX_PANEL)

	arg0_5.cards = {}

	for iter0_5, iter1_5 in pairs(arg0_5.toggles) do
		local var0_5 = arg0_5.texts[iter0_5]
		local var1_5 = arg0_5.names[iter0_5]

		onToggle(arg0_5, iter1_5, function(arg0_10)
			if arg0_10 then
				arg0_5:SwitchPage(iter0_5)
			end

			var0_5.text = arg0_10 and setColorStr(var1_5, "#FEFEFE") or setColorStr(var1_5, "#6B6E75")
		end, SFX_PANEL)

		var0_5.text = setColorStr(var1_5, "#6B6E75")
	end
end

function var0_0.AddListeners(arg0_11)
	arg0_11:AddListener(GAME.ISLAND_SIGN_IN_INVITATION_DONE, arg0_11.OnInvitation)
	arg0_11:AddListener(GAME.ISLAND_SIGN_SHARE_SIGNIN_DONE, arg0_11.OnShare)
end

function var0_0.RemoveListeners(arg0_12)
	arg0_12:RemoveListener(GAME.ISLAND_SIGN_IN_INVITATION_DONE, arg0_12.OnInvitation)
	arg0_12:RemoveListener(GAME.ISLAND_SIGN_SHARE_SIGNIN_DONE, arg0_12.OnShare)
end

function var0_0.OnInvitation(arg0_13)
	arg0_13:FlushList()
end

function var0_0.OnShare(arg0_14)
	return
end

function var0_0.GetDisplayData(arg0_15, arg1_15)
	local var0_15 = {}

	if arg1_15 == var1_0 then
		var0_15 = getProxy(FriendProxy):getAllFriends()
	elseif arg1_15 == var2_0 then
		local var1_15 = getProxy(GuildProxy):getRawData()

		var0_15 = var1_15 and var1_15:getSortMemberWithoutSelf() or {}
	end

	return var0_15
end

function var0_0.SwitchPage(arg0_16, arg1_16)
	arg0_16.pageIndex = arg1_16

	arg0_16:FlushList()
end

function var0_0.OnInitItem(arg0_17, arg1_17)
	local var0_17 = IslandSignInInvitationCard.New(arg1_17)

	onButton(arg0_17, var0_17.btn, function()
		arg0_17:emit(IslandMediator.SIGN_IN_INVITATION, {
			var0_17.player.id
		})
	end, SFX_PANEL)

	arg0_17.cards[arg1_17] = var0_17
end

function var0_0.OnUpdateItem(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19.cards[arg2_19]

	if not var0_19 then
		arg0_19:OnInitItem(arg2_19)

		var0_19 = arg0_19.cards[arg2_19]
	end

	local var1_19 = arg0_19:GetIsland()
	local var2_19 = arg0_19.displays[arg1_19 + 1]

	var0_19:Update(var2_19, var1_19)
end

function var0_0.Show(arg0_20)
	var0_0.super.Show(arg0_20)
	triggerToggle(arg0_20.toggles[var1_0], true)
end

function var0_0.FlushList(arg0_21)
	arg0_21.displays = arg0_21:GetDisplayData(arg0_21.pageIndex)

	arg0_21._scrollrect:SetTotalCount(#arg0_21.displays)
end

function var0_0.OnDestroy(arg0_22)
	ClearLScrollrect(arg0_22._scrollrect)

	for iter0_22, iter1_22 in pairs(arg0_22.cards) do
		iter1_22:Dispose()
	end

	arg0_22.cards = nil
end

return var0_0
