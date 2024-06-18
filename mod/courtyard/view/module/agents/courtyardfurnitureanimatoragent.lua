local var0_0 = class("CourtYardFurnitureAnimatorAgent", import(".CourtYardAgent"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.maskSpineAnimUIs = {}

	for iter0_1, iter1_1 in pairs(arg0_1.masks) do
		local var0_1 = GetOrAddComponent(iter1_1:Find("spine"), typeof(SpineAnimUI))

		table.insert(arg0_1.maskSpineAnimUIs, var0_1)
	end

	arg0_1.spineTF = arg0_1._tf:Find("spine_icon")
	arg0_1.spineAnimUI = GetOrAddComponent(arg0_1.spineTF:Find("spine"), typeof(SpineAnimUI))

	arg0_1:SetState(CourtYardFurniture.STATE_IDLE)
end

function var0_0.State2Action(arg0_2, arg1_2)
	if arg1_2 == CourtYardFurniture.STATE_IDLE then
		return arg0_2.data:GetFirstSlot():GetSpineDefaultAction(), true
	elseif arg1_2 == CourtYardFurniture.STATE_TOUCH then
		return arg0_2.data:GetTouchAction()
	elseif arg1_2 == CourtYardFurniture.STATE_TOUCH_PREPARE then
		return arg0_2.data:GetTouchPrepareAction()
	elseif arg1_2 == CourtYardFurniture.STATE_PLAY_MUSIC then
		return arg0_2.data:GetMusicData().action, true
	end
end

function var0_0.SetState(arg0_3, arg1_3)
	local var0_3, var1_3 = arg0_3:State2Action(arg1_3)

	if not var0_3 or var0_3 == "" then
		return
	end

	arg0_3:_PlayAction(var0_3, var1_3, function()
		arg0_3:OnAnimtionFinish(arg1_3)
	end)

	if arg1_3 == CourtYardFurniture.STATE_IDLE then
		for iter0_3, iter1_3 in ipairs(arg0_3.maskSpineAnimUIs) do
			iter1_3:SetAction(var0_3, 0)
		end
	end
end

function var0_0.GetNormalAnimationName(arg0_5)
	return arg0_5:State2Action(CourtYardFurniture.STATE_IDLE)
end

function var0_0.RestartAnimation(arg0_6, arg1_6)
	arg0_6.spineAnimUI:SetAction(arg1_6, 0)
end

function var0_0._PlayAction(arg0_7, arg1_7, arg2_7, arg3_7)
	local var0_7 = not arg2_7 and function(arg0_8)
		if arg0_8 == "finish" then
			arg0_7.spineAnimUI:SetActionCallBack(nil)
			arg3_7()
		end
	end or nil

	arg0_7.spineAnimUI:SetActionCallBack(var0_7)
	arg0_7.spineAnimUI:SetAction(arg1_7, 0)
end

function var0_0.PlayInteractioAnim(arg0_9, arg1_9)
	parallelAsync({
		function(arg0_10)
			arg0_9:PlayMaskAction(arg1_9, arg0_10)
		end,
		function(arg0_11)
			arg0_9:_PlayAction(arg1_9, false, arg0_11)
		end
	}, function()
		arg0_9:OnAnimtionFinish(CourtYardFurniture.STATE_INTERACT)
	end)
end

function var0_0.PlayMaskAction(arg0_13, arg1_13, arg2_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in ipairs(arg0_13.maskSpineAnimUIs) do
		table.insert(var0_13, function(arg0_14)
			iter1_13:SetActionCallBack(function(arg0_15)
				if arg0_15 == "finish" then
					iter1_13:SetActionCallBack(nil)
					arg0_14()
				end
			end)
			iter1_13:SetAction(arg1_13, 0)
		end)
	end

	parallelAsync(var0_13, arg2_13)
end

function var0_0.Dispose(arg0_16)
	arg0_16.spineAnimUI:SetActionCallBack(nil)
	Object.Destroy(arg0_16.spineAnimUI)

	arg0_16.spineAnimUI = nil

	Object.Destroy(arg0_16.spineTF.gameObject)

	arg0_16.spineTF = nil

	for iter0_16, iter1_16 in ipairs(arg0_16.maskSpineAnimUIs) do
		iter1_16:SetActionCallBack(nil)
		Object.Destroy(iter1_16)
	end

	arg0_16.maskSpineAnimUIs = nil

	var0_0.super.Dispose()
end

return var0_0
