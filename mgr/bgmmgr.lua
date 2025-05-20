pg = pg or {}

local var0_0 = pg

var0_0.BgmMgr = singletonClass("BgmMgr")

local var1_0 = var0_0.BgmMgr

function var1_0.Ctor(arg0_1)
	return
end

function var1_0.Init(arg0_2, arg1_2)
	print("initializing bgm manager...")
	arg0_2:Clear()
	arg1_2()
end

function var1_0.Clear(arg0_3)
	arg0_3._stack = {}
	arg0_3._dictionary = {}
	arg0_3._musicData = {}
	arg0_3._musicCallbackDic = {}
end

function var1_0.Push(arg0_4, arg1_4, arg2_4, arg3_4)
	if not arg0_4._dictionary[arg1_4] then
		table.insert(arg0_4._stack, arg1_4)
	end

	arg0_4._dictionary[arg1_4] = arg2_4
	arg0_4._musicData[arg1_4] = arg3_4

	arg0_4:CheckPlay()
end

function var1_0.Pop(arg0_5, arg1_5)
	if arg0_5._dictionary[arg1_5] then
		table.removebyvalue(arg0_5._stack, arg1_5)

		arg0_5._dictionary[arg1_5] = nil
		arg0_5._musicData[arg1_5] = nil

		arg0_5:CheckPlay()
	end
end

function var1_0.CheckPlay(arg0_6)
	if #arg0_6._stack == 0 then
		return
	end

	local var0_6 = arg0_6._stack[#arg0_6._stack]
	local var1_6 = arg0_6._dictionary[var0_6]
	local var2_6 = arg0_6._musicData[var0_6]

	if arg0_6.isDirty or arg0_6._now ~= var1_6 then
		arg0_6._now = var1_6
		arg0_6._nowData = var2_6

		arg0_6:ContinuePlay()
	end
end

function var1_0.TempPlay(arg0_7, arg1_7, arg2_7)
	arg0_7.isDirty = true

	arg0_7:FinalPlay(arg1_7, arg2_7)
end

function var1_0.StopPlay(arg0_8)
	arg0_8.isDirty = true

	arg0_8:FinalPause()
end

function var1_0.ContinuePlay(arg0_9)
	arg0_9.isDirty = false

	arg0_9:FinalPlay(arg0_9._now, arg0_9._nowData)
end

function var1_0.RegisterMusicCallback(arg0_10, arg1_10, arg2_10, arg3_10)
	for iter0_10, iter1_10 in pairs(arg3_10) do
		arg0_10._musicCallbackDic[iter0_10] = arg0_10._musicCallbackDic[iter0_10] or {}
		arg0_10._musicCallbackDic[iter0_10][arg2_10] = arg0_10._musicCallbackDic[iter0_10][arg2_10] or {}

		table.insert(arg0_10._musicCallbackDic[iter0_10][arg2_10], {
			iter1_10,
			arg1_10
		})
	end
end

function var1_0.UnregisterMusicCallback(arg0_11, arg1_11)
	for iter0_11, iter1_11 in pairs(arg0_11._musicCallbackDic) do
		for iter2_11, iter3_11 in pairs(iter1_11) do
			for iter4_11 = #iter3_11, 1, -1 do
				if iter3_11[iter4_11][2] == arg1_11 then
					table.remove(iter3_11, iter4_11)
				end
			end
		end
	end
end

function var1_0.GetNow(arg0_12)
	return arg0_12._now, arg0_12._nowData
end

function var1_0.GetPlayType(arg0_13, arg1_13)
	return switch(arg1_13, {
		MainMusicPlayer = function()
			return "music"
		end,
		TempMusicPlayer = function()
			return "music"
		end
	}, function()
		return "bgm"
	end)
end

function var1_0.FinalPlay(arg0_17, arg1_17, arg2_17)
	if not arg1_17 then
		return
	end

	local var0_17 = arg0_17:GetPlayType(arg1_17)

	if arg0_17.playType and arg0_17.playType ~= var0_17 then
		arg0_17:FinalPause()
	end

	arg0_17.playType = var0_17

	if arg0_17.playType == "music" then
		switch(arg1_17, {
			MainMusicPlayer = function()
				arg0_17:PlayMainMusicPlayer(arg2_17, arg1_17)
			end,
			TempMusicPlayer = function()
				arg0_17:NewMusicPlayer(arg2_17, arg1_17)
			end
		})
	elseif arg0_17.playType == "bgm" then
		var0_0.CriMgr.GetInstance():PlayBGM(arg1_17)
	end
end

function var1_0.FinalPause(arg0_20)
	if arg0_20.playType == "music" then
		arg0_20.musicPlayer:Pause()
	elseif arg0_20.playType == "bgm" then
		var0_0.CriMgr.GetInstance():StopBGM()
	end
end

function var1_0.GetMusicPlayer(arg0_21)
	return arg0_21.musicPlayer
end

function var1_0.PlayMainMusicPlayer(arg0_22, arg1_22, arg2_22)
	if arg0_22.musicPlayer and arg0_22.musicPlayer.music == arg2_22 then
		arg0_22.musicPlayer:ChangeData(arg1_22)

		arg0_22.musicPlayer.music = arg2_22

		if arg0_22.musicPlayer:IsPaused() then
			arg0_22.musicPlayer:Resume()
		else
			arg0_22.musicPlayer:Reflush(arg0_22.musicPlayer.index)
		end

		return arg0_22.musicPlayer
	else
		return arg0_22:NewMusicPlayer(arg1_22, arg2_22)
	end
end

function var1_0.NewMusicPlayer(arg0_23, arg1_23, arg2_23)
	arg0_23:RemoveMusicPlayer()

	local var0_23 = {}

	for iter0_23, iter1_23 in pairs(MusicPlayer.CALLBACK_DIC) do
		var0_23[iter0_23] = function(...)
			local var0_24 = checkExist(arg0_23._musicCallbackDic, {
				iter0_23
			}, {
				arg2_23
			})

			for iter0_24, iter1_24 in ipairs(var0_24 or {}) do
				iter1_24[1](...)
			end
		end
	end

	arg0_23.musicPlayer = MusicPlayer.New(arg1_23, var0_23)
	arg0_23.musicPlayer.music = arg2_23

	return arg0_23.musicPlayer
end

function var1_0.RemoveMusicPlayer(arg0_25)
	if not arg0_25.musicPlayer then
		return
	end

	arg0_25.musicPlayer:Dispose()

	arg0_25.musicPlayer = nil
end
