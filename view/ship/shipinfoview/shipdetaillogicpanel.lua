local var0 = class("ShipDetailLogicPanel", import("...base.BasePanel"))
local var1 = {
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
local var2 = {
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
local var3
local var4 = 0.5
local var5 = Vector3(1, 1, 1)
local var6 = Vector3(1.3, 1.3, 1.3)

var0.EQUIPMENT_ADDITION = 0
var0.TECHNOLOGY_ADDITION = 1
var0.CORE_ADDITION = 2

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1.gameObject)

	arg0.skillContainer = findTF(arg0._tf, "skills/content")
	arg0.skillContainerHz = arg0.skillContainer:GetComponent(typeof(HorizontalLayoutGroup))
	arg0.skillTpl = findTF(arg0.skillContainer, "skill_tpl")
	arg0.attrs = findTF(arg0._tf, "attrs/property")
	arg0.powerTxt = findTF(arg0.attrs, "power/value")
	arg0.levelTxt = findTF(arg0.attrs, "level_bg/level_label/Text")
	arg0.levelSlider = findTF(arg0.attrs, "level_bg/exp")
	arg0.expInfo = findTF(arg0.attrs, "level_bg/exp_info")
	arg0.outline = findTF(arg0.attrs, "level_bg/outline")
	arg0.levelTip = findTF(arg0.attrs, "level_bg/tip")
	arg0.levelBg = findTF(arg0.attrs, "level_bg")
	arg0.expTip = findTF(arg0.attrs, "level_bg/exp_tip")
	arg0.armorNameTxt = arg0.attrs:Find("icons"):GetChild(1):Find("name")

	if PLATFORM_CODE == PLATFORM_JP then
		var3 = var2.jp
	elseif PLATFORM_CODE == PLATFORM_KR then
		var3 = var2.kr
	elseif PLATFORM_CODE == PLATFORM_US then
		var3 = var2.us
	else
		var3 = var2.defaut
	end

	local var0 = var3.sort_index

	for iter0 = 1, #var0 do
		local var1 = var0[iter0]
		local var2 = findTF(arg0.attrs, "props/" .. var1)
		local var3 = findTF(arg0.attrs, "icons/" .. var1)
		local var4 = pg.gametip["attr_" .. var1].tip

		if var4 and string.len(var4) > 0 and var1 ~= "armor" then
			setText(findTF(var3, "name"), var4)
		end

		var2:SetSiblingIndex(iter0 - 1)
		var3:SetSiblingIndex(iter0 - 1)
	end

	local var5 = var3.hide

	for iter1 = 1, #var5 do
		local var6 = var5[iter1]
		local var7 = findTF(arg0.attrs, "props/" .. var6)
		local var8 = findTF(arg0.attrs, "icons/" .. var6)

		setActive(var7, false)
		setActive(var8, false)
	end

	local var9 = var3.prop_ignore

	for iter2, iter3 in pairs(var9) do
		local var10 = findTF(arg0.attrs, "props/" .. iter2)
		local var11 = findTF(arg0.attrs, "icons/" .. iter2)

		GetOrAddComponent(var10, typeof(LayoutElement)).ignoreLayout = true
		GetOrAddComponent(var11, typeof(LayoutElement)).ignoreLayout = true
		var10.anchorMax = Vector2(0, 1)
		var10.anchorMin = Vector2(0, 1)
		var11.anchorMax = Vector2(0, 1)
		var11.anchorMin = Vector2(0, 1)
		var10.anchoredPosition = Vector2(iter3[3], iter3[4])
		var11.anchoredPosition = Vector2(iter3[1], iter3[2])
	end
end

function var0.attach(arg0, arg1)
	var0.super.attach(arg0, arg1)

	arg0.evalueToggle = arg0.attrs:Find("evalue_toggle")
	arg0.evalueIndex = var0.EQUIPMENT_ADDITION

	onToggle(arg0.viewComponent, arg0.evalueToggle, function()
		arg0.evalueIndex = 1 - arg0.evalueIndex

		arg0:updateEvalues()
	end)
end

function var0.enableEvent(arg0, arg1)
	arg0:emit(ShipViewConst.SET_CLICK_ENABLE, arg1)
end

function var0.flush(arg0, arg1)
	assert(arg1, "shipVO can not be nil")

	arg0.shipDataTemplate = pg.ship_data_template[arg1.configId]
	arg0.shipVO = arg1

	arg0:updateShipAttrs()
	arg0:updateSKills()
	arg0:updateLevelInfo()

	local var0 = arg1:isMaxStar()

	if not var0 and arg0.evalueIndex == var0.TECHNOLOGY_ADDITION then
		triggerToggle(arg0.evalueToggle, false)
	end

	setActive(arg0.evalueToggle, var0)
end

function var0.updateEvalues(arg0)
	if not arg0.additionValues then
		return
	end

	local var0 = table.contains(TeamType.SubShipType, arg0.shipVO:getShipType())

	for iter0, iter1 in pairs(arg0.additionValues.transforms) do
		if iter0 == AttributeType.Armor or iter0 == AttributeType.Expend or iter0 == AttributeType.HuntingRange and var0 then
			setText(iter1, "")
			setActive(iter1, false)
		else
			local var1 = arg0.additionValues[arg0.evalueIndex][iter0] or 0
			local var2 = arg0.shipVO:getTechNationMaxAddition(iter0)
			local var3 = arg0.evalueIndex == var0.EQUIPMENT_ADDITION and COLOR_GREEN or COLOR_YELLOW

			if arg0.evalueIndex == var0.TECHNOLOGY_ADDITION and var1 ~= var2 then
				var3 = "#B4BFD5FF"
			end

			setText(iter1, var1 == 0 and "" or setColorStr(" +" .. var1, var3))
			setActive(iter1, var1 ~= 0)
		end
	end
end

function var0.updateShipAttrs(arg0)
	arg0.additionValues = {
		[var0.EQUIPMENT_ADDITION] = {},
		[var0.TECHNOLOGY_ADDITION] = {},
		transforms = {}
	}

	local var0 = arg0.shipVO
	local var1 = table.contains(TeamType.SubShipType, var0:getShipType())
	local var2 = intProperties(var0:isBluePrintShip() and var0:getBluePrint():getShipProperties(var0) or var0:getShipProperties())
	local var3, var4 = var0:getEquipmentProperties()
	local var5 = intProperties(var3)
	local var6 = intProperties(var4)
	local var7 = var0:getShipCombatPower()

	FormationUI.tweenNumText(arg0.powerTxt, var7)

	for iter0, iter1 in pairs(var1) do
		local var8 = findTF(arg0.attrs, "props/" .. iter0)
		local var9 = findTF(arg0.attrs, "icons/" .. iter0)
		local var10 = findTF(var8, "value")
		local var11 = findTF(var8, "add")
		local var12 = var2[iter1] or 0
		local var13 = var6[iter1] or 1
		local var14 = calcFloor(((var5[iter1] or 0) + var12) * var13) - var12

		setText(var10, var12)

		arg0.additionValues.transforms[iter1] = var11
		arg0.additionValues[0][iter1] = var14
		arg0.additionValues[1][iter1] = var0:getTechNationAddition(iter1)

		if iter1 == AttributeType.Armor then
			setActive(var10, false)
			setActive(var11, false)
			setText(arg0.armorNameTxt, var0:getShipArmorName())
		elseif iter1 == AttributeType.Expend then
			setText(findTF(var8, "value"), var0:getBattleTotalExpend())
			setActive(var11, false)
		elseif iter1 == AttributeType.HuntingRange then
			setActive(var9, var1)
			setActive(var8, var1)

			if var1 then
				setActive(var10, false)
				setActive(var11, false)
			end
		elseif iter1 == AttributeType.AntiSub then
			setActive(var9, not var1)
			setActive(var8, not var1)
		elseif iter1 == AttributeType.OxyMax or iter1 == AttributeType.Ammo then
			setActive(var9, var1)
			setActive(var8, var1)

			if iter1 == AttributeType.Ammo then
				setText(var10, var0:getShipAmmo())
			end
		end
	end

	arg0:updateEvalues()
end

function var0.updateSKills(arg0)
	local var0 = arg0.shipVO
	local var1 = Clone(arg0.shipDataTemplate.buff_list_display)

	for iter0 = #var1 + 1, 3 do
		table.insert(var1, false)
	end

	setActive(arg0.skillTpl, false)

	local var2 = UIItemList.New(arg0.skillContainer, arg0.skillTpl)

	var2:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var1[arg1 + 1]

			if var0 then
				local var1 = var0:fateSkillChange(var0)
				local var2 = getSkillConfig(var0:RemapSkillId(var1))
				local var3 = var0.skills[var1]

				if var3 and var3.id == 11720 and not var0.transforms[3612] then
					var3 = nil
				end

				if var3 and var3.id == 14900 and not var0.transforms[16412] then
					var3 = nil
				end

				arg0:updateSkillTF(arg2, var2, var3)
				onButton(arg0, arg2, function()
					arg0:emit(ShipMainMediator.ON_SKILL, var2.id, var3, arg1 + 1)
				end, SFX_PANEL)
			else
				arg0:updateSkillTF(arg2)
				RemoveComponent(arg2, "Button")
			end
		end
	end)
	var2:align(#var1)
end

function var0.updateSkillTF(arg0, arg1, arg2, arg3)
	local var0 = findTF(arg1, "skill")
	local var1 = findTF(arg1, "lock")
	local var2 = findTF(arg1, "unknown")

	if arg2 then
		setActive(var0, true)
		setActive(var2, false)
		setActive(var1, not arg3)
		LoadImageSpriteAsync("skillicon/" .. arg2.icon, findTF(var0, "icon"))

		findTF(var0, "mask/name").anchoredPosition = Vector2(0, 0)

		setScrollText(findTF(var0, "mask/name"), getSkillName(arg2.id))

		local var3 = findTF(var0, "level")

		setText(var3, "LEVEL: " .. (arg3 and arg3.level or "??"))
	else
		setActive(var0, false)
		setActive(var2, true)
		setActive(var1, false)
	end
end

function var0.updateLevelInfo(arg0)
	local var0 = arg0.shipVO

	setText(arg0.levelTxt, var0.level)

	local var1 = var0:getLevelExpConfig()

	if var0.level ~= var0:getMaxLevel() then
		setSlider(arg0.levelSlider, 0, var1.exp_interval, var0.exp)
		setText(arg0.expInfo, var0.exp .. "/" .. var1.exp_interval)
	else
		setSlider(arg0.levelSlider, 0, 1, 1)
		setText(arg0.expInfo, var0.exp .. "/Max")
	end

	arg0:updateMaxLevel(var0)
	arg0:UpdateExpTip(var0)
end

function var0.UpdateExpTip(arg0, arg1)
	local var0 = arg1:isReachNextMaxLevel()
	local var1 = arg1.level >= arg1.maxLevel

	setActive(arg0.expTip, not var0 and not var1)
	onButton(arg0, arg0.expTip, function()
		if arg1:isActivityNpc() then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("coures_exp_npc_tip"),
				onYes = function()
					arg0:emit(ShipViewConst.SHOW_EXP_ITEM_USAGE, arg1)
				end
			})
		else
			arg0:emit(ShipViewConst.SHOW_EXP_ITEM_USAGE, arg1)
		end
	end, SFX_PANEL)
