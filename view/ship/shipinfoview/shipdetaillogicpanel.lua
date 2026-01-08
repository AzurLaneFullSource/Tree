local var0_0 = class("ShipDetailLogicPanel", import("...base.BasePanel"))
local var1_0 = {
	durability = AttributeType.Durability,
	armor = AttributeType.Armor,
	reload = AttributeType.Reload,
	cannon = AttributeType.Cannon,
	torpedo = AttributeType.Torpedo,
	motion = AttributeType.Dodge,
	antiaircraft = AttributeType.AntiAircraft,
	air = AttributeType.Air,
	hit = AttributeType.Hit,
	antisub = AttributeType.AntiSub,
	oxy_max = AttributeType.OxyMax,
	ammo = AttributeType.Ammo,
	hunting_range = AttributeType.HuntingRange,
	luck = AttributeType.Luck,
	consume = AttributeType.Expend,
	speed = AttributeType.Speed
}
local var2_0 = {
	us = {
		prop_ignore = {
			luck = {
				134,
				-260,
				134,
				-260
			},
			consume = {
				417,
				-260,
				431,
				-260
			},
			hunting_range = {
				622,
				-260,
				639,
				-260
			}
		},
		sort_index = {
			"durability",
			"armor",
			"reload",
			"cannon",
			"torpedo",
			"motion",
			"antiaircraft",
			"air",
			"hit",
			"consume",
			"antisub",
			"oxy_max",
			"ammo",
			"speed",
			"hunting_range",
			"luck"
		},
		hide = {}
	},
	jp = {
		prop_ignore = {
			luck = {
				137,
				-260,
				151,
				-260
			},
			consume = {
				417,
				-260,
				431,
				-260
			},
			hunting_range = {
				622,
				-260,
				639,
				-260
			}
		},
		sort_index = {
			"durability",
			"armor",
			"reload",
			"cannon",
			"torpedo",
			"motion",
			"antiaircraft",
			"air",
			"hit",
			"consume",
			"antisub",
			"oxy_max",
			"ammo",
			"speed",
			"hunting_range",
			"luck"
		},
		hide = {}
	},
	kr = {
		prop_ignore = {
			luck = {
				137,
				-260,
				151,
				-260
			},
			consume = {
				417,
				-260,
				431,
				-260
			},
			hunting_range = {
				622,
				-260,
				639,
				-260
			}
		},
		sort_index = {
			"durability",
			"armor",
			"reload",
			"cannon",
			"torpedo",
			"motion",
			"antiaircraft",
			"air",
			"hit",
			"consume",
			"antisub",
			"oxy_max",
			"ammo",
			"speed",
			"hunting_range",
			"luck"
		},
		hide = {}
	},
	defaut = {
		prop_ignore = {
			luck = {
				137,
				-260,
				151,
				-260
			},
			consume = {
				417,
				-260,
				431,
				-260
			},
			hunting_range = {
				622,
				-260,
				639,
				-260
			}
		},
		sort_index = {
			"durability",
			"armor",
			"reload",
			"cannon",
			"torpedo",
			"motion",
			"antiaircraft",
			"air",
			"hit",
			"antisub",
			"oxy_max",
			"ammo",
			"speed",
			"hunting_range",
			"luck",
			"consume"
		},
		hide = {}
	}
}
local var3_0
local var4_0 = 0.5
local var5_0 = Vector3(1, 1, 1)
local var6_0 = Vector3(1.3, 1.3, 1.3)

