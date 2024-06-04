local var0 = class("OreAkashiControl")

var0.STATUS_NULL = 0
var0.STATUS_WOOD_BOX = 1
var0.STATUS_IRON_BOX = 2
var0.STATUS_CART = 3
var0.HIT_DELTA = 15
var0.HIT_MOVE_TIME = 0.5

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0.binder = arg1
	arg0._tf = arg2
	arg0.collisionMgr = arg3

	arg0:Init()
end

function var0.Init(arg0)
	arg0.uiMgr = pg.UIMgr.GetInstance()

	arg0.collisionMgr:SetAkashiObject(arg0)

	arg0.oreTpl = arg0._tf:Find("oreTpl")

	arg0:AddListener()
	arg0:AddDftAniEvent()
	arg0:Reset()

	arg0.aabbTF = arg0._tf:Find("aabb")

	setActive(arg0.aabbTF, OreGameConfig.SHOW_AABB)

	arg0.aabb = OreGameHelper.GetAABBWithTF(arg0.aabbTF)
end

function var0.AddListener(arg0)
	arg0.binder:bind(OreGameConfig.EVENT_DO_CARRY, function(arg0, arg1)
		arg0.weight = arg0.weight + arg1.weight
		arg0.point = arg0.point + arg1.point

		arg0:CheckStatus()
		arg0:AddOre(arg1.type)
	end)
	arg0.binder:bind(OreGameConfig.EVENT_AKASHI_HIT, function(arg0, arg1)
		if arg0.invincible then
			return
		end

		arg0:PlayHitAnim(arg1.dir, arg1.class, arg1.y)
	end)
end

function var0.AddDftAniEvent(arg0)
	eachChild(arg0._tf:Find("main"), function(arg0)
		arg0:Find("main/Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			if arg0.isDeliver then
				arg0:ResetData()
			else
				arg0:ResetData()
				arg0.mainTF:Find("main/Image"):GetComponent(typeof(Animator)):Play("Idle_S_Sad")

				arg0.mainAnimName = "Idle_S_Sad"
			end
		end)
	end)
	eachChild(arg0._tf:Find("effect"), function(arg0)
		arg0:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setActive(arg0, false)
		end)
	end)
end

function var0.Reset(arg0)
	setAnchoredPosition(arg0._tf, Vector2(0, -100))

	arg0.invincible = nil

	arg0:ResetData()
	arg0.mainTF:Find("main/Image"):GetComponent(typeof(Animator)):Play("Idle_S_0")
end

function var0.ResetData(arg0)
	arg0.mainAnimName, arg0.toolAnimName, arg0.oreAnimName = "", "", ""

	arg0:SetAnimDir("S")

	arg0.weight = 0
	arg0.point = 0
	arg0.isDeliver = false
	arg0.playHitAnim = nil

	arg0:ResetStatus()
end

function var0.ResetStatus(arg0)
	arg0:SetStatus(var0.STATUS_NULL)

	arg0.oreList = {}

	eachChild(arg0._tf:Find("main"), function(arg0)
		for iter0 = 1, 3 do
			local var0 = arg0:Find("ore/Image/" .. iter0 .. "/oreTF")

			removeAllChildren(var0)
		end
	end)
end

local var1 = {
	S = {
		EF_Get = {
			Vector2(0, 0),
			Vector2(-1, 0),
			Vector2(0, -11)
		},
		EF_Upgrade = {
			Vector2(0, -5),
			Vector2(0, -4)
		}
	},
	E = {
		EF_Get = {
			Vector2(13, 3),
			Vector2(14.8, 4.4),
			Vector2(-23, 4)
		},
		EF_Upgrade = {
			Vector2(13, 0),
			Vector2(18, 2.7)
		}
	},
	W = {
		EF_Get = {
			Vector2(-16, 3.5),
			Vector2(-16, 5),
			Vector2(-24, 4)
		},
		EF_Upgrade = {
			Vector2(-18, 2),
			Vector2(-22, 2)
		}
	}
}

function var0.PlayEffect(arg0, arg1)
	local var0 = arg0.animDir

	if var0 == "N" then
		return
	end

	local var1 = arg0._tf:Find("effect/" .. arg1)
	local var2 = arg0.status

	if arg1 == "EF_Upgrade" then
		var2 = arg0.status == var0.STATUS_IRON_BOX and 2 or 1
	end

	local var3 = var1[var0][arg1][var2]

	setAnchoredPosition(var1, var3)
	setActive(var1, true)
end

