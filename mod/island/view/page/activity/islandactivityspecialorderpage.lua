local var0_0 = class("IslandActivitySpecialOrderPage", import("Mod.Island.View.page.activity.IslandBaseActivityPage"))

function var0_0.OnDataSetting(arg0_1)
	return
end

function var0_0.getTabTipMapList(arg0_2)
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

function var0_0.getItemTipPrefix(arg0_3)
	return "island_spoperation_item_2509_"
end

function var0_0.OnFirstFlush(arg0_4)
	local var0_4 = arg0_4:getTabTipMapList()

	UIItemList.StaticAlign(arg0_4.rtTabs, arg0_4.rtTabTpl, #var0_4, function(arg0_5, arg1_5, arg2_5)
		arg1_5 = arg1_5 + 1

		if arg0_5 == UIItemList.EventUpdate then
			local var0_5, var1_5 = unpack(var0_4[arg1_5])

			setText(arg2_5:Find("on/Text"), i18n(var0_5))
			setText(arg2_5:Find("off/Text"), i18n(var0_5))
			setActive(arg2_5:Find("line"), arg1_5 < #var0_4)
			onToggle(arg0_4, arg2_5, function(arg0_6)
				if arg0_6 then
					arg0_4.index = arg1_5

					eachChild(arg0_4.rtPages, function(arg0_7, arg1_7)
						arg1_7 = arg1_7 + 1

						setActive(arg0_7, arg1_5 == arg1_7)
					end)
					setText(arg0_4.rtTitle:Find("Text"), i18n(var1_5))
					eachChild(arg0_4.rtPages:GetChild(arg1_5 - 1):Find("content"), function(arg0_8, arg1_8)
						local var0_8 = arg0_8:Find("tpl")
						local var1_8 = {}

						if arg1_8 > 0 then
							table.insert(var1_8, function(arg0_9)
								setCanvasGroupAlpha(var0_8, 0)
								LeanTween.delayedCall(arg1_8 * 0.08, System.Action(arg0_9))
							end)
						end

						seriesAsync(var1_8, function()
							if arg0_4._state == var0_0.STATES.DESTROY then
								return
							end

							quickPlayAnimation(var0_8, "Anim_IslandActivitySpecialOrderPageTPl_in")
						end)
					end)
				end
			end, SFX_PANEL)

			if arg1_5 == 1 then
				triggerToggle(arg2_5, true)
			end
		end
	end)
	setText(arg0_4.rtTitle:Find("level/Text"), i18n("island_spoperation_level_2509_1"))
	eachChild(arg0_4.rtPages:Find("page_2/content"), function(arg0_11, arg1_11)
		arg1_11 = arg1_11 + 1

		setText(arg0_11:Find("tpl/name"), i18n(arg0_4:getItemTipPrefix() .. arg1_11))
	end)
end

function var0_0.OnUpdateFlush(arg0_12)
	return
end

function var0_0.OnShowFlush(arg0_13)
	quickPlayAnimation(arg0_13._tf, "Anim_IslandActivitySpecialOrderPage_in")
	triggerToggle(arg0_13.rtTabs:GetChild((arg0_13.index or 1) - 1), true)
end

return var0_0
