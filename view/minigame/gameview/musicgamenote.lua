local var0_0 = class("MusicGameNote")

var0_0.easyTriggerStepTime = nil
var0_0.type_left = 1
var0_0.type_right = 2
var0_0.type_pu_normal = 1
var0_0.type_pu_both = 2
var0_0.type_dgree_easy = 1
var0_0.type_dgree_hard = 2

local var1_0 = 1
local var2_0 = 2
local var3_0 = 3
local var4_0 = 4
local var5_0 = 4
local var6_0 = 0
local var7_0 = 1
local var8_0 = 2
local var9_0 = {
	500,
	800,
	1250,
	1450
}
local var10_0 = {
	0.26,
	0.2,
	0.15,
	0.13
}
local var11_0 = 3
local var12_0
local var13_0 = false

local function var14_0(arg0_1)
	local var0_1 = {
		_tf = arg0_1
	}

	var0_1.type = nil
	var0_1.beginTime = nil
	var0_1.endTime = nil
	var0_1.longFlag = nil
	var0_1.removeTime = nil
	var0_1.speedOffsetX = nil
	var0_1.longTime = 0
	var0_1.triggerDown = nil
	var0_1.triggerUp = nil
	var0_1.fixedScoreType = nil

	function var0_1.Ctor(arg0_2)
		arg0_2.longTf = findTF(arg0_2._tf, "longNote")
		arg0_2.singleTf = findTF(arg0_2._tf, "singleNote")
	end

	function var0_1.stepUpdate(arg0_3, arg1_3)
		if not isActive(arg0_3._tf) then
			arg0_3:changeActive(true)
		end

		local var0_3 = (arg1_3 - arg0_3.beginTime) * arg0_3.speedOffsetX

		if var0_3 > 0 then
			var0_3 = 0
		end

		arg0_3._tf.localPosition = Vector3(var0_3, 0, 0)

		if arg0_3.longFlag then
			local var1_3

			if var0_3 == 0 then
				var1_3 = (arg0_3.endTime - arg1_3) * arg0_3.speedOffsetX

				if not arg0_3.triggerDown and not arg0_3.removeTime then
					arg0_3.removeTime = arg1_3 + var12_0
				end
			else
				var1_3 = (arg0_3.endTime - arg0_3.beginTime) * arg0_3.speedOffsetX
			end

			if var1_3 < 0 then
				var1_3 = 0
			end

			arg0_3.longTf.sizeDelta = Vector2(var1_3, arg0_3.longTf.sizeDelta.y)

			if var1_3 == 0 and not arg0_3.triggerUp and not arg0_3.removeTime then
				arg0_3.removeTime = arg1_3 + var12_0
			end
		elseif var0_3 == 0 and not arg0_3.removeTime then
			arg0_3.removeTime = arg1_3 + var12_0
		end
	end

	function var0_1.setNoteData(arg0_4, arg1_4, arg2_4, arg3_4, arg4_4)
		arg0_4.removeTime = nil
		arg0_4.triggerDown = nil
		arg0_4.triggerUp = nil
		arg0_4.fixedScoreType = nil
		arg0_4.keyType = arg1_4.key_flag == "K_BOTH" and MusicGameNote.type_pu_both or MusicGameNote.type_pu_normal
		arg0_4.beginTime = tonumber(arg1_4.begin_time)
		arg0_4.endTime = tonumber(arg1_4.end_time)
		arg0_4.longTime = arg0_4.endTime - arg0_4.beginTime
		arg0_4.longFlag = arg1_4.begin_time ~= arg1_4.end_time
		arg0_4.speedOffsetX = arg2_4
		arg0_4.dgree = arg3_4
		arg0_4.directType = arg4_4
		arg0_4.imgType = arg0_4:getImageType()
		arg0_4._tf.localPosition = Vector3(0, 0, 0)
		arg0_4._tf.name = "beginTime" .. arg0_4.beginTime

		arg0_4:updateNoteTf()
	end

	function var0_1.updateNoteTf(arg0_5)
		setActive(findTF(arg0_5._tf, "singleNote"), false)
		setActive(findTF(arg0_5._tf, "longNote"), false)

		if arg0_5.longFlag then
			setActive(findTF(arg0_5._tf, "longNote"), true)

			for iter0_5 = 1, var5_0 do
				setActive(findTF(arg0_5._tf, "longNote/note/img" .. iter0_5), iter0_5 == arg0_5.imgType)
				setActive(findTF(arg0_5._tf, "longNote/long/img" .. iter0_5), iter0_5 == arg0_5.imgType)
			end
		else
			setActive(findTF(arg0_5._tf, "singleNote"), true)

			for iter1_5 = 1, var5_0 do
				setActive(findTF(arg0_5._tf, "singleNote/note/img" .. iter1_5), iter1_5 == arg0_5.imgType)
			end
		end
	end

	function var0_1.getImageType(arg0_6)
		if arg0_6.dgree == MusicGameNote.type_dgree_easy then
			return var1_0
		elseif arg0_6.keyType == MusicGameNote.type_pu_both then
			return var4_0
		elseif arg0_6.directType == MusicGameNote.type_left then
			return var2_0
		elseif arg0_6.directType == MusicGameNote.type_right then
			return var3_0
		end

		return var1_0
	end

	function var0_1.getRemoveTime(arg0_7)
		return arg0_7.removeTime
	end

	function var0_1.triggerScore(arg0_8)
		if arg0_8.removeTime then
			arg0_8.removeTime = nil
		end
	end

	function var0_1.changeActive(arg0_9, arg1_9)
		setActive(arg0_9._tf, arg1_9)
	end

	function var0_1.dispose(arg0_10)
		if arg0_10._tf then
			Destroy(arg0_10._tf)
		end
	end

	var0_1:Ctor()

	return var0_1
