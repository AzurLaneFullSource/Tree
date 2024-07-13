local var0_0 = class("ChineseCalendar")
local var1_0 = 1901
local var2_0 = 199
local var3_0 = {
	306771,
	677704,
	5580477,
	861776,
	890180,
	4631225,
	354893,
	634178,
	2404022,
	306762,
	6966718,
	675154,
	861510,
	6116026,
	742478,
	879171,
	2714935,
	613195,
	7642049,
	300884,
	674636,
	5973436,
	435536,
	447557,
	4905656,
	177741,
	612162,
	2398135,
	300874,
	6703934,
	870993,
	959814,
	5690554,
	372046,
	177732,
	3749688,
	601675,
	8165055,
	824659,
	870984,
	7185723,
	742735,
	354885,
	4894137,
	154957,
	601410,
	2921910,
	693578,
	8080061,
	445009,
	742726,
	5593787,
	318030,
	678723,
	3484600,
	338764,
	9082175,
	955730,
	436808,
	8049980,
	701775,
	308805,
	4871993,
	677709,
	337474,
	4100917,
	890185,
	7711422,
	354897,
	617798,
	5549755,
	306511,
	675139,
	5056183,
	861515,
	9261759,
	742482,
	748103,
	6909244,
	613200,
	301893,
	4869049,
	674637,
	11216322,
	435540,
	447561,
	7002685,
	702033,
	603974,
	5543867,
	300879,
	412484,
	3581239,
	959818,
	8827583,
	371795,
	702023,
	5846716,
	601680,
	824901,
	5065400,
	870988,
	894273,
	2468534,
	354889,
	8039869,
	154962,
	601415,
	6067642,
	693582,
	739907,
	4937015,
	709962,
	9788095,
	309843,
	678728,
	6630332,
	338768,
	693061,
	4888377,
	174924,
	350913,
	2808118,
	223562,
	6771389,
	234193,
	206278,
	5655482,
	415181,
	175427,
	3500855,
	373963,
	12298559,
	371027,
	365256,
	7153084,
	337359,
	153028,
	5418424,
	186060,
	374081,
	2992438,
	444746,
	8295102,
	430801,
	338630,
	5920442,
	154446,
	187074,
	3593527,
	484555,
	9390401,
	477523,
	430920,
	6630204,
	338895,
	158532,
	4418232,
	240332,
	238786,
	3623349,
	215497,
	8033725,
	169425,
	339397,
	5942586,
	177486,
	373443,
	4957495,
	369995,
	9259711,
	346835,
	169671,
	6641339,
	350927,
	185669,
	4575928,
	447180,
	435522,
	4082358,
	430921,
	7809469,
	436817,
	709958,
	5561018,
	308814,
	677699,
	4532024,
	861770,
	9343806,
	873042,
	895559,
	6731067,
	355663,
	306757,
	4869817,
	675148,
	857409,
	2986677
}

function var0_0.DayOfSolarYear(arg0_1, arg1_1, arg2_1)
	local var0_1, var1_1 = {
		1,
		32,
		60,
		91,
		121,
		152,
		182,
		213,
		244,
		274,
		305,
		335
	}, {
		1,
		32,
		61,
		92,
		122,
		153,
		183,
		214,
		245,
		275,
		306,
		336
	}

	if arg0_1 % 4 == 0 then
		if arg0_1 % 100 ~= 0 then
			var0_1 = var1_1
		end

		if arg0_1 % 400 == 0 then
			var0_1 = var1_1
		end
	end

	return var0_1[arg1_1] + arg2_1 - 1
end

