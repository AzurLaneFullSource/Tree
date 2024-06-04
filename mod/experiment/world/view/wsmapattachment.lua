local var0 = class("WSMapAttachment", import(".WSMapTransform"))

var0.Fields = {
	cell = "table",
	lurkTimer = "table",
	map = "table",
	twTimer = "userdata",
	attachment = "table",
	isInit = "boolean",
	twBreathId = "number",
	isFighting = "boolean"
}
var0.Listeners = {
	onUpdate = "Update"
}
var0.CharBasePos = Vector2.zero
var0.IconBasePos = Vector2(0, 10)

function var0.GetResName(arg0)
	if arg0.type == WorldMapAttachment.TypeEvent then
		if arg0:GetReplaceDisplayEnemyConfig() then
			return "enemy_tpl"
		else
			return "event_tpl"
		end
	elseif arg0.type == WorldMapAttachment.TypeBox then
		return "event_tpl"
	elseif WorldMapAttachment.IsEnemyType(arg0.type) then
		return "enemy_tpl"
	elseif arg0.type == WorldMapAttachment.TypePort then
		return "blank_tpl"
	elseif arg0.type == WorldMapAttachment.TypeTransportFleet then
		return "transport_tpl"
	elseif arg0.type == WorldMapAttachment.TypeTrap then
		return "event_tpl"
	else
		assert(false, "invalid attachment type: " .. tostring(arg0.type))
	end
end

function var0.Setup(arg0, arg1, arg2, arg3)
	assert(arg0.worldMapAttachment == nil)

	arg0.map = arg1
	arg0.cell = arg2

	arg0.cell:AddListener(WorldMapCell.EventUpdateInFov, arg0.onUpdate)
	arg0.cell:AddListener(WorldMap.EventUpdateMapBuff, arg0.onUpdate)

	arg0.attachment = arg3

	arg0:Init()
end

function var0.Dispose(arg0)
	arg0.cell:RemoveListener(WorldMapCell.EventUpdateInFov, arg0.onUpdate)
	arg0.cell:RemoveListener(WorldMap.EventUpdateMapBuff, arg0.onUpdate)

	if arg0.twBreathId then
		LeanTween.cancel(arg0.twBreathId)
	end

	if arg0.lurkTimer then
		arg0.lurkTimer:Stop()
	end

	arg0.transform.localEulerAngles = Vector3.zero

	var0.super.Dispose(arg0)
end

function var0.Init(arg0)
	arg0.transform.anchoredPosition3D = Vector3.zero
	arg0.transform.localEulerAngles = Vector3.zero
	arg0.transform.name = arg0.attachment:GetDebugName()

	arg0:SetModelOrder(arg0.attachment:GetModelOrder(), arg0.cell.row)
	arg0:Update()
end

function var0.LoadAvatar(arg0, arg1, arg2, arg3)
	local var0 = {}

	if arg1 and #arg1 > 0 then
		table.insert(var0, function(arg0)
			arg0:LoadModel(WorldConst.ModelSpine, arg1, nil, true, function()
				arg0.model:SetParent(arg2, false)
				arg0()
			end)
		end)
	end

	seriesAsync(var0, arg3)
end

function var0.LoadBoxPrefab(arg0, arg1, arg2, arg3)
	local var0 = {}

	if arg1 and #arg1 > 0 then
		table.insert(var0, function(arg0)
			arg0:LoadModel(WorldConst.ModelPrefab, WorldConst.ResBoxPrefab .. arg1, arg1, true, function()
				arg0.model:SetParent(arg2, false)
				arg0()
			end)
		end)
	end

	seriesAsync(var0, arg3)
end

function var0.LoadChapterPrefab(arg0, arg1, arg2, arg3)
	local var0 = {}

	if arg1 and #arg1 > 0 then
		table.insert(var0, function(arg0)
			arg0:LoadModel(WorldConst.ModelPrefab, WorldConst.ResChapterPrefab .. arg1, arg1, true, function()
				arg0.model:SetParent(arg2, false)
				arg0()
			end)
		end)
	end

	seriesAsync(var0, arg3)
end

function var0.Update(arg0, arg1)
	local var0 = arg0.attachment

	if var0.type == WorldMapAttachment.TypeEvent then
		if var0:GetReplaceDisplayEnemyConfig() then
			arg0:UpdateEventEnemy(arg1)
		else
			arg0:UpdateEvent(arg1)
		end
	elseif var0.type == WorldMapAttachment.TypeBox then
		arg0:UpdateBox(arg1)
	elseif var0.type == WorldMapAttachment.TypePort then
		arg0:UpdatePort(arg1)
	elseif WorldMapAttachment.IsEnemyType(var0.type) then
		arg0:UpdateEnemy(arg1)
	elseif var0.type == WorldMapAttachment.TypeTransportFleet then
		arg0:UpdateTransportFleet(arg1)
	elseif var0.type == WorldMapAttachment.TypeTrap then
		arg0:UpdateTrap(arg1)
	else
		assert(false, "invalid attachment type: " .. var0.type)
	end

	arg0:UpdateBreathTween()
	arg0:UpdateModelAngles(arg0.attachment:GetMillor() and Vector3(0, 180, 0) or Vector3.zero)
	arg0:UpdateModelScale(arg0.attachment:GetScale())
