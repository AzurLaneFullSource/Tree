local var0_0 = class("IslandTradePriceTrendPage", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "IslandTradePriceTrendUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.uiPriceList = UIItemList.New(arg0_2._tf:Find("frame/prices"), arg0_2._tf:Find("frame/prices/tpl"))
	arg0_2.uiDateList = UIItemList.New(arg0_2._tf:Find("frame/date"), arg0_2._tf:Find("frame/date/tpl"))
	arg0_2.tpl = arg0_2._tf:Find("frame/tpl")
	arg0_2.dotContainer = arg0_2._tf:Find("frame/dots")
	arg0_2.dots = {}
end

function var0_0.Show(arg0_3, arg1_3, arg2_3)
	var0_0.super.Show(arg0_3)

	arg0_3.mode = arg2_3
	arg0_3.island = arg1_3

	arg0_3:InitPrices()
	arg0_3:InitDate()
	onNextTick(function()
		arg0_3:UpdateCurve()
	end)
end

function var0_0.InitPrices(arg0_5)
	arg0_5.priceList = {}

	local var0_5 = pg.island_set.treasure_price_scale_y.key_value_varchar

	arg0_5.uiPriceList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = var0_5[arg1_6 + 1]

			setText(arg2_6:Find("Text"), var0_6)
			table.insert(arg0_5.priceList, {
				var0_6,
				arg2_6
			})
		end
	end)
	arg0_5.uiPriceList:align(#var0_5)
	table.sort(arg0_5.priceList, function(arg0_7, arg1_7)
		return arg0_7[1] < arg1_7[1]
	end)
end

function var0_0.CollectDate(arg0_8)
	local var0_8 = pg.TimeMgr.GetInstance():GetServerHour()
	local var1_8 = GetZeroTime()

	if var0_8 <= 2 then
		var1_8 = var1_8 - 86400
	end

	local var2_8 = var1_8 - 86400 + 10800
	local var3_8 = {}
	local var4_8 = 0

	for iter0_8 = 6, 1, -1 do
		if arg0_8.island:GetTradeAgency():ExistTrade(var2_8 - iter0_8 * 86400) then
			var4_8 = iter0_8

			break
		end
	end

	for iter1_8 = var4_8, 1, -1 do
		local var5_8 = var2_8 - iter1_8 * 86400

		table.insert(var3_8, var5_8)
	end

	table.insert(var3_8, var2_8)

	for iter2_8 = 1, 7 - #var3_8 do
		local var6_8 = var2_8 + iter2_8 * 86400

		table.insert(var3_8, var6_8)
	end

	return var3_8
end

function var0_0.InitDate(arg0_9)
	arg0_9.dateList = {}

	local var0_9 = arg0_9:CollectDate()

	assert(#var0_9 == 7)
	arg0_9.uiDateList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = var0_9[arg1_10 + 1]
			local var1_10 = pg.TimeMgr.GetInstance():STimeDescS(var0_10, "%m.%d")

			setText(arg2_10:Find("Text"), var1_10)

			arg0_9.dateList[var0_10] = arg2_10
		end
	end)
	arg0_9.uiDateList:align(#var0_9)
end

function var0_0.UpdateCurve(arg0_11)
	eachChild(arg0_11.dotContainer, function(arg0_12)
		setActive(arg0_12, false)
	end)

	local var0_11 = arg0_11.island:GetTradeAgency()
	local var1_11

	if arg0_11.mode == IslandTradePage.MODE_SELL then
		var1_11 = var0_11:GetSellPriceTrend()
	elseif arg0_11.mode == IslandTradePage.MODE_PURCHAS then
		var1_11 = var0_11:GetPriceTrend()
	end

	local var2_11 = {}

	for iter0_11, iter1_11 in pairs(arg0_11.dateList) do
		local var3_11 = var1_11[iter0_11]

		if var3_11 then
			local var4_11 = arg0_11:UpdateCurveItem(iter0_11, iter1_11, var3_11)

			table.insert(var2_11, {
				iter0_11,
				var4_11
			})
		end
	end

	table.sort(var2_11, function(arg0_13, arg1_13)
		return arg0_13[1] < arg1_13[1]
	end)

	local var5_11 = _.map(var2_11, function(arg0_14)
		return arg0_14[2]
	end)

	for iter2_11, iter3_11 in ipairs(var2_11) do
		local var6_11 = iter3_11[1]
		local var7_11 = arg0_11.dots[var6_11]:Find("line")
		local var8_11 = var2_11[iter2_11 + 1]

		if var7_11 and var8_11 and var8_11[1] - iter3_11[1] == 86400 then
			local var9_11 = Vector2.Distance(iter3_11[2].localPosition, var8_11[2].localPosition)

			var7_11.sizeDelta = Vector2(4, var9_11)
			var7_11.up = (var8_11[2].position - iter3_11[2].position).normalized

			setActive(var7_11, true)
		elseif var7_11 then
			setActive(var7_11, false)
		end
	end

	arg0_11:PlayDotAnimations(var5_11)
end

function var0_0.PlayDotAnimations(arg0_15, arg1_15)
	local var0_15 = {}

	table.insert(var0_15, function(arg0_16)
		onDelayTick(arg0_16, 0.33)
	end)

	for iter0_15, iter1_15 in ipairs(arg1_15) do
		setActive(iter1_15, false)
		table.insert(var0_15, function(arg0_17)
			if IsNil(iter1_15) then
				return
			end

			setActive(iter1_15, true)

			local var0_17 = iter1_15:GetComponent("Animation")

			if not var0_17 then
				return
			end

			var0_17:Play("anim_IslandTradePriceTrendUI_res_tpl_in")
			onDelayTick(arg0_17, 0.33)
		end)
	end

	seriesAsync(var0_15)
end

function var0_0.UpdateCurveItem(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg0_18.dots[arg1_18]

	if not var0_18 then
		var0_18 = cloneTplTo(arg0_18.tpl, arg0_18.dotContainer)
		arg0_18.dots[arg1_18] = var0_18
	end

	setActive(var0_18, true)

	local var1_18 = arg0_18.dotContainer:InverseTransformPoint(arg2_18:Find("Text").position)
	local var2_18 = arg0_18:GetPriceYScale(arg3_18)

	setLocalPosition(var0_18, Vector3(var1_18.x, var2_18, 0))
	setActive(var0_18:Find("dot/current"), pg.TimeMgr.GetInstance():IsSameDay(arg1_18, pg.TimeMgr.GetInstance():GetServerTime()))

	return var0_18
end

function var0_0.GetPriceYScale(arg0_19, arg1_19)
	local var0_19 = arg0_19.priceList[1]
	local var1_19 = arg0_19.priceList[2][2].localPosition.y - var0_19[2].localPosition.y
	local var2_19

	for iter0_19, iter1_19 in ipairs(arg0_19.priceList) do
		if arg1_19 >= iter1_19[1] then
			var2_19 = iter0_19
		end
	end

	if not var2_19 then
		return
	end

	local var3_19 = 0
	local var4_19 = 0

	if var2_19 == #arg0_19.priceList then
		var3_19 = arg0_19.priceList[var2_19][1] + 1000
		var4_19 = arg0_19.priceList[var2_19][1]
	else
		var3_19 = arg0_19.priceList[var2_19 + 1][1]
		var4_19 = arg0_19.priceList[var2_19][1]
	end

	local var5_19 = (arg1_19 - var4_19) / (var3_19 - var4_19)
	local var6_19 = arg0_19.priceList[var2_19][2]

	return arg0_19.dotContainer:InverseTransformPoint(var6_19:Find("Text").position).y + var1_19 * var5_19
end

return var0_0
