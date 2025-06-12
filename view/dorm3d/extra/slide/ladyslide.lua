local var0_0 = class("LadySlide")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.ladyEnv = arg1_1
end

function var0_0.OnUpdate(arg0_2)
	if not arg0_2.wayPoints or not arg0_2.curIndex or arg0_2.curIndex > #arg0_2.wayPoints then
		return
	end

	local function var0_2(arg0_3, arg1_3)
		local var0_3 = arg0_3.position - arg1_3.position

		var0_3.y = 0

		return var0_3.magnitude <= 0.1
	end

	if arg0_2.curIndex == 0 or var0_2(arg0_2.wayPoints[arg0_2.curIndex], arg0_2.ladyEnv.lady) then
		arg0_2.curIndex = arg0_2.curIndex + 1

		local var1_2 = arg0_2.wayPoints[arg0_2.curIndex]

		arg0_2:ExitState(arg0_2.curState)
		arg0_2:EnterState(var1_2.name)
	end

	arg0_2:UpdateState()
end

function var0_0.UpdateState(arg0_4)
	switch(arg0_4.curState, {
		walk = function()
			arg0_4.ladyEnv:MoveToTarget(arg0_4.wayPoints[arg0_4.curIndex].position)
		end,
		ladder = function()
			return
		end,
		slide = function()
			return
		end
	})
end

function var0_0.EnterState(arg0_8, arg1_8)
	switch(arg1_8, {
		walk = function()
			arg0_8.ladyEnv:PlaySingleAction("swim_slide_walk_01")

			arg0_8.ladyEnv.characterController.enabled = true
		end,
		ladder = function()
			arg0_8.ladyEnv:PlaySingleAction("swim_slide_ladder_01")

			arg0_8.bonePosition = arg0_8.ladyBoneRoot.localPosition
		end,
		slide = function()
			return
		end
	})

	arg0_8.curState = arg1_8
end

function var0_0.ExitState(arg0_12, arg1_12)
	switch(arg0_12.curState, {
		walk = function()
			arg0_12.ladyEnv.characterController.enabled = false
		end,
		ladder = function()
			return
		end,
		slide = function()
			return
		end
	})

	arg0_12.curState = nil
end

return var0_0
