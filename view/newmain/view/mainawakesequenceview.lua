local var0_0 = class("MainAwakeSequenceView", import(".MainSequenceView"))

function var0_0.Ctor(arg0_1)
	arg0_1.sequence = {
		MainCompatibleDataSequence.New(),
		MainRandomFlagShipSequence.New(),
		MainFixSettingDefaultValue.New()
	}
end

return var0_0
