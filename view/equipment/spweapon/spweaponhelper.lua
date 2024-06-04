local var0 = {}
local var1
local var2
local var3
local var4
local var5

local function var6(arg0, arg1)
	local var0 = arg0:Find("base")

	if IsNil(var0) then
		return
	end

	local var1 = arg1.name
	local var2 = arg1.value

	setActive(var0, var2)

	if not var2 then
		return
	end

	setText(var0:Find("name"), var1)
	Canvas.ForceUpdateCanvases()

	if not IsNil(var0:Find("value")) then
		setActive(var0:Find("value"), var2)
		changeToScrollText(var0:Find("value/Text"), var2)
	end

	if not IsNil(var0:Find("effect")) then
		setActive(var0:Find("effect"), false)
	end

	setActive(var0:Find("value/up"), arg1.compare and arg1.compare > 0)
	setActive(var0:Find("value/down"), arg1.compare and arg1.compare < 0)
	triggerToggle(var0, arg1.lock_open)

	if not arg1.lock_open and arg1.sub and #arg1.sub > 0 then
		GetComponent(var0, typeof(Toggle)).enabled = true
	else
		setActive(var0:Find("name/close"), false)
		setActive(var0:Find("name/open"), false)

		GetComponent(var0, typeof(Toggle)).enabled = false
	end
end

local function var7(arg0, arg1)
	local var0 = arg0:Find("desc")

	if IsNil(var0) then
		return
	end

	setActive(var0, arg1.desc)

	if not arg1.desc then
		return
	end

	setText(var0:Find("Text"), arg1.desc)
end

local function var8(arg0, arg1)
	var6(arg0, arg1)
	var7(arg0, arg1)
end

local function var9(arg0, arg1, arg2)
	removeAllChildren(arg0)
	var5(arg0, arg1, arg2)
end

function var5(arg0, arg1, arg2)
	for iter0, iter1 in ipairs(arg2) do
		local var0 = cloneTplTo(arg1, arg0)

		var8(var0, iter1)
	end
end

function updateSpWeaponInfo(arg0, arg1, arg2)
	local var0 = arg0:Find("attr_tpl")

	var9(arg0:Find("attrs"), var0, arg1.attrs)

	local var1 = {}

	if arg2[1].skillId > 0 then
		local var2 = getSkillDesc(arg2[1].skillId, arg2[1].lv)

		if not arg2[1].unlock then
			var2 = setColorStr(i18n("spweapon_tip_skill_locked") .. var2, "#a2a2a2")
		end

		table.insert(var1, {
			name = i18n("spweapon_attr_effect"),
			value = setColorStr(getSkillName(arg2[1].skillId), arg2[1].unlock and "#FFDE00FF" or "#A2A2A2"),
			desc = var2
		})
	end

	if arg2[2].skillId > 0 then
		local var3 = getSkillDesc(arg2[2].skillId, arg2[2].lv)

		if not arg2[2].unlock then
			var3 = setColorStr(i18n("spweapon_tip_skill_locked") .. var3, "#a2a2a2")
		end

		table.insert(var1, {
			name = i18n("spweapon_attr_skillupgrade"),
			value = setColorStr(getSkillName(arg2[2].skillId), arg2[2].unlock and "#FFDE00FF" or "#A2A2A2"),
			desc = var3
		})
	end

	var5(arg0:Find("attrs"), var0, var1)

	local var4 = cloneTplTo(var0, arg0:Find("part"))

	var4:SetSiblingIndex(0)
	var8(var4, {
		value = "",
		name = i18n("equip_info_23")
	})

	local var5 = arg0:Find("part/value")
	local var6 = var5:Find("label")
	local var7 = {}
	local var8 = {}

	if #arg1.part[1] == 0 and #arg1.part[2] == 0 then
		setmetatable(var7, {
			__index = function(arg0, arg1)
				return true
			end
		})
		setmetatable(var8, {
			__index = function(arg0, arg1)
				return true
			end
		})
	else
		for iter0, iter1 in ipairs(arg1.part[1]) do
			var7[iter1] = true
		end

		for iter2, iter3 in ipairs(arg1.part[2]) do
			var8[iter3] = true
		end
	end

	local var9 = ShipType.MergeFengFanType(ShipType.FilterOverQuZhuType(ShipType.AllShipType), var7, var8)

	UIItemList.StaticAlign(var5, var6, #var9, function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = var9[arg1]

			GetImageSpriteFromAtlasAsync("shiptype", ShipType.Type2CNLabel(var0), arg2)
			setActive(arg2:Find("main"), var7[var0] and not var8[var0])
			setActive(arg2:Find("sub"), var8[var0] and not var7[var0])
			setImageAlpha(arg2, not var7[var0] and not var8[var0] and 0.3 or 1)
		end
	end)
	setActive(var0, false)
