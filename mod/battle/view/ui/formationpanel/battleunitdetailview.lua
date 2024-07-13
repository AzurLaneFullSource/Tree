ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleAttr
local var2_0 = var0_0.Battle.BattleDataFunction
local var3_0 = var0_0.Battle.BattleConst
local var4_0 = var0_0.Battle.BattleUnitEvent
local var5_0 = var0_0.Battle.BattleConst.EquipmentType
local var6_0 = class("BattleUnitDetailView")

var0_0.Battle.BattleUnitDetailView = var6_0
var6_0.__name = "BattleUnitDetailView"
var6_0.DefaultActive = {}
var6_0.EnemyMarkList = {}
var6_0.HIGH_LIGHT_BUFF = {}
var6_0.PrimalAttr = {
	"cannonPower",
	"torpedoPower",
	"airPower",
	"antiAirPower",
	"antiSubPower",
	"loadSpeed",
	"dodgeRate",
	"attackRating",
	"velocity"
}
var6_0.BaseEnhancement = {
	damageRatioByCannon = "damage/damageRatioByCannon",
	injureRatioByBulletTorpedo = "injure/injureRatioByBulletTorpedo",
	damageRatioByBulletTorpedo = "damage/damageRatioByBulletTorpedo",
	injureRatioByCannon = "injure/injureRatioByCannon",
	damageRatioBullet = "damage/damageRatioBullet",
	injureRatio = "injure/injureRatio",
	injureRatioByAir = "injure/injureRatioByAir",
	damageRatioByAir = "damage/damageRatioByAir"
}
var6_0.SecondaryAttrListener = {}

function var6_0.Ctor(arg0_1)
	pg.DelegateInfo.New(arg0_1)
end

function var6_0.SetUnit(arg0_2, arg1_2)
	var0_0.EventListener.AttachEventListener(arg0_2)

	arg0_2._unit = arg1_2

	if arg0_2._unit:GetUnitType() == var3_0.UnitType.PLAYER_UNIT then
		local var0_2 = var0_0.Battle.BattleResourceManager.GetInstance():GetCharacterQIcon(arg0_2._unit:GetTemplate().painting)

		setImageSprite(arg0_2._icon, var0_2)

		for iter0_2 = 1, arg0_2._unit:GetTemplate().star do
			local var1_2 = cloneTplTo(arg0_2._starTpl, arg0_2._stars)

			setActive(var1_2, true)
		end
	end

	setText(arg0_2._templateID, arg0_2._unit:GetTemplate().id)
	setText(arg0_2._name, arg0_2._unit:GetTemplate().name)
	setText(arg0_2._lv, arg0_2._unit:GetAttrByName("level"))

	arg0_2._preAttrList = {}

	for iter1_2, iter2_2 in ipairs(var6_0.PrimalAttr) do
		local var2_2 = var1_0.GetBase(arg0_2._unit, iter2_2)

		setText(arg0_2._attrView:Find(iter2_2 .. "/base"), var2_2)

		arg0_2._preAttrList[iter2_2] = var2_2
	end

	arg0_2._baseEhcList = {}

	for iter3_2, iter4_2 in pairs(var6_0.BaseEnhancement) do
		arg0_2._baseEhcList[iter3_2] = 0
	end

	arg0_2._secondaryAttrList = {}
	arg0_2._buffList = {}
	arg0_2._aaList = {}
	arg0_2._weaponList = {}
	arg0_2._skillList = {}

	arg0_2:updateWeaponList()
end

function var6_0.Update(arg0_3)
	for iter0_3, iter1_3 in ipairs(var6_0.PrimalAttr) do
		arg0_3:updatePrimalAttr(iter1_3)
	end

	for iter2_3, iter3_3 in pairs(var6_0.BaseEnhancement) do
		arg0_3:updateBaseEnhancement(iter2_3, iter3_3)
	end

	local var0_3 = arg0_3._unit:GetAttr()

	for iter4_3, iter5_3 in pairs(var0_3) do
		if string.find(iter4_3, "DMG_TAG_EHC_") or string.find(iter4_3, "DMG_FROM_TAG_") or table.contains(var6_0.SecondaryAttrListener, iter4_3) then
			arg0_3:updateSecondaryAttr(iter4_3, iter5_3)
		end
	end

	arg0_3:updateHP()
	arg0_3:updateBuffList()
	arg0_3:updateWeaponProgress()
	arg0_3:updateSkillList()
