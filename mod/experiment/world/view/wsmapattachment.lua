local var0_0 = class("WSMapAttachment", import(".WSMapTransform"))

var0_0.Fields = {
	cell = "table",
	lurkTimer = "table",
	map = "table",
	twTimer = "userdata",
	attachment = "table",
	isInit = "boolean",
	twBreathId = "number",
	isFighting = "boolean"
}
var0_0.Listeners = {
	onUpdate = "Update"
}
var0_0.CharBasePos = Vector2.zero
var0_0.IconBasePos = Vector2(0, 10)

function var0_0.GetResName(arg0_1)
	if arg0_1.type == WorldMapAttachment.TypeEvent then
		if arg0_1:GetReplaceDisplayEnemyConfig() then
			return "enemy_tpl"
		else
			return "event_tpl"
		end
	elseif arg0_1.type == WorldMapAttachment.TypeBox then
		return "event_tpl"
	elseif WorldMapAttachment.IsEnemyType(arg0_1.type) then
		return "enemy_tpl"
	elseif arg0_1.type == WorldMapAttachment.TypePort then
		return "blank_tpl"
	elseif arg0_1.type == WorldMapAttachment.TypeTransportFleet then
		return "transport_tpl"
	elseif arg0_1.type == WorldMapAttachment.TypeTrap then
		return "event_tpl"
	else
		assert(false, "invalid attachment type: " .. tostring(arg0_1.type))
	end
end

function var0_0.Setup(arg0_2, arg1_2, arg2_2, arg3_2)
	assert(arg0_2.worldMapAttachment == nil)

	arg0_2.map = arg1_2
	arg0_2.cell = arg2_2

	arg0_2.cell:AddListener(WorldMapCell.EventUpdateInFov, arg0_2.onUpdate)
	arg0_2.cell:AddListener(WorldMap.EventUpdateMapBuff, arg0_2.onUpdate)

	arg0_2.attachment = arg3_2

	arg0_2:Init()
end

function var0_0.Dispose(arg0_3)
	arg0_3.cell:RemoveListener(WorldMapCell.EventUpdateInFov, arg0_3.onUpdate)
	arg0_3.cell:RemoveListener(WorldMap.EventUpdateMapBuff, arg0_3.onUpdate)

	if arg0_3.twBreathId then
		LeanTween.cancel(arg0_3.twBreathId)
	end

	if arg0_3.lurkTimer then
		arg0_3.lurkTimer:Stop()
	end

	arg0_3.transform.localEulerAngles = Vector3.zero

	var0_0.super.Dispose(arg0_3)
end

function var0_0.Init(arg0_4)
	arg0_4.transform.anchoredPosition3D = Vector3.zero
	arg0_4.transform.localEulerAngles = Vector3.zero
	arg0_4.transform.name = arg0_4.attachment:GetDebugName()

	arg0_4:SetModelOrder(arg0_4.attachment:GetModelOrder(), arg0_4.cell.row)
	arg0_4:Update()
end

