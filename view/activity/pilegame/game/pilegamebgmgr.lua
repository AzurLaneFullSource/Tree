local var0 = class("PileGameBgMgr")

var0.bgMaps = {
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
var0.effects = {
	nil,
	"diediele_1yanhua",
	nil,
	"diediele_2liuxin",
	"diediele_2liuxin",
	[12] = "diediele_3xinxin"
}

function var0.Ctor(arg0, arg1)
	arg0.tr = arg1
end

function var0.Init(arg0, arg1)
	arg0.list = {
		arg0.tr:Find("Image1"),
		arg0.tr:Find("Image2"),
		arg0.tr:Find("Image3")
	}
	arg0.names = {}

	local var0 = {}

	for iter0 = 1, 2 do
		setActive(arg0.list[iter0], false)
		table.insert(var0, function(arg0)
			local var0 = arg0:GetBg(iter0)

			arg0:LoadImage(var0, function(arg0)
				setActive(arg0.list[iter0], true)

				arg0.list[iter0]:GetComponent(typeof(Image)).sprite = arg0

				arg0()
			end)

			arg0.names[arg0.list[iter0]] = var0

			arg0:LoadEffect(var0, arg0.list[iter0])
		end)
	end

	seriesAsync(var0, function()
		local var0 = 0

		for iter0, iter1 in ipairs(arg0.list) do
			local var1 = arg0.list[iter0 - 1]

			if var1 then
				var0 = var0 + var1.rect.height
			end

			setAnchoredPosition(iter1, {
				x = 0,
				z = 0,
				y = var0
			})
		end

		arg1()
	end)
end

function var0.DoMove(arg0, arg1)
	local var0

	for iter0, iter1 in ipairs(arg0.list) do
		if iter1 then
			var0 = var0 or iter0

			local var1 = getAnchoredPosition(iter1)

			setAnchoredPosition(iter1, {
				y = var1.y - arg1
			})
		end
	end

	arg0:DoCheck(var0)
end

function var0.DoCheck(arg0, arg1)
	local var0 = arg0.list[arg1]
	local var1 = arg0.list[arg1 + 2]
	local var2 = getAnchoredPosition(var0)

	if var2.y + var0.rect.height + arg0.list[arg1 + 1].rect.height - arg0.tr.rect.height >= 50 then
		local var3 = var1:GetComponent(typeof(Image))
		local var4 = arg0:GetBg(arg1 + 2)

		if arg0.names[var1] ~= var4 then
			arg0:LoadImage(var4, function(arg0)
				setActive(var1, true)

				var3.sprite = arg0

				var3:SetNativeSize()
			end)
			arg0:LoadEffect(var4, var1)

			arg0.names[var1] = var4
		end
	end

	if math.abs(var2.y) >= var0.rect.height then
		var0:GetComponent(typeof(Image)).sprite = nil
		arg0.names[var0] = nil

		var0:SetAsFirstSibling()

		arg0.list[arg1 + 3] = var0
		arg0.list[arg1] = false

		local var5 = getAnchoredPosition(var1)

		setAnchoredPosition(var0, {
			y = var5.y + var1.rect.height
		})
		arg0:ReturnEffect(var0)
	end
end

function var0.GetBg(arg0, arg1)
	return var0.bgMaps[arg1] or var0.bgMaps[#var0.bgMaps]
end

function var0.LoadImage(arg0, arg1, arg2)
	LoadSpriteAtlasAsync("clutter/bg" .. arg1, nil, function(arg0)
		arg2(arg0)
	end)
end

function var0.LoadEffect(arg0, arg1, arg2)
	local var0 = var0.effects[tonumber(arg1)]

	if var0 then
		PoolMgr.GetInstance():GetUI(var0, true, function(arg0)
			if not arg0.list then
				PoolMgr.GetInstance():ReturnUI(var0, arg0)
			else
				arg0.name = var0

				SetParent(arg0, arg2)
				setActive(arg0, true)
			end
		end)
	end
end

function var0.ReturnEffect(arg0, arg1)
	if arg1.childCount > 0 then
		local var0 = arg1:GetChild(0)

		PoolMgr.GetInstance():ReturnUI(var0.name, var0.gameObject)
	end
end

function var0.Clear(arg0)
	eachChild(arg0.tr, function(arg0)
		arg0:GetComponent(typeof(Image)).sprite = nil

		arg0:ReturnEffect(arg0)
	end)

	arg0.list = nil
	arg0.names = nil
end

return var0
