local var0_0 = class("IslandShopBuySuccessLayer", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandShopBuySuccessUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.awardList = UIItemList.New(arg0_2._tf:Find("awards"), arg0_2._tf:Find("awards/item"))

	setText(arg0_2._tf:Find("tip/text"), i18n("island_3Dshop_close"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("award_window"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("tip"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.SetUp(arg0_6, arg1_6)
	arg0_6.awardList:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = arg1_6[arg1_7 + 1]

			if var0_7.type == VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT and var0_7.id == 0 then
				LoadImageSpriteAtlasAsync("island/" .. pg.island_set.season_pt.key_value_varchar[2], "", arg2_7:Find("IslandItemTpl/icon_bg/icon"))
				setText(arg2_7:Find("IslandItemTpl/icon_bg/count_bg/count"), var0_7.count)
				setActive(arg2_7:Find("split"), true)
			else
				setActive(arg2_7:Find("split"), false)

				if var0_7.type == DROP_TYPE_ISLAND_ITEM or var0_7.type == DROP_TYPE_ISLAND_SPEEDUP_TICKET then
					updateCustomDrop(arg2_7:Find("IslandItemTpl"), {
						type = var0_7.type,
						id = var0_7.id,
						count = var0_7.count
					})
				elseif var0_7.type == DROP_TYPE_ISLAND_FURNITURE then
					GetImageSpriteFromAtlasAsync("island/IslandFurnitureIcon/" .. pg.island_furniture_template[var0_7.id].icon, "", arg2_7:Find("IslandItemTpl/icon_bg/icon"))
					setText(arg2_7:Find("IslandItemTpl/icon_bg/count_bg/count"), var0_7.count)
				elseif var0_7.type == DROP_TYPE_ISLAND_DRESS then
					GetImageSpriteFromAtlasAsync("island/IslandDressIcon/" .. pg.island_dress_template[var0_7.id].icon, "", arg2_7:Find("IslandItemTpl/icon_bg/icon"))
					setText(arg2_7:Find("IslandItemTpl/icon_bg/count_bg/count"), var0_7.count)
				elseif var0_7.type == DROP_TYPE_ISLAND_SKIN then
					GetImageSpriteFromAtlasAsync("island/IslandDressIcon/" .. pg.island_skin_template[var0_7.id].icon, "", arg2_7:Find("IslandItemTpl/icon_bg/icon"))
					setText(arg2_7:Find("IslandItemTpl/icon_bg/count_bg/count"), var0_7.count)
				end
			end
		end
	end)
	arg0_6.awardList:align(#arg1_6)
end

function var0_0.OnShow(arg0_8, arg1_8, arg2_8)
	arg0_8:BlurPanel(arg0_8._tf)
	arg0_8:SetUp(arg1_8)

	arg0_8.callback = arg2_8
	arg0_8.active = true
end

function var0_0.OnHide(arg0_9)
	arg0_9:UnOverlayPanel(arg0_9._tf, arg0_9._parentTf)

	if arg0_9.active then
		arg0_9.active = false

		if arg0_9.callback then
			arg0_9.callback()
		end
	end
end

function var0_0.OnDestroy(arg0_10)
	return
end

return var0_0
