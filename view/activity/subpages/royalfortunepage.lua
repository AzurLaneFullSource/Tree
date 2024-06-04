local var0 = class("RoyalFortunePage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnInit(arg0)
	var0.super.OnInit(arg0)

	arg0.painting = arg0:findTF("painting", arg0.bg)
end

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	if arg0:IsLastTaskFinish() then
		local var0 = math.random(#arg0.taskGroup)

		GetImageSpriteFromAtlasAsync("ui/activityuipage/royalfortunepage_atlas", var0, arg0.painting)
	else
		GetImageSpriteFromAtlasAsync("ui/activityuipage/royalfortunepage_atlas", arg0.nday, arg0.painting)
	end
end

function var0.IsLastTaskFinish(arg0)
	if arg0.nday ~= #arg0.taskGroup then
		return false
	end

	local var0 = arg0.taskGroup[#arg0.taskGroup]
	local var1 = true

	for iter0, iter1 in ipairs(var0) do
		if arg0.taskProxy:getTaskVO(iter1):getTaskStatus() ~= 2 then
			var1 = false
		end
	end

	return var1
end

return var0
