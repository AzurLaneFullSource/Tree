local var0_0 = class("MoveEnemy", import("view.miniGame.gameView.RyzaMiniGame.character.TargetMove"))

function var0_0.InitUI(arg0_1, arg1_1)
	arg0_1.hp = arg1_1.hp or 3
	arg0_1.bomb = arg1_1.bomb or 4
	arg0_1.bombCount = arg0_1.bomb
	arg0_1.power = arg1_1.power or 4
	arg0_1.speed = arg1_1.speed or 4

	arg0_1:UpdateSpirit(defaultValue(arg1_1.spirit, true))

	arg0_1.neglectTime = 0
	arg0_1.invincibilityTime = 0

	arg0_1:PlayIdle()
	arg0_1.rtScale:Find("main/spirit"):GetComponent(typeof(Image)).material:SetInt("_Overwrite", 0)

	local var0_1 = arg0_1.rtScale:Find("main/character"):GetComponent(typeof(DftAniEvent))

	var0_1:SetTriggerEvent(function()
		switch(arg0_1.status, {
			Burn_S = function()
				if arg0_1.spriteVanish then
					arg0_1.spriteVanish = false

					setActive(arg0_1.rtScale:Find("front/EF_Vanish"), true)
				end
			end
		})
	end)
	var0_1:SetEndEvent(function()
		arg0_1.lock = false

		if arg0_1.hp <= 0 then
			arg0_1.responder:GameFinish(false)
		end
	end)
	eachChild(arg0_1.rtScale:Find("front"), function(arg0_5)
		arg0_5:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setActive(arg0_5, false)
		end)
	end)
	arg0_1.rtScale:Find("front/EF_Summon"):GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function()
		arg0_1.summonCount = defaultValue(arg0_1.summonCount, 0) + 1

		local var0_7 = arg0_1.rtScale:Find("main/spirit")

		switch(arg0_1.summonCount, {
			function()
				GetOrAddComponent(var0_7, typeof(CanvasGroup)).alpha = 0
			end,
			function()
				GetOrAddComponent(var0_7, typeof(CanvasGroup)).alpha = 1

				var0_7:GetComponent(typeof(Image)).material:SetInt("_Overwrite", 1)
			end,
			function()
				var0_7:GetComponent(typeof(Image)).material:SetInt("_Overwrite", 0)
			end
		})

		arg0_1.summonCount = arg0_1.summonCount % 3
	end)
end

function var0_0.InitRegister(arg0_11, arg1_11)
	arg0_11:Register("feedback", function()
		arg0_11.bombCount = math.min(arg0_11.bombCount + 1, arg0_11.bomb)
	end, {})
	arg0_11:Register("burn", function()
		if arg0_11.invincibilityTime > 0 then
			return
		end

		arg0_11:Hurt(1)

		if arg0_11.hp > 0 then
			arg0_11:PlayAnim("Burn_S")
		else
			arg0_11:DeregisterAll()
			arg0_11:PlayAnim("Gameover_B")
		end
	end, {
		{
			0,
			0
		}
	})
	arg0_11:Register("hit", function(arg0_14, arg1_14)
		if arg0_11.invincibilityTime > 0 then
			return
		end

		arg0_11:Hurt(arg0_14)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-ryza-minigame-damage")

		local var0_14 = arg1_14 - arg0_11.realPos
		local var1_14 = var0_14 * (1 / math.sqrt(var0_14:SqrMagnitude()))

		setAnchoredPosition(arg0_11.rtScale:Find("front/EF_Hit"), NewPos(var1_14.x, -var1_14.y) * 16)
		setActive(arg0_11.rtScale:Find("front/EF_Hit"), true)

		if arg0_11.hp > 0 then
			local var2_14 = RyzaMiniGameConfig.GetFourDirMark(var1_14)

			arg0_11:PlayAnim("Damage_" .. (var2_14 == "" and "S" or var2_14))
			arg0_11:PlayDamage()
		else
			arg0_11:DeregisterAll()
			arg0_11:PlayAnim("Gameover_A")
		end
	end, {})
end

function var0_0.Hurt(arg0_15, arg1_15)
	if arg0_15.spirit then
		arg0_15.spriteVanish = true

		arg0_15:UpdateSpirit(false)
	else
		arg0_15.hp = arg0_15.hp - arg1_15

		arg0_15.responder:SyncStatus(arg0_15, "hp", {
			num = arg0_15.hp,
			delta = -arg1_15
		})
	end

	arg0_15.invincibilityTime = 3
end

function var0_0.AddItem(arg0_16, arg1_16)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-ryza-minigame-powerup")
	switch(arg1_16, {
		bomb = function()
			arg0_16.bomb = math.min(arg0_16.bomb + 1, 7)
			arg0_16.bombCount = arg0_16.bombCount + 1

			arg0_16.responder:SyncStatus(arg0_16, "bomb", {
				num = arg0_16.bomb
			})
		end,
		power = function()
			arg0_16.power = math.min(arg0_16.power + 1, 7)

			arg0_16.responder:SyncStatus(arg0_16, "power", {
				num = arg0_16.power
			})
		end,
		speed = function()
			arg0_16.speed = math.min(arg0_16.speed + 1, 7)

			arg0_16.responder:SyncStatus(arg0_16, "speed", {
				num = arg0_16.speed
			})
		end,
		hp1 = function()
			arg0_16.hp = math.min(arg0_16.hp + 1, 3)

			arg0_16.responder:SyncStatus(arg0_16, "hp", {
				delta = 1,
				num = arg0_16.hp
			})
		end,
		hp2 = function()
			arg0_16.hp = math.min(arg0_16.hp + 2, 3)

			arg0_16.responder:SyncStatus(arg0_16, "hp", {
				delta = 2,
				num = arg0_16.hp
			})
		end,
		spirit = function()
			if not arg0_16.spirit then
				arg0_16:UpdateSpirit(true)
				setActive(arg0_16.rtScale:Find("front/EF_Summon"), true)
			end
		end
	})
