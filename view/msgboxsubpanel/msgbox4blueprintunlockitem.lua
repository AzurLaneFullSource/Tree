local var0_0 = class("Msgbox4BlueprintUnlockItem", import(".MsgboxSubPanel"))

function var0_0.getUIName(arg0_1)
	return "Msgbox4BlueprintUnlockItem"
end

function var0_0.OnRefresh(arg0_2, arg1_2)
	rtf(arg0_2.viewParent._window).sizeDelta = Vector2(1010, 685)

	local var0_2 = arg1_2.item
	local var1_2 = arg1_2.blueprints

	updateDrop(arg0_2._tf:Find("IconTpl"), {
		type = DROP_TYPE_ITEM,
		id = var0_2.id
	})
	setText(arg0_2._tf:Find("content_unlock/title/bg/Text"), i18n("tech_select_tip1"))
	setText(arg0_2._tf:Find("content_unlock/title/Text"), i18n("tech_select_tip2"))

	local var2_2 = arg0_2._tf:Find("content_unlock/list")
	local var3_2 = UIItemList.New(var2_2, var2_2:GetChild(0))

	var3_2:make(function(arg0_3, arg1_3, arg2_3)
		arg1_3 = arg1_3 + 1

		if arg0_3 == UIItemList.EventUpdate then
			updateDrop(arg2_3:Find("IconTpl"), {
				type = DROP_TYPE_SHIP,
				id = ShipGroup.getDefaultShipConfig(var1_2[arg1_3].id).id
			})
			setActive(arg2_3:Find("IconTpl/mask"), var1_2[arg1_3]:isUnlock())
			setText(arg2_3:Find("IconTpl/mask/Text"), i18n("tech_select_tip3"))
		end
	end)
	var3_2:align(#var1_2)

	local var4_2 = var0_2:getConfig("display_icon")

	setText(arg0_2._tf:Find("content_after/title/bg/Text"), i18n("tech_select_tip4"))
	setText(arg0_2._tf:Find("content_after/title/Text"), i18n("tech_select_tip5"))

	local var5_2 = arg0_2._tf:Find("content_after/list")
	local var6_2 = UIItemList.New(var5_2, var5_2:GetChild(0))

	var6_2:make(function(arg0_4, arg1_4, arg2_4)
		arg1_4 = arg1_4 + 1

		if arg0_4 == UIItemList.EventUpdate then
			local var0_4, var1_4, var2_4 = unpack(var4_2[arg1_4])

			updateDrop(arg2_4:Find("IconTpl"), {
				type = var0_4,
				id = var1_4,
				count = var2_4
			})
		end
	end)
	var6_2:align(#var4_2)
end

return var0_0
