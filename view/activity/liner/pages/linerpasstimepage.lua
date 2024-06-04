local var0 = class("LinerPassTimePage", import("view.base.BaseSubView"))

var0.ANIM_TIME = 0.75
var0.DELAY_TIME = 0.5

function var0.getUIName(arg0)
	return "LinerPassTimePage"
end

function var0.OnLoaded(arg0)
	arg0.rotateTF = arg0:findTF("progress/Image")
	arg0.dayTF = arg0:findTF("time/day")

	setText(arg0.dayTF, "DAY")

	arg0.beforeDay = arg0:findTF("time/day_1")
	arg0.afterDay = arg0:findTF("time/day_2")
	arg0.pointTF = arg0:findTF("time/point")
	arg0.pointAfterTF = arg0:findTF("time/point_after")
	arg0.timeAnim = arg0:findTF("time"):GetComponent(typeof(Animation))
	arg0.anim = arg0._tf:GetComponent(typeof(Animation))
	arg0.animEvent = arg0._tf:GetComponent(typeof(DftAniEvent))

	arg0.animEvent:SetEndEvent(function()
		arg0:Hide()
	end)
end

function var0.OnInit(arg0)
	return
end

function var0.ShowAnim(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg1:GetDayByIdx(arg3)
	local var1 = arg1:GetTimeByIdx(arg2)
	local var2 = arg1:GetTimeByIdx(arg3)
	local var3 = var1:GetType() == LinerTime.TYPE.STORY and var0 - 1 or var0

	setText(arg0.beforeDay, string.format("%02d", var3))
	setText(arg0.afterDay, string.format("%02d", var3))
	setText(arg0.pointTF, var1:GetStartTimeDesc())
	setText(arg0.pointAfterTF, var1:GetStartTimeDesc())

	local var4 = var1:GetTime()[1]
	local var5 = var2:GetTime()[1]
	local var6 = var3 == var0 and "anim_passtime_change" or "anim_passtime_change1"
	local var7 = var4 > 3 and var4 or var4 + 24
	local var8 = var5 > 3 and var5 or var5 + 24
	local var9 = var7 - 8
	local var10 = var8 - 8
	local var11 = math.floor(var9 * 180 / 19)
	local var12 = math.floor(var10 * 180 / 19)

	setLocalEulerAngles(arg0.rotateTF, {
		z = -var11
	})
	arg0:Show()
	seriesAsync({
		function(arg0)
			arg0:managedTween(LeanTween.delayedCall, function()
				arg0()
			end, 0.4, nil)
		end,
		function(arg0)
			if var11 > var12 then
				arg0:managedTween(LeanTween.delayedCall, function()
					setLocalEulerAngles(arg0.rotateTF, {
						z = -var12
					})
					arg0()
					setText(arg0.afterDay, string.format("%02d", var0))
					setText(arg0.pointAfterTF, var2:GetStartTimeDesc())
					arg0.timeAnim:Play(var6)
				end, var0.ANIM_TIME, nil)
			else
				arg0:managedTween(LeanTween.value, nil, go(arg0.rotateTF), var11, var12, var0.ANIM_TIME):setOnUpdate(System.Action_float(function(arg0)
					setLocalEulerAngles(arg0.rotateTF, {
						z = -arg0
					})
				end)):setEase(LeanTweenType.easeInOutCubic):setOnComplete(System.Action(function()
					arg0()
				end))
				setText(arg0.afterDay, string.format("%02d", var0))
				setText(arg0.pointAfterTF, var2:GetStartTimeDesc())
				arg0.timeAnim:Play(var6)
			end
		end,
		function(arg0)
			arg0:managedTween(LeanTween.delayedCall, function()
				arg0()
			end, var0.DELAY_TIME, nil)
		end
	}, function()
		if arg4 then
			arg4()
		end

		arg0.anim:Play("anim_passtime_out")
	end)
end

function var0.Show(arg0)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.OnDestroy(arg0)
	return
end

return var0
