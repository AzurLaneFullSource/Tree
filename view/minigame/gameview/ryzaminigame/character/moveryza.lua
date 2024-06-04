local var0 = class("MoveEnemy", import("view.miniGame.gameView.RyzaMiniGame.character.TargetMove"))

function var0.InitUI(arg0, arg1)
	arg0.hp = arg1.hp or 3
	arg0.bomb = arg1.bomb or 4
	arg0.bombCount = arg0.bomb
	arg0.power = arg1.power or 4
	arg0.speed = arg1.speed or 4

	arg0:UpdateSpirit(defaultValue(arg1.spirit, true))

	arg0.neglectTime = 0
	arg0.invincibilityTime = 0

	arg0:PlayIdle()
	arg0.rtScale:Find("main/spirit"):GetComponent(typeof(Image)).material:SetInt("_Overwrite", 0)

	local var0 = arg0.rtScale:Find("main/character"):GetComponent(typeof(DftAniEvent))

	var0:SetTriggerEvent(function()
		switch(arg0.status, {
			Burn_S = function()
				if arg0.spriteVanish then
					arg0.spriteVanish = false

					setActive(arg0.rtScale:Find("front/EF_Vanish"), true)
				end
			end
		})
	end)
	var0:SetEndEvent(function()
		arg0.lock = false

		if arg0.hp <= 0 then
			arg0.responder:GameFinish(false)
		end
	end)
	eachChild(arg0.rtScale:Find("front"), function(arg0)
		arg0:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setActive(arg0, false)
		end)
	end)
	arg0.rtScale:Find("front/EF_Summon"):GetComponent(typeof(DftAniEvent)):SetTriggerEvent(function()
		arg0.summonCount = defaultValue(arg0.summonCount, 0) + 1

		local var0 = arg0.rtScale:Find("main/spirit")

		switch(arg0.summonCount, {
			function()
				GetOrAddComponent(var0, typeof(CanvasGroup)).alpha = 0
			end,
			function()
				GetOrAddComponent(var0, typeof(CanvasGroup)).alpha = 1

				var0:GetComponent(typeof(Image)).material:SetInt("_Overwrite", 1)
			end,
			function()
				var0:GetComponent(typeof(Image)).material:SetInt("_Overwrite", 0)
			end
		})

		arg0.summonCount = arg0.summonCount % 3
	end)
end

function var0.InitRegister(arg0, arg1)
	arg0:Register("feedback", function()
		arg0.bombCount = math.min(arg0.bombCount + 1, arg0.bomb)
	end, {})
	arg0:Register("burn", function()
		if arg0.invincibilityTime > 0 then
			return
		end

		arg0:Hurt(1)

		if arg0.hp > 0 then
			arg0:PlayAnim("Burn_S")
		else
			arg0:DeregisterAll()
			arg0:PlayAnim("Gameover_B")
		end
	end, {
		{
			0,
			0
		}
	})
	arg0:Register("hit", function(arg0, arg1)
		if arg0.invincibilityTime > 0 then
			return
		end

		arg0:Hurt(arg0)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-ryza-minigame-damage")

		local var0 = arg1 - arg0.realPos
		local var1 = var0 * (1 / math.sqrt(var0:SqrMagnitude()))

		setAnchoredPosition(arg0.rtScale:Find("front/EF_Hit"), NewPos(var1.x, -var1.y) * 16)
		setActive(arg0.rtScale:Find("front/EF_Hit"), true)

		if arg0.hp > 0 then
			local var2 = RyzaMiniGameConfig.GetFourDirMark(var1)

			arg0:PlayAnim("Damage_" .. (var2 == "" and "S" or var2))
			arg0:PlayDamage()
		else
			arg0:DeregisterAll()
			arg0:PlayAnim("Gameover_A")
		end
	end, {})
end

function var0.Hurt(arg0, arg1)
	if arg0.spirit then
		arg0.spriteVanish = true

		arg0:UpdateSpirit(false)
	else
		arg0.hp = arg0.hp - arg1

		arg0.responder:SyncStatus(arg0, "hp", {
			num = arg0.hp,
			delta = -arg1
		})
	end

	arg0.invincibilityTime = 3
end

function var0.AddItem(arg0, arg1)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-ryza-minigame-powerup")
	switch(arg1, {
		bomb = function()
			arg0.bomb = math.min(arg0.bomb + 1, 7)
			arg0.bombCount = arg0.bombCount + 1

			arg0.responder:SyncStatus(arg0, "bomb", {
				num = arg0.bomb
			})
		end,
		power = function()
			arg0.power = math.min(arg0.power + 1, 7)

			arg0.responder:SyncStatus(arg0, "power", {
				num = arg0.power
			})
		end,
		speed = function()
			arg0.speed = math.min(arg0.speed + 1, 7)

			arg0.responder:SyncStatus(arg0, "speed", {
				num = arg0.speed
			})
		end,
		hp1 = function()
			arg0.hp = math.min(arg0.hp + 1, 3)

			arg0.responder:SyncStatus(arg0, "hp", {
				delta = 1,
				num = arg0.hp
			})
		end,
		hp2 = function()
			arg0.hp = math.min(arg0.hp + 2, 3)

			arg0.responder:SyncStatus(arg0, "hp", {
				delta = 2,
				num = arg0.hp
			})
		end,
		spirit = function()
			if not arg0.spirit then
				arg0:UpdateSpirit(true)
				setActive(arg0.rtScale:Find("front/EF_Summon"), true)
			end
		end
	})
