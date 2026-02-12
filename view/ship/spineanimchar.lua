local var0_0 = class("SpineAnimChar")
local var1_0 = "normal"

var0_0.state_init = 1
var0_0.state_loading = 2
var0_0.state_complete = 3
var0_0.state_dispose = 4

function var0_0.Ctor(arg0_1, arg1_1)
	if arg1_1 then
		arg0_1.config = pg.ship_skin_template[arg1_1]
		arg0_1.prefab = arg0_1.config.prefab
	end

	arg0_1.state = var0_0.state_init
	arg0_1.normalAction = var1_0
end

function var0_0.GetCharModel(arg0_2)
	return arg0_2._model
end

function var0_0.SetName(arg0_3, arg1_3)
	if arg0_3:isComplete() then
		arg0_3._model.name = arg1_3
	end
end

function var0_0.SetSiblingIndex(arg0_4, arg1_4)
	if arg0_4:isComplete() then
		arg0_4._model.transform:SetSiblingIndex(arg1_4)
	end
end

function var0_0.SetPaint(arg0_5, arg1_5)
	arg0_5.prefab = arg1_5
end

function var0_0.Load(arg0_6, arg1_6, arg2_6)
	if arg0_6.state == var0_0.state_init then
		arg0_6.state = var0_0.state_loading

		PoolMgr.GetInstance():GetSpineChar(arg0_6.prefab, arg0_6.sync, function(arg0_7)
			if arg0_7 then
				if arg0_6:isDispose() then
					PoolMgr.GetInstance():ReturnSpineChar(arg0_6.prefab, arg0_7)
				else
					arg0_6:start(arg0_7)

					if arg2_6 then
						arg2_6(arg0_6)
					end
				end
			else
				arg0_6.state = var0_0.state_init
			end
		end)
	end
end

function var0_0.SetPivot(arg0_8, arg1_8)
	if arg0_8:isComplete() then
		tf(arg0_8._model).pivot = arg1_8
	end
end

function var0_0.SetSizeDelta(arg0_9, arg1_9)
	if arg0_9:isComplete() then
		tf(arg0_9._model).sizeDelta = arg1_9
	end
end

function var0_0.SetParent(arg0_10, arg1_10, arg2_10)
	if not arg0_10:isComplete() then
		arg0_10.loadedParent = arg1_10

		return
	end

	SetParent(arg0_10._model, arg1_10, arg2_10 and true or false)
end

function var0_0.SetNormalAction(arg0_11, arg1_11)
	arg0_11.normalAction = arg1_11
end

function var0_0.SetAction(arg0_12, arg1_12, arg2_12)
	arg2_12 = arg2_12 or 0
	arg0_12.actionName = arg1_12

	local var0_12, var1_12 = arg0_12:getDirectActonName(arg1_12)

	if not arg0_12.modelScale then
		arg0_12.modelScale = tf(arg0_12._model).localScale
	end

	local var2_12

	if var1_12 then
		local var3_12 = math.abs(arg0_12.modelScale.x)

		tf(arg0_12._model).localScale = Vector3(var3_12, arg0_12.modelScale.y, arg0_12.modelScale.z)
	else
		local var4_12 = math.sign(arg0_12.modelScale.x)

		tf(arg0_12._model).localScale = arg0_12.modelScale
	end

	arg0_12._animUI:SetAction(var0_12, arg2_12)
end

