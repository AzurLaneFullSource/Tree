TimelineSupport = {}

local var0_0 = TimelineSupport

function var0_0.InitTimeline(arg0_1)
	var0_0.DynamicBinding(arg0_1)
	var0_0.InitHXGroup(arg0_1)
end

function var0_0.EachDirector(arg0_2, arg1_2)
	arg1_2(arg0_2)
	eachChild(arg0_2, function(arg0_3)
		local var0_3 = arg0_3:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		if var0_3 then
			var0_0.EachDirector(var0_3, arg1_2)
		end
	end)
end

function var0_0.EachTrack(arg0_4, arg1_4)
	table.IpairsCArray(TimelineHelper.GetTimelineTracks(arg0_4), function(arg0_5, arg1_5)
		arg1_4(arg0_5, arg1_5)
	end)
end

function var0_0.EachGroupTrack(arg0_6, arg1_6)
	table.IpairsCArray(TimelineHelper.GetGroupTracks(arg0_6), function(arg0_7, arg1_7)
		arg1_6(arg0_7, arg1_7)
	end)
end

function var0_0.DynamicBinding(arg0_8)
	local var0_8 = _.reduce(pg.dorm3d_timeline_dynamic_binding, {}, function(arg0_9, arg1_9)
		if arg1_9.track_name then
			arg0_9[arg1_9.track_name] = arg1_9.object_name
		end

		return arg0_9
	end)

	var0_0.EachDirector(arg0_8, function(arg0_10)
		var0_0.EachTrack(arg0_10, function(arg0_11, arg1_11)
			if var0_8[arg1_11.name] then
				local var0_11 = GameObject.Find(var0_8[arg1_11.name])

				if var0_11 then
					TimelineHelper.SetAutoBinding(arg0_10, arg1_11, var0_11)
				else
					warning(string.format("轨道%s需要绑定的物体%s不存在", arg1_11.name, var0_8[arg1_11.name]))
				end
			end
		end)
	end)
end

function var0_0.InitSubtitle(arg0_12, arg1_12)
	local var0_12 = GameObject.Find("[subtitle]")

	if var0_12 then
		var0_12:GetComponent(typeof(Canvas)).worldCamera = pg.UIMgr.GetInstance().overlayCameraComp
	end

	local function var1_12(arg0_13)
		local var0_13 = tonumber(arg0_13)

		if not var0_13 then
			return arg0_13
		end

		local var1_13 = pg.dorm3d_subtitle[var0_13].subtitle

		return (HXSet.hxLan(string.gsub(var1_13, "$dorm3d", arg1_12)))
	end

	BLHXTimeline.SubtitleMixer.func = var1_12
end

function var0_0.DisablePlayOnAwake(arg0_14)
	var0_0.EachDirector(arg0_14, function(arg0_15)
		arg0_15.playOnAwake = false
	end)
end

function var0_0.InitHXGroup(arg0_16)
	var0_0.EachDirector(arg0_16, function(arg0_17)
		local var0_17 = false

		var0_0.EachGroupTrack(arg0_17, function(arg0_18, arg1_18)
			if arg1_18.name == "HXGroup" and arg1_18.muted ~= not HXSet.isHx() then
				arg1_18.muted = not HXSet.isHx()
				var0_17 = true
			end
		end)

		if var0_17 then
			arg0_17:RebuildGraph()
		end
	end)
end