end

function var0.updateMaxLevel(arg0, arg1)
	if arg1:isReachNextMaxLevel() then
		SetActive(arg0.outline, true)
		setActive(arg0.levelTip, true)
		blinkAni(arg0.outline, 1.5, -1, 0.1):setFrom(1)
		blinkAni(arg0.levelTip, 1.5, -1, 0.1):setFrom(1)

		local var0 = arg1:getNextMaxLevelConsume()
		local var1 = arg1:getMaxLevel()
		local var2 = arg1:getNextMaxLevel()

		onButton(arg0, arg0.levelBg, function()
			if arg1:isActivityNpc() then
				pg.TipsMgr.GetInstance():ShowTips(i18n("npc_upgrade_max_level"))

				return
			end

			arg0:emit(ShipViewConst.SHOW_CUSTOM_MSG, {
				content = i18n("upgrade_to_next_maxlevel_tip"),
				content1 = var1 .. "->" .. var2,
				items = var0,
				onYes = function()
					local var0, var1 = arg1:canUpgradeMaxLevel()

					if var0 then
						arg0:emit(ShipViewConst.HIDE_CUSTOM_MSG)
						arg0:emit(ShipMainMediator.ON_UPGRADE_MAX_LEVEL, arg1.id)
					else
						pg.TipsMgr.GetInstance():ShowTips(var1)
					end
				end
			})
		end, SFX_PANEL)
	else
		arg0:removeLevelUpTip()
	end