var0_0.EQUIPMENT_ADDITION = 0
var0_0.TECHNOLOGY_ADDITION = 1
var0_0.CORE_ADDITION = 2

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1.gameObject)

	arg0_1.skillContainer = findTF(arg0_1._tf, "skills/content")
	arg0_1.skillContainerHz = arg0_1.skillContainer:GetComponent(typeof(HorizontalLayoutGroup))
	arg0_1.skillTpl = findTF(arg0_1.skillContainer, "skill_tpl")
	arg0_1.attrs = findTF(arg0_1._tf, "attrs/property")
	arg0_1.powerTxt = findTF(arg0_1.attrs, "power/value")
	arg0_1.levelTxt = findTF(arg0_1.attrs, "level_bg/level_label/Text")
	arg0_1.levelSlider = findTF(arg0_1.attrs, "level_bg/exp")
	arg0_1.expInfo = findTF(arg0_1.attrs, "level_bg/exp_info")
	arg0_1.outline = findTF(arg0_1.attrs, "level_bg/outline")
	arg0_1.levelTip = findTF(arg0_1.attrs, "level_bg/tip")
	arg0_1.levelBg = findTF(arg0_1.attrs, "level_bg")
	arg0_1.expTip = findTF(arg0_1.attrs, "level_bg/exp_tip")
	arg0_1.armorNameTxt = arg0_1.attrs:Find("icons"):GetChild(1):Find("name")

	if PLATFORM_CODE == PLATFORM_JP then
		var3_0 = var2_0.jp
	elseif PLATFORM_CODE == PLATFORM_KR then
		var3_0 = var2_0.kr
	elseif PLATFORM_CODE == PLATFORM_US then
		var3_0 = var2_0.us
	else
		var3_0 = var2_0.defaut
	end

	local var0_1 = var3_0.sort_index

	for iter0_1 = 1, #var0_1 do
		local var1_1 = var0_1[iter0_1]
		local var2_1 = findTF(arg0_1.attrs, "props/" .. var1_1)
		local var3_1 = findTF(arg0_1.attrs, "icons/" .. var1_1)
		local var4_1 = pg.gametip["attr_" .. var1_1].tip

		if var4_1 and string.len(var4_1) > 0 and var1_1 ~= "armor" then
			setText(findTF(var3_1, "name"), var4_1)
		end

		var2_1:SetSiblingIndex(iter0_1 - 1)
		var3_1:SetSiblingIndex(iter0_1 - 1)
	end

	local var5_1 = var3_0.hide

	for iter1_1 = 1, #var5_1 do
		local var6_1 = var5_1[iter1_1]
		local var7_1 = findTF(arg0_1.attrs, "props/" .. var6_1)
		local var8_1 = findTF(arg0_1.attrs, "icons/" .. var6_1)

		setActive(var7_1, false)
		setActive(var8_1, false)
	end

	local var9_1 = var3_0.prop_ignore

	for iter2_1, iter3_1 in pairs(var9_1) do
		local var10_1 = findTF(arg0_1.attrs, "props/" .. iter2_1)
		local var11_1 = findTF(arg0_1.attrs, "icons/" .. iter2_1)

		GetOrAddComponent(var10_1, typeof(LayoutElement)).ignoreLayout = true
		GetOrAddComponent(var11_1, typeof(LayoutElement)).ignoreLayout = true
		var10_1.anchorMax = Vector2(0, 1)
		var10_1.anchorMin = Vector2(0, 1)
		var11_1.anchorMax = Vector2(0, 1)
		var11_1.anchorMin = Vector2(0, 1)
		var10_1.anchoredPosition = Vector2(iter3_1[3], iter3_1[4])
		var11_1.anchoredPosition = Vector2(iter3_1[1], iter3_1[2])
	end
end

function var0_0.attach(arg0_2, arg1_2)
	var0_0.super.attach(arg0_2, arg1_2)

	arg0_2.evalueToggle = arg0_2.attrs:Find("evalue_toggle")
	arg0_2.evalueIndex = var0_0.EQUIPMENT_ADDITION

	onToggle(arg0_2.viewComponent, arg0_2.evalueToggle, function()
		arg0_2.evalueIndex = 1 - arg0_2.evalueIndex

		arg0_2:updateEvalues()
	end)
end

