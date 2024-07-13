local var0_0 = class("CourtYardShipAnimatorAgent", import(".CourtYardAgent"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.name = nil
end

function var0_0.State2AnimationName(arg0_2, arg1_2)
	if arg1_2 == CourtYardShip.STATE_IDLE or arg1_2 == CourtYardShip.STATE_STOP then
		return "stand2"
	elseif arg1_2 == CourtYardShip.STATE_MOVE then
		return "walk"
	elseif arg1_2 == CourtYardShip.STATE_DRAG then
		return "tuozhuai2"
	elseif arg1_2 == CourtYardShip.STATE_TOUCH then
		return "touch"
	elseif arg1_2 == CourtYardShip.STATE_GETAWARD then
		return "motou"
	elseif arg1_2 == CourtYardShip.STATE_INTERACT then
		-- block empty
	end
end

function var0_0.SetState(arg0_3, arg1_3)
	arg0_3:RemoveAnimFinishTimer()

	local var0_3 = arg0_3:State2AnimationName(arg1_3)

	if not var0_3 or arg0_3.name == var0_3 then
		return
	end

	arg0_3:PlayAction(var0_3, function()
		arg0_3:OnAnimtionFinish(arg1_3)
	end)
end

function var0_0.PlayInteractioAnim(arg0_5, arg1_5)
	arg0_5:PlayAction(arg1_5, function()
		arg0_5:OnAnimtionFinish(CourtYardShip.STATE_INTERACT)
	end)
	arg0_5:CheckMissTagAction(arg1_5)
end

function var0_0.PlayAction(arg0_7, arg1_7, arg2_7)
	arg0_7:RemoveAnimFinishTimer()
	arg0_7.spineAnimUI:SetActionCallBack(nil)

	local function var0_7(arg0_8)
		if arg0_8 == "finish" then
			arg0_7.spineAnimUI:SetActionCallBack(nil)
			arg2_7()
		end
	end

	arg0_7.spineAnimUI:SetActionCallBack(var0_7)
	arg0_7.role:SetAction(arg1_7)

	arg0_7.name = arg1_7
end

function var0_0.CheckMissTagAction(arg0_9, arg1_9)
	local var0_9 = arg0_9.data:GetInterActionData()
	local var1_9 = pg.furniture_specail_action[var0_9:GetOwner().configId]

	if var1_9 then
		local var2_9 = _.detect(var1_9.actions, function(arg0_10)
			return arg0_10[1] == arg1_9
		end)

		if var2_9 then
			arg0_9:AddAnimFinishTimer(var2_9[2])
		end
	end
end

function var0_0.AddAnimFinishTimer(arg0_11, arg1_11)
	arg0_11.animFinishTimer = Timer.New(function()
		arg0_11.animFinishTimer:Stop()

		arg0_11.animFinishTimer = nil

		arg0_11:OnAnimtionFinish(CourtYardShip.STATE_INTERACT)
	end, arg1_11, 1)

	arg0_11.animFinishTimer:Start()
end

function var0_0.RemoveAnimFinishTimer(arg0_13)
	if arg0_13.animFinishTimer then
		arg0_13.animFinishTimer:Stop()

		arg0_13.animFinishTimer = nil
	end
end

function var0_0.Dispose(arg0_14)
	arg0_14:RemoveAnimFinishTimer()
	var0_0.super.Dispose(arg0_14)
	arg0_14.spineAnimUI:SetActionCallBack(nil)
end

return var0_0
