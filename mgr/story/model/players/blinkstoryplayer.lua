local var0_0 = class("BlinkStoryPlayer", import(".StoryPlayer"))

function var0_0.UpdateBg(arg0_1, arg1_1)
	var0_0.super.UpdateBg(arg0_1, arg1_1)

	arg0_1.blurOptimized = pg.UIMgr.GetInstance().cameraBlurs[pg.UIMgr.CameraOverlay][1]
	arg0_1.blurFlag = false

	local var0_1 = arg0_1.blurOptimized.downsample
	local var1_1 = arg0_1.blurOptimized.blurSize
	local var2_1 = arg0_1.blurOptimized.blurIterations

	arg0_1.defaultBlueValues = {
		downsample = var0_1,
		blurSize = var1_1,
		blurIterations = var2_1
	}
end

function var0_0.LoadEffects(arg0_2, arg1_2, arg2_2)
	parallelAsync({
		function(arg0_3)
			arg0_2:PlayOpenEyeEffect(arg1_2, arg0_3)
		end,
		function(arg0_4)
			var0_0.super.LoadEffects(arg0_2, arg1_2, arg0_4)
		end
	}, arg2_2)
end

function var0_0.PlayOpenEyeEffect(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg1_5:GetOpenEyeData()

	seriesAsync({
		function(arg0_6)
			arg0_5:LoadOpenEyeEffect(function(arg0_7)
				arg0_5.targetGo = arg0_7

				arg0_6()
			end)
		end,
		function(arg0_8)
			arg0_5:ApplyOpenEyeEffect(arg1_5, var0_5, arg0_5.targetGo, arg0_8)
		end,
		function(arg0_9)
			arg0_5:ClearTarget()
			arg0_9()
		end
	}, arg2_5)
end

function var0_0.ClearTarget(arg0_10)
	if arg0_10.targetGo then
		arg0_10.targetGo:GetComponent(typeof(Image)).material:SetFloat("_EyeClose", 1)
		Object.Destroy(arg0_10.targetGo)

		arg0_10.targetGo = nil
	end
end

function var0_0.LoadOpenEyeEffect(arg0_11, arg1_11)
	LoadAndInstantiateAsync("effect", "openEye", function(arg0_12)
		setParent(arg0_12, arg0_11.topEffectTr)

		arg0_12.transform.localScale = Vector3.one

		setActive(arg0_12, true)
		arg1_11(arg0_12)
	end)
end

local function var1_0(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13)
	arg0_13:TweenValueWithEase(arg0_13._go, arg2_13.x, arg2_13.y, arg2_13.z, 0, arg3_13, function(arg0_14)
		arg1_13:SetFloat("_EyeClose", arg0_14)
	end, arg4_13)
end

function var0_0.ApplyOpenEyeEffect(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	setActive(arg0_15.bgPanel, true)

	local var0_15 = arg2_15.open
	local var1_15 = arg2_15.close
	local var2_15 = arg2_15.hold
	local var3_15 = arg2_15.ease
	local var4_15 = arg3_15:GetComponent(typeof(Image)).material

	seriesAsync({
		function(arg0_16)
			parallelAsync({
				function(arg0_17)
					var1_0(arg0_15, var4_15, var1_15, var3_15, arg0_17)
				end,
				function(arg0_18)
					arg0_15:ClearToBlur(arg1_15, arg0_18)
				end
			}, arg0_16)
		end,
		function(arg0_19)
			parallelAsync({
				function(arg0_20)
					arg0_15:UpdateNextBg(arg1_15, arg0_20)
				end,
				function(arg0_21)
					var1_0(arg0_15, var4_15, var2_15, var3_15, arg0_21)
				end
			}, arg0_19)
		end,
		function(arg0_22)
			parallelAsync({
				function(arg0_23)
					var1_0(arg0_15, var4_15, var0_15, var3_15, arg0_23)
				end,
				function(arg0_24)
					arg0_15:BlurToClear(arg1_15, arg0_24)
				end
			}, arg0_22)
		end
	}, arg4_15)
end

function var0_0.ClearToBlur(arg0_25, arg1_25, arg2_25)
	arg0_25.blurFlag = true
	arg0_25.blurOptimized.downsample = 0
	arg0_25.blurOptimized.blurSize = 0
	arg0_25.blurOptimized.blurIterations = 0
	arg0_25.blurOptimized.enabled = true

	local var0_25 = arg1_25.closeTime
	local var1_25 = arg1_25.ease
	local var2_25 = arg1_25.blurTimeFactor[1]

	arg0_25:TweenValueWithEase(arg0_25._go, 0, 3, var0_25 * var2_25, 0, var1_25, function(arg0_26)
		arg0_25.blurOptimized.blurSize = arg0_26
		arg0_25.blurOptimized.blurIterations = arg0_26
	end, arg2_25)
end

function var0_0.BlurToClear(arg0_27, arg1_27, arg2_27)
	local var0_27 = arg1_27.openTime
	local var1_27 = arg1_27.ease
	local var2_27 = arg1_27.blurTimeFactor[2]

	arg0_27:TweenValueWithEase(arg0_27._go, 3, 0, var0_27 * var2_27, 0, var1_27, function(arg0_28)
		arg0_27.blurOptimized.blurSize = arg0_28
		arg0_27.blurOptimized.blurIterations = arg0_28
	end, function()
		arg0_27:ClearBlur()
		arg2_27()
	end)
end

function var0_0.ClearBlur(arg0_30)
	if arg0_30.blurFlag then
		arg0_30.blurOptimized.enabled = false
		arg0_30.blurOptimized.downsample = arg0_30.defaultBlueValues.downsample
		arg0_30.blurOptimized.blurSize = arg0_30.defaultBlueValues.blurSize
		arg0_30.blurOptimized.blurIterations = arg0_30.defaultBlueValues.blurIterations
		arg0_30.blurFlag = false
	end
end

function var0_0.UpdateNextBg(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg1_31:GetNextBgName()

	if not var0_31 then
		arg2_31()

		return
	end

	setActive(arg0_31.bgPanel, true)

	arg0_31.bgPanelCg.alpha = 1

	local var1_31 = arg0_31.bgImage

	var1_31.color = Color.New(1, 1, 1)
	var1_31.sprite = arg0_31:GetBg(var0_31)

	arg2_31()
end

function var0_0.RegisetEvent(arg0_32, arg1_32, arg2_32)
	arg2_32()
end

function var0_0.OnClear(arg0_33)
	arg0_33:ClearTarget()
	arg0_33:ClearBlur()
end

function var0_0.OnEnd(arg0_34)
	arg0_34:ClearTarget()
	arg0_34:ClearBlur()
end

return var0_0