end

function var0.UpdateSpirit(arg0, arg1)
	arg0.spirit = arg1

	local var0 = arg0.spirit and "spirit" or "character"

	eachChild(arg0.rtScale:Find("main"), function(arg0)
		setActive(arg0, arg0.name == var0)
		arg0:GetComponent(typeof(Image)).material:SetInt("_Overwrite", 0)
	end)

	arg0.mainTarget = arg0.rtScale:Find("main/" .. var0)
end

function var0.SetBomb(arg0)
	if not arg0.lock and arg0.bombCount > 0 and arg0.responder:GetCellCanBomb(arg0.pos) then
		arg0.bombCount = arg0.bombCount - 1

		arg0.responder:Create({
			name = "Bomb",
			pos = {
				arg0.pos.x,
				arg0.pos.y
			},
			power = arg0.power
		})
		pg.CriMgr.GetInstance():PlaySoundEffect_V3("ui-ryza-minigame-boom set")
	end
end

function var0.GetSpeed(arg0)
	return arg0.spirit and 7 or arg0.speed
end

local var1 = {
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
local var2 = 0.15

function var0.TimeUpdate(arg0, arg1)
	arg0.invincibilityTime = arg0.invincibilityTime - arg1

	if not arg0.lock then
		if arg0.invincibilityTime > 0 then
			arg0.rtScale:Find("main/character"):GetComponent(typeof(Image)).material:SetInt("_Overwrite", math.floor(arg0.invincibilityTime / var2) % 2)
		end

		local var0, var1 = arg0:GetMoveInfo()
		local var2 = RyzaMiniGameConfig.GetEightDirMark(var1)

		if var2 == "" then
			if arg0.spirit then
				arg0.neglectTime = 0

				arg0:PlayIdle()
			elseif arg0.neglectTime < 5 then
				arg0.neglectTime = arg0.neglectTime + arg1

				arg0:PlayIdle()
			else
				arg0:PlayNeglect(arg1)
			end
		else
			arg0.neglectTime = 0

			if arg0:GetSpeed() < 7 then
				arg0:PlayAnim("Trot_" .. var2)
			else
				arg0:PlayAnim("Run_" .. var2)
			end
		end

		local var3 = arg0:MoveDelta(var1, arg0:GetSpeedDis() * arg1)

		arg0:MoveUpdate(var3)

		if #var2 == 1 and var1[var2][1] * var3.x + var1[var2][2] * var3.y == 0 then
			arg0:Calling("touch", {
				arg0
			}, {
				var1[var2]
			})
		end
	end
end

function var0.GetMoveInfo(arg0)
	return nil, arg0.responder:GetJoyStick()
end

function var0.PlayNeglect(arg0, arg1)
	arg0.flowCount = defaultValue(arg0.flowCount, 0) + arg1

	if arg0.flowCount < 0.2 then
		return
	else
		arg0.flowCount = 0
	end

	switch(arg0.status, {
		Idle_N = function()
			arg0:PlayAnim("Idle_NE")
		end,
		Idle_NE = function()
			arg0:PlayAnim("Idle_E")
		end,
		Idle_E = function()
			arg0:PlayAnim("Idle_SE")
		end,
		Idle_SE = function()
			arg0:PlayAnim("Idle_S")
		end,
		Idle_NW = function()
			arg0:PlayAnim("Idle_W")
		end,
		Idle_W = function()
			arg0:PlayAnim("Idle_SW")
		end,
		Idle_SW = function()
			arg0:PlayAnim("Idle_S")
		end,
		Idle_S = function()
			arg0:PlayAnim("Neglect")
		end,
		Neglect = function()
			return
		end
	})
end

function var0.PlayIdle(arg0)
	arg0:PlayAnim("Idle_" .. (string.split(arg0.status, "_")[2] or "S"))
end

function var0.PlayDamage(arg0)
	arg0:PlayAnim("Damage_" .. (string.split(arg0.status, "_")[2] or "S"))
end

var0.loopDic = {
	Trot = true,
	Neglect = true,
	Idle = true,
	Run = true
}

function var0.UpdatePosition(arg0)
	var0.super.UpdatePosition(arg0)
	arg0.responder:WindowFocrus(arg0._tf.localPosition)
end

function var0.SetHide(arg0, arg1)
	var0.super.SetHide(arg0, arg1)

	GetOrAddComponent(arg0._tf, typeof(CanvasGroup)).alpha = arg1 and 0.7 or 1
end

return var0
