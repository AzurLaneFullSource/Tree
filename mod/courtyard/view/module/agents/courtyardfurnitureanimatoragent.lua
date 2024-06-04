local var0 = class("CourtYardFurnitureAnimatorAgent", import(".CourtYardAgent"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.maskSpineAnimUIs = {}

	for iter0, iter1 in pairs(arg0.masks) do
		local var0 = GetOrAddComponent(iter1:Find("spine"), typeof(SpineAnimUI))

		table.insert(arg0.maskSpineAnimUIs, var0)
	end

	arg0.spineTF = arg0._tf:Find("spine_icon")
	arg0.spineAnimUI = GetOrAddComponent(arg0.spineTF:Find("spine"), typeof(SpineAnimUI))

	arg0:SetState(CourtYardFurniture.STATE_IDLE)
end

function var0.State2Action(arg0, arg1)
	if arg1 == CourtYardFurniture.STATE_IDLE then
		return arg0.data:GetFirstSlot():GetSpineDefaultAction(), true
	elseif arg1 == CourtYardFurniture.STATE_TOUCH then
		return arg0.data:GetTouchAction()
	elseif arg1 == CourtYardFurniture.STATE_TOUCH_PREPARE then
		return arg0.data:GetTouchPrepareAction()
	elseif arg1 == CourtYardFurniture.STATE_PLAY_MUSIC then
		return arg0.data:GetMusicData().action, true
	end
end

function var0.SetState(arg0, arg1)
	local var0, var1 = arg0:State2Action(arg1)

	if not var0 or var0 == "" then
		return
	end

	arg0:_PlayAction(var0, var1, function()
		arg0:OnAnimtionFinish(arg1)
	end)

	if arg1 == CourtYardFurniture.STATE_IDLE then
		for iter0, iter1 in ipairs(arg0.maskSpineAnimUIs) do
			iter1:SetAction(var0, 0)
		end
	end
end

function var0.GetNormalAnimationName(arg0)
	return arg0:State2Action(CourtYardFurniture.STATE_IDLE)
end

function var0.RestartAnimation(arg0, arg1)
	arg0.spineAnimUI:SetAction(arg1, 0)
end

function var0._PlayAction(arg0, arg1, arg2, arg3)
	local var0 = not arg2 and function(arg0)
		if arg0 == "finish" then
			arg0.spineAnimUI:SetActionCallBack(nil)
			arg3()
		end
	end or nil

	arg0.spineAnimUI:SetActionCallBack(var0)
	arg0.spineAnimUI:SetAction(arg1, 0)
end

function var0.PlayInteractioAnim(arg0, arg1)
	parallelAsync({
		function(arg0)
			arg0:PlayMaskAction(arg1, arg0)
		end,
		function(arg0)
			arg0:_PlayAction(arg1, false, arg0)
		end
	}, function()
		arg0:OnAnimtionFinish(CourtYardFurniture.STATE_INTERACT)
	end)
end

function var0.PlayMaskAction(arg0, arg1, arg2)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.maskSpineAnimUIs) do
		table.insert(var0, function(arg0)
			iter1:SetActionCallBack(function(arg0)
				if arg0 == "finish" then
					iter1:SetActionCallBack(nil)
					arg0()
				end
			end)
			iter1:SetAction(arg1, 0)
		end)
	end

	parallelAsync(var0, arg2)
end

function var0.Dispose(arg0)
	arg0.spineAnimUI:SetActionCallBack(nil)
	Object.Destroy(arg0.spineAnimUI)

	arg0.spineAnimUI = nil

	Object.Destroy(arg0.spineTF.gameObject)

	arg0.spineTF = nil

	for iter0, iter1 in ipairs(arg0.maskSpineAnimUIs) do
		iter1:SetActionCallBack(nil)
		Object.Destroy(iter1)
	end

	arg0.maskSpineAnimUIs = nil

	var0.super.Dispose()
end

return var0
