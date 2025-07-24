return {
	IsUnlockAtelier = function(arg0_1, arg1_1)
		local var0_1 = arg0_1:getConfig("config_client")[arg1_1]
		local var1_1 = tonumber(var0_1.unlockStageID)
		local var2_1 = var0_1.unlockStoryID
		local var3_1 = true

		if var1_1 then
			local var4_1 = getProxy(ChapterProxy)
			local var5_1 = var4_1:getChapterById(var1_1, true)

			var3_1 = var5_1 and var5_1:isClear() and var4_1:getMapById(var4_1:getLastMapForActivity())
		end

		if var2_1 then
			var3_1 = var3_1 and pg.NewStoryMgr.GetInstance():IsPlayed(var2_1)
		end

		return var3_1
	end,
	UpdateYumiaItem = function(arg0_2, arg1_2)
		local var0_2 = arg1_2:GetRarity()
		local var1_2 = ItemRarity.Rarity2Print(var0_2)

		GetImageSpriteFromAtlasAsync("weaponframes", "bg" .. var1_2, arg0_2:Find("IconTpl/icon_bg"))
		GetImageSpriteFromAtlasAsync(arg1_2:GetIconPath(), "", arg0_2:Find("IconTpl/icon_bg/icon"))

		local var2_2 = arg1_2:GetProps()
		local var3_2 = arg0_2:Find("List")

		for iter0_2 = 0, 3 do
			local var4_2 = var3_2:GetChild(iter0_2)
			local var5_2

			if table.contains(var2_2, iter0_2 + 1) then
				var5_2 = AtelierFormulaCircle.ELEMENT_NAME[iter0_2 + 1]
			else
				var5_2 = AtelierFormulaCircle.ELEMENT_NAME[iter0_2 + 1] .. "_2"
			end

			GetImageSpriteFromAtlasAsync("ui/ateliercommonyumiaui_atlas", var5_2, var4_2)
		end

		local var6_2 = arg1_2:GetCategory()

		if var6_2 ~= 0 then
			GetImageSpriteFromAtlasAsync("ui/ateliercommonyumiaui_atlas", "category" .. var6_2, arg0_2:Find("categoryBg/category"))
		end

		setActive(arg0_2:Find("categoryBg"), var6_2 ~= 0)
		setText(arg0_2:Find("cntText"), arg1_2.count)
	end
}