function var0_0.enableEvent(arg0_4, arg1_4)
	arg0_4:emit(ShipViewConst.SET_CLICK_ENABLE, arg1_4)
end

function var0_0.flush(arg0_5, arg1_5)
	assert(arg1_5, "shipVO can not be nil")

	arg0_5.shipDataTemplate = pg.ship_data_template[arg1_5.configId]
	arg0_5.shipVO = arg1_5

	arg0_5:updateShipAttrs()
	arg0_5:updateSKills()
	arg0_5:updateLevelInfo()

	local var0_5 = arg1_5:isMaxStar()

	if not var0_5 and arg0_5.evalueIndex == var0_0.TECHNOLOGY_ADDITION then
		triggerToggle(arg0_5.evalueToggle, false)
	end

	setActive(arg0_5.evalueToggle, var0_5)
end

function var0_0.updateEvalues(arg0_6)
	if not arg0_6.additionValues then
		return
	end

	local var0_6 = table.contains(ShipType.SubShipType, arg0_6.shipVO:getShipType())

	for iter0_6, iter1_6 in pairs(arg0_6.additionValues.transforms) do
		if iter0_6 == AttributeType.Armor or iter0_6 == AttributeType.Expend or iter0_6 == AttributeType.HuntingRange and var0_6 then
			setText(iter1_6, "")
			setActive(iter1_6, false)
		else
			local var1_6 = arg0_6.additionValues[arg0_6.evalueIndex][iter0_6] or 0
			local var2_6 = arg0_6.shipVO:getTechNationMaxAddition(iter0_6)
			local var3_6 = arg0_6.evalueIndex == var0_0.EQUIPMENT_ADDITION and COLOR_GREEN or COLOR_YELLOW

			if arg0_6.evalueIndex == var0_0.TECHNOLOGY_ADDITION and var1_6 ~= var2_6 then
				var3_6 = "#B4BFD5FF"
			end

			setText(iter1_6, var1_6 == 0 and "" or setColorStr(" +" .. var1_6, var3_6))
			setActive(iter1_6, var1_6 ~= 0)
		end
	end
end

function var0_0.updateShipAttrs(arg0_7)
	arg0_7.additionValues = {
		[var0_0.EQUIPMENT_ADDITION] = {},
		[var0_0.TECHNOLOGY_ADDITION] = {},
		transforms = {}
	}

	local var0_7 = arg0_7.shipVO
	local var1_7 = table.contains(ShipType.SubShipType, var0_7:getShipType())
	local var2_7 = intProperties(var0_7:isBluePrintShip() and var0_7:getBluePrint():getShipProperties(var0_7) or var0_7:getShipProperties())
	local var3_7, var4_7 = var0_7:getEquipmentProperties()
	local var5_7 = intProperties(var3_7)
	local var6_7 = intProperties(var4_7)
	local var7_7 = var0_7:getShipCombatPower()

	FormationUI.tweenNumText(arg0_7.powerTxt, var7_7)

	for iter0_7, iter1_7 in pairs(var1_0) do
		local var8_7 = findTF(arg0_7.attrs, "props/" .. iter0_7)
		local var9_7 = findTF(arg0_7.attrs, "icons/" .. iter0_7)
		local var10_7 = findTF(var8_7, "value")
		local var11_7 = findTF(var8_7, "add")
		local var12_7 = var2_7[iter1_7] or 0
		local var13_7 = var6_7[iter1_7] or 1
		local var14_7 = calcFloor(((var5_7[iter1_7] or 0) + var12_7) * var13_7) - var12_7

		setText(var10_7, var12_7)

		arg0_7.additionValues.transforms[iter1_7] = var11_7
		arg0_7.additionValues[0][iter1_7] = var14_7
		arg0_7.additionValues[1][iter1_7] = var0_7:getTechNationAddition(iter1_7)

		if iter1_7 == AttributeType.Armor then
			setActive(var10_7, false)
			setActive(var11_7, false)
			setText(arg0_7.armorNameTxt, var0_7:getShipArmorName())
		elseif iter1_7 == AttributeType.Expend then
			setText(findTF(var8_7, "value"), var0_7:getBattleTotalExpend())
			setActive(var11_7, false)
		elseif iter1_7 == AttributeType.HuntingRange then
			setActive(var9_7, var1_7)
			setActive(var8_7, var1_7)

			if var1_7 then
				setActive(var10_7, false)
				setActive(var11_7, false)
			end
		elseif iter1_7 == AttributeType.AntiSub then
			setActive(var9_7, not var1_7)
			setActive(var8_7, not var1_7)
		elseif iter1_7 == AttributeType.OxyMax or iter1_7 == AttributeType.Ammo then
			setActive(var9_7, var1_7)
			setActive(var8_7, var1_7)

			if iter1_7 == AttributeType.Ammo then
				setText(var10_7, var0_7:getShipAmmo())
			end
		end
	end

	arg0_7:updateEvalues()
