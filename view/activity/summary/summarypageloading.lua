local var0 = class("SummaryPageLoading", import(".SummaryPage"))
local var1 = 0.05

function var0.OnInit(arg0)
	arg0.textContainer = findTF(arg0._go, "texts")
	arg0.textTFs = {}

	eachChild(arg0.textContainer, function(arg0)
		setActive(arg0, false)
		table.insert(arg0.textTFs, 1, arg0)
	end)

	arg0.timers = {}

	setActive(arg0._go, false)
end

function var0.Show(arg0, arg1)
	arg0.inAniming = true

	setActive(arg0._tf, true)

	local var0 = {}

	for iter0, iter1 in ipairs(arg0.textTFs) do
		table.insert(var0, function(arg0)
			arg0.timers[iter0] = Timer.New(function()
				if arg0.timers[iter0] then
					arg0.timers[iter0]:Stop()

					arg0.timers[iter0] = nil
				end

				setActive(iter1, true)
				iter1:GetComponent(typeof(Typewriter)):setSpeed(0.015)
				arg0()
			end, var1 * iter0, 1)

			arg0.timers[iter0]:Start()
		end)
	end

	table.insert(var0, function(arg0)
		local var0 = arg0.textContainer:GetComponent(typeof(CanvasGroup))

		LeanTween.value(go(arg0.textContainer), 1, 0, 0.5):setOnUpdate(System.Action_float(function(arg0)
			var0.alpha = arg0
		end)):setOnComplete(System.Action(arg0)):setDelay(0.6)
	end)
	seriesAsync(var0, function()
		arg0.inAniming = nil

		arg1()
	end)
end

function var0.Hide(arg0, arg1)
	arg0:Clear()
	setActive(arg0._tf, false)
	arg1()
end

function var0.inAnim(arg0)
	return arg0.inAniming
end

function var0.Clear(arg0)
	for iter0, iter1 in pairs(arg0.timers) do
		iter1:Stop()
	end

	arg0.timers = {}
end

return var0
