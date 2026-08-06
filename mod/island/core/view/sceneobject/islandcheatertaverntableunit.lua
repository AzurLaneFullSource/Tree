local var0_0 = class("IslandCheaterTavernTableUnit", import(".IslandSceneUnit"))
local var1_0 = 180

function var0_0.OnAttach(arg0_1, arg1_1)
	var0_0.super.OnAttach(arg0_1, arg1_1)

	arg0_1.tf = tf(arg1_1)
	arg0_1.animator = arg0_1.tf:GetComponent(typeof(UnityEngine.Animator))

	bindComponent(arg0_1, arg1_1)

	arg0_1.decorationAnimator = arg0_1.decorationtf:GetComponent(typeof(UnityEngine.Animator))

	setActive(arg0_1.trunTalbeTip, false)
	setActive(arg0_1.boomShoot, false)
end

function var0_0.OnDetach(arg0_2)
	bindComponent(arg0_2, arg0_2.tf, true)
	var0_0.super.OnDetach(arg0_2)
end

function var0_0.OnFirstTakeShootTip(arg0_3, arg1_3)
	setActive(arg0_3.trunTalbeTip, true)
	arg0_3.animator:SetTrigger("open")
	arg0_3.decorationAnimator:SetTrigger("open")
	arg0_3:InitRotationBySeat(arg1_3)
	arg0_3:InitBombId({})
end

function var0_0.InitBombId(arg0_4, arg1_4)
	local function var0_4(arg0_5)
		for iter0_5, iter1_5 in ipairs(arg1_4) do
			if iter1_5 == arg0_5 then
				return true
			end
		end

		return false
	end

	for iter0_4 = 1, 6 do
		local var1_4 = var0_4(iter0_4)

		setActive(arg0_4["bombId" .. tostring(iter0_4)], var1_4)
	end
end