function var0_0.CalDate(arg0_2, arg1_2, arg2_2)
	local var0_2 = {
		day = 0,
		month = 0,
		leap = false,
		year = arg0_2
	}

	if arg0_2 <= var1_0 or arg0_2 > var1_0 + var2_0 - 1 then
		return var0_2
	end

	local var1_2 = arg0_2 - var1_0 + 1
	local var2_2 = bit.rshift(bit.band(var3_0[var1_2], 96), 5)
	local var3_2 = bit.band(var3_0[var1_2], 31)
	local var4_2 = var0_0.DayOfSolarYear(arg0_2, arg1_2, arg2_2)
	local var5_2 = var4_2 - var0_0.DayOfSolarYear(arg0_2, var2_2, var3_2) + 1

	if var5_2 <= 0 then
		var1_2 = var1_2 - 1
		var0_2.year = var0_2.year - 1

		if var1_2 <= 0 then
			return var0_2
		end

		local var6_2 = bit.rshift(bit.band(var3_0[var1_2], 96), 5)
		local var7_2 = bit.band(var3_0[var1_2], 31)
		local var8_2 = var0_0.DayOfSolarYear(var0_2.year, var6_2, var7_2)

		var5_2 = var4_2 + var0_0.DayOfSolarYear(var0_2.year, 12, 31) - var8_2 + 1
	end

	local var9_2 = 1

	while var9_2 <= 13 do
		local var10_2 = 29

		if bit.band(bit.rshift(var3_0[var1_2], 6 + var9_2), 1) == 1 then
			var10_2 = 30
		end

		if var5_2 <= var10_2 then
			break
		else
			var5_2 = var5_2 - var10_2
		end

		var9_2 = var9_2 + 1
	end

	var0_2.day = var5_2

	local var11_2 = bit.band(bit.rshift(var3_0[var1_2], 20), 15)

	if var11_2 > 0 and var11_2 < var9_2 then
		var9_2 = var9_2 - 1

		if var9_2 == var11_2 then
			var0_2.leap = true
		end
	end

	assert(var11_2 <= 12)

	var0_2.month = var9_2

	return var0_2
end

function var0_0.IsNewYear(arg0_3, arg1_3, arg2_3)
	return arg1_3 == 1 and arg2_3 == 1
end

function var0_0.IsLunarNewYear(arg0_4, arg1_4, arg2_4)
	local var0_4 = var0_0.CalDate(arg0_4, arg1_4, arg2_4 + 1)

	return var0_4.month == 1 and var0_4.day == 1
end

function var0_0.IsValentineDay(arg0_5, arg1_5, arg2_5)
	return arg1_5 == 2 and arg2_5 == 14
end

function var0_0.IsMidAutumnFestival(arg0_6, arg1_6, arg2_6)
	local var0_6 = var0_0.CalDate(arg0_6, arg1_6, arg2_6)

	return var0_6.month == 8 and var0_6.day == 15
end

function var0_0.AllHallowsDay(arg0_7, arg1_7, arg2_7)
	return arg1_7 == 10 and arg2_7 == 31
end

function var0_0.IsChristmas(arg0_8, arg1_8, arg2_8)
	return arg1_8 == 12 and arg2_8 == 25
end

function var0_0.GetCurrYearMonthDay(arg0_9)
	local var0_9 = pg.TimeMgr.GetInstance():STimeDescC(arg0_9, "%Y.%m.%d")
	local var1_9 = string.split(var0_9, ".")
	local var2_9 = tonumber(var1_9[1])
	local var3_9 = tonumber(var1_9[2])
	local var4_9 = tonumber(var1_9[3])

	return var2_9, var3_9, var4_9
end

function var0_0.AnySpecialDay(arg0_10, arg1_10, arg2_10)
	return var0_0.IsNewYear(arg0_10, arg1_10, arg2_10) or var0_0.IsLunarNewYear(arg0_10, arg1_10, arg2_10) or var0_0.IsValentineDay(arg0_10, arg1_10, arg2_10) or var0_0.IsMidAutumnFestival(arg0_10, arg1_10, arg2_10) or var0_0.AllHallowsDay(arg0_10, arg1_10, arg2_10) or var0_0.IsChristmas(arg0_10, arg1_10, arg2_10)
end

return var0_0
