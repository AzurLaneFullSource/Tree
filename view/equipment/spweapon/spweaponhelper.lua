local var0_0 = {}
local var1_0
local var2_0
local var3_0
local var4_0
local var5_0

local function var6_0(arg0_1, arg1_1)
	local var0_1 = arg0_1:Find("base")

	if IsNil(var0_1) then
		return
	end

	local var1_1 = arg1_1.name
	local var2_1 = arg1_1.value

	setActive(var0_1, var2_1)

	if not var2_1 then
		return
	end

	setText(var0_1:Find("name"), var1_1)
	Canvas.ForceUpdateCanvases()

	if not IsNil(var0_1:Find("value")) then
		setActive(var0_1:Find("value"), var2_1)
		changeToScrollText(var0_1:Find("value/Text"), var2_1)
	end

	if not IsNil(var0_1:Find("effect")) then
		setActive(var0_1:Find("effect"), false)
	end

	setActive(var0_1:Find("value/up"), arg1_1.compare and arg1_1.compare > 0)
	setActive(var0_1:Find("value/down"), arg1_1.compare and arg1_1.compare < 0)
	triggerToggle(var0_1, arg1_1.lock_open)

	if not arg1_1.lock_open and arg1_1.sub and #arg1_1.sub > 0 then
		GetComponent(var0_1, typeof(Toggle)).enabled = true
	else
		setActive(var0_1:Find("name/close"), false)
		setActive(var0_1:Find("name/open"), false)

		GetComponent(var0_1, typeof(Toggle)).enabled = false
	end
end

local function var7_0(arg0_2, arg1_2)
	local var0_2 = arg0_2:Find("desc")

	if IsNil(var0_2) then
		return
	end

	setActive(var0_2, arg1_2.desc)

	if not arg1_2.desc then
		return
	end

	setText(var0_2:Find("Text"), arg1_2.desc)
end

local function var8_0(arg0_3, arg1_3)
	var6_0(arg0_3, arg1_3)
	var7_0(arg0_3, arg1_3)
end

local function var9_0(arg0_4, arg1_4, arg2_4)
	removeAllChildren(arg0_4)
	var5_0(arg0_4, arg1_4, arg2_4)
end

function var5_0(arg0_5, arg1_5, arg2_5)
	for iter0_5, iter1_5 in ipairs(arg2_5) do
		local var0_5 = cloneTplTo(arg1_5, arg0_5)

		var8_0(var0_5, iter1_5)
	end
end

function updateSpWeaponInfo(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6:Find("attr_tpl")

	var9_0(arg0_6:Find("attrs"), var0_6, arg1_6.attrs)

	local var1_6 = {}

	if arg2_6[1].skillId > 0 then
		local var2_6 = getSkillDesc(arg2_6[1].skillId, arg2_6[1].lv)

		if not arg2_6[1].unlock then
			var2_6 = setColorStr(i18n("spweapon_tip_skill_locked") .. var2_6, "#a2a2a2")
		end

		table.insert(var1_6, {
			name = i18n("spweapon_attr_effect"),
			value = setColorStr(getSkillName(arg2_6[1].skillId), arg2_6[1].unlock and "#FFDE00FF" or "#A2A2A2"),
			desc = var2_6
		})
	end

	if arg2_6[2].skillId > 0 then
		local var3_6 = getSkillDesc(arg2_6[2].skillId, arg2_6[2].lv)

		if not arg2_6[2].unlock then
			var3_6 = setColorStr(i18n("spweapon_tip_skill_locked") .. var3_6, "#a2a2a2")
		end

		table.insert(var1_6, {
			name = i18n("spweapon_attr_skillupgrade"),
			value = setColorStr(getSkillName(arg2_6[2].skillId), arg2_6[2].unlock and "#FFDE00FF" or "#A2A2A2"),
			desc = var3_6
		})
	end

	var5_0(arg0_6:Find("attrs"), var0_6, var1_6)

	local var4_6 = cloneTplTo(var0_6, arg0_6:Find("part"))

	var4_6:SetSiblingIndex(0)
	var8_0(var4_6, {
		value = "",
		name = i18n("equip_info_23")
	})

	local var5_6 = arg0_6:Find("part/value")
	local var6_6 = var5_6:Find("label")
	local var7_6 = {}
	local var8_6 = {}

	if #arg1_6.part[1] == 0 and #arg1_6.part[2] == 0 then
		setmetatable(var7_6, {
			__index = function(arg0_7, arg1_7)
				return true
			end
		})
		setmetatable(var8_6, {
			__index = function(arg0_8, arg1_8)
				return true
			end
		})
	else
		for iter0_6, iter1_6 in ipairs(arg1_6.part[1]) do
			var7_6[iter1_6] = true
		end

		for iter2_6, iter3_6 in ipairs(arg1_6.part[2]) do
			var8_6[iter3_6] = true
		end
	end

	local var9_6 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var7_6, var8_6)

	UIItemList.StaticAlign(var5_6, var6_6, #var9_6, function(arg0_9, arg1_9, arg2_9)
		arg1_9 = arg1_9 + 1

		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = var9_6[arg1_9]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0_9), arg2_9)
			setActive(arg2_9:Find("main"), var7_6[var0_9] and not var8_6[var0_9])
			setActive(arg2_9:Find("sub"), var8_6[var0_9] and not var7_6[var0_9])
			setImageAlpha(arg2_9, not var7_6[var0_9] and not var8_6[var0_9] and 0.3 or 1)
		end
	end)
	setActive(var0_6, false)
