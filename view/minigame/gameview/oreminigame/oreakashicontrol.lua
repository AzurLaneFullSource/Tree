local var0_0 = class("OreAkashiControl")

var0_0.STATUS_NULL = 0
var0_0.STATUS_WOOD_BOX = 1
var0_0.STATUS_IRON_BOX = 2
var0_0.STATUS_CART = 3
var0_0.HIT_DELTA = 15
var0_0.HIT_MOVE_TIME = 0.5

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.binder = arg1_1
	arg0_1._tf = arg2_1
	arg0_1.collisionMgr = arg3_1

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.uiMgr = pg.UIMgr.GetInstance()

	arg0_2.collisionMgr:SetAkashiObject(arg0_2)

	arg0_2.oreTpl = arg0_2._tf:Find("oreTpl")

	arg0_2:AddListener()
	arg0_2:AddDftAniEvent()
	arg0_2:Reset()

	arg0_2.aabbTF = arg0_2._tf:Find("aabb")

	setActive(arg0_2.aabbTF, OreGameConfig.SHOW_AABB)

	arg0_2.aabb = OreGameHelper.GetAABBWithTF(arg0_2.aabbTF)
end

function var0_0.AddListener(arg0_3)
	arg0_3.binder:bind(OreGameConfig.EVENT_DO_CARRY, function(arg0_4, arg1_4)
		arg0_3.weight = arg0_3.weight + arg1_4.weight
		arg0_3.point = arg0_3.point + arg1_4.point

		arg0_3:CheckStatus()
		arg0_3:AddOre(arg1_4.type)
	end)
	arg0_3.binder:bind(OreGameConfig.EVENT_AKASHI_HIT, function(arg0_5, arg1_5)
		if arg0_3.invincible then
			return
		end

		arg0_3:PlayHitAnim(arg1_5.dir, arg1_5.class, arg1_5.y)
	end)
end

function var0_0.AddDftAniEvent(arg0_6)
	eachChild(arg0_6._tf:Find("main"), function(arg0_7)
		arg0_7:Find("main/Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			if arg0_6.isDeliver then
				arg0_6:ResetData()
			else
				arg0_6:ResetData()
				arg0_6.mainTF:Find("main/Image"):GetComponent(typeof(Animator)):Play("Idle_S_Sad")

				arg0_6.mainAnimName = "Idle_S_Sad"
			end
		end)
	end)
	eachChild(arg0_6._tf:Find("effect"), function(arg0_9)
		arg0_9:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setActive(arg0_9, false)
		end)
	end)
end

function var0_0.Reset(arg0_11)
	setAnchoredPosition(arg0_11._tf, Vector2(0, -100))

	arg0_11.invincible = nil

	arg0_11:ResetData()
	arg0_11.mainTF:Find("main/Image"):GetComponent(typeof(Animator)):Play("Idle_S_0")
end

function var0_0.ResetData(arg0_12)
	arg0_12.mainAnimName, arg0_12.toolAnimName, arg0_12.oreAnimName = "", "", ""

	arg0_12:SetAnimDir("S")

	arg0_12.weight = 0
	arg0_12.point = 0
	arg0_12.isDeliver = false
	arg0_12.playHitAnim = nil

	arg0_12:ResetStatus()
end

function var0_0.ResetStatus(arg0_13)
	arg0_13:SetStatus(var0_0.STATUS_NULL)

	arg0_13.oreList = {}

	eachChild(arg0_13._tf:Find("main"), function(arg0_14)
		for iter0_14 = 1, 3 do
			local var0_14 = arg0_14:Find("ore/Image/" .. iter0_14 .. "/oreTF")

			removeAllChildren(var0_14)
		end
	end)
end