function var0_0.GetPrevIds(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = {}

	for iter0_6 = 1, arg3_6 do
		local var1_6 = (arg2_6 - iter0_6 - 1) % arg1_6 + 1

		var0_6[#var0_6 + 1] = var1_6
	end

	return var0_6
end

function var0_0.InitRotationBySeat(arg0_7, arg1_7)
	local var0_7 = IslandCheaterTavernConst.seatRotatonY[arg1_7] - 90

	arg0_7.tableRoot.transform.localEulerAngles = Vector3(0, var0_7, 0)
	arg0_7.centerRoot.localEulerAngles = Vector3(0, IslandCheaterTavernConst.seatRotatonY[arg1_7], 0)
end

function var0_0.OnShoot(arg0_8, arg1_8, arg2_8, arg3_8, arg4_8, arg5_8)
	if arg1_8 and arg4_8 == 1 then
		setActive(arg0_8.trunTalbeTip, false)

		arg0_8.firstTakeShoot = true
	else
		arg0_8.animator:SetTrigger("open")
		arg0_8.decorationAnimator:SetTrigger("open")

		arg0_8.shootOpenTime = 0

		arg0_8:InitRotationBySeat(arg2_8)

		local var0_8 = arg0_8:GetPrevIds(6, arg3_8, arg4_8 - 1)

		arg0_8:InitBombId(var0_8)
	end

	arg0_8.curBombId = arg3_8
	arg0_8.hasBombCount = arg4_8
	arg0_8.gotShoot = arg5_8

	if arg0_8.hasBombCount == 1 then
		arg0_8.rotateDuration = IslandCheaterTavernConst.firstTurnTime
		arg0_8.turntabletf.localEulerAngles = Vector3(0, 0, 0)
		arg0_8.endRotationY = -60 * (arg0_8.curBombId - 1)
		arg0_8.rotateTotalAngle = IslandCheaterTavernConst.turnCircleCount * 360 + arg0_8.endRotationY
		arg0_8.rotateStartEuler = arg0_8.turntabletf.localEulerAngles
	else
		local var1_8 = arg0_8.curBombId - 1

		var1_8 = var1_8 == 0 and 6 or var1_8

		local var2_8 = -60 * (var1_8 - 1)

		arg0_8.turntabletf.localEulerAngles = Vector3(0, var2_8, 0)
		arg0_8.rotateDuration = IslandCheaterTavernConst.afterTurnTime
		arg0_8.stepStartY = arg0_8.turntabletf.localEulerAngles.y
		arg0_8.stepTargetY = arg0_8.stepStartY - 60
	end
end

function var0_0.OnUpdate(arg0_9)
	local var0_9 = false

	if arg0_9.shootOpenTime ~= nil then
		arg0_9.shootOpenTime = arg0_9.shootOpenTime + Time.deltaTime

		if arg0_9.shootOpenTime >= 0.2 then
			var0_9 = true
			arg0_9.shootOpenTime = nil
		end
	end

	if arg0_9.firstTakeShoot then
		var0_9 = true
		arg0_9.firstTakeShoot = false
	end

	if var0_9 then
		arg0_9.rotateTime = 0

		if arg0_9.hasBombCount == 1 then
			arg0_9.isRotating = true
		else
			arg0_9.trunToNextBomb = true
		end
	end

	if arg0_9.isRotating then
		arg0_9.rotateTime = arg0_9.rotateTime + Time.deltaTime

		local var1_9 = Mathf.Clamp01(arg0_9.rotateTime / arg0_9.rotateDuration)
		local var2_9 = Mathf.SmoothStep(0, 1, var1_9)
		local var3_9 = arg0_9.rotateStartEuler.y + arg0_9.rotateTotalAngle * var2_9

		arg0_9.turntabletf.localEulerAngles = Vector3(arg0_9.rotateStartEuler.x, var3_9, arg0_9.rotateStartEuler.z)

		if var1_9 >= 1 then
			arg0_9.isRotating = false
			arg0_9.turntabletf.localEulerAngles = Vector3(arg0_9.rotateStartEuler.x, arg0_9.rotateStartEuler.y + arg0_9.endRotationY, arg0_9.rotateStartEuler.z)

			if arg0_9.gotShoot then
				setActive(arg0_9.boomShoot, true)
				onDelayTick(function()
					if IsNil(arg0_9.boomShoot) then
						return
					end

					setActive(arg0_9.boomShoot, false)
					arg0_9.animator:SetTrigger("close")
					arg0_9.decorationAnimator:SetTrigger("close")
				end, 1)
			else
				setActive(arg0_9.noGotShoot, true)
				setActive(arg0_9["bombId" .. tostring(arg0_9.curBombId)], true)
				onDelayTick(function()
					if IsNil(arg0_9.noGotShoot) then
						return
					end

					setActive(arg0_9.noGotShoot, false)
					arg0_9.animator:SetTrigger("close")
					arg0_9.decorationAnimator:SetTrigger("close")
				end, 1)
			end
		end
	end

	if arg0_9.trunToNextBomb then
		arg0_9.rotateTime = arg0_9.rotateTime + Time.deltaTime

		local var4_9 = Mathf.Clamp01(arg0_9.rotateTime / arg0_9.rotateDuration)
		local var5_9 = Mathf.SmoothStep(0, 1, var4_9)
		local var6_9 = Mathf.LerpAngle(arg0_9.stepStartY, arg0_9.stepTargetY, var5_9)

		arg0_9.turntabletf.localEulerAngles = Vector3(0, var6_9, 0)

		if var4_9 >= 1 then
			arg0_9.turntabletf.localEulerAngles = Vector3(0, arg0_9.stepTargetY, 0)

			if arg0_9.gotShoot then
				setActive(arg0_9.boomShoot, true)
				onDelayTick(function()
					if IsNil(arg0_9.boomShoot) then
						return
					end

					setActive(arg0_9.boomShoot, false)
					arg0_9.animator:SetTrigger("close")
					arg0_9.decorationAnimator:SetTrigger("close")
				end, 1)
			else
				setActive(arg0_9.noGotShoot, true)
				setActive(arg0_9["bombId" .. tostring(arg0_9.curBombId)], true)
				onDelayTick(function()
					if IsNil(arg0_9.noGotShoot) then
						return
					end

					setActive(arg0_9.noGotShoot, false)
					arg0_9.animator:SetTrigger("close")
					arg0_9.decorationAnimator:SetTrigger("close")
				end, 1)
			end

			arg0_9.trunToNextBomb = false
		end
	end
end

return var0_0
