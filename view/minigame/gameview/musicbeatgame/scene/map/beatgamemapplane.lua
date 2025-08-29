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
	arg0_1.leftSpineSkeleton = findTF(arg0_1._tf, "char_left/ad/char"):GetComponent("SkeletonGraphic")
	arg0_1.rightSpine = GetComponent(findTF(arg0_1._tf, "char_right/ad/char"), typeof(SpineAnimUI))
	arg0_1.rightSpineSkeleton = findTF(arg0_1._tf, "char_right/ad/char"):GetComponent("SkeletonGraphic")
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

	var4_8.speed = 1

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
		arg0_11:setCharAnimation(arg0_11.leftSpine, "idle", 0)
		arg0_11.leftSpineSkeleton:Update(Time.deltaTime)
	end, function()
		local var0_13 = arg0_11:getCheckDymItem()

		if var0_13 then
			arg0_11._event:emit(MusicBeatGameEvent.TRACK_EVENT_MATCH, var0_13.track, function(arg0_14, arg1_14)
				if arg0_14 then
					var0_13.trigger = true
					var0_13.anim.speed = 1

					var0_13.anim:Play(arg2_11, -1)

					if var0_13.data.act == arg3_11 then
						var0_13.typeMatch = true

						arg0_11._event:emit(MusicBeatGameEvent.ADD_SCORE, {
							num = var0_13.data.score
						})
						arg0_11:setEmoji("success")
						arg0_11:changeLife(1)
					else
						if var0_13.data.act == "flap" and arg3_11 ~= "flap" then
							var0_13.typeMatch = false

							arg0_11:setCharAnimation(arg0_11.leftSpine, "shock", 0, function()
								arg0_11:setCharAnimation(arg0_11.leftSpine, "idle", 0)
							end)
							arg0_11:changeLife(-1)
						end

						arg0_11:setEmoji("fail")
					end

					local var0_14

					if var0_13.typeMatch then
						if var0_13.data.act == "flap" then
							var0_14 = MusicBeatGameConst.sfx_plane_success_hit
						elseif var0_13.data.act == "touch" then
							var0_14 = MusicBeatGameConst.sfx_plane_success_touch
						end
					elseif var0_13.data.act == "flap" then
						var0_14 = MusicBeatGameConst.sfx_plane_faild_hit
					elseif var0_13.data.act == "touch" then
						var0_14 = MusicBeatGameConst.sfx_plane_faild_touch
					end

					if var0_14 then
						print("play Effect sound " .. var0_14)
						pg.CriMgr.GetInstance():PlaySoundEffect_V3(var0_14)
					end
				end
			end)
		end
	end)
end

function var0_0.onStart(arg0_16)
	arg0_16.triggerCd = nil
	arg0_16.finalEnd = false

	onNextTick(function()
		if arg0_16.leftSpine then
			arg0_16.leftSpine:Resume()
		end

		if arg0_16.rightSpine then
			arg0_16.rightSpine:Resume()
		end
	end)

	arg0_16.lifeCount = var3_0

	arg0_16:changeLife(0)
	arg0_16:setCharAnimation(arg0_16.leftSpine, "idle", 0, function()
		return
	end, function()
		return
	end)
	arg0_16:setCharAnimation(arg0_16.rightSpine, "idle", 0, function()
		return
	end, function()
		return
	end)
end

function var0_0.onStartTrack(arg0_22, arg1_22)
	arg0_22:createDymItem(arg1_22)
end

