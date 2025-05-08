TimelineSupport = {}

local var0_0 = TimelineSupport

function var0_0.InitTimeline(arg0_1)
	var0_0.DynamicBinding(arg0_1)
end

function var0_0.EachSubDirector(arg0_2, arg1_2)
	eachChild(arg0_2, function(arg0_3)
		local var0_3 = arg0_3:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		if not var0_3 then
			return
		end

		table.IpairsCArray(TimelineHelper.GetTimelineTracks(var0_3), function(arg0_4, arg1_4)
			arg1_2(arg0_4, arg1_4)
		end)
		var0_0.EachSubDirector(var0_3, arg1_2)
	end)
end

function var0_0.DynamicBinding(arg0_5)
	local var0_5 = _.reduce(pg.dorm3d_timeline_dynamic_binding, {}, function(arg0_6, arg1_6)
		if arg1_6.track_name then
			arg0_6[arg1_6.track_name] = arg1_6.object_name
		end

		return arg0_6
	end)

	eachChild(arg0_5, function(arg0_7)
		local var0_7 = arg0_7:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		if not var0_7 then
			return
		end

		table.IpairsCArray(TimelineHelper.GetTimelineTracks(var0_7), function(arg0_8, arg1_8)
			if var0_5[arg1_8.name] then
				local var0_8 = GameObject.Find(var0_5[arg1_8.name])

				if var0_8 then
					TimelineHelper.SetSceneBinding(var0_7, arg1_8, var0_8)
				else
					warning(string.format("轨道%s需要绑定的物体%s不存在", arg1_8.name, var0_5[arg1_8.name]))
				end
			end
		end)
	end)
end

function var0_0.InitSubtitle(arg0_9, arg1_9)
	local var0_9 = GameObject.Find("[subtitle]")

	if var0_9 then
		var0_9:GetComponent(typeof(Canvas)).worldCamera = pg.UIMgr.GetInstance().overlayCameraComp
	end

	local function var1_9(arg0_10)
		local var0_10 = tonumber(arg0_10)

		if not var0_10 then
			return arg0_10
		end

		local var1_10 = pg.dorm3d_subtitle[var0_10].subtitle

		return (HXSet.hxLan(string.gsub(var1_10, "$dorm3d", arg1_9)))
	end

	BLHXTimeline.SubtitleMixer.func = var1_9
end

function var0_0.CheckTrackType(arg0_11, arg1_11)
	return tostring(arg0_11:GetType()) == arg1_11
end

function var0_0.InitCriAtomTrack(arg0_12)
	var0_0.EachSubDirector(arg0_12, function(arg0_13, arg1_13)
		if var0_0.CheckTrackType(arg1_13, "BLHXTimeline.BLHXCriAtomTrack") then
			local var0_13 = ReflectionHelp.RefCallMethod(typeof("BLHXTimeline.BLHXCriAtomTrack"), "GetClips", arg1_13)

			table.IpairsCArray(var0_13, function(arg0_14, arg1_14)
				local var0_14 = ReflectionHelp.RefGetProperty(arg1_14:GetType(), "asset", arg1_14)
				local var1_14 = ReflectionHelp.RefGetField(typeof("BLHXTimeline.BLHXCriAtomClip"), "cueSheet", var0_14)

				pg.CriMgr.GetInstance():LoadCueSheet(var1_14, nil, true)
			end)
		end
	end)
end

function var0_0.UnloadPlayable(arg0_15)
	var0_0.UnloadCriAtomTrack(arg0_15)
end

function var0_0.UnloadCriAtomTrack(arg0_16)
	var0_0.EachSubDirector(arg0_16, function(arg0_17, arg1_17)
		if var0_0.CheckTrackType(arg1_17, "BLHXTimeline.BLHXCriAtomTrack") then
			local var0_17 = ReflectionHelp.RefCallMethod(typeof("BLHXTimeline.BLHXCriAtomTrack"), "GetClips", arg1_17)

			table.IpairsCArray(var0_17, function(arg0_18, arg1_18)
				local var0_18 = ReflectionHelp.RefGetProperty(arg1_18:GetType(), "asset", arg1_18)
				local var1_18 = ReflectionHelp.RefGetField(typeof("BLHXTimeline.BLHXCriAtomClip"), "cueSheet", var0_18)

				pg.CriMgr.GetInstance():UnloadCueSheet(var1_18)
			end)
		end
	end)
end
