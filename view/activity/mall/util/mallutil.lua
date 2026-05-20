local var0_0 = class("MallUtil")

var0_0.FLOOR_RANK = {
	CLOSE = 4,
	S = 1,
	A = 2,
	B = 3
}
var0_0.RANK2NAME = {
	[var0_0.FLOOR_RANK.S] = i18n("mall_rank_s"),
	[var0_0.FLOOR_RANK.A] = i18n("mall_rank_a"),
	[var0_0.FLOOR_RANK.B] = i18n("mall_rank_b"),
	[var0_0.FLOOR_RANK.CLOSE] = i18n("mall_rank_close")
}

function var0_0.GetFloorRank(arg0_1, arg1_1)
	local var0_1 = arg0_1 / arg1_1

	if var0_1 <= 0 then
		return var0_0.FLOOR_RANK.CLOSE
	end

	if var0_1 >= 1.5 then
		return var0_0.FLOOR_RANK.S
	end

	if var0_1 >= 1 and var0_1 < 1.5 then
		return var0_0.FLOOR_RANK.A
	end

	return var0_0.FLOOR_RANK.B
end

function var0_0.GetFloorFactor(arg0_2)
	local var0_2 = pg.gameset.activity_mall_profit_factor.description

	for iter0_2, iter1_2 in ipairs(var0_2) do
		if arg0_2 == var0_2[1] then
			return iter1_2[2]
		end
	end

	return var0_2[#var0_2][2]
end

return var0_0
