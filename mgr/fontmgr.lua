pg = pg or {}

local var0 = pg

var0.FontMgr = singletonClass("FontMgr")

local var1 = var0.FontMgr

function var0.FontMgr.Init(arg0, arg1)
	print("initializing font manager...")

	local var0 = {}

	for iter0, iter1 in pairs({
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
		table.insert(var0, function(arg0)
			ResourceMgr.Inst:getAssetAsync("font/" .. iter1, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
				arg0.fonts[iter0] = arg0

				arg0()
			end), false, false)
		end)
	end

	arg0.fonts = {}

	parallelAsync(var0, function(arg0)
		arg1(arg0)
	end)
end
