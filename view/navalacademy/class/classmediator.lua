local var0 = class("ClassMediator", import("...base.ContextMediator"))

var0.UPGRADE_FIELD = "ClassMediator:UPGRADE_FIELD"

function var0.register(arg0)
	arg0:bind(var0.UPGRADE_FIELD, function(arg0, arg1)
		arg0:sendNotification(GAME.SHOPPING, {
			count = 1,
			id = arg1
		})
	end)

	local var0 = getProxy(NavalAcademyProxy):getCourse()

	arg0.viewComponent:SetCourse(var0)

	local var1 = getProxy(CollectionProxy):getGroups()

	arg0.viewComponent:SetStudents(var1)

	local var2 = getProxy(NavalAcademyProxy):GetClassVO()

	arg0.viewComponent:SetClass(var2)
end

function var0.listNotificationInterests(arg0)
	return {
		NavalAcademyProxy.RESOURCE_UPGRADE_DONE,
		NavalAcademyProxy.RESOURCE_UPGRADE,
		NavalAcademyProxy.COURSE_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == NavalAcademyProxy.RESOURCE_UPGRADE_DONE then
		local var2 = var1.field

		if isa(var2, ClassResourceField) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("main_navalAcademyScene_class_upgrade_complete", pg.navalacademy_data_template[1].name, var1.value, var1.rate, var1.exp))
		end

		arg0.viewComponent:OnUpdateResField(var2)
	elseif var0 == NavalAcademyProxy.RESOURCE_UPGRADE then
		arg0.viewComponent:OnUpdateResField(var1.resVO)
	elseif var0 == NavalAcademyProxy.COURSE_UPDATED then
		local var3 = getProxy(NavalAcademyProxy):getCourse()

		arg0.viewComponent:SetCourse(var3)
		arg0.viewComponent:InitClassInfo()
	end
end

return var0