end

function var6_0.ConfigSkin(arg0_4, arg1_4)
	arg0_4._go = arg1_4

	local var0_4 = arg1_4.transform

	arg0_4._tf = var0_4
	arg0_4._iconView = var0_4:Find("icon")
	arg0_4._icon = arg0_4._iconView:Find("icon")
	arg0_4._stars = arg0_4._iconView:Find("stars")
	arg0_4._starTpl = arg0_4._stars:Find("star_tpl")
	arg0_4._templateView = var0_4:Find("template")
	arg0_4._templateID = arg0_4._templateView:Find("template/text")
	arg0_4._name = arg0_4._templateView:Find("name/text")
	arg0_4._lv = arg0_4._templateView:Find("level/text")
	arg0_4._totalHP = arg0_4._templateView:Find("totalHP/text")
	arg0_4._currentHP = arg0_4._templateView:Find("currentHP/text")
	arg0_4._shield = arg0_4._templateView:Find("shield/text")
	arg0_4._attrView = var0_4:Find("attr_panels/primal_attr")
	arg0_4._baseEnhanceView = var0_4:Find("attr_panels/basic_ehc")
	arg0_4._secondaryAttrView = var0_4:Find("attr_panels/tag_ehc")
	arg0_4._secondaryAttrContainer = arg0_4._secondaryAttrView:Find("tag_container")
	arg0_4._secondaryAttrTpl = arg0_4._secondaryAttrView:Find("tag_attr_tpl")
	arg0_4._buffView = var0_4:Find("attr_panels/buff")
	arg0_4._buffContainer = arg0_4._buffView:Find("buff_container")
	arg0_4._buffTpl = arg0_4._buffView:Find("buff_tpl")
	arg0_4._weaponView = var0_4:Find("panel_container/weapon_panels")
	arg0_4._weaponContainer = arg0_4._weaponView:Find("weapon_container")
	arg0_4._weaponTpl = arg0_4._weaponView:Find("weapon_tpl")
	arg0_4._skillView = var0_4:Find("panel_container/skill_panel")
	arg0_4._skillContainer = arg0_4._skillView:Find("skill_container")
	arg0_4._skillTpl = arg0_4._skillView:Find("skill_tpl")

	SetActive(arg0_4._go, true)

	for iter0_4, iter1_4 in ipairs(var6_0.DefaultActive) do
		SetActive(var0_4:Find(iter1_4), true)
	end
end

function var6_0.updateHP(arg0_5)
	local var0_5, var1_5 = arg0_5._unit:GetHP()
	local var2_5 = arg0_5._unit:GetHPRate()

	setText(arg0_5._totalHP, var1_5)
	setText(arg0_5._currentHP, var0_5)

	local var3_5 = arg0_5._unit:GetBuffList()
	local var4_5 = 0

	for iter0_5, iter1_5 in pairs(var3_5) do
		for iter2_5, iter3_5 in ipairs(iter1_5:GetEffectList()) do
			if iter3_5.__name == "BattleBuffShield" or iter3_5.__name == "BattleBuffRecordShield" then
				var4_5 = var4_5 + math.max(0, iter3_5:GetEffectAttachData())
			end
		end
	end

	setText(arg0_5._shield, var4_5)
end

function var6_0.updatePrimalAttr(arg0_6, arg1_6)
	local var0_6 = arg0_6._unit:GetAttrByName(arg1_6)

	setText(arg0_6._attrView:Find(arg1_6 .. "/current"), var0_6)

	local var1_6 = var0_6 - arg0_6._preAttrList[arg1_6]

	if var1_6 ~= 0 then
		local var2_6 = arg0_6._attrView:Find(arg1_6 .. "/change")

		var6_0.setDeltaText(var2_6, var1_6)

		arg0_6._preAttrList[arg1_6] = var0_6
	end

	local var3_6 = var0_6 - var1_0.GetBase(arg0_6._unit, arg1_6)

	if var3_6 ~= 0 then
		local var4_6 = arg0_6._attrView:Find(arg1_6 .. "/delta")

		var6_0.setDeltaText(var4_6, var3_6)
	end
