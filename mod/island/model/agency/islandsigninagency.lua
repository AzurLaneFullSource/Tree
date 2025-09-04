local var0_0 = class("IslandSignInAgency", import(".IslandBaseAgency"))

var0_0.GIFT_CNT_UPDATE = "IslandSignInAgency:GIFT_CNT_UPDATE"
var0_0.SIGN_CNT_UPDATE = "IslandSignInAgency:SIGN_CNT_UPDATE"
var0_0.OTHER_FETCH_CNT_UPDATE = "IslandSignInAgency:OTHER_FETCH_CNT_UPDATE"

function var0_0.OnInit(arg0_1, arg1_1)
	local var0_1 = arg0_1:GetHost():GetAblityAgency():GetSignInGiftAddition()

	arg0_1.defaultGiftCnt = pg.island_set.daily_gift_drop_num.key_value_int + var0_1
	arg0_1.maxFetchCnt = pg.island_set.daily_gift_get_max.key_value_int
	arg0_1.giftEndTime = arg1_1.tree_gift_timestamp or 0
	arg0_1.giftCnt = arg1_1.tree_gift_count or 0
	arg0_1.inviteList = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.tree_gift_invited or {}) do
		table.insert(arg0_1.inviteList, iter1_1)
	end

	arg0_1.fetchedList = {}

	arg0_1:UpdateFetchedList(arg1_1.tree_gift_visitor or {})

	arg0_1.fetchCnt = 0
	arg0_1.otherFetchCnt = 0
	arg0_1.signInCnt = 0
end

function var0_0.UpdateGiftEndTime(arg0_2, arg1_2)
	arg0_2.giftEndTime = arg1_2
end

function var0_0.IsMaxFetchCnt(arg0_3)
	return arg0_3.otherFetchCnt >= arg0_3.maxFetchCnt
end

function var0_0.InInInviteList(arg0_4, arg1_4)
	return table.contains(arg0_4.inviteList, arg1_4)
end

function var0_0.InitPrivateData(arg0_5, arg1_5)
	for iter0_5, iter1_5 in ipairs(arg1_5.daily_list) do
		if iter1_5.key == IslandConst.DL_SIGNINSYS_FETCH_CNT then
			arg0_5.fetchCnt = iter1_5.value
		elseif iter1_5.key == IslandConst.DL_SIGNINSYS_OTHER_FETCH_CNT then
			arg0_5.otherFetchCnt = iter1_5.value
		elseif iter1_5.key == IslandConst.DL_SIGNINSYS_CNT then
			arg0_5.signInCnt = iter1_5.value
		end
	end
end

function var0_0.UpdateFetchedList(arg0_6, arg1_6)
	arg0_6.fetchedList = {}

	for iter0_6 = 1, arg0_6.defaultGiftCnt do
		arg0_6.fetchedList[iter0_6] = arg1_6[iter0_6] or -1
	end
end

function var0_0.SetGiftCnt(arg0_7, arg1_7)
	arg0_7.giftCnt = arg1_7

	arg0_7:DispatchEvent(var0_0.GIFT_CNT_UPDATE, arg0_7.giftCnt)
end

function var0_0.GetGiftCnt(arg0_8)
	return arg0_8.giftCnt
end

function var0_0.GetGiftModel(arg0_9)
	return pg.island_unit_item[var0_0.AGORA_GIFT_ID].model
end

function var0_0.CanSignIn(arg0_10)
	return arg0_10.signInCnt == 0
end

function var0_0.MarkSignIn(arg0_11)
	arg0_11:UpdateSignInCnt(1)
	arg0_11:UpdateFetchedList({})
	arg0_11:SetGiftCnt(arg0_11.defaultGiftCnt)
end

function var0_0.UpdateSignInCnt(arg0_12, arg1_12)
	arg0_12.signInCnt = arg1_12

	arg0_12:DispatchEvent(var0_0.SIGN_CNT_UPDATE, arg0_12.signInCnt)
end

function var0_0.SetFetchCnt(arg0_13)
	arg0_13.fetchCnt = 1
end

function var0_0.SetOtherFetchCnt(arg0_14)
	local var0_14 = arg0_14.otherFetchCnt + 1

	arg0_14:UpdateOtherFetchCnt(var0_14)
end

function var0_0.UpdateOtherFetchCnt(arg0_15, arg1_15)
	arg0_15.otherFetchCnt = arg1_15

	arg0_15:DispatchEvent(var0_0.OTHER_FETCH_CNT_UPDATE)
end

function var0_0.GetLeftOtherFetchCnt(arg0_16)
	return arg0_16.maxFetchCnt - arg0_16.otherFetchCnt
end

function var0_0.GetMaxOtheFetchcnt(arg0_17)
	return arg0_17.maxFetchCnt
end

function var0_0.CanInvite(arg0_18)
	return arg0_18.fetchCnt > 0
end

function var0_0.IsSigned(arg0_19)
	return arg0_19.signInCnt > 0
end

function var0_0.CanSelectGift(arg0_20)
	return not arg0_20:CanSignIn() and arg0_20.fetchCnt == 0
end

function var0_0.IsExpiration(arg0_21)
	return arg0_21.giftEndTime <= pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.CanSelectGiftInPos(arg0_22, arg1_22)
	if not arg0_22:CanSelectGift() then
		return false
	end

	if arg1_22 <= 0 or arg1_22 > arg0_22.defaultGiftCnt then
		return false
	end

	return arg0_22.fetchedList[arg1_22] == 0
end

function var0_0.Visible(arg0_23, arg1_23)
	if arg1_23 <= 0 or arg1_23 > arg0_23.defaultGiftCnt then
		return false
	end

	return arg0_23.fetchedList[arg1_23] == 0
end

function var0_0.IsOutRange(arg0_24, arg1_24)
	return arg1_24 <= 0 or arg1_24 > arg0_24.defaultGiftCnt
end

function var0_0.IsFetched(arg0_25, arg1_25)
	return table.contains(arg0_25.fetchedList, arg1_25)
end

function var0_0.GetNextCanSignInTime(arg0_26)
	if arg0_26:CanSignIn() then
		return 0
	else
		return GetZeroTime()
	end
end

function var0_0.IsInvited(arg0_27, arg1_27)
	return table.contains(arg0_27.inviteList, arg1_27)
end

function var0_0.AddInviter(arg0_28, arg1_28)
	if not arg0_28:IsInvited(arg1_28) then
		table.insert(arg0_28.inviteList, arg1_28)
	end
end

function var0_0.ResetSignInCnt(arg0_29)
	arg0_29:UpdateSignInCnt(0)

	arg0_29.fetchCnt = 0

	arg0_29:UpdateOtherFetchCnt(0)

	arg0_29.inviteList = {}

	arg0_29:DispatchEvent(var0_0.SIGN_CNT_UPDATE, arg0_29.signInCnt)
end

return var0_0