end

function var0.removeLevelUpTip(arg0)
	SetActive(arg0.outline, false)
	setActive(arg0.levelTip, false)

	if LeanTween.isTweening(go(arg0.outline)) then
		LeanTween.cancel(go(arg0.outline))
	end

	if LeanTween.isTweening(go(arg0.levelTip)) then
		LeanTween.cancel(go(arg0.levelTip))
	end

	removeOnButton(arg0.levelBg)
end

function var0.doLeveUpAnim(arg0, arg1, arg2, arg3)
	arg0:removeLevelUpTip()
	arg0:enableEvent(false)

	local var0 = {}

	if arg1.level < arg2.level then
		local var1 = arg2.level - arg1.level
		local var2 = arg1:getLevelExpConfig()

		for iter0 = 1, var1 do
			table.insert(var0, function(arg0)
				TweenValue(arg0.levelSlider, 0, var2.exp_interval, var4, 0, function(arg0)
					setSlider(arg0.levelSlider, 0, var2.exp_interval, arg0)
					setText(arg0.expInfo, math.floor(arg0) .. "/" .. var2.exp_interval)
				end, function()
					local var0 = Clone(arg1)

					arg1.level = arg1.level + 1
					var2 = arg1:getLevelExpConfig()

					arg0:scaleAnim(arg0.levelTxt, var5, var6, var4 / 2, function()
						if arg1.level == arg2.level then
							arg0:doAttrAnim(var0, arg2, function()
								TweenValue(arg0.levelSlider, 0, arg2.exp, var4, 0, function(arg0)
									setSlider(arg0.levelSlider, 0, var2.exp_interval, arg0)
									setText(arg0.expInfo, math.floor(arg0) .. "/" .. var2.exp_interval)
								end, arg0)
							end)
						else
							arg0:doAttrAnim(var0, arg1, arg0)
						end
					end, function()
						setText(arg0.levelTxt, arg1.level)
					end)
				end)
			end)
		end
	else
		local var3 = arg2:getLevelExpConfig()

		if arg2.exp > arg1.exp then
			table.insert(var0, function(arg0)
				TweenValue(arg0.levelSlider, arg1.exp, arg2.exp, var4, 0, function(arg0)
					setSlider(arg0.levelSlider, 0, var3.exp_interval, arg0)
					setText(arg0.expInfo, math.floor(arg0) .. "/" .. var3.exp_interval)
				end, arg0)
			end)
		end
	end

	seriesAsync(var0, function()
		if arg3 then
			arg3()
		end

		arg0:enableEvent(true)
	end)
