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
			arg1_2(arg0_4, arg1_4, var0_3)
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

	var0_0.EachSubDirector(arg0_5, function(arg0_7, arg1_7, arg2_7)
		if var0_5[arg1_7.name] then
			local var0_7 = GameObject.Find(var0_5[arg1_7.name])

			if var0_7 then
				TimelineHelper.SetSceneBinding(arg2_7, arg1_7, var0_7)
			else
				warning(string.format("轨道%s需要绑定的物体%s不存在", arg1_7.name, var0_5[arg1_7.name]))
			end
		end
	end)
end

function var0_0.InitSubtitle(arg0_8, arg1_8)
	local var0_8 = GameObject.Find("[subtitle]")

	if var0_8 then
		var0_8:GetComponent(typeof(Canvas)).worldCamera = pg.UIMgr.GetInstance().overlayCameraComp
	end

	local function var1_8(arg0_9)
		local var0_9 = tonumber(arg0_9)

		if not var0_9 then
			return arg0_9
		end

		local var1_9 = pg.dorm3d_subtitle[var0_9].subtitle

		return (HXSet.hxLan(string.gsub(var1_9, "$dorm3d", arg1_8)))
	end

	BLHXTimeline.SubtitleMixer.func = var1_8
end

function var0_0.CheckTrackType(arg0_10, arg1_10)
	return tostring(arg0_10:GetType()) == arg1_10
end

function var0_0.InitCriAtomTrack(arg0_11)
	var0_0.EachSubDirector(arg0_11, function(arg0_12, arg1_12)
		if var0_0.CheckTrackType(arg1_12, "BLHXTimeline.BLHXCriAtomTrack") then
			local var0_12 = ReflectionHelp.RefCallMethod(typeof("BLHXTimeline.BLHXCriAtomTrack"), "GetClips", arg1_12)

			table.IpairsCArray(var0_12, function(arg0_13, arg1_13)
				local var0_13 = ReflectionHelp.RefGetProperty(arg1_13:GetType(), "asset", arg1_13)
				local var1_13 = ReflectionHelp.RefGetField(typeof("BLHXTimeline.BLHXCriAtomClip"), "cueSheet", var0_13)

				pg.CriMgr.GetInstance():LoadCueSheet(var1_13, nil, true)
			end)
		end
	end)
end

function var0_0.UnloadPlayable(arg0_14)
	var0_0.UnloadCriAtomTrack(arg0_14)
end

function var0_0.UnloadCriAtomTrack(arg0_15)
	var0_0.EachSubDirector(arg0_15, function(arg0_16, arg1_16)
		if var0_0.CheckTrackType(arg1_16, "BLHXTimeline.BLHXCriAtomTrack") then
			local var0_16 = ReflectionHelp.RefCallMethod(typeof("BLHXTimeline.BLHXCriAtomTrack"), "GetClips", arg1_16)

			table.IpairsCArray(var0_16, function(arg0_17, arg1_17)
				local var0_17 = ReflectionHelp.RefGetProperty(arg1_17:GetType(), "asset", arg1_17)
				local var1_17 = ReflectionHelp.RefGetField(typeof("BLHXTimeline.BLHXCriAtomClip"), "cueSheet", var0_17)

				pg.CriMgr.GetInstance():UnloadCueSheet(var1_17)
			end)
		end
	end)
end
