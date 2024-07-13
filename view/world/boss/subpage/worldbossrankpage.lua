local var0_0 = class("WorldBossRankPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "WorldBossRankUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.numberTF1 = arg0_2:findTF("frame/list/number1")

	setActive(arg0_2.numberTF1, false)

	arg0_2.numberTF2 = arg0_2:findTF("frame/list/number2")

	setActive(arg0_2.numberTF2, false)

	arg0_2.numberTF3 = arg0_2:findTF("frame/list/number3")

	setActive(arg0_2.numberTF3, false)

	arg0_2.numberTF4 = arg0_2:findTF("frame/list/number4")

	setActive(arg0_2.numberTF4, false)
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Update(arg0_5, arg1_5, arg2_5)
	arg0_5.bossProxy = arg1_5
	arg0_5.bossId = arg2_5

	arg0_5:Show()
	arg0_5:UpdateRankList()
end

function var0_0.UpdateRankList(arg0_6)
	local var0_6 = arg0_6.bossId
	local var1_6 = arg0_6.bossProxy:GetRank(var0_6)

	if var1_6 == nil then
		arg0_6:emit(WorldBossMediator.ON_RANK_LIST, var0_6)
	else
		arg0_6:UpdateRanks(var1_6)
	end
end

function var0_0.UpdateRanks(arg0_7, arg1_7)
	for iter0_7 = 1, 3 do
		local var0_7 = arg1_7[iter0_7]
		local var1_7 = arg0_7["numberTF" .. iter0_7]

		setActive(var1_7, var0_7)

		if var0_7 then
			arg0_7:UpdateRank(var1_7, var0_7)
		end
	end

	local var2_7 = getProxy(PlayerProxy):getRawData().id
	local var3_7

	for iter1_7, iter2_7 in ipairs(arg1_7) do
		if iter2_7.id == var2_7 then
			var3_7 = iter2_7
			var3_7.number = iter1_7

			break
		end
	end

	if var3_7 then
		arg0_7:UpdateMyRank(arg0_7.numberTF4, var3_7)
	else
		setActive(arg0_7.numberTF4, false)
	end
end

function var0_0.UpdateRank(arg0_8, arg1_8, arg2_8)
	setText(arg1_8:Find("Text"), arg2_8.name)
	setText(arg1_8:Find("damage/Text"), arg2_8.damage)
	setActive(arg1_8:Find("view"), arg2_8.id ~= getProxy(PlayerProxy):getRawData().id)
	onButton(arg0_8, arg1_8:Find("view"), function()
		arg0_8:emit(WorldBossMediator.FETCH_RANK_FORMATION, arg2_8.id, arg0_8.bossId)
	end, SFX_PANEL)
end

function var0_0.UpdateMyRank(arg0_10, arg1_10, arg2_10)
	arg0_10:UpdateRank(arg1_10, arg2_10)
	setText(arg1_10:Find("number"), arg2_10.number)
end

function var0_0.isActive(arg0_11)
	return isActive(arg0_11._tf)
end

function var0_0.OnDestroy(arg0_12)
	return
end

return var0_0
