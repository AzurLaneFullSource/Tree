local var0 = class("ChineseCalendar")
local var1 = 1901
local var2 = 199
local var3 = {
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

function var0.DayOfSolarYear(arg0, arg1, arg2)
	local var0, var1 = {
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

	if arg0 % 4 == 0 then
		if arg0 % 100 ~= 0 then
			var0 = var1
		end

		if arg0 % 400 == 0 then
			var0 = var1
		end
	end

	return var0[arg1] + arg2 - 1
end

function var0.CalDate(arg0, arg1, arg2)
	local var0 = {
		day = 0,
		month = 0,
		leap = false,
		year = arg0
	}

	if arg0 <= var1 or arg0 > var1 + var2 - 1 then
		return var0
	end

	local var1 = arg0 - var1 + 1
	local var2 = bit.rshift(bit.band(var3[var1], 96), 5)
	local var3 = bit.band(var3[var1], 31)
	local var4 = var0.DayOfSolarYear(arg0, arg1, arg2)
	local var5 = var4 - var0.DayOfSolarYear(arg0, var2, var3) + 1

	if var5 <= 0 then
		var1 = var1 - 1
		var0.year = var0.year - 1

		if var1 <= 0 then
			return var0
		end

		local var6 = bit.rshift(bit.band(var3[var1], 96), 5)
		local var7 = bit.band(var3[var1], 31)
		local var8 = var0.DayOfSolarYear(var0.year, var6, var7)

		var5 = var4 + var0.DayOfSolarYear(var0.year, 12, 31) - var8 + 1
	end

	local var9 = 1

	while var9 <= 13 do
		local var10 = 29

		if bit.band(bit.rshift(var3[var1], 6 + var9), 1) == 1 then
			var10 = 30
		end

		if var5 <= var10 then
			break
		else
			var5 = var5 - var10
		end

		var9 = var9 + 1
	end

	var0.day = var5

	local var11 = bit.band(bit.rshift(var3[var1], 20), 15)

	if var11 > 0 and var11 < var9 then
		var9 = var9 - 1

		if var9 == var11 then
			var0.leap = true
		end
	end

	assert(var11 <= 12)

	var0.month = var9

	return var0
end

function var0.IsNewYear(arg0, arg1, arg2)
	return arg1 == 1 and arg2 == 1
end

function var0.IsLunarNewYear(arg0, arg1, arg2)
	local var0 = var0.CalDate(arg0, arg1, arg2 + 1)

	return var0.month == 1 and var0.day == 1
end

function var0.IsValentineDay(arg0, arg1, arg2)
	return arg1 == 2 and arg2 == 14
end

function var0.IsMidAutumnFestival(arg0, arg1, arg2)
	local var0 = var0.CalDate(arg0, arg1, arg2)

	return var0.month == 8 and var0.day == 15
end

function var0.AllHallowsDay(arg0, arg1, arg2)
	return arg1 == 10 and arg2 == 31
end

function var0.IsChristmas(arg0, arg1, arg2)
	return arg1 == 12 and arg2 == 25
end

function var0.GetCurrYearMonthDay(arg0)
	local var0 = pg.TimeMgr.GetInstance():STimeDescC(arg0, "%Y.%m.%d")
	local var1 = string.split(var0, ".")
	local var2 = tonumber(var1[1])
	local var3 = tonumber(var1[2])
	local var4 = tonumber(var1[3])

	return var2, var3, var4
end

function var0.AnySpecialDay(arg0, arg1, arg2)
	return var0.IsNewYear(arg0, arg1, arg2) or var0.IsLunarNewYear(arg0, arg1, arg2) or var0.IsValentineDay(arg0, arg1, arg2) or var0.IsMidAutumnFestival(arg0, arg1, arg2) or var0.AllHallowsDay(arg0, arg1, arg2) or var0.IsChristmas(arg0, arg1, arg2)
end

return var0
