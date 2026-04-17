local var0_0 = class("L2dBoundsUI")
local var1_0 = "l2dui"

function var0_0.Ctor(arg0_1)
	arg0_1._timer = Timer.New(function()
		arg0_1:step()
	end, 0.0333333333333333, -1)

	arg0_1._timer:Start()

	arg0_1._dragsUI = {}
	arg0_1.visible = true
	var1_0 = pg.gameset.l2d_tips_default_icon.description
end

function var0_0.InitUI(arg0_3, arg1_3, arg2_3)
	arg1_3 = arg1_3 or "l2dboundsui"

	PoolMgr.GetInstance():GetUI(arg1_3, true, function(arg0_4)
		if arg0_3._isDispose then
			Destroy(arg0_4)

			return
		end

		arg0_3:onLoaded(arg0_4)

		if arg2_3 then
			arg2_3(arg0_3)
		end
	end)
end

function var0_0.SetData(arg0_5, arg1_5, arg2_5)
	arg0_5._bounds = arg1_5
	arg0_5._tipConfig = pg.ship_l2d_tips[arg2_5]

	if not arg0_5._tipConfig then
		return
	end

	arg0_5._tipOffset = arg0_5._tipConfig.tips_offset
	arg0_5._tipsScale = arg0_5._tipConfig.tips_scale
	arg0_5._tipsIdleBlackList = arg0_5._tipConfig.idle_black_list
	arg0_5._tipsAnimWhiteList = arg0_5._tipConfig.anim_white_list

	arg0_5:createDrags()
end

function var0_0.SetParent(arg0_6, arg1_6)
	if arg0_6._tf then
		SetParent(arg0_6._tf, arg1_6)
	end
end

function var0_0.onLoaded(arg0_7, arg1_7)
	arg0_7._tf = tf(arg1_7)
	arg0_7._container = findTF(arg0_7._tf, "ad")
	arg0_7._boundsTpl = findTF(arg0_7._tf, "ad/bounds_tpl")

	setActive(arg0_7._boundsTpl, false)
	setActive(arg0_7._tf, true)
end

function var0_0.step(arg0_8)
	if not arg0_8._bounds or #arg0_8._dragsUI == 0 then
		return
	end

	local var0_8 = GameObject.Find("UICamera"):GetComponent(typeof(Camera))
	local var1_8 = var0_8:ScreenToWorldPoint(Vector3(0, 0, -10))
	local var2_8 = var0_8:ScreenToWorldPoint(Vector3(Screen.width, Screen.height, -10))
	local var3_8 = Screen.width / (var2_8.x - var1_8.x)
	local var4_8 = Screen.height / (var2_8.y - var1_8.y)

	for iter0_8 = 1, #arg0_8._bounds do
		local var5_8 = arg0_8._bounds[iter0_8]
		local var6_8 = var5_8.name
		local var7_8 = var5_8.bounds.min
		local var8_8 = var5_8.bounds.max
		local var9_8 = true

		if not arg0_8.visible then
			var9_8 = false
		elseif arg0_8._state.isPlaying then
			if not arg0_8:MatchPlayingList(var6_8) then
				var9_8 = false
			end
		elseif not arg0_8._state.isPlaying and arg0_8:MatchIdleBlackList(var6_8) then
			var9_8 = false
		elseif var7_8.x >= var2_8.x or var7_8.y >= var2_8.y or var8_8.x <= var1_8.x or var8_8.y <= var1_8.y then
			var9_8 = false
		end

		arg0_8:setUIVisible(arg0_8._dragsUI[iter0_8], var9_8)

		if var9_8 then
			local var10_8 = var5_8.bounds.min
			local var11_8 = var5_8.bounds.max

			var10_8.x = var10_8.x < var1_8.x and var1_8.x or var10_8.x
			var10_8.y = var10_8.y < var1_8.y and var1_8.y or var10_8.y
			var11_8.x = var11_8.x > var2_8.x and var2_8.x or var11_8.x
			var11_8.y = var11_8.y > var2_8.y and var2_8.y or var11_8.y

			local var12_8 = var11_8.x - var10_8.x
			local var13_8 = var11_8.y - var10_8.y

			arg0_8._dragsUI[iter0_8].position = Vector3(var10_8.x + var12_8 / 2, var10_8.y + var13_8 / 2, 0)
			arg0_8._dragsUI[iter0_8].sizeDelta = Vector2(var12_8 * var3_8 - 10, var13_8 * var4_8 - 10)
		end
	end
end

function var0_0.setUIVisible(arg0_9, arg1_9, arg2_9)
	if isActive(arg1_9) ~= arg2_9 then
		setActive(arg1_9, arg2_9)
	end
end