function var0.AddOre(arg0, arg1)
	if arg0.status == var0.STATUS_WOOD_BOX and #arg0.oreList >= 6 then
		return
	end

	if (arg0.status == var0.STATUS_IRON_BOX or arg0.status == var0.STATUS_CART) and #arg0.oreList >= 8 then
		return
	end

	table.insert(arg0.oreList, arg1)
	eachChild(arg0._tf:Find("main"), function(arg0)
		if arg0.name == "N" and arg0.status ~= var0.STATUS_CART then
			return
		end

		local var0 = arg0:Find("ore/Image/" .. arg0.status .. "/oreTF")
		local var1 = arg0:Find("ore/Image/" .. arg0.status .. "/pos/" .. "num_" .. #arg0.oreList)

		if var0.childCount < #arg0.oreList - 1 then
			for iter0, iter1 in ipairs(arg0.oreList) do
				local var2 = arg0.oreTpl:Find(iter1)
				local var3 = cloneTplTo(var2, var0, iter0)
			end
		else
			local var4 = arg0.oreTpl:Find(arg1)
			local var5 = cloneTplTo(var4, var0, #arg0.oreList)
		end

		eachChild(var1, function(arg0)
			setAnchoredPosition(var0:Find(arg0.name), arg0.anchoredPosition)
		end)
	end)
end

function var0.CheckStatus(arg0)
	local var0 = false

	if arg0.status == var0.STATUS_NULL then
		var0 = arg0.weight >= 0
	elseif arg0.status == var0.STATUS_WOOD_BOX then
		var0 = arg0.weight >= OreGameConfig.CAPACITY.WOOD_BOX
	elseif arg0.status == var0.STATUS_IRON_BOX then
		var0 = arg0.weight >= OreGameConfig.CAPACITY.IRON_BOX
	end

	if var0 then
		arg0:PlayEffect("EF_Upgrade")
		arg0:SetStatus(arg0.status + 1)
	else
		arg0:PlayEffect("EF_Get")
	end
end

function var0.SetStatus(arg0, arg1)
	arg0.status = arg1

	eachChild(arg0._tf:Find("main"), function(arg0)
		setActive(arg0:Find("tool"), arg0.status ~= var0.STATUS_NULL)
		setActive(arg0:Find("ore"), arg0.status ~= var0.STATUS_NULL)
		eachChild(arg0:Find("ore/Image"), function(arg0)
			setActive(arg0, arg0.status == tonumber(arg0.name))
		end)
	end)

	arg0.speed = OreGameConfig.SPEED[arg0.status]
end

function var0.SetAnimDir(arg0, arg1)
	arg0.animDir = arg1

	eachChild(arg0._tf:Find("main"), function(arg0)
		if arg0.name == arg0.animDir then
			setActive(arg0, true)

			arg0.mainTF = arg0
		else
			setActive(arg0, false)
		end
	end)
end

function var0.PlayHitAnim(arg0, arg1, arg2, arg3)
	arg0.invincible = 0

	setActive(arg0._tf:Find("effect/EF_Clash_" .. arg1), true)

	local var0 = ""
	local var1 = arg2 < 4 and "Light" or "Heavy"

	arg0.hitPos = {
		x = 0,
		y = 0
	}
	arg0.hitPos.x = arg1 == "W" and -var0.HIT_DELTA or var0.HIT_DELTA

	if arg3 <= arg0._tf.anchoredPosition.y then
		var0 = arg1 == "W" and "CW" or "CCW"
		arg0.hitPos.y = var0.HIT_DELTA
	else
		var0 = arg1 == "W" and "CCW" or "CW"
		arg0.hitPos.y = -var0.HIT_DELTA
	end

	arg0.hitTime = 0
	arg0.hitAnimName = "Stun_" .. var1 .. "_" .. var0

	arg0.mainTF:Find("main/Image"):GetComponent(typeof(Animator)):Play("Clash_" .. arg1)
	arg0.binder:emit(OreGameConfig.EVENT_PLAY_CONTAINER_HIT, {
		pos = arg0._tf.anchoredPosition,
		hitPos = arg0.hitPos,
		status = arg0.status,
		oreTF = arg0.mainTF:Find("ore/Image/" .. tostring(arg0.status))
	})
	arg0:ResetStatus()
end

function var0.PlayDeliver(arg0)
	arg0.isDeliver = true

	setActive(arg0.mainTF:Find("tool"), false)
	setActive(arg0.mainTF:Find("ore"), false)
	arg0.mainTF:Find("main/Image"):GetComponent(typeof(Animator)):Play("Deliver")
end

function var0.CheckDeliver(arg0)
	if arg0._tf.anchoredPosition.y < OreGameConfig.RANGE_Y[1] + 2 and arg0._tf.anchoredPosition.x > -100 and arg0._tf.anchoredPosition.x < 100 and arg0.animDir == "S" and arg0.weight > 0 then
		arg0:PlayDeliver()
		arg0.binder:emit(OreGameConfig.EVENT_DELIVER, {
			point = arg0.point,
			status = arg0.status,
			pos = arg0._tf.anchoredPosition,
			oreTF = arg0.mainTF:Find("ore/Image/" .. tostring(arg0.status))
		})
	end
end

function var0.OnTimer(arg0, arg1)
	if arg0.invincible then
		arg0.invincible = arg0.invincible + arg1

		if arg0.invincible >= OreGameConfig.INVINCIBLE_TIME then
			arg0.invincible = nil
		end
	end

	if arg0.hitTime then
		if arg1 * 5 < arg0.hitTime and arg0.hitTime <= arg1 * 6 then
			arg0.mainTF:Find("main/Image"):GetComponent(typeof(Animator)):Play(arg0.hitAnimName)

			arg0.playHitAnim = true
		elseif arg0.hitTime > arg1 * 6 then
			local var0 = {
				x = arg0._tf.anchoredPosition.x + arg0.hitPos.x * arg1 / var0.HIT_MOVE_TIME,
				y = arg0._tf.anchoredPosition.y + arg0.hitPos.y * arg1 / var0.HIT_MOVE_TIME
			}

			arg0:SetPosition(var0)
		end

		arg0.hitTime = arg0.hitTime + arg1

		if arg0.hitTime >= var0.HIT_MOVE_TIME then
			arg0.hitTime = nil
		end

		return
	end

	if not arg0.isDeliver and not arg0.playHitAnim then
		local var1 = Vector2(arg0.uiMgr.hrz, arg0.uiMgr.vtc)

		arg0:UpdateAnim(var1)
		arg0:UpdatePosition(var1)
		arg0:CheckDeliver()
	end
end

function var0.UpdateAnim(arg0, arg1)
	local var0 = OreGameHelper.GetFourDirLabel(arg1)
	local var1 = false

	if var0 == "STAND" then
		var0 = arg0.animDir
		var1 = true
	end

	arg0:SetAnimDir(var0)

	local var2 = ""
	local var3 = ""
	local var4 = ""

	if var1 then
		if arg0.mainAnimName ~= "Idle_S_Sad" then
			var2 = "Idle_" .. var0 .. "_" .. arg0.status

			if arg0.status ~= var0.STATUS_NULL then
				var3 = var2
				var4 = var2
			end
		else
			var2 = "Idle_S_Sad"
			var3 = "Idle_S_1"
			var4 = "Idle_S_1"
		end
	else
		var2 = "Move_" .. var0 .. "_" .. arg0.status

		if arg0.status ~= var0.STATUS_NULL then
			var3 = var2
			var4 = var2
		end
	end

	if var2 ~= "" and arg0.mainAnimName ~= var2 then
		arg0.mainTF:Find("main/Image"):GetComponent(typeof(Animator)):Play(var2)

		arg0.mainAnimName = var2
	end

	if arg0.status ~= var0.STATUS_NULL then
		if var4 ~= "" and var4 ~= arg0.toolAnimName then
			if string.find(var4, "N_1") or string.find(var4, "N_2") then
				arg0.mainTF:Find("tool/Image"):GetComponent(typeof(Image)).enabled = false
			else
				arg0.mainTF:Find("tool/Image"):GetComponent(typeof(Image)).enabled = true

				arg0.mainTF:Find("tool/Image"):GetComponent(typeof(Animator)):Play(var4)
			end

			arg0.toolAnimName = var4
		end

		if var3 ~= "" and var3 ~= arg0.oreAnimName then
			arg0.mainTF:Find("ore/Image"):GetComponent(typeof(Animator)):Play(var3)

			arg0.oreAnimName = var3

			local var5 = arg0.mainTF:Find("ore/Image/" .. arg0.status .. "/oreTF")

			if not var1 and var0.oreAnimOffset[arg0.status][arg0.animDir] then
				setAnchoredPosition(var5, var0.oreAnimOffset[arg0.status][arg0.animDir])
			else
				setAnchoredPosition(var5, Vector2(0, 0))
			end
		end
	end
end

var0.oreAnimOffset = {
	{
		S = Vector2(0, -2),
		W = Vector2(1, -2)
	},
	{
		S = Vector2(0, -2)
	},
	{
		W = Vector2(5, 0),
		E = Vector2(-3, 0)
	}
}

function var0.UpdatePosition(arg0, arg1)
	local var0 = OreGameHelper.GetEightDirVector(arg1) * OreGameConfig.TIME_INTERVAL * arg0.speed
	local var1 = {
		x = arg0._tf.anchoredPosition.x + var0.x,
		y = arg0._tf.anchoredPosition.y + var0.y
	}

	arg0:SetPosition(var1)
end

function var0.SetPosition(arg0, arg1)
	if OreGameHelper.CheckRemovable(arg1) then
		setAnchoredPosition(arg0._tf, arg1)

		arg0._tf:GetComponent(typeof(Canvas)).sortingOrder = -arg1.y + 320
	end
end

function var0.IsInvincible(arg0)
	return arg0.invincible
end

function var0.GetAnimDirLabel(arg0)
	return arg0.animDir
end

function var0.GetAABB(arg0)
	return arg0.aabb
end

function var0.GetCarryTriggerOffset(arg0)
	return {
		0,
		10
	}
end

function var0.GetCollisionInfo(arg0)
	return {
		pos = {
			x = arg0._tf.anchoredPosition.x + arg0.aabbTF.anchoredPosition.x,
			y = arg0._tf.anchoredPosition.y + arg0.aabbTF.anchoredPosition.y
		},
		aabb = arg0:GetAABB(),
		carryOffset = arg0:GetCarryTriggerOffset()
	}
end

return var0
