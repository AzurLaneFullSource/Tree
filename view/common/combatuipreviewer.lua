local var0_0 = class("CombatUIPreviewer")
local var1_0 = Vector3(0, 1, 40)
local var2_0 = Vector3(35, 1, 40)
local var3_0 = Vector3(30, 0, 0)
local var4_0 = Vector3(330, 0, 0)
local var5_0 = Vector3(-532, 157, -675)
local var6_0 = Vector3(-665, 70, -675)
local var7_0 = Vector3(473, 157, -675)
local var8_0 = Vector3(-791, 70, -675)
local var9_0 = Vector3(464, 70, -675)

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.rawImage = arg1_1

	setActive(arg0_1.rawImage, false)

	arg0_1.seaCameraGO = GameObject.Find("BarrageCamera")
	arg0_1.seaCameraGO.tag = "MainCamera"
	arg0_1.seaCamera = arg0_1.seaCameraGO:GetComponent(typeof(Camera))
	arg0_1.seaCamera.targetTexture = arg0_1.rawImage.texture
	arg0_1.seaCamera.enabled = true
	arg0_1.mainCameraGO = pg.UIMgr.GetInstance():GetMainCamera()
end

function var0_0.setDisplayWeapon(arg0_2, arg1_2, arg2_2, arg3_2)
	arg0_2.weaponIds = arg1_2
	arg0_2.equipSkinId = arg2_2 or 0
end

