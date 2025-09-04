local var0_0 = class("IslandShipCard", import(".IslandMiniShipCard"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.go = arg1_1
	arg0_1.tf = arg1_1.transform
	arg0_1.addBtn = arg0_1.tf:Find("add")
	arg0_1.iconTr = arg0_1.tf:Find("mask/icon")
	arg0_1.selected = arg0_1.tf:Find("sel")
	arg0_1.levelTxt = arg0_1.tf:Find("Text"):GetComponent(typeof(Text))
end

function var0_0.Update(arg0_2, arg1_2, arg2_2)
	arg0_2.configId = arg1_2
	arg0_2.ship = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(arg1_2)

	setActive(arg0_2.addBtn, not arg0_2.ship)

	local var0_2 = IslandShip.StaticGetPrefab(arg1_2)

	GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var0_2, "", arg0_2.iconTr)

	arg0_2.levelTxt.text = arg0_2.ship and "Lv." .. arg0_2.ship:GetLevel() or ""

	arg0_2:UpdateSelected(arg2_2)
end

function var0_0.Dispose(arg0_3)
	return
end

return var0_0
