local var0 = class("MusicGameNote")

var0.easyTriggerStepTime = nil
var0.type_left = 1
var0.type_right = 2
var0.type_pu_normal = 1
var0.type_pu_both = 2
var0.type_dgree_easy = 1
var0.type_dgree_hard = 2

local var1 = 1
local var2 = 2
local var3 = 3
local var4 = 4
local var5 = 4
local var6 = 0
local var7 = 1
local var8 = 2
local var9 = {
	500,
	800,
	1250,
	1450
}
local var10 = {
	0.26,
	0.2,
	0.15,
	0.13
}
local var11 = 3
local var12
local var13 = false

local function var14(arg0)
	local var0 = {
		_tf = arg0
	}

	var0.type = nil
	var0.beginTime = nil
	var0.endTime = nil
	var0.longFlag = nil
	var0.removeTime = nil
	var0.speedOffsetX = nil
	var0.longTime = 0
	var0.triggerDown = nil
	var0.triggerUp = nil
	var0.fixedScoreType = nil

	function var0.Ctor(arg0)
		arg0.longTf = findTF(arg0._tf, "longNote")
		arg0.singleTf = findTF(arg0._tf, "singleNote")
	end

	function var0.stepUpdate(arg0, arg1)
		if not isActive(arg0._tf) then
			arg0:changeActive(true)
		end

		local var0 = (arg1 - arg0.beginTime) * arg0.speedOffsetX

		if var0 > 0 then
			var0 = 0
		end

		arg0._tf.localPosition = Vector3(var0, 0, 0)

		if arg0.longFlag then
			local var1

			if var0 == 0 then
				var1 = (arg0.endTime - arg1) * arg0.speedOffsetX

				if not arg0.triggerDown and not arg0.removeTime then
					arg0.removeTime = arg1 + var12
				end
			else
				var1 = (arg0.endTime - arg0.beginTime) * arg0.speedOffsetX
			end

			if var1 < 0 then
				var1 = 0
			end

			arg0.longTf.sizeDelta = Vector2(var1, arg0.longTf.sizeDelta.y)

			if var1 == 0 and not arg0.triggerUp and not arg0.removeTime then
				arg0.removeTime = arg1 + var12
			end
		elseif var0 == 0 and not arg0.removeTime then
			arg0.removeTime = arg1 + var12
		end
	end

	function var0.setNoteData(arg0, arg1, arg2, arg3, arg4)
		arg0.removeTime = nil
		arg0.triggerDown = nil
		arg0.triggerUp = nil
		arg0.fixedScoreType = nil
		arg0.keyType = arg1.key_flag == "K_BOTH" and MusicGameNote.type_pu_both or MusicGameNote.type_pu_normal
		arg0.beginTime = tonumber(arg1.begin_time)
		arg0.endTime = tonumber(arg1.end_time)
		arg0.longTime = arg0.endTime - arg0.beginTime
		arg0.longFlag = arg1.begin_time ~= arg1.end_time
		arg0.speedOffsetX = arg2
		arg0.dgree = arg3
		arg0.directType = arg4
		arg0.imgType = arg0:getImageType()
		arg0._tf.localPosition = Vector3(0, 0, 0)
		arg0._tf.name = "beginTime" .. arg0.beginTime

		arg0:updateNoteTf()
	end

	function var0.updateNoteTf(arg0)
		setActive(findTF(arg0._tf, "singleNote"), false)
		setActive(findTF(arg0._tf, "longNote"), false)

		if arg0.longFlag then
			setActive(findTF(arg0._tf, "longNote"), true)

			for iter0 = 1, var5 do
				setActive(findTF(arg0._tf, "longNote/note/img" .. iter0), iter0 == arg0.imgType)
				setActive(findTF(arg0._tf, "longNote/long/img" .. iter0), iter0 == arg0.imgType)
			end
		else
			setActive(findTF(arg0._tf, "singleNote"), true)

			for iter1 = 1, var5 do
				setActive(findTF(arg0._tf, "singleNote/note/img" .. iter1), iter1 == arg0.imgType)
			end
		end
	end

	function var0.getImageType(arg0)
		if arg0.dgree == MusicGameNote.type_dgree_easy then
			return var1
		elseif arg0.keyType == MusicGameNote.type_pu_both then
			return var4
		elseif arg0.directType == MusicGameNote.type_left then
			return var2
		elseif arg0.directType == MusicGameNote.type_right then
			return var3
		end

		return var1
	end

	function var0.getRemoveTime(arg0)
		return arg0.removeTime
	end

	function var0.triggerScore(arg0)
		if arg0.removeTime then
			arg0.removeTime = nil
		end
	end

	function var0.changeActive(arg0, arg1)
		setActive(arg0._tf, arg1)
	end

	function var0.dispose(arg0)
		if arg0._tf then
			Destroy(arg0._tf)
		end
	end

	var0:Ctor()

	return var0
