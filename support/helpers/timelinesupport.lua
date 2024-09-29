TimelineSupport = {}

local var0_0 = TimelineSupport

function var0_0.InitTimeline(arg0_1)
	var0_0.DynamicBinding(arg0_1)
	var0_0.InitSubtitle()
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

function var0_0.InitSubtitle()
	local var0_6 = GameObject.Find("[subtitle]")

	if var0_6 then
		var0_6:GetComponent(typeof(Canvas)).worldCamera = pg.UIMgr.GetInstance().overlayCameraComp
	end
end

function var0_0.CheckTrackType(arg0_7, arg1_7)
	return tostring(arg0_7:GetType()) == arg1_7
end

function var0_0.InitCriAtomTrack(arg0_8)
	eachChild(arg0_8, function(arg0_9)
		local var0_9 = arg0_9:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		if not var0_9 then
			return
		end

		table.IpairsCArray(TimelineHelper.GetTimelineTracks(var0_9), function(arg0_10, arg1_10)
			if var0_0.CheckTrackType(arg1_10, "CriTimeline.Atom.CriAtomTrack") then
				local var0_10 = ReflectionHelp.RefCallMethod(typeof("CriTimeline.Atom.CriAtomTrack"), "GetClips", arg1_10)

				table.IpairsCArray(var0_10, function(arg0_11, arg1_11)
					local var0_11 = ReflectionHelp.RefGetProperty(arg1_11:GetType(), "asset", arg1_11)
					local var1_11 = ReflectionHelp.RefGetField(typeof("CriTimeline.Atom.CriAtomClip"), "cueSheet", var0_11)

					pg.CriMgr.GetInstance():LoadCueSheet(var1_11)
				end)
			end
		end)
	end)
end
