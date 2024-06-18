local var0_0 = class("RoyalFortunePage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)

	arg0_1.painting = arg0_1:findTF("painting", arg0_1.bg)
end

function var0_0.OnUpdateFlush(arg0_2)
	var0_0.super.OnUpdateFlush(arg0_2)

	if arg0_2:IsLastTaskFinish() then
		local var0_2 = math.random(#arg0_2.taskGroup)

		GetImageSpriteFromAtlasAsync("ui/activityuipage/royalfortunepage_atlas", var0_2, arg0_2.painting)
	else
		GetImageSpriteFromAtlasAsync("ui/activityuipage/royalfortunepage_atlas", arg0_2.nday, arg0_2.painting)
	end
end

function var0_0.IsLastTaskFinish(arg0_3)
	if arg0_3.nday ~= #arg0_3.taskGroup then
		return false
	end

	local var0_3 = arg0_3.taskGroup[#arg0_3.taskGroup]
	local var1_3 = true

	for iter0_3, iter1_3 in ipairs(var0_3) do
		if arg0_3.taskProxy:getTaskVO(iter1_3):getTaskStatus() ~= 2 then
			var1_3 = false
		end
	end

	return var1_3
end

return var0_0