end

function var0.UpdateEvent(arg0, arg1)
	local var0 = arg0.map
	local var1 = arg0.cell
	local var2 = arg0.attachment
	local var3 = arg0.transform
	local var4 = var0:CheckDisplay(var2)

	setActive(var3, var4)

	if var4 then
		local var5 = var2:IsAvatar()

		if arg0.isInit and arg1 == WorldMap.EventUpdateMapBuff then
			arg0:UpdateMapBuff(var3, var2:GetRadiationBuffs(), var0:GetBuffList(WorldMap.FactionEnemy, var2))
		end

		if not arg0.isInit then
			arg0.isInit = true

			local var6 = var2.config
			local var7 = var3:Find("char")
			local var8 = var3:Find("icon")

			setActive(var7, var5)
			setActive(var8, not var5)

			if var5 then
				arg0:LoadAvatar(var6.icon, var7:Find("ship"), function()
					if #var6.icon > 0 then
						setAnchoredPosition(arg0.model, var2:GetDeviation())
					end
				end)
			elseif math.floor(var6.enemyicon / 2) == 2 then
				arg0:LoadChapterPrefab(var6.icon, var8, function()
					if #var6.icon > 0 then
						setAnchoredPosition(arg0.model, var2:GetDeviation())
					end
				end)
			elseif math.floor(var6.enemyicon / 2) == 0 then
				arg0:LoadBoxPrefab(var6.icon, var8, function()
					if #var6.icon > 0 then
						setAnchoredPosition(arg0.model, var2:GetDeviation())
					end
				end)
			else
				assert(false, "enemyicon error from id: " .. var2.id)
			end

			arg0:UpdateBuffList(var3, var2:GetBuffList())
			arg0:UpdateMapBuff(var3, var2:GetRadiationBuffs(), var0:GetBuffList(WorldMap.FactionEnemy, var2))
		end

		if arg1 == WorldMapAttachment.EventUpdateLurk and var1:GetInFOV() and not var2.lurk then
			setActive(var3:Find("effect_found"), true)

			arg0.lurkTimer = Timer.New(function()
				setActive(var3:Find("effect_found"), false)
			end, 3, 1)

			arg0.lurkTimer:Start()
		else
			setActive(var3:Find("effect_found"), false)
		end
	end
end

function var0.UpdateEventEnemy(arg0, arg1)
	local var0 = arg0.map
	local var1 = arg0.cell
	local var2 = arg0.attachment
	local var3 = arg0.transform
	local var4 = var3:Find("live")
	local var5 = var3:Find("dead")
	local var6 = var0:CheckDisplay(var2)

	setActive(var3, var6)

	if var6 then
		local var7 = var2:IsAlive()
		local var8 = var2:IsAvatar()

		if arg0.isInit and arg1 == WorldMap.EventUpdateMapBuff then
			arg0:UpdateMapBuff(var4, var2:GetRadiationBuffs(), var0:GetBuffList(WorldMap.FactionEnemy, var2))
		end

		if not arg0.isInit then
			arg0.isInit = true

			local var9 = var2:GetReplaceDisplayEnemyConfig()
			local var10 = var4:Find("char")
			local var11 = var4:Find("icon")

			setActive(var10, var8)
			setActive(var11, not var8)

			if var8 then
				arg0:LoadAvatar(var9.icon, var10:Find("ship"))
			else
				GetImageSpriteFromAtlasAsync("enemies/" .. var9.icon, "", var11:Find("pic"))

				local var12 = WorldConst.EnemySize[var9.type]

				setActive(var11:Find("size/bg_s"), var12 == 1 or not var12)
				setActive(var11:Find("size/bg_m"), var12 == 2)
				setActive(var11:Find("size/bg_h"), var12 == 3)
				setActive(var11:Find("size/bg_boss"), var12 == 99)

				if var9.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
					setActive(var11:Find("size/bg_boss"), false)
					setText(var11:Find("lv/Text"), WorldConst.WorldLevelCorrect(var0.config.expedition_level, var9.type))
				else
					setText(var11:Find("lv/Text"), var9.level)
				end

				GetImageSpriteFromAtlasAsync("enemies/" .. var9.icon .. "_d_blue", "", var5:Find("icon"))
			end

			arg0:UpdateHP(var4:Find("hp"), var2:GetHP(), var2:GetMaxHP())
			arg0:UpdateBuffList(var4, var2:GetBuffList())
			arg0:UpdateMapBuff(var4, var2:GetRadiationBuffs(), var0:GetBuffList(WorldMap.FactionEnemy, var2))
		end

		setActive(var4, var7)
		setActive(var5, false)
		setActive(var4:Find("fighting"), false)

		if arg1 == WorldMapAttachment.EventUpdateLurk and var1:GetInFOV() and not var2.lurk then
			setActive(var4:Find("effect_found"), true)

			arg0.lurkTimer = Timer.New(function()
				setActive(var4:Find("effect_found"), false)
			end, 3, 1)

			arg0.lurkTimer:Start()
		else
			setActive(var4:Find("effect_found"), false)
		end
	end
