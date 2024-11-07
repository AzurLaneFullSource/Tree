pg = pg or {}

local var0_0 = pg

var0_0.FontMgr = singletonClass("FontMgr")

function var0_0.FontMgr.Init(arg0_1, arg1_1)
	print("initializing font manager...")

	local var0_1 = {}

	for iter0_1, iter1_1 in pairs({
		impact = "impact",
		remfont = "remfont",
		lvnumber = "lvnumber",
		heitibold = "ZhunYuan_Bold",
		crifont = "crifont",
		heiti = "zhunyuan",
		explofont = "explofont",
		bankgthd = "bankgthd",
		countnumber = "countnumber",
		weaponcountfont = "weaponcountfont",
		missfont = "missfont",
		treatfont = "treatfont",
		MStiffHei = "MStiffHei",
		chuanjiadanFont = "chuanjiadanFont",
		number = "number",
		sourcehanserifcn = "sourcehanserifcn-bold_0",
		weijichuanFont = "weijichuanFont"
	}) do
		table.insert(var0_1, function(arg0_2)
			AssetBundleHelper.loadAssetBundleAsync("font/" .. iter1_1, function(arg0_3)
				arg0_2()
			end)
		end)
	end

	parallelAsync(var0_1, function(arg0_4)
		arg1_1(arg0_4)
	end)
end