function var0_0.setCombatUI(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	arg0_3.uiGO = arg1_3
	arg0_3.hpBarGO = arg2_3
	arg0_3.enemyBarGO = arg3_3
	arg0_3.skinKey = arg4_3

	local var0_3 = arg1_3.transform

	arg0_3.uiTF = var0_3
	arg0_3.chatPop = var0_3:Find("popup")
	arg0_3.chatPopGo = arg0_3.chatPop.gameObject

	setActive(arg0_3.chatPop, false)

	arg0_3.flagShipMark = var0_3:Find("flagShipMark")
	arg0_3.timer = var0_3:Find("Timer")

	setActive(arg0_3.timer, true)
	setText(arg0_3.timer:Find("Text"), "03:00")

	arg0_3.buttonContainer = var0_3:Find("Weapon_button_container")

	for iter0_3 = 1, 3 do
		local var1_3 = ys.Battle.BattleWeaponButton.New()
		local var2_3 = cloneTplTo(var0_3:Find("Weapon_button_progress"), arg0_3.buttonContainer)

		skinName = "Skill_" .. iter0_3

		local var3_3 = {}

		ys.Battle.BattleSkillView.SetSkillButtonPreferences(var2_3, iter0_3)
		var1_3:ConfigSkin(var2_3)
		var1_3:SwitchIcon(iter0_3, arg4_3)
		var1_3:SwitchIconEffect(iter0_3, arg4_3)
		var1_3:SetTextActive(true)
		var1_3:SetToCombatUIPreview(iter0_3 > 1)
	end

	arg0_3.heroBar = arg2_3.transform

	setActive(arg0_3.heroBar:Find("heroBlood"), true)

	arg0_3.enemyBar = arg0_3.enemyBarGO.transform

	setActive(arg0_3.enemyBar:Find("enemyBlood"), true)
	arg0_3:updateBarPos()

	arg0_3.mainArrow = var0_3:Find("EnemyArrowContainer/MainArrow")

	setActive(arg0_3.mainArrow, true)

	arg0_3.autoBtn = var0_3:Find("AutoBtn")

	setActive(arg0_3.autoBtn, true)
	triggerToggle(arg0_3.autoBtn, true)

	arg0_3.enemyHPBar = var0_3:Find("EnemyHPBar")

	setActive(arg0_3.enemyHPBar, false)

	arg0_3.bossHPBar = var0_3:Find("BossBarContainer/heroBlood")

	setActive(arg0_3.bossHPBar, true)

	local var4_3 = arg0_3.bossHPBar:Find("bloodBarContainer")
	local var5_3 = var4_3.childCount - 1

	for iter1_3 = 0, var5_3 do
		var4_3:GetChild(iter1_3):GetComponent(typeof(Image)).fillAmount = 1
		iter1_3 = iter1_3 + 1
	end

	arg0_3.skillContainer = var0_3:Find("Skill_Activation/Root")
	arg0_3.skill = var0_3:Find("Skill_Activation/mask")

	local var6_3 = var0_3:Find("Stick/Area/BG/spine")

	if var6_3 then
		var6_3:GetComponent(typeof(SpineAnimUI)):SetAction("normal", 0)
	end
end

function var0_0.load(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4, arg5_4)
	assert(not arg0_4.loading and not arg0_4.loaded, "load function can be called only once.")

	arg0_4.loading = true
	arg0_4.shipVO = arg2_4
	arg0_4.enemyVO = arg3_4

	ys.Battle.BattleVariable.Init()
	ys.Battle.BattleVariable.UpdateCameraPositionArgs()
	ys.Battle.BattleFXPool.GetInstance():Init()

	local var0_4 = ys.Battle.BattleResourceManager.GetInstance()

	var0_4:Init()
	var0_4:AddPreloadResource(var0_4.GetUIPath("CombatHPPop" .. arg0_4.skinKey))
	var0_4:AddPreloadResource(var0_4.GetMapResource(arg1_4))
	var0_4:AddPreloadResource(var0_4.GetDisplayCommonResource())

	if arg0_4.equipSkinId > 0 then
		var0_4:AddPreloadResource(var0_4.GetEquipSkinPreviewRes(arg0_4.equipSkinId))
	end

	var0_4:AddPreloadResource(var0_4.GetShipResource(arg2_4.configId, arg2_4.skinId), false)
	var0_4:AddPreloadResource(var0_4.GetShipResource(arg3_4.configId, arg3_4.skinId), false)

	local function var1_4()
		arg0_4.seaView = ys.Battle.BattleMap.New(arg1_4)

		local function var0_5(arg0_6)
			arg0_4.loading = false
			arg0_4.loaded = true

			pg.UIMgr.GetInstance():LoadingOff()

			local var0_6 = ys.Battle.BattleFXPool.GetInstance()

			arg0_4.seaFXPool = var0_6

			local var1_6 = pg.ship_skin_template[arg2_4.skinId].fx_container
			local var2_6 = {}

			for iter0_6, iter1_6 in ipairs(ys.Battle.BattleConst.FXContainerIndex) do
				local var3_6 = var1_6[iter0_6]

				var2_6[iter0_6] = Vector3(var3_6[1], var3_6[2], var3_6[3])
			end

			local var4_6 = arg2_4:getConfig("scale") / 50

			local function var5_6(arg0_7, arg1_7)
				local var0_7 = arg0_7.transform

				if arg1_7 then
					var0_7.localScale = Vector3(var4_6 * -1, var4_6, var4_6)
				else
					var0_7.localScale = Vector3(var4_6, var4_6, var4_6)
				end

				var0_7.localEulerAngles = var3_0

				var0_7:GetComponent("SpineAnim"):SetAction(ys.Battle.BattleConst.ActionName.MOVE, 0, true)

				local var1_7 = GameObject()
				local var2_7 = var1_7.transform

				var2_7:SetParent(var0_7, false)

				var2_7.localPosition = Vector3.zero
				var2_7.localEulerAngles = var4_0

				local var3_7 = {
					GetGO = function()
						return arg0_4.seaCharacter
					end,
					GetSpecificFXScale = function()
						return {}
					end,
					GetAttachPoint = function()
						return var1_7
					end,
					GetFXOffsets = function(arg0_11, arg1_11)
						arg1_11 = arg1_11 or 1

						return var2_6[arg1_11]
					end
				}
				local var4_7 = var0_6:GetCharacterFX("movewave", var3_7)

				pg.EffectMgr.GetInstance():PlayBattleEffect(var4_7, Vector3.zero, true)
			end

			arg0_4.seaCharacter = arg0_6

			var5_6(arg0_4.seaCharacter)

			arg0_4.seaCharacter.transform.localPosition = var1_0

			arg0_4:SeaUpdate()

			local var6_6 = ys.Battle.BattleResourceManager.GetInstance():GetCharacterSquareIcon(arg0_4.enemyVO:getPrefab())
			local var7_6 = ys.Battle.BattleResourceManager.GetInstance():GetCharacterQIcon(arg0_4.shipVO:getPrefab())
			local var8_6 = findTF(arg0_4.mainArrow, "icon")

			setImageSprite(var8_6, var7_6)
			setImageSprite(findTF(arg0_4.bossHPBar, "BossIcon/icon"), var6_6)
			setText(findTF(arg0_4.bossHPBar, "BossNameBG/BossName"), ys.Battle.BattleDataFunction.GetPlayerShipTmpDataFromID(arg0_4.enemyVO.configId).name)
			setActive(arg0_4.rawImage, true)
			arg0_4.mainCameraGO:SetActive(false)
			pg.TimeMgr.GetInstance():ResumeBattleTimer()
			arg5_4()
		end

		local function var1_5(arg0_12)
			local var0_12 = ys.Battle.BattleFXPool.GetInstance()

			arg0_4.seaFXPool = var0_12

			local var1_12 = pg.ship_skin_template[arg3_4.skinId].fx_container
			local var2_12 = {}

			for iter0_12, iter1_12 in ipairs(ys.Battle.BattleConst.FXContainerIndex) do
				local var3_12 = var1_12[iter0_12]

				var2_12[iter0_12] = Vector3(var3_12[1], var3_12[2], var3_12[3])
			end

			local var4_12 = arg3_4:getConfig("scale") / 50

			local function var5_12(arg0_13, arg1_13)
				local var0_13 = arg0_13.transform

				if arg1_13 then
					var0_13.localScale = Vector3(var4_12 * -1, var4_12, var4_12)
				else
					var0_13.localScale = Vector3(var4_12, var4_12, var4_12)
				end

				var0_13.localEulerAngles = var3_0

				var0_13:GetComponent("SpineAnim"):SetAction(ys.Battle.BattleConst.ActionName.MOVE, 0, true)

				local var1_13 = GameObject()
				local var2_13 = var1_13.transform

				var2_13:SetParent(var0_13, false)

				var2_13.localPosition = Vector3.zero
				var2_13.localEulerAngles = var4_0

				local var3_13 = {
					GetGO = function()
						return arg0_4.seaCharacter
					end,
					GetSpecificFXScale = function()
						return {}
					end,
					GetAttachPoint = function()
						return var1_13
					end,
					GetFXOffsets = function(arg0_17, arg1_17)
						arg1_17 = arg1_17 or 1

						return var2_12[arg1_17]
					end
				}
				local var4_13 = var0_12:GetCharacterFX("movewave", var3_13)

				pg.EffectMgr.GetInstance():PlayBattleEffect(var4_13, Vector3.zero, true)
			end

			arg0_4.seaEnemy = arg0_12

			var5_12(arg0_4.seaEnemy, true)

			arg0_4.seaEnemy.transform.localPosition = var2_0
		end

		var0_4:InstCharacter(arg3_4:getPrefab(), function(arg0_18)
			var1_5(arg0_18)
		end)
		var0_4:InstCharacter(arg2_4:getPrefab(), function(arg0_19)
			var0_5(arg0_19)
		end)
	end

	var0_4:StartPreload(var1_4, nil)
	pg.UIMgr.GetInstance():LoadingOn()
end

function var0_0.updateBarPos(arg0_20)
	if arg0_20.seaCharacter then
		arg0_20.heroBar.localPosition = var5_0
		arg0_20.flagShipMark.localPosition = var6_0
	end

	if arg0_20.seaEnemy then
		arg0_20.enemyBar.localPosition = var7_0
	end
end

function var0_0.updatePopUp(arg0_21)
	setActive(arg0_21.chatPop, true)

	arg0_21.chatPop.localPosition = var8_0

	LeanTween.cancel(arg0_21.chatPop)

	if arg0_21.chatPop.transform:GetComponent(typeof(Animation)) then
		ys.Battle.BattleCharacter.ChatPopAnimation(arg0_21.chatPop, pg.ship_skin_words[100000].skill, 4)
	else
		LeanTween.scale(rtf(arg0_21.chatPop.gameObject), Vector3.New(0, 0, 1), 0.1):setEase(LeanTweenType.easeInBack):setOnComplete(System.Action(function()
			ys.Battle.BattleCharacter.ChatPop(arg0_21.chatPop, pg.ship_skin_words[100000].skill, 5)
		end))
	end
end

function var0_0.updateSkillFloat(arg0_23)
	setActive(arg0_23.skill, true)

	local var0_23 = ys.Battle.BattleResourceManager.GetInstance()
	local var1_23

	if arg0_23.skinKey == "Standard" then
		var1_23 = var0_23:GetCharacterIcon(arg0_23.shipVO:getPrefab())
	else
		var1_23 = var0_23:GetCharacterSquareIcon(arg0_23.shipVO:getPrefab())
	end

	local var2_23 = arg0_23.skill.transform

	arg0_23.skill.localScale = Vector3(1.5, 1.5, 0)

	local var3_23 = var2_23:GetComponent(typeof(Animation))

	if var3_23 then
		local var4_23 = 1

		while var3_23:GetClip("anim_skinui_skill_" .. var4_23) do
			var4_23 = var4_23 + 1
		end

		if var4_23 > 1 then
			var3_23:Play("anim_skinui_skill_" .. math.random(var4_23 - 1))
		end
	end

	setText(findTF(var2_23, "skill/skill_name/Text"), HXSet.hxLan(pg.skill_data_template[9033].name))

	local var5_23 = findTF(var2_23, "skill/icon_mask/icon")
	local var6_23 = findTF(var2_23, "skill/skill_name")

	var5_23:GetComponent(typeof(Image)).sprite = var1_23

	local var7_23 = Color.New(1, 1, 1, 1)

	var6_23:GetComponent(typeof(Image)).color = var7_23
	findTF(var2_23, "skill"):GetComponent(typeof(Image)).color = var7_23

	var2_23:GetComponent(typeof(DftAniEvent)):SetEndEvent(function(arg0_24)
		setActive(arg0_23.skill, false)
	end)

	var2_23.position = Clone(arg0_23.heroBar.position)
end

function var0_0.updateHPPop(arg0_25)
	if not arg0_25._popNumMgr then
		arg0_25._popNumMgr = ys.Battle.BattlePopNumManager.GetInstance()

		arg0_25._popNumMgr:InitialBundlePool(arg0_25.uiGO.transform:Find("HPTextCharacterContainer/container"))

		arg0_25._popNumBundle = arg0_25._popNumMgr:GetBundle()
	end

	local var0_25 = math.random(1, 4)
	local var1_25 = math.random(1, 2) > 1
	local var2_25 = arg0_25._popNumBundle:GetPop(false, var1_25, false, 114, {
		var0_25,
		1
	})

	var2_25._tf.localPosition = var9_0

	var2_25:Play()
end

function var0_0.SeaUpdate(arg0_26)
	local var0_26 = -20
	local var1_26 = 60
	local var2_26 = 0
	local var3_26 = 60
	local var4_26 = ys.Battle.BattleConfig
	local var5_26 = ys.Battle.BattleConst

	local function var6_26()
		arg0_26:updateBarPos()
	end

	pg.TimeMgr.GetInstance():AddBattleTimer("barrageUpdateTimer", -1, 0.033, var6_26)

	local function var7_26()
		arg0_26:updatePopUp()
	end

	pg.TimeMgr.GetInstance():AddBattleTimer("popupUpdateTimer", -1, 10, var7_26)

	local function var8_26()
		arg0_26:updateSkillFloat()
	end

	pg.TimeMgr.GetInstance():AddBattleTimer("skillFloatUpdateTimer", -1, 10, var8_26)

	local function var9_26()
		arg0_26:updateHPPop()
	end

	pg.TimeMgr.GetInstance():AddBattleTimer("HPPopUpdateTimer", -1, 3, var9_26)
end

function var0_0.clear(arg0_31)
	pg.TimeMgr.GetInstance():RemoveAllBattleTimer()
	Destroy(arg0_31.seaCharacter)
	Destroy(arg0_31.seaEnemy)
	Destroy(arg0_31.uiGO)
	Destroy(arg0_31.hpBarGO)
	Destroy(arg0_31.enemyBarGO)

	if arg0_31.seaView then
		arg0_31.seaView:Dispose()

		arg0_31.seaView = nil
	end

	if arg0_31._popNumMgr then
		arg0_31._popNumMgr:Clear()
	end

	if arg0_31.weaponList then
		for iter0_31, iter1_31 in ipairs(arg0_31.weaponList) do
			for iter2_31, iter3_31 in ipairs(iter1_31.emitterList) do
				iter3_31:Destroy()
			end
		end

		arg0_31.weaponList = nil
	end

	if arg0_31.seaFXPool then
		arg0_31.seaFXPool:Clear()

		arg0_31.seaFXPool = nil
	end

	if arg0_31.seaFXContainersPool then
		arg0_31.seaFXContainersPool:Clear()

		arg0_31.seaFXContainersPool = nil
	end

	ys.Battle.BattleResourceManager.GetInstance():Clear()

	arg0_31.seaCameraGO.tag = "Untagged"
	arg0_31.seaCameraGO = nil
	arg0_31.seaCamera = nil

	arg0_31.mainCameraGO:SetActive(true)

	arg0_31.mainCameraGO = nil
	arg0_31.loading = false
	arg0_31.loaded = false
end

return var0_0
