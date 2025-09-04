local var0_0 = class("MainAwakeSequenceView", import(".MainSequenceView"))

function var0_0.Ctor(arg0_1)
	arg0_1.sequence = {
		MainPlayerTestSequence.New(),
		MainCompatibleDataSequence.New(),
		MainRandomFlagShipSequence.New(),
		MainFixSettingDefaultValue.New()
	}
end

function var0_0.Execute(arg0_2, arg1_2)
	if not arg0_2.executable then
		arg0_2.executable = arg0_2:MapSequence(arg0_2.sequence)
	end

	seriesAsync(arg0_2.executable, arg1_2)
end

return var0_0