end

function var0_0.updateSKills(arg0_8)
	local var0_8 = arg0_8.shipVO
	local var1_8 = Clone(arg0_8.shipDataTemplate.buff_list_display)

	for iter0_8 = #var1_8 + 1, 3 do
		table.insert(var1_8, false)
	end

	setActive(arg0_8.skillTpl, false)

	local var2_8 = UIItemList.New(arg0_8.skillContainer, arg0_8.skillTpl)

	var2_8:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			local var0_9 = var1_8[arg1_9 + 1]

			if var0_9 then
				local var1_9 = var0_8:fateSkillChange(var0_9)
				local var2_9 = getSkillConfig(var0_8:RemapSkillId(var1_9))
				local var3_9 = var0_8.skills[var1_9]

				if var3_9 and var3_9.id == 11720 and not var0_8.transforms[3612] then
					var3_9 = nil
				end

				if var3_9 and var3_9.id == 14900 and not var0_8.transforms[16412] then
					var3_9 = nil
				end

				arg0_8:updateSkillTF(arg2_9, var2_9, var3_9)
				onButton(arg0_8, arg2_9, function()
					arg0_8:emit(ShipMainMediator.ON_SKILL, var2_9.id, var3_9, arg1_9 + 1)
				end, SFX_PANEL)
			else
				arg0_8:updateSkillTF(arg2_9)
				RemoveComponent(arg2_9, "Button")
			end
		end
	end)
	var2_8:align(#var1_8)
end

function var0_0.updateSkillTF(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = findTF(arg1_11, "skill")
	local var1_11 = findTF(arg1_11, "lock")
	local var2_11 = findTF(arg1_11, "unknown")

	if arg2_11 then
		setActive(var0_11, true)
		setActive(var2_11, false)
		setActive(var1_11, not arg3_11)
		LoadImageSpriteAsync("skillicon/" .. arg2_11.icon, findTF(var0_11, "icon"))

		findTF(var0_11, "mask/name").anchoredPosition = Vector2(0, 0)

		setScrollText(findTF(var0_11, "mask/name"), getSkillName(arg2_11.id))

		local var3_11 = findTF(var0_11, "level")

		setText(var3_11, "LEVEL: " .. (arg3_11 and arg3_11.level or "??"))
	else
		setActive(var0_11, false)
		setActive(var2_11, true)
		setActive(var1_11, false)
	end
end

function var0_0.updateLevelInfo(arg0_12)
	local var0_12 = arg0_12.shipVO

	setText(arg0_12.levelTxt, var0_12.level)

	local var1_12 = var0_12:getLevelExpConfig()

	if var0_12.level ~= var0_12:getMaxLevel() then
		setSlider(arg0_12.levelSlider, 0, var1_12.exp_interval, var0_12.exp)
		setText(arg0_12.expInfo, var0_12.exp .. "/" .. var1_12.exp_interval)
	else
		setSlider(arg0_12.levelSlider, 0, 1, 1)
		setText(arg0_12.expInfo, var0_12.exp .. "/Max")
	end

	arg0_12:updateMaxLevel(var0_12)
	arg0_12:UpdateExpTip(var0_12)
end

function var0_0.UpdateExpTip(arg0_13, arg1_13)
	local var0_13 = arg1_13:isReachNextMaxLevel()
	local var1_13 = arg1_13.level >= arg1_13.maxLevel

	setActive(arg0_13.expTip, not var0_13 and not var1_13)
	onButton(arg0_13, arg0_13.expTip, function()
		local var0_14 = {}

		if arg1_13:isActivityNpc() then
			table.insert(var0_14, function(arg0_15)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("coures_exp_npc_tip"),
					onYes = arg0_15
				})
			end)
		end

		seriesAsync(var0_14, function()
			arg0_13:emit(ShipViewConst.SHOW_EXP_ITEM_USAGE, arg1_13)
		end)
	end, SFX_PANEL)