function var0_0.LoadAvatar(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = {}

	if arg1_5 and #arg1_5 > 0 then
		table.insert(var0_5, function(arg0_6)
			arg0_5:LoadModel(WorldConst.ModelSpine, arg1_5, nil, true, function()
				arg0_5.model:SetParent(arg2_5, false)
				arg0_6()
			end)
		end)
	end

	seriesAsync(var0_5, arg3_5)
end

function var0_0.LoadBoxPrefab(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8 = {}

	if arg1_8 and #arg1_8 > 0 then
		table.insert(var0_8, function(arg0_9)
			arg0_8:LoadModel(WorldConst.ModelPrefab, WorldConst.ResBoxPrefab .. arg1_8, arg1_8, true, function()
				arg0_8.model:SetParent(arg2_8, false)
				arg0_9()
			end)
		end)
	end

	seriesAsync(var0_8, arg3_8)
end

function var0_0.LoadChapterPrefab(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = {}

	if arg1_11 and #arg1_11 > 0 then
		table.insert(var0_11, function(arg0_12)
			arg0_11:LoadModel(WorldConst.ModelPrefab, WorldConst.ResChapterPrefab .. arg1_11, arg1_11, true, function()
				arg0_11.model:SetParent(arg2_11, false)
				arg0_12()
			end)
		end)
	end

	seriesAsync(var0_11, arg3_11)
end

function var0_0.Update(arg0_14, arg1_14)
	local var0_14 = arg0_14.attachment

	if var0_14.type == WorldMapAttachment.TypeEvent then
		if var0_14:GetReplaceDisplayEnemyConfig() then
			arg0_14:UpdateEventEnemy(arg1_14)
		else
			arg0_14:UpdateEvent(arg1_14)
		end
	elseif var0_14.type == WorldMapAttachment.TypeBox then
		arg0_14:UpdateBox(arg1_14)
	elseif var0_14.type == WorldMapAttachment.TypePort then
		arg0_14:UpdatePort(arg1_14)
	elseif WorldMapAttachment.IsEnemyType(var0_14.type) then
		arg0_14:UpdateEnemy(arg1_14)
	elseif var0_14.type == WorldMapAttachment.TypeTransportFleet then
		arg0_14:UpdateTransportFleet(arg1_14)
	elseif var0_14.type == WorldMapAttachment.TypeTrap then
		arg0_14:UpdateTrap(arg1_14)
	else
		assert(false, "invalid attachment type: " .. var0_14.type)
	end

	arg0_14:UpdateBreathTween()
	arg0_14:UpdateModelAngles(arg0_14.attachment:GetMillor() and Vector3(0, 180, 0) or Vector3.zero)
	arg0_14:UpdateModelScale(arg0_14.attachment:GetScale())
end

function var0_0.UpdateEvent(arg0_15, arg1_15)
	local var0_15 = arg0_15.map
	local var1_15 = arg0_15.cell
	local var2_15 = arg0_15.attachment
	local var3_15 = arg0_15.transform
	local var4_15 = var0_15:CheckDisplay(var2_15)

	setActive(var3_15, var4_15)

	if var4_15 then
		local var5_15 = var2_15:IsAvatar()

		if arg0_15.isInit and arg1_15 == WorldMap.EventUpdateMapBuff then
			arg0_15:UpdateMapBuff(var3_15, var2_15:GetRadiationBuffs(), var0_15:GetBuffList(WorldMap.FactionEnemy, var2_15))
		end

		if not arg0_15.isInit then
			arg0_15.isInit = true

			local var6_15 = var2_15.config
			local var7_15 = var3_15:Find("char")
			local var8_15 = var3_15:Find("icon")

			setActive(var7_15, var5_15)
			setActive(var8_15, not var5_15)

			if var5_15 then
				arg0_15:LoadAvatar(var6_15.icon, var7_15:Find("ship"), function()
					if #var6_15.icon > 0 then
						setAnchoredPosition(arg0_15.model, var2_15:GetDeviation())
					end
				end)
			elseif math.floor(var6_15.enemyicon / 2) == 2 then
				arg0_15:LoadChapterPrefab(var6_15.icon, var8_15, function()
					if #var6_15.icon > 0 then
						setAnchoredPosition(arg0_15.model, var2_15:GetDeviation())
					end
				end)
			elseif math.floor(var6_15.enemyicon / 2) == 0 then
				arg0_15:LoadBoxPrefab(var6_15.icon, var8_15, function()
					if #var6_15.icon > 0 then
						setAnchoredPosition(arg0_15.model, var2_15:GetDeviation())
					end
				end)
			else
				assert(false, "enemyicon error from id: " .. var2_15.id)
			end

			arg0_15:UpdateBuffList(var3_15, var2_15:GetBuffList())
			arg0_15:UpdateMapBuff(var3_15, var2_15:GetRadiationBuffs(), var0_15:GetBuffList(WorldMap.FactionEnemy, var2_15))
		end

		if arg1_15 == WorldMapAttachment.EventUpdateLurk and var1_15:GetInFOV() and not var2_15.lurk then
			setActive(var3_15:Find("effect_found"), true)

			arg0_15.lurkTimer = Timer.New(function()
				setActive(var3_15:Find("effect_found"), false)
			end, 3, 1)

			arg0_15.lurkTimer:Start()
		else
			setActive(var3_15:Find("effect_found"), false)
		end
	end
end

function var0_0.UpdateEventEnemy(arg0_20, arg1_20)
	local var0_20 = arg0_20.map
	local var1_20 = arg0_20.cell
	local var2_20 = arg0_20.attachment
	local var3_20 = arg0_20.transform
	local var4_20 = var3_20:Find("live")
	local var5_20 = var3_20:Find("dead")
	local var6_20 = var0_20:CheckDisplay(var2_20)

	setActive(var3_20, var6_20)

	if var6_20 then
		local var7_20 = var2_20:IsAlive()
		local var8_20 = var2_20:IsAvatar()

		if arg0_20.isInit and arg1_20 == WorldMap.EventUpdateMapBuff then
			arg0_20:UpdateMapBuff(var4_20, var2_20:GetRadiationBuffs(), var0_20:GetBuffList(WorldMap.FactionEnemy, var2_20))
		end

		if not arg0_20.isInit then
			arg0_20.isInit = true

			local var9_20 = var2_20:GetReplaceDisplayEnemyConfig()
			local var10_20 = var4_20:Find("char")
			local var11_20 = var4_20:Find("icon")

			setActive(var10_20, var8_20)
			setActive(var11_20, not var8_20)

			if var8_20 then
				arg0_20:LoadAvatar(var9_20.icon, var10_20:Find("ship"))
			else
				GetImageSpriteFromAtlasAsync("enemies/" .. var9_20.icon, "", var11_20:Find("pic"))

				local var12_20 = WorldConst.EnemySize[var9_20.type]

				setActive(var11_20:Find("size/bg_s"), var12_20 == 1 or not var12_20)
				setActive(var11_20:Find("size/bg_m"), var12_20 == 2)
				setActive(var11_20:Find("size/bg_h"), var12_20 == 3)
				setActive(var11_20:Find("size/bg_boss"), var12_20 == 99)

				if var9_20.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
					setActive(var11_20:Find("size/bg_boss"), false)
					setText(var11_20:Find("lv/Text"), WorldConst.WorldLevelCorrect(var0_20.config.expedition_level, var9_20.type))
				else
					setText(var11_20:Find("lv/Text"), var9_20.level)
				end

				GetImageSpriteFromAtlasAsync("enemies/" .. var9_20.icon .. "_d_blue", "", var5_20:Find("icon"))
			end

			arg0_20:UpdateHP(var4_20:Find("hp"), var2_20:GetHP(), var2_20:GetMaxHP())
			arg0_20:UpdateBuffList(var4_20, var2_20:GetBuffList())
			arg0_20:UpdateMapBuff(var4_20, var2_20:GetRadiationBuffs(), var0_20:GetBuffList(WorldMap.FactionEnemy, var2_20))
		end

		setActive(var4_20, var7_20)
		setActive(var5_20, false)
		setActive(var4_20:Find("fighting"), false)

		if arg1_20 == WorldMapAttachment.EventUpdateLurk and var1_20:GetInFOV() and not var2_20.lurk then
			setActive(var4_20:Find("effect_found"), true)

			arg0_20.lurkTimer = Timer.New(function()
				setActive(var4_20:Find("effect_found"), false)
			end, 3, 1)

			arg0_20.lurkTimer:Start()
		else
			setActive(var4_20:Find("effect_found"), false)
		end
	end
end

function var0_0.UpdateBox(arg0_22, arg1_22)
	local var0_22 = arg0_22.map
	local var1_22 = arg0_22.cell
	local var2_22 = arg0_22.attachment
	local var3_22 = arg0_22.transform
	local var4_22 = var0_22:CheckDisplay(var2_22)

	setActive(var3_22, var4_22)

	if var4_22 then
		local var5_22 = var2_22:IsAvatar()

		if not arg0_22.isInit then
			arg0_22.isInit = true

			local var6_22 = var2_22.config
			local var7_22 = var3_22:Find("char")
			local var8_22 = var3_22:Find("icon")

			setActive(var7_22, var5_22)
			setActive(var8_22, not var5_22)
			setAnchoredPosition(var7_22, var0_0.CharBasePos)
			setAnchoredPosition(var8_22, var0_0.IconBasePos)

			if var5_22 then
				arg0_22:LoadAvatar(var6_22.icon, var7_22:Find("ship"))
			else
				arg0_22:LoadBoxPrefab(var6_22.icon, var8_22)
			end

			arg0_22:UpdateBuffList(var3_22, {})
			arg0_22:UpdateMapBuff(var3_22, {}, {})
		end
	end
end

function var0_0.UpdateEnemy(arg0_23, arg1_23)
	local var0_23 = arg0_23.map
	local var1_23 = arg0_23.cell
	local var2_23 = arg0_23.attachment
	local var3_23 = arg0_23.transform
	local var4_23 = var3_23:Find("live")
	local var5_23 = var3_23:Find("dead")
	local var6_23 = var0_23:CheckDisplay(var2_23)

	setActive(var3_23, var6_23)

	if var6_23 then
		local var7_23 = var2_23:IsAlive()
		local var8_23 = var2_23:IsAvatar()

		if arg0_23.isInit and arg1_23 == WorldMap.EventUpdateMapBuff then
			arg0_23:UpdateMapBuff(var4_23, var2_23:GetRadiationBuffs(), var0_23:GetBuffList(WorldMap.FactionEnemy, var2_23))
		end

		if not arg0_23.isInit then
			arg0_23.isInit = true

			local var9_23 = var2_23.config
			local var10_23 = var4_23:Find("char")
			local var11_23 = var4_23:Find("icon")

			setActive(var10_23, var8_23)
			setActive(var11_23, not var8_23)

			if var8_23 then
				arg0_23:LoadAvatar(var9_23.icon, var10_23:Find("ship"))
			else
				GetImageSpriteFromAtlasAsync("enemies/" .. var9_23.icon, "", var11_23:Find("pic"))

				local var12_23 = WorldConst.EnemySize[var9_23.type]

				setActive(var11_23:Find("size/bg_s"), var12_23 == 1 or not var12_23)
				setActive(var11_23:Find("size/bg_m"), var12_23 == 2)
				setActive(var11_23:Find("size/bg_h"), var12_23 == 3)
				setActive(var11_23:Find("size/bg_boss"), var12_23 == 99)

				if var9_23.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
					setActive(var11_23:Find("size/bg_boss"), false)
					setText(var11_23:Find("lv/Text"), WorldConst.WorldLevelCorrect(var0_23.config.expedition_level, var9_23.type))
				else
					setText(var11_23:Find("lv/Text"), var9_23.level)
				end

				GetImageSpriteFromAtlasAsync("enemies/" .. var9_23.icon .. "_d_blue", "", var5_23:Find("icon"))
			end

			arg0_23:UpdateHP(var4_23:Find("hp"), var2_23:GetHP(), var2_23:GetMaxHP())
			arg0_23:UpdateBuffList(var4_23, var2_23:GetBuffList())
			arg0_23:UpdateMapBuff(var4_23, var2_23:GetRadiationBuffs(), var0_23:GetBuffList(WorldMap.FactionEnemy, var2_23))
		end

		setActive(var4_23, var7_23)
		setActive(var5_23, not var8_23 and var2_23.flag == 1)

		if var7_23 then
			setActive(var4_23:Find("fighting"), arg0_23.isFighting)
		end
	end
end

function var0_0.UpdatePort(arg0_24, arg1_24)
	setActive(arg0_24.transform, false)
end

function var0_0.UpdateTransportFleet(arg0_25, arg1_25)
	local var0_25 = arg0_25.map
	local var1_25 = arg0_25.cell
	local var2_25 = arg0_25.attachment
	local var3_25 = arg0_25.transform
	local var4_25 = var0_25:CheckDisplay(var2_25)

	setActive(var3_25, var4_25)

	if var4_25 and not arg0_25.isInit then
		arg0_25.isInit = true

		local var5_25 = var2_25.config
		local var6_25 = var3_25:Find("ship/icon")

		GetImageSpriteFromAtlasAsync("enemies/" .. var5_25.icon, "", var6_25)
	end
end

function var0_0.UpdateTrap(arg0_26, arg1_26)
	local var0_26 = arg0_26.map
	local var1_26 = arg0_26.cell
	local var2_26 = arg0_26.attachment
	local var3_26 = arg0_26.transform
	local var4_26 = var0_26:CheckDisplay(var2_26)

	setActive(var3_26, var4_26)

	if var4_26 then
		local var5_26 = var2_26:IsAvatar()

		if not arg0_26.isInit then
			arg0_26.isInit = true

			local var6_26 = var2_26.config
			local var7_26 = var3_26:Find("char")
			local var8_26 = var3_26:Find("icon")

			setActive(var7_26, var5_26)
			setActive(var8_26, not var5_26)
			setAnchoredPosition(var7_26, var0_0.CharBasePos)
			setAnchoredPosition(var8_26, var0_0.IconBasePos)

			if var5_26 then
				arg0_26:LoadAvatar(var6_26.trap_fx, var7_26:Find("ship"))
			else
				arg0_26:LoadBoxPrefab(var6_26.trap_fx, var8_26)
			end

			arg0_26:UpdateBuffList(var3_26, {})
			arg0_26:UpdateMapBuff(var3_26, {}, {})
		end
	end
end

function var0_0.UpdateBuffList(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg1_27:Find("buffs")

	setActive(var0_27, #arg2_27 > 0)

	local var1_27 = UIItemList.New(var0_27, var0_27:GetChild(0))

	var1_27:make(function(arg0_28, arg1_28, arg2_28)
		arg1_28 = arg1_28 + 1

		if arg0_28 == UIItemList.EventUpdate then
			local var0_28 = arg2_27[arg1_28]

			GetImageSpriteFromAtlasAsync("world/buff/" .. var0_28.config.icon, "", arg2_28)
		end
	end)
	var1_27:align(#arg2_27)
	setAnchoredPosition(var0_27, {
		y = arg0_27.modelType == WorldConst.ModelSpine and 100 or 0
	})
end

function var0_0.UpdateMapBuff(arg0_29, arg1_29, arg2_29, arg3_29)
	local var0_29 = arg1_29:Find("map_buff")
	local var1_29 = false

	if #arg2_29 > 0 then
		var1_29 = "wifi"

		local var2_29, var3_29, var4_29 = unpack(arg2_29[1])

		GetImageSpriteFromAtlasAsync("world/mapbuff/" .. pg.world_SLGbuff_data[var3_29].icon, "", var0_29:Find("Image"))
	elseif #arg3_29 > 0 then
		var1_29 = "arrow"

		local var5_29 = arg3_29[1]

		GetImageSpriteFromAtlasAsync("world/mapbuff/" .. var5_29.config.icon, "", var0_29:Find("Image"))
	end

	setActive(var0_29:Find("wifi"), var1_29 == "wifi")
	setActive(var0_29:Find("arrow"), var1_29 == "arrow")
	setActive(var0_29, var1_29)
end

function var0_0.UpdateHP(arg0_30, arg1_30, arg2_30, arg3_30)
	setActive(arg1_30, arg2_30 and arg3_30)

	if arg2_30 and arg3_30 then
		setSlider(arg1_30, 0, arg3_30, arg2_30)
	end
end

function var0_0.UpdateBreathTween(arg0_31)
	local var0_31 = arg0_31.attachment

	if var0_31:IsFloating() and var0_31:IsAlive() and var0_31:IsVisible() then
		if not arg0_31.twBreathId then
			arg0_31.transform.localPosition = Vector3(0, 40, 0)

			local var1_31 = LeanTween.moveY(arg0_31.transform, 50, 1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

			var1_31.passed = arg0_31.twTimer.passed
			var1_31.direction = arg0_31.twTimer.direction
			arg0_31.twBreathId = var1_31.uniqueId
		end
	elseif arg0_31.twBreathId then
		LeanTween.cancel(arg0_31.twBreathId)

		arg0_31.twBreathId = nil
		arg0_31.transform.localPosition = Vector3(0, 40, 0)
	end
end

function var0_0.UpdateIsFighting(arg0_32, arg1_32)
	assert(WorldMapAttachment.IsEnemyType(arg0_32.attachment.type))

	if arg0_32.isFighting ~= arg1_32 then
		arg0_32.isFighting = arg1_32

		arg0_32:UpdateEnemy()
	end
end

function var0_0.TrapAnimDisplay(arg0_33, arg1_33)
	local var0_33 = {}
	local var1_33 = arg0_33.model:GetChild(0)

	table.insert(var0_33, function(arg0_34)
		var1_33:GetComponent("DftAniEvent"):SetEndEvent(arg0_34)
		var1_33:GetComponent("Animator"):Play("disappear")
	end)
	table.insert(var0_33, function(arg0_35)
		local var0_35 = arg0_33.attachment:GetScale(arg0_33.attachment.config.trap_range[1])

		arg0_33:UpdateModelScale(var0_35)
		var1_33:GetComponent("DftAniEvent"):SetEndEvent(arg0_35)
		var1_33:GetComponent("Animator"):Play("vortexAnimation")
	end)
	table.insert(var0_33, function(arg0_36)
		arg0_33:UpdateModelScale(Vector3.zero)
		var1_33:GetComponent("Animator"):Play("loop")
		arg0_36()
	end)
	seriesAsync(var0_33, arg1_33)
end

return var0_0
