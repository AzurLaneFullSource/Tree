pg = pg or {}

local var0_0 = pg

var0_0.FontMgr = singletonClass("FontMgr")

local var1_0 = var0_0.FontMgr

function var0_0.FontMgr.Init(arg0_1, arg1_1)
	print("initializing font manager...")

	local var0_1 = {}

	for iter0_1, iter1_1 in pairs({
		crifont = "crifont",
		remfont = "remfont",
		heiti = "zhunyuan",
		treatfont = "treatfont",
		impact = "impact",
		chuanjiadanFont = "chuanjiadanFont",
		explofont = "explofont",
		number = "number",
		countnumber = "countnumber",
		weaponcountfont = "weaponcountfont",
		missfont = "missfont",
		MStiffHei = "MStiffHei",
		weijichuanFont = "weijichuanFont",
		bankgthd = "bankgthd",
		lvnumber = "lvnumber",
		sourcehanserifcn = "sourcehanserifcn-bold_0"
	}) do
		table.insert(var0_1, function(arg0_2)
			ResourceMgr.Inst:getAssetAsync("font/" .. iter1_1, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_3)
				arg0_1.fonts[iter0_1] = arg0_3

				arg0_2()
			end), false, false)
		end)
	end

	arg0_1.fonts = {}

	parallelAsync(var0_1, function(arg0_4)
		arg1_1(arg0_4)
	end)
end