end

function var0_0.updateMaxLevel(arg0_17, arg1_17)
	if arg1_17:isReachNextMaxLevel() then
		SetActive(arg0_17.outline, true)
		setActive(arg0_17.levelTip, true)
		blinkAni(arg0_17.outline, 1.5, -1, 0.1):setFrom(1)
		blinkAni(arg0_17.levelTip, 1.5, -1, 0.1):setFrom(1)

		local var0_17 = arg1_17:getNextMaxLevelConsume()
		local var1_17 = arg1_17:getMaxLevel()
		local var2_17 = arg1_17:getNextMaxLevel()

		onButton(arg0_17, arg0_17.levelBg, function()
			if arg1_17:isActivityNpc() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("npc_upgrade_max_level"))

				return
			end

			arg0_17:emit(ShipViewConst.SHOW_CUSTOM_MSG, {
				content = i18n("upgrade_to_next_maxlevel_tip"),
				content1 = var1_17 .. "->" .. var2_17,
				items = var0_17,
				onYes = function()
					local var0_19, var1_19 = arg1_17:canUpgradeMaxLevel()

					if var0_19 then
						arg0_17:emit(ShipViewConst.HIDE_CUSTOM_MSG)
						arg0_17:emit(ShipMainMediator.ON_UPGRADE_MAX_LEVEL, arg1_17.id)
					else
						pg.TipsMgr.GetInstance():ShowTips(var1_19)
					end
				end
			})
		end, SFX_PANEL)
	else
		arg0_17:removeLevelUpTip()
	end
end

function var0_0.removeLevelUpTip(arg0_20)
	SetActive(arg0_20.outline, false)
	setActive(arg0_20.levelTip, false)

	if LeanTween.isTweening(go(arg0_20.outline)) then
		LeanTween.cancel(go(arg0_20.outline))
	end

	if LeanTween.isTweening(go(arg0_20.levelTip)) then
		LeanTween.cancel(go(arg0_20.levelTip))
	end

	removeOnButton(arg0_20.levelBg)
end

