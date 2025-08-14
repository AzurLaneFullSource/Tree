local var0_0 = class("MusicBeatMapCtrl")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1

	arg0_1._event:bind(MusicBeatGameEvent.TRACK_TRIGGER, function(arg0_2, arg1_2, arg2_2)
		arg0_1.selectScene:startTrack(arg1_2)
	end)
	arg0_1._event:bind(MusicBeatGameEvent.TRACK_REMOVE, function(arg0_3, arg1_3, arg2_3)
		return
	end)
end

function var0_0.setGameVo(arg0_4, arg1_4)
	arg0_4._gameVo = arg1_4
end

function var0_0.readyStart(arg0_5)
	arg0_5:clear()

	arg0_5.mapData = arg0_5._gameVo:getMapData()

	arg0_5:loadMapScene(arg0_5.mapData.map_scene)
	arg0_5:setSelectScene(1)

	for iter0_5 = 1, #arg0_5.mapScenes do
		arg0_5.mapScenes[iter0_5]:start()
	end
end

function var0_0.start(arg0_6)
	return
end

function var0_0.step(arg0_7, arg1_7)
	for iter0_7 = 1, #arg0_7.mapScenes do
		arg0_7.mapScenes[iter0_7]:step()
	end
end

function var0_0.clear(arg0_8)
	arg0_8:clearMapScene()

	arg0_8.curMapScene = nil
end

function var0_0.stop(arg0_9)
	for iter0_9 = 1, #arg0_9.mapScenes do
		arg0_9.mapScenes[iter0_9]:stop()
	end
end

function var0_0.resume(arg0_10)
	for iter0_10 = 1, #arg0_10.mapScenes do
		arg0_10.mapScenes[iter0_10]:step()
	end
end

function var0_0.dispose(arg0_11)
	for iter0_11 = 1, #arg0_11.mapScenes do
		arg0_11.mapScenes[iter0_11]:dispose()
	end
end

function var0_0.loadMapScene(arg0_12, arg1_12)
	arg0_12:clearMapScene()

	for iter0_12, iter1_12 in ipairs(arg1_12) do
		local var0_12 = iter1_12.type
		local var1_12 = iter1_12.name
		local var2_12 = findTF(arg0_12._tf, var1_12)
		local var3_12

		if var0_12 == MusicBeatGameConst.map_type_plane then
			var3_12 = BeatGameMapPlane.New(var2_12, arg0_12._event, iter1_12)
		end

		if var3_12 then
			var3_12:setGameVo(arg0_12._gameVo)
			table.insert(arg0_12.mapScenes, var3_12)
		end
	end
end

function var0_0.clearMapScene(arg0_13)
	if arg0_13.mapScenes then
		for iter0_13, iter1_13 in ipairs(arg0_13.mapScenes) do
			if iter1_13 then
				iter1_13:clear()
			end
		end
	end

	arg0_13.mapScenes = {}
end

function var0_0.setSelectScene(arg0_14, arg1_14)
	if arg0_14.selectScene then
		arg0_14.selectScene:setSelect(false)
	end

	arg0_14.selectScene = arg0_14.mapScenes[arg1_14]

	arg0_14.selectScene:setSelect(true)
end

return var0_0
