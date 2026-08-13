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

	if not arg1_1.lock_open and arg1_1.sub and #arg1_1.sub > 0 then
		onToggle(nil, var0_1, function(arg0_2)
			setActive(var0_1:Find("sub"), arg0_2)
		end, SFX_PANEL)
		triggerToggle(var0_1, arg1_1.lock_open)

		GetComponent(var0_1, typeof(Toggle)).enabled = true
	elseif arg1_1.descTrigger ~= nil then
		local var3_1 = arg0_1:Find("desc")

		onToggle(nil, var0_1, function(arg0_3)
			setActive(var3_1, arg0_3)
		end, SFX_PANEL)
		onButton(nil, var3_1, function()
			triggerToggle(var0_1, false)
		end, SFX_PANEL)
		triggerToggle(var0_1, arg1_1.descTrigger)

		GetComponent(var0_1, typeof(Toggle)).enabled = true
	else
		setActive(var0_1:Find("name/close"), false)
		setActive(var0_1:Find("name/open"), false)
		removeOnToggle(var0_1)

		GetComponent(var0_1, typeof(Toggle)).enabled = false
	end
end

local function var7_0(arg0_5, arg1_5)
	local var0_5 = arg0_5:Find("desc")

	if IsNil(var0_5) then
		return
	end

	if arg1_5.descTrigger == nil then
		setActive(var0_5, arg1_5.desc)
	end

	if not arg1_5.desc then
		return
	end

	setText(var0_5:Find("Text"), arg1_5.desc)
end

local function var8_0(arg0_6, arg1_6)
	var6_0(arg0_6, arg1_6)
	var7_0(arg0_6, arg1_6)
end

local function var9_0(arg0_7, arg1_7, arg2_7)
	removeAllChildren(arg0_7)
	var5_0(arg0_7, arg1_7, arg2_7)
end

function var5_0(arg0_8, arg1_8, arg2_8)
	for iter0_8, iter1_8 in ipairs(arg2_8) do
		local var0_8 = cloneTplTo(arg1_8, arg0_8)

		var8_0(var0_8, iter1_8)
	end
end

function updateSpWeaponInfo(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg0_9:Find("attr_tpl")

	var9_0(arg0_9:Find("attrs"), var0_9, arg1_9.attrs)

	local var1_9 = {}

	if arg2_9[1].skillId > 0 then
		local var2_9 = getSkillDesc(arg2_9[1].skillId, arg2_9[1].lv)

		if not arg2_9[1].unlock then
			var2_9 = setColorStr(i18n("spweapon_tip_skill_locked") .. var2_9, "#a2a2a2")
		end

		table.insert(var1_9, {
			name = i18n("spweapon_attr_effect"),
			value = setColorStr(getSkillName(arg2_9[1].skillId), arg2_9[1].unlock and "#FFDE00FF" or "#A2A2A2"),
			desc = var2_9,
			descTrigger = defaultValue(arg2_9[1].descTrigger, arg2_9[1].unlock)
		})
	end

	for iter0_9, iter1_9 in ipairs(arg2_9[2]) do
		local var3_9 = getSkillDesc(iter1_9.skillId, iter1_9.lv)

		if not iter1_9.unlock then
			var3_9 = setColorStr(i18n("spweapon_tip_skill_locked") .. var3_9, "#a2a2a2")
		end

		table.insert(var1_9, {
			name = i18n("spweapon_attr_skillupgrade"),
			value = setColorStr(getSkillName(iter1_9.skillId), iter1_9.unlock and "#FFDE00FF" or "#A2A2A2"),
			desc = var3_9,
			descTrigger = defaultValue(iter1_9.descTrigger, iter1_9.unlock)
		})
	end

	var5_0(arg0_9:Find("attrs"), var0_9, var1_9)

	local var4_9 = cloneTplTo(var0_9, arg0_9:Find("part"))

	var4_9:SetSiblingIndex(0)
	var8_0(var4_9, {
		value = "",
		name = i18n("equip_info_23")
	})

	local var5_9 = arg0_9:Find("part/value")
	local var6_9 = var5_9:Find("label")
	local var7_9 = {}
	local var8_9 = {}

	if #arg1_9.part[1] == 0 and #arg1_9.part[2] == 0 then
		setmetatable(var7_9, {
			__index = function(arg0_10, arg1_10)
				return true
			end
		})
		setmetatable(var8_9, {
			__index = function(arg0_11, arg1_11)
				return true
			end
		})
	else
		for iter2_9, iter3_9 in ipairs(arg1_9.part[1]) do
			var7_9[iter3_9] = true
		end

		for iter4_9, iter5_9 in ipairs(arg1_9.part[2]) do
			var8_9[iter5_9] = true
		end
	end

	local var9_9 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var7_9, var8_9)

	UIItemList.StaticAlign(var5_9, var6_9, #var9_9, function(arg0_12, arg1_12, arg2_12)
		arg1_12 = arg1_12 + 1

		if arg0_12 == UIItemList.EventUpdate then
			local var0_12 = var9_9[arg1_12]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0_12), arg2_12)
			setActive(arg2_12:Find("main"), var7_9[var0_12] and not var8_9[var0_12])
			setActive(arg2_12:Find("sub"), var8_9[var0_12] and not var7_9[var0_12])
			setImageAlpha(arg2_12, not var7_9[var0_12] and not var8_9[var0_12] and 0.3 or 1)
		end
	end)
	setActive(var0_9, false)
