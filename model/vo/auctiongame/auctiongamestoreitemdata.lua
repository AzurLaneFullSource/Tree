local var0_0 = class("AuctionGameStoreItemData")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.uid = arg1_1.uid
	arg0_1.name = arg1_1.name
	arg0_1.rarity = arg1_1.rarity
	arg0_1.contour = AuctionGameTools.GetPosRange(arg1_1.pos)
	arg0_1.value = arg1_1.value
	arg0_1.position = arg1_1.pos[1]

	if arg1_1.id and arg1_1.id ~= 0 then
		arg0_1.price = pg.auction_collection[arg0_1.id].value

		arg0_1:SetShowContour()
	end

	local var0_1 = ""

	for iter0_1, iter1_1 in ipairs(arg1_1.pos) do
		var0_1 = var0_1 .. string.format("{%s, %s}", iter1_1.x, iter1_1.y)
	end

	print("uid", arg1_1.uid, "id", arg1_1.id, "稀有度：", arg0_1.rarity, string.format("位置： {%s, %s}", arg0_1.position.x, arg0_1.position.y), string.format("轮廓：{%s,%s}", arg0_1.contour[1], arg0_1.contour[2]), "占位:" .. var0_1)
end

function var0_0.SetRevealFlag(arg0_2, arg1_2)
	arg0_2.revealFlag = arg1_2
end

function var0_0.GetReveal(arg0_3)
	return arg0_3.revealFlag
end

function var0_0.UpdateContour(arg0_4, arg1_4)
	arg0_4.contour = AuctionGameTools.GetPosRange(arg1_4)
end

function var0_0.InitContour(arg0_5, arg1_5, arg2_5)
	arg0_5.contour = {
		arg1_5,
		arg2_5
	}
end

function var0_0.UpdateRarity(arg0_6, arg1_6)
	arg0_6.rarity = arg1_6
end

function var0_0.UpdatePos(arg0_7, arg1_7)
	arg0_7.position = arg1_7
end

function var0_0.SetShowContour(arg0_8)
	arg0_8.showContour = true
end

function var0_0.SetShowPos(arg0_9)
	arg0_9.showPos = true
end

function var0_0.SetShowRarity(arg0_10)
	arg0_10.showRarity = true
end

function var0_0.GetEstimateValue(arg0_11)
	if arg0_11.id ~= nil and arg0_11.id ~= 0 then
		local var0_11 = pg.auction_collection[arg0_11.id].value

		return var0_11, var0_11
	end

	local var1_11 = {}

	if arg0_11.showRarity ~= true and arg0_11.showContour ~= true then
		var1_11 = Clone(pg.auction_collection.all)
	else
		local var2_11 = {}

		if arg0_11.showRarity then
			var2_11 = Clone(pg.auction_collection.get_id_list_by_rarity[arg0_11.rarity])
		else
			var2_11 = Clone(pg.auction_collection.all)
		end

		if arg0_11.showContour then
			for iter0_11, iter1_11 in ipairs(var2_11) do
				local var3_11 = pg.auction_collection[iter1_11].contour

				if arg0_11.contour[1] == var3_11[1] and arg0_11.contour[2] == var3_11[2] then
					table.insert(var1_11, iter1_11)
				end
			end
		else
			var1_11 = var2_11
		end
	end

	local var4_11 = 0
	local var5_11 = 0

	for iter2_11, iter3_11 in ipairs(var1_11) do
		local var6_11 = pg.auction_collection[iter3_11]

		if var4_11 == 0 or var4_11 > var6_11.value then
			var4_11 = var6_11.value
		end

		if var5_11 == 0 or var5_11 < var6_11.value then
			var5_11 = var6_11.value
		end
	end

	return var4_11, var5_11
end

return var0_0