function var0_0.onStep(arg0_23)
	if arg0_23.triggerCd then
		arg0_23.triggerCd = arg0_23.triggerCd - arg0_23._gameVo.deltaTime

		if arg0_23.triggerCd <= 0 then
			arg0_23.triggerCd = nil
		end
	end

	local var0_23 = arg0_23._gameVo:getCriInfoTime()

	if var0_23 ~= -1 then
		for iter0_23 = #arg0_23.dymItems, 1, -1 do
			local var1_23 = arg0_23.dymItems[iter0_23]

			if var1_23 then
				local var2_23 = var1_23.data.distance_time
				local var3_23 = var1_23.track.begin_time
				local var4_23 = var3_23 - var0_23

				if var1_23.active then
					if var3_23 <= var0_23 and var0_23 - var3_23 > var1_0 then
						var1_23.active = false
						var1_23.remove = true
					end

					if var1_23.check and not var1_23.trigger and var0_23 - var3_23 > MusicBeatGameConst.beat_offset then
						var1_23.check = false

						if not var1_23.trigger then
							arg0_23:setEmoji("miss")

							if var1_23.data.act == "flap" then
								arg0_23:changeLife(-1)
							end
						end
					end
				elseif var1_23.remove == true then
					if var1_23.data.final then
						arg0_23.finalEnd = true

						local var5_23
						local var6_23 = var1_23.typeMatch and "final_correct" or "final_wrong"

						arg0_23:setCharAnimation(arg0_23.leftSpine, var6_23, 0, function()
							arg0_23.leftSpine:Pause()
						end)
						arg0_23:setCharAnimation(arg0_23.rightSpine, var6_23, 0, function()
							arg0_23.rightSpine:Pause()
						end)
					end

					local var7_23 = table.remove(arg0_23.dymItems, iter0_23)

					Destroy(var7_23.tf)

					var7_23.tf = nil
					var7_23.anim = nil
					var7_23.track = nil

					return
				elseif var4_23 > 0 and var4_23 <= var2_23 then
					arg0_23:activeDymItem(var1_23)
				elseif not var1_23.throw and var4_23 > 0 and var4_23 <= var2_23 + 100 then
					var1_23.throw = true

					arg0_23:setCharAnimation(arg0_23.rightSpine, "throw", 0, function()
						arg0_23:setCharAnimation(arg0_23.rightSpine, "idle", 0, nil, nil)
					end, nil)
				elseif var4_23 <= var2_23 / 2 or var3_23 <= var0_23 and not var1_23.active then
					var1_23.remove = true
				end
			else
				warning("dymitem == nil")
			end
		end
	end
end

function var0_0.onStop(arg0_27)
	for iter0_27 = 1, #arg0_27.dymItems do
		local var0_27 = arg0_27.dymItems[iter0_27].anim

		if var0_27 then
			var0_27.speed = 0
		end
	end
end

function var0_0.onResume(arg0_28)
	for iter0_28 = 1, #arg0_28.dymItems do
		local var0_28 = arg0_28.dymItems[iter0_28].anim

		if var0_28 then
			var0_28.speed = 1
		end
	end
end

function var0_0.changeLife(arg0_29, arg1_29)
	arg0_29.lifeCount = arg0_29.lifeCount + arg1_29

	if arg0_29.lifeCount <= 0 then
		arg0_29._event:emit(MusicBeatGameEvent.GAME_OVER)
	end

	setText(findTF(arg0_29.beatCount, "text"), arg0_29.lifeCount)
end

function var0_0.setEmoji(arg0_30, arg1_30)
	setActive(arg0_30.emojiTf, false)
	arg0_30:setChildVisible(findTF(arg0_30.emojiTf, "ad"), false)

	if arg1_30 then
		setActive(arg0_30.emojiTf, true)
		setActive(findTF(arg0_30.emojiTf, "ad/" .. arg1_30), true)
	end
end

function var0_0.setChildVisible(arg0_31, arg1_31, arg2_31)
	for iter0_31 = 1, arg1_31.childCount do
		local var0_31 = arg1_31:GetChild(iter0_31 - 1)

		setActive(var0_31, arg2_31)
	end
end

function var0_0.getCheckDymItem(arg0_32)
	for iter0_32 = 1, #arg0_32.dymItems do
		local var0_32 = arg0_32.dymItems[iter0_32]

		if var0_32.check and not var0_32.trigger then
			return var0_32
		end
	end

	return nil
end

function var0_0.activeDymItem(arg0_33, arg1_33)
	setActive(arg1_33.tf, true)

	arg1_33.active = true

	arg1_33.anim:Play("item_fly", -1, 0)

	arg1_33.anim.speed = 1
end

function var0_0.setCharAnimation(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34, arg5_34)
	if arg1_34 then
		arg1_34:SetActionCallBack(nil)
		arg1_34:SetActionCallBack(function(arg0_35)
			if arg0_35 == "finish" and arg4_34 then
				arg1_34:SetActionCallBack(nil)
				arg4_34()
			elseif arg0_35 == "action" and arg5_34 then
				arg5_34()
			end
		end)
	end

	if arg1_34 == arg0_34.leftSpine then
		print("set action" .. arg2_34)
	end

	arg1_34:SetAction(arg2_34, arg3_34)
end

function var0_0.onClear(arg0_36)
	for iter0_36 = 1, #arg0_36.dymItems do
		if arg0_36.dymItems[iter0_36].tf then
			Destroy(arg0_36.dymItems[iter0_36].tf)

			arg0_36.dymItems[iter0_36].tf = nil
			arg0_36.dymItems[iter0_36].anim = nil
		end
	end

	arg0_36.dymItems = {}
end

function var0_0.onDispose(arg0_37)
	return
end

return var0_0
