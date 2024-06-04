local var0 = class("CommanderCatPlayAnimation")
local var1 = 0.3

function var0.Ctor(arg0, arg1)
	arg0.expSlider = arg1
end

function var0.Action(arg0, arg1, arg2, arg3)
	if arg2.level - arg1.level > 0 then
		arg0:DoLevelOffsetAnimation(arg1, arg2, arg3)
	else
		arg0:DoSameLevelAnimation(arg1, arg2, arg3)
	end
end

function var0.DoLevelOffsetAnimation(arg0, arg1, arg2, arg3)
	local var0 = arg2.level - arg1.level
	local var1 = {}

	table.insert(var1, function(arg0)
		local var0 = arg1:getNextLevelExp()

		TweenValue(go(arg0.expSlider), arg1.exp, var0, var1, 0, function(arg0)
			arg0.expSlider.value = arg0
		end, arg0)
	end)

	for iter0 = 1, var0 - 1 do
		table.insert(var1, function(arg0)
			TweenValue(go(arg0.expSlider), 0, 1, var1, 0, function(arg0)
				arg0.expSlider.value = arg0
			end, arg0)
		end)
	end

	table.insert(var1, function(arg0)
		local var0 = arg2:getNextLevelExp()

		TweenValue(go(arg0.expSlider), 0, arg2.exp, var1, 0, function(arg0)
			arg0.expSlider.value = arg0 / var0
		end, arg0)
	end)
	seriesAsync(var1, arg3)
end

function var0.DoSameLevelAnimation(arg0, arg1, arg2, arg3)
	local var0 = arg1:getNextLevelExp()

	TweenValue(go(arg0.expSlider), arg1.exp, arg2.exp, var1, 0, function(arg0)
		arg0.expSlider.value = arg0 / var0
	end, arg3)
end

function var0.Dispose(arg0)
	if LeanTween.isTweening(arg0.expSlider.gameObject) then
		LeanTween.cancel(arg0.expSlider.gameObject)
	end
end

return var0
