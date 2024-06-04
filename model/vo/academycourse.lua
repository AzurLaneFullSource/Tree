local var0 = class("AcademyCourse", import(".BaseVO"))

var0.MaxStudyTime = 43200

function var0.Ctor(arg0)
	arg0.proficiency = 0
end

function var0.bindConfigTable(arg0)
	return pg.class_upgrade_group
end

function var0.getConfig(arg0, arg1)
	local var0 = pg.TimeMgr.GetInstance():GetServerWeek()

	return arg0:bindConfigTable()[var0][arg1]
end

function var0.update(arg0, arg1)
	arg0.proficiency = arg1.proficiency
end

function var0.GetProficiency(arg0)
	return arg0.proficiency
end

function var0.getExtraRate(arg0)
	return pg.TimeMgr.GetInstance():GetServerWeek() == 7 and 2 or 1
end

function var0.SetProficiency(arg0, arg1)
	arg0.proficiency = arg1
end

return var0
