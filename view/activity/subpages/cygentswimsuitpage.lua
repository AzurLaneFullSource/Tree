local var0_0 = class("CygentSwimsuitPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)
	PoolMgr.GetInstance():GetSpineChar("xiaotiane_2", false, function(arg0_2)
		arg0_2.transform.localScale = Vector3(0.7, 0.7, 1)

		arg0_2.transform:SetParent(arg0_1:findTF("char", arg0_1.bg), false)
		arg0_2:GetComponent(typeof(SpineAnimUI)):SetAction("stand", 0)

		arg0_1.model = arg0_2
	end)
end

function var0_0.OnUpdateFlush(arg0_3)
	var0_0.super.OnUpdateFlush(arg0_3)
	GetImageSpriteFromAtlasAsync("numbericon/t1/" .. arg0_3.nday, "", arg0_3:findTF("day1", arg0_3.bg))
	setText(arg0_3:findTF("progress", arg0_3.bg), "進度:" .. arg0_3.nday .. "/10")
end

function var0_0.OnDestroy(arg0_4)
	var0_0.super.OnDestroy(arg0_4)

	if arg0_4.model then
		arg0_4.model.transform.localScale = Vector3.one

		PoolMgr.GetInstance():ReturnSpineChar("xiaotiane_2", arg0_4.model)

		arg0_4.model = nil
	end
end

return var0_0
