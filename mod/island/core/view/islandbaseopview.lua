local var0_0 = class("IslandBaseOpView", import(".IslandBaseSubView"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)
	arg0_1:Init()

	arg0_1.enableCnt = 0
end

function var0_0.DoInit(arg0_2, arg1_2, arg2_2)
	var0_0.super.DoInit(arg0_2, arg1_2, arg2_2)

	if arg0_2:GetEnterAnimationName() or arg0_2:GetExitAnimationName() then
		arg0_2.animataion = arg1_2:GetComponent(typeof(Animation))
		arg0_2.dftAniEvent = arg0_2.animataion:GetComponent(typeof(DftAniEvent))
	end
end

function var0_0.SetUIParent(arg0_3, arg1_3)
	return arg0_3:GetView().opContainer
end

function var0_0.TryDisable(arg0_4, arg1_4)
	if arg0_4.exiting then
		return
	end

	arg0_4.enableCnt = arg0_4.enableCnt - 1

	if arg0_4.enableCnt == 0 then
		arg0_4.exiting = true

		arg0_4:HideUI(arg1_4, function()
			arg0_4.exiting = false

			arg0_4:OnDisable()
		end)
	end
end

function var0_0.CloseAndReset(arg0_6)
	if arg0_6.enableCnt <= 0 then
		return
	end

	arg0_6.enableCnt = 1

	arg0_6:TryDisable()
end

function var0_0.TryEnable(arg0_7)
	arg0_7.enableCnt = arg0_7.enableCnt + 1

	if arg0_7.enableCnt == 1 then
		arg0_7:ShowUI()
		arg0_7:OnEnable()
	end
end

function var0_0.ShowOrHideGameObject(arg0_8, arg1_8, arg2_8)
	local var0_8 = GetOrAddComponent(arg1_8, typeof(CanvasGroup))

	var0_8.alpha = arg2_8 and 1 or 0
	var0_8.blocksRaycasts = arg2_8
end

function var0_0.HideUI(arg0_9, arg1_9, arg2_9)
	arg1_9 = defaultValue(arg1_9, true)

	if arg1_9 then
		arg0_9:PlayExitAnimation(function()
			arg0_9:ShowOrHideGameObject(arg0_9._go, false)
			arg2_9()
		end)
	else
		arg0_9:ShowOrHideGameObject(arg0_9._go, false)
		arg2_9()
	end
end

function var0_0.ShowUI(arg0_11)
	arg0_11:PlayeEnterAnimation()
	arg0_11:ShowOrHideGameObject(arg0_11._go, true)
end

function var0_0.PlayeEnterAnimation(arg0_12)
	local var0_12 = arg0_12:GetEnterAnimationName()

	if var0_12 then
		arg0_12.animataion:Play(var0_12)
	end
end

function var0_0.PlayExitAnimation(arg0_13, arg1_13)
	local var0_13 = arg0_13:GetExitAnimationName()

	if var0_13 then
		arg0_13.dftAniEvent:SetEndEvent(function()
			arg0_13.dftAniEvent:SetEndEvent(nil)
			arg1_13()
		end)
		arg0_13.animataion:Play(var0_13)
	else
		arg1_13()
	end
end

function var0_0.OnBeforeLoaded(arg0_15)
	arg0_15.enableCnt = 1
end

function var0_0.OnDispose(arg0_16)
	var0_0.super.OnDispose(arg0_16)

	if arg0_16.dftAniEvent then
		arg0_16.dftAniEvent:SetEndEvent(nil)
	end
end

function var0_0.OnDisable(arg0_17)
	return
end

function var0_0.OnEnable(arg0_18)
	return
end

function var0_0.GetEnterAnimationName(arg0_19)
	return nil
end

function var0_0.GetExitAnimationName(arg0_20)
	return nil
end

return var0_0