end

function var0_0.AlignAttrs(arg0_13, arg1_13)
	for iter0_13 = 1, #arg0_13 do
		if not arg1_13[iter0_13] or arg0_13[iter0_13].type ~= arg1_13[iter0_13].type then
			local var0_13 = false

			for iter1_13 = iter0_13 + 1, #arg1_13 do
				if arg1_13[iter0_13].type == arg1_13[iter1_13].type then
					local var1_13 = table.remove(arg1_13, iter1_13)

					table.insert(arg1_13, iter0_13, var1_13)

					var0_13 = true

					break
				end
			end

			if not var0_13 then
				table.insert(arg1_13, iter0_13, {
					type = arg0_13[iter0_13].type
				})

				arg1_13[iter0_13].empty = true
			end
		end
	end

	for iter2_13 = #arg0_13 + 1, #arg1_13 do
		table.insert(arg0_13, {
			type = arg1_13[iter2_13].type
		})

		arg0_13[iter2_13].empty = true
	end
end

function var0_0.CompareInfo(arg0_14, arg1_14)
	local var0_14 = arg0_14.empty and 0 or arg0_14.configAttr + arg0_14.baseAttr

	arg1_14.compare = (arg1_14.empty and 0 or arg1_14.configAttr + arg1_14.baseAttr) - var0_14
end

function var0_0.InsertAttrsCompare(arg0_15, arg1_15)
	var0_0.AlignAttrs(arg0_15, arg1_15)

	for iter0_15 = 1, #arg0_15 do
		var0_0.CompareInfo(arg0_15[iter0_15], arg1_15[iter0_15])
	end
end

local function var10_0(arg0_16)
	local var0_16 = arg0_16:GetConfigAttributes()
	local var1_16 = arg0_16:GetBaseAttributes()

	return {
		{
			type = arg0_16:getConfig("attribute_1"),
			configAttr = var0_16[1],
			baseAttr = var1_16[1]
		},
		{
			type = arg0_16:getConfig("attribute_2"),
			configAttr = var0_16[2],
			baseAttr = var1_16[2]
		}
	}
end

local function var11_0(arg0_17, arg1_17)
	local var0_17 = {
		attrs = {}
	}

	for iter0_17 = 1, #arg0_17 do
		local var1_17 = arg0_17[iter0_17]
		local var2_17 = AttributeType.Type2Name(var1_17.type)
		local var3_17

		if not var1_17.empty then
			var3_17 = var1_17.configAttr .. " + " .. var1_17.baseAttr

			if not arg1_17:IsReal() then
				var3_17 = var3_17 .. "~" .. arg1_17:GetAttributesRange()[iter0_17]
			end
		else
			var3_17 = 0
		end

		table.insert(var0_17.attrs, {
			name = var2_17,
			value = var3_17,
			compare = var1_17.compare
		})
	end

	local var4_17 = arg1_17:GetWearableShipTypes()

	var0_17.part = {
		var4_17,
		var4_17
	}

	return var0_17
end

function var0_0.TransformNormalInfo(arg0_18)
	local var0_18 = var10_0(arg0_18)

	return var11_0(var0_18, arg0_18)
end

function var0_0.CompareNormalInfo(arg0_19, arg1_19)
	local var0_19 = var10_0(arg0_19)
	local var1_19 = var10_0(arg1_19)

	var0_0.InsertAttrsCompare(var0_19, var1_19)

	return var11_0(var0_19, arg0_19), var11_0(var1_19, arg1_19)
end

function var0_0.TransformCompositeInfo(arg0_20)
	local var0_20 = {}
	local var1_20 = {
		arg0_20:getConfig("attribute_1"),
		arg0_20:getConfig("attribute_2")
	}
	local var2_20 = arg0_20:GetConfigAttributes()
	local var3_20 = arg0_20:GetAttributesRange()

	for iter0_20 = 1, 2 do
		local var4_20 = AttributeType.Type2Name(var1_20[iter0_20])
		local var5_20 = var2_20[iter0_20] .. " + 0~" .. var3_20[iter0_20]

		table.insert(var0_20, {
			name = var4_20,
			value = var5_20
		})
	end

	return var0_20
end

function var0_0.TransformUpgradeInfo(arg0_21, arg1_21)
	local var0_21 = {}
	local var1_21 = {
		arg0_21:getConfig("attribute_1"),
		arg0_21:getConfig("attribute_2")
	}
	local var2_21 = arg0_21:GetConfigAttributes()
	local var3_21 = arg1_21:GetConfigAttributes()
	local var4_21 = arg0_21:GetBaseAttributes()

	for iter0_21 = 1, 2 do
		local var5_21 = AttributeType.Type2Name(var1_21[iter0_21])
		local var6_21 = var3_21[iter0_21] .. " + " .. var4_21[iter0_21]

		if var2_21[iter0_21] ~= var3_21[iter0_21] then
			var6_21 = var2_21[iter0_21] .. "   >   " .. var6_21
		end

		table.insert(var0_21, {
			name = var5_21,
			value = var6_21
		})
	end

	return var0_21
end

return var0_0
