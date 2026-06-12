local var0_0 = class("MailReDropWindow", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MailReDropMsgboxUI"
end

function var0_0.OnInit(arg0_2)
	onButton(arg0_2, arg0_2._tf:Find("bg"), function()
		arg0_2:Hide()
	end, SFX_PANEL)

	arg0_2.closeBtn = arg0_2._tf:Find("adapt/window_redrop/top/btnBack")

	onButton(arg0_2, arg0_2.closeBtn, function()
		arg0_2:Hide()
	end, SFX_PANEL)

	arg0_2._window_redrop = arg0_2._tf:Find("adapt/window_redrop")
	arg0_2.titleTips = arg0_2._window_redrop:Find("top/bg/infomation/title")
	arg0_2._itemConfireText = arg0_2._window_redrop:Find("content"):GetComponent("RichText")
	arg0_2._confireLabel = arg0_2._window_redrop:Find("desc/label1")
	arg0_2._confireInput = arg0_2._window_redrop:Find("desc/InputField")
	arg0_2._redroptitleTips = arg0_2._window_redrop:Find("top/bg/infomation/title")
	arg0_2.PlaceholderText = arg0_2._confireInput:Find("Placeholder")
	arg0_2._redropcancelButton = arg0_2._window_redrop:Find("button_container/btn_not")
	arg0_2._redropconfirmButton = arg0_2._window_redrop:Find("button_container/btn_ok")
	arg0_2.item = arg0_2._window_redrop:Find("item")
	arg0_2.items = arg0_2._window_redrop:Find("items")
	arg0_2.itemList = UIItemList.New(arg0_2.items, arg0_2.item)
	arg0_2.imgCache = {}
	arg0_2.dropIdCache = {}

	setText(arg0_2._redropcancelButton:Find("Text"), i18n("mail_box_cancel"))
	setText(arg0_2._redropconfirmButton:Find("Text"), i18n("mail_box_confirm"))
	setText(arg0_2.titleTips, i18n("mail_boxtitle_information"))
	setText(arg0_2.PlaceholderText, i18n("mail_search"))
end

function var0_0.Updatelayout(arg0_5)
	if not arg0_5.key then
		arg0_5.key = math.random(100000, 999999)

		setText(arg0_5._confireLabel, i18n("mail_storeroom_max_2", arg0_5.key))
	else
		setText(arg0_5._confireLabel, "")
	end
end

function var0_0.showConformMsgBox(arg0_6, arg1_6)
	local var0_6 = arg1_6.dropList

	arg0_6:refrshContent(var0_6, arg1_6.content)

	arg0_6.key = nil

	arg0_6:Updatelayout()
	onButton(arg0_6, arg0_6._redropcancelButton, function()
		arg0_6:Hide()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6._redropconfirmButton, function()
		if arg0_6.key then
			local var0_8 = getInputText(arg0_6._confireInput)

			if arg0_6.key ~= tonumber(var0_8) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("mail_input_erro"))

				return
			end
		end

		arg0_6:Hide()

		if arg1_6.onYes then
			arg1_6.onYes()
		end
	end, SFX_PANEL)
	setActive(arg0_6.item, false)
	arg0_6.itemList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = arg2_9:Find("IconTpl")
			local var1_9 = var0_6[arg1_9 + 1]
			local var2_9 = {
				type = var1_9.type,
				id = var1_9.id,
				count = var1_9.count
			}
			local var3_9 = arg2_9:Find("name_bg/name")

			updateDrop(var0_9, var2_9)
			setScrollText(var3_9, var1_9:getName())
		end
	end)
	arg0_6.itemList:align(#var0_6)
end

function var0_0.refrshContent(arg0_10, arg1_10, arg2_10)
	local var0_10 = 0
	local var1_10 = ""

	for iter0_10, iter1_10 in ipairs(arg1_10) do
		local var2_10 = iter1_10.id
		local var3_10 = iter1_10.count

		if not arg0_10.dropIdCache[var2_10] then
			arg0_10.dropIdCache[var2_10] = arg0_10:GetRestoreNumByTargetId(var2_10)
		end

		local var4_10 = arg0_10.dropIdCache[var2_10][1] or 0
		local var5_10 = arg0_10.dropIdCache[var2_10][2]

		if var5_10 and not arg0_10.imgCache[var5_10] then
			local var6_10 = Item.getConfigData(var5_10).icon
			local var7_10 = GetSpriteFromAtlas(var6_10, "")

			arg0_10.imgCache[var5_10] = var6_10

			arg0_10._itemConfireText:AddSprite(var6_10, var7_10)
		end

		var1_10 = arg0_10.imgCache[var5_10]
		var0_10 = var4_10 * var3_10 + var0_10
	end

	local var8_10 = i18n(arg2_10, string.format("<icon name=%s w=0.7 h=0.7/>%d", var1_10, var0_10))

	arg0_10._itemConfireText.text = var8_10
end

function var0_0.GetRestoreNumByTargetId(arg0_11, arg1_11)
	local var0_11 = pg.equip_data_limit[arg1_11].restore_id
	local var1_11 = pg.drop_data_restore[var0_11]

	return {
		var1_11.resource_num,
		var1_11.resource_type
	}
end

function var0_0.Show(arg0_12, arg1_12)
	var0_0.super.Show(arg0_12)
	pg.UIMgr.GetInstance():BlurPanel(arg0_12._tf)
	arg0_12:showConformMsgBox(arg1_12)
end

function var0_0.Hide(arg0_13)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_13._tf, arg0_13._parentTf)
	var0_0.super.Hide(arg0_13)
	setInputText(arg0_13._confireInput, "")
end

function var0_0.OnDestroy(arg0_14)
	arg0_14.imgCache = nil

	if arg0_14:isShowing() then
		arg0_14:Hide()
	end
end

return var0_0
