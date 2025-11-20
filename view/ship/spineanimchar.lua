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

function var0_0.SetParent(arg0_8, arg1_8, arg2_8)
	if not arg0_8:isComplete() then
		arg0_8.loadedParent = arg1_8

		return
	end

	SetParent(arg0_8._model, arg1_8, arg2_8 and true or false)
end

function var0_0.SetNormalAction(arg0_9, arg1_9)
	arg0_9.normalAction = arg1_9
end

function var0_0.SetAction(arg0_10, arg1_10, arg2_10)
	arg2_10 = arg2_10 or 0
	arg0_10.actionName = arg1_10

	local var0_10, var1_10 = arg0_10:getDirectActonName(arg1_10)

	if not arg0_10.modelScale then
		arg0_10.modelScale = tf(arg0_10._model).localScale
	end

	local var2_10

	if var1_10 then
		local var3_10 = math.abs(arg0_10.modelScale.x)

		tf(arg0_10._model).localScale = Vector3(var3_10, arg0_10.modelScale.y, arg0_10.modelScale.z)
	else
		local var4_10 = math.sign(arg0_10.modelScale.x)

		tf(arg0_10._model).localScale = arg0_10.modelScale
	end

	arg0_10._animUI:SetAction(var0_10, arg2_10)
end

function var0_0.SetActionOnce(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11)
	arg0_11:SetActionCallback(nil)
	arg0_11:SetActionCallback(function(arg0_12)
		if arg0_12 == "action" then
			if arg3_11 then
				arg3_11()
			end
		elseif arg0_12 == "finish" and arg4_11 then
			arg4_11()
		end
	end)
	arg0_11:SetAction(arg1_11, arg2_11)
end

function var0_0.SetActionCallBack(arg0_13, arg1_13)
	arg0_13._animUI:SetActionCallBack(arg1_13)
end

function var0_0.GetLocalScale(arg0_14)
	if arg0_14:isComplete() then
		return tf(arg0_14._model).localScale
	end
end

function var0_0.SetLocalScale(arg0_15, arg1_15)
	if arg0_15:isComplete() then
		arg0_15.direct = math.sign(arg1_15.x)
		tf(arg0_15._model).localScale = arg1_15
		arg0_15.modelScale = arg1_15

		arg0_15:updateCharDirect()
	end
end

function var0_0.SetLocalPosition(arg0_16, arg1_16)
	if arg0_16:isComplete() then
		tf(arg0_16._model).localPosition = arg1_16
	end
end

function var0_0.SetAnchoredPosition(arg0_17, arg1_17)
	if arg0_17:isComplete() then
		tf(arg0_17._model).anchoredPosition = arg1_17
	end
end

function var0_0.GetAnchoredPosition(arg0_18)
	if arg0_18:isComplete() then
		return tf(arg0_18._model).anchoredPosition
	end
end

function var0_0.SetLayer(arg0_19, arg1_19)
	if arg0_19:isComplete() then
		pg.ViewUtils.SetLayer(tf(arg0_19._model), arg1_19)
	end
end

function var0_0.SetAnchoredPosition3D(arg0_20, arg1_20)
	if arg0_20:isComplete() then
		tf(arg0_20._model).anchoredPosition3D = arg1_20
	end
end

function var0_0.GetPauseStatue(arg0_21)
	if arg0_21._animUI then
		return arg0_21._animUI.Pause
	end

	return nil
end

function var0_0.GetSkeletonGraphic(arg0_22)
	return arg0_22._skeletonGraphic
end

function var0_0.GetAnimationState(arg0_23)
	if arg0_23._animUI then
		return arg0_23._animUI:GetAnimationState()
	end

	return nil
end

function var0_0.GetModel(arg0_24)
	return arg0_24._model
end

function var0_0.Resume(arg0_25)
	if arg0_25._animUI then
		return arg0_25._animUI:Resume()
	end
end

function var0_0.Pause(arg0_26)
	if arg0_26._animUI then
		return arg0_26._animUI:Pause()
	end
end

function var0_0.Dispose(arg0_27)
	if arg0_27.state == var0_0.state_complete then
		arg0_27:SetActionCallBack(nil)
		PoolMgr.GetInstance():ReturnSpineChar(arg0_27.prefab, arg0_27._model)
	end

	arg0_27.state = var0_0.state_dispose
	arg0_27.parent = nil
end

function var0_0.start(arg0_28, arg1_28)
	arg0_28.state = var0_0.state_complete
	arg0_28._model = arg1_28
	arg0_28._animUI = arg1_28:GetComponent(typeof(SpineAnimUI))
	arg0_28._skeletonGraphic = arg1_28:GetComponent("SkeletonGraphic")

	if arg0_28.loadedParent then
		arg0_28:setParent(arg1_28, arg0_28.parent)

		arg0_28.loadedParent = nil
	end

	if arg0_28.loadedScale then
		arg0_28:setScale(arg0_28.loadedScale)

		arg0_28.loadedScale = nil
	end

	if arg0_28.loadedPosition then
		arg0_28:setPosition(arg0_28.loadedPosition)

		arg0_28.loadedPosition = nil
	end
end

function var0_0.updateCharDirect(arg0_29)
	if arg0_29.normalAction == arg0_29.actionName then
		arg0_29:SetAction(arg0_29.actionName, 0, -1)
	end
end

function var0_0.getDirectActonName(arg0_30, arg1_30)
	if not arg0_30.direct then
		arg0_30.direct = math.sign(tf(arg0_30._model).localScale.x)
	end

	local var0_30 = arg0_30.direct == 1 and "_R" or "_L"
	local var1_30 = arg1_30 .. var0_30

	if arg0_30._skeletonGraphic.SkeletonData:FindAnimation(var1_30) then
		return var1_30, true
	end

	return arg1_30, false
end

function var0_0.isComplete(arg0_31)
	return arg0_31.state == var0_0.state_complete
end

function var0_0.isDispose(arg0_32)
	return arg0_32.state == var0_0.state_dispose
end

return var0_0