end

function var6_0.updateBaseEnhancement(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7._baseEnhanceView:Find(arg2_7)
	local var1_7 = arg0_7._unit:GetAttrByName(arg1_7)
	local var2_7 = var1_7 - arg0_7._baseEhcList[arg1_7]

	setText(var0_7:Find("current"), var1_7)

	if var2_7 ~= 0 then
		var6_0.setDeltaText(var0_7:Find("change"), var2_7)
	end
end

function var6_0.updateSecondaryAttr(arg0_8, arg1_8, arg2_8)
	if not arg0_8._secondaryAttrList[arg1_8] then
		local var0_8 = cloneTplTo(arg0_8._secondaryAttrTpl, arg0_8._secondaryAttrContainer)

		Canvas.ForceUpdateCanvases()
		setText(var0_8:Find("tag_name"), arg1_8)
		setActive(var0_8, true)

		local var1_8 = {
			value = 0,
			tf = var0_8
		}

		arg0_8._secondaryAttrList[arg1_8] = var1_8
	end

	local var2_8 = arg0_8._secondaryAttrList[arg1_8].tf
	local var3_8 = arg0_8._unit:GetAttrByName(arg1_8)
	local var4_8 = arg0_8._secondaryAttrList[arg1_8].value

	if var4_8 ~= arg2_8 then
		setText(var2_8:Find("current"), arg2_8)

		local var5_8 = var3_8 - var4_8

		var6_0.setDeltaText(var2_8:Find("delta"), var5_8)
	end
end

function var6_0.updateBuffList(arg0_9)
	local var0_9 = arg0_9._unit:GetBuffList()

	for iter0_9, iter1_9 in pairs(arg0_9._buffList) do
		if not var0_9[iter0_9] then
			GameObject.Destroy(iter1_9.gameObject)

			arg0_9._buffList[iter0_9] = nil
		end
	end

	for iter2_9, iter3_9 in pairs(var0_9) do
		if not arg0_9._buffList[iter2_9] then
			arg0_9:addBuff(iter2_9, iter3_9)
		else
			local var1_9 = arg0_9._buffList[iter2_9]

			if iter3_9._stack > 1 then
				local var2_9 = var1_9:Find("buff_stack")

				setActive(var2_9, true)
				setText(var2_9, "x" .. iter3_9._stack)
			end
		end
	end

	for iter4_9, iter5_9 in pairs(var0_9) do
		local var3_9 = iter5_9:GetEffectList()

		for iter6_9, iter7_9 in ipairs(var3_9) do
			if iter7_9.__name == var0_0.Battle.BattleBuffCastSkill.__name and (not arg0_9._skillList[iter7_9._skill_id] or not table.contains(arg0_9._skillList[iter7_9._skill_id].effectList, iter7_9)) then
				arg0_9:addSkillCaster(iter7_9)
			end
		end
	end
end

function var6_0.updateWeaponList(arg0_10)
	local var0_10 = arg0_10._unit:GetAirAssistList()

	if var0_10 then
		for iter0_10, iter1_10 in ipairs(var0_10) do
			local var1_10 = cloneTplTo(arg0_10._weaponTpl, arg0_10._weaponContainer)

			Canvas.ForceUpdateCanvases()

			local var2_10 = var1_10:Find("common/icon")

			GetImageSpriteFromAtlasAsync("skillicon/2130", "", var2_10)
			setText(var1_10:Find("common/index"), "空袭")
			setText(var1_10:Find("common/templateID"), iter1_10:GetStrikeSkillID())

			arg0_10._aaList[iter1_10] = var1_10
		end
	end

	local var3_10 = arg0_10._unit:GetAllWeapon()

	for iter2_10, iter3_10 in ipairs(var3_10) do
		local var4_10 = iter3_10:GetType()

		if var4_10 ~= var5_0.STRIKE_AIRCRAFT and var4_10 ~= var5_0.FLEET_ANTI_AIR then
			local var5_10 = cloneTplTo(arg0_10._weaponTpl, arg0_10._weaponContainer)

			Canvas.ForceUpdateCanvases()
			setText(var5_10:Find("common/index"), iter3_10:GetEquipmentIndex())
			setText(var5_10:Find("common/templateID"), iter3_10:GetTemplateData().id)

			local var6_10 = iter3_10:GetSrcEquipmentID()
			local var7_10 = var5_10:Find("common/icon")

			if var6_10 then
				local var8_10 = var2_0.GetWeaponDataFromID(var6_10).icon

				GetImageSpriteFromAtlasAsync("equips/" .. var8_10, "", var7_10)
			else
				setActive(var7_10, false)
			end

			arg0_10._weaponList[iter3_10] = {
				tf = var5_10,
				data = {}
			}

			onToggle(arg0_10, var5_10:Find("common/sector"), function(arg0_11)
				arg0_10._unit:ActiveWeaponSectorView(iter3_10, arg0_11)
			end)
			arg0_10:updateBulletAttrBuff(iter3_10)
		end
	end

	local var9_10 = arg0_10._unit:GetFleetRangeAAWeapon()

	if var9_10 then
		local var10_10 = cloneTplTo(arg0_10._weaponTpl, arg0_10._weaponContainer)

		Canvas.ForceUpdateCanvases()

		local var11_10 = var10_10:Find("common/icon")

		GetImageSpriteFromAtlasAsync("skillicon/2130", "", var11_10)
		setText(var10_10:Find("common/index"), "远程防空")
		setText(var10_10:Find("common/templateID"), "N/A")
		onToggle(arg0_10, var10_10:Find("common/sector"), function(arg0_12)
			arg0_10._unit:ActiveWeaponSectorView(var9_10, arg0_12)
		end)
	end
end

function var6_0.updateWeaponProgress(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13._weaponList) do
		local var0_13 = iter1_13.tf
		local var1_13 = iter0_13:GetReloadRate()

		arg0_13.updateBarProgress(var0_13, var1_13)
		setText(var0_13:Find("sum/damageSum"), iter0_13:GetDamageSUM())
		setText(var0_13:Find("sum/CTRate"), string.format("%.2f", iter0_13:GetCTRate() * 100) .. "%")
		setText(var0_13:Find("sum/ACCRate"), string.format("%.2f", iter0_13:GetACCRate() * 100) .. "%")
		arg0_13:updateBulletAttrBuff(iter0_13)
	end

	for iter2_13, iter3_13 in pairs(arg0_13._aaList) do
		local var2_13 = iter2_13:GetReloadRate()

		arg0_13.updateBarProgress(iter3_13, var2_13)

		local var3_13, var4_13 = iter2_13:GetDamageSUM()

		setText(iter3_13:Find("sum/damageSum"), var3_13 .. " + " .. var4_13)
	end
end

function var6_0.updateBarProgress(arg0_14, arg1_14)
	local var0_14 = arg0_14:Find("common/reload_progress/blood"):GetComponent(typeof(Image))

	var0_14.fillAmount = 1 - arg1_14

	if arg1_14 == 0 then
		var0_14.color = Color.green
	else
		var0_14.color = Color.red
	end
end

function var6_0.updateBulletAttrBuff(arg0_15, arg1_15)
	local var0_15 = arg0_15._weaponList[arg1_15]
	local var1_15 = var0_15.tf
	local var2_15 = var0_15.data
	local var3_15 = var1_15:Find("weapon_attr_tpl")
	local var4_15 = var1_15:Find("weapon_attr_container")
	local var5_15 = {}

	for iter0_15, iter1_15 in pairs(var2_15) do
		var5_15[iter0_15] = true
	end

	for iter2_15, iter3_15 in pairs(arg0_15._unit:GetBuffList()) do
		for iter4_15, iter5_15 in ipairs(iter3_15:GetEffectList()) do
			if iter5_15.__name == var0_0.Battle.BattleBuffAddBulletAttr.__name then
				local var6_15 = arg1_15:GetEquipmentIndex()

				if iter5_15:equipIndexRequire(var6_15) then
					local var7_15 = var2_15[iter5_15]

					if not var7_15 then
						var7_15 = cloneTplTo(var3_15, var4_15)

						setText(var7_15:Find("tag_name"), iter5_15._attr)
						setText(var7_15:Find("src_buff"), iter3_15:GetID())
						Canvas.ForceUpdateCanvases()

						var7_15:Find("src_buff"):GetComponent(typeof(Text)).color = Color.green
						var2_15[iter5_15] = var7_15
					end

					setText(var7_15:Find("current"), iter5_15._number)

					var5_15[iter5_15] = false
				end
			end
		end
	end

	for iter6_15, iter7_15 in pairs(var5_15) do
		if iter7_15 then
			local var8_15 = var2_15[iter6_15]

			SetActive(var8_15:Find("expire"), true)
		end
	end
end

function var6_0.addBuff(arg0_16, arg1_16, arg2_16)
	local var0_16 = cloneTplTo(arg0_16._buffTpl, arg0_16._buffContainer)

	Canvas.ForceUpdateCanvases()
	setText(var0_16:Find("buff_id"), "buff_" .. arg1_16)

	if table.contains(var6_0.HIGH_LIGHT_BUFF, arg1_16) then
		local var1_16 = var0_16:Find("high_light")

		setActive(var1_16, true)
	end

	if arg2_16._stack > 1 then
		local var2_16 = var0_16:Find("buff_stack")

		setActive(var2_16, true)
		setText(var2_16, "x" .. arg2_16._stack)
	end

	setActive(var0_16, true)

	arg0_16._buffList[arg1_16] = var0_16
end

function var6_0.addSkillCaster(arg0_17, arg1_17)
	local var0_17 = arg1_17._skill_id
	local var1_17 = arg1_17._srcBuff:GetLv()

	if not var0_0.Battle.BattleSkillUnit.IsFireSkill(var0_17, var1_17) then
		return
	end

	local var2_17 = arg0_17._skillList[var0_17]

	if not var2_17 then
		local var3_17 = cloneTplTo(arg0_17._skillTpl, arg0_17._skillContainer)
		local var4_17 = var3_17:Find("common")

		setText(var4_17:Find("skillID"), arg1_17._skill_id)

		local var5_17 = var3_17:Find("common/icon")
		local var6_17 = arg1_17._srcBuff._tempData.icon or 10120

		GetImageSpriteFromAtlasAsync("skillicon/" .. var6_17, "", var5_17)
		Canvas.ForceUpdateCanvases()

		var2_17 = {
			tf = var3_17,
			effectList = {}
		}
		arg0_17._skillList[var0_17] = var2_17
	end

	table.insert(var2_17.effectList, arg1_17)
	arg0_17:updateCastEffectTpl(var0_17)
end

function var6_0.updateSkillList(arg0_18)
	for iter0_18, iter1_18 in pairs(arg0_18._skillList) do
		arg0_18:updateCastEffectTpl(iter0_18)
	end
end

function var6_0.updateCastEffectTpl(arg0_19, arg1_19)
	local var0_19 = arg0_19._skillList[arg1_19]
	local var1_19 = var0_19.tf
	local var2_19 = var0_19.effectList
	local var3_19 = 0
	local var4_19 = 0

	for iter0_19, iter1_19 in ipairs(var2_19) do
		var3_19 = var3_19 + iter1_19:GetCastCount()
		var4_19 = var4_19 + iter1_19:GetSkillFireDamageSum()
	end

	local var5_19 = var1_19:Find("common")

	setText(var5_19:Find("count"), var3_19)
	setText(var5_19:Find("damageSum"), var4_19)
end

function var6_0.Dispose(arg0_20)
	pg.DelegateInfo.Dispose(arg0_20)

	arg0_20._unit = nil
	arg0_20._secondaryAttrList = nil
	arg0_20._buffList = nil
	arg0_20._weaponList = nil

	GameObject.Destroy(arg0_20._go)
	var0_0.EventListener.DetachEventListener(arg0_20)
end

function var6_0.setDeltaText(arg0_21, arg1_21)
	setText(arg0_21, arg1_21)

	local var0_21 = arg1_21 > 0 and Color.green or Color.red

	arg0_21:GetComponent(typeof(Text)).color = var0_21
end

var6_0.WeaponForger = {}
var6_0.BulletForger = {}
var6_0.BarrageForger = {}
var6_0.AircraftForger = {}