end

function var0_0.AlignAttrs(arg0_10, arg1_10)
	for iter0_10 = 1, #arg0_10 do
		if not arg1_10[iter0_10] or arg0_10[iter0_10].type ~= arg1_10[iter0_10].type then
			local var0_10 = false

			for iter1_10 = iter0_10 + 1, #arg1_10 do
				if arg1_10[iter0_10].type == arg1_10[iter1_10].type then
					local var1_10 = table.remove(arg1_10, iter1_10)

					table.insert(arg1_10, iter0_10, var1_10)

					var0_10 = true

					break
				end
			end

			if not var0_10 then
				table.insert(arg1_10, iter0_10, {
					type = arg0_10[iter0_10].type
				})

				arg1_10[iter0_10].empty = true
			end
		end
	end

	for iter2_10 = #arg0_10 + 1, #arg1_10 do
		table.insert(arg0_10, {
			type = arg1_10[iter2_10].type
		})

		arg0_10[iter2_10].empty = true
	end
end

function var0_0.CompareInfo(arg0_11, arg1_11)
	local var0_11 = arg0_11.empty and 0 or arg0_11.configAttr + arg0_11.baseAttr

	arg1_11.compare = (arg1_11.empty and 0 or arg1_11.configAttr + arg1_11.baseAttr) - var0_11
end

function var0_0.InsertAttrsCompare(arg0_12, arg1_12)
	var0_0.AlignAttrs(arg0_12, arg1_12)

	for iter0_12 = 1, #arg0_12 do
		var0_0.CompareInfo(arg0_12[iter0_12], arg1_12[iter0_12])
	end
end

local function var10_0(arg0_13)
	local var0_13 = arg0_13:GetConfigAttributes()
	local var1_13 = arg0_13:GetBaseAttributes()

	return {
		{
			type = arg0_13:getConfig("attribute_1"),
			configAttr = var0_13[1],
			baseAttr = var1_13[1]
		},
		{
			type = arg0_13:getConfig("attribute_2"),
			configAttr = var0_13[2],
			baseAttr = var1_13[2]
		}
	}
end

local function var11_0(arg0_14, arg1_14)
	local var0_14 = {
		attrs = {}
	}

	for iter0_14 = 1, #arg0_14 do
		local var1_14 = arg0_14[iter0_14]
		local var2_14 = AttributeType.Type2Name(var1_14.type)
		local var3_14

		if not var1_14.empty then
			var3_14 = var1_14.configAttr .. " + " .. var1_14.baseAttr

			if not arg1_14:IsReal() then
				var3_14 = var3_14 .. "~" .. arg1_14:GetAttributesRange()[iter0_14]
			end
		else
			var3_14 = 0
		end

		table.insert(var0_14.attrs, {
			name = var2_14,
			value = var3_14,
			compare = var1_14.compare
		})
	end

	local var4_14 = arg1_14:GetWearableShipTypes()

	var0_14.part = {
		var4_14,
		var4_14
	}

	return var0_14
end

function var0_0.TransformNormalInfo(arg0_15)
	local var0_15 = var10_0(arg0_15)

	return var11_0(var0_15, arg0_15)
end

function var0_0.CompareNormalInfo(arg0_16, arg1_16)
	local var0_16 = var10_0(arg0_16)
	local var1_16 = var10_0(arg1_16)

	var0_0.InsertAttrsCompare(var0_16, var1_16)

	return var11_0(var0_16, arg0_16), var11_0(var1_16, arg1_16)
end

function var0_0.TransformCompositeInfo(arg0_17)
	local var0_17 = {}
	local var1_17 = {
		arg0_17:getConfig("attribute_1"),
		arg0_17:getConfig("attribute_2")
	}
	local var2_17 = arg0_17:GetConfigAttributes()
	local var3_17 = arg0_17:GetAttributesRange()

	for iter0_17 = 1, 2 do
		local var4_17 = AttributeType.Type2Name(var1_17[iter0_17])
		local var5_17 = var2_17[iter0_17] .. " + 0~" .. var3_17[iter0_17]

		table.insert(var0_17, {
			name = var4_17,
			value = var5_17
		})
	end

	return var0_17
end

function var0_0.TransformUpgradeInfo(arg0_18, arg1_18)
	local var0_18 = {}
	local var1_18 = {
		arg0_18:getConfig("attribute_1"),
		arg0_18:getConfig("attribute_2")
	}
	local var2_18 = arg0_18:GetConfigAttributes()
	local var3_18 = arg1_18:GetConfigAttributes()
	local var4_18 = arg0_18:GetBaseAttributes()

	for iter0_18 = 1, 2 do
		local var5_18 = AttributeType.Type2Name(var1_18[iter0_18])
		local var6_18 = var3_18[iter0_18] .. " + " .. var4_18[iter0_18]

		if var2_18[iter0_18] ~= var3_18[iter0_18] then
			var6_18 = var2_18[iter0_18] .. "   >   " .. var6_18
		end

		table.insert(var0_18, {
			name = var5_18,
			value = var6_18
		})
	end

	return var0_18
end

return var0_0