end

function var0.Ctor(arg0, arg1, arg2, arg3)
	arg0._tf = arg1
	arg0.noteTpl = arg2
	arg0.directType = arg3
	arg0.noteStateCallback = nil
	arg0.notePool = {}
	arg0.noteList = {}
end

function var0.setStateCallback(arg0, arg1)
	arg0.noteStateCallback = arg1
end

function var0.setLongTimeCallback(arg0, arg1)
	arg0.longNoteCallback = arg1
end

function var0.setStartData(arg0, arg1, arg2, arg3, arg4)
	var12 = var10[arg2]
	arg0.puList = arg1
	arg0.speedLevel = arg2
	arg0.dgree = arg3
	arg0.noteType = arg4
	arg0.speedOffsetX = var9[arg2]
	arg0.tplNote = findTF(arg0.noteTpl, "tplNote" .. arg4)

	if arg0.lastNoteType and arg0.lastNoteType ~= arg4 then
		arg0:destroyNoteAll()
	else
		arg0:clearNote()
	end

	arg0.lastNoteType = arg0.noteType
end

function var0.step(arg0, arg1)
	arg0.stepTime = arg1 / 1000

	if #arg0.noteList > 0 then
		local var0 = arg0.noteList[1]
		local var1 = arg0:checkScoreType(var0)

		if var1 then
			var0:triggerScore()
			arg0.noteStateCallback(var1)

			if not var0.longFlag or var1 == var6 then
				arg0:returnNote(table.remove(arg0.noteList, 1))
			elseif var0.longFlag and var0.triggerUp then
				arg0:returnNote(table.remove(arg0.noteList, 1))

				if arg0.longNoteCallback then
					arg0.longNoteCallback(var0.longTime)
				end
			end
		end
	end

	for iter0 = #arg0.noteList, 1, -1 do
		local var2 = arg0.noteList[iter0].fixedScoreType

		if var2 and arg0.noteStateCallback then
			arg0.noteStateCallback(var2)

			if arg0.loopFlag then
				arg0.loopFlag = false
			end

			arg0:returnNote(table.remove(arg0.noteList, iter0))
		end
	end

	for iter1 = #arg0.noteList, 1, -1 do
		local var3 = arg0.noteList[iter1]
		local var4 = var3.longFlag
		local var5 = var3.triggerDown
		local var6 = arg0.noteList[iter1]:getRemoveTime()

		if var6 and var6 < arg0.stepTime then
			if arg0.noteStateCallback then
				if not var13 then
					arg0.noteStateCallback(var6)
				else
					arg0.noteStateCallback(var8)
				end
			end

			if arg0.loopFlag then
				arg0.loopFlag = false
			end

			arg0:returnNote(table.remove(arg0.noteList, iter1))
		end
	end

	for iter2 = #arg0.noteList, 1, -1 do
		arg0.noteList[iter2]:stepUpdate(arg0.stepTime)
	end

	if arg0.puList and #arg0.puList > 0 then
		local var7 = arg0.puList[1]

		if arg0:checkPuShow(var7) then
			arg0:pushNoteToList(arg0:getNote(var7))
			table.remove(arg0.puList, 1)
		end
	end
end