end

function var0_0.Ctor(arg0_11, arg1_11, arg2_11, arg3_11)
	arg0_11._tf = arg1_11
	arg0_11.noteTpl = arg2_11
	arg0_11.directType = arg3_11
	arg0_11.noteStateCallback = nil
	arg0_11.notePool = {}
	arg0_11.noteList = {}
end

function var0_0.setStateCallback(arg0_12, arg1_12)
	arg0_12.noteStateCallback = arg1_12
end

function var0_0.setLongTimeCallback(arg0_13, arg1_13)
	arg0_13.longNoteCallback = arg1_13
end

function var0_0.setStartData(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14)
	var12_0 = var10_0[arg2_14]
	arg0_14.puList = arg1_14
	arg0_14.speedLevel = arg2_14
	arg0_14.dgree = arg3_14
	arg0_14.noteType = arg4_14
	arg0_14.speedOffsetX = var9_0[arg2_14]
	arg0_14.tplNote = findTF(arg0_14.noteTpl, "tplNote" .. arg4_14)

	if arg0_14.lastNoteType and arg0_14.lastNoteType ~= arg4_14 then
		arg0_14:destroyNoteAll()
	else
		arg0_14:clearNote()
	end

	arg0_14.lastNoteType = arg0_14.noteType
end

function var0_0.step(arg0_15, arg1_15)
	arg0_15.stepTime = arg1_15 / 1000

	if #arg0_15.noteList > 0 then
		local var0_15 = arg0_15.noteList[1]
		local var1_15 = arg0_15:checkScoreType(var0_15)

		if var1_15 then
			var0_15:triggerScore()
			arg0_15.noteStateCallback(var1_15)

			if not var0_15.longFlag or var1_15 == var6_0 then
				arg0_15:returnNote(table.remove(arg0_15.noteList, 1))
			elseif var0_15.longFlag and var0_15.triggerUp then
				arg0_15:returnNote(table.remove(arg0_15.noteList, 1))

				if arg0_15.longNoteCallback then
					arg0_15.longNoteCallback(var0_15.longTime)
				end
			end
		end
	end

	for iter0_15 = #arg0_15.noteList, 1, -1 do
		local var2_15 = arg0_15.noteList[iter0_15].fixedScoreType

		if var2_15 and arg0_15.noteStateCallback then
			arg0_15.noteStateCallback(var2_15)

			if arg0_15.loopFlag then
				arg0_15.loopFlag = false
			end

			arg0_15:returnNote(table.remove(arg0_15.noteList, iter0_15))
		end
	end

	for iter1_15 = #arg0_15.noteList, 1, -1 do
		local var3_15 = arg0_15.noteList[iter1_15]
		local var4_15 = var3_15.longFlag
		local var5_15 = var3_15.triggerDown
		local var6_15 = arg0_15.noteList[iter1_15]:getRemoveTime()

		if var6_15 and var6_15 < arg0_15.stepTime then
			if arg0_15.noteStateCallback then
				if not var13_0 then
					arg0_15.noteStateCallback(var6_0)
				else
					arg0_15.noteStateCallback(var8_0)
				end
			end

			if arg0_15.loopFlag then
				arg0_15.loopFlag = false
			end

			arg0_15:returnNote(table.remove(arg0_15.noteList, iter1_15))
		end
	end

	for iter2_15 = #arg0_15.noteList, 1, -1 do
		arg0_15.noteList[iter2_15]:stepUpdate(arg0_15.stepTime)
	end

	if arg0_15.puList and #arg0_15.puList > 0 then
		local var7_15 = arg0_15.puList[1]

		if arg0_15:checkPuShow(var7_15) then
			arg0_15:pushNoteToList(arg0_15:getNote(var7_15))
			table.remove(arg0_15.puList, 1)
		end
	end
