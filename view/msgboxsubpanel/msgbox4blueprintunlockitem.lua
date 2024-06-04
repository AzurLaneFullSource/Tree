local var0 = class("Msgbox4BlueprintUnlockItem", import(".MsgboxSubPanel"))

function var0.getUIName(arg0)
	return "Msgbox4BlueprintUnlockItem"
end

function var0.OnRefresh(arg0, arg1)
	rtf(arg0.viewParent._window).sizeDelta = Vector2(1010, 685)

	local var0 = arg1.item
	local var1 = arg1.blueprints

	updateDrop(arg0._tf:Find("IconTpl"), {
		type = DROP_TYPE_ITEM,
		id = var0.id
	})
	setText(arg0._tf:Find("content_unlock/title/bg/Text"), i18n("tech_select_tip1"))
	setText(arg0._tf:Find("content_unlock/title/Text"), i18n("tech_select_tip2"))

	local var2 = arg0._tf:Find("content_unlock/list")
	local var3 = UIItemList.New(var2, var2:GetChild(0))

	var3:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			updateDrop(arg2:Find("IconTpl"), {
				type = DROP_TYPE_SHIP,
				id = ShipGroup.getDefaultShipConfig(var1[arg1].id).id
			})
			setActive(arg2:Find("IconTpl/mask"), var1[arg1]:isUnlock())
			setText(arg2:Find("IconTpl/mask/Text"), i18n("tech_select_tip3"))
		end
	end)
	var3:align(#var1)

	local var4 = var0:getConfig("display_icon")

	setText(arg0._tf:Find("content_after/title/bg/Text"), i18n("tech_select_tip4"))
	setText(arg0._tf:Find("content_after/title/Text"), i18n("tech_select_tip5"))

	local var5 = arg0._tf:Find("content_after/list")
	local var6 = UIItemList.New(var5, var5:GetChild(0))

	var6:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0, var1, var2 = unpack(var4[arg1])

			updateDrop(arg2:Find("IconTpl"), {
				type = var0,
				id = var1,
				count = var2
			})
		end
	end)
	var6:align(#var4)
end

return var0