end

function var0.AlignAttrs(arg0, arg1)
	for iter0 = 1, #arg0 do
		if not arg1[iter0] or arg0[iter0].type ~= arg1[iter0].type then
			local var0 = false

			for iter1 = iter0 + 1, #arg1 do
				if arg1[iter0].type == arg1[iter1].type then
					local var1 = table.remove(arg1, iter1)

					table.insert(arg1, iter0, var1)

					var0 = true

					break
				end
			end

			if not var0 then
				table.insert(arg1, iter0, {
					type = arg0[iter0].type
				})

				arg1[iter0].empty = true
			end
		end
	end

	for iter2 = #arg0 + 1, #arg1 do
		table.insert(arg0, {
			type = arg1[iter2].type
		})

		arg0[iter2].empty = true
	end
end

function var0.CompareInfo(arg0, arg1)
	local var0 = arg0.empty and 0 or arg0.configAttr + arg0.baseAttr

	arg1.compare = (arg1.empty and 0 or arg1.configAttr + arg1.baseAttr) - var0
end

function var0.InsertAttrsCompare(arg0, arg1)
	var0.AlignAttrs(arg0, arg1)

	for iter0 = 1, #arg0 do
		var0.CompareInfo(arg0[iter0], arg1[iter0])
	end
end

local function var10(arg0)
	local var0 = arg0:GetConfigAttributes()
	local var1 = arg0:GetBaseAttributes()

	return {
		{
			type = arg0:getConfig("attribute_1"),
			configAttr = var0[1],
			baseAttr = var1[1]
		},
		{
			type = arg0:getConfig("attribute_2"),
			configAttr = var0[2],
			baseAttr = var1[2]
		}
	}
end

local function var11(arg0, arg1)
	local var0 = {
		attrs = {}
	}

	for iter0 = 1, #arg0 do
		local var1 = arg0[iter0]
		local var2 = AttributeType.Type2Name(var1.type)
		local var3

		if not var1.empty then
			var3 = var1.configAttr .. " + " .. var1.baseAttr

			if not arg1:IsReal() then
				var3 = var3 .. "~" .. arg1:GetAttributesRange()[iter0]
			end
		else
			var3 = 0
		end

		table.insert(var0.attrs, {
			name = var2,
			value = var3,
			compare = var1.compare
		})
	end

	local var4 = arg1:GetWearableShipTypes()

	var0.part = {
		var4,
		var4
	}

	return var0
end

function var0.TransformNormalInfo(arg0)
	local var0 = var10(arg0)

	return var11(var0, arg0)
end

function var0.CompareNormalInfo(arg0, arg1)
	local var0 = var10(arg0)
	local var1 = var10(arg1)

	var0.InsertAttrsCompare(var0, var1)

	return var11(var0, arg0), var11(var1, arg1)
end

function var0.TransformCompositeInfo(arg0)
	local var0 = {}
	local var1 = {
		arg0:getConfig("attribute_1"),
		arg0:getConfig("attribute_2")
	}
	local var2 = arg0:GetConfigAttributes()
	local var3 = arg0:GetAttributesRange()

	for iter0 = 1, 2 do
		local var4 = AttributeType.Type2Name(var1[iter0])
		local var5 = var2[iter0] .. " + 0~" .. var3[iter0]

		table.insert(var0, {
			name = var4,
			value = var5
		})
	end

	return var0
end

function var0.TransformUpgradeInfo(arg0, arg1)
	local var0 = {}
	local var1 = {
		arg0:getConfig("attribute_1"),
		arg0:getConfig("attribute_2")
	}
	local var2 = arg0:GetConfigAttributes()
	local var3 = arg1:GetConfigAttributes()
	local var4 = arg0:GetBaseAttributes()

	for iter0 = 1, 2 do
		local var5 = AttributeType.Type2Name(var1[iter0])
		local var6 = var3[iter0] .. " + " .. var4[iter0]

		if var2[iter0] ~= var3[iter0] then
			var6 = var2[iter0] .. "   >   " .. var6
		end

		table.insert(var0, {
			name = var5,
			value = var6
		})
	end

	return var0
end

return var0
