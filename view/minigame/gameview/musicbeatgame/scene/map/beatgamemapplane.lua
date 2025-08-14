local var0_0 = class("BeatGameMapPlane", import(".BeatGameMapBase"))
local var1_0 = 500
local var2_0 = 0.1
local var3_0 = 20

function var0_0.onInit(arg0_1)
	arg0_1.touchTf = findTF(arg0_1._tf, "touch")
	arg0_1.flapTf = findTF(arg0_1._tf, "flap")
	arg0_1.touchTrigger = GetOrAddComponent(arg0_1.touchTf, typeof(EventTriggerListener))
	arg0_1.flapTrigger = GetOrAddComponent(arg0_1.flapTf, typeof(EventTriggerListener))

	arg0_1.touchTrigger:AddPointDownFunc(function()
		arg0_1:keyTrigger("catch", "item_touch", "touch")
	end)
	arg0_1.flapTrigger:AddPointDownFunc(function()
		arg0_1:keyTrigger("refuse", "item_flap", "flap")
	end)
	arg0_1._event:bind(MusicBeatGameEvent.KEY_CODE_DOWN, function(arg0_4, arg1_4, arg2_4)
		if arg1_4 == KeyCode.A then
			arg0_1:keyTrigger("refuse", "item_flap", "flap")
		elseif arg1_4 == KeyCode.D then
			arg0_1:keyTrigger("catch", "item_touch", "touch")
		end
	end)

	arg0_1.leftSpine = GetComponent(findTF(arg0_1._tf, "char_left/ad/char"), typeof(SpineAnimUI))
	arg0_1.rightSpine = GetComponent(findTF(arg0_1._tf, "char_right/ad/char"), typeof(SpineAnimUI))
	arg0_1.emojiTf = findTF(arg0_1._tf, "emoji")

	setActive(arg0_1.emojiTf, false)

	arg0_1.beatCount = findTF(arg0_1._tf, "beat_count")

	setActive(arg0_1.beatCount, true)
	arg0_1:initData()
	arg0_1:initPosition()
	arg0_1:initItemMap()
end

function var0_0.initData(arg0_5)
	arg0_5.dymItems = {}
	arg0_5.itemMap = {}
	arg0_5.itemFinalMap = {}
end

function var0_0.initPosition(arg0_6)
	arg0_6.content = findTF(arg0_6._tf, "content")
	arg0_6.startTf = findTF(arg0_6._tf, "content/start")
	arg0_6.endTf = findTF(arg0_6._tf, "content/end")
	arg0_6.startPosition = arg0_6.startTf.anchoredPosition
end

function var0_0.initItemMap(arg0_7)
	local var0_7 = arg0_7._data.items

	for iter0_7 = 1, #var0_7 do
		local var1_7 = var0_7[iter0_7].track_key

		if arg0_7.itemMap[var1_7] == nil then
			arg0_7.itemMap[var1_7] = {}
		elseif arg0_7.itemFinalMap[var1_7] == nil then
			arg0_7.itemFinalMap[var1_7] = {}
		end

		if var0_7[iter0_7].final then
			table.insert(arg0_7.itemFinalMap[var1_7], var0_7[iter0_7])
		else
			table.insert(arg0_7.itemMap[var1_7], var0_7[iter0_7])
		end
	end
end

function var0_0.createDymItem(arg0_8, arg1_8)
	local var0_8 = arg1_8.track
	local var1_8 = arg1_8.final
	local var2_8 = arg0_8:getItemData(var0_8.key_flag, var1_8)
	local var3_8 = arg0_8:createItemTf(var2_8.prefab)
	local var4_8 = GetComponent(var3_8, typeof(Animator))

	var4_8.speed = 0

	table.insert(arg0_8.dymItems, {
		check = true,
		data = var2_8,
		tf = var3_8,
		anim = var4_8,
		track = var0_8
	})
end

