local var0 = class("CookGameJudge")

function var0.Ctor(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0._tf = arg1
	arg0._judgeDatas = arg3
	arg0._gameData = arg4
	arg0._event = arg5
	arg0._index = arg2
	arg0.wantedTf = findTF(arg0._tf, "wanted")
	arg0.smokeTf = findTF(arg0._tf, "wanted/smoke")
	arg0.dftEvent = GetComponent(findTF(arg0._tf, "mask/anim"), typeof(DftAniEvent))

	arg0.dftEvent:SetEndEvent(function(arg0)
		arg0:onAniEnd()
	end)

	arg0.animator = GetComponent(findTF(arg0._tf, "mask/anim"), typeof(Animator))

	onButton(arg0._event, findTF(arg0._tf, "collider"), function()
		if arg0.clickCallback then
			arg0.clickCallback()
		end
	end, SFX_CANCEL)
end

function var0.clear(arg0)
	arg0._puzzleTime = nil
	arg0._puzzleWeight = nil
	arg0._puzzleCamp = nil
	arg0.cakeId = 1
	arg0.inTrigger = false
	arg0.serveData = nil
	arg0.serveCallback = nil

	arg0:updateWanted(nil)
	arg0:showCard(nil)
	setActive(arg0.wantedTf, false)
	setActive(arg0._tf, false)

	local var0 = arg0:getAnimData(arg0.cakeId)

	arg0.animator.runtimeAnimatorController = var0.runtimeAnimator

	arg0:select(false)
end

function var0.start(arg0)
	arg0:clear()
	setActive(arg0._tf, true)
	arg0:updateWanted(math.random(1, arg0._gameData.cake_num))
end

function var0.step(arg0, arg1)
	if arg0.wantedCakeTime and arg0.wantedCakeTime > 0 then
		arg0.wantedCakeTime = arg0.wantedCakeTime - arg1

		if arg0.wantedCakeTime <= 0 then
			arg0.wantedCakeTime = nil

			arg0:updateWanted(math.random(1, arg0._gameData.cake_num))
		end
	end

	if arg0._puzzleTime then
		arg0._puzzleTime = arg0._puzzleTime - arg1

		if arg0._puzzleTime <= 0 then
			arg0._puzzleTime = nil
			arg0._puzzleCamp = nil
			arg0._puzzleWeight = nil

			arg0:showCard(false)
		end
	end

	if arg0.readyServeTime and arg0.readyServeTime > 0 then
		arg0.readyServeTime = arg0.readyServeTime - arg1

		if arg0.readyServeTime <= 0 then
			arg0.readyServeTime = nil
			arg0.serveData = nil
			arg0.serveCallback = nil
		end
	end
end

function var0.destroy(arg0)
	return
end

function var0.changeSpeed(arg0, arg1)
	arg0.animator.speed = arg1
end

function var0.onAniEnd(arg0)
	arg0.inTrigger = false

	if arg0.freshWanted then
		arg0.freshWanted = false
		arg0.wantedCakeTime = nil

		arg0:updateWanted(math.random(1, arg0._gameData.cake_num))
	end
end

function var0.getIndex(arg0)
	return arg0._index
end

function var0.getTf(arg0)
	return arg0._tf
end

function var0.trigger(arg0, arg1, arg2, arg3, arg4)
	if arg0.inTrigger then
		print("评委已有状态")

		return
	end

	local var0 = Vector3(1, 1, 1)

	arg0.inTrigger = true

	if arg0.cakeId ~= arg1 then
		arg0.cakeId = arg1

		local var1 = arg0:getAnimData(arg0.cakeId)

		arg0.animator.runtimeAnimatorController = var1.runtimeAnimator
	end

	arg0.animator:SetBool("AC", arg3 or false)
	arg0.animator:SetBool("right", arg2 or false)
	arg0.animator:SetBool("bk", arg4 or false)
	arg0.animator:SetBool("reject", arg0._puzzleCamp and true or false)

	if arg0._puzzleCamp and not arg2 then
		if arg0._puzzleCamp == CookGameConst.camp_player then
			var0 = Vector3(-1, 1, 1)
		else
			var0 = Vector3(1, 1, 1)
		end
	end

	findTF(arg0._tf, "mask").localScale = var0

	arg0.animator:SetTrigger("trigger")

	if arg2 then
		arg0:updateWanted()

		arg0.freshWanted = true
		arg0.wantedCakeTime = 3
	end
end

function var0.readyServe(arg0, arg1, arg2)
	if arg0.serveCallback then
		arg0.serveCallback(false)
	end

	arg0.serveData = arg1
	arg0.readyServeTime = 4
	arg0.serveCallback = arg2

	if arg0.serveData.battleData.cake_allow and arg0.wantedCake ~= arg0.serveData.parameter.cakeId then
		if not arg0._puzzleTime then
			setActive(arg0.smokeTf, false)
			setActive(arg0.smokeTf, true)

			arg0.wantedCake = arg0.serveData.parameter.cakeId

			arg0:showCake(arg0.wantedCake)
		elseif arg0._puzzleCamp ~= arg0.serveData.parameter.camp and arg0.serveData.parameter.weight > arg0._puzzleWeight then
			setActive(arg0.smokeTf, false)
			setActive(arg0.smokeTf, true)

			arg0.wantedCake = arg0.serveData.parameter.cakeId

			arg0:showCake(arg0.wantedCake)
		end
	end
end

function var0.setWantedImg(arg0)
	return
end

function var0.serve(arg0)
	if not arg0.serveData then
		return
	end

	if (not arg0.wantedCake or arg0.inTrigger) and arg0.serveCallback then
		arg0.serveCallback(false)
	end

	local var0 = arg0.serveData.parameter.cakeId
	local var1 = arg0.serveData.battleData.ac_able
	local var2 = arg0.serveData.judgeData.acPos
	local var3 = arg0.serveData.battleData.id
	local var4 = arg0.serveData.parameter.right_index
	local var5 = arg0.serveData.parameter.right_flag
	local var6 = arg0.serveData.parameter.rate
	local var7 = arg0.serveData.parameter.weight

	if not var0 then
		print("cakeId 不能为nil")

		return
	end

	local var8 = var1 and true or false
	local var9 = false

	if var8 then
		local var10 = arg0._tf.parent

		if var2.y > arg0._tf.anchoredPosition.y then
			var9 = true
		end
	end

	local var11 = 1

	if arg0._puzzleCamp and arg0.serveData.parameter.camp == arg0._puzzleCamp then
		var11 = 2
	elseif arg0._puzzleCamp and arg0.serveData.parameter.camp ~= arg0._puzzleCamp then
		var11 = 0
	end

	if arg0.serveData.parameter.puzzle then
		arg0:setPuzzle(arg0.serveData.parameter.camp, arg0.serveData.battleData.weight)
	end

	local var12 = arg0._puzzleWeight or 0

	arg0:trigger(var0, var5, var8, var9)
	arg0._event:emit(CookGameView.SERVE_EVENT, {
		serveData = arg0.serveData,
		pos = arg0._tf.position,
		right = var5,
		rate = var11,
		weight = var12
	})

	arg0.serveData = nil
	arg0.serveCallback = nil
	arg0.readyServeTime = nil
end

function var0.setPuzzle(arg0, arg1, arg2)
	arg0._puzzleCamp = arg1
	arg0._puzzleWeight = arg2
	arg0._puzzleTime = CookGameConst.puzzle_time

	arg0:showCard(true)
end

function var0.showCard(arg0, arg1)
	setActive(findTF(arg0.wantedTf, "Card"), arg1)
	arg0:showCake(nil)
end

function var0.isInServe(arg0)
	return arg0.serveData
end

function var0.isInTrigger(arg0)
	return arg0.inTrigger
end

function var0.getPuzzleCamp(arg0)
	return arg0._puzzleCamp
end

function var0.getWantedCake(arg0)
	return arg0.wantedCake
end

function var0.updateWanted(arg0, arg1)
	if arg0.wantedCake ~= arg1 and arg1 then
		arg0:showCake(arg1)
	end

	if arg1 and arg1 > 0 then
		setActive(arg0.wantedTf, true)

		arg0.wantedCake = arg1
		arg0.wantedCakeTime = nil
	else
		setActive(arg0.wantedTf, false)
	end
end

function var0.showCake(arg0, arg1)
	arg1 = arg1 or arg0.wantedCake

	for iter0 = 1, arg0._gameData.cake_num do
		setActive(findTF(arg0.wantedTf, "cake_" .. iter0), not arg0._puzzleTime and iter0 == arg1)
	end
end

function var0.setFrontContainer(arg0, arg1)
	arg0._frontTf = arg1

	if arg0._frontTf then
		SetParent(arg0.wantedTf, arg0._frontTf, true)
	end
end

function var0.getPos(arg0)
	return arg0._tf.anchoredPosition()
end

function var0.getLeftTf(arg0)
	return findTF(arg0._tf, "leftPos")
end

function var0.getRightTf(arg0)
	return findTF(arg0._tf, "rightPos")
end

function var0.select(arg0, arg1)
	setActive(findTF(arg0._tf, "select"), arg1)
end

function var0.setClickCallback(arg0, arg1)
	arg0.clickCallback = arg1
end

function var0.getAcTargetTf(arg0)
	return findTF(arg0._tf, "acTarget")
end

function var0.getAnimData(arg0, arg1)
	for iter0 = 1, #arg0._judgeDatas do
		local var0 = arg0._judgeDatas[iter0]

		if var0.data.cake_id == arg1 then
			return var0
		end
	end

	return nil
end

return var0
