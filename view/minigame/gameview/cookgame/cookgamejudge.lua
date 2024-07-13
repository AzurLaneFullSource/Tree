local var0_0 = class("CookGameJudge")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	arg0_1._tf = arg1_1
	arg0_1._judgeDatas = arg3_1
	arg0_1._gameData = arg4_1
	arg0_1._event = arg5_1
	arg0_1._index = arg2_1
	arg0_1.wantedTf = findTF(arg0_1._tf, "wanted")
	arg0_1.smokeTf = findTF(arg0_1._tf, "wanted/smoke")
	arg0_1.dftEvent = GetComponent(findTF(arg0_1._tf, "mask/anim"), typeof(DftAniEvent))

	arg0_1.dftEvent:SetEndEvent(function(arg0_2)
		arg0_1:onAniEnd()
	end)

	arg0_1.animator = GetComponent(findTF(arg0_1._tf, "mask/anim"), typeof(Animator))

	onButton(arg0_1._event, findTF(arg0_1._tf, "collider"), function()
		if arg0_1.clickCallback then
			arg0_1.clickCallback()
		end
	end, SFX_CANCEL)
end

function var0_0.clear(arg0_4)
	arg0_4._puzzleTime = nil
	arg0_4._puzzleWeight = nil
	arg0_4._puzzleCamp = nil
	arg0_4.cakeId = 1
	arg0_4.inTrigger = false
	arg0_4.serveData = nil
	arg0_4.serveCallback = nil

	arg0_4:updateWanted(nil)
	arg0_4:showCard(nil)
	setActive(arg0_4.wantedTf, false)
	setActive(arg0_4._tf, false)

	local var0_4 = arg0_4:getAnimData(arg0_4.cakeId)

	arg0_4.animator.runtimeAnimatorController = var0_4.runtimeAnimator

	arg0_4:select(false)
end

function var0_0.start(arg0_5)
	arg0_5:clear()
	setActive(arg0_5._tf, true)
	arg0_5:updateWanted(math.random(1, arg0_5._gameData.cake_num))
end

function var0_0.step(arg0_6, arg1_6)
	if arg0_6.wantedCakeTime and arg0_6.wantedCakeTime > 0 then
		arg0_6.wantedCakeTime = arg0_6.wantedCakeTime - arg1_6

		if arg0_6.wantedCakeTime <= 0 then
			arg0_6.wantedCakeTime = nil

			arg0_6:updateWanted(math.random(1, arg0_6._gameData.cake_num))
		end
	end

	if arg0_6._puzzleTime then
		arg0_6._puzzleTime = arg0_6._puzzleTime - arg1_6

		if arg0_6._puzzleTime <= 0 then
			arg0_6._puzzleTime = nil
			arg0_6._puzzleCamp = nil
			arg0_6._puzzleWeight = nil

			arg0_6:showCard(false)
		end
	end

	if arg0_6.readyServeTime and arg0_6.readyServeTime > 0 then
		arg0_6.readyServeTime = arg0_6.readyServeTime - arg1_6

		if arg0_6.readyServeTime <= 0 then
			arg0_6.readyServeTime = nil
			arg0_6.serveData = nil
			arg0_6.serveCallback = nil
		end
	end
end

function var0_0.destroy(arg0_7)
	return
end

function var0_0.changeSpeed(arg0_8, arg1_8)
	arg0_8.animator.speed = arg1_8
end

function var0_0.onAniEnd(arg0_9)
	arg0_9.inTrigger = false

	if arg0_9.freshWanted then
		arg0_9.freshWanted = false
		arg0_9.wantedCakeTime = nil

		arg0_9:updateWanted(math.random(1, arg0_9._gameData.cake_num))
	end
end

function var0_0.getIndex(arg0_10)
	return arg0_10._index
end

function var0_0.getTf(arg0_11)
	return arg0_11._tf
end

