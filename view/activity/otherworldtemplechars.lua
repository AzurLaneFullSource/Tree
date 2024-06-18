local var0_0 = class("OtherWorldTempleChars")
local var1_0 = "other_world_temple_char"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1

	onButton(arg0_1._event, findTF(arg0_1._tf, "ad/btnClose"), function()
		arg0_1:setActive(false)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1._tf, "ad/clickClose"), function()
		arg0_1:setActive(false)
	end, SFX_CANCEL)

	arg0_1._charTpl = findTF(arg0_1._tf, "ad/chars/content/charTpl")

	setText(findTF(arg0_1._charTpl, "got/img/text"), i18n("word_got"))
	setActive(arg0_1._charTpl, false)

	arg0_1._charItems = {}
	arg0_1._charContent = findTF(arg0_1._tf, "ad/chars/content")
end

function var0_0.setData(arg0_4, arg1_4)
	arg0_4.charIds = arg1_4
end

function var0_0.updateActivityPool(arg0_5, arg1_5)
	arg0_5.activityPools = arg1_5
end

function var0_0.updateSelect(arg0_6)
	arg0_6:updateItemsCount(#arg0_6.charIds)

	for iter0_6 = 1, #arg0_6._charItems do
		local var0_6 = arg0_6._charItems[iter0_6]

		setActive(var0_6, false)

		if iter0_6 <= #arg0_6.charIds then
			setActive(var0_6, true)
			arg0_6:setItemData(var0_6, arg0_6.charIds[iter0_6])
		end
	end

	setText(findTF(arg0_6._tf, "ad/title/text"), i18n(var1_0))
end

function var0_0.setItemData(arg0_7, arg1_7, arg2_7)
	local var0_7 = pg.guardian_template[arg2_7]
	local var1_7 = arg0_7.activityPools[var0_7.guardian_gain_pool]
	local var2_7 = ""
	local var3_7 = var1_7:getGuardianGot(arg2_7)

	if var0_7.type == 1 then
		var2_7 = string.gsub(var0_7.guardian_gain_desc, "$1", math.min(var1_7:getFetchCount(), var0_7.guardian_gain[2]))
	elseif var0_7.type == 2 then
		if var3_7 then
			var2_7 = var0_7.guardian_gain_desc
		else
			var2_7 = "???"
		end
	end

	if var0_7.type == 2 then
		setText(findTF(arg1_7, "desc/text"), var3_7 and var0_7.guardian_desc or "???")
		setText(findTF(arg1_7, "name/text"), var3_7 and var0_7.guardian_name or "???")
	else
		setText(findTF(arg1_7, "name/text"), var0_7.guardian_name)
		setText(findTF(arg1_7, "desc/text"), var0_7.guardian_desc)
	end

	if PLATFORM_CODE ~= PLATFORM_CH then
		GetComponent(findTF(arg1_7, "name/text"), typeof(Text)).fontSize = 30
		GetComponent(findTF(arg1_7, "desc/text"), typeof(Text)).fontSize = 24
	end

	if var0_7.type == 2 then
		setActive(findTF(arg1_7, "icon/mask/img"), var3_7)
	end

	LoadImageSpriteAsync("shipyardicon/" .. var0_7.guardian_painting, findTF(arg1_7, "icon/mask/img"), true)
	setText(findTF(arg1_7, "tip/text"), var2_7)
	setActive(findTF(arg1_7, "icon/lock"), not var3_7)
	setActive(findTF(arg1_7, "got"), var3_7)
end

function var0_0.updateItemsCount(arg0_8, arg1_8)
	local var0_8 = 0

	if arg1_8 > #arg0_8._charItems then
		var0_8 = arg1_8 - #arg0_8._charItems
	end

	for iter0_8 = 1, var0_8 do
		local var1_8 = tf(instantiate(arg0_8._charTpl))

		SetParent(var1_8, arg0_8._charContent)
		table.insert(arg0_8._charItems, var1_8)
	end
end

function var0_0.setActive(arg0_9, arg1_9)
	setActive(arg0_9._tf, arg1_9)
end

return var0_0
