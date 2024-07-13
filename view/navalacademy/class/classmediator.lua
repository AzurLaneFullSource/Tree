local var0_0 = class("ClassMediator", import("...base.ContextMediator"))

var0_0.UPGRADE_FIELD = "ClassMediator:UPGRADE_FIELD"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.UPGRADE_FIELD, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.SHOPPING, {
			count = 1,
			id = arg1_2
		})
	end)

	local var0_1 = getProxy(NavalAcademyProxy):getCourse()

	arg0_1.viewComponent:SetCourse(var0_1)

	local var1_1 = getProxy(CollectionProxy):getGroups()

	arg0_1.viewComponent:SetStudents(var1_1)

	local var2_1 = getProxy(NavalAcademyProxy):GetClassVO()

	arg0_1.viewComponent:SetClass(var2_1)
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		NavalAcademyProxy.RESOURCE_UPGRADE_DONE,
		NavalAcademyProxy.RESOURCE_UPGRADE,
		NavalAcademyProxy.COURSE_UPDATED
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == NavalAcademyProxy.RESOURCE_UPGRADE_DONE then
		local var2_4 = var1_4.field

		if isa(var2_4, ClassResourceField) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("main_navalAcademyScene_class_upgrade_complete", pg.navalacademy_data_template[1].name, var1_4.value, var1_4.rate, var1_4.exp))
		end

		arg0_4.viewComponent:OnUpdateResField(var2_4)
	elseif var0_4 == NavalAcademyProxy.RESOURCE_UPGRADE then
		arg0_4.viewComponent:OnUpdateResField(var1_4.resVO)
	elseif var0_4 == NavalAcademyProxy.COURSE_UPDATED then
		local var3_4 = getProxy(NavalAcademyProxy):getCourse()

		arg0_4.viewComponent:SetCourse(var3_4)
		arg0_4.viewComponent:InitClassInfo()
	end
end

return var0_0
