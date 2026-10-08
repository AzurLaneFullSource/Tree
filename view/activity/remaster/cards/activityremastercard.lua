local var0_0 = class("ActivityRemasterCard")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1
	arg0_1._tf = arg1_1.transform
	arg0_1.doingTr = arg0_1._tf:Find("doing")
	arg0_1.finishTr = arg0_1._tf:Find("finish")
	arg0_1.finishTagTr = arg0_1._tf:Find("finish_tag")
	arg0_1.ico = arg0_1._tf:Find("border/ico"):GetComponent(typeof(Image))
	arg0_1.title = arg0_1._tf:Find("border/title"):GetComponent(typeof(Image))
	arg0_1.modelTxt = arg0_1._tf:Find("border/model"):GetComponent(typeof(Text))
	arg0_1.furTxt = arg0_1._tf:Find("border/fur"):GetComponent(typeof(Text))
	arg0_1.finishToggle = arg0_1._tf:Find("finish_toggle")
	arg0_1.uiShipList = UIItemList.New(arg0_1._tf:Find("border/ships"), arg0_1._tf:Find("border/ships/tpl"))

	setText(arg0_1._tf:Find("border/label"), i18n("act_remaster_colllect_progress"))
end

function var0_0.Update(arg0_2, arg1_2)
	arg0_2.remasterData = arg1_2

	arg0_2:UpdateStyle(arg1_2)
	arg0_2:UpdateProgress(arg1_2)
	arg0_2:UpdateShips(arg1_2)
end

function var0_0.UpdateStyle(arg0_3, arg1_3)
	local var0_3 = arg1_3:IsFinish()
	local var1_3 = arg1_3:GetBanner()
	local var2_3 = GetSpriteFromAtlas("ActivityRemaster/" .. var1_3, "banner")
	local var3_3 = GetSpriteFromAtlas("ActivityRemaster/" .. var1_3, "title")

	arg0_3.ico.sprite = var2_3
	arg0_3.title.sprite = var3_3

	triggerToggle(arg0_3.finishToggle, var0_3)
end

function var0_0.UpdateProgress(arg0_4, arg1_4)
	local var0_4 = arg1_4:GetShipProgress()
	local var1_4 = arg1_4:GetShipTotalCnt()

	arg0_4.modelTxt.text = var0_4 .. "/" .. var1_4

	local var2_4 = arg1_4:GetFurnitureProgress()
	local var3_4 = arg1_4:GetFurnitureTotalCnt()

	arg0_4.furTxt.text = var2_4 .. "/" .. var3_4
end

function var0_0.UpdateShips(arg0_5, arg1_5)
	local var0_5 = arg1_5:GetCollectableShipIdList()

	arg0_5.uiShipList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = var0_5[arg1_6 + 1]
			local var1_6 = ShipGroup.getDefaultShipConfig(var0_6).skin_id
			local var2_6 = pg.ship_skin_template[var1_6]

			GetImageSpriteFromAtlasAsync("shipYardIcon/" .. var2_6.painting, var2_6.painting, arg2_6:Find("ico"))

			local var3_6 = getProxy(CollectionProxy):getShipGroup(var0_6)

			setActive(arg2_6:Find("mask"), var3_6)
		end
	end)
	arg0_5.uiShipList:align(#var0_5)
end

function var0_0.Dispose(arg0_7)
	return
end

return var0_0
