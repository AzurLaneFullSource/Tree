local var0_0 = class("IslandMiniShipCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tf = arg1_1.transform
	arg0_1.addBtn = arg0_1.tf:Find("add")
	arg0_1.iconTr = arg0_1.tf:Find("icon")
	arg0_1.selected = arg0_1.tf:Find("sel")
	arg0_1.selImg = arg0_1.tf:Find("sel_1"):GetComponent(typeof(Image))
	arg0_1.redDot = arg0_1.tf:Find("red_dot")
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.configId = arg1_2
	arg0_2.ship = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg1_2)

	setActive(arg0_2.addBtn, not arg0_2.ship)

	local var0_2 = IslandShip.StaticGetPrefab(arg1_2)

	GetImageSpriteFromAtlasAsync("island/IslandShipIcon/" .. var0_2, "", arg0_2.iconTr)
	arg0_2:UpdateSelected(arg2_2)
	arg0_2:FlushRedDot()
end

function var0_0.FlushRedDot(arg0_3)
	setActive(arg0_3.redDot, false)
end

function var0_0.UpdateSelected(arg0_4, arg1_4)
	local var0_4 = arg1_4 == arg0_4.configId

	setActive(arg0_4.selected, var0_4)
end

function var0_0.Dispose(arg0_5)
	return
end

return var0_0
