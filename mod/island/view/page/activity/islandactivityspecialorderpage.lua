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

function var0_0.OnFirstFlush(arg0_3)
	local var0_3 = {
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

	UIItemList.StaticAlign(arg0_3.rtTabs, arg0_3.rtTabTpl, #var0_3, function(arg0_4, arg1_4, arg2_4)
		arg1_4 = arg1_4 + 1

		if arg0_4 == UIItemList.EventUpdate then
			local var0_4, var1_4 = unpack(var0_3[arg1_4])

			setText(arg2_4:Find("on/Text"), i18n(var0_4))
			setText(arg2_4:Find("off/Text"), i18n(var0_4))
			setActive(arg2_4:Find("line"), arg1_4 < #var0_3)
			onToggle(arg0_3, arg2_4, function(arg0_5)
				if arg0_5 then
					arg0_3.index = arg1_4

					eachChild(arg0_3.rtPages, function(arg0_6, arg1_6)
						arg1_6 = arg1_6 + 1

						setActive(arg0_6, arg1_4 == arg1_6)
					end)
					setText(arg0_3.rtTitle:Find("Text"), i18n(var1_4))
					eachChild(arg0_3.rtPages:GetChild(arg1_4 - 1):Find("content"), function(arg0_7, arg1_7)
						local var0_7 = arg0_7:Find("tpl")
						local var1_7 = {}

						if arg1_7 > 0 then
							table.insert(var1_7, function(arg0_8)
								setCanvasGroupAlpha(var0_7, 0)
								LeanTween.delayedCall(arg1_7 * 0.08, System.Action(arg0_8))
							end)
						end

						seriesAsync(var1_7, function()
							if arg0_3._state == var0_0.STATES.DESTROY then
								return
							end

							quickPlayAnimation(var0_7, "Anim_IslandActivitySpecialOrderPageTPl_in")
						end)
					end)
				end
			end, SFX_PANEL)
		end
	end)
	setText(arg0_3.rtTitle:Find("level/Text"), i18n("island_spoperation_level_2509_1"))
	eachChild(arg0_3.rtPages:Find("page_2/content"), function(arg0_10, arg1_10)
		arg1_10 = arg1_10 + 1

		setText(arg0_10:Find("tpl/name"), i18n("island_spoperation_item_2509_" .. arg1_10))
	end)
end

function var0_0.OnUpdateFlush(arg0_11)
	return
end

function var0_0.OnShowFlush(arg0_12)
	quickPlayAnimation(arg0_12._tf, "Anim_IslandActivitySpecialOrderPage_in")
	triggerToggle(arg0_12.rtTabs:GetChild((arg0_12.index or 1) - 1), true)
end

return var0_0