end

function var0_0.checkScoreType(arg0_16, arg1_16)
	if arg0_16.dgree == MusicGameNote.type_dgree_easy and arg0_16.keyDownStepTime and arg0_16.keyDownStepTime and arg0_16.keyDownStepTime == MusicGameNote.easyTriggerStepTime then
		arg0_16.keyDownTrigger = true
	end

	local var0_16
	local var1_16
	local var2_16 = false

	if not arg1_16.longFlag then
		local var3_16 = arg1_16.beginTime

		if arg0_16.keyDownStepTime and not arg0_16.keyDownTrigger then
			local var4_16 = math.abs(arg0_16.keyDownStepTime - var3_16)

			if arg1_16.keyType == MusicGameNote.type_pu_both then
				if arg0_16.keyBothDown then
					var0_16 = arg0_16:getScoreType(var4_16)
				end
			else
				var0_16 = arg0_16:getScoreType(var4_16)
			end

			if var0_16 then
				arg1_16.triggerDown = true
				arg0_16.keyDownTrigger = true

				if arg0_16.dgree == MusicGameNote.type_dgree_easy then
					MusicGameNote.easyTriggerStepTime = arg0_16.keyDownStepTime
				end
			end
		end
	elseif not arg1_16.triggerDown then
		local var5_16 = arg1_16.beginTime

		if arg0_16.keyDownStepTime and not arg0_16.keyDownTrigger then
			local var6_16 = math.abs(arg0_16.keyDownStepTime - var5_16)

			if arg1_16.keyType == MusicGameNote.type_pu_both then
				if arg0_16.keyBothDown then
					var0_16 = arg0_16:getScoreType(var6_16)
				end
			else
				var0_16 = arg0_16:getScoreType(var6_16)
			end

			if var0_16 then
				arg1_16.triggerDown = true
				arg0_16.keyDownTrigger = true
				arg0_16.loopFlag = true
			end
		end
	else
		local var7_16 = arg1_16.endTime
		local var8_16 = arg0_16.stepTime < var7_16 - var12_0

		if not arg0_16.keyDown and var8_16 then
			if arg0_16.loopFlag then
				arg0_16.loopFlag = false
			end

			arg1_16.fixedScoreType, arg1_16.endTime = arg0_16:getScoreType(math.abs(arg0_16.stepTime - arg1_16.endTime)) or var7_0, arg1_16.beginTime
			var0_16 = nil
		elseif arg0_16.keyUpStepTime and not arg0_16.keyUpTrigger then
			local var9_16 = math.abs(arg0_16.keyUpStepTime - var7_16)

			if arg1_16.keyType == MusicGameNote.type_pu_both then
				if arg0_16.keyBothUp then
					var0_16 = arg0_16:getScoreType(var9_16)
				end
			else
				var0_16 = arg0_16:getScoreType(var9_16)
			end

			if var0_16 then
				if arg0_16.loopFlag then
					arg0_16.loopFlag = false
				end

				arg1_16.triggerUp = true
				arg0_16.keyUpTrigger = true
			end
		end
	end

	return var0_16
