local var0_0 = class("IslandShopBuySuccessLayer", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShopBuySuccessUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.awardList = UIItemList.New(arg0_2._tf:Find("awards"), arg0_2._tf:Find("awards/item"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("award_window"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.SetUp(arg0_5, arg1_5, arg2_5)
	if arg2_5.count > 0 then
		table.insert(arg1_5, 1, arg2_5)
	end

	arg0_5.awardList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = arg1_5[arg1_6 + 1]

			if var0_6.type == VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT and var0_6.id == 0 then
				LoadImageSpriteAtlasAsync("island/" .. pg.island_set.season_pt.key_value_varchar[2], "", arg2_6:Find("IslandItemTpl/icon_bg/icon"))
				setText(arg2_6:Find("IslandItemTpl/icon_bg/count_bg/count"), var0_6.count)
				setActive(arg2_6:Find("split"), true)
			else
				setActive(arg2_6:Find("split"), false)

				if var0_6.type == DROP_TYPE_ISLAND_ITEM then
					updateCustomDrop(arg2_6:Find("IslandItemTpl"), {
						type = var0_6.type,
						id = var0_6.id,
						count = var0_6.number
					})
				elseif var0_6.type == DROP_TYPE_ISLAND_FURNITURE then
					GetImageSpriteFromAtlasAsync("island/IslandFurnitureIcon/" .. pg.island_furniture_template[var0_6.id].icon, "", arg2_6:Find("IslandItemTpl/icon_bg/icon"))
					setText(arg2_6:Find("IslandItemTpl/icon_bg/count_bg/count"), var0_6.number)
				elseif var0_6.type == DROP_TYPE_ISLAND_DRESS then
					GetImageSpriteFromAtlasAsync("island/IslandDressIcon/" .. pg.island_dress_template[var0_6.id].icon, "", arg2_6:Find("IslandItemTpl/icon_bg/icon"))
					setText(arg2_6:Find("IslandItemTpl/icon_bg/count_bg/count"), var0_6.number)
				elseif var0_6.type == DROP_TYPE_ISLAND_SKIN then
					GetImageSpriteFromAtlasAsync("island/IslandDressIcon/" .. pg.island_skin_template[var0_6.id].icon, "", arg2_6:Find("IslandItemTpl/icon_bg/icon"))
					setText(arg2_6:Find("IslandItemTpl/icon_bg/count_bg/count"), var0_6.number)
				end
			end
		end
	end)
	arg0_5.awardList:align(#arg1_5)
end

function var0_0.OnShow(arg0_7, arg1_7, arg2_7, arg3_7)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf, false, {
		groupName = "IslandShop"
	})
	arg0_7:SetUp(arg1_7, arg2_7)

	arg0_7.callback = arg3_7
	arg0_7.active = true
end

function var0_0.OnHide(arg0_8)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_8._tf, arg0_8._parentTf)

	if arg0_8.active then
		arg0_8.active = false

		if arg0_8.callback then
			arg0_8.callback()
		end
	end
end

function var0_0.OnDestroy(arg0_9)
	return
end

return var0_0
