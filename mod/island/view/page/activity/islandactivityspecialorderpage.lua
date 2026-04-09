local var0_0 = class("IslandActivitySpecialOrderPage", import("Mod.Island.View.page.activity.IslandBaseActivityPage"))

function var0_0.OnInit(arg0_1)
	local var0_1 = arg0_1._tf:GetComponent(typeof(ItemList)).prefabItem:ToTable()

	for iter0_1, iter1_1 in ipairs({
		"rtPages",
		"rtTitle",
		"rtTabs",
		"rtTabTpl"
	}) do
		arg0_1[iter1_1] = var0_1[iter0_1].transform
	end
end

function var0_0.OnDataSetting(arg0_2)
	return
end

function var0_0.getTabTipMapList(arg0_3)
	return {
		{
			"island_spoperation_btn_2509_1",
			"island_spoperation_tip_2509_3"
		},
		{
			"island_spoperation_btn_2509_2",
			"island_spoperation_tip_2509_2"
		},
		{
			"island_spoperation_btn_2509_3",
			"island_spoperation_tip_2509_1"
		}
	}
end

function var0_0.getItemTipPrefix(arg0_4)
	return "island_spoperation_item_2509_"
end

function var0_0.OnFirstFlush(arg0_5)
	local var0_5 = arg0_5:getTabTipMapList()

	UIItemList.StaticAlign(arg0_5.rtTabs, arg0_5.rtTabTpl, #var0_5, function(arg0_6, arg1_6, arg2_6)
		arg1_6 = arg1_6 + 1

		if arg0_6 == UIItemList.EventUpdate then
			local var0_6, var1_6 = unpack(var0_5[arg1_6])

			setText(arg2_6:Find("on/Text"), i18n(var0_6))
			setText(arg2_6:Find("off/Text"), i18n(var0_6))
			setActive(arg2_6:Find("line"), arg1_6 < #var0_5)
			onToggle(arg0_5, arg2_6, function(arg0_7)
				if arg0_7 then
					arg0_5.index = arg1_6

					eachChild(arg0_5.rtPages, function(arg0_8, arg1_8)
						arg1_8 = arg1_8 + 1

						setActive(arg0_8, arg1_6 == arg1_8)
					end)
					setText(arg0_5.rtTitle:Find("Text"), i18n(var1_6))
					eachChild(arg0_5.rtPages:GetChild(arg1_6 - 1):Find("content"), function(arg0_9, arg1_9)
						local var0_9 = arg0_9:Find("tpl")
						local var1_9 = {}

						if arg1_9 > 0 then
							table.insert(var1_9, function(arg0_10)
								setCanvasGroupAlpha(var0_9, 0)
								LeanTween.delayedCall(arg1_9 * 0.08, System.Action(arg0_10))
							end)
						end

						seriesAsync(var1_9, function()
							if arg0_5._state == var0_0.STATES.DESTROY then
								return
							end

							quickPlayAnimation(var0_9, "Anim_IslandActivitySpecialOrderPageTPl_in")
						end)
					end)
				end
			end, SFX_PANEL)

			if arg1_6 == 1 then
				triggerToggle(arg2_6, true)
			end
		end
	end)
	setText(arg0_5.rtTitle:Find("level/Text"), i18n("island_spoperation_level_2509_1"))
	eachChild(arg0_5.rtPages:Find("page_2/content"), function(arg0_12, arg1_12)
		arg1_12 = arg1_12 + 1

		setText(arg0_12:Find("tpl/name"), i18n(arg0_5:getItemTipPrefix() .. arg1_12))
	end)
end

function var0_0.OnUpdateFlush(arg0_13)
	return
end

function var0_0.OnShowFlush(arg0_14)
	quickPlayAnimation(arg0_14._tf, "Anim_IslandActivitySpecialOrderPage_in")
	triggerToggle(arg0_14.rtTabs:GetChild((arg0_14.index or 1) - 1), true)
end

return var0_0
