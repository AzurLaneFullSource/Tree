local var0 = class("XiaotianeSwimsuitSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.rtDayImage = arg0.bg:Find("day_image")
	arg0.rtCharacter = arg0.bg:Find("character")
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.dayTF, i18n("activity_permanent_progress") .. arg0.nday .. "/" .. #arg0.taskGroup)
	GetImageSpriteFromAtlasAsync("ui/activityuipage/xiaotianeswimsuitskinpage_atlas", tostring(arg0.nday), arg0.rtDayImage, true)

	if not arg0.model then
		PoolMgr.GetInstance():GetSpineChar("xiaotiane_2", true, function(arg0)
			if arg0.model then
				return
			end

			arg0.model = arg0
			tf(arg0).localScale = Vector3(1, 1, 1)

			arg0:GetComponent("SpineAnimUI"):SetAction("stand2", 0)
			setParent(arg0, arg0.rtCharacter)
		end)
	end
end

function var0.OnDestroy(arg0)
	if arg0.model then
		PoolMgr.GetInstance():ReturnSpineChar("xiaotiane_2", arg0.model)

		arg0.prefab1 = nil
		arg0.model1 = nil
	end

	var0.super.OnDestroy(arg0)
end

return var0
