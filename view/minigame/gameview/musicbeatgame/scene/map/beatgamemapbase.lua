local var0_0 = class("BeatGameMapBase")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._data = arg3_1
	arg0_1._trackDic = {}

	arg0_1:onInit()
end

function var0_0.addScore(arg0_2, arg1_2)
	if arg1_2 > 0 then
		arg0_2._event:emit(MusicBeatGameEvent.ADD_SCORE, {
			num = arg1_2
		})
	end
end

function var0_0.startTrack(arg0_3, arg1_3)
	arg0_3:onStartTrack(arg1_3)
end

function var0_0.setGameVo(arg0_4, arg1_4)
	arg0_4._gameVo = arg1_4
end

function var0_0.setSelect(arg0_5, arg1_5)
	arg0_5._selectFlag = arg1_5

	setActive(arg0_5._tf, arg1_5)
	arg0_5:onSelectChange()
end

function var0_0.clear(arg0_6)
	arg0_6._trackDic = {}

	arg0_6:onClear()
end

function var0_0.dispose(arg0_7)
	arg0_7:onDispose()

	arg0_7._tf = nil
	arg0_7._data = nil
	arg0_7._event = nil
end

function var0_0.step(arg0_8)
	arg0_8:onStep()
end

function var0_0.start(arg0_9)
	arg0_9:onStart()
end

function var0_0.stop(arg0_10)
	arg0_10:onStop()
end

function var0_0.resume(arg0_11)
	arg0_11:onResume()
end

function var0_0.onInit(arg0_12)
	return
end

function var0_0.onStart(arg0_13)
	return
end

function var0_0.onStop(arg0_14)
	return
end

function var0_0.onResume(arg0_15)
	return
end

function var0_0.onStartTrack(arg0_16, arg1_16)
	return
end

function var0_0.onSelectChange(arg0_17)
	return
end

function var0_0.onClear(arg0_18)
	return
end

function var0_0.onDispose(arg0_19)
	return
end

function var0_0.onStep(arg0_20)
	return
end

return var0_0