end

function var0.UpdateBox(arg0, arg1)
	local var0 = arg0.map
	local var1 = arg0.cell
	local var2 = arg0.attachment
	local var3 = arg0.transform
	local var4 = var0:CheckDisplay(var2)

	setActive(var3, var4)

	if var4 then
		local var5 = var2:IsAvatar()

		if not arg0.isInit then
			arg0.isInit = true

			local var6 = var2.config
			local var7 = var3:Find("char")
			local var8 = var3:Find("icon")

			setActive(var7, var5)
			setActive(var8, not var5)
			setAnchoredPosition(var7, var0.CharBasePos)
			setAnchoredPosition(var8, var0.IconBasePos)

			if var5 then
				arg0:LoadAvatar(var6.icon, var7:Find("ship"))
			else
				arg0:LoadBoxPrefab(var6.icon, var8)
			end

			arg0:UpdateBuffList(var3, {})
			arg0:UpdateMapBuff(var3, {}, {})
		end
	end
end

function var0.UpdateEnemy(arg0, arg1)
	local var0 = arg0.map
	local var1 = arg0.cell
	local var2 = arg0.attachment
	local var3 = arg0.transform
	local var4 = var3:Find("live")
	local var5 = var3:Find("dead")
	local var6 = var0:CheckDisplay(var2)

	setActive(var3, var6)

	if var6 then
		local var7 = var2:IsAlive()
		local var8 = var2:IsAvatar()

		if arg0.isInit and arg1 == WorldMap.EventUpdateMapBuff then
			arg0:UpdateMapBuff(var4, var2:GetRadiationBuffs(), var0:GetBuffList(WorldMap.FactionEnemy, var2))
		end

		if not arg0.isInit then
			arg0.isInit = true

			local var9 = var2.config
			local var10 = var4:Find("char")
			local var11 = var4:Find("icon")

			setActive(var10, var8)
			setActive(var11, not var8)

			if var8 then
				arg0:LoadAvatar(var9.icon, var10:Find("ship"))
			else
				GetImageSpriteFromAtlasAsync("enemies/" .. var9.icon, "", var11:Find("pic"))

				local var12 = WorldConst.EnemySize[var9.type]

				setActive(var11:Find("size/bg_s"), var12 == 1 or not var12)
				setActive(var11:Find("size/bg_m"), var12 == 2)
				setActive(var11:Find("size/bg_h"), var12 == 3)
				setActive(var11:Find("size/bg_boss"), var12 == 99)

				if var9.difficulty == ys.Battle.BattleConst.Difficulty.WORLD then
					setActive(var11:Find("size/bg_boss"), false)
					setText(var11:Find("lv/Text"), WorldConst.WorldLevelCorrect(var0.config.expedition_level, var9.type))
				else
					setText(var11:Find("lv/Text"), var9.level)
				end

				GetImageSpriteFromAtlasAsync("enemies/" .. var9.icon .. "_d_blue", "", var5:Find("icon"))
			end

			arg0:UpdateHP(var4:Find("hp"), var2:GetHP(), var2:GetMaxHP())
			arg0:UpdateBuffList(var4, var2:GetBuffList())
			arg0:UpdateMapBuff(var4, var2:GetRadiationBuffs(), var0:GetBuffList(WorldMap.FactionEnemy, var2))
		end

		setActive(var4, var7)
		setActive(var5, not var8 and var2.flag == 1)

		if var7 then
			setActive(var4:Find("fighting"), arg0.isFighting)
		end
	end
end

function var0.UpdatePort(arg0, arg1)
	setActive(arg0.transform, false)
end

