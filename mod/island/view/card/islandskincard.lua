local var0_0 = class("IslandSkinCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tf = arg1_1.transform
	arg0_1.selectGos = {
		arg0_1.tf:Find("select")
	}
	arg0_1.notGetTF = arg0_1.tf:Find("not_get")
	arg0_1.changeColorTF = arg0_1.tf:Find("changeColor")
	arg0_1.buyTF = arg0_1.notGetTF:Find("buy")
end

local var1_0 = {
	"white",
	"blue",
	"purple",
	"golden"
}

function var0_0.Update(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.configId = arg1_2

	local var0_2 = pg.island_skin_template[arg0_2.configId]

	setText(arg0_2.tf:Find("Text"), var0_2.name)

	if var0_2.icon ~= "" then
		GetImageSpriteFromAtlasAsync(string.format("island/IslandDressIcon/%s", var0_2.icon), "", arg0_2.tf:Find("icon"))
	end

	setActive(arg0_2.notGetTF, not arg3_2)
	arg0_2:UpdateSelected(arg2_2)
end

function var0_0.UpdateSelected(arg0_3, arg1_3)
	local var0_3 = arg1_3 == arg0_3.configId

	for iter0_3, iter1_3 in ipairs(arg0_3.selectGos) do
		setActive(iter1_3, var0_3)
	end
end

function var0_0.Dispose(arg0_4)
	return
end

return var0_0
