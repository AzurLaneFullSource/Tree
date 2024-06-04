local var0 = class("WorldBossRankPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "WorldBossRankUI"
end

function var0.OnLoaded(arg0)
	arg0.numberTF1 = arg0:findTF("frame/list/number1")

	setActive(arg0.numberTF1, false)

	arg0.numberTF2 = arg0:findTF("frame/list/number2")

	setActive(arg0.numberTF2, false)

	arg0.numberTF3 = arg0:findTF("frame/list/number3")

	setActive(arg0.numberTF3, false)

	arg0.numberTF4 = arg0:findTF("frame/list/number4")

	setActive(arg0.numberTF4, false)
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Update(arg0, arg1, arg2)
	arg0.bossProxy = arg1
	arg0.bossId = arg2

	arg0:Show()
	arg0:UpdateRankList()
end

function var0.UpdateRankList(arg0)
	local var0 = arg0.bossId
	local var1 = arg0.bossProxy:GetRank(var0)

	if var1 == nil then
		arg0:emit(WorldBossMediator.ON_RANK_LIST, var0)
	else
		arg0:UpdateRanks(var1)
	end
end

function var0.UpdateRanks(arg0, arg1)
	for iter0 = 1, 3 do
		local var0 = arg1[iter0]
		local var1 = arg0["numberTF" .. iter0]

		setActive(var1, var0)

		if var0 then
			arg0:UpdateRank(var1, var0)
		end
	end

	local var2 = getProxy(PlayerProxy):getRawData().id
	local var3

	for iter1, iter2 in ipairs(arg1) do
		if iter2.id == var2 then
			var3 = iter2
			var3.number = iter1

			break
		end
	end

	if var3 then
		arg0:UpdateMyRank(arg0.numberTF4, var3)
	else
		setActive(arg0.numberTF4, false)
	end
end

function var0.UpdateRank(arg0, arg1, arg2)
	setText(arg1:Find("Text"), arg2.name)
	setText(arg1:Find("damage/Text"), arg2.damage)
	setActive(arg1:Find("view"), arg2.id ~= getProxy(PlayerProxy):getRawData().id)
	onButton(arg0, arg1:Find("view"), function()
		arg0:emit(WorldBossMediator.FETCH_RANK_FORMATION, arg2.id, arg0.bossId)
	end, SFX_PANEL)
end

function var0.UpdateMyRank(arg0, arg1, arg2)
	arg0:UpdateRank(arg1, arg2)
	setText(arg1:Find("number"), arg2.number)
end

function var0.isActive(arg0)
	return isActive(arg0._tf)
end

function var0.OnDestroy(arg0)
	return
end

return var0
