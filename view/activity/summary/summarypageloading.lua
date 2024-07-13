local var0_0 = class("SummaryPageLoading", import(".SummaryPage"))
local var1_0 = 0.05

function var0_0.OnInit(arg0_1)
	arg0_1.textContainer = findTF(arg0_1._go, "texts")
	arg0_1.textTFs = {}

	eachChild(arg0_1.textContainer, function(arg0_2)
		setActive(arg0_2, false)
		table.insert(arg0_1.textTFs, 1, arg0_2)
	end)

	arg0_1.timers = {}

	setActive(arg0_1._go, false)
end

function var0_0.Show(arg0_3, arg1_3)
	arg0_3.inAniming = true

	setActive(arg0_3._tf, true)

	local var0_3 = {}

	for iter0_3, iter1_3 in ipairs(arg0_3.textTFs) do
		table.insert(var0_3, function(arg0_4)
			arg0_3.timers[iter0_3] = Timer.New(function()
				if arg0_3.timers[iter0_3] then
					arg0_3.timers[iter0_3]:Stop()

					arg0_3.timers[iter0_3] = nil
				end

				setActive(iter1_3, true)
				iter1_3:GetComponent(typeof(Typewriter)):setSpeed(0.015)
				arg0_4()
			end, var1_0 * iter0_3, 1)

			arg0_3.timers[iter0_3]:Start()
		end)
	end

	table.insert(var0_3, function(arg0_6)
		local var0_6 = arg0_3.textContainer:GetComponent(typeof(CanvasGroup))

		LeanTween.value(go(arg0_3.textContainer), 1, 0, 0.5):setOnUpdate(System.Action_float(function(arg0_7)
			var0_6.alpha = arg0_7
		end)):setOnComplete(System.Action(arg0_6)):setDelay(0.6)
	end)
	seriesAsync(var0_3, function()
		arg0_3.inAniming = nil

		arg1_3()
	end)
end

function var0_0.Hide(arg0_9, arg1_9)
	arg0_9:Clear()
	setActive(arg0_9._tf, false)
	arg1_9()
end

function var0_0.inAnim(arg0_10)
	return arg0_10.inAniming
end

function var0_0.Clear(arg0_11)
	for iter0_11, iter1_11 in pairs(arg0_11.timers) do
		iter1_11:Stop()
	end

	arg0_11.timers = {}
end

return var0_0
