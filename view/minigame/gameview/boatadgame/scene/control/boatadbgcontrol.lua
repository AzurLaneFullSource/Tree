local var0_0 = class("BoatAdBgControl")
local var1_0
local var2_0 = 2
local var3_0 = 100
local var4_0 = 1

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = BoatAdGameVo
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._content = findTF(arg0_1._tf, "scene_front/content")
	arg0_1._spineSea = findTF(arg0_1._tf, "scene_background/content/spineSea")
	arg0_1._spineSeaLeft = findTF(arg0_1._tf, "scene_background/content/spineSeaLeft")
	arg0_1._spineSeaRight = findTF(arg0_1._tf, "scene_background/content/spineSeaRight")
	arg0_1.graphicUI = {}

	table.insert(arg0_1.graphicUI, arg0_1._spineSea:GetComponent("SkeletonGraphic"))
	table.insert(arg0_1.graphicUI, arg0_1._spineSeaLeft:GetComponent("SkeletonGraphic"))
	table.insert(arg0_1.graphicUI, arg0_1._spineSeaRight:GetComponent("SkeletonGraphic"))

	arg0_1._bgs = {}
	arg0_1._bgsPool = {}
	arg0_1.thunders = {}

	for iter0_1 = 1, 3 do
		local var0_1 = var1_0.GetGameTplTf("bgs/thunder_" .. iter0_1)
		local var1_1 = GetComponent(findTF(var0_1, "ad/img/spine"), typeof(SpineAnimUI))
		local var2_1 = {
			active = false,
			tf = var0_1,
			animUI = var1_1
		}

		setParent(var0_1, arg0_1._content)
		setActive(var0_1, false)
		table.insert(arg0_1.thunders, var2_1)
	end
end

function var0_0.start(arg0_2)
	arg0_2:setSpineStop(false)
	arg0_2:clear()

	arg0_2._createTime = var2_0
	arg0_2._thunderTime = var4_0
end

function var0_0.step(arg0_3, arg1_3)
	if arg0_3._createTime > 0 then
		arg0_3._createTime = arg0_3._createTime - arg1_3

		if arg0_3._createTime <= 0 then
			arg0_3._createTime = var2_0

			if math.random(1, 100) <= var3_0 then
				arg0_3:createBg(BoatAdGameConst.create_bg[math.random(1, #BoatAdGameConst.create_bg)])
			end
		end
	end

	if #arg0_3._bgs > 0 and arg0_3._thunderTime > 0 then
		arg0_3._thunderTime = arg0_3._thunderTime - arg1_3

		if arg0_3._thunderTime <= 0 then
			arg0_3._thunderTime = var4_0

			for iter0_3 = 1, #arg0_3.thunders do
				local var0_3 = arg0_3.thunders[iter0_3]

				if var0_3.active == false then
					var0_3.active = true

					local var1_3 = arg0_3._bgs[math.random(1, #arg0_3._bgs)]

					var0_3.tf.anchoredPosition = var1_3:getPosition()

					setActive(var0_3.tf, true)
					arg0_3:setAnimation(arg0_3.thunders[iter0_3].animUI, "normal", function()
						var0_3.active = false

						setActive(var0_3.tf, false)
					end)
					print("创建闪电成功")

					break
				end
			end
		end
	end

	for iter1_3 = #arg0_3._bgs, 1, -1 do
		local var2_3 = arg0_3._bgs[iter1_3]

		var2_3:step(arg1_3)

		if var2_3:getRemoveFlag() then
			table.remove(arg0_3._bgs, iter1_3)
			arg0_3:returnBg(var2_3)
		end
	end
end

function var0_0.returnBg(arg0_5, arg1_5)
	arg1_5:clear()
	table.insert(arg0_5._bgsPool, arg1_5)
end

function var0_0.getSpineStop(arg0_6)
	return arg0_6.spineStopFlag
end

function var0_0.setSpineStop(arg0_7, arg1_7)
	arg0_7.spineStopFlag = arg1_7

	local var0_7
	local var1_7 = arg1_7 and 0 or BoatAdGameConst.spine_scale_time

	for iter0_7 = 1, #arg0_7.graphicUI do
		arg0_7.graphicUI[iter0_7].AnimationState.TimeScale = var1_7
	end
end

function var0_0.createBg(arg0_8, arg1_8)
	local var0_8 = arg1_8
	local var1_8 = math.random(1, 4)
	local var2_8 = arg0_8:getOrCreateItem(var0_8)

	var2_8:start()
	var2_8:setMoveCount(var1_8)
	table.insert(arg0_8._bgs, var2_8)
end

function var0_0.getOrCreateItem(arg0_9, arg1_9)
	local var0_9

	if #arg0_9._bgsPool > 0 then
		for iter0_9 = 1, #arg0_9._bgsPool do
			if arg0_9._bgsPool[iter0_9]:getId() == arg1_9 then
				var0_9 = table.remove(arg0_9._bgsPool, iter0_9)

				break
			end
		end
	end

	if not var0_9 then
		local var1_9 = BoatAdGameConst.game_bg[arg1_9]

		if not var1_9 then
			print("不存在背景id" .. arg1_9)
		end

		local var2_9 = var1_0.GetGameTplTf(var1_9.tpl)

		var0_9 = BoatAdBg.New(var2_9, arg0_9._event)

		var0_9:setData(var1_9)
		var0_9:setContent(arg0_9._content)
	end

	var0_9:start()

	return var0_9
end

function var0_0.setMoveSpeed(arg0_10, arg1_10)
	arg0_10._moveSpeed = arg1_10

	for iter0_10 = 1, #arg0_10._bgs do
		arg0_10._bgs[iter0_10]:setSpeed(arg1_10)
	end

	if arg1_10 == 0 then
		arg0_10:setSpineStop(true)
	else
		arg0_10:setSpineStop(false)
	end
end

function var0_0.getMoveSpeed(arg0_11)
	return arg0_11._moveSpeed
end

function var0_0.stop(arg0_12)
	arg0_12.lastMoveSpeed = arg0_12._moveSpeed or 1

	arg0_12:setMoveSpeed(0)
end

function var0_0.resume(arg0_13)
	arg0_13:setMoveSpeed(arg0_13.lastMoveSpeed)
end

function var0_0.clear(arg0_14)
	for iter0_14 = #arg0_14._bgs, 1, -1 do
		local var0_14 = table.remove(arg0_14._bgs, iter0_14)

		var0_14:clear()
		table.insert(arg0_14._bgsPool, var0_14)
	end

	for iter1_14 = #arg0_14.thunders, 1, -1 do
		arg0_14.thunders[iter1_14].active = false

		setActive(arg0_14.thunders[iter1_14].tf, false)
	end

	arg0_14:setMoveSpeed(1)
end

function var0_0.setAnimation(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	arg1_15:SetActionCallBack(nil)
	arg1_15:SetAction(arg2_15, 0)
	arg1_15:SetActionCallBack(function(arg0_16)
		if arg0_16 == "action" and arg4_15 then
			arg4_15()
		end

		if arg0_16 == "finish" then
			arg1_15:SetActionCallBack(nil)

			if arg3_15 then
				arg3_15()
			end
		end
	end)
end

function var0_0.dispose(arg0_17)
	return
end

return var0_0
