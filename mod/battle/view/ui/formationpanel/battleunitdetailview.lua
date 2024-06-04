ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleAttr
local var2 = var0.Battle.BattleDataFunction
local var3 = var0.Battle.BattleConst
local var4 = var0.Battle.BattleUnitEvent
local var5 = var0.Battle.BattleConst.EquipmentType
local var6 = class("BattleUnitDetailView")

var0.Battle.BattleUnitDetailView = var6
var6.__name = "BattleUnitDetailView"
var6.DefaultActive = {}
var6.EnemyMarkList = {}
var6.HIGH_LIGHT_BUFF = {}
var6.PrimalAttr = {
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
var6.BaseEnhancement = {
	damageRatioByCannon = "damage/damageRatioByCannon",
	injureRatioByBulletTorpedo = "injure/injureRatioByBulletTorpedo",
	damageRatioByBulletTorpedo = "damage/damageRatioByBulletTorpedo",
	injureRatioByCannon = "injure/injureRatioByCannon",
	damageRatioBullet = "damage/damageRatioBullet",
	injureRatio = "injure/injureRatio",
	injureRatioByAir = "injure/injureRatioByAir",
	damageRatioByAir = "damage/damageRatioByAir"
}
var6.SecondaryAttrListener = {}

function var6.Ctor(arg0)
	pg.DelegateInfo.New(arg0)
end

function var6.SetUnit(arg0, arg1)
	var0.EventListener.AttachEventListener(arg0)

	arg0._unit = arg1

	if arg0._unit:GetUnitType() == var3.UnitType.PLAYER_UNIT then
		local var0 = var0.Battle.BattleResourceManager.GetInstance():GetCharacterQIcon(arg0._unit:GetTemplate().painting)

		setImageSprite(arg0._icon, var0)

		for iter0 = 1, arg0._unit:GetTemplate().star do
			local var1 = cloneTplTo(arg0._starTpl, arg0._stars)

			setActive(var1, true)
		end
	end

	setText(arg0._templateID, arg0._unit:GetTemplate().id)
	setText(arg0._name, arg0._unit:GetTemplate().name)
	setText(arg0._lv, arg0._unit:GetAttrByName("level"))

	arg0._preAttrList = {}

	for iter1, iter2 in ipairs(var6.PrimalAttr) do
		local var2 = var1.GetBase(arg0._unit, iter2)

		setText(arg0._attrView:Find(iter2 .. "/base"), var2)

		arg0._preAttrList[iter2] = var2
	end

	arg0._baseEhcList = {}

	for iter3, iter4 in pairs(var6.BaseEnhancement) do
		arg0._baseEhcList[iter3] = 0
	end

	arg0._secondaryAttrList = {}
	arg0._buffList = {}
	arg0._aaList = {}
	arg0._weaponList = {}
	arg0._skillList = {}

	arg0:updateWeaponList()
end

function var6.Update(arg0)
	for iter0, iter1 in ipairs(var6.PrimalAttr) do
		arg0:updatePrimalAttr(iter1)
	end

	for iter2, iter3 in pairs(var6.BaseEnhancement) do
		arg0:updateBaseEnhancement(iter2, iter3)
	end

	local var0 = arg0._unit:GetAttr()

	for iter4, iter5 in pairs(var0) do
		if string.find(iter4, "DMG_TAG_EHC_") or string.find(iter4, "DMG_FROM_TAG_") or table.contains(var6.SecondaryAttrListener, iter4) then
			arg0:updateSecondaryAttr(iter4, iter5)
		end
	end

	arg0:updateHP()
	arg0:updateBuffList()
	arg0:updateWeaponProgress()
	arg0:updateSkillList()
end

function var6.ConfigSkin(arg0, arg1)
	arg0._go = arg1

	local var0 = arg1.transform

	arg0._tf = var0
	arg0._iconView = var0:Find("icon")
	arg0._icon = arg0._iconView:Find("icon")
	arg0._stars = arg0._iconView:Find("stars")
	arg0._starTpl = arg0._stars:Find("star_tpl")
	arg0._templateView = var0:Find("template")
	arg0._templateID = arg0._templateView:Find("template/text")
	arg0._name = arg0._templateView:Find("name/text")
	arg0._lv = arg0._templateView:Find("level/text")
	arg0._totalHP = arg0._templateView:Find("totalHP/text")
	arg0._currentHP = arg0._templateView:Find("currentHP/text")
	arg0._shield = arg0._templateView:Find("shield/text")
	arg0._attrView = var0:Find("attr_panels/primal_attr")
	arg0._baseEnhanceView = var0:Find("attr_panels/basic_ehc")
	arg0._secondaryAttrView = var0:Find("attr_panels/tag_ehc")
	arg0._secondaryAttrContainer = arg0._secondaryAttrView:Find("tag_container")
	arg0._secondaryAttrTpl = arg0._secondaryAttrView:Find("tag_attr_tpl")
	arg0._buffView = var0:Find("attr_panels/buff")
	arg0._buffContainer = arg0._buffView:Find("buff_container")
	arg0._buffTpl = arg0._buffView:Find("buff_tpl")
	arg0._weaponView = var0:Find("panel_container/weapon_panels")
	arg0._weaponContainer = arg0._weaponView:Find("weapon_container")
	arg0._weaponTpl = arg0._weaponView:Find("weapon_tpl")
	arg0._skillView = var0:Find("panel_container/skill_panel")
	arg0._skillContainer = arg0._skillView:Find("skill_container")
	arg0._skillTpl = arg0._skillView:Find("skill_tpl")

	SetActive(arg0._go, true)

	for iter0, iter1 in ipairs(var6.DefaultActive) do
		SetActive(var0:Find(iter1), true)
	end
end

function var6.updateHP(arg0)
	local var0, var1 = arg0._unit:GetHP()
	local var2 = arg0._unit:GetHPRate()

	setText(arg0._totalHP, var1)
	setText(arg0._currentHP, var0)

	local var3 = arg0._unit:GetBuffList()
	local var4 = 0

	for iter0, iter1 in pairs(var3) do
		for iter2, iter3 in ipairs(iter1:GetEffectList()) do
			if iter3.__name == "BattleBuffShield" or iter3.__name == "BattleBuffRecordShield" then
				var4 = var4 + math.max(0, iter3:GetEffectAttachData())
			end
		end
	end

	setText(arg0._shield, var4)
end

function var6.updatePrimalAttr(arg0, arg1)
	local var0 = arg0._unit:GetAttrByName(arg1)

	setText(arg0._attrView:Find(arg1 .. "/current"), var0)

	local var1 = var0 - arg0._preAttrList[arg1]

	if var1 ~= 0 then
		local var2 = arg0._attrView:Find(arg1 .. "/change")

		var6.setDeltaText(var2, var1)

		arg0._preAttrList[arg1] = var0
	end

	local var3 = var0 - var1.GetBase(arg0._unit, arg1)

	if var3 ~= 0 then
		local var4 = arg0._attrView:Find(arg1 .. "/delta")

		var6.setDeltaText(var4, var3)
	end
end

function var6.updateBaseEnhancement(arg0, arg1, arg2)
	local var0 = arg0._baseEnhanceView:Find(arg2)
	local var1 = arg0._unit:GetAttrByName(arg1)
	local var2 = var1 - arg0._baseEhcList[arg1]

	setText(var0:Find("current"), var1)

	if var2 ~= 0 then
		var6.setDeltaText(var0:Find("change"), var2)
	end
end

function var6.updateSecondaryAttr(arg0, arg1, arg2)
	if not arg0._secondaryAttrList[arg1] then
		local var0 = cloneTplTo(arg0._secondaryAttrTpl, arg0._secondaryAttrContainer)

		Canvas.ForceUpdateCanvases()
		setText(var0:Find("tag_name"), arg1)
		setActive(var0, true)

		local var1 = {
			value = 0,
			tf = var0
		}

		arg0._secondaryAttrList[arg1] = var1
	end

	local var2 = arg0._secondaryAttrList[arg1].tf
	local var3 = arg0._unit:GetAttrByName(arg1)
	local var4 = arg0._secondaryAttrList[arg1].value

	if var4 ~= arg2 then
		setText(var2:Find("current"), arg2)

		local var5 = var3 - var4

		var6.setDeltaText(var2:Find("delta"), var5)
	end
end

function var6.updateBuffList(arg0)
	local var0 = arg0._unit:GetBuffList()

	for iter0, iter1 in pairs(arg0._buffList) do
		if not var0[iter0] then
			GameObject.Destroy(iter1.gameObject)

			arg0._buffList[iter0] = nil
		end
	end

	for iter2, iter3 in pairs(var0) do
		if not arg0._buffList[iter2] then
			arg0:addBuff(iter2, iter3)
		else
			local var1 = arg0._buffList[iter2]

			if iter3._stack > 1 then
				local var2 = var1:Find("buff_stack")

				setActive(var2, true)
				setText(var2, "x" .. iter3._stack)
			end
		end
	end

	for iter4, iter5 in pairs(var0) do
		local var3 = iter5:GetEffectList()

		for iter6, iter7 in ipairs(var3) do
			if iter7.__name == var0.Battle.BattleBuffCastSkill.__name and (not arg0._skillList[iter7._skill_id] or not table.contains(arg0._skillList[iter7._skill_id].effectList, iter7)) then
				arg0:addSkillCaster(iter7)
			end
		end
	end
end

function var6.updateWeaponList(arg0)
	local var0 = arg0._unit:GetAirAssistList()

	if var0 then
		for iter0, iter1 in ipairs(var0) do
			local var1 = cloneTplTo(arg0._weaponTpl, arg0._weaponContainer)

			Canvas.ForceUpdateCanvases()

			local var2 = var1:Find("common/icon")

			GetImageSpriteFromAtlasAsync("skillicon/2130", "", var2)
			setText(var1:Find("common/index"), "空袭")
			setText(var1:Find("common/templateID"), iter1:GetStrikeSkillID())

			arg0._aaList[iter1] = var1
		end
	end

	local var3 = arg0._unit:GetAllWeapon()

	for iter2, iter3 in ipairs(var3) do
		local var4 = iter3:GetType()

		if var4 ~= var5.STRIKE_AIRCRAFT and var4 ~= var5.FLEET_ANTI_AIR then
			local var5 = cloneTplTo(arg0._weaponTpl, arg0._weaponContainer)

			Canvas.ForceUpdateCanvases()
			setText(var5:Find("common/index"), iter3:GetEquipmentIndex())
			setText(var5:Find("common/templateID"), iter3:GetTemplateData().id)

			local var6 = iter3:GetSrcEquipmentID()
			local var7 = var5:Find("common/icon")

			if var6 then
				local var8 = var2.GetWeaponDataFromID(var6).icon

				GetImageSpriteFromAtlasAsync("equips/" .. var8, "", var7)
			else
				setActive(var7, false)
			end

			arg0._weaponList[iter3] = {
				tf = var5,
				data = {}
			}

			onToggle(arg0, var5:Find("common/sector"), function(arg0)
				arg0._unit:ActiveWeaponSectorView(iter3, arg0)
			end)
			arg0:updateBulletAttrBuff(iter3)
		end
	end

	local var9 = arg0._unit:GetFleetRangeAAWeapon()

	if var9 then
		local var10 = cloneTplTo(arg0._weaponTpl, arg0._weaponContainer)

		Canvas.ForceUpdateCanvases()

		local var11 = var10:Find("common/icon")

		GetImageSpriteFromAtlasAsync("skillicon/2130", "", var11)
		setText(var10:Find("common/index"), "远程防空")
		setText(var10:Find("common/templateID"), "N/A")
		onToggle(arg0, var10:Find("common/sector"), function(arg0)
			arg0._unit:ActiveWeaponSectorView(var9, arg0)
		end)
	end
end

function var6.updateWeaponProgress(arg0)
	for iter0, iter1 in pairs(arg0._weaponList) do
		local var0 = iter1.tf
		local var1 = iter0:GetReloadRate()

		arg0.updateBarProgress(var0, var1)
		setText(var0:Find("sum/damageSum"), iter0:GetDamageSUM())
		setText(var0:Find("sum/CTRate"), string.format("%.2f", iter0:GetCTRate() * 100) .. "%")
		setText(var0:Find("sum/ACCRate"), string.format("%.2f", iter0:GetACCRate() * 100) .. "%")
		arg0:updateBulletAttrBuff(iter0)
	end

	for iter2, iter3 in pairs(arg0._aaList) do
		local var2 = iter2:GetReloadRate()

		arg0.updateBarProgress(iter3, var2)

		local var3, var4 = iter2:GetDamageSUM()

		setText(iter3:Find("sum/damageSum"), var3 .. " + " .. var4)
	end
end

function var6.updateBarProgress(arg0, arg1)
	local var0 = arg0:Find("common/reload_progress/blood"):GetComponent(typeof(Image))

	var0.fillAmount = 1 - arg1

	if arg1 == 0 then
		var0.color = Color.green
	else
		var0.color = Color.red
	end
end

function var6.updateBulletAttrBuff(arg0, arg1)
	local var0 = arg0._weaponList[arg1]
	local var1 = var0.tf
	local var2 = var0.data
	local var3 = var1:Find("weapon_attr_tpl")
	local var4 = var1:Find("weapon_attr_container")
	local var5 = {}

	for iter0, iter1 in pairs(var2) do
		var5[iter0] = true
	end

	for iter2, iter3 in pairs(arg0._unit:GetBuffList()) do
		for iter4, iter5 in ipairs(iter3:GetEffectList()) do
			if iter5.__name == var0.Battle.BattleBuffAddBulletAttr.__name then
				local var6 = arg1:GetEquipmentIndex()

				if iter5:equipIndexRequire(var6) then
					local var7 = var2[iter5]

					if not var7 then
						var7 = cloneTplTo(var3, var4)

						setText(var7:Find("tag_name"), iter5._attr)
						setText(var7:Find("src_buff"), iter3:GetID())
						Canvas.ForceUpdateCanvases()

						var7:Find("src_buff"):GetComponent(typeof(Text)).color = Color.green
						var2[iter5] = var7
					end

					setText(var7:Find("current"), iter5._number)

					var5[iter5] = false
				end
			end
		end
	end

	for iter6, iter7 in pairs(var5) do
		if iter7 then
			local var8 = var2[iter6]

			SetActive(var8:Find("expire"), true)
		end
	end
end

function var6.addBuff(arg0, arg1, arg2)
	local var0 = cloneTplTo(arg0._buffTpl, arg0._buffContainer)

	Canvas.ForceUpdateCanvases()
	setText(var0:Find("buff_id"), "buff_" .. arg1)

	if table.contains(var6.HIGH_LIGHT_BUFF, arg1) then
		local var1 = var0:Find("high_light")

		setActive(var1, true)
	end

	if arg2._stack > 1 then
		local var2 = var0:Find("buff_stack")

		setActive(var2, true)
		setText(var2, "x" .. arg2._stack)
	end

	setActive(var0, true)

	arg0._buffList[arg1] = var0
end

function var6.addSkillCaster(arg0, arg1)
	local var0 = arg1._skill_id
	local var1 = arg1._srcBuff:GetLv()

	if not var0.Battle.BattleSkillUnit.IsFireSkill(var0, var1) then
		return
	end

	local var2 = arg0._skillList[var0]

	if not var2 then
		local var3 = cloneTplTo(arg0._skillTpl, arg0._skillContainer)
		local var4 = var3:Find("common")

		setText(var4:Find("skillID"), arg1._skill_id)

		local var5 = var3:Find("common/icon")
		local var6 = arg1._srcBuff._tempData.icon or 10120

		GetImageSpriteFromAtlasAsync("skillicon/" .. var6, "", var5)
		Canvas.ForceUpdateCanvases()

		var2 = {
			tf = var3,
			effectList = {}
		}
		arg0._skillList[var0] = var2
	end

	table.insert(var2.effectList, arg1)
	arg0:updateCastEffectTpl(var0)
end

function var6.updateSkillList(arg0)
	for iter0, iter1 in pairs(arg0._skillList) do
		arg0:updateCastEffectTpl(iter0)
	end
end

function var6.updateCastEffectTpl(arg0, arg1)
	local var0 = arg0._skillList[arg1]
	local var1 = var0.tf
	local var2 = var0.effectList
	local var3 = 0
	local var4 = 0

	for iter0, iter1 in ipairs(var2) do
		var3 = var3 + iter1:GetCastCount()
		var4 = var4 + iter1:GetSkillFireDamageSum()
	end

	local var5 = var1:Find("common")

	setText(var5:Find("count"), var3)
	setText(var5:Find("damageSum"), var4)
end

function var6.Dispose(arg0)
	pg.DelegateInfo.Dispose(arg0)

	arg0._unit = nil
	arg0._secondaryAttrList = nil
	arg0._buffList = nil
	arg0._weaponList = nil

	GameObject.Destroy(arg0._go)
	var0.EventListener.DetachEventListener(arg0)
end

function var6.setDeltaText(arg0, arg1)
	setText(arg0, arg1)

	local var0 = arg1 > 0 and Color.green or Color.red

	arg0:GetComponent(typeof(Text)).color = var0
end

var6.WeaponForger = {}
var6.BulletForger = {}
var6.BarrageForger = {}
var6.AircraftForger = {}