function var0_0.SetActionOnce(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	arg0_13:SetActionCallBack(nil)
	arg0_13:SetActionCallBack(function(arg0_14)
		if arg0_14 == "action" then
			if arg3_13 then
				arg3_13()
			end
		elseif arg0_14 == "finish" and arg4_13 then
			arg4_13()
		end
	end)
	arg0_13:SetAction(arg1_13, arg2_13)
end

function var0_0.SetActionCallBack(arg0_15, arg1_15)
	arg0_15._animUI:SetActionCallBack(arg1_15)
end

function var0_0.GetLocalScale(arg0_16)
	if arg0_16:isComplete() then
		return tf(arg0_16._model).localScale
	end
end

function var0_0.SetLocalScale(arg0_17, arg1_17)
	if arg0_17:isComplete() then
		arg0_17.direct = math.sign(arg1_17.x)
		tf(arg0_17._model).localScale = arg1_17
		arg0_17.modelScale = arg1_17

		arg0_17:updateCharDirect()
	end
end

function var0_0.SetLocalPosition(arg0_18, arg1_18)
	if arg0_18:isComplete() then
		tf(arg0_18._model).localPosition = arg1_18
	end
end

function var0_0.SetAnchoredPosition(arg0_19, arg1_19)
	if arg0_19:isComplete() then
		tf(arg0_19._model).anchoredPosition = arg1_19
	end
end

function var0_0.GetAnchoredPosition(arg0_20)
	if arg0_20:isComplete() then
		return tf(arg0_20._model).anchoredPosition
	end
end

function var0_0.SetLayer(arg0_21, arg1_21)
	if arg0_21:isComplete() then
		pg.ViewUtils.SetLayer(tf(arg0_21._model), arg1_21)
	end
end

function var0_0.SetAnchoredPosition3D(arg0_22, arg1_22)
	if arg0_22:isComplete() then
		tf(arg0_22._model).anchoredPosition3D = arg1_22
	end
end

function var0_0.GetPauseStatue(arg0_23)
	if arg0_23._animUI then
		return arg0_23._animUI.Pause
	end

	return nil
end

function var0_0.GetSkeletonGraphic(arg0_24)
	return arg0_24._skeletonGraphic
end

function var0_0.GetAnimationState(arg0_25)
	if arg0_25._animUI then
		return arg0_25._animUI:GetAnimationState()
	end

	return nil
end

function var0_0.GetModel(arg0_26)
	return arg0_26._model
end

function var0_0.Resume(arg0_27)
	if arg0_27._animUI then
		return arg0_27._animUI:Resume()
	end
end

function var0_0.Pause(arg0_28)
	if arg0_28._animUI then
		return arg0_28._animUI:Pause()
	end
end

function var0_0.Dispose(arg0_29)
	if arg0_29.state == var0_0.state_complete then
		arg0_29:SetActionCallBack(nil)
		PoolMgr.GetInstance():ReturnSpineChar(arg0_29.prefab, arg0_29._model)
	end

	arg0_29._animUI = nil
	arg0_29.prefab = nil
	arg0_29._model = nil
	arg0_29.state = var0_0.state_dispose
	arg0_29.parent = nil
end

function var0_0.start(arg0_30, arg1_30)
	arg0_30.state = var0_0.state_complete
	arg0_30._model = arg1_30
	arg0_30._animUI = arg1_30:GetComponent(typeof(SpineAnimUI))
	arg0_30._skeletonGraphic = arg1_30:GetComponent("SkeletonGraphic")

	if arg0_30.loadedParent then
		arg0_30:setParent(arg1_30, arg0_30.parent)

		arg0_30.loadedParent = nil
	end

	if arg0_30.loadedScale then
		arg0_30:setScale(arg0_30.loadedScale)

		arg0_30.loadedScale = nil
	end

	if arg0_30.loadedPosition then
		arg0_30:setPosition(arg0_30.loadedPosition)

		arg0_30.loadedPosition = nil
	end
end

function var0_0.updateCharDirect(arg0_31)
	if arg0_31.normalAction == arg0_31.actionName then
		arg0_31:SetAction(arg0_31.actionName, 0, -1)
	end
end

function var0_0.getDirectActonName(arg0_32, arg1_32)
	if not arg0_32.direct then
		arg0_32.direct = math.sign(tf(arg0_32._model).localScale.x)
	end

	local var0_32 = arg0_32.direct == 1 and "_R" or "_L"
	local var1_32 = arg1_32 .. var0_32

	if arg0_32._skeletonGraphic.SkeletonData:FindAnimation(var1_32) then
		return var1_32, true
	end

	return arg1_32, false
end

function var0_0.isComplete(arg0_33)
	return arg0_33.state == var0_0.state_complete
end

function var0_0.isDispose(arg0_34)
	return arg0_34.state == var0_0.state_dispose
end

return var0_0
