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
			if EDITOR_TOOL then
				local function var0_10(arg0_11)
					local var0_11 = tonumber(arg0_11)

					if not var0_11 then
						return arg0_11
					end

					local var1_11 = pg.dorm3d_subtitle[var0_11].subtitle

					return (HXSet.hxLan(string.gsub(var1_11, "$dorm3d", arg1_9)))
				end

				Lens.Gameplay.Tools.SubtitleMixer.func = var0_10
			else
				local var1_10 = ReflectionHelp.RefCallMethod(typeof("Lens.Gameplay.Tools.SubtitleTrack"), "GetClips", arg1_10)

				table.IpairsCArray(var1_10, function(arg0_12, arg1_12)
					local var0_12 = ReflectionHelp.RefGetProperty(arg1_12:GetType(), "asset", arg1_12)
					local var1_12 = ReflectionHelp.RefGetField(var0_12:GetType(), "behaviour", var0_12)
					local var2_12 = tonumber(ReflectionHelp.RefGetField(var1_12:GetType(), "subtitle", var1_12))

					if not var2_12 then
						return
					end

					local var3_12 = pg.dorm3d_subtitle[var2_12].subtitle
					local var4_12 = HXSet.hxLan(string.gsub(var3_12, "$dorm3d", arg1_9))

					ReflectionHelp.RefSetField(var1_12:GetType(), "subtitle", var1_12, var4_12)
				end)
			end
		end
	end)
end

function var0_0.CheckTrackType(arg0_13, arg1_13)
	return tostring(arg0_13:GetType()) == arg1_13
end

function var0_0.InitCriAtomTrack(arg0_14)
	var0_0.EachSubDirector(arg0_14, function(arg0_15, arg1_15)
		if var0_0.CheckTrackType(arg1_15, "CriTimeline.Atom.CriAtomTrack") then
			local var0_15 = ReflectionHelp.RefCallMethod(typeof("CriTimeline.Atom.CriAtomTrack"), "GetClips", arg1_15)

			table.IpairsCArray(var0_15, function(arg0_16, arg1_16)
				local var0_16 = ReflectionHelp.RefGetProperty(arg1_16:GetType(), "asset", arg1_16)
				local var1_16 = ReflectionHelp.RefGetField(typeof("CriTimeline.Atom.CriAtomClip"), "cueSheet", var0_16)

				pg.CriMgr.GetInstance():LoadCueSheet(var1_16)
			end)
		end
	end)
end

function var0_0.UnloadPlayable(arg0_17)
	var0_0.UnloadCriAtomTrack(arg0_17)
end

function var0_0.UnloadCriAtomTrack(arg0_18)
	var0_0.EachSubDirector(arg0_18, function(arg0_19, arg1_19)
		if var0_0.CheckTrackType(arg1_19, "CriTimeline.Atom.CriAtomTrack") then
			local var0_19 = ReflectionHelp.RefCallMethod(typeof("CriTimeline.Atom.CriAtomTrack"), "GetClips", arg1_19)

			table.IpairsCArray(var0_19, function(arg0_20, arg1_20)
				local var0_20 = ReflectionHelp.RefGetProperty(arg1_20:GetType(), "asset", arg1_20)
				local var1_20 = ReflectionHelp.RefGetField(typeof("CriTimeline.Atom.CriAtomClip"), "cueSheet", var0_20)

				pg.CriMgr.GetInstance():UnloadCueSheet(var1_20)
			end)
		end
	end)
end
