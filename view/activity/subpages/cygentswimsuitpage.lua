local var0 = class("CygentSwimsuitPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	PoolMgr.GetInstance():GetSpineChar("xiaotiane_2", false, function(arg0)
		arg0.transform.localScale = Vector3(0.7, 0.7, 1)

		arg0.transform:SetParent(arg0:findTF("char", arg0.bg), false)
		arg0:GetComponent(typeof(SpineAnimUI)):SetAction("stand", 0)

		arg0.model = arg0
	end)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	GetImageSpriteFromAtlasAsync("numbericon/t1/" .. arg0.nday, "", arg0:findTF("day1", arg0.bg))
	setText(arg0:findTF("progress", arg0.bg), "進度:" .. arg0.nday .. "/10")
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)

	if arg0.model then
		arg0.model.transform.localScale = Vector3.one

		PoolMgr.GetInstance():ReturnSpineChar("xiaotiane_2", arg0.model)

		arg0.model = nil
	end
end

return var0
