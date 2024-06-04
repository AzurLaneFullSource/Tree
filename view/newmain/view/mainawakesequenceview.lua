local var0 = class("MainAwakeSequenceView", import(".MainSequenceView"))

function var0.Ctor(arg0)
	arg0.sequence = {
		MainCompatibleDataSequence.New(),
		MainRandomFlagShipSequence.New(),
		MainFixSettingDefaultValue.New()
	}
end

return var0
