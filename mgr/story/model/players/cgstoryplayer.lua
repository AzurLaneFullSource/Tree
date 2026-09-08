local var0_0 = class("CGStoryPlayer", import(".StoryPlayer"))

function var0_0.OnReset(arg0_1, arg1_1, arg2_1, arg3_1)
	setActive(arg0_1.frontTr, false)

	arg0_1.color = arg0_1.mainImg.color
	arg0_1.mainImg.color = Color.New(1, 1, 1, 0)

	arg3_1()
end

function var0_0.OnInit(arg0_2, arg1_2, arg2_2, arg3_2)
	seriesAsync({
		function(arg0_3)
			gcAll(true)
			onNextTick(arg0_3)
		end,
		function(arg0_4)
			arg0_2:LoadCGUI(arg0_4)
		end,
		function(arg0_5)
			arg0_2:PlayCGAnimation(arg1_2, arg0_5)
		end,
		function(arg0_6)
			arg0_2:ClearCGUI()
			arg0_6()
		end
	}, arg3_2)
end

function var0_0.LoadCGUI(arg0_7, arg1_7)
	if arg0_7.cgUI and not IsNil(arg0_7.cgUI) then
		arg1_7()

		return
	end

	LoadAndInstantiateAsync("ui", "StoryCGPlayerUI", function(arg0_8)
		arg0_7.cgUI = arg0_8
		arg0_7.cgTF = arg0_8.transform

		arg0_7.cgTF:SetParent(arg0_7._tf, false)

		arg0_7.cgPlayer = ReFluxCGPlayer.New(arg0_8)

		arg1_7()
	end, true, true)
end

function var0_0.PlayCGAnimation(arg0_9, arg1_9, arg2_9)
	arg0_9.cgPlayer:Play(arg1_9:GetBgs(), arg2_9)
end

function var0_0.RegisetEvent(arg0_10, arg1_10, arg2_10)
	var0_0.super.RegisetEvent(arg0_10, arg1_10, arg2_10)
	triggerButton(arg0_10._go)
end

function var0_0.ClearCGUI(arg0_11)
	if arg0_11.cgUI == nil then
		return
	end

	if arg0_11.cgUI and not IsNil(arg0_11.cgUI) then
		Object.Destroy(arg0_11.cgUI)
	end

	if arg0_11.cgPlayer then
		arg0_11.cgPlayer:Dispose()

		arg0_11.cgPlayer = nil
	end

	arg0_11.cgUI = nil
	arg0_11.cgTF = nil
	arg0_11.mainImg.color = arg0_11.color

	gcAll()
end

function var0_0.OnClear(arg0_12)
	arg0_12:ClearCGUI()
end

function var0_0.OnEnd(arg0_13)
	arg0_13:ClearCGUI()
end

return var0_0