end

function var0_0.UpdateSpirit(arg0_23, arg1_23)
	arg0_23.spirit = arg1_23

	local var0_23 = arg0_23.spirit and "spirit" or "character"

	eachChild(arg0_23.rtScale:Find("main"), function(arg0_24)
		setActive(arg0_24, arg0_24.name == var0_23)
		arg0_24:GetComponent(typeof(Image)).material:SetInt("_Overwrite", 0)
	end)

	arg0_23.mainTarget = arg0_23.rtScale:Find("main/" .. var0_23)
end

function var0_0.SetBomb(arg0_25)
	if not arg0_25.lock and arg0_25.bombCount > 0 and arg0_25.responder:GetCellCanBomb(arg0_25.pos) then
		arg0_25.bombCount = arg0_25.bombCount - 1

		arg0_25.responder:Create({
			name = "Bomb",
			pos = {
				arg0_25.pos.x,
				arg0_25.pos.y
			},
			power = arg0_25.power
		})
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-ryza-minigame-boom set")
	end
end

function var0_0.GetSpeed(arg0_26)
	return arg0_26.spirit and 7 or arg0_26.speed
end

local var1_0 = {
	S = {
		0,
		1
	},
	E = {
		1,
		0
	},
	N = {
		0,
		-1
	},
	W = {
		-1,
		0
	}
}
local var2_0 = 0.15

function var0_0.TimeUpdate(arg0_27, arg1_27)
	arg0_27.invincibilityTime = arg0_27.invincibilityTime - arg1_27

	if not arg0_27.lock then
		if arg0_27.invincibilityTime > 0 then
			arg0_27.rtScale:Find("main/character"):GetComponent(typeof(Image)).material:SetInt("_Overwrite", math.floor(arg0_27.invincibilityTime / var2_0) % 2)
		end

		local var0_27, var1_27 = arg0_27:GetMoveInfo()
		local var2_27 = RyzaMiniGameConfig.GetEightDirMark(var1_27)

		if var2_27 == "" then
			if arg0_27.spirit then
				arg0_27.neglectTime = 0

				arg0_27:PlayIdle()
			elseif arg0_27.neglectTime < 5 then
				arg0_27.neglectTime = arg0_27.neglectTime + arg1_27

				arg0_27:PlayIdle()
			else
				arg0_27:PlayNeglect(arg1_27)
			end
		else
			arg0_27.neglectTime = 0

			if arg0_27:GetSpeed() < 7 then
				arg0_27:PlayAnim("Trot_" .. var2_27)
			else
				arg0_27:PlayAnim("Run_" .. var2_27)
			end
		end

		local var3_27 = arg0_27:MoveDelta(var1_27, arg0_27:GetSpeedDis() * arg1_27)

		arg0_27:MoveUpdate(var3_27)

		if #var2_27 == 1 and var1_0[var2_27][1] * var3_27.x + var1_0[var2_27][2] * var3_27.y == 0 then
			arg0_27:Calling("touch", {
				arg0_27
			}, {
				var1_0[var2_27]
			})
		end
	end
end

function var0_0.GetMoveInfo(arg0_28)
	return nil, arg0_28.responder:GetJoyStick()
end

function var0_0.PlayNeglect(arg0_29, arg1_29)
	arg0_29.flowCount = defaultValue(arg0_29.flowCount, 0) + arg1_29

	if arg0_29.flowCount < 0.2 then
		return
	else
		arg0_29.flowCount = 0
	end

	switch(arg0_29.status, {
		Idle_N = function()
			arg0_29:PlayAnim("Idle_NE")
		end,
		Idle_NE = function()
			arg0_29:PlayAnim("Idle_E")
		end,
		Idle_E = function()
			arg0_29:PlayAnim("Idle_SE")
		end,
		Idle_SE = function()
			arg0_29:PlayAnim("Idle_S")
		end,
		Idle_NW = function()
			arg0_29:PlayAnim("Idle_W")
		end,
		Idle_W = function()
			arg0_29:PlayAnim("Idle_SW")
		end,
		Idle_SW = function()
			arg0_29:PlayAnim("Idle_S")
		end,
		Idle_S = function()
			arg0_29:PlayAnim("Neglect")
		end,
		Neglect = function()
			return
		end
	})
end

function var0_0.PlayIdle(arg0_39)
	arg0_39:PlayAnim("Idle_" .. (string.split(arg0_39.status, "_")[2] or "S"))
end

function var0_0.PlayDamage(arg0_40)
	arg0_40:PlayAnim("Damage_" .. (string.split(arg0_40.status, "_")[2] or "S"))
end

var0_0.loopDic = {
	Trot = true,
	Neglect = true,
	Idle = true,
	Run = true
}

function var0_0.UpdatePosition(arg0_41)
	var0_0.super.UpdatePosition(arg0_41)
	arg0_41.responder:WindowFocrus(arg0_41._tf.localPosition)
end

function var0_0.SetHide(arg0_42, arg1_42)
	var0_0.super.SetHide(arg0_42, arg1_42)

	GetOrAddComponent(arg0_42._tf, typeof(CanvasGroup)).alpha = arg1_42 and 0.7 or 1
end

return var0_0
