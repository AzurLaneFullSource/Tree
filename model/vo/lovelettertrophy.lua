local var0_0 = class("LoveLetterTrophy", import(".Trophy"))

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg1_1.id
	arg0_1.level = arg0_1.id % 100
	arg0_1.groupId = math.floor(arg0_1.id % 1000000000 / 100)
	arg0_1.ll = getProxy(LoveLetterProxy):GetGroupData(arg0_1.groupId)
	arg0_1.oll = setmetatable({
		level = arg0_1.level
	}, {
		__index = arg0_1.ll
	})
	arg0_1.isMax = arg0_1.level + 10 > arg0_1.ll:GetMaxLevel()
	arg0_1.groupName = arg0_1.ll:GetName()
	arg0_1.paint = arg0_1.ll:GetPainting()
	arg0_1.subTrophyList = {}

	arg0_1:update(arg1_1)
end

function var0_0.getConfigTable(arg0_2)
	if not arg0_2.configTable then
		arg0_2.configTable = {
			next = not arg0_2.isMax and arg0_2.id + 10 or nil
		}
	end

	return arg0_2.configTable
end

function var0_0.update(arg0_3, arg1_3)
	arg0_3.timestamp = 1
end

function var0_0.isComplexTrophy(arg0_4)
	return false
end

function var0_0.getTargetID(arg0_5)
	return arg0_5:getConfig("target_id")
end

function var0_0.getHideType(arg0_6)
	return arg0_6:getConfig("hide")
end

function var0_0.isHide(arg0_7)
	return false
end

function var0_0.isMaxLevel(arg0_8)
	return arg0_8.isMax
end

function var0_0.getName(arg0_9)
	return i18n("loveactivity_ui_14", arg0_9.groupName)
end

function var0_0.GetPrefabName(arg0_10)
	return arg0_10.oll:GetPrefabName()
end

function var0_0.GetPainting(arg0_11)
	return arg0_11.paint
end

function var0_0.GetDisplayLevelMark(arg0_12)
	return arg0_12.oll:GetDisplayLevelMark()
end

return var0_0
