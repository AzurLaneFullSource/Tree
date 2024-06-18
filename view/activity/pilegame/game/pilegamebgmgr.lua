local var0_0 = class("PileGameBgMgr")

var0_0.bgMaps = {
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"10",
	"11",
	"12"
}
var0_0.effects = {
	nil,
	"diediele_1yanhua",
	nil,
	"diediele_2liuxin",
	"diediele_2liuxin",
	[12] = "diediele_3xinxin"
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.tr = arg1_1
end

function var0_0.Init(arg0_2, arg1_2)
	arg0_2.list = {
		arg0_2.tr:Find("Image1"),
		arg0_2.tr:Find("Image2"),
		arg0_2.tr:Find("Image3")
	}
	arg0_2.names = {}

	local var0_2 = {}

	for iter0_2 = 1, 2 do
		setActive(arg0_2.list[iter0_2], false)
		table.insert(var0_2, function(arg0_3)
			local var0_3 = arg0_2:GetBg(iter0_2)

			arg0_2:LoadImage(var0_3, function(arg0_4)
				setActive(arg0_2.list[iter0_2], true)

				arg0_2.list[iter0_2]:GetComponent(typeof(Image)).sprite = arg0_4

				arg0_3()
			end)

			arg0_2.names[arg0_2.list[iter0_2]] = var0_3

			arg0_2:LoadEffect(var0_3, arg0_2.list[iter0_2])
		end)
	end

	seriesAsync(var0_2, function()
		local var0_5 = 0

		for iter0_5, iter1_5 in ipairs(arg0_2.list) do
			local var1_5 = arg0_2.list[iter0_5 - 1]

			if var1_5 then
				var0_5 = var0_5 + var1_5.rect.height
			end

			setAnchoredPosition(iter1_5, {
				x = 0,
				z = 0,
				y = var0_5
			})
		end

		arg1_2()
	end)
end

function var0_0.DoMove(arg0_6, arg1_6)
	local var0_6

	for iter0_6, iter1_6 in ipairs(arg0_6.list) do
		if iter1_6 then
			var0_6 = var0_6 or iter0_6

			local var1_6 = getAnchoredPosition(iter1_6)

			setAnchoredPosition(iter1_6, {
				y = var1_6.y - arg1_6
			})
		end
	end

	arg0_6:DoCheck(var0_6)
end

function var0_0.DoCheck(arg0_7, arg1_7)
	local var0_7 = arg0_7.list[arg1_7]
	local var1_7 = arg0_7.list[arg1_7 + 2]
	local var2_7 = getAnchoredPosition(var0_7)

	if var2_7.y + var0_7.rect.height + arg0_7.list[arg1_7 + 1].rect.height - arg0_7.tr.rect.height >= 50 then
		local var3_7 = var1_7:GetComponent(typeof(Image))
		local var4_7 = arg0_7:GetBg(arg1_7 + 2)

		if arg0_7.names[var1_7] ~= var4_7 then
			arg0_7:LoadImage(var4_7, function(arg0_8)
				setActive(var1_7, true)

				var3_7.sprite = arg0_8

				var3_7:SetNativeSize()
			end)
			arg0_7:LoadEffect(var4_7, var1_7)

			arg0_7.names[var1_7] = var4_7
		end
	end

	if math.abs(var2_7.y) >= var0_7.rect.height then
		var0_7:GetComponent(typeof(Image)).sprite = nil
		arg0_7.names[var0_7] = nil

		var0_7:SetAsFirstSibling()

		arg0_7.list[arg1_7 + 3] = var0_7
		arg0_7.list[arg1_7] = false

		local var5_7 = getAnchoredPosition(var1_7)

		setAnchoredPosition(var0_7, {
			y = var5_7.y + var1_7.rect.height
		})
		arg0_7:ReturnEffect(var0_7)
	end
end

function var0_0.GetBg(arg0_9, arg1_9)
	return var0_0.bgMaps[arg1_9] or var0_0.bgMaps[#var0_0.bgMaps]
end

function var0_0.LoadImage(arg0_10, arg1_10, arg2_10)
	LoadSpriteAtlasAsync("clutter/bg" .. arg1_10, nil, function(arg0_11)
		arg2_10(arg0_11)
	end)
end

function var0_0.LoadEffect(arg0_12, arg1_12, arg2_12)
	local var0_12 = var0_0.effects[tonumber(arg1_12)]

	if var0_12 then
		PoolMgr.GetInstance():GetUI(var0_12, true, function(arg0_13)
			if not arg0_12.list then
				PoolMgr.GetInstance():ReturnUI(var0_12, arg0_13)
			else
				arg0_13.name = var0_12

				SetParent(arg0_13, arg2_12)
				setActive(arg0_13, true)
			end
		end)
	end
end

function var0_0.ReturnEffect(arg0_14, arg1_14)
	if arg1_14.childCount > 0 then
		local var0_14 = arg1_14:GetChild(0)

		PoolMgr.GetInstance():ReturnUI(var0_14.name, var0_14.gameObject)
	end
end

function var0_0.Clear(arg0_15)
	eachChild(arg0_15.tr, function(arg0_16)
		arg0_16:GetComponent(typeof(Image)).sprite = nil

		arg0_15:ReturnEffect(arg0_16)
	end)

	arg0_15.list = nil
	arg0_15.names = nil
end

return var0_0