function var0.checkScoreType(arg0, arg1)
	if arg0.dgree == MusicGameNote.type_dgree_easy and arg0.keyDownStepTime and arg0.keyDownStepTime and arg0.keyDownStepTime == MusicGameNote.easyTriggerStepTime then
		arg0.keyDownTrigger = true
	end

	local var0
	local var1
	local var2 = false

	if not arg1.longFlag then
		local var3 = arg1.beginTime

		if arg0.keyDownStepTime and not arg0.keyDownTrigger then
			local var4 = math.abs(arg0.keyDownStepTime - var3)

			if arg1.keyType == MusicGameNote.type_pu_both then
				if arg0.keyBothDown then
					var0 = arg0:getScoreType(var4)
				end
			else
				var0 = arg0:getScoreType(var4)
			end

			if var0 then
				arg1.triggerDown = true
				arg0.keyDownTrigger = true

				if arg0.dgree == MusicGameNote.type_dgree_easy then
					MusicGameNote.easyTriggerStepTime = arg0.keyDownStepTime
				end
			end
		end
	elseif not arg1.triggerDown then
		local var5 = arg1.beginTime

		if arg0.keyDownStepTime and not arg0.keyDownTrigger then
			local var6 = math.abs(arg0.keyDownStepTime - var5)

			if arg1.keyType == MusicGameNote.type_pu_both then
				if arg0.keyBothDown then
					var0 = arg0:getScoreType(var6)
				end
			else
				var0 = arg0:getScoreType(var6)
			end

			if var0 then
				arg1.triggerDown = true
				arg0.keyDownTrigger = true
				arg0.loopFlag = true
			end
		end
	else
		local var7 = arg1.endTime
		local var8 = arg0.stepTime < var7 - var12

		if not arg0.keyDown and var8 then
			if arg0.loopFlag then
				arg0.loopFlag = false
			end

			arg1.fixedScoreType, arg1.endTime = arg0:getScoreType(math.abs(arg0.stepTime - arg1.endTime)) or var7, arg1.beginTime
			var0 = nil
		elseif arg0.keyUpStepTime and not arg0.keyUpTrigger then
			local var9 = math.abs(arg0.keyUpStepTime - var7)

			if arg1.keyType == MusicGameNote.type_pu_both then
				if arg0.keyBothUp then
					var0 = arg0:getScoreType(var9)
				end
			else
				var0 = arg0:getScoreType(var9)
			end

			if var0 then
				if arg0.loopFlag then
					arg0.loopFlag = false
				end

				arg1.triggerUp = true
				arg0.keyUpTrigger = true
			end
		end
	end

	return var0
end

function var0.loopTime(arg0)
	return arg0.loopFlag
end

function var0.getScoreType(arg0, arg1)
	if arg1 < var12 / 2 then
		return var8
	elseif arg1 < var12 then
		return var7
	end

	return nil
end

function var0.pushNoteToList(arg0, arg1)
	table.insert(arg0.noteList, arg1)
end

function var0.checkPuShow(arg0, arg1)
	if arg1.begin_time - arg0.stepTime <= var11 then
		return true
	end

	return false
end

function var0.destroyNoteAll(arg0)
	for iter0 = #arg0.noteList, 1, -1 do
		arg0.noteList[iter0]:dispose()
	end

	for iter1 = #arg0.notePool, 1, -1 do
		arg0.notePool[iter1]:dispose()
	end

	arg0.noteList = {}
	arg0.notePool = {}
end

function var0.clearNote(arg0)
	for iter0 = #arg0.noteList, 1, -1 do
		local var0 = table.remove(arg0.noteList, iter0)

		arg0:returnNote(var0)
	end
end

function var0.getNote(arg0, arg1)
	if #arg0.notePool == 0 then
		local var0 = arg0:createNote()

		table.insert(arg0.notePool, var0)
	end

	local var1 = table.remove(arg0.notePool, 1)

	var1:setNoteData(arg1, arg0.speedOffsetX, arg0.dgree, arg0.directType)

	return var1
end

function var0.returnNote(arg0, arg1)
	arg1:changeActive(false)
	table.insert(arg0.notePool, arg1)
end

function var0.createNote(arg0)
	local var0 = tf(instantiate(arg0.tplNote))

	setActive(var0, false)

	local var1 = var14(var0)

	setParent(var0, arg0._tf)

	return var14(var0)
end

function var0.onKeyDown(arg0)
	arg0.keyDown = true
	arg0.keyUp = false
	arg0.keyDownStepTime = arg0.stepTime
	arg0.keyDownTrigger = false
	arg0.keyBothDown = false
end

function var0.onKeyUp(arg0)
	arg0.keyUp = true
	arg0.keyDown = false
	arg0.keyUpStepTime = arg0.stepTime
	arg0.keyUpTrigger = false
	arg0.keyBothUp = false
end

function var0.bothDown(arg0)
	arg0.keyDownStepTime = arg0.stepTime
	arg0.keyBothDown = true
	arg0.keyBothUp = false
end

function var0.bothUp(arg0)
	arg0.keyBothUp = true
	arg0.keyBothDown = false
	arg0.keyUpStepTime = arg0.stepTime
end

return var0
