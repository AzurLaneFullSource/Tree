TimelineSupport = {}

local var0_0 = TimelineSupport

function var0_0.InitTimeline(arg0_1)
	var0_0.DynamicBinding(arg0_1)
	var0_0.InitCriAtomTrack(arg0_1)
end

function var0_0.DynamicBinding(arg0_2)
	local var0_2 = _.reduce(pg.dorm3d_timeline_dynamic_binding, {}, function(arg0_3, arg1_3)
		if arg1_3.track_name then
			arg0_3[arg1_3.track_name] = arg1_3.object_name
		end

		return arg0_3
	end)

	eachChild(arg0_2, function(arg0_4)
		local var0_4 = arg0_4:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		if not var0_4 then
			return
		end

		table.IpairsCArray(TimelineHelper.GetTimelineTracks(var0_4), function(arg0_5, arg1_5)
			if var0_2[arg1_5.name] then
				local var0_5 = GameObject.Find(var0_2[arg1_5.name])

				if var0_5 then
					TimelineHelper.SetSceneBinding(var0_4, arg1_5, var0_5)
				else
					warning(string.format("轨道%s需要绑定的物体%s不存在", arg1_5.name, var0_2[arg1_5.name]))
				end
			end
		end)
	end)
end

function var0_0.InitSubtitle(arg0_6, arg1_6)
	local var0_6 = GameObject.Find("[subtitle]")

	if var0_6 then
		var0_6:GetComponent(typeof(Canvas)).worldCamera = pg.UIMgr.GetInstance().overlayCameraComp
	end

	eachChild(arg0_6, function(arg0_7)
		local var0_7 = arg0_7:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		if not var0_7 then
			return
		end

		table.IpairsCArray(TimelineHelper.GetTimelineTracks(var0_7), function(arg0_8, arg1_8)
			if var0_0.CheckTrackType(arg1_8, "Lens.Gameplay.Tools.SubtitleTrack") then
				local var0_8 = ReflectionHelp.RefCallMethod(typeof("Lens.Gameplay.Tools.SubtitleTrack"), "GetClips", arg1_8)

				table.IpairsCArray(var0_8, function(arg0_9, arg1_9)
					local var0_9 = ReflectionHelp.RefGetProperty(arg1_9:GetType(), "asset", arg1_9)
					local var1_9 = ReflectionHelp.RefGetField(var0_9:GetType(), "behaviour", var0_9)
					local var2_9 = ReflectionHelp.RefGetField(var1_9:GetType(), "subtitle", var1_9)
					local var3_9 = string.gsub(var2_9, "{dorm3d}", arg1_6)

					ReflectionHelp.RefSetField(var1_9:GetType(), "subtitle", var1_9, var3_9)
				end)
			end
		end)
	end)
end

function var0_0.CheckTrackType(arg0_10, arg1_10)
	return tostring(arg0_10:GetType()) == arg1_10
end

function var0_0.InitCriAtomTrack(arg0_11)
	eachChild(arg0_11, function(arg0_12)
		local var0_12 = arg0_12:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		if not var0_12 then
			return
		end

		table.IpairsCArray(TimelineHelper.GetTimelineTracks(var0_12), function(arg0_13, arg1_13)
			if var0_0.CheckTrackType(arg1_13, "CriTimeline.Atom.CriAtomTrack") then
				local var0_13 = ReflectionHelp.RefCallMethod(typeof("CriTimeline.Atom.CriAtomTrack"), "GetClips", arg1_13)

				table.IpairsCArray(var0_13, function(arg0_14, arg1_14)
					local var0_14 = ReflectionHelp.RefGetProperty(arg1_14:GetType(), "asset", arg1_14)
					local var1_14 = ReflectionHelp.RefGetField(typeof("CriTimeline.Atom.CriAtomClip"), "cueSheet", var0_14)

					pg.CriMgr.GetInstance():LoadCueSheet(var1_14)
				end)
			end
		end)
	end)
end