function var0_0.createDrags(arg0_10)
	if arg0_10._isDispose or not arg0_10._boundsTpl then
		return
	end

	arg0_10:clearDrags()

	for iter0_10 = 1, #arg0_10._bounds do
		local var0_10 = arg0_10._bounds[iter0_10]
		local var1_10 = Instantiate(arg0_10._boundsTpl)

		GetOrAddComponent(var1_10, typeof(EventTriggerListener))
		SetParent(var1_10, arg0_10._container)
		table.insert(arg0_10._dragsUI, tf(var1_10))

		var1_10.name = var0_10.name

		setText(findTF(var1_10, "ad/text"), var0_10.name)
		setActive(findTF(var1_10, "ad/text"), false)

		local var2_10 = var0_10.name

		arg0_10:getDragBoundUI(var2_10, function(arg0_11)
			if arg0_10._tf then
				local var0_11 = tf(arg0_11)

				arg0_11.name = var2_10

				local var1_11 = findTF(var1_10, "ad")

				SetParent(var0_11, var1_11)

				local var2_11 = arg0_10:GetOffset(var2_10)

				var0_11.localScale, var0_11.anchoredPosition = arg0_10:GetScale(var2_10), var2_11

				setActive(var0_11, true)
				setText(findTF(var0_11, "Image/Text"), tostring(iter0_10))
			else
				Destroy(arg0_11)
			end
		end)
	end
end

function var0_0.MatchIdleBlackList(arg0_12, arg1_12)
	local var0_12 = arg0_12._state.idleIndex

	if arg0_12._tipsIdleBlackList and #arg0_12._tipsIdleBlackList >= 0 then
		for iter0_12, iter1_12 in ipairs(arg0_12._tipsIdleBlackList) do
			local var1_12 = iter1_12.drawable
			local var2_12 = iter1_12.idle

			if table.contains(var1_12, arg1_12) and table.contains(var2_12, var0_12) then
				return true
			end
		end
	end

	return false
end

function var0_0.MatchPlayingList(arg0_13, arg1_13)
	if not arg0_13._state.isPlaying then
		return false
	end

	local var0_13 = arg0_13._state.actionName

	if arg0_13._tipsAnimWhiteList and #arg0_13._tipsAnimWhiteList >= 0 then
		for iter0_13, iter1_13 in ipairs(arg0_13._tipsAnimWhiteList) do
			local var1_13 = iter1_13.drawable
			local var2_13 = iter1_13.white_list

			if table.contains(var1_13, arg1_13) and table.contains(var2_13, var0_13) then
				return true
			end
		end
	end

	return false
end

function var0_0.GetScale(arg0_14, arg1_14)
	local var0_14 = Vector3(1, 1, 1)

	if arg0_14._tipsScale and #arg0_14._tipsScale > 0 then
		for iter0_14, iter1_14 in ipairs(arg0_14._tipsScale) do
			local var1_14 = iter1_14.drawable
			local var2_14 = iter1_14.scale

			if table.contains(var1_14, arg1_14) then
				var0_14.x = var2_14[1]
				var0_14.y = var2_14[2]
				var0_14.z = var2_14[3]
			end
		end
	end

	return var0_14
end

function var0_0.GetOffset(arg0_15, arg1_15)
	local var0_15 = Vector2(0, 0)

	if arg0_15._tipOffset and #arg0_15._tipOffset > 0 then
		for iter0_15, iter1_15 in ipairs(arg0_15._tipOffset) do
			local var1_15 = iter1_15.drawable
			local var2_15 = iter1_15.offset

			if table.contains(var1_15, arg1_15) then
				var0_15.x = var2_15[1]
				var0_15.y = var2_15[2]
			end
		end
	end

	return var0_15
end

function var0_0.getDragBoundUI(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16._tipConfig.tips_icon
	local var1_16 = var1_0

	if var0_16 and #var0_16 > 0 then
		for iter0_16, iter1_16 in ipairs(var0_16) do
			local var2_16 = iter1_16.drawable
			local var3_16 = iter1_16.icon

			if table.contains(var2_16, arg1_16) then
				var1_16 = iter1_16.icon
			end
		end
	end

	PoolMgr.GetInstance():GetPrefab("ui/" .. var1_16, nil, true, function(arg0_17)
		if arg2_16 then
			arg2_16(arg0_17)
		end
	end)
end

function var0_0.GetDragsCount(arg0_18)
	if arg0_18._dragsUI then
		return #arg0_18._dragsUI
	end

	return 0
end

function var0_0.ActionChange(arg0_19, arg1_19)
	arg0_19._state = arg1_19
end

function var0_0.SetVisible(arg0_20, arg1_20)
	arg0_20.visible = arg1_20
end

function var0_0.clearDrags(arg0_21)
	if arg0_21._dragsUI and #arg0_21._dragsUI > 0 then
		for iter0_21 = 1, #arg0_21._dragsUI do
			ClearEventTrigger(GetComponent(arg0_21._dragsUI[iter0_21], typeof(EventTriggerListener)))
			Destroy(arg0_21._dragsUI[iter0_21])
		end

		arg0_21._dragsUI = {}
	end
end

function var0_0.Dispose(arg0_22)
	arg0_22._isDispose = true

	if arg0_22._timer then
		arg0_22._timer:Stop()

		arg0_22._timer = nil
	end

	if arg0_22._bounds then
		arg0_22._bounds = nil
	end

	if arg0_22._tf then
		Destroy(arg0_22._tf)

		arg0_22._tf = nil
	end

	arg0_22._boundsTpl = nil

	arg0_22:clearDrags()
end

return var0_0
