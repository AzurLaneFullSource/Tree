local var0 = class("CourtYardShipAnimatorAgent", import(".CourtYardAgent"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.name = nil
end

function var0.State2AnimationName(arg0, arg1)
	if arg1 == CourtYardShip.STATE_IDLE or arg1 == CourtYardShip.STATE_STOP then
		return "stand2"
	elseif arg1 == CourtYardShip.STATE_MOVE then
		return "walk"
	elseif arg1 == CourtYardShip.STATE_DRAG then
		return "tuozhuai2"
	elseif arg1 == CourtYardShip.STATE_TOUCH then
		return "touch"
	elseif arg1 == CourtYardShip.STATE_GETAWARD then
		return "motou"
	elseif arg1 == CourtYardShip.STATE_INTERACT then
		-- block empty
	end
end

function var0.SetState(arg0, arg1)
	arg0:RemoveAnimFinishTimer()

	local var0 = arg0:State2AnimationName(arg1)

	if not var0 or arg0.name == var0 then
		return
	end

	arg0:PlayAction(var0, function()
		arg0:OnAnimtionFinish(arg1)
	end)
end

function var0.PlayInteractioAnim(arg0, arg1)
	arg0:PlayAction(arg1, function()
		arg0:OnAnimtionFinish(CourtYardShip.STATE_INTERACT)
	end)
	arg0:CheckMissTagAction(arg1)
end

function var0.PlayAction(arg0, arg1, arg2)
	arg0:RemoveAnimFinishTimer()
	arg0.spineAnimUI:SetActionCallBack(nil)

	local function var0(arg0)
		if arg0 == "finish" then
			arg0.spineAnimUI:SetActionCallBack(nil)
			arg2()
		end
	end

	arg0.spineAnimUI:SetActionCallBack(var0)
	arg0.role:SetAction(arg1)

	arg0.name = arg1
end

function var0.CheckMissTagAction(arg0, arg1)
	local var0 = arg0.data:GetInterActionData()
	local var1 = pg.furniture_specail_action[var0:GetOwner().configId]

	if var1 then
		local var2 = _.detect(var1.actions, function(arg0)
			return arg0[1] == arg1
		end)

		if var2 then
			arg0:AddAnimFinishTimer(var2[2])
		end
	end
end

function var0.AddAnimFinishTimer(arg0, arg1)
	arg0.animFinishTimer = Timer.New(function()
		arg0.animFinishTimer:Stop()

		arg0.animFinishTimer = nil

		arg0:OnAnimtionFinish(CourtYardShip.STATE_INTERACT)
	end, arg1, 1)

	arg0.animFinishTimer:Start()
end

function var0.RemoveAnimFinishTimer(arg0)
	if arg0.animFinishTimer then
		arg0.animFinishTimer:Stop()

		arg0.animFinishTimer = nil
	end
end

function var0.Dispose(arg0)
	arg0:RemoveAnimFinishTimer()
	var0.super.Dispose(arg0)
	arg0.spineAnimUI:SetActionCallBack(nil)
end

return var0
