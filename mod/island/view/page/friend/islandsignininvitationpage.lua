local var0_0 = class("IslandSignInInvitationPage", import("...base.IslandBasePage"))
local var1_0 = 1
local var2_0 = 2

function var0_0.getUIName(arg0_1)
	return "IslandSignInInvitationUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.shareBtn = arg0_2._tf:Find("frame/public")
	arg0_2.onkeyBtn = arg0_2._tf:Find("frame/onkey")
	arg0_2.closeBtn = arg0_2._tf:Find("frame/close")
	arg0_2.toggles = {
		[var1_0] = arg0_2._tf:Find("frame/toggles/1"),
		[var2_0] = arg0_2._tf:Find("frame/toggles/2")
	}
	arg0_2.texts = {
		[var1_0] = arg0_2._tf:Find("frame/toggles/1/Text"):GetComponent(typeof(Text)),
		[var2_0] = arg0_2._tf:Find("frame/toggles/2/Text"):GetComponent(typeof(Text))
	}
	arg0_2.names = {
		i18n("island_friend"),
		i18n("island_guild")
	}
	arg0_2._scrollrect = arg0_2._tf:Find("frame/scrollrect"):GetComponent("LScrollRect")

	function arg0_2._scrollrect.onInitItem(arg0_3)
		arg0_2:OnInitItem(arg0_3)
	end

	function arg0_2._scrollrect.onUpdateItem(arg0_4, arg1_4)
		arg0_2:OnUpdateItem(arg0_4, arg1_4)
	end

	setText(arg0_2._tf:Find("frame/public/Text"), i18n("island_public_invitation"))
	setText(arg0_2._tf:Find("frame/onkey/Text"), i18n("island_onekey_invitation"))
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5._tf, function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.closeBtn, function()
		arg0_5:Hide()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.shareBtn, function()
		arg0_5:DoShare()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.onkeyBtn, function()
		arg0_5:OnOneKey()
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

function var0_0.DoShare(arg0_11)
	if arg0_11:GetIsland():GetAccessAgency():HasOpenFlag(IslandConst.OPEN_SIGNIN) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_public_invitation_1"))

		return
	end

	arg0_11:emit(IslandMediator.SHARE_SIGNIN)
end

function var0_0.OnOneKey(arg0_12)
	local var0_12 = {}

	for iter0_12, iter1_12 in ipairs(arg0_12.displays) do
		table.insert(var0_12, iter1_12.id)
	end

	arg0_12:emit(IslandMediator.SIGN_IN_INVITATION, var0_12)
end

function var0_0.AddListeners(arg0_13)
	arg0_13:AddListener(GAME.ISLAND_SIGN_IN_INVITATION_DONE, arg0_13.OnInvitation)
	arg0_13:AddListener(GAME.ISLAND_SIGN_SHARE_SIGNIN_DONE, arg0_13.OnShare)
end

function var0_0.RemoveListeners(arg0_14)
	arg0_14:RemoveListener(GAME.ISLAND_SIGN_IN_INVITATION_DONE, arg0_14.OnInvitation)
	arg0_14:RemoveListener(GAME.ISLAND_SIGN_SHARE_SIGNIN_DONE, arg0_14.OnShare)
end

function var0_0.OnInvitation(arg0_15)
	arg0_15:FlushList()
end

function var0_0.OnShare(arg0_16)
	return
end

function var0_0.GetDisplayData(arg0_17, arg1_17)
	local var0_17 = {}

	if arg1_17 == var1_0 then
		var0_17 = getProxy(FriendProxy):getAllFriends()
	elseif arg1_17 == var2_0 then
		local var1_17 = getProxy(GuildProxy):getRawData()

		var0_17 = var1_17 and var1_17:getSortMemberWithoutSelf() or {}
	end

	return var0_17
end

function var0_0.SwitchPage(arg0_18, arg1_18)
	arg0_18.pageIndex = arg1_18

	arg0_18:FlushList()
end

function var0_0.OnInitItem(arg0_19, arg1_19)
	local var0_19 = IslandSignInInvitationCard.New(arg1_19)

	onButton(arg0_19, var0_19.btn, function()
		arg0_19:DoInvitation(var0_19)
	end, SFX_PANEL)

	arg0_19.cards[arg1_19] = var0_19
end

function var0_0.DoInvitation(arg0_21, arg1_21)
	arg0_21:emit(IslandMediator.SIGN_IN_INVITATION, {
		arg1_21.player.id
	})
end

function var0_0.OnUpdateItem(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22.cards[arg2_22]

	if not var0_22 then
		arg0_22:OnInitItem(arg2_22)

		var0_22 = arg0_22.cards[arg2_22]
	end

	local var1_22 = arg0_22:GetIsland()
	local var2_22 = arg0_22.displays[arg1_22 + 1]
	local var3_22 = var1_22:GetSignInAgency():IsInvited(var2_22.id)

	var0_22:Update(var2_22, var3_22)
end

function var0_0.Show(arg0_23)
	var0_0.super.Show(arg0_23)
	triggerToggle(arg0_23.toggles[var1_0], true)
end

function var0_0.FlushList(arg0_24)
	arg0_24.displays = arg0_24:GetDisplayData(arg0_24.pageIndex)

	arg0_24._scrollrect:SetTotalCount(#arg0_24.displays)
end

function var0_0.OnDestroy(arg0_25)
	ClearLScrollrect(arg0_25._scrollrect)

	for iter0_25, iter1_25 in pairs(arg0_25.cards) do
		iter1_25:Dispose()
	end

	arg0_25.cards = nil
end

return var0_0