function var0.UpdateTransportFleet(arg0, arg1)
	local var0 = arg0.map
	local var1 = arg0.cell
	local var2 = arg0.attachment
	local var3 = arg0.transform
	local var4 = var0:CheckDisplay(var2)

	setActive(var3, var4)

	if var4 and not arg0.isInit then
		arg0.isInit = true

		local var5 = var2.config
		local var6 = var3:Find("ship/icon")

		GetImageSpriteFromAtlasAsync("enemies/" .. var5.icon, "", var6)
	end
end

function var0.UpdateTrap(arg0, arg1)
	local var0 = arg0.map
	local var1 = arg0.cell
	local var2 = arg0.attachment
	local var3 = arg0.transform
	local var4 = var0:CheckDisplay(var2)

	setActive(var3, var4)

	if var4 then
		local var5 = var2:IsAvatar()

		if not arg0.isInit then
			arg0.isInit = true

			local var6 = var2.config
			local var7 = var3:Find("char")
			local var8 = var3:Find("icon")

			setActive(var7, var5)
			setActive(var8, not var5)
			setAnchoredPosition(var7, var0.CharBasePos)
			setAnchoredPosition(var8, var0.IconBasePos)

			if var5 then
				arg0:LoadAvatar(var6.trap_fx, var7:Find("ship"))
			else
				arg0:LoadBoxPrefab(var6.trap_fx, var8)
			end

			arg0:UpdateBuffList(var3, {})
			arg0:UpdateMapBuff(var3, {}, {})
		end
	end
end

function var0.UpdateBuffList(arg0, arg1, arg2)
	local var0 = arg1:Find("buffs")

	setActive(var0, #arg2 > 0)

	local var1 = UIItemList.New(var0, var0:GetChild(0))

	var1:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg2[arg1]

			GetImageSpriteFromAtlasAsync("world/buff/" .. var0.config.icon, "", arg2)
		end
	end)
	var1:align(#arg2)
	setAnchoredPosition(var0, {
		y = arg0.modelType == WorldConst.ModelSpine and 100 or 0
	})
end

function var0.UpdateMapBuff(arg0, arg1, arg2, arg3)
	local var0 = arg1:Find("map_buff")
	local var1 = false

	if #arg2 > 0 then
		var1 = "wifi"

		local var2, var3, var4 = unpack(arg2[1])

		GetImageSpriteFromAtlasAsync("world/mapbuff/" .. pg.world_SLGbuff_data[var3].icon, "", var0:Find("Image"))
	elseif #arg3 > 0 then
		var1 = "arrow"

		local var5 = arg3[1]

		GetImageSpriteFromAtlasAsync("world/mapbuff/" .. var5.config.icon, "", var0:Find("Image"))
	end

	setActive(var0:Find("wifi"), var1 == "wifi")
	setActive(var0:Find("arrow"), var1 == "arrow")
	setActive(var0, var1)
end

function var0.UpdateHP(arg0, arg1, arg2, arg3)
	setActive(arg1, arg2 and arg3)

	if arg2 and arg3 then
		setSlider(arg1, 0, arg3, arg2)
	end
end

function var0.UpdateBreathTween(arg0)
	local var0 = arg0.attachment

	if var0:IsFloating() and var0:IsAlive() and var0:IsVisible() then
		if not arg0.twBreathId then
			arg0.transform.localPosition = Vector3(0, 40, 0)

			local var1 = LeanTween.moveY(arg0.transform, 50, 1):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()

			var1.passed = arg0.twTimer.passed
			var1.direction = arg0.twTimer.direction
			arg0.twBreathId = var1.uniqueId
		end
	elseif arg0.twBreathId then
		LeanTween.cancel(arg0.twBreathId)

		arg0.twBreathId = nil
		arg0.transform.localPosition = Vector3(0, 40, 0)
	end
end

function var0.UpdateIsFighting(arg0, arg1)
	assert(WorldMapAttachment.IsEnemyType(arg0.attachment.type))

	if arg0.isFighting ~= arg1 then
		arg0.isFighting = arg1

		arg0:UpdateEnemy()
	end
end

function var0.TrapAnimDisplay(arg0, arg1)
	local var0 = {}
	local var1 = arg0.model:GetChild(0)

	table.insert(var0, function(arg0)
		var1:GetComponent("DftAniEvent"):SetEndEvent(arg0)
		var1:GetComponent("Animator"):Play("disappear")
	end)
	table.insert(var0, function(arg0)
		local var0 = arg0.attachment:GetScale(arg0.attachment.config.trap_range[1])

		arg0:UpdateModelScale(var0)
		var1:GetComponent("DftAniEvent"):SetEndEvent(arg0)
		var1:GetComponent("Animator"):Play("vortexAnimation")
	end)
	table.insert(var0, function(arg0)
		arg0:UpdateModelScale(Vector3.zero)
		var1:GetComponent("Animator"):Play("loop")
		arg0()
	end)
	seriesAsync(var0, arg1)
end

return var0