function var0_0.getItemData(arg0_9, arg1_9, arg2_9)
	local var0_9

	if arg2_9 then
		var0_9 = arg0_9.itemFinalMap[arg1_9]
	else
		var0_9 = arg0_9.itemMap[arg1_9]
	end

	return var0_9[math.random(1, #var0_9)]
end

function var0_0.createItemTf(arg0_10, arg1_10)
	local var0_10 = tf(instantiate(findTF(arg0_10._tf, arg1_10)))

	setParent(var0_10, arg0_10.content)
	setActive(var0_10, false)

	var0_10.anchoredPosition = arg0_10.startTf.anchoredPosition

	return var0_10
end

function var0_0.keyTrigger(arg0_11, arg1_11, arg2_11, arg3_11)
	if arg0_11.finalEnd then
		return
	end

	if arg0_11.triggerCd then
		return
	end

	arg0_11.triggerCd = var2_0

	arg0_11:setCharAnimation(arg0_11.leftSpine, arg1_11, 0, function()
		arg0_11:setCharAnimation(arg0_11.leftSpine, "idle", 0, function()
			return
		end)
	end, function()
		local var0_14 = arg0_11:getCheckDymItem()

		if var0_14 then
			arg0_11._event:emit(MusicBeatGameEvent.TRACK_EVENT_MATCH, var0_14.track, function(arg0_15, arg1_15)
				if arg0_15 then
					var0_14.trigger = true
					var0_14.anim.speed = 1

					var0_14.anim:Play(arg2_11, -1)

					if var0_14.data.act == arg3_11 then
						var0_14.typeMatch = true

						arg0_11._event:emit(MusicBeatGameEvent.ADD_SCORE, {
							num = var0_14.data.score
						})
						arg0_11:setEmoji("success")
						arg0_11:changeLife(1)
					else
						if var0_14.data.act == "flap" and arg3_11 ~= "flap" then
							var0_14.typeMatch = false

							arg0_11:setCharAnimation(arg0_11.leftSpine, "shock", 0, function()
								arg0_11:setCharAnimation(arg0_11.leftSpine, "idle", 0)
							end)
							arg0_11:changeLife(-1)
						end

						arg0_11:setEmoji("fail")
					end

					local var0_15

					if var0_14.typeMatch then
						if var0_14.data.act == "flap" then
							var0_15 = MusicBeatGameConst.sfx_plane_success_hit
						elseif var0_14.data.act == "touch" then
							var0_15 = MusicBeatGameConst.sfx_plane_success_touch
						end
					elseif var0_14.data.act == "flap" then
						var0_15 = MusicBeatGameConst.sfx_plane_faild_hit
					elseif var0_14.data.act == "touch" then
						var0_15 = MusicBeatGameConst.sfx_plane_faild_touch
					end

					if var0_15 then
						print("play Effect sound " .. var0_15)
						pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_15)
					end
				end
			end)
		end
	end)
end

function var0_0.onStart(arg0_17)
	arg0_17.triggerCd = nil
	arg0_17.finalEnd = false

	onNextTick(function()
		if arg0_17.leftSpine then
			arg0_17.leftSpine:Resume()
		end

		if arg0_17.rightSpine then
			arg0_17.rightSpine:Resume()
		end
	end)

	arg0_17.lifeCount = var3_0

	arg0_17:changeLife(0)
	arg0_17:setCharAnimation(arg0_17.leftSpine, "idle", 0, function()
		return
	end, function()
		return
	end)
	arg0_17:setCharAnimation(arg0_17.rightSpine, "idle", 0, function()
		return
	end, function()
		return
	end)
end

function var0_0.onStartTrack(arg0_23, arg1_23)
	arg0_23:createDymItem(arg1_23)
end

function var0_0.onStep(arg0_24)
	if arg0_24.triggerCd then
		arg0_24.triggerCd = arg0_24.triggerCd - arg0_24._gameVo.deltaTime

		if arg0_24.triggerCd <= 0 then
			arg0_24.triggerCd = nil
		end
	end

	local var0_24 = arg0_24._gameVo:getCriInfoTime()

	if var0_24 ~= -1 then
		for iter0_24 = #arg0_24.dymItems, 1, -1 do
			local var1_24 = arg0_24.dymItems[iter0_24]
			local var2_24 = var1_24.data.distance_time
			local var3_24 = var1_24.track.begin_time
			local var4_24 = var3_24 - var0_24

			if var1_24.active then
				if not var1_24.trigger then
					local var5_24 = 1 - (var3_24 + var1_0 - var0_24) / (var1_24.data.distance_time + var1_0)

					if var5_24 >= 0 and var5_24 <= 1 then
						var1_24.anim:Play("item_fly", -1, var5_24)
					end
				end

				if var3_24 <= var0_24 and var0_24 - var3_24 > var1_0 then
					var1_24.active = false
					var1_24.remove = true
				end

				if var1_24.check and not var1_24.trigger and var0_24 - var3_24 > MusicBeatGameConst.beat_offset then
					var1_24.check = false

					if not var1_24.trigger then
						arg0_24:setEmoji("miss")

						if var1_24.data.act == "flap" then
							arg0_24:changeLife(-1)
						end
					end
				end
			elseif var1_24.remove == true then
				if var1_24.data.final then
					arg0_24.finalEnd = true

					local var6_24
					local var7_24 = var1_24.typeMatch and "final_correct" or "final_wrong"

					arg0_24:setCharAnimation(arg0_24.leftSpine, var7_24, 0, function()
						arg0_24.leftSpine:Pause()
					end)
					arg0_24:setCharAnimation(arg0_24.rightSpine, var7_24, 0, function()
						arg0_24.rightSpine:Pause()
					end)
				end

				local var8_24 = table.remove(arg0_24.dymItems, iter0_24)

				Destroy(var8_24.tf)

				var8_24.tf = nil
				var8_24.anim = nil
				var8_24.track = nil
			elseif var4_24 > 0 and var4_24 <= var2_24 then
				arg0_24:activeDymItem(var1_24)
			elseif not var1_24.throw and var4_24 > 0 and var4_24 <= var2_24 + 100 then
				var1_24.throw = true

				arg0_24:setCharAnimation(arg0_24.rightSpine, "throw", 0, function()
					arg0_24:setCharAnimation(arg0_24.rightSpine, "idle", 0, nil, nil)
				end, nil)
			elseif var4_24 <= var2_24 / 2 or var3_24 <= var0_24 and not var1_24.active then
				var1_24.remove = true
			end
		end
	end
end

function var0_0.changeLife(arg0_28, arg1_28)
	arg0_28.lifeCount = arg0_28.lifeCount + arg1_28

	if arg0_28.lifeCount <= 0 then
		arg0_28._event:emit(MusicBeatGameEvent.GAME_OVER)
	end

	setText(findTF(arg0_28.beatCount, "text"), arg0_28.lifeCount)
end

function var0_0.setEmoji(arg0_29, arg1_29)
	setActive(arg0_29.emojiTf, false)
	arg0_29:setChildVisible(findTF(arg0_29.emojiTf, "ad"), false)

	if arg1_29 then
		setActive(arg0_29.emojiTf, true)
		setActive(findTF(arg0_29.emojiTf, "ad/" .. arg1_29), true)
	end
end

function var0_0.setChildVisible(arg0_30, arg1_30, arg2_30)
	for iter0_30 = 1, arg1_30.childCount do
		local var0_30 = arg1_30:GetChild(iter0_30 - 1)

		setActive(var0_30, arg2_30)
	end
end

function var0_0.getCheckDymItem(arg0_31)
	for iter0_31 = 1, #arg0_31.dymItems do
		local var0_31 = arg0_31.dymItems[iter0_31]

		if var0_31.check and not var0_31.trigger then
			return var0_31
		end
	end

	return nil
end

function var0_0.activeDymItem(arg0_32, arg1_32)
	setActive(arg1_32.tf, true)

	arg1_32.active = true
end

function var0_0.setCharAnimation(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33, arg5_33)
	if arg1_33 then
		arg1_33:SetActionCallBack(nil)
		arg1_33:SetActionCallBack(function(arg0_34)
			if arg0_34 == "finish" and arg4_33 then
				arg1_33:SetActionCallBack(nil)
				arg4_33()
			elseif arg0_34 == "action" and arg5_33 then
				arg5_33()
			end
		end)
	end

	if arg1_33 == arg0_33.leftSpine then
		print("set action" .. arg2_33)
	end

	arg1_33:SetAction(arg2_33, arg3_33)
end

function var0_0.onClear(arg0_35)
	for iter0_35 = 1, #arg0_35.dymItems do
		if arg0_35.dymItems[iter0_35].tf then
			Destroy(arg0_35.dymItems[iter0_35].tf)

			arg0_35.dymItems[iter0_35].tf = nil
			arg0_35.dymItems[iter0_35].anim = nil
		end
	end

	arg0_35.dymItems = {}
end

function var0_0.onDispose(arg0_36)
	return
end

return var0_0
