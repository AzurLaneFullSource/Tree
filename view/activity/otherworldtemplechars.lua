local var0 = class("OtherWorldTempleChars")
local var1 = "other_world_temple_char"

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	arg0._event = arg2

	onButton(arg0._event, findTF(arg0._tf, "ad/btnClose"), function()
		arg0:setActive(false)
	end, SFX_CANCEL)
	onButton(arg0._event, findTF(arg0._tf, "ad/clickClose"), function()
		arg0:setActive(false)
	end, SFX_CANCEL)

	arg0._charTpl = findTF(arg0._tf, "ad/chars/content/charTpl")

	setText(findTF(arg0._charTpl, "got/img/text"), i18n("word_got"))
	setActive(arg0._charTpl, false)

	arg0._charItems = {}
	arg0._charContent = findTF(arg0._tf, "ad/chars/content")
end

function var0.setData(arg0, arg1)
	arg0.charIds = arg1
end

function var0.updateActivityPool(arg0, arg1)
	arg0.activityPools = arg1
end

function var0.updateSelect(arg0)
	arg0:updateItemsCount(#arg0.charIds)

	for iter0 = 1, #arg0._charItems do
		local var0 = arg0._charItems[iter0]

		setActive(var0, false)

		if iter0 <= #arg0.charIds then
			setActive(var0, true)
			arg0:setItemData(var0, arg0.charIds[iter0])
		end
	end

	setText(findTF(arg0._tf, "ad/title/text"), i18n(var1))
end

function var0.setItemData(arg0, arg1, arg2)
	local var0 = pg.guardian_template[arg2]
	local var1 = arg0.activityPools[var0.guardian_gain_pool]
	local var2 = ""
	local var3 = var1:getGuardianGot(arg2)

	if var0.type == 1 then
		var2 = string.gsub(var0.guardian_gain_desc, "$1", math.min(var1:getFetchCount(), var0.guardian_gain[2]))
	elseif var0.type == 2 then
		if var3 then
			var2 = var0.guardian_gain_desc
		else
			var2 = "???"
		end
	end

	if var0.type == 2 then
		setText(findTF(arg1, "desc/text"), var3 and var0.guardian_desc or "???")
		setText(findTF(arg1, "name/text"), var3 and var0.guardian_name or "???")
	else
		setText(findTF(arg1, "name/text"), var0.guardian_name)
		setText(findTF(arg1, "desc/text"), var0.guardian_desc)
	end

	if PLATFORM_CODE ~= PLATFORM_CH then
		GetComponent(findTF(arg1, "name/text"), typeof(Text)).fontSize = 30
		GetComponent(findTF(arg1, "desc/text"), typeof(Text)).fontSize = 24
	end

	if var0.type == 2 then
		setActive(findTF(arg1, "icon/mask/img"), var3)
	end

	LoadImageSpriteAsync("shipyardicon/" .. var0.guardian_painting, findTF(arg1, "icon/mask/img"), true)
	setText(findTF(arg1, "tip/text"), var2)
	setActive(findTF(arg1, "icon/lock"), not var3)
	setActive(findTF(arg1, "got"), var3)
end

function var0.updateItemsCount(arg0, arg1)
	local var0 = 0

	if arg1 > #arg0._charItems then
		var0 = arg1 - #arg0._charItems
	end

	for iter0 = 1, var0 do
		local var1 = tf(instantiate(arg0._charTpl))

		SetParent(var1, arg0._charContent)
		table.insert(arg0._charItems, var1)
	end
end

function var0.setActive(arg0, arg1)
	setActive(arg0._tf, arg1)
end

return var0