local var1_0 = {
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

function var0_0.PlayEffect(arg0_15, arg1_15)
	local var0_15 = arg0_15.animDir

	if var0_15 == "N" then
		return
	end

	local var1_15 = arg0_15._tf:Find("effect/" .. arg1_15)
	local var2_15 = arg0_15.status

	if arg1_15 == "EF_Upgrade" then
		var2_15 = arg0_15.status == var0_0.STATUS_IRON_BOX and 2 or 1
	end

	local var3_15 = var1_0[var0_15][arg1_15][var2_15]

	setAnchoredPosition(var1_15, var3_15)
	setActive(var1_15, true)
end

function var0_0.AddOre(arg0_16, arg1_16)
	if arg0_16.status == var0_0.STATUS_WOOD_BOX and #arg0_16.oreList >= 6 then
		return
	end

	if (arg0_16.status == var0_0.STATUS_IRON_BOX or arg0_16.status == var0_0.STATUS_CART) and #arg0_16.oreList >= 8 then
		return
	end

	table.insert(arg0_16.oreList, arg1_16)
	eachChild(arg0_16._tf:Find("main"), function(arg0_17)
		if arg0_17.name == "N" and arg0_16.status ~= var0_0.STATUS_CART then
			return
		end

		local var0_17 = arg0_17:Find("ore/Image/" .. arg0_16.status .. "/oreTF")
		local var1_17 = arg0_17:Find("ore/Image/" .. arg0_16.status .. "/pos/" .. "num_" .. #arg0_16.oreList)

		if var0_17.childCount < #arg0_16.oreList - 1 then
			for iter0_17, iter1_17 in ipairs(arg0_16.oreList) do
				local var2_17 = arg0_16.oreTpl:Find(iter1_17)
				local var3_17 = cloneTplTo(var2_17, var0_17, iter0_17)
			end
		else
			local var4_17 = arg0_16.oreTpl:Find(arg1_16)
			local var5_17 = cloneTplTo(var4_17, var0_17, #arg0_16.oreList)
		end

		eachChild(var1_17, function(arg0_18)
			setAnchoredPosition(var0_17:Find(arg0_18.name), arg0_18.anchoredPosition)
		end)
	end)
end

function var0_0.CheckStatus(arg0_19)
	local var0_19 = false

	if arg0_19.status == var0_0.STATUS_NULL then
		var0_19 = arg0_19.weight >= 0
	elseif arg0_19.status == var0_0.STATUS_WOOD_BOX then
		var0_19 = arg0_19.weight >= OreGameConfig.CAPACITY.WOOD_BOX
	elseif arg0_19.status == var0_0.STATUS_IRON_BOX then
		var0_19 = arg0_19.weight >= OreGameConfig.CAPACITY.IRON_BOX
	end

	if var0_19 then
		arg0_19:PlayEffect("EF_Upgrade")
		arg0_19:SetStatus(arg0_19.status + 1)
	else
		arg0_19:PlayEffect("EF_Get")
	end
end

function var0_0.SetStatus(arg0_20, arg1_20)
	arg0_20.status = arg1_20

	eachChild(arg0_20._tf:Find("main"), function(arg0_21)
		setActive(arg0_21:Find("tool"), arg0_20.status ~= var0_0.STATUS_NULL)
		setActive(arg0_21:Find("ore"), arg0_20.status ~= var0_0.STATUS_NULL)
		eachChild(arg0_21:Find("ore/Image"), function(arg0_22)
			setActive(arg0_22, arg0_20.status == tonumber(arg0_22.name))
		end)
	end)

	arg0_20.speed = OreGameConfig.SPEED[arg0_20.status]
end

function var0_0.SetAnimDir(arg0_23, arg1_23)
	arg0_23.animDir = arg1_23

	eachChild(arg0_23._tf:Find("main"), function(arg0_24)
		if arg0_24.name == arg0_23.animDir then
			setActive(arg0_24, true)

			arg0_23.mainTF = arg0_24
		else
			setActive(arg0_24, false)
		end
	end)
end

function var0_0.PlayHitAnim(arg0_25, arg1_25, arg2_25, arg3_25)
	arg0_25.invincible = 0

	setActive(arg0_25._tf:Find("effect/EF_Clash_" .. arg1_25), true)

	local var0_25 = ""
	local var1_25 = arg2_25 < 4 and "Light" or "Heavy"

	arg0_25.hitPos = {
		x = 0,
		y = 0
	}
	arg0_25.hitPos.x = arg1_25 == "W" and -var0_0.HIT_DELTA or var0_0.HIT_DELTA

	if arg3_25 <= arg0_25._tf.anchoredPosition.y then
		var0_25 = arg1_25 == "W" and "CW" or "CCW"
		arg0_25.hitPos.y = var0_0.HIT_DELTA
	else
		var0_25 = arg1_25 == "W" and "CCW" or "CW"
		arg0_25.hitPos.y = -var0_0.HIT_DELTA
	end

	arg0_25.hitTime = 0
	arg0_25.hitAnimName = "Stun_" .. var1_25 .. "_" .. var0_25

	arg0_25.mainTF:Find("main/Image"):GetComponent(typeof(Animator)):Play("Clash_" .. arg1_25)
	arg0_25.binder:emit(OreGameConfig.EVENT_PLAY_CONTAINER_HIT, {
		pos = arg0_25._tf.anchoredPosition,
		hitPos = arg0_25.hitPos,
		status = arg0_25.status,
		oreTF = arg0_25.mainTF:Find("ore/Image/" .. tostring(arg0_25.status))
	})
	arg0_25:ResetStatus()
end

function var0_0.PlayDeliver(arg0_26)
	arg0_26.isDeliver = true

	setActive(arg0_26.mainTF:Find("tool"), false)
	setActive(arg0_26.mainTF:Find("ore"), false)
	arg0_26.mainTF:Find("main/Image"):GetComponent(typeof(Animator)):Play("Deliver")
end

function var0_0.CheckDeliver(arg0_27)
	if arg0_27._tf.anchoredPosition.y < OreGameConfig.RANGE_Y[1] + 2 and arg0_27._tf.anchoredPosition.x > -100 and arg0_27._tf.anchoredPosition.x < 100 and arg0_27.animDir == "S" and arg0_27.weight > 0 then
		arg0_27:PlayDeliver()
		arg0_27.binder:emit(OreGameConfig.EVENT_DELIVER, {
			point = arg0_27.point,
			status = arg0_27.status,
			pos = arg0_27._tf.anchoredPosition,
			oreTF = arg0_27.mainTF:Find("ore/Image/" .. tostring(arg0_27.status))
		})
	end
end

function var0_0.OnTimer(arg0_28, arg1_28)
	if arg0_28.invincible then
		arg0_28.invincible = arg0_28.invincible + arg1_28

		if arg0_28.invincible >= OreGameConfig.INVINCIBLE_TIME then
			arg0_28.invincible = nil
		end
	end

	if arg0_28.hitTime then
		if arg1_28 * 5 < arg0_28.hitTime and arg0_28.hitTime <= arg1_28 * 6 then
			arg0_28.mainTF:Find("main/Image"):GetComponent(typeof(Animator)):Play(arg0_28.hitAnimName)

			arg0_28.playHitAnim = true
		elseif arg0_28.hitTime > arg1_28 * 6 then
			local var0_28 = {
				x = arg0_28._tf.anchoredPosition.x + arg0_28.hitPos.x * arg1_28 / var0_0.HIT_MOVE_TIME,
				y = arg0_28._tf.anchoredPosition.y + arg0_28.hitPos.y * arg1_28 / var0_0.HIT_MOVE_TIME
			}

			arg0_28:SetPosition(var0_28)
		end

		arg0_28.hitTime = arg0_28.hitTime + arg1_28

		if arg0_28.hitTime >= var0_0.HIT_MOVE_TIME then
			arg0_28.hitTime = nil
		end

		return
	end

	if not arg0_28.isDeliver and not arg0_28.playHitAnim then
		local var1_28 = Vector2(arg0_28.uiMgr.hrz, arg0_28.uiMgr.vtc)

		arg0_28:UpdateAnim(var1_28)
		arg0_28:UpdatePosition(var1_28)
		arg0_28:CheckDeliver()
	end
end

function var0_0.UpdateAnim(arg0_29, arg1_29)
	local var0_29 = OreGameHelper.GetFourDirLabel(arg1_29)
	local var1_29 = false

	if var0_29 == "STAND" then
		var0_29 = arg0_29.animDir
		var1_29 = true
	end

	arg0_29:SetAnimDir(var0_29)

	local var2_29 = ""
	local var3_29 = ""
	local var4_29 = ""

	if var1_29 then
		if arg0_29.mainAnimName ~= "Idle_S_Sad" then
			var2_29 = "Idle_" .. var0_29 .. "_" .. arg0_29.status

			if arg0_29.status ~= var0_0.STATUS_NULL then
				var3_29 = var2_29
				var4_29 = var2_29
			end
		else
			var2_29 = "Idle_S_Sad"
			var3_29 = "Idle_S_1"
			var4_29 = "Idle_S_1"
		end
	else
		var2_29 = "Move_" .. var0_29 .. "_" .. arg0_29.status

		if arg0_29.status ~= var0_0.STATUS_NULL then
			var3_29 = var2_29
			var4_29 = var2_29
		end
	end

	if var2_29 ~= "" and arg0_29.mainAnimName ~= var2_29 then
		arg0_29.mainTF:Find("main/Image"):GetComponent(typeof(Animator)):Play(var2_29)

		arg0_29.mainAnimName = var2_29
	end

	if arg0_29.status ~= var0_0.STATUS_NULL then
		if var4_29 ~= "" and var4_29 ~= arg0_29.toolAnimName then
			if string.find(var4_29, "N_1") or string.find(var4_29, "N_2") then
				arg0_29.mainTF:Find("tool/Image"):GetComponent(typeof(Image)).enabled = false
			else
				arg0_29.mainTF:Find("tool/Image"):GetComponent(typeof(Image)).enabled = true

				arg0_29.mainTF:Find("tool/Image"):GetComponent(typeof(Animator)):Play(var4_29)
			end

			arg0_29.toolAnimName = var4_29
		end

		if var3_29 ~= "" and var3_29 ~= arg0_29.oreAnimName then
			arg0_29.mainTF:Find("ore/Image"):GetComponent(typeof(Animator)):Play(var3_29)

			arg0_29.oreAnimName = var3_29

			local var5_29 = arg0_29.mainTF:Find("ore/Image/" .. arg0_29.status .. "/oreTF")

			if not var1_29 and var0_0.oreAnimOffset[arg0_29.status][arg0_29.animDir] then
				setAnchoredPosition(var5_29, var0_0.oreAnimOffset[arg0_29.status][arg0_29.animDir])
			else
				setAnchoredPosition(var5_29, Vector2(0, 0))
			end
		end
	end
end

var0_0.oreAnimOffset = {
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

function var0_0.UpdatePosition(arg0_30, arg1_30)
	local var0_30 = OreGameHelper.GetEightDirVector(arg1_30) * OreGameConfig.TIME_INTERVAL * arg0_30.speed
	local var1_30 = {
		x = arg0_30._tf.anchoredPosition.x + var0_30.x,
		y = arg0_30._tf.anchoredPosition.y + var0_30.y
	}

	arg0_30:SetPosition(var1_30)
end

function var0_0.SetPosition(arg0_31, arg1_31)
	if OreGameHelper.CheckRemovable(arg1_31) then
		setAnchoredPosition(arg0_31._tf, arg1_31)

		arg0_31._tf:GetComponent(typeof(Canvas)).sortingOrder = -arg1_31.y + 320
	end
end

function var0_0.IsInvincible(arg0_32)
	return arg0_32.invincible
end

function var0_0.GetAnimDirLabel(arg0_33)
	return arg0_33.animDir
end

function var0_0.GetAABB(arg0_34)
	return arg0_34.aabb
end

function var0_0.GetCarryTriggerOffset(arg0_35)
	return {
		0,
		10
	}
end

function var0_0.GetCollisionInfo(arg0_36)
	return {
		pos = {
			x = arg0_36._tf.anchoredPosition.x + arg0_36.aabbTF.anchoredPosition.x,
			y = arg0_36._tf.anchoredPosition.y + arg0_36.aabbTF.anchoredPosition.y
		},
		aabb = arg0_36:GetAABB(),
		carryOffset = arg0_36:GetCarryTriggerOffset()
	}
end

return var0_0
