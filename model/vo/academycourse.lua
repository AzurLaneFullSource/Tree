local var0_0 = class("AcademyCourse", import(".BaseVO"))

var0_0.MaxStudyTime = 43200

function var0_0.Ctor(arg0_1)
	arg0_1.proficiency = 0
end

function var0_0.bindConfigTable(arg0_2)
	return pg.class_upgrade_group
end

function var0_0.getConfig(arg0_3, arg1_3)
	local var0_3 = pg.TimeMgr.GetInstance():GetServerWeek()

	return arg0_3:bindConfigTable()[var0_3][arg1_3]
end

function var0_0.update(arg0_4, arg1_4)
	arg0_4.proficiency = arg1_4.proficiency
end

function var0_0.GetProficiency(arg0_5)
	return arg0_5.proficiency
end

function var0_0.getExtraRate(arg0_6)
	return pg.TimeMgr.GetInstance():GetServerWeek() == 7 and 2 or 1
end

function var0_0.SetProficiency(arg0_7, arg1_7)
	arg0_7.proficiency = arg1_7
end

return var0_0