function var0_0.doLeveUpAnim(arg0_21, arg1_21, arg2_21, arg3_21)
	arg0_21:removeLevelUpTip()
	arg0_21:enableEvent(false)

	local var0_21 = {}

	if arg1_21.level < arg2_21.level then
		local var1_21 = arg2_21.level - arg1_21.level
		local var2_21 = arg1_21:getLevelExpConfig()

		for iter0_21 = 1, var1_21 do
			table.insert(var0_21, function(arg0_22)
				TweenValue(arg0_21.levelSlider, 0, var2_21.exp_interval, var4_0, 0, function(arg0_23)
					setSlider(arg0_21.levelSlider, 0, var2_21.exp_interval, arg0_23)
					setText(arg0_21.expInfo, math.floor(arg0_23) .. "/" .. var2_21.exp_interval)
				end, function()
					local var0_24 = Clone(arg1_21)

					arg1_21.level = arg1_21.level + 1
					var2_21 = arg1_21:getLevelExpConfig()

					arg0_21:scaleAnim(arg0_21.levelTxt, var5_0, var6_0, var4_0 / 2, function()
						if arg1_21.level == arg2_21.level then
							arg0_21:doAttrAnim(var0_24, arg2_21, function()
								TweenValue(arg0_21.levelSlider, 0, arg2_21.exp, var4_0, 0, function(arg0_27)
									setSlider(arg0_21.levelSlider, 0, var2_21.exp_interval, arg0_27)
									setText(arg0_21.expInfo, math.floor(arg0_27) .. "/" .. var2_21.exp_interval)
								end, arg0_22)
							end)
						else
							arg0_21:doAttrAnim(var0_24, arg1_21, arg0_22)
						end
					end, function()
						setText(arg0_21.levelTxt, arg1_21.level)
					end)
				end)
			end)
		end
	else
		local var3_21 = arg2_21:getLevelExpConfig()

		if arg2_21.exp > arg1_21.exp then
			table.insert(var0_21, function(arg0_29)
				TweenValue(arg0_21.levelSlider, arg1_21.exp, arg2_21.exp, var4_0, 0, function(arg0_30)
					setSlider(arg0_21.levelSlider, 0, var3_21.exp_interval, arg0_30)
					setText(arg0_21.expInfo, math.floor(arg0_30) .. "/" .. var3_21.exp_interval)
				end, arg0_29)
			end)
		end
	end

	seriesAsync(var0_21, function()
		if arg3_21 then
			arg3_21()
		end

		arg0_21:enableEvent(true)
	end)
end

