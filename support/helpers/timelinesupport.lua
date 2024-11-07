TimelineSupport = {}

local var0_0 = TimelineSupport

function var0_0.InitTimeline(arg0_1)
	var0_0.DynamicBinding(arg0_1)
	var0_0.InitCriAtomTrack(arg0_1)
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

	var0_0.EachSubDirector(arg0_9, function(arg0_10, arg1_10)
		if var0_0.CheckTrackType(arg1_10, "Lens.Gameplay.Tools.SubtitleTrack") then
			local var0_10 = ReflectionHelp.RefCallMethod(typeof("Lens.Gameplay.Tools.SubtitleTrack"), "GetClips", arg1_10)

			table.IpairsCArray(var0_10, function(arg0_11, arg1_11)
				local var0_11 = ReflectionHelp.RefGetProperty(arg1_11:GetType(), "asset", arg1_11)
				local var1_11 = ReflectionHelp.RefGetField(var0_11:GetType(), "behaviour", var0_11)
				local var2_11 = tonumber(ReflectionHelp.RefGetField(var1_11:GetType(), "subtitle", var1_11))

				if not var2_11 then
					return
				end

				local var3_11 = pg.dorm3d_subtitle[var2_11].subtitle
				local var4_11 = string.gsub(var3_11, "$dorm3d", arg1_9)

				ReflectionHelp.RefSetField(var1_11:GetType(), "subtitle", var1_11, var4_11)
			end)
		end
	end)
end

function var0_0.CheckTrackType(arg0_12, arg1_12)
	return tostring(arg0_12:GetType()) == arg1_12
end

function var0_0.InitCriAtomTrack(arg0_13)
	var0_0.EachSubDirector(arg0_13, function(arg0_14, arg1_14)
		if var0_0.CheckTrackType(arg1_14, "CriTimeline.Atom.CriAtomTrack") then
			local var0_14 = ReflectionHelp.RefCallMethod(typeof("CriTimeline.Atom.CriAtomTrack"), "GetClips", arg1_14)

			table.IpairsCArray(var0_14, function(arg0_15, arg1_15)
				local var0_15 = ReflectionHelp.RefGetProperty(arg1_15:GetType(), "asset", arg1_15)
				local var1_15 = ReflectionHelp.RefGetField(typeof("CriTimeline.Atom.CriAtomClip"), "cueSheet", var0_15)

				pg.CriMgr.GetInstance():LoadCueSheet(var1_15)
			end)
		end
	end)
end

function var0_0.UnloadPlayable(arg0_16)
	var0_0.UnloadCriAtomTrack(arg0_16)
end

function var0_0.UnloadCriAtomTrack(arg0_17)
	var0_0.EachSubDirector(arg0_17, function(arg0_18, arg1_18)
		if var0_0.CheckTrackType(arg1_18, "CriTimeline.Atom.CriAtomTrack") then
			local var0_18 = ReflectionHelp.RefCallMethod(typeof("CriTimeline.Atom.CriAtomTrack"), "GetClips", arg1_18)

			table.IpairsCArray(var0_18, function(arg0_19, arg1_19)
				local var0_19 = ReflectionHelp.RefGetProperty(arg1_19:GetType(), "asset", arg1_19)
				local var1_19 = ReflectionHelp.RefGetField(typeof("CriTimeline.Atom.CriAtomClip"), "cueSheet", var0_19)

				pg.CriMgr.GetInstance():UnloadCueSheet(var1_19)
			end)
		end
	end)
end