end

function var0_0.loopTime(arg0_17)
	return arg0_17.loopFlag
end

function var0_0.getScoreType(arg0_18, arg1_18)
	if arg1_18 < var12_0 / 2 then
		return var8_0
	elseif arg1_18 < var12_0 then
		return var7_0
	end

	return nil
end

function var0_0.pushNoteToList(arg0_19, arg1_19)
	table.insert(arg0_19.noteList, arg1_19)
end

function var0_0.checkPuShow(arg0_20, arg1_20)
	if arg1_20.begin_time - arg0_20.stepTime <= var11_0 then
		return true
	end

	return false
end

function var0_0.destroyNoteAll(arg0_21)
	for iter0_21 = #arg0_21.noteList, 1, -1 do
		arg0_21.noteList[iter0_21]:dispose()
	end

	for iter1_21 = #arg0_21.notePool, 1, -1 do
		arg0_21.notePool[iter1_21]:dispose()
	end

	arg0_21.noteList = {}
	arg0_21.notePool = {}
end

function var0_0.clearNote(arg0_22)
	for iter0_22 = #arg0_22.noteList, 1, -1 do
		local var0_22 = table.remove(arg0_22.noteList, iter0_22)

		arg0_22:returnNote(var0_22)
	end
end

function var0_0.getNote(arg0_23, arg1_23)
	if #arg0_23.notePool == 0 then
		local var0_23 = arg0_23:createNote()

		table.insert(arg0_23.notePool, var0_23)
	end

	local var1_23 = table.remove(arg0_23.notePool, 1)

	var1_23:setNoteData(arg1_23, arg0_23.speedOffsetX, arg0_23.dgree, arg0_23.directType)

	return var1_23
end

function var0_0.returnNote(arg0_24, arg1_24)
	arg1_24:changeActive(false)
	table.insert(arg0_24.notePool, arg1_24)
end

function var0_0.createNote(arg0_25)
	local var0_25 = tf(instantiate(arg0_25.tplNote))

	setActive(var0_25, false)

	local var1_25 = var14_0(var0_25)

	setParent(var0_25, arg0_25._tf)

	return var14_0(var0_25)
end

function var0_0.onKeyDown(arg0_26)
	arg0_26.keyDown = true
	arg0_26.keyUp = false
	arg0_26.keyDownStepTime = arg0_26.stepTime
	arg0_26.keyDownTrigger = false
	arg0_26.keyBothDown = false
end

function var0_0.onKeyUp(arg0_27)
	arg0_27.keyUp = true
	arg0_27.keyDown = false
	arg0_27.keyUpStepTime = arg0_27.stepTime
	arg0_27.keyUpTrigger = false
	arg0_27.keyBothUp = false
end

function var0_0.bothDown(arg0_28)
	arg0_28.keyDownStepTime = arg0_28.stepTime
	arg0_28.keyBothDown = true
	arg0_28.keyBothUp = false
end

function var0_0.bothUp(arg0_29)
	arg0_29.keyBothUp = true
	arg0_29.keyBothDown = false
	arg0_29.keyUpStepTime = arg0_29.stepTime
end

return var0_0