end

function var0.doAttrAnim(arg0, arg1, arg2, arg3)
	local var0 = intProperties(arg1:getShipProperties())
	local var1, var2 = arg1:getEquipmentProperties()
	local var3 = intProperties(arg2:getShipProperties())
	local var4, var5 = arg2:getEquipmentProperties()
	local var6 = intProperties(var1)
	local var7 = intProperties(var2)
	local var8 = intProperties(var4)
	local var9 = intProperties(var5)
	local var10 = {}
	local var11 = arg2:getShipCombatPower()
	local var12 = arg1:getShipCombatPower()

	if var12 ~= var11 then
		table.insert(var10, function(arg0)
			TweenValue(arg0.powerTxt, var12, var11, var4, 0, function(arg0)
				setText(arg0.powerTxt, math.floor(arg0))
			end, arg0)
		end)
	end

	for iter0, iter1 in pairs(var1) do
		local var13 = findTF(arg0.attrs, "props/" .. iter0) or findTF(arg0.attrs, "prop_" .. iter0)
		local var14 = findTF(arg0.attrs, "icons/" .. iter0) or findTF(arg0.attrs, "icon_" .. iter0)
		local var15 = findTF(var13, "value")
		local var16 = findTF(var13, "add")
		local var17 = var0[iter1] or 0
		local var18 = var7[iter1] or 1
		local var19 = var3[iter1] or 0
		local var20 = var9[iter1] or 1
		local var21
		local var22

		if arg0.evalueIndex == var0.EQUIPMENT_ADDITION then
			var21 = calcFloor(((var6[iter1] or 0) + var17) * var18) - var17
			var22 = calcFloor(((var8[iter1] or 0) + var19) * var20) - var19
		elseif arg0.evalueIndex == var0.TECHNOLOGY_ADDITION then
			var21 = arg1:getTechNationAddition(iter1)
			var22 = arg2:getTechNationAddition(iter1)
		end

		if var17 ~= 0 then
			table.insert(var10, function(arg0)
				TweenValue(var15, var17, var19, var4, 0, function(arg0)
					setText(var15, math.floor(arg0))
				end, arg0)
				arg0:scaleAnim(var15, var5, var6, var4 / 2)
			end)
		end

		if var21 < var22 then
			local var23 = arg0.evalueIndex == var0.EQUIPMENT_ADDITION and COLOR_GREEN or COLOR_YELLOW

			table.insert(var10, function(arg0)
				TweenValue(var16, var21, var22, var4, 0, function(arg0)
					setText(var16, setColorStr("+" .. math.floor(arg0), var23))
				end, arg0)
				arg0:scaleAnim(var16, var5, var6, var4 / 2)
			end)
		end

		setActive(var16, var22 ~= 0)

		if iter1 == AttributeType.Armor then
			setActive(var15, false)
			setActive(var16, false)
			setText(arg0.armorNameTxt, arg2:getShipArmorName())
		elseif iter1 == AttributeType.Expend then
			local var24 = arg2:getBattleTotalExpend()
			local var25 = arg1:getBattleTotalExpend()
			local var26 = findTF(var13, "value")

			if var25 ~= var24 then
				table.insert(var10, function(arg0)
					TweenValue(var26, var25, var24, var4, 0, function(arg0)
						setText(var26, math.floor(arg0))
					end, arg0)
					arg0:scaleAnim(var26, var5, var6, var4 / 2)
				end)
			end

			setActive(var16, false)
		elseif iter1 == AttributeType.OxyMax or iter1 == AttributeType.Tactics then
			local var27 = table.contains(TeamType.SubShipType, arg2:getShipType())

			setActive(var14, var27)
			setActive(var13, var27)

			if var27 and iter1 == AttributeType.Tactics then
				local var28, var29 = arg2:getTactics()

				setActive(var15, false)
				setActive(var16, true)
				setText(var16, i18n(var29))
			end
		end
	end

	parallelAsync(var10, function()
		if arg3 then
			arg3()
		end
	end)
end

function var0.scaleAnim(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
	LeanTween.scale(go(arg1), arg3, arg4):setFrom(arg2):setOnComplete(System.Action(function()
		if arg6 then
			arg6()
		end

		LeanTween.scale(go(arg1), arg2, arg4):setFrom(arg3):setOnComplete(System.Action(arg5))
	end))
end

function var0.clear(arg0)
	triggerToggle(arg0.evalueToggle, false)

	if LeanTween.isTweening(go(arg0.levelSlider)) then
		LeanTween.cancel(go(arg0.levelSlider))
	end

	if LeanTween.isTweening(go(arg0.powerTxt)) then
		LeanTween.cancel(go(arg0.powerTxt))
	end

	if LeanTween.isTweening(go(arg0.expInfo)) then
		LeanTween.cancel(go(arg0.expInfo))
	end

	arg0:removeLevelUpTip()

	arg0.additionValues = nil
end

return var0
