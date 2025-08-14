local var0_0 = class("MusicBeatGameScene")
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1
	arg0_1.sceneMask = findTF(arg0_1._tf, "sceneMask")
	arg0_1.sceneContainer = findTF(arg0_1._tf, "sceneMask/sceneContainer")

	arg0_1:showContainer(false)

	arg0_1.bgmController = MusicBeatBgmCtrl.New(arg0_1._event)
	arg0_1.mapController = MusicBeatMapCtrl.New(arg0_1.sceneContainer, arg0_1._event)
	arg0_1.noteController = MusicBeatNoteCtrl.New(arg0_1.sceneContainer, arg0_1._event)

	arg0_1.bgmController:setGameVo(arg0_1._gameVo)
	arg0_1.mapController:setGameVo(arg0_1._gameVo)
	arg0_1.noteController:setGameVo(arg0_1._gameVo)
end

function var0_0.readyStart(arg0_2)
	arg0_2:showContainer(true)
	arg0_2.bgmController:readyStart()
	arg0_2.mapController:readyStart()
	arg0_2.noteController:readyStart()
end

function var0_0.start(arg0_3)
	arg0_3.bgmController:start()
	arg0_3.mapController:start()
	arg0_3.noteController:start()
end

function var0_0.step(arg0_4, arg1_4)
	arg0_4.bgmController:step(arg1_4)
	arg0_4.mapController:step(arg1_4)
	arg0_4.noteController:step(arg1_4)
end

function var0_0.clear(arg0_5)
	arg0_5.bgmController:clear()
	arg0_5.mapController:clear()
	arg0_5.noteController:clear()
end

function var0_0.stop(arg0_6)
	arg0_6.bgmController:stop()
	arg0_6.mapController:stop()
	arg0_6.noteController:stop()
end

function var0_0.resume(arg0_7)
	arg0_7.bgmController:resume()
	arg0_7.mapController:resume()
	arg0_7.noteController:resume()
end

function var0_0.dispose(arg0_8)
	arg0_8.bgmController:dispose()
	arg0_8.mapController:dispose()
	arg0_8.noteController:dispose()
end

function var0_0.showContainer(arg0_9, arg1_9)
	setActive(arg0_9.sceneMask, arg1_9)
end

return var0_0
