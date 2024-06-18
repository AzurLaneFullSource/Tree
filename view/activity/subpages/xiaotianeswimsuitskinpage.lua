local var0_0 = class("XiaotianeSwimsuitSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.rtDayImage = arg0_1.bg:Find("day_image")
	arg0_1.rtCharacter = arg0_1.bg:Find("character")
end

function var0_0.OnUpdateFlush(arg0_2)
	var0_0.super.OnUpdateFlush(arg0_2)
	setText(arg0_2.dayTF, i18n("activity_permanent_progress") .. arg0_2.nday .. "/" .. #arg0_2.taskGroup)
	GetImageSpriteFromAtlasAsync("ui/activityuipage/xiaotianeswimsuitskinpage_atlas", tostring(arg0_2.nday), arg0_2.rtDayImage, true)

	if not arg0_2.model then
		PoolMgr.GetInstance():GetSpineChar("xiaotiane_2", true, function(arg0_3)
			if arg0_2.model then
				return
			end

			arg0_2.model = arg0_3
			tf(arg0_3).localScale = Vector3(1, 1, 1)

			arg0_3:GetComponent("SpineAnimUI"):SetAction("stand2", 0)
			setParent(arg0_3, arg0_2.rtCharacter)
		end)
	end
end

function var0_0.OnDestroy(arg0_4)
	if arg0_4.model then
		PoolMgr.GetInstance():ReturnSpineChar("xiaotiane_2", arg0_4.model)

		arg0_4.prefab1 = nil
		arg0_4.model1 = nil
	end

	var0_0.super.OnDestroy(arg0_4)
end

return var0_0