function var0_0.doAttrAnim(arg0_32, arg1_32, arg2_32, arg3_32)
	local var0_32 = intProperties(arg1_32:getShipProperties())
	local var1_32, var2_32 = arg1_32:getEquipmentProperties()
	local var3_32 = intProperties(arg2_32:getShipProperties())
	local var4_32, var5_32 = arg2_32:getEquipmentProperties()
	local var6_32 = intProperties(var1_32)
	local var7_32 = intProperties(var2_32)
	local var8_32 = intProperties(var4_32)
	local var9_32 = intProperties(var5_32)
	local var10_32 = {}
	local var11_32 = arg2_32:getShipCombatPower()
	local var12_32 = arg1_32:getShipCombatPower()

	if var12_32 ~= var11_32 then
		table.insert(var10_32, function(arg0_33)
			TweenValue(arg0_32.powerTxt, var12_32, var11_32, var4_0, 0, function(arg0_34)
				setText(arg0_32.powerTxt, math.floor(arg0_34))
			end, arg0_33)
		end)
	end

	for iter0_32, iter1_32 in pairs(var1_0) do
		local var13_32 = findTF(arg0_32.attrs, "props/" .. iter0_32) or findTF(arg0_32.attrs, "prop_" .. iter0_32)
		local var14_32 = findTF(arg0_32.attrs, "icons/" .. iter0_32) or findTF(arg0_32.attrs, "icon_" .. iter0_32)
		local var15_32 = findTF(var13_32, "value")
		local var16_32 = findTF(var13_32, "add")
		local var17_32 = var0_32[iter1_32] or 0
		local var18_32 = var7_32[iter1_32] or 1
		local var19_32 = var3_32[iter1_32] or 0
		local var20_32 = var9_32[iter1_32] or 1
		local var21_32
		local var22_32

		if arg0_32.evalueIndex == var0_0.EQUIPMENT_ADDITION then
			var21_32 = calcFloor(((var6_32[iter1_32] or 0) + var17_32) * var18_32) - var17_32
			var22_32 = calcFloor(((var8_32[iter1_32] or 0) + var19_32) * var20_32) - var19_32
		elseif arg0_32.evalueIndex == var0_0.TECHNOLOGY_ADDITION then
			var21_32 = arg1_32:getTechNationAddition(iter1_32)
			var22_32 = arg2_32:getTechNationAddition(iter1_32)
		end

		if var17_32 ~= 0 then
			table.insert(var10_32, function(arg0_35)
				TweenValue(var15_32, var17_32, var19_32, var4_0, 0, function(arg0_36)
					setText(var15_32, math.floor(arg0_36))
				end, arg0_35)
				arg0_32:scaleAnim(var15_32, var5_0, var6_0, var4_0 / 2)
			end)
		end

		if var21_32 < var22_32 then
			local var23_32 = arg0_32.evalueIndex == var0_0.EQUIPMENT_ADDITION and COLOR_GREEN or COLOR_YELLOW

			table.insert(var10_32, function(arg0_37)
				TweenValue(var16_32, var21_32, var22_32, var4_0, 0, function(arg0_38)
					setText(var16_32, setColorStr("+" .. math.floor(arg0_38), var23_32))
				end, arg0_37)
				arg0_32:scaleAnim(var16_32, var5_0, var6_0, var4_0 / 2)
			end)
		end

		setActive(var16_32, var22_32 ~= 0)

		if iter1_32 == AttributeType.Armor then
			setActive(var15_32, false)
			setActive(var16_32, false)
			setText(arg0_32.armorNameTxt, arg2_32:getShipArmorName())
		elseif iter1_32 == AttributeType.Expend then
			local var24_32 = arg2_32:getBattleTotalExpend()
			local var25_32 = arg1_32:getBattleTotalExpend()
			local var26_32 = findTF(var13_32, "value")

			if var25_32 ~= var24_32 then
				table.insert(var10_32, function(arg0_39)
					TweenValue(var26_32, var25_32, var24_32, var4_0, 0, function(arg0_40)
						setText(var26_32, math.floor(arg0_40))
					end, arg0_39)
					arg0_32:scaleAnim(var26_32, var5_0, var6_0, var4_0 / 2)
				end)
			end

			setActive(var16_32, false)
		elseif iter1_32 == AttributeType.OxyMax or iter1_32 == AttributeType.Tactics then
			local var27_32 = table.contains(ShipType.SubShipType, arg2_32:getShipType())

			setActive(var14_32, var27_32)
			setActive(var13_32, var27_32)

			if var27_32 and iter1_32 == AttributeType.Tactics then
				local var28_32, var29_32 = arg2_32:getTactics()

				setActive(var15_32, false)
				setActive(var16_32, true)
				setText(var16_32, i18n(var29_32))
			end
		end
	end

	parallelAsync(var10_32, function()
		if arg3_32 then
			arg3_32()
		end
	end)
end

function var0_0.scaleAnim(arg0_42, arg1_42, arg2_42, arg3_42, arg4_42, arg5_42, arg6_42)
	LeanTween.scale(go(arg1_42), arg3_42, arg4_42):setFrom(arg2_42):setOnComplete(System.Action(function()
		if arg6_42 then
			arg6_42()
		end

		LeanTween.scale(go(arg1_42), arg2_42, arg4_42):setFrom(arg3_42):setOnComplete(System.Action(arg5_42))
	end))
end

function var0_0.clear(arg0_44)
	triggerToggle(arg0_44.evalueToggle, false)

	if LeanTween.isTweening(go(arg0_44.levelSlider)) then
		LeanTween.cancel(go(arg0_44.levelSlider))
	end

	if LeanTween.isTweening(go(arg0_44.powerTxt)) then
		LeanTween.cancel(go(arg0_44.powerTxt))
	end

	if LeanTween.isTweening(go(arg0_44.expInfo)) then
		LeanTween.cancel(go(arg0_44.expInfo))
	end

	arg0_44:removeLevelUpTip()

	arg0_44.additionValues = nil
end

return var0_0