function var0_0.trigger(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
	if arg0_12.inTrigger then
		print("评委已有状态")

		return
	end

	local var0_12 = Vector3(1, 1, 1)

	arg0_12.inTrigger = true

	if arg0_12.cakeId ~= arg1_12 then
		arg0_12.cakeId = arg1_12

		local var1_12 = arg0_12:getAnimData(arg0_12.cakeId)

		arg0_12.animator.runtimeAnimatorController = var1_12.runtimeAnimator
	end

	arg0_12.animator:SetBool("AC", arg3_12 or false)
	arg0_12.animator:SetBool("right", arg2_12 or false)
	arg0_12.animator:SetBool("bk", arg4_12 or false)
	arg0_12.animator:SetBool("reject", arg0_12._puzzleCamp and true or false)

	if arg0_12._puzzleCamp and not arg2_12 then
		if arg0_12._puzzleCamp == CookGameConst.camp_player then
			var0_12 = Vector3(-1, 1, 1)
		else
			var0_12 = Vector3(1, 1, 1)
		end
	end

	findTF(arg0_12._tf, "mask").localScale = var0_12

	arg0_12.animator:SetTrigger("trigger")

	if arg2_12 then
		arg0_12:updateWanted()

		arg0_12.freshWanted = true
		arg0_12.wantedCakeTime = 3
	end
end

function var0_0.readyServe(arg0_13, arg1_13, arg2_13)
	if arg0_13.serveCallback then
		arg0_13.serveCallback(false)
	end

	arg0_13.serveData = arg1_13
	arg0_13.readyServeTime = 4
	arg0_13.serveCallback = arg2_13

	if arg0_13.serveData.battleData.cake_allow and arg0_13.wantedCake ~= arg0_13.serveData.parameter.cakeId then
		if not arg0_13._puzzleTime then
			setActive(arg0_13.smokeTf, false)
			setActive(arg0_13.smokeTf, true)

			arg0_13.wantedCake = arg0_13.serveData.parameter.cakeId

			arg0_13:showCake(arg0_13.wantedCake)
		elseif arg0_13._puzzleCamp ~= arg0_13.serveData.parameter.camp and arg0_13.serveData.parameter.weight > arg0_13._puzzleWeight then
			setActive(arg0_13.smokeTf, false)
			setActive(arg0_13.smokeTf, true)

			arg0_13.wantedCake = arg0_13.serveData.parameter.cakeId

			arg0_13:showCake(arg0_13.wantedCake)
		end
	end
end

function var0_0.setWantedImg(arg0_14)
	return
end

function var0_0.serve(arg0_15)
	if not arg0_15.serveData then
		return
	end

	if (not arg0_15.wantedCake or arg0_15.inTrigger) and arg0_15.serveCallback then
		arg0_15.serveCallback(false)
	end

	local var0_15 = arg0_15.serveData.parameter.cakeId
	local var1_15 = arg0_15.serveData.battleData.ac_able
	local var2_15 = arg0_15.serveData.judgeData.acPos
	local var3_15 = arg0_15.serveData.battleData.id
	local var4_15 = arg0_15.serveData.parameter.right_index
	local var5_15 = arg0_15.serveData.parameter.right_flag
	local var6_15 = arg0_15.serveData.parameter.rate
	local var7_15 = arg0_15.serveData.parameter.weight

	if not var0_15 then
		print("cakeId 不能为nil")

		return
	end

	local var8_15 = var1_15 and true or false
	local var9_15 = false

	if var8_15 then
		local var10_15 = arg0_15._tf.parent

		if var2_15.y > arg0_15._tf.anchoredPosition.y then
			var9_15 = true
		end
	end

	local var11_15 = 1

	if arg0_15._puzzleCamp and arg0_15.serveData.parameter.camp == arg0_15._puzzleCamp then
		var11_15 = 2
	elseif arg0_15._puzzleCamp and arg0_15.serveData.parameter.camp ~= arg0_15._puzzleCamp then
		var11_15 = 0
	end

	if arg0_15.serveData.parameter.puzzle then
		arg0_15:setPuzzle(arg0_15.serveData.parameter.camp, arg0_15.serveData.battleData.weight)
	end

	local var12_15 = arg0_15._puzzleWeight or 0

	arg0_15:trigger(var0_15, var5_15, var8_15, var9_15)
	arg0_15._event:emit(CookGameView.SERVE_EVENT, {
		serveData = arg0_15.serveData,
		pos = arg0_15._tf.position,
		right = var5_15,
		rate = var11_15,
		weight = var12_15
	})

	arg0_15.serveData = nil
	arg0_15.serveCallback = nil
	arg0_15.readyServeTime = nil
end

function var0_0.setPuzzle(arg0_16, arg1_16, arg2_16)
	arg0_16._puzzleCamp = arg1_16
	arg0_16._puzzleWeight = arg2_16
	arg0_16._puzzleTime = CookGameConst.puzzle_time

	arg0_16:showCard(true)
end

function var0_0.showCard(arg0_17, arg1_17)
	setActive(findTF(arg0_17.wantedTf, "Card"), arg1_17)
	arg0_17:showCake(nil)
end

function var0_0.isInServe(arg0_18)
	return arg0_18.serveData
end

function var0_0.isInTrigger(arg0_19)
	return arg0_19.inTrigger
end

function var0_0.getPuzzleCamp(arg0_20)
	return arg0_20._puzzleCamp
end

function var0_0.getWantedCake(arg0_21)
	return arg0_21.wantedCake
end

function var0_0.updateWanted(arg0_22, arg1_22)
	if arg0_22.wantedCake ~= arg1_22 and arg1_22 then
		arg0_22:showCake(arg1_22)
	end

	if arg1_22 and arg1_22 > 0 then
		setActive(arg0_22.wantedTf, true)

		arg0_22.wantedCake = arg1_22
		arg0_22.wantedCakeTime = nil
	else
		setActive(arg0_22.wantedTf, false)
	end
end

function var0_0.showCake(arg0_23, arg1_23)
	arg1_23 = arg1_23 or arg0_23.wantedCake

	for iter0_23 = 1, arg0_23._gameData.cake_num do
		setActive(findTF(arg0_23.wantedTf, "cake_" .. iter0_23), not arg0_23._puzzleTime and iter0_23 == arg1_23)
	end
end

function var0_0.setFrontContainer(arg0_24, arg1_24)
	arg0_24._frontTf = arg1_24

	if arg0_24._frontTf then
		SetParent(arg0_24.wantedTf, arg0_24._frontTf, true)
	end
end

function var0_0.getPos(arg0_25)
	return arg0_25._tf.anchoredPosition()
end

function var0_0.getLeftTf(arg0_26)
	return findTF(arg0_26._tf, "leftPos")
end

function var0_0.getRightTf(arg0_27)
	return findTF(arg0_27._tf, "rightPos")
end

function var0_0.select(arg0_28, arg1_28)
	setActive(findTF(arg0_28._tf, "select"), arg1_28)
end

function var0_0.setClickCallback(arg0_29, arg1_29)
	arg0_29.clickCallback = arg1_29
end

function var0_0.getAcTargetTf(arg0_30)
	return findTF(arg0_30._tf, "acTarget")
end

function var0_0.getAnimData(arg0_31, arg1_31)
	for iter0_31 = 1, #arg0_31._judgeDatas do
		local var0_31 = arg0_31._judgeDatas[iter0_31]

		if var0_31.data.cake_id == arg1_31 then
			return var0_31
		end
	end

	return nil
end

return var0_0
