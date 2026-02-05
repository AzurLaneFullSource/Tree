local var0_0 = class("IslandTradeInvitePage", import("Mod.Island.View.page.friend.IslandSignInInvitationPage"))

function var0_0.getUIName(arg0_1)
	return "IslandSignInInvitation4TradeUI"
end

function var0_0.AddListeners(arg0_2)
	var0_0.super.AddListeners(arg0_2)
	arg0_2:AddListener(IslandTradegency.INVITE_LIST_UPDATE, arg0_2.OnListUpdate)
end

function var0_0.RemoveListeners(arg0_3)
	var0_0.super.RemoveListeners(arg0_3)
	arg0_3:RemoveListener(IslandTradegency.INVITE_LIST_UPDATE, arg0_3.OnListUpdate)
end

function var0_0.OnListUpdate(arg0_4)
	arg0_4:FlushList()
end

function var0_0.OnUpdateItem(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg0_5.cards[arg2_5]

	if not var0_5 then
		arg0_5:OnInitItem(arg2_5)

		var0_5 = arg0_5.cards[arg2_5]
	end

	local var1_5 = arg0_5:GetIsland()
	local var2_5 = arg0_5.displays[arg1_5 + 1]
	local var3_5 = var1_5:GetTradeAgency():IsInvited(var2_5.id)

	var0_5:Update(var2_5, var3_5)
end

function var0_0.DoInvitation(arg0_6, arg1_6)
	local var0_6, var1_6, var2_6 = arg0_6:GetInfo()

	if var0_6 then
		arg0_6:emit(IslandBaseMediator.TRADE_INVITATION, {
			arg1_6.player.id
		}, var0_6, var2_6)
	end
end

function var0_0.GetInfo(arg0_7)
	local var0_7 = arg0_7:GetSelfIsland()
	local var1_7 = IslandConst.AGORA_MAP_ID
	local var2_7 = pg.island_map[var1_7].name
	local var3_7 = var0_7:GetTradeAgency():GetTodaySellPrice()

	return var1_7, var2_7, var3_7
end

function var0_0.DoShare(arg0_8)
	local var0_8, var1_8, var2_8 = arg0_8:GetInfo()

	if var0_8 then
		arg0_8:emit(IslandBaseMediator.SEND_CHAT, IslandChatConst.CHANNEL_ISLAND, IslandConst.TRADE_SHARE_CODE .. "*" .. var1_8 .. "*" .. var2_8)
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_trade_share_success"))
	end
end

function var0_0.OnOneKey(arg0_9)
	local var0_9 = arg0_9:GetSelfIsland():GetTradeAgency()
	local var1_9 = {}

	for iter0_9, iter1_9 in ipairs(arg0_9.displays) do
		if not var0_9:IsInvited(iter1_9.id) then
			table.insert(var1_9, iter1_9.id)
		end
	end

	local var2_9, var3_9, var4_9 = arg0_9:GetInfo()

	arg0_9:emit(IslandBaseMediator.TRADE_INVITATION, var1_9, var2_9, var4_9)
end

function var0_0.OnShow(arg0_10)
	arg0_10:BlurPanel()
end

function var0_0.OnHide(arg0_11)
	arg0_11:UnBlurPanel()
end

return var0_0
