local var0_0 = class("MusicBeatBgmCtrl")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1._event = arg1_1
end

function var0_0.setGameVo(arg0_2, arg1_2)
	arg0_2._gameVo = arg1_2
end

function var0_0.readyStart(arg0_3)
	arg0_3:clear()

	arg0_3.nodeData = arg0_3._gameVo:getNodeData()

	arg0_3:loadAndPlayMusic(arg0_3.nodeData.music_name, 0)
end

function var0_0.start(arg0_4)
	return
end

function var0_0.step(arg0_5, arg1_5)
	if arg0_5.criInfo and arg0_5.criInfo:GetTime() >= arg0_5.criInfo:GetLength() then
		arg0_5._event:emit(MusicBeatGameEvent.GAME_OVER)
	end
end

function var0_0.clear(arg0_6)
	if arg0_6.criInfo then
		pg.CriMgr.GetInstance():UnloadCueSheet(arg0_6.nodeData.music_name)
		arg0_6.criInfo:PlaybackStop()
	end

	arg0_6.criInfo = nil

	arg0_6._gameVo:setBgmPlay(false)
	arg0_6._gameVo:setCriInfo(nil)
end

function var0_0.stop(arg0_7)
	arg0_7:stopMusic()
end

function var0_0.resume(arg0_8)
	arg0_8:loadAndPlayMusic(arg0_8.nodeData.music_name, arg0_8.pauseTime or 0)
end

function var0_0.loadAndPlayMusic(arg0_9, arg1_9, arg2_9)
	CriWareMgr.Inst:PlayBGM(arg1_9, CriWareMgr.CRI_FADE_TYPE.FADE_INOUT, function(arg0_10)
		if arg0_10 == nil then
			warning("Missing BGM :" .. (arg1_9 or "NIL"))
		else
			print("加载完毕,开始播放音乐")

			if arg0_9.countingfive_flag then
				return
			end

			arg0_9.criInfo = arg0_10
			arg0_9.cirInfoLength = arg0_10:GetLength()

			arg0_9.criInfo:PlaybackStop()
			arg0_9.criInfo:SetStartTimeAndPlay(arg2_9)
			arg0_9._gameVo:setCriInfo(arg0_10)
			arg0_9._gameVo:setBgmPlay(true)
		end
	end)
end

function var0_0.stopMusic(arg0_11)
	if arg0_11.criInfo then
		arg0_11.pauseTime = arg0_11.criInfo:GetTime()

		arg0_11.criInfo:PlaybackStop()
		arg0_11._gameVo:setBgmPlay(false)
	else
		print("cri info不存在")
	end
end

function var0_0.dispose(arg0_12)
	if arg0_12.criInfo then
		pg.CriMgr.GetInstance():UnloadCueSheet(arg0_12.nodeData.music_name)
	end
end

return var0_0
