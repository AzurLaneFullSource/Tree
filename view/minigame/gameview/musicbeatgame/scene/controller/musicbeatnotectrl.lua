local var0_0 = class("MusicBeatNoteCtrl")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._content = arg1_1
	arg0_1._event = arg2_1

	arg0_1._event:bind(MusicBeatGameEvent.TRACK_EVENT_MATCH, function(arg0_2, arg1_2, arg2_2)
		if arg1_2 then
			local var0_2 = arg1_2.id

			for iter0_2 = 1, #arg0_1.prepareTracks do
				if arg0_1.prepareTracks[iter0_2].id == var0_2 then
					local var1_2 = arg0_1.prepareTracks[iter0_2]
					local var2_2, var3_2 = arg0_1:matchTrack(var1_2)

					print("match is " .. tostring(var2_2) .. " subtime is " .. var3_2)

					if arg2_2 then
						arg2_2(var2_2, var3_2)
					end

					return
				end
			end
		end
	end)
end

function var0_0.setGameVo(arg0_3, arg1_3)
	arg0_3._gameVo = arg1_3
end

function var0_0.readyStart(arg0_4)
	arg0_4:clear()

	arg0_4.mapData = arg0_4._gameVo:getMapData()
	arg0_4.nodeData = arg0_4._gameVo:getNodeData()
	arg0_4.beatOffset = MusicBeatGameConst.beat_offset

	arg0_4:createTrackList()
end

function var0_0.start(arg0_5)
	return
end

function var0_0.step(arg0_6, arg1_6)
	if arg0_6._gameVo:isBgmPlaying() then
		if arg0_6.trackData == nil and #arg0_6.trackList > 0 then
			arg0_6.trackData = table.remove(arg0_6.trackList, 1)
		end

		if arg0_6.trackData then
			local var0_6 = arg0_6._gameVo:getCriInfoTime()
			local var1_6 = arg0_6.trackData.begin_time - var0_6

			if var1_6 >= 0 and var1_6 <= MusicBeatGameConst.beat_prepare then
				arg0_6._event:emit(MusicBeatGameEvent.TRACK_TRIGGER, {
					track = arg0_6.trackData,
					final = #arg0_6.trackList <= 0
				})
				table.insert(arg0_6.prepareTracks, arg0_6.trackData)

				arg0_6.trackData = nil
			elseif var1_6 <= 0 and arg0_6.trackData.begin_time == arg0_6.trackData.end_time and math.abs(var1_6) >= arg0_6.beatOffset then
				arg0_6._event:emit(MusicBeatGameEvent.TRACK_REMOVE, arg0_6.trackData)

				arg0_6.trackData = nil
			end
		end
	end

	if #arg0_6.prepareTracks > 0 then
		local var2_6 = arg0_6._gameVo:getCriInfoTime()

		for iter0_6 = #arg0_6.prepareTracks, 1, -1 do
			if var2_6 - arg0_6.prepareTracks[iter0_6].end_time >= arg0_6.beatOffset then
				local var3_6 = table.remove(arg0_6.prepareTracks, iter0_6)
			end
		end
	end
end

function var0_0.clear(arg0_7)
	arg0_7.trackData = nil
	arg0_7.trackIndex = 0
	arg0_7.prepareTracks = {}
end

function var0_0.stop(arg0_8)
	return
end

function var0_0.resume(arg0_9)
	return
end

function var0_0.dispose(arg0_10)
	return
end

function var0_0.matchTrack(arg0_11, arg1_11)
	local var0_11 = arg0_11._gameVo:getCriInfoTime()

	if var0_11 > 0 then
		local var1_11
		local var2_11

		if arg1_11.begin_time == arg1_11.end_time then
			local var3_11 = arg1_11.begin_time

			var2_11 = math.abs(var3_11 - var0_11)

			if var2_11 <= arg0_11.beatOffset then
				return true, var2_11
			end
		elseif arg1_11.data.begin_time ~= arg1_11.data.end_time then
			local var4_11 = arg1_11.matchBegin and arg1_11.data.end_time or arg1_11.data.begin_time

			var2_11 = math.abs(var4_11 - var0_11)

			if var2_11 <= arg0_11.beatOffset then
				if not arg1_11.matchBegin then
					arg1_11.matchBegin = true
				end

				return true, var2_11
			end
		end

		return false, var2_11
	end

	return false, nil
end

function var0_0.createTrackList(arg0_12)
	local var0_12 = Clone(arg0_12.nodeData.touch_track)

	arg0_12.trackList = {}

	for iter0_12, iter1_12 in ipairs(var0_12) do
		table.insert(arg0_12.trackList, {
			key_flag = iter1_12.key_flag,
			key_index = iter1_12.key_index,
			begin_time = math.floor(tonumber(iter1_12.begin_time) * 1000),
			end_time = math.floor(tonumber(iter1_12.end_time) * 1000),
			id = iter0_12
		})
	end
end

return var0_0
